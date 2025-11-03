<style>

	:global(:root) {
		--primary-color: #ff4500; /* Markanın ana rengi (koyu turuncu) */
		--secondary-color: #000000; /* İkincil renk, örneğin metinlerde */
		--text-dark: #2d3748; /* Koyu metin rengi */
		--text-light: #f0f0f0; /* Açık metin rengi */
		--bg-light: #ffffff; /* Açık arka plan rengi */
		--bg-dark: #000000; /* Koyu arka plan rengi*/
		--border-color: #e2e8f0; /* Genel çerçeve rengi */
		--shadow-color: rgba(0, 0, 0, 0.1); /* Gölge rengi */

		/* Font Ailesi */
		--font-family-sans: 'Roboto','Inter', sans-serif;
	}

	/* --- GENEL SIFIRLAMA VE TEMEL STİLLER --- */
	:global(body) {
		margin: 0;
		padding: 0;
		font-family: var(--font-family-sans);
		color: var(--text-dark);
		background-color: var(--bg-light);
		line-height: 1.6;
		-webkit-font-smoothing: antialiased;
		-moz-osx-font-smoothing: grayscale;
	}

	:global(h1, h2, h3, h4, h5, h6) {
		margin-top: 0;
		margin-bottom: 0.5em;
		font-weight: 700;
		line-height: 1.2;
		color: var(--secondary-color);
	}

	:global(p) {
		margin-top: 0;
		margin-bottom: 1em;
	}

	:global(a) {
		text-decoration: none;
		color: var(--primary-color);
	}

	:global(img) {
		max-width: 100%;
		height: auto;
		display: block;
	}

	/* Genel konteyner stilini tanımlayabiliriz */
	:global(.content-container) {
		max-width: 1200px;
		margin: 0 auto;
		padding: 0 1.5rem; /* Yan boşluklar */
	}

	/* Geçiş Gradianları için genel bir stil */
	:global(.gradient-transition) {
		width: 100%;
		height: 150px; /* Geçişin yüksekliği */
		background: linear-gradient(to bottom, var(--bg-dark), var(--bg-light)); /* Siyahtan beyaza */
		display: block;
	}
</style>