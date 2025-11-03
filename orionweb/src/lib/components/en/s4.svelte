<script lang="ts">
	import { fly } from 'svelte/transition';

	const mainModules = [
		{
			image: '/img/or2.png',
			title: 'HVD-AI ORION Doctor',
			description: 'Fault detection and repair assistant',
			link: '#doctor-section',
			size: 'default'
		},
		{
			image: '/img/assis.png',
			title: 'HVD-AI ORION Assistant',
			description: 'Repair predictions based on past data',
			link: '#asistan-section',
			size: 'default'
		},

		{
			image: '/img/cld.png',
			title: 'HVD-AI ORION Cloud',
			description: 'Central data hub and fleet management',
			link: '#cloud-section',
			size: 'default'
		},
		{
			image: '/img/co3.png',
			title: 'HVD-AI ORION Co-pilot',
			description: 'Virtual collaboration platform for experts',
			link: '#copilot-section',
			size: 'wide'
		},
		{
			image: '/img/mobile.png',
			title: 'HVD-AI ORION Mobile',
			description: 'Real-time reporting and remote access',
			link: '#mobil-section',
			size: 'wide'
		},
		{
			image: '/img/eduh4.png',
			title: 'HVD-AI ORION Edu',
			description: 'Interactive technical training module',
			link: '#edu-section',
			size: 'wide'
		}
	];

	const testSystems = [
		{ image: '/img/pfeature2.png', title: 'EBS Test System', link: '#info-section' },
		{ image: '/img/p6.png', title: 'APM Test System', link: '#info-section' },
		{ image: '/img/test.png', title: 'Euro 4/5/6 (7+) Compliance', link: '#info-section' }
	];

	let inView = false;

	function intersect(node: HTMLElement) {
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries[0].isIntersecting) {
					inView = true;
					observer.disconnect();
				}
			},
			{ threshold: 0.1 }
		);
		observer.observe(node);
		return { destroy: () => observer.disconnect() };
	}
</script>

