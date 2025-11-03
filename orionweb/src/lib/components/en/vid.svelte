<script>
  import { onMount } from 'svelte';

  const videos = [
    {
      id: 'ebs-testleri',
      title: 'EBS Application Example',
      description:
        'In this video, you can see the main features of our EBS product along with a practical application scenario.',
      videoSrc: '/img/orion4.mp4',
      thumbnail: '/img/fonk.jpg',
      category: 'EBS'
    },
    {
      id: 'apm-testleri',
      title: 'APM Application Example',
      description:
        'Check out how our APM system monitors performance and detects potential issues in this example.',
      videoSrc: '/img/orion4.mp4',
      thumbnail: '/img/fonk.jpg',
      category: 'APM'
    },
    {
      id: 'eks-testleri',
      title: 'EKS Application Example',
      description:
        'Watch this detailed technical video showing how our EKS solution works to learn more about our product.',
      videoSrc: '/img/orion4.mp4',
      thumbnail: '/img/fonk.jpg',
      category: 'EKS'
    }
  ];

  let activeVideoId = videos[0].id;
  $: activeVideo = videos.find((v) => v.id === activeVideoId);

  function setActiveVideo(id) {
    activeVideoId = id;
  }

  onMount(() => {
    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) {
            entry.target.classList.add('in-view');
          }
        });
      },
      { threshold: 0.1 }
    );

    const elementsToAnimate = document.querySelectorAll('.vid-animate-on-scroll');
    elementsToAnimate.forEach((el) => observer.observe(el));

    return () => observer.disconnect();
  });
</script>

