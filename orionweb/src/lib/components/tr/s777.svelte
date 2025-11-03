<script lang="ts">
	import { fade } from 'svelte/transition';

	let activeTab = 'Fonksiyonel ve Yazılım Özellikleri';

	// Veri yapısına ikon SVG yollarını ekledik.
	const tabContent = {
		'Fonksiyonel ve Yazılım Özellikleri': {
			icon: 'M21 7.5l-2.25-1.313M21 7.5v2.25m0-2.25l-2.25 1.313M3 7.5l2.25-1.313M3 7.5v2.25m0-2.25l2.25 1.313M9 12l2.25-1.313M15 12l-2.25-1.313M12 3.75l-2.25 1.313M12 3.75l2.25 1.313M3 16.5l2.25-1.313M3 16.5v2.25m0-2.25l2.25 1.313m18 0l-2.25-1.313m-13.5 0v2.25m0-2.25l2.25 1.313M9 12l-2.25 1.313M15 12l2.25 1.313M12 20.25l-2.25-1.313M12 20.25l2.25-1.313',
			image: './img/fonk.png',
			features: [
				'HVD-AI yazılım platformu ile gerçek zamanlı araç teşhisi.',
				'Yapay Zeka: Test ve analiz, Asistan (Tamir öncesi tahmin), Co-pilot (Tamir aşamalarında yönlendirme).',
				'Geçmiş arıza kayıtlarını analiz ederek bakım önerileri sunar.',
				'Otomatik veri raporlama ve PDF/Excel formatında çıktı alma.',
				'Senaryo Geliştirme: Test senaryoları ve kullanıcı tarafından sınırsız senaryo ekleme.',
				'Otomatik ve merkezi yazılım güncellemeleri.',
				'Sezgisel dokunmatik arayüz, çoklu dil desteği.'
			]
		},
		'Test ve Analiz Kapasitesi': {
			icon: 'M3.75 12h16.5m-16.5 3.75h16.5M3.75 19.5h16.5M5.625 4.5h12.75a1.875 1.875 0 010 3.75H5.625a1.875 1.875 0 010-3.75z',
			image: './img/co.png',
			features: [
				'Motor elektronik kontrol ünitesi (ECU) okuma ve kod temizleme.',
				'ABS, EBS ve şanzıman sistemleri dahil elektronik sistem testi.',
				'Elektromekanik sistemler ve sensör arızalarının tespiti.',
				'Can bus üzerinden detaylı veri akışı analizi.',
				'Arıza kodlarını otomatik tanımlama ve çözüm önerileri.',
				'AI destekli algoritmalar ile tahmine dayalı analiz.',
				'Sistem uyarıları ve risk analizi modülü.'
			]
		},
		'Elektronik Özellikler ve Bağlantı': {
			icon: 'M9 17.25v1.007a3 3 0 01-.879 2.122L7.5 21h9l-1.621-.87a3 3 0 01-.879-2.122v-1.007m5.207-4.012a5.25 5.25 0 01-1.162.986c-.527.29-1.124.52-1.764.693a6 6 0 00-3.286 3.286c-.173.64-.396 1.24-.693 1.764a5.25 5.25 0 01-.986 1.162A4.5 4.5 0 0112 21.75a4.5 4.5 0 01-2.437-1.007 5.25 5.25 0 01-1.162-.986c-.29-.527-.52-1.124-.693-1.764a6 6 0 00-3.286-3.286c-.64-.173-1.24-.396-1.764-.693a5.25 5.25 0 01-.986-1.162A4.5 4.5 0 012.25 12c0-.92.26-1.79.73-2.563a5.25 5.25 0 011.162-.986c.527-.29 1.124-.52 1.764-.693a6 6 0 003.286-3.286c.173-.64.396-1.24.693-1.764a5.25 5.25 0 01.986-1.162A4.5 4.5 0 0112 2.25c.92 0 1.79.26 2.563.73a5.25 5.25 0 011.162.986c.29.527.52 1.124.693 1.764a6 6 0 003.286 3.286c.64.173 1.24.396 1.764.693a5.25 5.25 0 01.986 1.162A4.5 4.5 0 0121.75 12c0 .92-.26 1.79-.73 2.563z',
			image: './img/cld.png',
			features: [
				'İşlemci: 1x dual core (550Mhz), 5x single core (240Mhz) ARM.',
				'Algılama: 40 sensör girişi (5V/24VDC).',
				'Kontrol: 6x selenoid (10A), 6x oransal selenoid (4-20mA, 0-10V).',
				'Bağlantı: Automotive Ethernet, 6x CanBus, Dual FDCAN, LinBUS.',
				'Kablosuz: Wi-Fi 802.11 b/g/n, Bluetooth 5.1.',
				'Güç Kaynağı: 0-30V/5A yazılım kontrollü güç çıkışı.',
				'Bulut tabanlı veri kaydı ve araç geçmişi yönetimi.'
			]
		},
		'Mekanik ve Donanım Özellikleri': {
			icon: 'M3.75 3.75v4.5m0-4.5h4.5m-4.5 0L9 9M3.75 20.25v-4.5m0 4.5h4.5m-4.5 0L9 15M20.25 3.75v4.5m0-4.5h-4.5m4.5 0L15 9m5.25 11.25v-4.5m0 4.5h-4.5m4.5 0L15 15',
			image: './img/assis.png',
			features: [
				'Boyutlar: 120x75x55 cm, Ağırlık: 155 Kg (servis aracında taşınabilir).',
				'Hava: 15.5 bar max basınç, 3 x 8 lt hava tankı.',
				'Güvenlik: Acil durum butonu ve operasyonel durum ışığı.',
				'Arayüz: 1 mikrofon, 2 hoparlör, yüksek çözünürlüklü dokunmatik ekran.',
				'Gövde: Endüstriyel dayanıklılığa sahip, modüler ve taşınabilir tasarım.',
				'Patentli teknoloji (TR2023015406).'
			]
		}
	};
