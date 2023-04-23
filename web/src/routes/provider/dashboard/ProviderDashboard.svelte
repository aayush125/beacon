<script>
import responder_placeholder from "@/assets/responder_placeholder.svg"
import beaconLogo from '@/assets/beacon_logo_backdrop.svg'


</script>


    <nav class="left elevate">
        <a href="#/">
            <img class="circle" src={beaconLogo}>
        </a>
       <h5 class = "padding">Responders List</h5>

       <div class="field large prefix round fill">
        <i class="front">search</i>
        <input placeholder="Search responder">
        <div class="dropdown min">
          <header class="fixed">
            <div class="field large prefix suffix no-margin">
              <i class="front">arrow_backward</i>
              <input placeholder="Search Responder">
              <i class="front">close</i>
            </div>
          </header>
        </div>
      </div>

       <article>
        <details>
          <summary class="none">
            <div class="row">
              <img class="right-round medium" src={responder_placeholder}>
              <div class="max">
                <h5>Shyam</h5>
                <h7>9812498219</h7>
                <button>Assign</button>
              </div>
              <i>arrow_drop_down</i>
            </div>
          </summary>
          <p class = "padding">Responder additional details.</p>
        </details>
      </article>

      <article>
        <details>
          <summary class="none">
            <div class="row">
              <img class="right-round medium" src={responder_placeholder}>
              <div class="max">
                <h5>Hari</h5>
                <h7>9841123456</h7>
                <button>Assign</button>
              </div>
              <i>arrow_drop_down</i>
            </div>
          </summary>
          <p class = "padding">Responder additional details.</p>
        </details>
      </article>

    </nav>

    <nav class="right elevate">
        <h5 class = "padding">Emergency Details</h5>
        <article class="small round">
            <div class="progress right"></div>
            <h5 class = "padding">Emergency1</h5>
            <p class="left-align">Details about the selected emergency is displayed here.</p>
        </article>
    </nav>

    <h3 class = "center-align">Embedded Map display</h3>


<style>
    nav{
        width: 20%;
    }
</style>