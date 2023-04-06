<script>
  import beaconLogo from "@/assets/beacon_logo_backdrop.svg"
  import DocumentInput from "./DocumentInput.svelte";

  function submitData() {
    // Todo: prepare data for upload to server
    window.ui("#confirm-error")
    window.ui("#confirm-dialog")
  }
</script>

<div class="toast pink white-text" id="confirm-error">
  <i>error</i>
  <span>Failed to submit form. Reason: No server!</span>
</div>

<div class="modal" id="confirm-dialog">
  <h4>Confirmation</h4>
  <div class="large-text">
    <p>
      Please ensure all fields are correctly filled, and necessary documents are uploaded. If the authenticity of your organization is validated, we will contact you through the provided email or phone number.
    </p>
    <p>
      We might require additional documents or details for verification. If the need arises, we may ask for information via the email address or the contact number. Cooperation in this regard is necessary for validation. We are sorry for the inconvinience.
    </p>
    <p>
      If you have any questions, feel free to contact us at our number: +977-9803675279
    </p>
    <p>
      Thank you very much for applying as a provider to Beacon!
    </p>
  </div>
  <nav class="right-align">
    <button data-ui="#confirm-dialog" class="border">Cancel</button>
    <button on:click={submitData}>Confirm</button>
  </nav>
</div>

<main>
  <h3 class="center-align small-padding">
    <img src={beaconLogo} class="logo" alt="Beacon Logo" />
    Beacon - Provider Registration Form
  </h3>

  <div class="grid">
    <div class="s6">
      <h5 class="center-align">General Details</h5>

      <div class="input-container">
        <div class="field label border">
          <input id="company-name" type="text" />
          <label for="company-name">Company Name</label>
        </div>

        <div class="field label border">
          <input id="company-pan" type="text" />
          <label for="company-pan">Company PAN Number</label>
        </div>

        <div class="field label border">
          <input id="company-reg-num" type="text" />
          <label for="company-reg-num">Registration Number</label>
        </div>

        <div class="field label border">
          <input id="company-address" type="text" />
          <label for="company-address">Address</label>
        </div>

        <div class="field label border">
          <input id="company-phone" type="tel" />
          <label for="company-phone">Contact Number</label>
        </div>

        <div class="field label border">
          <input id="company-email" type="email" />
          <label for="company-email">Contact Email</label>
        </div>

        <div class="field middle-align">
          <nav>
            <span class="large-text">Emergency Service Type: </span>
            <label class="radio">
              <input type="radio" name="service-type" />
              <span>Fire</span>
            </label>
            <label class="radio">
              <input type="radio" name="service-type" />
              <span>Medical</span>
            </label>
            <label class="radio">
              <input type="radio" name="service-type" />
              <span>Police</span>
            </label>
          </nav>
        </div>
      </div>
    </div>
    <div class="s6">
      <h5 class="center-align">Documents</h5>
      <div class="input-container">
        <div class="tabs">
          <a data-ui="#pan" class="active">PAN</a>
          <a data-ui="#reg-cert">Registration Certificate</a>
          <a data-ui="#logo">Logo Image</a>
        </div>
        <div class="page padding left active" id="pan">
          <DocumentInput/>
        </div>
        <div class="page padding left" id="reg-cert">
          <DocumentInput/>
        </div>
        <div class="page padding left" id="logo">
          <DocumentInput/>
        </div>
      </div>
    </div>
  </div>
  <button data-ui="#confirm-dialog" class="absolute bottom small-elevate large right margin">Submit</button>
</main>


<style>
  main {
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
