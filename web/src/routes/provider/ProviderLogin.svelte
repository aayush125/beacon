<script>
  import { onMount } from "svelte";
  import ProviderDashboard from "./dashboard/ProviderDashboard.svelte";

  let loggedIn = false
  let checking = true
  let disabled = false

  async function loginHandle(e) {
    disabled = true

    const formData = new FormData(e.currentTarget)
    const res = await fetch("/api/web/provider/login", {
      method: "post",
      body: formData,
    })

    disabled = false

    if (res.ok) loggedIn = true
  }

  onMount(async () => {
    const res = await fetch('/api/web/provider/is_logged_in')
    checking = false
    if (res.ok) loggedIn = true
  })
</script>

{#if checking}
<main class="center-align middle-align">
  <a class="loader large"></a>
</main>
{:else}

{#if loggedIn}
<ProviderDashboard/>
{:else}
<main class="center-align middle-align">
  <article class="medium-width round">
    <h5 class="center-align">Provider</h5>
    <p>Hey! Enter your credentials to log into your account.</p>
    <form on:submit|preventDefault={loginHandle} class="large-padding">
      <div class="field label prefix border">
        <i>person</i>
        <input {disabled} name="username" type="text" required />
        <label>Username</label>
      </div>
      <div class="field label prefix border">
        <i>lock</i>
        <input {disabled} name="password" type="password" required />
        <label>Password</label>
      </div>
      <button {disabled} class="small-elevate">Login</button>
    </form>
  </article>
</main>
{/if}

{/if}

<style>
  main {
    min-height: 100vh;
  }
</style>
