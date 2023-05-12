<script>
  import { onMount } from "svelte";

  let disabled = false
  let actionData = {}
  let applications = []
  let loading = true

  async function loadApplications() {
    applications = []
    const res = await fetch('/api/web/admin/applications')
    applications = await res.json()
    loading = false
  }

  async function executeAction(event) {
    disabled = true

    const res = await fetch(`/api/web/admin/applications/${actionData.action}/${actionData.id}`, {
      method: 'post',
      body: new FormData(event.currentTarget)
    })

    disabled = false
    
    // Close dialog
    ui("#confirm-dialog") 
    
    // Show toast
    ui(res.ok ? "#action-success" : "#action-error")

    // Reload list
    loadApplications()
  }

  onMount(loadApplications)
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
  <form on:submit|preventDefault={executeAction}>
    <div class="large-text">
      <p>
        <b>Reminders:</b>
      </p>
      <p>
        1. Make sure that you have checked and verified all details - including location and certificates! 
      </p>
      <p>
        2. You must inform the concerned authority about the outcome, providing additional details if necessary.
      </p>
      
      {#if actionData.action === 'accept'}
        <div class="center medium-width">
          <p>Create login credentials for {actionData.name}:</p>
          <div class="field label border">
            <input name="username" type="text" required />
            <label>Login Username</label>
          </div>
  
          <div class="field label border">
            <input name="password" type="text" required/>
            <label>Login Password</label>
          </div>
        </div>
      {/if}

      <p>
        Are you sure you want to <b>{actionData.action}</b> the application for {actionData.name}?
      </p>
    </div>
    <nav class="right-align">
      {#if disabled}
        <a class="loader small"></a>
      {/if}
      <button type="button" {disabled} data-ui="#confirm-dialog" class="border">Cancel</button>
      <button {disabled}>Confirm</button>
    </nav>
  </form>
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
  {:else}
    {#if loading}
      <a class="loader large"></a>
    {:else}
      <p class="italic">No provider applications!</p>
    {/if}
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