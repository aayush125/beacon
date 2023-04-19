

<!-- login page for admin -->



<form on:submit|preventDefault={onSubmit}>
  <h3 class="center-align small-padding">
    <img src={beaconLogo} class="logo" alt="Beacon Logo" />
    Beacon - Admin Login Page
  </h3>

  <div class="grid">
    <div class="s6 position">
      <h5 class="center-align small-padding">Enter Login Credentials</h5>

      <div class="input-container">
        <div class="field label border">
          <input name="username" type="text" required />
          <label>Username</label>
        </div>

        <div class="field label border">
          <input name="password" type="password" required />
          <label>Password</label>
        </div>
      </div>
    </div>
    <button
      class="absolute bottom small-elevate large center margin"
      type="submit">Login</button
    >
  </div>
  <div id = "route">
  </div>
</form>



<style>
  form {
    min-height: 100vh;
  }

  .logo {
    width: 2.25em;
    padding: 10px;
  }

  .input-container {
    padding-left: 4em;
    padding-right: 4em;
  }

  div.field {
    margin-bottom: 1.5em;
  }

  .position {
    left: 20em;
    padding-bottom: 5em;
  }
</style>

<script>
  import beaconLogo from "@/assets/beacon_logo_backdrop.svg";
  // import AdminDashboard from "./AdminDashboard.svelte"
  import { push } from "svelte-spa-router";
  

  let formData;

  async function onSubmit(e) {
    console.log("onSubmit called");
    formData = new FormData(e.currentTarget);
    console.log("formData: ", formData);

    const data = {};
    for (let field of formData) {
      const [key, value] = field;
      data[key] = value;
    }
    console.log("data: ", data);

    if(data.username == "admin" && data.password == "admin"){
      await push('/admin/dashboard')
    } else{
      document.getElementById("route").innerHTML = '<h5>Incorrect Credentials</h5>'
    }
  }
</script>