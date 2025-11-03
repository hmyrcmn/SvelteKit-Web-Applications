<!-- src/lib/components/Ev.svelte -->
<script>
    export let house;
    import room from './room.svelte';
  </script>
  
  <div class="mb-8">
    <h2 class="text-2xl font-semibold">{house.ad}</h2>
  
    {#each house.rooms as room}
      <room {room} />
    {/each}
  </div>
  