<section class="module-view-section">
  <div class="module-panel layout-reversed">
    <!-- Left Column: Content -->
    <div class="content-pane">
      <div class="content-header">
        <h4 class="subtitle">MODULE ANALYSIS: HVD-AI CLOUD</h4>
        <h2 class="title">Central Data Bank</h2>
        <p class="description">
          Digitizes master expertise, stores it in a central data bank, analyzes it, and makes it accessible for future repairs.
        </p>
      </div>

      <div class="features-grid">
        <!-- Data Collection & Analysis -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M4 7v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2H6c-1.1 0-2 .9-2 2zm10 4c0-1.1-.9-2-2-2s-2 .9-2 2 .9 2 2 2 2-.9 2-2z" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Data Collection & Analysis</h3>
            <p class="block-description">All service data is stored centrally.</p>
          </div>
        </div>

        <!-- Fast Fault Prediction -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M13.5 4.5L13.5 9H18M13 21C8.02944 21 4 16.9706 4 12C4 7.02944 8.02944 3 13 3C17.9706 3 22 7.02944 22 12C22 13.8163 21.4725 15.5233 20.5539 16.9588" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Fast Fault Prediction</h3>
            <p class="block-value"><span class="highlight">50%</span> Faster</p>
          </div>
        </div>

        <!-- Digital Service Tracking -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Digital Service Tracking</h3>
            <p class="block-value"><span class="highlight">30%</span> Fewer Manual Steps</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column: Image -->
    <div class="image-pane">
      <img src="/img/cld.png" alt="HVD-AI Cloud Data Flow" class="feature-image" />
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
		max-width: 1100px;
		min-height: 500px;
		display: grid;
		grid-template-columns:  1.3fr 0.7fr;
		background-color: var(--bg-light-navy);
		border: 1px solid var(--border-color);
		box-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
		transition: box-shadow 0.3s ease;
	}
	.module-panel:hover {
		box-shadow: 0 0 50px rgba(100, 255, 218, 0.15);
	}

	/* YENİ: Ters Yerleşim Sınıfı */
	.module-panel.layout-reversed .image-pane {
		grid-column: 2; /* Resmi 2. sütuna taşı */
	}
	.module-panel.layout-reversed .content-pane {
		grid-column: 1; /* İçeriği 1. sütuna taşı */
		border-left: none; /* Sol kenarlığı kaldır */
		border-right: 1px solid var(--border-color); /* Sağ kenarlık ekle */
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
		transition: transform 0.4s ease, opacity 0.4s ease;
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
		grid-template-columns: 1fr;
		gap: 1rem;
	}

	.feature-block {
		display: flex;
		align-items: center;
		padding: 1rem;
		border: 1px solid var(--border-color);
		background-color: rgba(10, 25, 47, 0.5);
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
		color: var(--text-dark);
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
		.module-panel, .module-panel.layout-reversed {
			grid-template-columns: 1fr;
			min-height: auto;
		}
		.image-pane {
			height: 350px;
		}
		/* Ters yerleşimde resmi üste al */
		.module-panel.layout-reversed .image-pane {
			grid-row: 1;
		}
		.module-panel.layout-reversed .content-pane {
			grid-row: 2;
			border-right: none;
			border-left: none;
		}
		.content-pane {
			padding: 2.5rem;
		}
	}

	@media (max-width: 500px) {
		.title { font-size: 2rem; }
		.content-pane { padding: 2rem 1.5rem; }
	}
</style>