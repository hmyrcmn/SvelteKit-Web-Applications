<script>
	import { onMount } from 'svelte';
	import FeatureMap from './featureMap.svelte';
	import Vid from '$lib/components/tr/vid.svelte';


	onMount(() => {
		const observer = new IntersectionObserver(
			(entries) => {
				entries.forEach((entry) => {
					if (entry.isIntersecting) {
						entry.target.classList.add('in-view');
					}
				});
			},
			{
				threshold: 0.2 // Ekrana %20 girince animasyon tetiklenir
			}
		);

		const elementsToAnimate = document.querySelectorAll('.animate-on-scroll');
		elementsToAnimate.forEach((el) => observer.observe(el));

		// Bileşen DOM'dan kaldırıldığında observer'ı temizle
		return () => observer.disconnect();
	});

	const features = [
		{
			eyebrow: ' ',
			title: 'EBS Testleri',
			description:
				'HVD-AI ORION, ağır vasıtalardaki elektronik fren sistemlerini (EBS) kapsamlı bir şekilde analiz eder. Fren modüllerindeki arızaları tespit eder, hata kodlarını ayrıntılı olarak raporlar ve araç güvenliği için kritik önlemler sunar. <br/ > <b > KNORR BREMSE, MAN EBS Versions </b> <br/> Single and Dual Channel <br/> Software Version 2.0, 2.1, 2.2, 3.0, 4.0, 5.0, 6.0, 7.0 <br/> <b> WABCO  Single and Dual Channel</b> <br/> Software Version GEN. 1-5',
			image: '/img/ebs444.png'
	


			
		},
		{
			eyebrow: '',
			title: 'APM Testleri',
			description:
				'RENAULT,SCANIA,MERCEDES,VOLVO,ACTROS,regenaration exhaust,selenoid, sensör, air weak,test with AI.Selenoidlerin ömrünü yüzde olarak  hesaplar. ',
			image: '/img/v1.png'
		},
		{
			eyebrow: '',
			title: ' EKS Testleri',
			description:"EKS (Elektro-Mekanik Sistem) Testleri . </br> 1/1- 4/4 selenoidler ve sensörlerini test eder. Selenoidlerin ömrünü yüzde olarak  hesaplar. ",
			image: '/img/eks2.png'
		}
	
	];
</script>




<section class="tech-specs-section animate-on-scroll">
	<div class="container">
		<h2 class="spec-title">HVD-AI-ORION <br /> Öne Çıkan Teknolojisi</h2>
		<p class="spec-description">Yapay Zeka Tabanlı Taşınabilir Ağır Vasıta Diagnostik Sistemi</p>
		<div class="specs-grid">
			<div class="spec-item">
				<div class="spec-value-compound">
					<div class="main-amp">
						<div class="spec-value">EBS 2.0-7.0 / GEN1-5 <br> 40 out/ </div>
					</div>
					<div class="total-amp">
						<div class="spec-value"></div>
					</div>
				</div>
				<div class="spec-label"> EBS Modülleri </div>
			</div>

			<div class="spec-item">
				<div class="spec-value"> RENO,VOLVO,<br>SCANIA, MERCEDES</div>
				<div class="spec-label"> APM Modülleri</div>
			</div>
			<div class="spec-item">
				<div class="spec-value">AUTO ETH,CAN,<br>FDCAN,COMBUS,<br>LINBUS</div>
				<div class="spec-label">Ethernet Bağlantısı (Twisted  SINGLE Pair)</div>
			</div>
		</div>
	</div>
</section>

<FeatureMap />

<Vid />

