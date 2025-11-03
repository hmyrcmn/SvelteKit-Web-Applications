<script lang="ts">
	import { onMount, onDestroy } from 'svelte';

	// Centralized data keeps the code clean
	const statsData = [
		{ value: '6', text: 'Core Processor', subtext: 'Parallel data processing', icon: 'https://api.iconify.design/ri/cpu-line.svg' },
		{ value: '40', text: 'Sensor Inputs', subtext: '5V/24VDC precision', icon: 'https://api.iconify.design/mdi/radar.svg' },
		{ value: '6', text: 'Proportional Solenoid', subtext: '4-20mA, 0-10V control', icon: 'https://api.iconify.design/ri/settings-line.svg' },
		{ value: '6', text: 'Solenoid Outputs', subtext: 'Dry Contact - 10A', icon: 'https://api.iconify.design/ri/exchange-line.svg' }
	];

	let cardElements: HTMLElement[] = [];
	const circumference = 2 * Math.PI * 52; // SVG circle radius (r=52)

	onMount(() => {
		const update = () => {
			for (const card of cardElements) {
				if (!card) continue;
				const rect = card.getBoundingClientRect();
				const viewHeight = window.innerHeight || document.documentElement.clientHeight;

				const start = Math.min(viewHeight, Math.max(0, viewHeight - rect.top));
				const total = rect.height + viewHeight * 0.5; // Completes at half viewport
				let progress = Math.min(1, Math.max(0, start / total));

				// Calculate offset for SVG circle
				const offset = circumference * (1 - progress);
				card.style.setProperty('--progress-offset', `${offset}`);
			}
		};

		update();
		window.addEventListener('scroll', update, { passive: true });
		window.addEventListener('resize', update);

		return () => {
			window.removeEventListener('scroll', update);
			window.removeEventListener('resize', update);
		};
	});
</script>

<section class="capacity-section">
	<div class="container">
		<h4 class="subtitle">HVD-AI ORION CAPACITY</h4>
		<h2 class="title">Technical Specifications</h2>
		<p class="description">
			ORION, with its multi-core architecture and advanced I/O modules, 
			processes, analyzes, and controls dozens of sensor signals simultaneously in real time.
		</p>

		<div class="stats-grid">
			{#each statsData as stat, index}
				<div class="stat-card" bind:this={cardElements[index]}>
					<div class="dial-container">
						<!-- Radial Progress Bar -->
						<svg class="dial-svg" viewBox="0 0 120 120">
							<circle class="dial-bg" cx="60" cy="60" r="52" />
							<circle
								class="dial-progress"
								cx="60"
								cy="60"
								r="52"
								stroke-dasharray={circumference}
								stroke-dashoffset={circumference}
							/>
						</svg>
						<!-- Icon -->
						<img src={stat.icon} alt="{stat.text} Icon" class="stat-icon" />
					</div>
					<div class="text-content">
						<span class="stat-value">{stat.value}</span>
						<span class="stat-text">{stat.text}</span>
						<span class="stat-subtext">{stat.subtext}</span>
					</div>
				</div>
			{/each}
		</div>
	</div>
</section>

<style>
	:root {
		--bg-dark-navy: #0a192f;
		--bg-light-navy: #112240;
		--text-lightest: #e6f1ff;
		--text-light: #ccd6f6;
		--text-dark: #8892b0;
		
	}

	.capacity-section {
		padding: 6rem 1.5rem;
		background-color: var(--bg-dark-navy);
		color: var(--text-light);
	}

	.container {
		max-width: 1200px;
		margin: 0 auto;
		text-align: center;
	}

	.subtitle {
		color: #e6f1ff;
		font-family: 'Roboto ', ;
		font-size: 5em;
		font-weight: 500;
	}

	.title {
		font-size: 2.75rem;
		font-weight: 700;
		margin-top: 0.5rem;
		color: var(--text-lightest);
	}

	.description {
		max-width: 600px;
		margin: 1rem auto 4rem;
		color: var(--text-dark);
		line-height: 1.6;
	}

	.stats-grid {
		display: grid;
		grid-template-columns: repeat(4, 1fr);
		gap: 1.5rem;
	}

	.stat-card {
		background-color: var(--bg-light-navy);
		padding: 2rem 1.5rem;
		text-align: center;
		position: relative;
		clip-path: polygon(0 10px, 10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%);
		transition: transform 0.3s ease, background-color 0.3s ease;
	}
	.stat-card::before {
		content: '';
		position: absolute;
		inset: 0;
		clip-path: polygon(0 10px, 10px 0, 100% 0, 100% calc(100% - 10px), calc(100% - 10px) 100%, 0 100%);
		border: 1px solid transparent;
		transition: border-color 0.3s ease;
		pointer-events: none;
	}

	.stat-card:hover {
		transform: translateY(-8px);
		background-color: #1b2f51;
	}
	.stat-card:hover::before {
		border-color: #e6f1ff;
	}

	.dial-container {
		position: relative;
		width: 120px;
		height: 120px;
		margin: 0 auto 1.5rem;
		display: flex;
		align-items: center;
		justify-content: center;
	}

	.dial-svg {
		position: absolute;
		inset: 0;
		transform: rotate(-90deg); /* Dairenin başlangıcını üste alır */
	}

	.dial-bg, .dial-progress {
		fill: none;
		stroke-width: 4;
	}

	.dial-bg {
		stroke: rgba(136, 146, 176, 0.15);
	}

	.dial-progress {
		stroke:#e6f1ff;
		stroke-linecap: round;
		stroke-dashoffset: var(--progress-offset, 326.72); /* circumference */
		transition: stroke-dashoffset 0.5s cubic-bezier(0.25, 0.1, 0.25, 1);
	}

	.stat-icon {
		width: 40px;
		height: 40px;
		filter: invert(100%) brightness(1000%);
	}

	.stat-value {
		display: block;
		font-size: 2.5rem;
		font-weight: 700;
		color: var(--text-lightest);
		margin-bottom: 0.25rem;
	}

	.stat-text {
		display: block;
		font-size: 1rem;
		color: var(--text-light);
	}

	.stat-subtext {
		display: block;
		font-size: 0.8rem;
		color:#8892b0;
		margin-top: 0.25rem;
	}

	@media (max-width: 992px) {
		.stats-grid {
			grid-template-columns: repeat(2, 1fr);
		}
	}
	@media (max-width: 576px) {
		.stats-grid {
			grid-template-columns: 1fr;
		}
		.title {
			font-size: 2rem;
		}
	}
</style>