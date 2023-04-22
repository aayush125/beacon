<script>
  import beaconLogo from '@/assets/beacon_logo_backdrop.svg'
  import Router, { location, replace } from 'svelte-spa-router'
  import active from 'svelte-spa-router/active'
  import Applications from './Applications.svelte'
  import Emergencies from './Emergencies.svelte'
  import NotFound from '@/routes/NotFound.svelte'
  import { onMount } from 'svelte';

  const prefix = '/admin/dashboard'

  const routes = {
    '/applications': Applications,
    '/emergencies': Emergencies,

    '*': NotFound
  }

  let checking = true
  onMount(async () => {
    const res = await fetch('/api/web/admin/is_logged_in')
    checking = false
    if (!res.ok) replace('/admin/login')
  })

  async function logout() {
    await fetch('/api/web/admin/logout', { method: 'post' })
    replace('/')
  }
</script>

{#if checking}

<main class="center-align middle-align">
  <a class="loader large"></a>
</main>

{:else}

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
    <button class="border circle" on:click={logout}>
      <i>Logout</i>
    </button>
  </nav>
  
  <Router {prefix} {routes} />
</div>

{/if}

<style>
  nav {
    width: 7em;
  }

  main {
    min-height: 100vh;
  }
</style>
