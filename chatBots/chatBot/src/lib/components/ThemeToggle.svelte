<script lang="ts">
  import { theme } from "$lib/stores/theme";
  
  function toggleTheme() {
    $theme = $theme === 'light' ? 'dark' : 'light';
    if (typeof window !== 'undefined') {
      localStorage.setItem('theme', $theme);
    }
  }
</script>

<button
  on:click={toggleTheme}
  class="fixed bottom-6 right-6 p-3 rounded-full bg-white dark:bg-dark-surface shadow-lg hover:shadow-xl transition-all duration-300 group"
  aria-label="Toggle theme"
>
  {#if $theme === 'dark'}
    <svg 
      class="w-6 h-6 text-yellow-500 transform group-hover:rotate-45 transition-transform duration-300" 
      fill="currentColor" 
      viewBox="0 0 24 24"
    >
      <path d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z" />
    </svg>
  {:else}
    <svg 
      class="w-6 h-6 text-gray-700 transform group-hover:rotate-12 transition-transform duration-300" 
      fill="currentColor" 
      viewBox="0 0 24 24"
    >
      <path d="M17.293 13.293A8 8 0 016.707 2.707a8.001 8.001 0 1010.586 10.586z" />
    </svg>
  {/if}
</button>
