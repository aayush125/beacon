<script>
  import beaconLogo from "@/assets/beacon_logo_backdrop.svg"
  import DocumentInput from "@/lib/DocumentInput.svelte"
  import EmbedMap from "@/lib/EmbedMap.svelte";

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
  <span>Form submitted successfully.</span>
</div>

<div class="toast pink white-text" id="submit-error">
  <i>error</i>
  <span>Failed to submit form. Please ensure all fields are filled, and try again.</span>
</div>

<div class="modal" id="confirm-dialog">
  <h4>Confirmation</h4>
  <div class="large-text">
    <p>
      Please ensure that all fields are properly filled and all required documents are uploaded. Once we have validated the authenticity of your organization, we will contact you using the email address or phone number provided.
    </p>
    <p>
      If additional documents or details are required for verification, we may request them via the email or contact number provided. Your cooperation during this process is necessary for successful validation, and we apologize for any inconvenience this may cause.
    </p>
    <p>
      Should you have any questions, please do not hesitate to contact us at our number: +977-9803675279.
    </p>
    <p>
      Thank you for your interest in becoming a provider for Beacon.
    </p>
  </div>
  <nav class="right-align">
    {#if disabled}
      <a class="loader small"></a>
    {/if}
    <button {disabled} data-ui="#confirm-dialog" class="border">Cancel</button>
    <button {disabled} on:click={submitData}>
      Confirm
    </button>
  </nav>
</div>

<form on:submit|preventDefault={formConfirm}>
  <h3 class="center-align small-padding">
    <img src={beaconLogo} class="logo" alt="Beacon Logo" />
    Beacon - Provider Registration Form
  </h3>

  <div class="grid">
    <div class="s6">
      <h5 class="center-align">General Details</h5>

      <div class="input-container">
        <div class="field label border">
          <input name="name" type="text" required />
          <label>Company Name</label>
        </div>

        <div class="field label border">
          <input name="pan_no" type="text" required/>
          <label>Company PAN Number</label>
        </div>

        <div class="field label border">
          <input name="reg_no" type="text" required />
          <label>Registration Number</label>
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

        <div class="field middle-align">
          <nav>
            <span class="large-text">Emergency Service Type: </span>
            <label class="radio">
              <input type="radio" name="type" value="fire" required />
              <span>Fire</span>
            </label>
            <label class="radio">
              <input type="radio" name="type" value="medical" />
              <span>Medical</span>
            </label>
            <label class="radio">
              <input type="radio" name="type" value="police" />
              <span>Police</span>
            </label>
          </nav>
        </div>
      </div>
    </div>
    <div class="s6">
      <div class="input-container">
        <div class="tabs">
          <a data-ui="#pan" class="active">PAN</a>
          <a data-ui="#reg">Registration Certificate</a>
          <a data-ui="#logo">Logo Image</a>
          <a data-ui="#loc">Location</a>
        </div>
        <div class="page padding left active" id="pan">
          <DocumentInput name="img_pan"/>
        </div>
        <div class="page padding left" id="reg">
          <DocumentInput name="img_reg"/>
        </div>
        <div class="page padding left" id="logo">
          <DocumentInput name="img_logo"/>
        </div>
        <div class="page padding left" id="loc">
          <p class="center-align">Click on the map to place the marker. Drag the map to move it.</p>
          <EmbedMap />
          <label class="center checkbox">
            <input type="checkbox" required>
            <span>I have correctly set the location of our office above.</span>
          </label>
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
