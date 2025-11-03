<section class="hero-section">
	<div class="background-container">
		<!-- Background image -->
		<img src="/img/orionmain8.png" alt="HVD-AI ORION Background" class="bg-image" />
	</div>

	<div class="content-wrapper">
		<div class="main-info-block">
			<h1>HVD-AI<br />ORION</h1>
			<p class="tagline">
				Accelerates fault detection with patented AI technology. <br />
				Delivers high efficiency and reliable maintenance solutions for businesses.
			</p>
			<div class="feature-list-block">
				<div class="feature-item">
					<span class="icon">⚡</span>
					<p>AI-powered Testing & Analysis</p>
				</div>
				<div class="feature-item">
					<span class="icon">💡</span>
					<p>Pre-repair Predictions with Assistant</p>
				</div>
				<div class="feature-item">
					<span class="icon">🧭</span>
					<p>Guidance During Repairs with Co-pilot</p>
				</div>
			</div>
		</div>
	</div>
</section>
<style>
	@import url('https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700;900&display=swap');

	:root {
		--primary-bg: #0b1523; /* Daha koyu lacivert */
		--secondary-bg: #152238; /* Koyu lacivert */
		--text-light: #e6eefc; /* Çok açık gri */
		--text-muted: #a0aec0; /* Gri ton */
		--text-accent: #4a90e2; /* Modern orta mavi */
		--button-main: #2d73f1; /* Canlı mavi */
		--button-hover: #1e5ac8; /* Daha koyu canlı mavi */
		--border-color: rgba(255, 255, 255, 0.15); /* Hafif belirgin border */
		--font-family-sans: 'Lato', sans-serif;
		--hero-height: 90vh; /* Modern yükseklik */
	}

	:global(body, html) {
		margin: 0;
		padding: 0;
		box-sizing: border-box;
		font-family: var(--font-family-sans);
		background-color: var(--primary-bg);
		color: var(--text-light);
		line-height: 1.6;
		overflow-x: hidden;
		-webkit-font-smoothing: antialiased;
		-moz-osx-font-smoothing: grayscale;
	}

	.hero-section {
		width: 100%;
		min-height: var(--hero-height);
		position: relative;
		display: flex;
		align-items: center;
		justify-content: center; /* İçeriği ortala */
		padding: 40px 20px;
		overflow: hidden;
	}

	.background-container {
		position: absolute;
		top: 0;
		left: 0;
		width: 100%;
		height: 100%;
		z-index: 0;
		background-color: var(--primary-bg);
	}

	.bg-image {
		width: 100%;
		height: 100%;
		object-fit: cover;
		object-position: center;
		/* DEĞİŞİKLİK 1: Resmin net gözükmesi için opaklık 1 yapıldı. */
		opacity: 1; 
	}

	.content-wrapper {
		position: relative;
		z-index: 10;
		display: flex;
		flex-direction: row;
		gap: 40px; /* Daha fazla boşluk */
		max-width: 1280px; /* Maksimum genişlik artırıldı */
		width: 100%;
		padding: 0%; /* İç dolgu artırıldı */
		align-items: center; /* Dikeyde ortala */
		justify-content: space-between; /* İçeriği yay */
	}

	.main-info-block {
		flex: 0 0 55%; /* Ekranın %55'ini kapla */
		max-width: 700px; /* Maksimum genişlik */
		display: flex;
		flex-direction: column;
		justify-content: center;
		text-align: left;
	}

	.main-info-block h1 {
		font-size: 5.2rem; /* Daha büyük başlık */
		font-weight: 900; /* Daha kalın */
		line-height: 1.0;
		margin: 0 0 1.5rem 0;
		color: var(--text-light);
		letter-spacing: -3px;
		/* DEĞİŞİKLİK 2: Yazının her türlü arka planda okunması için gölge eklendi. */
		text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.7);
	}

	.main-info-block .tagline {
		font-size: 1.45rem; /* Daha belirgin tagline */
		font-weight: 300;
		line-height: 1.7;
		margin: 0 0 3.5rem 0;
		color: var(--text-muted); /* Daha yumuşak metin rengi */
		max-width: 100%;
		/* DEĞİŞİKLİK 3: Yazının her türlü arka planda okunması için gölge eklendi. */
		text-shadow: 1px 1px 6px rgba(0, 0, 0, 0.8);
	}

	.call-to-action-button {
		display: inline-flex; /* Flexbox ile daha iyi hizalama */
		align-items: center;
		justify-content: center;
		background: transparent;
		color: var(--button-main);
		border: 1px solid var(--button-main); /* Buton için çerçeve */
		font-size: 1.15rem;
		font-weight: 700;
		padding: 1rem 2.5rem; /* Daha büyük padding */
		text-decoration: none;
		transition: all 0.3s ease;
		position: relative;
		letter-spacing: 0.8px;
		text-transform: uppercase;
		border-radius: 8px; /* Köşeleri yuvarlat */
		max-width: fit-content;
		box-shadow: 0 4px 15px rgba(0, 115, 255, 0.2); /* Hafif gölge */
	}

	.call-to-action-button:hover {
		background-color: var(--button-main);
		color: var(--text-light);
		box-shadow: 0 6px 20px rgba(0, 115, 255, 0.4);
		transform: translateY(-2px);
	}

	.call-to-action-button::after {
		display: none;
	}

	.feature-list-block {
		flex: 0 0 40%; /* Ekranın %40'ını kapla */
		display: flex;
		flex-direction: column;
		justify-content: center;
		gap: 35px; /* Daha fazla boşluk */
		margin-top: 0; /* Margin kaldırıldı */
		padding-left: 50px; /* Padding artırıldı */
		border-left: 1px solid var(--border-color);
	}

	.feature-item {
		display: flex;
		align-items: flex-start; /* Başlangıca hizala */
		gap: 20px;
	}

	.feature-item .icon {
		font-size: 2.5rem; /* Daha büyük ikon */
		line-height: 1;
		color: var(--text-accent);
		flex-shrink: 0;
	}

	.feature-item p {
		font-size: 1.35rem; /* Daha belirgin metin */
		font-weight: 400;
		margin: 0;
		color: var(--text-light); /* İkonla aynı renk yerine beyaz metin */
		letter-spacing: 0.5px;
		/* DEĞİŞİKLİK 4: Yazının her türlü arka planda okunması için gölge eklendi. */
		text-shadow: 1px 1px 4px rgba(0, 0, 0, 0.7);
	}

	/* Responsive Düzenlemeler */
	@media (max-width: 1024px) {
		.content-wrapper {
			flex-direction: column;
			gap: 50px; /* Daha fazla boşluk */
			padding: 20px;
			align-items: center;
			justify-content: flex-start; 
			
		}

		.hero-section {
			justify-content: center;
		}

		.main-info-block {
			flex: 0 0 auto;
			max-width: 90%;
			width: 100%;
			text-align:left;
			align-items: flex-start;
		}

		.main-info-block h1 {
			font-size: 4.2rem;
			letter-spacing: -2px;
		}

		.main-info-block .tagline {
			font-size: 1.25rem;
			max-width: 700px;
			margin-bottom: 2.5rem;
		}

		.call-to-action-button {
			padding: 0.9rem 2rem;
			font-size: 1.05rem;
		}

		.feature-list-block {
			padding-left: 0;
			border-left: none;
			border-top: 1px solid var(--border-color);
			padding-top: 50px;
			align-items: center; /* Ortala */
			width: 100%;
			max-width: 90%;
			text-align: center;
		}
		.feature-item {
			justify-content: center; /* Ortala */
			width: 100%;
			max-width: 400px; /* Özellik öğelerini daha dar tut */
		}
		.feature-item .icon {
			font-size: 2.2rem;
		}
		.feature-item p {
			font-size: 1.2rem;
			text-align: left; /* Metni sola hizalı tut */
		}
	}

	@media (max-width: 768px) {
		:root {
			--hero-height: 100vh;
		}
		.hero-section {
			padding: 20px 15px;
		}
		.content-wrapper {
			padding: 25px;
			gap: 40px;
		}
		.main-info-block h1 {
			font-size: 3.2rem;
			line-height: 1.1;
		}
		.main-info-block .tagline {
			font-size: 1.05rem;
			margin-bottom: 2rem;
		}
		.call-to-action-button {
			padding: 0.8rem 1.8rem;
			font-size: 1rem;
		}
		.feature-list-block {
			padding-top: 30px;
			gap: 25px;
		}
		.feature-item .icon {
			font-size: 1.9rem;
		}
		.feature-item p {
			font-size: 1.1rem;
		}
	}

	@media (max-width: 480px) {
		.main-info-block h1 {
			font-size: 2.5rem;
			letter-spacing: -1px;
		}
		.main-info-block .tagline {
			font-size: 0.9rem;
			margin-bottom: 1.5rem;
		}
		.call-to-action-button {
			padding: 0.7rem 1.5rem;
			font-size: 0.9rem;
		}
		.feature-item {
			flex-direction: column; /* Küçük ekranlarda ikon ve metni alt alta getir */
			align-items: center; /* Ortala */
			text-align: center;
			gap: 10px;
		}
		.feature-item p {
			font-size: 1rem;
		}
	}
</style>