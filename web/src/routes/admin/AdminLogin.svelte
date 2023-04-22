<script>
  import { replace } from "svelte-spa-router";
  import { onMount } from "svelte";

  let disabled = false

  async function loginHandle(e) {
    disabled = true

    const formData = new FormData(e.currentTarget)
    const res = await fetch('/api/web/admin/login', {
      method: 'post',
      body: formData,
    })
    
    disabled = false

    if (res.ok) replace('/admin/dashboard/applications')
  }

  let checking = true
  onMount(async () => {
    const res = await fetch('/api/web/admin/is_logged_in')
    checking = false
    if (res.ok) replace('/admin/dashboard/applications')
  })
</script>

<main class="center-align middle-align">
  {#if checking}
  <a class="loader large"></a>
  {:else}
  <article class="medium-width">
    <h5 class="center-align">Admin Login</h5>
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
  {/if}
</main>

<style>
  main {
    min-height: 100vh;
  }
</style>
