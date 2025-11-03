<script lang="ts">
	// Using Svelte's fly transition for animations
	import { fly } from 'svelte/transition';
	import FeaturedTV from '$lib/components/en/FeaturedTV.svelte';

	let inView = false;

	/**
	 * intersect action:
	 * Sets `inView` to true when the element becomes visible.
	 * Triggers only once, then disconnects the observer.
	 */
	function intersect(node: HTMLElement) {
		const observer = new IntersectionObserver(
			(entries) => {
				if (entries[0].isIntersecting) {
					inView = true;
					observer.disconnect();
				}
			},
			{ threshold: 0.2 } // Triggers when 20% of the element is visible
		);

		observer.observe(node);

		return {
			destroy() {
				observer.disconnect();
			}
		};
	}
</script>

<FeaturedTV />

<!-- Section triggered with use:intersect -->
<section
	use:intersect
	data-section="innovation-showcase"
	class="innovation-section"
	aria-labelledby="innovation-title"
	role="region"
>
	<div class="content-container">
		{#if inView}
			<!-- Header -->
			<div class="header-content" in:fly={{ y: 30, duration: 600, delay: 100 }}>
				<h2 id="innovation-title" class="section-title">
					Smart Diagnostics, Seamless Control
				</h2>
				<p class="section-subtitle">
					HVD AI ORION combines advanced sensor technology with an AI engine 
					to deliver the most comprehensive fault detection and management experience 
					for heavy-duty vehicles.
				</p>
			</div>

			<!-- Features -->
			<div class="features-grid">
				<!-- Card 1 -->
				<div class="feature-card" in:fly={{ y: 30, duration: 600, delay: 300 }}>
					<div class="feature-icon">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
							<path
								d="M21.707 12.707l-1.414-1.414L15 16.586V4h-2v12.586l-5.293-5.293-1.414 1.414L12 19.414l9.707-6.707z"
							/>
						</svg>
					</div>
					<h3 class="feature-title">Fast & Precise Analysis</h3>
					<p class="feature-description">
						The system scans all test points through connected sensors and modules, 
						providing instant diagnostics and analysis.
					</p>
				</div>

				<!-- Card 2 -->
				<div class="feature-card" in:fly={{ y: 30, duration: 600, delay: 450 }}>
					<div class="feature-icon">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
							<path
								d="M10 18a7.952 7.952 0 004.897-1.688l4.396 4.396 1.414-1.414-4.396-4.396A7.952 7.952 0 0018 10c0-4.411-3.589-8-8-8s-8 3.589-8 8 3.589 8 8 8zm0-14c3.309 0 6 2.691 6 6s-2.691 6-6 6-6-2.691-6-6 2.691-6 6-6z"
							/>
						</svg>
					</div>
					<h3 class="feature-title">Comprehensive Fault Detection</h3>
					<p class="feature-description">
						Accurately identifies both electronic and mechanical issues, 
						clarifying the root cause with detailed reports.
					</p>
				</div>

				<!-- Card 3 -->
				<div class="feature-card" in:fly={{ y: 30, duration: 600, delay: 600 }}>
					<div class="feature-icon">
						<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
							<path
								d="M7 2h10a2 2 0 012 2v16a2 2 0 01-2 2H7a2 2 0 01-2-2V4a2 2 0 012-2zm0 2v16h10V4H7zm5 14a1 1 0 110-2 1 1 0 010 2z"
							/>
						</svg>
					</div>
					<h3 class="feature-title">Full Control via App</h3>
					<p class="feature-description">
						The analysis process is managed through the mobile app, 
						allowing you to easily track data and plan immediate interventions.
					</p>
				</div>
			</div>

			<!-- Footnote -->
			<div class="footnote-block" in:fly={{ y: 30, duration: 600, delay: 700 }}>
				<p class="footnote-text">
					* Data is based on HVD AI laboratory tests. 
					Actual performance may vary depending on usage conditions.
				</p>
			</div>
		{/if}
	</div>
</section>



<style>
	.innovation-section {
		background: #fff;
		padding: 6rem 1.5rem;
		color: var(--text-dark);
		text-align: center;
		overflow: hidden;
	}

	.content-container {
		max-width: 1200px;
		margin: 0 auto;
	}

	/* Başlık */
	.header-content {
		max-width: 750px;
		margin: 0 auto 4rem auto;
	}

	.section-title {
		font-size: 2.8rem;
		font-weight: 700;
		color: #0d1a2e;
		line-height: 1.2;
		margin-bottom: 1rem;
	}

	.section-subtitle {
		font-size: 1.15rem;
		line-height: 1.6;
		color:#007bff
	}

	/* Özellikler */
	.features-grid {
		display: grid;
		grid-template-columns: repeat(3, 1fr);
		gap: 2rem;
		margin-bottom: 4rem;
	}

	.feature-card {
		background: #fff;
		padding: 2.5rem 2rem;
		border-radius: 12px;
		border: 1px solid #e9e9e9;
		text-align: left;
		transition: transform 0.3s ease, box-shadow 0.3s ease;
	}

	.feature-card:hover {
		transform: translateY(-8px);
		box-shadow: 0 15px 30px rgba(0, 0, 0, 0.08);
	}

	.feature-icon {
		width: 50px;
		height: 50px;
		margin-bottom: 1.5rem;
		color: var(--primary-color, #007bff);
	}

	.feature-title {
		font-size: 1.4rem;
		font-weight: 600;
		margin-bottom: 0.75rem;
		color: #0d1a2e;
	}

	.feature-description {
		font-size: 1rem;
		line-height: 1.7;
		color: #0d1a2e;
	}

	/* Dipnot */
	.footnote-block {
		max-width: 750px;
		margin: 0 auto;
	}

	.footnote-text {
		font-size: 0.9rem;
		line-height: 1.5;
		color: #888;
	}

	/* Responsive */
	@media (max-width: 1024px) {
		.features-grid {
			grid-template-columns: 1fr;
			max-width: 600px;
			margin-left: auto;
			margin-right: auto;
		}

		.section-title {
			font-size: 2.5rem;
		}
	}

	@media (max-width: 768px) {
		.innovation-section {
			padding: 4rem 1rem;
		}

		.section-title {
			font-size: 2rem;
		}

		.section-subtitle {
			font-size: 1rem;
		}

		.feature-card {
			text-align: center;
		}

		.feature-icon {
			margin-left: auto;
			margin-right: auto;
		}
	}
</style>
