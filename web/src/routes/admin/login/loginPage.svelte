<script>
    import beaconLogo from "@/assets/beacon_logo_backdrop.svg"
  
    let formData
    let disabled = false
  
    function formConfirm(e) {
      ui("#confirm-dialog")
      formData = new FormData(e.currentTarget)
    }
  
    async function submitData() {
      disabled = true
  
      const res = await fetch("/api/web/provider/register", {
        method: "post",
        body: formData,
      })
  
      disabled = false
  
      // Close dialog
      ui("#confirm-dialog") 
  
      // Show toast
      ui(res.ok ? "#submit-success" : "#submit-error")
    }
  </script>
  
  <div class="toast green white-text" id="submit-success">
    <i>check</i>
    <span>Credentials submitted successfully.</span>
  </div>
  
  <div class="toast pink white-text" id="submit-error">
    <i>error</i>
    <span>Failed to submit credentials. Please ensure all fields are filled correctly, and try again.</span>
  </div>
  
  
  
  <form on:submit|preventDefault={formConfirm}>
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
            <input name="password" type="password" required/>
            <label>Password</label>
          </div>

      </div>
    </div>
    <button class="absolute bottom small-elevate large center margin">Login</button>
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

    .position{
        left:20em;
        padding-bottom: 5em;
    }

  </style>
  