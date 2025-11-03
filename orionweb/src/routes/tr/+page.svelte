<script lang="ts">
	import S4 from '$lib/components/tr/s4.svelte';
	import S5 from '$lib/components/tr/s5.svelte';
	import S6 from '$lib/components/tr/s6.svelte';
	import S777 from '$lib/components/tr/s777.svelte';
	import Bigimages from '$lib/components/tr/images.svelte';

	import Doctor from '$lib/components/tr/doctor.svelte';
	import Cloud from '$lib/components/tr/cloud.svelte';
	import Asis from '$lib/components/tr/asis.svelte';
	import Copilot from '$lib/components/tr/copilot.svelte';
	import Mobil from '$lib/components/tr/mobil.svelte';
	import Edu from '$lib/components/tr/edu.svelte';

	import Test from '$lib/components/tr/test.svelte';
	import Sinfo from '$lib/components/tr/sinfo.svelte';
	import Vid from '$lib/components/tr/vid.svelte';
</script>

<svelte:head>
	<title>HVD-AI-ORION Ağır Vasıta Teşhis Sistemi</title>
	<meta
		name="description"
		content="Akıllı priz sistemlerimizle cihazlarınızı uzaktan kontrol edin, enerji tasarrufu sağlayın ve güvenliğinizi artırın."
	/>
</svelte:head>

<main data-aos="fade-up" data-aos-delay="120">
	<section>
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

	<section id="features-section-3" data-aos="fade-up" data-aos-delay="80">
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

	<section id="s7-section" data-aos="fade-up" data-aos-delay="120">
		<S777 />
	</section>

	<!-- Diğer kullanılmayan bölümlerin section'ları yorum satırında kalabilir veya kaldırılabilir -->
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

	/* Özel section stilleri */
	#main-intro-section {
		padding: 0; /* Intro bileşeni kendi iç paddinglerini yönettiği için burada 0 verdik */
		margin-bottom: 0;
	}

	@media (max-width: 768px) {
		section {
			padding: 0;
			margin-bottom: 0;
		}
	}
</style>
