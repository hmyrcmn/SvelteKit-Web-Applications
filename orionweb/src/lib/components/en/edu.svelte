<section class="module-view-section">
  <div class="module-panel layout-reversed">
    <!-- Left Column: Content -->
    <div class="content-pane">
      <div class="content-header">
        <h4 class="subtitle">MODULE ANALYSIS: HVD-AI EDU</h4>
        <h2 class="title">Interactive Training Module</h2>
        <p class="description">
          An interactive learning platform designed to provide users full mastery of the system and fault diagnosis methods.
        </p>
      </div>

      <div class="features-grid">
        <!-- Interactive Content -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M4.26 10.147a60.436 60.436 0 00-.491 6.347A48.627 48.627 0 0112 20.904a48.627 48.627 0 018.232-4.41 60.46 60.46 0 00-.491-6.347m-15.482 0a50.57 50.57 0 00-2.658-.813A59.905 59.905 0 0112 3.493a59.902 59.902 0 0110.399 5.84c-.896.248-1.783.52-2.658.814m-15.482 0A50.697 50.697 0 0112 13.489a50.702 50.702 0 017.74-3.342M6.75 15a.75.75 0 100-1.5.75.75 0 000 1.5z" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Interactive Content</h3>
            <p class="block-description">Learning through simulations and practical scenarios.</p>
          </div>
        </div>

        <!-- Knowledge Transfer -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M12 16.5V9.75m0 0l3 3m-3-3l-3 3M6.75 19.5a4.5 4.5 0 01-1.41-8.775 5.25 5.25 0 0110.233-2.33 3 3 0 013.758 3.848A3.752 3.752 0 0118 19.5H6.75z" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Knowledge Transfer</h3>
            <p class="block-value"><span class="highlight">100%</span> Access</p>
          </div>
        </div>

        <!-- Learning Progress Tracking -->
        <div class="feature-block">
          <div class="block-icon">
            <svg viewBox="0 0 24 24"><path d="M3 13.125C3 12.504 3.504 12 4.125 12h2.25c.621 0 1.125.504 1.125 1.125v6.75C7.5 20.496 6.996 21 6.375 21h-2.25A1.125 1.125 0 013 19.875v-6.75zM9.75 8.625c0-.621.504-1.125 1.125-1.125h2.25c.621 0 1.125.504 1.125 1.125v11.25c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V8.625zM16.5 4.125c0-.621.504-1.125 1.125-1.125h2.25C20.496 3 21 3.504 21 4.125v15.75c0 .621-.504 1.125-1.125 1.125h-2.25a1.125 1.125 0 01-1.125-1.125V4.125z" /></svg>
          </div>
          <div class="block-content">
            <h3 class="block-title">Learning Progress Tracking</h3>
            <p class="block-value"><span class="highlight">+50</span> items</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Right Column: Image -->
    <div class="image-pane">
      <img src="/img/tt.png" alt="HVD-AI Edu training interface" class="feature-image" />
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
		grid-template-columns: 1.3fr 0.7fr;
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