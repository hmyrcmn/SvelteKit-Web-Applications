<!-- src/routes/+page.svelte -->
<script>
	import { houses } from './store.js';
	import house from '../lib/components/house.svelte';
  </script>
  
  <main class="container mx-auto p-4">
	<h1 class="text-3xl font-bold mb-4">Priz Kontrolü</h1>
  
	{#each $evler as house}
	  <house {house} />
	{/each}
  </main>
  