<section class="module-section" use:intersect>
	<div class="container">
		<div class="section-header">
			<h2 class="section-title">System Components & Modules</h2>
			<p class="section-subtitle">
				Explore the core modules that power HVD-AI ORION’s capabilities. Select a card to learn more
				technical details about each component.
			</p>
		</div>

		{#if inView}
			<!-- Main Modules Grid -->
			<div class="main-modules-grid">
				{#each mainModules as card, index}
					<a
						href={card.link}
						class="card"
						class:is-wide={card.size === 'wide'}
						class:is-tall={card.size === 'tall'}
						in:fly={{ y: 40, duration: 600, delay: index * 60 }}
					>
						<div class="card-image-wrapper">
							<img src={card.image} alt={card.title} class="card-image" loading="lazy" />
						</div>
						<div class="card-content">
							<div class="text-content">
								<h3 class="card-title">{@html card.title}</h3>
								<p class="card-description">{card.description}</p>
							</div>
							<div class="card-cta">
								<span class="cta-text">View Details</span>
								<svg class="cta-icon" viewBox="0 0 24 24">
									<path d="M17.25 12L6.75 12M17.25 12L12.75 17.25M17.25 12L12.75 6.75" />
								</svg>
							</div>
						</div>
					</a>
				{/each}
			</div>

			<!-- Test Systems Section -->
			<div class="sub-section-header">
				<h3 class="sub-section-title">Integrated Test Systems</h3>
			</div>

			<div class="test-systems-grid">
				{#each testSystems as card, index}
					<a
						href={card.link}
						class="card is-small"
						in:fly={{ y: 40, duration: 600, delay: (mainModules.length + index) * 60 }}
					>
						<div class="card-image-wrapper">
							<img src={card.image} alt={card.title} class="card-image" loading="lazy" />
						</div>
						<div class="card-content">
							<div class="small-card-inner">
								<h3 class="card-title">{@html card.title}</h3>
								<div class="card-cta">
									<span class="cta-text">Details</span>
									<svg class="cta-icon" viewBox="0 0 24 24">
										<path d="M17.25 12L6.75 12M17.25 12L12.75 17.25M17.25 12L12.75 6.75" />
									</svg>
								</div>
							</div>
						</div>
					</a>
				{/each}
			</div>
		{/if}
	</div>
</section>

<style>
	:root {
		--bg-light: #f8f9fa;
		--bg-white: #ffffff;
		--border-color: #e9ecef;
		--text-primary: #212529;
		--text-secondary: #6c757d;
		--accent-blue: #007bff;
	}
	.module-section {
		padding: 6rem 1.5rem;
		background-color: var(--bg-light);
	}
	.container {
		max-width: 1320px;
		margin: 0 auto;
	}
	.section-header {
		text-align: center;
		margin-bottom: 3rem;
	}
	.section-title {
		font-size: 2.75rem;
		font-weight: 700;
		color: var(--text-primary);
		margin-bottom: 1rem;
	}
	.section-subtitle {
		font-size: 1.15rem;
		color: var(--text-secondary);
		max-width: 700px;
		margin: 0 auto;
		line-height: 1.7;
	}

	/* Ana Grid */
	.main-modules-grid {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 1.5rem;
		margin-bottom: 3rem;
	}

	/* Alt Bölüm Başlığı */
	.sub-section-header {
		position: relative;
		text-align: center;
		margin-bottom: 2rem;
	}
	.sub-section-header::before {
		content: '';
		position: absolute;
		left: 0;
		right: 0;
		top: 50%;
		height: 1px;
		background-color: var(--border-color);
	}
	.sub-section-title {
		position: relative;
		display: inline-block;
		background-color: var(--bg-light);
		padding: 0 1.5rem;
		font-size: 1.5rem;
		font-weight: 600;
		color: var(--text-primary);
	}

	/* Test Sistemleri Grid'i */
	.test-systems-grid {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 1.5rem;
	}

	.card {
		background-color: var(--bg-white);
		border-radius: 12px;
		border: 1px solid var(--border-color);
		box-shadow: 0 4px 6px rgba(0, 0, 0, 0.04);
		display: flex;
		flex-direction: column;
		overflow: hidden;
		text-decoration: none;
		transition:
			transform 0.3s ease,
			box-shadow 0.3s ease,
			border-color 0.3s ease;
	}
	.card:hover {
		transform: translateY(-8px);
		box-shadow: 0 12px 20px rgba(0, 0, 0, 0.08);
		border-color: var(--accent-blue);
	}

	.card.is-tall {
		grid-row: span 2;
	}
	.card.is-wide {
		grid-column: span 1.5;
		flex-direction: row;
	}

	.card-image-wrapper {
		position: relative;
		overflow: hidden;
		background-color: #000;
	}
	.card:not(.is-wide) .card-image-wrapper {
		height: 220px;
	}
	.card.is-wide .card-image-wrapper {
		flex-basis: 50%;
	}
	.card.is-small .card-image-wrapper {
		height: 140px;
	}

	.card-image {
		width: 100%;
		height: 100%;
		object-fit: cover;
		transition: transform 0.4s ease;
	}
	.card:hover .card-image {
		transform: scale(1.05);
	}

	.card-content {
		padding: 1.75rem;
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		flex-grow: 1;
	}
	.card.is-wide .card-content {
		flex-basis: 50%;
	}

	.text-content {
		flex-grow: 1;
	}
	.card-title {
		font-size: 1.5rem;
		font-weight: 600;
		color: var(--text-primary);
		margin-bottom: 0.75rem;
	}
	.card-description {
		font-size: 1rem;
		color: var(--text-secondary);
		line-height: 1.6;
	}

	/* Küçük Kart Optimizasyonu */
	.card.is-small .card-content {
		padding: 1.5rem;
	}
	.card.is-small .card-title {
		font-size: 1.25rem;
		margin-bottom: 0;
	}
	.small-card-inner {
		display: flex;
		flex-direction: column;
		justify-content: space-between;
		flex-grow: 1;
	}

	.card-cta {
		display: flex;
		align-items: center;
		margin-top: 1.5rem;
		color: var(--accent-blue);
		font-weight: 500;
	}
	.cta-text {
		font-size: 0.95rem;
	}
	.cta-icon {
		width: 20px;
		height: 20px;
		stroke: var(--accent-blue);
		stroke-width: 2;
		margin-left: 0.5rem;
		transition: transform 0.3s ease;
	}
	.card:hover .cta-icon {
		transform: translateX(4px);
	}

	@media (max-width: 1024px) {
		.main-modules-grid {
			grid-template-columns: 1fr 1fr;
		}
		.card.is-wide {
			grid-column: span 2;
		}
		.card.is-tall {
			grid-column: span 1;
			grid-row: span 2;
		}
	}

	@media (max-width: 768px) {
		.module-section {
			padding: 4rem 1rem;
		}
		.section-title {
			font-size: 2.2rem;
		}
		.main-modules-grid,
		.test-systems-grid {
			grid-template-columns: 1fr;
		}
		.card.is-wide,
		.card.is-tall {
			grid-column: span 1;
			grid-row: auto;
			flex-direction: column;
		}
		.card.is-wide .card-image-wrapper {
			height: 220px;
			flex-basis: auto;
		}
	}
</style>
