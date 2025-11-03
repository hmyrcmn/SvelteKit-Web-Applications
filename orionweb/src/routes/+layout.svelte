<!-- src/routes/+layout.svelte -->
<script>
  import "../app.css";
  import AOS from 'aos';
  import 'aos/dist/aos.css';
  import { onMount } from 'svelte';

  onMount(() => {
    AOS.init({
      duration: 900,
      easing: 'ease-out-cubic',
      offset: 80,
      once: true,
      mirror: false,
    });
  });
</script>

<div class="bg-white text-black">
  <slot />
</div>