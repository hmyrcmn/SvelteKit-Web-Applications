<script lang="ts">
	// Oluşturduğumuz tüm bileşenleri import ediyoruz
	import Head from '$lib/components/head.svelte';

	import Hero from '$lib/components/Hero.svelte';
	import MobileSection from '$lib/components/MobileSection.svelte';
	import FeaturedTV from '$lib/components/FeaturedTV.svelte';
	import HighlightsSection from '$lib/components/HighlightsSection.svelte';
	import ExploreSection from '$lib/components/ExploreSection.svelte';
	import SupportSection from '$lib/components/SupportSection.svelte';
	import ExampleSection from '$lib/components/ExampleSection.svelte';
	import UseCase from '$lib/components/useCase.svelte';

	import VideolarSection from '$lib/components/videolar.svelte';
	import Video from '$lib/components/video.svelte';
	import Bigimages from '$lib/components/tr/images.svelte';
  import Cardinfo from '$lib/components/cardinfo.svelte';
</script>

<main>
	<!-- Bileşenleri sırayla çağırıyoruz -->
	<Head />
	<!-- <MobileSection /> -->
  <Cardinfo />
	<Bigimages />
	<FeaturedTV />
  <!-- <Cardinfo /> -->
	<ExampleSection />
	<!-- <UseCase /> -->
	<!-- <VideolarSection /> -->

	<SupportSection />
</main>

<style>
	main {
		/* Ana kapsayıcı için ek bir stil gerekirse buraya yazılabilir. */
		/* Bu örnekte şimdilik boş bırakıyoruz. */
	}
</style>
