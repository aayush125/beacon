<script>
  let disabled = false
  let actionData = {}

  async function executeAction() {
    disabled = true

    const res = await fetch(`/api/web/admin/provider/${actionData.id}?action=${actionData.action}`, {
      // todo
      method: 'get', // probably should be POST, also need to include authentication here somehow
    })

    // todo: reload applications array here

    disabled = false

    // Close dialog
    ui("#confirm-dialog") 

    // Show toast
    ui(res.ok ? "#action-success" : "#action-error")
  }

  let applications = [
    {
      id: 8,
      name: 'Naya Project',
      pan_no: 123456789,
      reg_no: '01-9374',
      address: '28 kilo',
      locationLat: 27.629836075366725,
      locationLng: 85.5250883102417,
      contact_no: '9809999999',
      email: 'aayush@gmail.com',
      provider_type: 'fire',
    },
    {
      id: 9,
      name: 'Naya',
      pan_no: 123456789,
      reg_no: '01-9374',
      address: '28 kilo',
      locationLat: 27.629836075366725,
      locationLng: 85.5250883102417,
      contact_no: '9809999999',
      email: 'aayush@gmail.com',
      provider_type: 'fire',
    }
  ]
</script>

<div class="toast green white-text" id="action-success">
  <i>check</i>
  <span>Action successfully completed.</span>
</div>

<div class="toast pink white-text" id="action-error">
  <i>error</i>
  <span>Failed to complete action. Please try again.</span>
</div>

<div class="modal" id="confirm-dialog">
  <h4>Confirmation</h4>
  <div class="large-text">
    <p>
      <b>Reminder:</b> Make sure that you have checked and verified all details - including location and certificates! 
    </p>
    <p>
      Are you sure you want to <b>{actionData.action}</b> the application for {actionData.name}?
    </p>
  </div>
  <nav class="right-align">
    <button {disabled} data-ui="#confirm-dialog" class="border">Cancel</button>
    <button {disabled} on:click={executeAction}>
      Confirm
    </button>
    {#if disabled}
      <a class="loader small"></a>
    {/if}
  </nav>
</div>

<main class="responsive center-align">
  <h3 class="center-align">Applications</h3>

  {#each applications as entry}
    <article>
      <details>
        <summary class="none">
          <div class="row">
            <img class="round" src={`https://res.cloudinary.com/dgglbr1hh/image/upload/${entry.id}_logo`}>
            <div class="max">
              <h5>{entry.name}</h5>
            </div>
            <i>arrow_drop_down</i>
          </div>
        </summary>
        <div class="grid no-space">
          <div class="m6">
            <h6 class="general-details">General Details</h6> 
            <div class="grid no-margin no-space left-align medium-padding">
              <p class="s6">
                <b>PAN No.:</b>
              </p>
              <p class="s6">
                {entry.pan_no} 
              </p>  
              <p class="s6">
                <b>Registration No:</b> 
              </p>
              <p class="s6">
                {entry.reg_no}
              </p>
              <p class="s6">
                <b>Address:</b>
              </p>
              <p class="s6">
                {entry.address} 
              </p>  
              <p class="s6">
                <b>Contact No:</b> 
              </p>
              <p class="s6">
                {entry.contact_no}
              </p>
              <p class="s6">
                <b>Email:</b>
              </p>
              <p class="s6">
                {entry.email} 
              </p>  
              <p class="s6">
                <b>Provider Type:</b> 
              </p>
              <p class="s6 capitalize">
                {entry.provider_type}
              </p>
            </div>
          </div>
          <div class="m6">
            <div class="tabs">
              <a data-ui={`#pan-${entry.id}`} class="active">PAN</a>
              <a data-ui={`#reg-${entry.id}`}>Registration Certificate</a>
              <a data-ui={`#loc-${entry.id}`}>Location</a>
            </div>
            <div class="page padding left active" id={`pan-${entry.id}`}>
              <img class="document" src={`https://res.cloudinary.com/dgglbr1hh/image/upload/${entry.id}_pan`}>
            </div>
            <div class="page padding left" id={`reg-${entry.id}`}>
              <img class="document" src={`https://res.cloudinary.com/dgglbr1hh/image/upload/${entry.id}_reg`}>
            </div>
            <div class="page padding left" id={`loc-${entry.id}`}>
              <iframe 
                style="border:0"
                loading="lazy"
                allowfullscreen
                src={`https://www.google.com/maps/embed/v1/place?q=${entry.locationLat}%2C${entry.locationLng}&key=AIzaSyBKEI1M_LZSWWEa6AMJCorqfSsVXgD79ns`}>
              </iframe>
            </div>
          </div>
        </div>
        <nav class="right-align">
          <!-- Reject button -->
          <button class="border" on:click={() => {
            actionData = {
              action: 'reject',
              id: entry.id,
              name: entry.name
            }
            window.ui('#confirm-dialog')
          }}>
            Reject
          </button>
          
          <!-- Accept button -->
          <button on:click={() => {
            actionData = {
              action: 'accept',
              id: entry.id,
              name: entry.name
            }
            window.ui('#confirm-dialog')
          }}>
            Accept
          </button>
        </nav>
      </details>
    </article>
  {/each}

</main>

<style>
  img.document {
    max-width: 100%;
    max-height: 65vh;
  }

  iframe {
    height: 50vh;
    width: 100%;
    padding: 1em;
  }

  .general-details {
    margin: 0.5em 0 0 0.5em; 
  }
</style>