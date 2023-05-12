<script>
  import { Loader } from "@googlemaps/js-api-loader"

  let iframe
  let map
  let marker

  let lat = 27.7090302
  let lng = 85.284933

  async function loadmap() {
    const container = iframe.contentDocument.getElementById("map-container")

    console.log(iframe)
    console.log(container)

    const loader = new Loader({
      apiKey: "AIzaSyBKEI1M_LZSWWEa6AMJCorqfSsVXgD79ns",
    })

    await loader.load()
    
    const { Map } = await google.maps.importLibrary("maps")

    map = new Map(container, {
      zoom: 12,
      center: {lat, lng},
    })

    google.maps.event.addListener(map, 'click', function(event) {                
      const clickedLocation = event.latLng;
      
      if (!marker){
        marker = new google.maps.Marker({
          position: clickedLocation,
          map: map
        });
      } else{
        marker.setPosition(clickedLocation);
      }
      
      lat = clickedLocation.lat()
      lng = clickedLocation.lng()
    })
  }
</script>

<iframe 
  class="center"
  on:load={loadmap}
  bind:this={iframe}
  srcdoc={`
    <html style="height: 100%;">
      <body style="height: 100%; margin: 0;">
        <div id="map-container" style="height: 100%"></div>
      </body>
    </html>
  `}>
</iframe>

<input type="hidden" name="locationLat" value={lat} />
<input type="hidden" name="locationLng" value={lng} />

<style>
  iframe {
    height: 45vh;
    padding: 0.5em;
    width: 100%;
    border: none;
  }
</style>
