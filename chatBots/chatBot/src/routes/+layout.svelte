<script lang="ts">
	import "../app.css";
	import Header from "$lib/components/Header.svelte";
	import Footer from "$lib/components/Footer.svelte";
	import { theme } from "$lib/stores/theme";
	import { onMount } from "svelte";
	
	// Sayfa yüklendiğinde kaydedilmiş temayı kontrol et
	onMount(() => {
		if (typeof window !== 'undefined') {
			const savedTheme = localStorage.getItem('theme') || 'light';
			theme.set(savedTheme);
			document.documentElement.classList.toggle('dark', savedTheme === 'dark');
		}
	});
	
	// Theme değişikliğini dinle
	$: if (typeof window !== 'undefined') {
		document.documentElement.classList.toggle('dark', $theme === 'dark');
	}
</script>

<div class="min-h-screen flex flex-col bg-white dark:bg-dark-bg transition-colors duration-200">
	<Header />
	<main class="flex-grow container mx-auto px-4 py-8">
		<slot />
	</main>
	<Footer />
</div>