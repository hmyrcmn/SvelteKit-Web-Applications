<script lang="ts">
  import { page } from '$app/stores';
  let isMenuOpen = false;
</script>

<header class="bg-white dark:bg-dark-surface shadow-md">
  <div class="container mx-auto px-4">
    <div class="flex justify-between items-center h-16">
      <!-- Logo -->
      <a href="/" class="flex items-center">
        <img src="/images/logo.svg" alt="Kul Elektronik" class="h-8 w-auto" />
      </a>

      <!-- Desktop Navigation -->
      <nav class="hidden md:flex space-x-8">
        <a 
          href="/" 
          class="text-gray-700 dark:text-gray-200 hover:text-primary transition-colors"
          class:text-primary={$page.url.pathname === '/'}
        >
          Ana Sayfa
        </a>
        <a 
          href="/about" 
          class="text-gray-700 dark:text-gray-200 hover:text-primary transition-colors"
          class:text-primary={$page.url.pathname === '/about'}
        >
          Hakkımızda
        </a>
      </nav>

      <!-- Mobile Menu Button -->
      <button 
        class="md:hidden p-2 rounded-lg hover:bg-gray-100 dark:hover:bg-gray-800"
        on:click={() => isMenuOpen = !isMenuOpen}
      >
        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          {#if !isMenuOpen}
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
          {:else}
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
          {/if}
        </svg>
      </button>
    </div>

    <!-- Mobile Navigation -->
    {#if isMenuOpen}
      <div class="md:hidden py-4">
        <nav class="flex flex-col space-y-4">
          <a 
            href="/" 
            class="text-gray-700 dark:text-gray-200 hover:text-primary transition-colors"
            on:click={() => isMenuOpen = false}
          >
            Ana Sayfa
          </a>
          <a 
            href="/about" 
            class="text-gray-700 dark:text-gray-200 hover:text-primary transition-colors"
            on:click={() => isMenuOpen = false}
          >
            Hakkımızda
          </a>
        </nav>
      </div>
    {/if}
  </div>
</header>
