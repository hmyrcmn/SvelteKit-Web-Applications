import os
import json
from datetime import datetime
from gtts import gTTS
from playsound import playsound
import numpy as np
import torch
import torchaudio
import sounddevice as sd
from transformers import AutoProcessor, AutoModelForSpeechSeq2Seq
import config

# Whisper modelini yükle
processor = AutoProcessor.from_pretrained("emre/whisper-medium-turkish-2")
model = AutoModelForSpeechSeq2Seq.from_pretrained("emre/whisper-medium-turkish-2")
model = model.to("cuda" if torch.cuda.is_available() else "cpu")

def speak(text, filename="response.mp3"):
    tts = gTTS(text=text, lang=config.LANGUAGE)
    tts.save(filename)
    playsound(filename)
    os.remove(filename)

def record_audio_array(duration=2, fs=16000):
    print(f"{duration} sn dinleniyor...")
    recording = sd.rec(int(duration * fs), samplerate=fs, channels=1, dtype='int16')
    sd.wait()
    return recording.squeeze(), fs

def transcribe(audio_array, fs):
    if audio_array is None or audio_array.size == 0 or np.all(audio_array == 0):
        print("Boş veya sessiz kayıt, atlanıyor.")
        return ""
    if fs != 16000:
        waveform = torchaudio.functional.resample(torch.tensor(audio_array, dtype=torch.float32), fs, 16000).numpy()
    else:
        waveform = audio_array.astype(np.float32)
    # Whisper'ın beklediği min uzunluk: 30.000 örnek (2 sn @ 16kHz)
    if waveform.shape[0] < 30000:
        print("Kayıt çok kısa, atlanıyor.")
        return ""
    try:
        inputs = processor(waveform, sampling_rate=16000, return_tensors="pt")
        input_features = inputs.input_features.to(model.device)
        if any(dim == 0 for dim in input_features.shape):
            print("input_features boş, atlanıyor.")
            return ""
        with torch.no_grad():
            generated_ids = model.generate(input_features=input_features)
        transcription = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
        return transcription.strip()
    except Exception as e:
        print(f"Whisper transkripsiyon hatası: {e}")
        return ""

def listen_for_wake_word():
    print(f"'{config.WAKE_WORD}' bekleniyor...")
    sessiz_sayac = 0
    sessiz_limit = 10  # 10 x 10 sn = 100 sn
    while True:
        audio_array, fs = record_audio_array(duration=10)
        if np.all(audio_array == 0):
            sessiz_sayac += 1
            if sessiz_sayac >= sessiz_limit:
                print("100 saniye boyunca hiç ses algılanmadı. Program kapatılıyor.")
                exit()
            continue
        else:
            sessiz_sayac = 0
        text = transcribe(audio_array, fs)
        print(f"Algılanan: {text}")
        # 10 sn'lik kayıttan hemen sonra algılanan metni yazdır
        print(f"[10 sn kayıt sonrası] Algılanan metin: {text}")
        if config.WAKE_WORD in text.lower():
            print("Tetikleyici algılandı!")
            return True
        # Tetikleyici gelmezse döngü başa döner ve tekrar 10 sn dinler

def listen_for_command():
    print("Komutunuzu dinliyorum...")
    audio_array, fs = record_audio_array(duration=5)
    if np.all(audio_array == 0):
        print("Sessiz komut kaydı algılandı.")
        return ""
    text = transcribe(audio_array, fs)
    print(f"Algılanan komut: {text}")
    return text.lower()

def initialize_json():
    if not os.path.exists(config.JSON_PATH):
        with open(config.JSON_PATH, "w", encoding="utf-8") as f:
            json.dump([], f, ensure_ascii=False, indent=2)

def process_command(command):
    if not command:
        speak("Komut anlaşılamadı. Lütfen tekrar söyleyin.")
        return False
    now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    new_row = {"komut": command, "tarih": now}
    try:
        if os.path.exists(config.JSON_PATH):
            with open(config.JSON_PATH, "r", encoding="utf-8") as f:
                data = json.load(f)
        else:
            data = []
        data.append(new_row)
        with open(config.JSON_PATH, "w", encoding="utf-8") as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
        speak(f"Komut kaydedildi: {command}")
        return True
    except Exception as e:
        print(f"Komut işleme hatası: {e}")
        speak("Komut işlenirken hata oluştu")
        return False

if __name__ == "__main__":
    initialize_json()
    while True:
        if listen_for_wake_word():
            speak(config.RESPONSE_TEXT)
            command_success = False
            while not command_success:
                command = listen_for_command()
                command_success = process_command(command)