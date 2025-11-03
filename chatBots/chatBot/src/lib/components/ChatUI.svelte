<script lang="ts">
  let message = "";
  let isLoading = false;
  let error: string | null = null;

  async function handleSubmit() {
    if (!message.trim()) return;
    
    isLoading = true;
    error = null;
    
    try {
      const response = await fetch('/api/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ message })
      });
      
      if (!response.ok) throw new Error('API yanıt vermedi');
      
      const data = await response.json();
      message = ""; // input'u temizle
      
    } catch (e) {
      error = e instanceof Error ? e.message : 'Bir hata oluştu';
    } finally {
      isLoading = false;
    }
  }
</script>

<div class="w-full max-w-md mx-auto bg-white dark:bg-dark-surface rounded-2xl shadow-lg overflow-hidden">
  <!-- Bot Avatar -->
  <div class="p-6 flex flex-col items-center">
    <div class="w-32 h-32 relative">
      <img 
        src="/images/bot-avatar.png" 
        alt="AI Bot" 
        class="w-full h-full object-contain"
      />
    </div>
    
    <!-- Message Display -->
    <div class="mt-6 w-full text-center">
      <h2 class="text-xl font-semibold text-gray-800 dark:text-white">
        {message || "Nasıl yardımcı olabilirim?"}
      </h2>
      {#if error}
        <p class="text-red-500 mt-2">{error}</p>
      {/if}
    </div>
  </div>

  <!-- Input Controls -->
  <div class="p-4 border-t border-gray-200 dark:border-gray-700">
    <div class="flex items-center justify-center gap-4">
      <button
        class="p-3 rounded-full bg-bot-light dark:bg-bot-dark text-bot-blue hover:bg-opacity-80 transition-all disabled:opacity-50"
        aria-label="Mesaj gönder"
        disabled={isLoading}
        on:click={handleSubmit}
      >
        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 14c1.66 0 3-1.34 3-3V5c0-1.66-1.34-3-3-3S9 3.34 9 5v6c0 1.66 1.34 3 3 3z"/>
          <path d="M17 11c0 2.76-2.24 5-5 5s-5-2.24-5-5H5c0 3.53 2.61 6.43 6 6.92V21h2v-3.08c3.39-.49 6-3.39 6-6.92h-2z"/>
        </svg>
      </button>
      
      <button
        class="p-3 rounded-full bg-bot-light dark:bg-bot-dark text-bot-blue hover:bg-opacity-80 transition-all"
        aria-label="Seçenekler"
      >
        <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 24 24">
          <path d="M12 8c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm0 2c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2zm0 6c-1.1 0-2 .9-2 2s.9 2 2 2 2-.9 2-2-.9-2-2-2z"/>
        </svg>
      </button>
    </div>
  </div>
</div>
