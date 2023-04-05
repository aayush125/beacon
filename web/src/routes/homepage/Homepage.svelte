<script>
  import beaconLogo from '@/assets/beacon_logo.svg'
  import RouteButton from '@/lib/RouteButton.svelte';

  let darkMode = document.body.className === "dark";

  function modeSwitch() {
    darkMode = !darkMode;
    document.body.className = (darkMode) ? "dark" : "light"
  }
</script>
  
<main class="center-align middle-align">
<div>
  <div>
    <a href="https://github.com/aayush125/beacon" target="_blank" rel="noreferrer">
      <img src={beaconLogo} class="logo" alt="Beacon Logo" />
    </a>
  </div>
  <h1 class="center-align">Beacon</h1>      
  <p class="large-text secondary-text">
    A swift and reliable emergency services platform, featuring easy navigation tools for service providers.
  </p>

  <RouteButton route="/register_provider">Provider Registration</RouteButton>
  <RouteButton route="/provider/login">Provider Dashboard</RouteButton>
  <RouteButton route="/admin/login">Admin Dashboard</RouteButton>

</div>

<button on:click={modeSwitch} class="circle large small-elevate secondary large-margin absolute bottom right">
  <i>
    {#if darkMode}
    light_mode
    {:else}
    dark_mode
    {/if}
  </i>
</button>

</main>

<style>
.logo {
  height: 10em;
  will-change: filter;
  transition: filter 300ms;
}
.logo:hover {
  filter: drop-shadow(0 0 2em #e33d55ff);
}

main {
  height: 100vh;
}
</style>
  