</script>

<section class="specs-section">
	<div class="container">
		<div class="section-header">
			<h4 class="subtitle"></h4>
			<h2 class="title">Detaylı Teknik Özellikler</h2>
		</div>

		<!-- Mobil Navigasyon: Açılır Menü -->
		<div class="mobile-nav">
			<select bind:value={activeTab}>
				{#each Object.keys(tabContent) as tab}
					<option value={tab}>{tab}</option>
				{/each}
			</select>
		</div>

		<div class="specs-panel">
			<!-- Masaüstü Navigasyon: Kenar Çubuğu -->
			<div class="tabs-sidebar">
				{#each Object.keys(tabContent) as tab}
					<button class="tab-button" class:active={activeTab === tab} on:click={() => (activeTab = tab)}>
						<svg viewBox="0 0 24 24" class="tab-icon"><path d={tabContent[tab].icon} /></svg>
						<span>{tab}</span>
					</button>
				{/each}
			</div>

			<!-- İçerik Alanı -->
			<div class="content-area">
				{#key activeTab}
					<div class="content-inner" in:fade={{ duration: 300 }}>
						<div class="image-wrapper">
							<img src={tabContent[activeTab].image} alt={activeTab} class="feature-image" />
						</div>
						<ul class="features-list">
							{#each tabContent[activeTab].features as feature}
								<li>
									<svg class="feature-icon" viewBox="0 0 24 24"><path d="M9 12.75L11.25 15 15 9.75M21 12a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
									<span>{feature}</span>
								</li>
							{/each}
						</ul>
					</div>
				{/key}
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

	.specs-section {
		padding: 6rem 1.5rem;
		background-color: var(--bg-dark-navy);
	}
	.container { max-width: 1200px; margin: 0 auto; }

	.section-header { text-align: center; margin-bottom: 3rem; }
	.subtitle { color: var(--accent-cyan); font-family: 'Roboto Mono', monospace; }
	.title { font-size: 2.75rem; font-weight: 700; color: var(--text-lightest); margin-top: 0.5rem; }

	.mobile-nav { display: none; margin-bottom: 1.5rem; }
	.mobile-nav select {
		width: 100%;
		padding: 0.75rem 1rem;
		background-color: var(--bg-light-navy);
		color: var(--text-light);
		border: 1px solid var(--border-color);
		border-radius: 4px;
		font-size: 1rem;
	}

	.specs-panel {
		display: grid;
		grid-template-columns: 300px 1fr;
		background-color: var(--bg-light-navy);
		border: 1px solid var(--border-color);
		min-height: 600px;
	}

	.tabs-sidebar {
		border-right: 1px solid var(--border-color);
		padding: 1.5rem 0;
	}
	.tab-button {
		display: flex;
		align-items: center;
		width: 100%;
		padding: 1rem 1.5rem;
		text-align: left;
		background: none;
		border: none;
		border-left: 3px solid transparent;
		color: var(--text-dark);
		font-size: 0.95rem;
		cursor: pointer;
		transition: all 0.3s ease;
	}
	.tab-button:hover {
		background-color: rgba(100, 255, 218, 0.05);
		color: var(--text-light);
	}
	.tab-button.active {
		background-color: rgba(100, 255, 218, 0.1);
		color: var(--accent-cyan);
		border-left-color: var(--accent-cyan);
	}
	.tab-icon {
		width: 20px;
		height: 20px;
		margin-right: 1rem;
		stroke: currentColor;
		stroke-width: 1.5;
		fill: none;
		flex-shrink: 0;
	}

	.content-area { padding: 2rem; }
	.image-wrapper {
		margin-bottom: 2rem;
		border-radius: 4px;
		overflow: hidden;
		border: 1px solid var(--border-color);
	}
	.feature-image { width: 100%; display: block; }

	.features-list { list-style: none; padding: 0; margin: 0; }
	.features-list li {
		display: flex;
		align-items: flex-start;
		color: var(--text-light);
		font-size: 1rem;
		line-height: 1.6;
		margin-bottom: 1rem;
	}
	.feature-icon {
		width: 20px;
		height: 20px;
		margin-right: 0.75rem;
		color: var(--accent-cyan);
		stroke-width: 2;
		fill: var(--accent-cyan);
		stroke: var(--bg-light-navy);
		flex-shrink: 0;
		margin-top: 2px;
	}

	@media (max-width: 992px) {
		.tabs-sidebar { display: none; }
		.mobile-nav { display: block; }
		.specs-panel { grid-template-columns: 1fr; }
		.content-area { padding: 1.5rem; }
		.title { font-size: 2.25rem; }
	}

	@media (max-width: 576px) {
		.specs-section { padding: 4rem 1rem; }
		.title { font-size: 1.8rem; }
	}
</style>