<script>
  import { replace } from "svelte-spa-router"
  import ambulance from "@/assets/ambulance.svg"

  let disabled = false

  async function loginHandle(e) {
    disabled = true

    // TODO: Check login here, also check if already logged in, in this page
    // TODO: Make ProviderDashboard just a component and not a routed page, for convinience

    // const formData = new FormData(e.currentTarget)
    // const res = await fetch("/api/web/admin/login", {
    //   method: "post",
    //   body: formData,
    // })

    const res = { ok: true }

    disabled = false

    if (res.ok) replace("/provider/dashboard")
  }
</script>

<body>
  <main class="center-align middle-align">
    <article class="medium-width round">
      <h5 class="center-align">Provider</h5>
      <p>Hey! Enter your credentials to log into your account.</p>
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
  <div id="img-position">
    <!-- <img src= {ambulance} alt="Illustration of ambulance" /> -->
  </div>
</body>

<style>
  main {
    min-height: 100vh;
  }
</style>
