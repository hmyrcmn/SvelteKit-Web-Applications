# 1. Gerekli kütüphaneler
import sounddevice as sd
import soundfile as sf
from gtts import gTTS
from playsound import playsound
import numpy as np
import torchaudio
import torch
from datetime import datetime
from transformers import AutoProcessor, AutoModelForSpeechSeq2Seq
import os
import hashlib

# 2. Whisper modelini yükle
processor = AutoProcessor.from_pretrained("emre/whisper-medium-turkish-2")
model = AutoModelForSpeechSeq2Seq.from_pretrained("emre/whisper-medium-turkish-2")
model = model.to("cuda" if torch.cuda.is_available() else "cpu")

# 3. Sesli yanıt için yardımcı fonksiyon
def speak(text, filename="response.mp3"):
    tts = gTTS(text=text, lang='tr')
    tts.save(filename)
    playsound(filename)
    os.remove(filename)

# 4. Mikrofon kaydı fonksiyonu (artık dosya yerine numpy array döner)
def record_audio_array(duration=2, fs=16000):
    # print(f"\n🎙️ {duration} saniye boyunca konuşun...")  # Sessizleştirildi
    recording = sd.rec(int(duration * fs), samplerate=fs, channels=1, dtype='int16')
    sd.wait()
    return recording.squeeze(), fs

def get_audio_hash(audio_array):
    return hashlib.sha256(audio_array.tobytes()).hexdigest()

# 5. Komutları işle
def process_command(transcription):
    transcription = transcription.lower()

    if "ışıkları kapat" in transcription and "salon" in transcription:
        response = "Salon ışıkları kapatıldı."
    elif "prizleri aç" in transcription and "mutfak" in transcription:
        response = "Mutfak prizleri açıldı."
    elif "hava" in transcription:
        response = "Şu anda hava durumu bilgisini alamıyorum."
    elif "teşekkür" in transcription:
        response = "Rica ederim, her zaman buradayım."
    else:
        response = "Bu komutu anlayamadım ama kaydettim: " + transcription

    print("🔈 Sesli Yanıt:", response)
    speak(response)
    return response

# 6. Sürekli dinleme ve tetikleyici ile komut moduna geçiş
def listen_and_process():
    print("Sistem başlatıldı. 'Hey akıllı priz' dediğinizde komut moduna geçilecek.")
    first = True
    last_hash = None
    sessiz_sayac = 0
    sessiz_limit = 10  # 10 x 1 sn = 10 saniye
    try:
        while True:
            if first:
                print("Dinleme başlatıldı...")
                first = False
            audio_array, fs = record_audio_array(duration=1)
            audio_hash = get_audio_hash(audio_array)
            if last_hash == audio_hash:
                continue  # Aynı ses tekrar işlenmesin
            last_hash = audio_hash
            if np.all(audio_array == 0):
                sessiz_sayac += 1
                if sessiz_sayac >= sessiz_limit:
                    print("10 saniye boyunca hiç ses algılanmadı. Program kapatılıyor.")
                    break
                continue
            else:
                sessiz_sayac = 0  # Ses algılandıysa sayaç sıfırlanır
            # Sesi 16kHz'e çevir (gerekirse)
            if fs != 16000:
                waveform = torchaudio.functional.resample(torch.tensor(audio_array, dtype=torch.float32), fs, 16000).numpy()
            else:
                waveform = audio_array.astype(np.float32)
            # Transkripsiyon
            try:
                inputs = processor(waveform, sampling_rate=16000, return_tensors="pt")
                input_features = inputs.input_features.to(model.device)
                if input_features.shape[0] == 0 or input_features.shape[1] == 0:
                    continue
                with torch.no_grad():
                    generated_ids = model.generate(input_features=input_features)
                transcription = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
            except Exception as e:
                # Sadece ilk hatada uyarı ver, spam olmasın
                if sessiz_sayac == 0:
                    print(f"Transkripsiyon hatası: {e}")
                continue
            timestamp = datetime.now().strftime("[%Y-%m-%d %H:%M:%S]")
            entry = f"{timestamp} {transcription}"
            print("📝 Algılanan Konuşma:", transcription)
            with open("transkript.txt", "a", encoding="utf-8") as f:
                f.write(entry + "\n")
            # Tetikleyici kontrolü
            if "hey akıllı priz" in transcription.lower():
                speak("Efendim, sizi dinliyorum. Komutunuzu söyleyebilirsiniz.")
                print("🎧 Komut bekleniyor...")
                audio_array, fs = record_audio_array(duration=5)
                if np.all(audio_array == 0):
                    print("Sessiz komut kaydı algılandı.")
                    continue
                if fs != 16000:
                    waveform = torchaudio.functional.resample(torch.tensor(audio_array, dtype=torch.float32), fs, 16000).numpy()
                else:
                    waveform = audio_array.astype(np.float32)
                try:
                    inputs = processor(waveform, sampling_rate=16000, return_tensors="pt")
                    input_features = inputs.input_features.to(model.device)
                    if input_features.shape[0] == 0 or input_features.shape[1] == 0:
                        print("Geçersiz komut girdisi.")
                        continue
                    with torch.no_grad():
                        generated_ids = model.generate(input_features=input_features)
                    command_text = processor.batch_decode(generated_ids, skip_special_tokens=True)[0]
                except Exception as e:
                    print(f"Komut transkripsiyon hatası: {e}")
                    continue
                print("🗣️ Komut:", command_text)
                response = process_command(command_text)
                with open("transkript.txt", "a", encoding="utf-8") as f:
                    f.write(f"{datetime.now().strftime('[%Y-%m-%d %H:%M:%S]')} Komut: {command_text} → {response}\n")
                print("Komut sonrası tekrar dinlemeye geçiliyor...")
    except KeyboardInterrupt:
        print("\nKullanıcı tarafından durduruldu. Program kapatılıyor.")

if __name__ == "__main__":
    listen_and_process()
    # Tüm transkriptleri göster
    print("\n📄 Kayıtlı Tüm Konuşmalar:")
    with open("transkript.txt", "r", encoding="utf-8") as f:
        print(f.read())
