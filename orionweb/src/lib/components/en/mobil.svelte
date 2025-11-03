
<section class="module-view-section">
  <div class="module-panel">
    <!-- Left Column: Image -->
    <div class="image-pane">
      <img src="/img/mobile.png" alt="HVD-AI Mobile Interface" class="feature-image" />
    </div>

    <!-- Right Column: Content -->
    <div class="content-pane">
      <div class="content-header">
        <h4 class="subtitle">MODULE ANALYSIS: HVD-AI MOBILE</h4>
        <h2 class="title">Instant Reporting & Remote Access</h2>
        <p class="description">
          Access all diagnostic reports, training materials, and system notifications instantly from your mobile device.
        </p>
      </div>

      <div class="features-grid">
        <!-- Quick Report Access -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M10 21h4a2 2 0 002-2V5a2 2 0 00-2-2h-4a2 2 0 00-2 2v14a2 2 0 002 2zM7 5h10M7 19h10" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Quick Report Access</h3>
            <p class="block-description">Instantly reach all diagnostic reports.</p>
          </div>
        </div>

        <!-- Mobile Access to Training -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M4 19.5A2.5 2.5 0 016.5 17H20v2H6.5a2.5 2.5 0 01-2.5-2.5zM4 5v12h16V5H4zm2-2h12a2 2 0 012 2v12a2 2 0 01-2 2H6a2 2 0 01-2-2V5a2 2 0 012-2z" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Training Materials</h3>
            <p class="block-value"><span class="highlight">100%</span> Mobile Access</p>
          </div>
        </div>

        <!-- Real-time Notifications -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M18 8A6 6 0 006 8c0 7-3 9-3 9h18s-3-2-3-9zM13.73 21a2 2 0 01-3.46 0" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Real-time Notifications</h3>
            <p class="block-value"><span class="highlight">+50</span> Alert Types</p>
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
		max-width: 1100px;
		min-height: 500px;
		display: grid;
		grid-template-columns: 0.7fr 1.3fr;
		background-color: var(--bg-light-navy);
		border: 1px solid var(--border-color);
		box-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
		transition: box-shadow 0.3s ease;
	}
	.module-panel:hover {
		box-shadow: 0 0 50px rgba(100, 255, 218, 0.15);
	}

	/* Ters Yerleşim Sınıfı */
	.module-panel.layout-reversed .image-pane {
		grid-column: 2;
	}
	.module-panel.layout-reversed .content-pane {
		grid-column: 1;
		border-left: none;
		border-right: 1px solid var(--border-color);
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

	/* RESPONSIVE AYARLAR */
	@media (max-width: 1024px) {
		.module-view-section {
			min-height: auto;
			padding: 4rem 1rem;
		}
		.module-panel, .module-panel.layout-reversed {
			grid-template-columns: 1fr; /* Tablet ve altında tek sütuna düşür */
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
			border-right: none; /* Gereksiz kenarlıkları kaldır */
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