<script lang="ts">
	import { fade } from 'svelte/transition';

	type SpecCategory = 'functional' | 'electronic' | 'mechanical';
	let activeTab: SpecCategory = 'functional';

	const specs = {
		functional: [
			{ label: 'Yapay Zeka', value: 'Test ve analiz' },
			{ label: 'Asistan', value: 'Tamir öncesi tahmin' },
			{ label: 'Co-pilot', value: 'Tamir aşamalarında yönlendirme' },
			{ label: 'Testler', value: 'EBS, APM, Euro 4/5/6 (Euro 7 uyumlu), Şanzıman ve Elektromekanik testler' },
			{ label: 'Kontroller', value: 'Otomatik, Yarı Otomatik, Manuel pnömatik kontroller' },
			{ label: 'Senaryo Geliştirme', value: 'Test senaryoları geliştirebilme' },
			{ label: 'Kullanıcı Senaryoları', value: 'Sınırsız kullanıcı senaryosu ekleyebilme' },
			{ label: 'Güncelleme', value: 'Otomatik güncelleme' }
		],
		electronic: [
			{ label: 'İşlemci', value: '1 dual core (550Mhz), 5 single core (240Mhz x 5) ARM işlemci' },
			{ label: 'Algılama', value: '40 sensör ile algılama (5V/24VDC)' },
			{ label: 'Selenoid Kontrolü', value: '6 selenoid giriş çıkış kontrolü (kuru kontak 10A)' },
			{ label: 'Oransal Selenoid', value: '6 oransal selenoid kontrolü (4-20mA, 0-10V)' },
			{ label: 'Ethernet', value: '1 Automotive Ethernet 10/100Mbit 1 twisted pair' },
			{ label: 'CanBus', value: '3 x CanBus (1Mbit Max)' },
			{ label: 'FDCAN BUS', value: 'Dual FDCAN BUS (8Mbit Max)' },
			{ label: 'LinBUS', value: 'LinBUS (9600,19200bps)' },
			{ label: 'Wi-Fi', value: 'Wi-Fi 802.11 b/g/n' },
			{ label: 'Bluetooth', value: 'Bluetooth 5.1' },
			{ label: 'Güç Kaynağı', value: '0-30V/5A yazılım kontrollü kısa güç kaynağı' }
		],
		mechanical: [
			{ label: 'Boyutlar', value: '120x75x55 cm' },
			{ label: 'Ağırlık', value: '155 Kg (servis aracında taşınabilir)' },
			{ label: 'Hava Basıncı', value: '15.5 bar max hava basıncı' },
			{ label: 'Hava Tankı', value: '3 adet 8 lt hava tankı' },
			{ label: 'Acil Durum', value: '1 adet acil durum butonu' },
			{ label: 'Durum Işığı', value: '1 adet durum ışığı' },
			{ label: 'Ses', value: '1 mikrofon, 2 hoparlör' }
		]
	};
</script>