<section class="video-section elite-product-page">
  <div class="main-content">
    <h2 class="video-section-title vid-animate-on-scroll">
      Hands-On Technical Videos
    </h2>
    <p class="video-section-description vid-animate-on-scroll">
      Explore the core features and working principles of our product through detailed technical videos.
    </p>

    <div class="video-container">
      {#if activeVideo}
        <div class="main-video-player">
          <video
            key={activeVideo.id}
            title={activeVideo.title}
            src={activeVideo.videoSrc}
            poster={activeVideo.thumbnail}
            controls
          >
            Your browser does not support the video tag.
          </video>
          <div class="main-video-info">
            <h3>{activeVideo.title}</h3>
            <p>{activeVideo.description}</p>
          </div>
        </div>
      {/if}

      <div class="video-sidebar">
        {#each videos as video, i}
          <button
            class="sidebar-item {video.id === activeVideoId ? 'active' : ''}"
            on:click={() => setActiveVideo(video.id)}
          >
            <div class="sidebar-thumbnail-wrapper">
              <img src={video.thumbnail} alt={video.title} />
              <div class="play-icon">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  class="w-6 h-6"
                >
                  <path
                    fill-rule="evenodd"
                    d="M2.25 12c0-5.385 4.365-9.75 9.75-9.75s9.75 4.365 9.75 9.75-4.365 9.75-9.75 9.75S2.25 17.385 2.25 12Zm14.024-.983a1.125 1.125 0 0 1 0 1.966l-5.604 3.113A1.125 1.125 0 0 1 8.25 15.113V8.887c0-.857.921-1.4 1.67-.983l5.604 3.113Z"
                    clip-rule="evenodd"
                  />
                </svg>
              </div>
            </div>
            <div class="sidebar-text-content">
              <h4>{video.title}</h4>
              <p>{video.description.substring(0, 70)}...</p>
            </div>
          </button>
        {/each}
      </div>
    </div>
  </div>
</section>


<!-- CSS KISMINDA DEĞİŞİKLİK GEREKMEZ -->
<style>
  /* ... stil kodlarınız olduğu gibi kalabilir ... */
  .video-section {
    background-color: #060a24;
    color: #fcfcfd;
    padding: 4rem 1.5rem;
    text-align: center;
  }
  .video-section-title {
    font-size: clamp(2.2rem, 4vw, 3rem);
    font-weight: 700;
    margin-bottom: 1rem;
    color: #fcfcfd;
  }
  .video-section-description {
    font-size: 1.25rem;
    line-height: 1.6;
    color: #7aaaed;
    max-width: 800px;
    margin: 0 auto 3rem auto;
  }
  .main-content {
    max-width: 1200px;
    margin: 0 auto;
    padding: 0 0.5rem;
  }
  .video-container {
    display: grid;
    grid-template-columns: 2fr 1fr;
    gap: 0.5rem;
    align-items: flex-start;
  }
  .main-video-player {
    background-color: #1a1e38;
    border-radius: 12px;
    overflow: hidden;
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
    position: relative;
  }
  .main-video-player video {
    width: 100%;
    aspect-ratio: 16 / 9;
    display: block;
    border: none;
  }
  .main-video-info {
    padding: 0.5rem;
    text-align: left;
  }
  .main-video-info h3 {
    font-size: 1rem;
    font-weight: 700;
    margin-bottom: 0.75rem;
    color: #fcfcfd;
  }
  .main-video-info p {
    font-size: 1rem;
    color: #aeb8d8;
    line-height: 1.6;
  }
  .video-sidebar {
    display: flex;
    flex-direction: column;
    gap: 1.25rem;
  }
  .sidebar-item {
    display: flex;
    align-items: center;
    gap: 1rem;
    background-color: #1a1e38;
    border: 2px solid transparent;
    border-radius: 10px;
    padding: 0.75rem;
    cursor: pointer;
    text-align: left;
    transition:
      background-color 0.3s ease,
      border-color 0.3s ease,
      transform 0.3s ease,
      box-shadow 0.3s ease;
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    color: inherit;
    font-family: inherit;
  }
  .sidebar-item:hover {
    background-color: #2c325a;
    transform: translateY(-2px);
  }
  .sidebar-item.active {
    border-color: #2563eb;
    background-color: #2c325a;
    box-shadow: 0 4px 15px rgba(37, 99, 235, 0.2);
  }
  .sidebar-thumbnail-wrapper {
    position: relative;
    flex-shrink: 0;
    width: 100px;
    height: 60px;
    border-radius: 8px;
    overflow: hidden;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .sidebar-thumbnail-wrapper img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
  .sidebar-thumbnail-wrapper .play-icon {
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    color: white;
    background-color: rgba(0, 0, 0, 0.5);
    border-radius: 50%;
    padding: 0.2rem;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background-color 0.3s ease;
  }
  .play-icon svg {
    width: 24px;
    height: 24px;
  }
  .sidebar-item:hover .play-icon {
    background-color: rgba(0, 0, 0, 0.7);
  }
  .sidebar-text-content h4 {
    font-size: 1rem;
    font-weight: 600;
    color: #fcfcfd;
    margin-bottom: 0.25rem;
    line-height: 1.4;
  }
  .sidebar-text-content p {
    font-size: 0.85rem;
    color: #aeb8d8;
    line-height: 1.4;
  }
  .vid-animate-on-scroll {
    opacity: 0;
    transform: translateY(30px);
    transition:
      opacity 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94),
      transform 0.8s cubic-bezier(0.25, 0.46, 0.45, 0.94);
  }
  :global(.vid-animate-on-scroll.in-view) {
    opacity: 1;
    transform: translateY(0);
  }
  @media (max-width: 991px) {
    .video-container {
      grid-template-columns: 1fr;
    }
    .video-sidebar {
      flex-direction: row;
      overflow-x: auto;
      padding-bottom: 1rem;
    }
    .sidebar-item {
      flex-shrink: 0;
      width: 280px;
      flex-direction: column;
      align-items: flex-start;
    }
    .sidebar-thumbnail-wrapper {
      width: 100%;
      height: 150px;
      margin-bottom: 0.75rem;
    }
  }
  @media (max-width: 767px) {
    .video-section-title {
      font-size: clamp(2rem, 8vw, 3rem);
    }
    .video-section-description {
      font-size: 1rem;
    }
  }
</style>