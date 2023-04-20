<script>
  import { replace } from "svelte-spa-router";

  let disabled = false

  async function loginHandle(e) {
    disabled = true

    // const formData = new FormData(e.currentTarget)
    // const res = await fetch("/api/web/admin/login", {
    //   method: "post",
    //   body: formData,
    // })
    
    const res = {ok: true}

    disabled = false

    if (res.ok) replace('/admin/dashboard/applications')
  }
</script>

<main class="center-align middle-align">
  <article class="medium-width">
    <h5 class="center-align">Admin Login</h5>
    <form on:submit|preventDefault={loginHandle} class="large-padding">
      <div class="field label prefix border">
        <i>person</i>
        <input {disabled} name="name" type="text" required />
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

<style>
  main {
    min-height: 100vh;
  }
</style>