<section class="specs-section">
	<div class="specs-container">
		<!-- Sol Taraf: Ürün Görseli -->
		<div class="image-wrapper">
			<img
				src="./img/mainorion2.png"
				alt="HVD-AI-ORION Ağır Vasıta Diagnostik Sistemi"
				class="product-image"
			/>
		</div>

		<!-- Sağ Taraf: Teknik Özellikler -->
		<div class="content-wrapper">
			<h2 class="section-title">Teknik Özellikler</h2>

			<!-- Sekme Navigasyonu -->
			<div class="tabs-nav">
				<button
					class:active={activeTab === 'functional'}
					on:click={() => (activeTab = 'functional')}>Fonksiyonel</button
				>
				<button
					class:active={activeTab === 'electronic'}
					on:click={() => (activeTab = 'electronic')}>Elektronik</button
				>
				<button
					class:active={activeTab === 'mechanical'}
					on:click={() => (activeTab = 'mechanical')}>Mekanik</button
				>
			</div>

			<!-- Sekme İçeriği -->
			<div class="tabs-content">
				{#key activeTab}
					<div class="spec-list" in:fade={{ duration: 300 }}>
						{#each specs[activeTab] as item}
							<div class="spec-item">
								<div class="spec-label">{item.label}</div>
								<div class="spec-value">{item.value}</div>
							</div>
						{/each}
					</div>
				{/key}
			</div>
		</div>
	</div>
</section>

<style>
	/* Değişkenler ve genel stiller */
	:root {
		--bg-dark: #0d1a2e;
		--bg-medium: #1a2b42; /* Biraz daha koyu bir orta ton */
		--border-color: #2a477b;
		--text-light: #e0e6f1;
		--text-medium: #a8b9cd; /* Daha kontrastlı bir orta ton */
		--accent-color: #38bdf8; /* Canlı bir mavi tonu */
		--font-heading: 'Poppins', sans-serif; /* Modern ve profesyonel başlık fontu */
		--font-body: 'Inter', sans-serif; /* Okunabilir body fontu */
		--spacing-unit: 0.75rem; /* Tutarlı boşluklar için bir birim */
	}

	.specs-section {
		background-color: var(--bg-dark);
		color: var(--text-light);
		padding: 2rem 2rem; /* Daha geniş dikey boşluk */
		font-family: var(--font-body);
	}

	.specs-container {
		display: grid;
		grid-template-columns: 1fr 1.5fr; /* Sağ sütun daha geniş */
		max-width: 1800px; /* Daha geniş max-width */
		margin: 0 auto;
		background-color: var(--bg-medium);
		border-radius: 12px; /* Köşeleri biraz daha az yuvarlak */
		overflow: hidden;
		border: 1px solid var(--border-color);
		box-shadow: 0 10px 30px rgba(0, 0, 0, 0.4); /* Daha az belirgin ama var olan bir gölge */
	}

	/* Sol Taraf: Görsel */
	.image-wrapper {
		display: flex;
		height: 85%;
		align-items: center;
		justify-content: center;
		padding: 0; /* Daha fazla padding */
		background-color: #122138; /* Görsel için biraz daha koyu bir arka plan */
		position: relative;
		overflow: hidden; /* Taşmaları engelle */
	}

	.product-image {
		max-width:100%;
		
		height: auto;
		object-fit: contain;
		display: block; /* Gereksiz boşlukları kaldırır */
	}

	/* Sağ Taraf: İçerik */
	.content-wrapper {
		padding: 3.5rem 2rem; /* Daha fazla padding */
		display: flex;
		flex-direction: column;
	}

	.section-title {
		font-family: var(--font-heading);
		font-size: 2.8rem; /* Daha büyük başlık */
		font-weight: 700;
		margin: 0 0 1.5rem 0; /* Başlık alt boşluğu azaltıldı */
		line-height: 1.2;
		color: var(--text-light);
		text-align: left;
	}

	/* Sekme Navigasyonu */
	.tabs-nav {
		display: flex;
		border-bottom: 1px solid var(--border-color); /* Daha ince bir ayırıcı */
		margin-bottom: 0.5rem;
		gap: var(--spacing-unit); /* Butonlar arası boşluk */
	}

	.tabs-nav button {
		font-family: var(--font-heading);
		font-size: 0.95rem; /* Hafif küçültülmüş font */
		font-weight: 600;
		padding: var(--spacing-unit) calc(var(--spacing-unit) * 1.5); /* Optimize edilmiş padding */
		border: none;
		background: none;
		color: var(--text-medium);
		cursor: pointer;
		position: relative;
		transition: color 0.3s ease, border-color 0.3s ease;
		border-bottom: 3px solid transparent;
		margin-bottom: -1px; /* Çizgiyle çakışmayı önler */
		text-transform: uppercase; /* Daha profesyonel görünüm */
		letter-spacing: 0.5px;
	}

	.tabs-nav button:hover {
		color: var(--text-light);
	}

	.tabs-nav button.active {
		color: var(--accent-color);
		border-bottom-color: var(--accent-color);
	}

	/* Sekme İçeriği */
	.tabs-content {
		flex: 1;
		overflow-y: auto;
		max-height: 450px; /* Maksimum yükseklik artırıldı */
		padding-right: var(--spacing-unit); /* Scrollbar için sağa boşluk */
		/* Scrollbar stilleri aynı kaldı, modern ve işlevsel */
	}

	.spec-list {
		display: flex;
		flex-direction: column;
		gap: 0; /* Boşluklar spec-item içinde yönetilecek */
		
	}

	.spec-item {
		display: grid;
		grid-template-columns: 1.2fr 2.5fr; /* Etiket daha dar, değer daha geniş */
		gap: 1rem; /* Daha az boşluk */
		padding: var(--spacing-unit) 0; /* Daha az dikey padding */
		border-bottom: 1px dashed rgba(255, 255, 255, 0.08); /* Yumuşak bir kesik çizgi */
		align-items: flex-start; /* Etiket ve değeri üste hizala */
	}

	.spec-item:last-child {
		border-bottom: none;
	}

	.spec-label {
		font-weight: 600; /* Daha kalın etiket */
		color: var(--text-medium);
		font-size: 0.85rem; /* Biraz küçültülmüş font */
		white-space: nowrap; /* Etiketin tek satırda kalmasını sağlar */
		text-overflow: ellipsis; /* Taşarsa üç nokta koyar */
		overflow: hidden;
		padding-right: var(--spacing-unit); /* Değerden ayrılması için */
		line-height: 0.85rem;
	}

	.spec-value {
		color: var(--text-light);
		line-height: 0.5;
		
		 /* Okunurluğu artırmak için line-height */
		font-size: 0.9rem; /* Biraz küçültülmüş font */
		font-weight: 400;
		justify-content: center;
	}

	/* Duyarlı Tasarım */
	@media (max-width: 1200px) {
		.specs-container {
			grid-template-columns: 0.7fr 1.3fr;
			max-width: 1000px;
		}
		.content-wrapper {
			padding: 0.2rem;
		}
		.section-title {
			font-size: 2.2rem;
		}
	}

	@media (max-width: 1024px) {
		.specs-section {
			padding: 1rem 1rem;
		}
		.specs-container {
			grid-template-columns: 1fr; /* Tablet ve altında tek sütunlu yapı */
			max-width: 768px;
		}
		.image-wrapper {
			padding: 0.5rem;
			border-bottom: 1px solid var(--border-color);
		}
		.content-wrapper {
			padding: 1.5rem;
		}
		.section-title {
			font-size: 2rem;
			margin-bottom: 1.2rem;
		}
		.tabs-content {
			max-height: 400px; /* Daha küçük ekranlarda biraz kısalt */
		}
		.tabs-nav button {
			font-size: 0.85rem;
			padding: 0.1rem 0.5rem;
		}
	}

	@media (max-width: 768px) {
		.specs-section {
			padding: 2.5rem 1rem;
		}
		.content-wrapper {
			padding: 2rem 1rem;
		}
		.section-title {
			font-size: 1.8rem;
		}
		.tabs-nav {
			flex-wrap: wrap; /* Butonlar alta geçebilir */
			justify-content: center;
			gap: 0.5rem;
			margin-bottom: 1.5rem;
		}
		.tabs-nav button {
			flex: auto; /* Esnek buton genişliği */
			min-width: unset;
			font-size: 0.8rem;
			padding: 0.5rem 0.8rem;
		}
		.spec-item {
			grid-template-columns: 1fr; /* Mobilde etiket ve değer alt alta gelsin */
			gap: 0.2rem; /* Daha az boşluk */
			padding: 0.7rem 0;
			border-bottom: 1px dashed rgba(255, 255, 255, 0.05); /* Daha hafif çizgi */
		}
		.spec-label {
			color: var(--accent-color); /* Mobilde etiket vurgulu */
			font-size: 0.85rem;
			font-weight: 700; /* Mobilde etiket daha kalın */
		}
		.spec-value {
			font-size: 0.85rem;
		}
		.tabs-content {
			max-height: 300px; /* En küçük ekranlarda daha da kısalt */
		}
	}
</style>