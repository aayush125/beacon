<script>
  let disabled = false;
  
  async function submitData(e) {
    const formData = new FormData(e.currentTarget);
    disabled = true;

    const res = await fetch("/api/web/provider/register_responder", {
      method: "post",
      body: formData,
    });

    disabled = false;

    // Show toast
    if (res.ok) window.location.reload()
    else ui("#submit-error")
    
    window.ui("#registration-form")
  }
</script>

<div class="toast pink white-text" id="submit-error">
  <i>error</i>
  <span
    >Failed to submit form. Please ensure all fields are filled, and try again.</span
  >
</div>

<div id="registration-form" class="modal">
  <form on:submit|preventDefault={submitData}>
    <h3 class="center-align small-padding">
      Responder Registration Form
    </h3>
        
        <div class="input-container">
          <div class="field label border">
            <input {disabled} name="name" type="text" required />
            <label>Responder Name</label>
          </div>
          
          <div class="field label border">
            <input {disabled} name="phone" type="tel" required />
            <label>Contact Number</label>
          </div>
          
          <div class="field label border">
            <input {disabled} name="password" type="text" required />
            <label>Password</label>
          </div>
        </div>
    <nav class="right-align">
      <div class="max"/>
      {#if disabled}
      <a class="loader small"></a>
      {/if}
      
      <button type="button" data-ui="#registration-form" {disabled} class="small-elevate border"
      >Cancel</button
      >
      <button {disabled} class="small-elevate"
      >Submit</button
      >
    </nav>
    
  </form>
</div>

<style>
  .input-container {
    padding-left: 4em;
    padding-right: 4em;
  }

  div.field {
    margin-bottom: 1.5em;
  }
</style>
