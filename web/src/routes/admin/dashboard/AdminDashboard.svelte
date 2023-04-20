<script>
  import beaconLogo from '@/assets/beacon_logo_backdrop.svg'
  import Router, { location, replace } from 'svelte-spa-router'
  import active from 'svelte-spa-router/active'
  import Applications from './Applications.svelte'
  import Emergencies from './Emergencies.svelte'
  import NotFound from '@/routes/NotFound.svelte'

  const prefix = '/admin/dashboard'

  const routes = {
    '/applications': Applications,
    '/emergencies': Emergencies,

    '*': NotFound
  }
</script>

<div>
  <nav class="left medium-space width small-elevate">
    <a href="#/">
      <img class="circle" src={beaconLogo}>
    </a>
    <a href="#/admin/dashboard/applications" use:active>
      <i>description</i>
      <div>Applications</div>
    </a>
    <a href="#/admin/dashboard/emergencies" use:active>
      <i>e911_emergency</i>
      <div>Emergencies</div>
    </a>
    <div class="max"></div> 
    <button class="border circle">
      <i>Logout</i>
    </button>
  </nav>
  
  <Router {prefix} {routes} />
</div>

<style>
  nav {
    width: 7em;
  }
</style>