<section id="info-section">
	<div class="elite-product-page">
	<div class="main-content">
		<div class="features-grid">
			{#each features as feature, i}
				<div class="feature-card animate-on-scroll" style="transition-delay: {i * 0.15}s;">
					<div class="feature-image-wrapper">
						<img src={feature.image} alt={feature.title} loading="lazy" />
					</div>
					<div class="feature-text-content">
						<span class="feature-eyebrow">{feature.eyebrow}</span>
						<h2 class="feature-title">{feature.title}</h2>
						<p class="feature-description">{@html feature.description}</p>
					</div>
				</div>
			{/each}
		</div>
	</div>
</div>


</section>

<style>
	:root {
		--font-primary: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
	}

	:global(body) {
		-webkit-font-smoothing: antialiased;
		-moz-osx-font-smoothing: grayscale;
		font-family: var(--font-primary);
	}

	.elite-product-page {
		background-color: #060a24;

		color: #fcfcfd; /* Koyu metin */
		overflow-x: hidden;
	}

	/* --- HERO ve ANA İÇERİK --- */
	.hero-section {
		display: flex;
		flex-direction: column;
		align-items: center;
		justify-content: center;
		text-align: center;
		padding: 2rem;
		box-sizing: border-box;
		position: relative;
	}

	.hero-section:first-of-type {
		min-height: 10vh;
		padding: 6.5rem 2rem;
	}

	.image-wrapper {
		width: 100%;
		height: 100%;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.main-image {
		display: block;
		max-width: 80%;
		max-height: 100%;
		object-fit: contain;
	}
	.hero-title {
		font-weight: 800;
		letter-spacing: -0.05em;
		line-height: 1.05;
	}

	.hero-subtitle {
		font-size: 24px;
		color: #4b5563;
		margin-top: 1rem;
		font-weight: 400;
	}

	.main-content {
		max-width: 1200px;
		margin: 0 auto;
		padding: 1rem 0.5rem;
	}

	.text-section {
		padding: 0.5rem 0;
		text-align: center;
	}

	.intro-text {
		font-size: 24px;
		line-height: 1.5;
		color: #374151; /* Daha iyi okunabilirlik için koyu gri */
		max-width: 800px;
		margin: 0 auto;
		font-weight: 400;
	}

	.intro-text strong {
		color: #060a24; /* Vurgulanan metin için koyu renk */
		font-weight: 600;
	}

	/* ========================================================= */
	/* TEKNİK ÖZELLİK STİLLERİ */
	/* ========================================================= */
	.tech-specs-section {
		padding: 2rem 1.5rem;
		text-align: center;
		background-color: #fff;
	}

	.tech-specs-section .container {
		max-width: 960px;
		margin-left: auto;
		margin-right: auto;
	}

	.spec-title {
		font-size: clamp(2.5rem, 5vw, 3.25rem);
		font-weight: 800;
		color: #111827;
		margin-bottom: 1rem;
	}

	.spec-description {
		font-size: 1.25rem;
		line-height: 1.6;
		color: #634b5d;
		max-width: 720px;
		margin-left: auto;
		margin-right: auto;
		margin-bottom: 2.5rem;
	}

	.specs-grid {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 1.5rem;
	}

	.spec-item {
		display: flex;
		flex-direction: column;
	}

	.spec-value {
		font-family: var(--font-primary);
		font-weight: 700;
		font-size: clamp(2rem, 3vw, 1rem);
		color: #000000;
		line-height: 1;
		letter-spacing: -0.05em;
	}
	.spec-value-compound {
		display: flex;
		justify-content: center;
		align-items: flex-end;
		gap: 1.5rem;
		margin-bottom: 0.5rem;
		font-family: var(--font-primary);
		font-weight: 700;
		font-size: clamp(2rem, 6vw, 3rem);
		color: #d1d5db;
		line-height: 1;
		letter-spacing: -0.05em;
	}

	.spec-value sup {
		font-size: 0.3em;
		position: relative;
		top: -0.5em;
		font-weight: 600;
		margin-left: 0.05em;
	}

	.spec-label {
		font-size: 1.125rem;
		color: #54040b;
		margin-top: 0.75rem;
	}

	@media (max-width: 767px) {
		.specs-grid {
			grid-template-columns: 1fr;
			gap: 3rem;
		}
	}
	/* ========================================================= */
	/* --- ÖZELLİKLER GRIDI --- */
	/* ========================================================= */
	.features-grid {
		display: grid;
		grid-template-columns: 1fr;
		gap: 4rem;
		padding: 3rem 0;
	}

	.feature-card {
		display: grid;
		grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
		gap: 4rem;
		align-items: center;
	}

	.feature-card:nth-child(2n) .feature-image-wrapper {
		order: 2;
	}

	.feature-image-wrapper {
		background-color: #f3f4f6;
		border-radius: 24px;
		transition: transform 0.4s ease;
		aspect-ratio: 16 / 9;
		display: flex;
		align-items: center;
		justify-content: center;
		overflow: hidden;
	}

	.feature-card:hover .feature-image-wrapper {
		transform: scale(1.02);
	}

	.feature-image-wrapper img {
		max-width: 100%;
		max-height: 100%;
		object-fit: contain;
		mix-blend-mode: multiply;
	}

	.feature-text-content {
		padding: 1rem 0;
	}

	.feature-eyebrow {
		display: block;
		font-size: 0.875rem;
		font-weight: 600;
		color: #2563eb;
		letter-spacing: 0.05em;
		margin-bottom: 1rem;
		text-transform: uppercase;
	}

	.feature-title {
		font-size: clamp(2rem, 5vw, 2.75rem);
		font-weight: 700;
		letter-spacing: -0.03em;
		margin-bottom: 1.5rem;
	}

	.feature-description {
		font-size: 1.1rem;
		line-height: 1.7;
		color: #7aaaed;
	}

	/* --- ANİMASYONLAR --- */
	.animate-on-scroll {
		opacity: 0;
		transform: translateY(30px);
		transition:
			opacity 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94),
			transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
	}

	:global(.animate-on-scroll.in-view) {
		opacity: 1;
		transform: translateY(0);
	}

	/* --- MOBİL UYUMLULUK --- */
	@media (max-width: 767px) {
		.feature-card,
		.feature-card:nth-child(2n) {
			gap: 2rem;
		}

		.feature-card:nth-child(2n) .feature-image-wrapper {
			order: 0;
		}
	}
</style>
