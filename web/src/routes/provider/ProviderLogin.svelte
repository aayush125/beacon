<script>
    import { replace } from "svelte-spa-router";
    import ambulance from "@/assets/ambulance.svg";
   
    let disabled = false
  
    async function loginHandle(e) {
      disabled = true
  
      // const formData = new FormData(e.currentTarget)
      // const res = await fetch("/api/web/admin/login", {
      //   method: "post",
      //   body: formData,
      // })
      
      const res = {ok: true}
  
      disabled = false
  
      if (res.ok) replace('/provider/dashboard')
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
  <div  id = "img-position">
    <!-- <img src= {ambulance} alt="Illustration of ambulance" /> -->
  </div>

  </body>
  
  <style>
    main {
      min-height: 100vh;
    }
    
    body{
        /* background-color: #f0cfd5; */
    }
    /* #img-position{
      position: relative;
      top: -20em;
      right: -20em;
    } */

  </style>
  