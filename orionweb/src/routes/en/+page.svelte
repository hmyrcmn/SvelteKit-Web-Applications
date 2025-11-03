<script lang="ts">
	import Doctor from '$lib/components/en/doctor.svelte';
	import Cloud from '$lib/components/en/cloud.svelte';
	import Asis from '$lib/components/en/asis.svelte';
	import Copilot from '$lib/components/en/copilot.svelte';
	import Mobil from '$lib/components/en/mobil.svelte';
	import Edu from '$lib/components/en/edu.svelte';
	import Sinfo from '$lib/components/en/sinfo.svelte';
	import S4 from '$lib/components/en/s4.svelte';
	import S5 from '$lib/components/en/s5.svelte';
	import S6 from '$lib/components/en/s6.svelte';
	import S777 from '$lib/components/en/s777.svelte';

	import Test from '$lib/components/en/test.svelte';
	import Bigimages from '$lib/components/en/images.svelte';
</script>

<svelte:head>
	<title>HVD-AI-ORION - Smart Plug and Energy Management Solutions</title>
	<meta
		name="description"
		content="Control your devices remotely, save energy, and enhance safety with our smart plug systems."
	/>
</svelte:head>

<main data-aos="fade-up" data-aos-delay="120">
	<section id="features-section-2" data-aos="fade-up" data-aos-delay="80">
		<S5 />
	</section>

	<section id="s7-section" data-aos="fade-up" data-aos-delay="60">
		<Sinfo />
	</section>
	<!-- Özellikler/Tanıtım Bölümleri -->
	<section id="features-section-1" data-aos="fade-up" data-aos-delay="80">
		<S4 />
	</section>

	<section id="features-section-3" data-aos="fade-up" data-aos-delay="80">
		<S6 />
	</section>
	<section id="test-section" data-aos="fade-up" data-aos-delay="100">
		<Test />
	</section>
	<section id="images-section" data-aos="fade-up" data-aos-delay="80">
		<Bigimages />
	</section>

	<section id="doctor-section" data-aos="fade-up" data-aos-delay="80">
		<Doctor />
	</section>

	<section id="asistan-section" data-aos="fade-up" data-aos-delay="80">
		<Asis />
	</section>
	<section id="cloud-section" data-aos="fade-up" data-aos-delay="80">
		<Cloud />
	</section>
	<section id="copilot-section" data-aos="fade-up" data-aos-delay="80">
		<Copilot />
	</section>
	<section id="mobil-section" data-aos="fade-up" data-aos-delay="80">
		<Mobil />
	</section>
	<section id="edu-section" data-aos="fade-up" data-aos-delay="80">
		<Edu />
	</section>

	<section id="s777-section" data-aos="fade-up" data-aos-delay="120">
		<S777 />
	</section>
</main>

<style>
	main {
		display: flex;
		flex-direction: column;
		width: 100%;
		overflow-x: hidden;
		background-color: white;
		gap: 0;
	}

	section {
		padding: 0;
		margin-bottom: 0;
		background-color: white;
	}

	#main-intro-section {
		padding: 0;
		margin-bottom: 0;
	}

	@media (max-width: 768px) {
		section {
			padding: 0;
			margin-bottom: 0;
		}
	}
</style>
