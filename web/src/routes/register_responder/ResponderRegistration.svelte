<script>
    import beaconLogo from "@/assets/beacon_logo_backdrop.svg"
    import DocumentInput from "@/lib/DocumentInput.svelte"
  
    let formData
    let disabled = false
  
    function formConfirm(e) {
      formData = new FormData(e.currentTarget)
      submitData()
    }
  
    async function submitData() {
      disabled = true
  
      const res = await fetch("/api/web/responder/register", {
        method: "post",
        body: formData,
      })
  
      disabled = false
  
      // Show toast
      ui(res.ok ? "#submit-success" : "#submit-error")
    }

  </script>
  
  <div class="toast green white-text" id="submit-success">
    <i>check</i>
    <span>Form submitted successfully.</span>
  </div>
  
  <div class="toast pink white-text" id="submit-error">
    <i>error</i>
    <span>Failed to submit form. Please ensure all fields are filled, and try again.</span>
  </div>

  <nav class="right-align">
    <button {disabled} data-ui="#confirm-dialog" class="border">Cancel</button>
    <button {disabled} on:click={submitData}>
      Confirm
    </button>
    {#if disabled}
      <a class="loader small"></a>
    {/if}
  </nav>
  
  <form on:submit|preventDefault={formConfirm}>
    <h3 class="center-align small-padding">
      <img src={beaconLogo} class="logo" alt="Beacon Logo" />
      Beacon - Responder Registration Form
    </h3>
  
    <div class="grid">
      <div class="s6">
        <h5 class="center-align">Personal Details</h5>
  
        <div class="input-container">
          <div class="field label border">
            <input name="name" type="text" required />
            <label>Responder Name</label>
          </div>
  
          <div class="field label border">
            <input name="address" type="text" required />
            <label>Address</label>
          </div>
  
          <div class="field label border">
            <input name="contact_no" type="tel" required />
            <label>Contact Number</label>
          </div>
  
          <div class="field label border">
            <input name="email" type="email" required />
            <label>Contact Email</label>
          </div>

          <div class="field label border">
            <input name="provider_name" type="text" required/>
            <label>Provider Name</label>
          </div>
        </div>
      </div>


      <div class="s6">
        <div class="input-container">
          <div class="tabs">
            <a data-ui="#citizenship" class="active">Citizenship Certificate</a>
          </div>
          <div class="page padding left active" id="citizenship">
            <DocumentInput name="img_pan"/>
          </div>
          </div>
        </div>
      </div>
    <button class="absolute bottom small-elevate large right margin">Submit</button>
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
  </style>
  