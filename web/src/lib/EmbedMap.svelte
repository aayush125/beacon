<script>
  import { Loader } from "@googlemaps/js-api-loader";
  import { createEventDispatcher } from "svelte";

  const dispatch = createEventDispatcher();

  let iframe;

  export let lat = 27.7090302;
  export let lng = 85.284933;
  export let zoom = 12;

  async function loadmap() {
    const container = iframe.contentDocument.getElementById("map-container");

    const loader = new Loader({
      apiKey: "AIzaSyBKEI1M_LZSWWEa6AMJCorqfSsVXgD79ns",
    });

    await loader.load();

    const { Map } = await google.maps.importLibrary("maps");

    const map = new Map(container, {
      zoom,
      center: { lat, lng },
    });

    dispatch("load", map);
  }
</script>

<div class="iframe-container">
  <iframe
    on:load={loadmap}
    bind:this={iframe}
    srcdoc={`
      <html style="height: 100%;">
      <body style="height: 100%; margin: 0;">
        <div id="map-container" style="height: 100%"></div>
        </body>
        </html>
        `}
  />
</div>

<style>
  div {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
  }

  iframe {
    height: 100%;
    width: 100%;
    border: none;
  }
</style>
