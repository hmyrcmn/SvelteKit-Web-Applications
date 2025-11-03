<script>
	import { Swiper, SwiperSlide } from 'swiper/svelte';
	import 'swiper/css';
	import 'swiper/css/autoplay';
	import SwiperCore, { Autoplay } from 'swiper';
	import { browser } from '$app/environment';

	SwiperCore.use([Autoplay]);

	const items = [
		{
			title: '🚛 HVD-AI ORION',
			desc: 'An advanced diagnostic system designed for heavy-duty vehicles. Detects engine, electronic, and communication errors.',
			src: '/img/main2.png'
		},
		{
			title: '⚙️ 100Base-T1 PHY Support',
			desc: 'Supports 100Base-T1 PHY physical layer components used in automotive Ethernet communication.',
			src: '/img/car.png'
		},
		{
			title: '🧩 MAC and PHY Layers',
			desc: 'MAC (Media Access Control) manages data transmission, while PHY (Physical Layer) ensures secure and fast data transfer over the physical medium.',
			src: '/img/eduh4.png'
		},
		{
			title: '🛠️ Diagnostic Functions',
			desc: 'Provides diagnostic functions for quick detection of faults in engine and electronic systems.',
			src: '/img/v1.png'
		},
		{
			title: '📊 Data Logging and Analysis',
			desc: 'Enables real-time data collection, logging, and analysis.',
			src: '/img/ebs2.PNG'
		},
		{
			title: '📊 Data Logging and Analysis',
			desc: 'Enables real-time data collection, logging, and analysis.',
			src: '/img/apm.PNG'
		},
		{
			title: '📄 Patented Technology',
			desc: 'Protected by patent number TR2023015406.',
			src: '/img/cld.png'
		}
	];

	let swiperInstance = null;
	let activeIndex = 0;

	const onSwiper = (e) => {
		swiperInstance = e.detail[0];
		if (browser) {
			activeIndex = swiperInstance.realIndex;
		}
	};

	const onSlideChange = (e) => {
		if (browser) {
			activeIndex = e.detail[0].realIndex;
		}
	};

	// Swiper breakpoints for responsiveness
	const swiperBreakpoints = {
		320: {
			slidesPerView: 1.1,
			spaceBetween: 20
		},
		768: {
			slidesPerView: 1.3,
			spaceBetween: 30
		},
		1024: {
			slidesPerView: 1.6,
			spaceBetween: 40
		}
	};
</script>

<section class="carousel-section">
	<h2 class="section-title">Full Control at Your Fingertips</h2>

	{#if browser}
		<Swiper
			class="custom-swiper"
			spaceBetween={40}
			slidesPerView={1.6}
			centeredSlides={true}
			loop={true}
			on:swiper={onSwiper}
			on:slideChange={onSlideChange}
			breakpoints={swiperBreakpoints}
			autoplay={{
				delay: 2500,
				disableOnInteraction: false
			}}
			grabCursor={true}
		>
			{#each items as item, i}
				<SwiperSlide class="custom-slide" data-swiper-slide-index={i}>
					<div class="image-slide">
						<img src={item.src} alt={item.title} />
					</div>
				</SwiperSlide>
			{/each}
		</Swiper>
	{/if}

	<div class="paginations">
		{#each items as _, i}
			<div
				class="pagination-item"
				class:active={i === activeIndex}
				on:click={() => swiperInstance?.slideToLoop(i)}
				on:keydown={(e) => {
					if (e.key === 'Enter' || e.key === ' ') swiperInstance?.slideToLoop(i);
				}}
				role="button"
				tabindex="0"
				aria-label="Go to slide {i + 1}"
			></div>
		{/each}
	</div>

	<div class="content-below-slider">
		{#if items[activeIndex]}
			<h3 class="content-title">{items[activeIndex].title}</h3>
			<p class="content-desc">{items[activeIndex].desc}</p>
		{/if}
	</div>
</section>


<style>
	.carousel-section {
		padding: 2.5rem 0;
		background: #0a1f44;
		overflow: hidden;
	}
	.section-title {
		text-align: center;
		margin-bottom: 1.5rem;
		font-family: Inter, sans-serif;
		font-weight: 600;
		font-size: 32px;
		color: #d8d8d8;
	}
	.image-slide img {
		width: 100%; /* Make images fill their container */
		height: 400px;
		max-width: 900px;
		border-radius: 16px;
		object-fit: cover; /* Ensure images cover the area without distortion */
		display: block;
		margin: 0 auto; /* Center images if they are smaller than max-width */
	}
	.custom-swiper {
		padding: 0;
		margin: 0;
	}
	.swiper-slide {
		transform: scale(0.85);
		opacity: 0.5;
		transition:
			transform 0.4s ease,
			opacity 0.4s ease;
	}
	.swiper-slide.swiper-slide-active {
		transform: scale(1);
		opacity: 1;
		z-index: 2;
	}
	.swiper-slide-next,
	.swiper-slide-prev {
		z-index: 1;
	}
	.paginations {
		display: flex;
		justify-content: center;
		align-items: center;
		gap: 10px;
		margin-top: 1rem;
		padding: 0 1rem;
		border-radius: 4px;
		overflow: hidden;
	}
	.pagination-item {
		height: 3px;
		width: 50px;
		background-color: #d8d8d8;
		border-radius: 4px;
		cursor: pointer;
		padding: 0%;
		margin: 0;
		transition: all 0.4s ease;
	}
	.pagination-item.active {
		width: 80px;
		background-color: #a8b3e8;
	}
	.content-below-slider {
		text-align: center;
		margin-top: 1rem;
		padding: 0 1rem;
		max-width: 750px;
		margin-left: auto;
		margin-right: auto;
		min-height: 120px; /* Prevent jumping when content changes */
	}
	.content-title {
		font-family: Inter, sans-serif;
		font-weight: 600;
		font-size: 28px;
		color: #d8d8d8;
		margin-bottom: 1rem;
	}
	.content-desc {
		font-family: Inter, sans-serif;
		font-weight: 400;
		font-size: 16px;
		color: #d8d8d8;
		line-height: 1.6;
	}

	/* Responsive adjustments */
	@media (max-width: 1024px) {
		.section-title {
			font-size: 28px;
		}
		.content-title {
			font-size: 24px;
		}
		.content-desc {
			font-size: 15px;
		}
	}

	@media (max-width: 768px) {
		.section-title {
			font-size: 24px;
		}
		.image-slide img {
			height: 300px; /* Smaller height for smaller screens */
		}
		.content-title {
			font-size: 20px;
		}
		.content-desc {
			font-size: 14px;
		}
		.pagination-item {
			width: 40px;
		}
		.pagination-item.active {
			width: 60px;
		}
	}

	@media (max-width: 480px) {
		.carousel-section {
			padding: 1.5rem 0;
		}
		.section-title {
			font-size: 20px;
		}
		.image-slide img {
			height: 250px; /* Even smaller height for very small screens */
		}
		.content-title {
			font-size: 18px;
		}
		.content-desc {
			font-size: 13px;
		}
		.pagination-item {
			width: 30px;
		}
		.pagination-item.active {
			width: 50px;
		}
	}
</style>
