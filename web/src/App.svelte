<script>
  import beaconLogo from './assets/beacon_logo.svg'
  import Counter from './lib/Counter.svelte'
</script>

<main class="center-align middle-align">
  <div>
    <div>
      <a href="https://github.com/aayush125/beacon" target="_blank" rel="noreferrer">
        <img src={beaconLogo} class="logo" alt="Beacon Logo" />
      </a>
    </div>
    <h1 class="center-align">Beacon</h1>
    
    <Counter />
    
    <p class="medium-text secondary-text">
      An emergency app that will <span class="italic">hopefully</span> get us A grades, and not much else.
    </p>
  </div>
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
