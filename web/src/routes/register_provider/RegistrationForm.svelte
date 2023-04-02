<script>
  import beaconLogo from "@/assets/beacon_logo_backdrop.svg"
</script>

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
    </div>
  </div>
  <button class="absolute bottom extra right margin">Submit</button>
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
