<section class="module-view-section">
	<div class="module-panel">
		<!-- Left Column: Image -->
		<div class="image-pane">
			<img src="/img/or2.png" alt="HVD-AI Doctor Interface" class="feature-image" />
		</div>

		<!-- Right Column: Info -->
		<div class="content-pane">
			<div class="content-header">
				<h4 class="subtitle">MODULE ANALYSIS: HVD-AI DOCTOR</h4>
				<h2 class="title">Smart Diagnosis & Repair</h2>
				<p class="description">
					The AI engine processes measurement data and applies previous experiences to future
					repairs. The experience of thousands of technicians trains the AI.
				</p>
			</div>

			<div class="features-grid">
				<!-- Smart Analysis -->
				<div class="feature-block">
					<div class="block-icon">
						<svg viewBox="0 0 24 24"
							><path
								d="M12 8V12M12 16H12.01M21 12C21 16.9706 16.9706 21 12 21C7.02944 21 3 16.9706 3 12C3 7.02944 7.02944 3 12 3C16.9706 3 21 7.02944 21 12Z"
							/></svg
						>
					</div>
					<div class="block-content">
						<h3 class="block-title">Smart Analysis</h3>
						<p class="block-description">Patented AI compares thousands of data points.</p>
					</div>
				</div>
				<!-- Fast Diagnosis -->
				<div class="feature-block">
					<div class="block-icon">
						<svg viewBox="0 0 24 24"
							><path
								d="M13.5 4.5L13.5 9H18M13 21C8.02944 21 4 16.9706 4 12C4 7.02944 8.02944 3 13 3C17.9706 3 22 7.02944 22 12C22 13.8163 21.4725 15.5233 20.5539 16.9588"
							/></svg
						>
					</div>
					<div class="block-content">
						<h3 class="block-title">Fast Diagnosis</h3>
						<p class="block-value"><span class="highlight">40%</span> Faster</p>
					</div>
				</div>
				<!-- Efficiency Increase -->
				<div class="feature-block">
					<div class="block-icon">
						<svg viewBox="0 0 24 24"
							><path
								d="M3 15C3 15 5 13 7 15C9 17 11 13 13 15C15 17 17 13 19 15C21 17 21 15 21 15V3H3V15Z"
							/><path d="M3 21H21" /></svg
						>
					</div>
					<div class="block-content">
						<h3 class="block-title">Efficiency Increase</h3>
						<p class="block-value"><span class="highlight">25%</span> Savings</p>
					</div>
				</div>
			</div>
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
		--accent-cyan: #64ffda;
		--border-color: rgba(136, 146, 176, 0.2);
	}

	.module-view-section {
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 2rem;
		background-color: var(--bg-dark-navy);
	}

	.module-panel {
		width: 100%;
		max-width: 1100px; /* Genişliği azalttık */
		min-height: 500px; /* Minimum yükseklik */
		display: grid;
		grid-template-columns: 0.7fr 1.3fr; /* Dengeli 1:1 oran */
		background-color: var(--bg-light-navy);
		border: 1px solid var(--border-color);
		box-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
		transition: box-shadow 0.3s ease;
	}
	.module-panel:hover {
		box-shadow: 0 0 50px rgba(100, 255, 218, 0.15);
	}

	/* Sol Sütun: Görsel */
	.image-pane {
		background-color: #000;
		overflow: hidden;
	}
	.feature-image {
		width: 100%;
		height: 100%;
		object-fit: cover;
		opacity: 0.8;
		transition:
			transform 0.4s ease,
			opacity 0.4s ease;
	}
	.module-panel:hover .feature-image {
		transform: scale(1.03);
		opacity: 1;
	}

	/* Sağ Sütun: İçerik */
	.content-pane {
		padding: 3rem;
		display: flex;
		flex-direction: column;
		justify-content: center;
		border-left: 1px solid var(--border-color);
	}

	.subtitle {
		color: var(--accent-cyan);
		font-family: 'Roboto Mono', monospace;
		font-size: 1.85rem;
		margin-bottom: 1rem;
	}
	.title {
		font-size: 2.25rem;
		font-weight: 700;
		color: var(--text-lightest);
		margin: 0;
		line-height: 1.2;
	}
	.description {
		margin: 1.25rem 0 2.5rem 0;
		color: #ffff;
		line-height: 1.6;
		font-size: 0.95rem;
	}

	.features-grid {
		display: grid;
		grid-template-columns: 1fr; /* Blokları alt alta dizdik */
		gap: 1rem;
	}

	.feature-block {
		display: flex;
		align-items: center;
		padding: 1rem;
		border: 1px solid var(--border-color);
		background-color: rgba(10, 25, 47, 0.5); /* Hafifçe farklı arkaplan */
		transition: background-color 0.3s ease;
	}
	.feature-block:hover {
		background-color: rgba(10, 25, 47, 1);
	}

	.block-icon {
		flex-shrink: 0;
		margin-right: 1rem;
		padding: 0.5rem;
		background-color: rgba(100, 255, 218, 0.05);
		border: 1px solid rgba(100, 255, 218, 0.1);
	}
	.block-icon svg {
		width: 24px;
		height: 24px;
		stroke: var(--accent-cyan);
		stroke-width: 1.5;
		fill: none;
	}

	.block-content {
		display: flex;
		align-items: baseline;
		justify-content: space-between;
		width: 100%;
	}
	.block-title {
		font-size: 1rem;
		font-weight: 500;
		color: var(--text-light);
	}
	.block-description {
		font-size: 0.9rem;
		color: #ffff;
		text-align: right;
	}
	.block-value {
		font-size: 1.5rem;
		font-weight: 600;
		color: var(--text-lightest);
		text-align: right;
	}
	.highlight {
		color: var(--accent-cyan);
	}

	@media (max-width: 1024px) {
		.module-view-section {
			min-height: auto;
			padding: 4rem 1rem;
		}
		.module-panel {
			grid-template-columns: 1fr;
			min-height: auto;
		}
		.image-pane {
			height: 350px;
		}
		.content-pane {
			padding: 2.5rem;
		}
	}

	@media (max-width: 500px) {
		.title {
			font-size: 2rem;
		}
		.content-pane {
			padding: 2rem 1.5rem;
		}
	}
</style>
