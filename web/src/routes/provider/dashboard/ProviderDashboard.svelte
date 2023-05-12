<script>
  import responder_placeholder from "@/assets/responder_placeholder.svg";
  import beaconLogo from "@/assets/beacon_logo_backdrop.svg";
  import RouteButton from "@/lib/RouteButton.svelte";
  import { onDestroy } from "svelte";
  import { fly } from "svelte/transition";
  import EmbedMap from "@/lib/EmbedMap.svelte";

  /** @type WebSocket | null */
  let ws = null;

  let selectedResponderId;
  let selectedEmergencyId;

  let rejectionId;

  let responders = [];
  let emergencies = [];
  let loading = true;
  let map;

  // TODO 1: Add logout button somewhere
  // TODO 2: (less important) change how selected items work, use references instead of ID, and add functions to remove
  //          instead of doing it all manually

  onDestroy(() => {
    ws?.close();
  });

  function refreshMarkers() {
    responders.forEach((e) => {
      e.marker.setIcon({
        url:
          "https://maps.google.com/mapfiles/ms/icons/" +
          (e.id === selectedResponderId ? "yellow-dot.png" : "yellow.png"),
      });
    });

    emergencies.forEach((e) => {
      e.marker.setIcon({
        url:
          "https://maps.google.com/mapfiles/ms/icons/" +
          (e.id === selectedEmergencyId ? "red-dot.png" : "red.png"),
      });
    });
  }

  function mapLoaded(e) {
    map = e.detail;

    ws = new WebSocket("ws://" + window.location.host + "/api/web/provider/ws");
    ws.onmessage = (msg) => {
      const data = JSON.parse(msg.data);

      if (data.type === "initial") {
        console.log(data);

        map.setCenter(data.location)

        // Put available responders above unavailable ones
        data.responders.sort((a, b) => b.available - a.available);

        // Create and store markers in responders array
        data.responders.forEach((r) => {
          r.marker = new google.maps.Marker({
            position: { lat: 0, lng: 0 },
            map,
            icon: {
              url: "https://maps.google.com/mapfiles/ms/icons/yellow.png",
            },
            title: r.name,
            visible: false,
          });
        });

        responders = data.responders;
        loading = false;
        return;
      }

      if (data.type === "emergency") {
        data.emergency.sent = false;

        data.emergency.marker = new google.maps.Marker({
          position: { lat: data.emergency.lat, lng: data.emergency.lng },
          map,
          icon: {
            url: "https://maps.google.com/mapfiles/ms/icons/red.png",
          },
          title: `${data.emergency.user.name}'s Emergency`
        });

        emergencies.push(data.emergency);
        console.log(emergencies);
        emergencies = emergencies;

        return;
      }

      if (data.type === "responder_pos_update") {
        // {"id": 6, "lat": 1.231, "lng": 2.321, "available": true}

        const target = responders.findIndex((e) => e.id === data.responder.id);
        if (target !== -1) {
          console.log(responders);

          const marker = responders[target].marker;

          responders[target].available = data.responder.available;
          marker.setPosition({
            lat: data.responder.lat,
            lng: data.responder.lng,
          });
          marker.setVisible(true);
        }

        // TODO, with maps integrated, we need to ensure marker for responder is also created here

        return;
      }

      // Usually used when emergencies end
      if (data.type === "emergency_update") {
        // TODO decide what to do with resolved emergencies

        if (data.emergency.status === "rejected") {
          if (selectedEmergencyId === data.emergency.id) {
            selectedEmergencyId = null;
            const target = emergencies.find((e) => e.id === selectedEmergencyId)
            if (target) {
              target.marker.setMap(null)
            }
          }

          emergencies = emergencies.filter((r) => r.id !== data.emergency.id);
        }
        return;
      }
    };
  }
</script>

<div class="modal" id="reject-dialog">
  <h4>Confirm Rejection</h4>
  <div class="large-text">
    <p>Are you sure you want to reject this emergency?</p>
  </div>
  <nav class="right-align">
    <button data-ui="#reject-dialog" class="border">Cancel</button>
    <button
      on:click={() => {
        // Send rejection packet
        ws.send(
          JSON.stringify({
            emergency_id: rejectionId,
            accepted: false,
          })
        );

        // Update emergencies list
        emergencies = emergencies.filter((e) => e.id !== rejectionId);

        // Clear selection
        selectedEmergencyId = null;
        rejectionId = null;

        window.ui("#reject-dialog");
      }}
    >
      Confirm
    </button>
  </nav>
</div>

<nav class="sidebar left elevate">
  <a href="#/">
    <img class="circle" src={beaconLogo} />
  </a>
  <h5 class="padding">Responders List</h5>

  <RouteButton route="/register_responder">Register New Responders</RouteButton>

  {#each responders as responder}
    <article
      class="responder-container"
      class:light-blue2={responder.id === selectedResponderId}
      class:red1={!responder.available}
    >
      <div class="row">
        <img class="right-round medium" src={responder_placeholder} />
        <div class="max">
          <h5>{responder.name}</h5>
          <span>{responder.phone}</span>
        </div>
        <button
          disabled={!responder.available}
          on:click={() => {
            selectedResponderId = responder.id;
            refreshMarkers();
          }}>Select</button
        >
      </div>
    </article>
  {:else}
    {#if loading}
      <a class="loader large" />
    {:else}
      <p class="italic">No responders!</p>
    {/if}
  {/each}
</nav>

<nav class="sidebar right elevate">
  <h5 class="padding">Emergencies</h5>
  {#each emergencies as emergency}
    <article
      class:light-blue2={emergency.id === selectedEmergencyId}
      class:blue-grey2={emergency.sent}
      class="small round left-align"
    >
      <div class="space" />

      <p>
        <b>Name:</b>
        {emergency.user.name}
      </p>
      <p>
        <b>Phone:</b>
        {emergency.user.phone}
      </p>
      <p>
        <b>Blood Group:</b>
        {emergency.user.blood}
      </p>
      <p>
        <b>Age:</b>
        {emergency.user.age}
      </p>

      <div class="space" />

      <button
        class="border"
        disabled={emergency.sent}
        on:click={() => {
          rejectionId = emergency.id;
          window.ui("#reject-dialog");
        }}>Reject</button
      >

      <button
        disabled={emergency.sent}
        on:click={() => {
          selectedEmergencyId = emergency.id;
          refreshMarkers();
        }}>Select</button
      >
    </article>
  {:else}
    <p class="italic">No emergencies received!</p>
  {/each}
</nav>

<div class="map-container">
  <EmbedMap on:load={mapLoaded} />

  <div class="confirmation-container">
    {#if selectedEmergencyId > 0 && selectedResponderId > 0}
      <article
        transition:fly={{ y: 100, duration: 1000 }}
        class="blur confirmation"
      >
        <nav class="right-align">
          <p class="max left-align">
            Assign selected responder to selected emergency?
          </p>
          <button
            class="border"
            on:click={() => {
              selectedEmergencyId = selectedResponderId = null;
              refreshMarkers();
            }}>Cancel</button
          >

          <button
            on:click={() => {
              ws.send(
                JSON.stringify({
                  emergency_id: selectedEmergencyId,
                  responder_id: selectedResponderId,
                  accepted: true,
                })
              );

              emergencies[
                emergencies.findIndex((e) => e.id === selectedEmergencyId)
              ].sent = true;
              responders[
                responders.findIndex((r) => r.id === selectedResponderId)
              ].available = false;

              selectedEmergencyId = selectedResponderId = null;
              refreshMarkers()
            }}>Confirm</button
          >
        </nav>
        <div class="space" />
      </article>
    {/if}
  </div>
</div>

<style>
  .sidebar {
    width: 20%;
    overflow-y: auto;
  }

  .map-container {
    left: 20%;
    width: 60%;
    overflow: hidden;
    min-height: 100vh;
  }

  .confirmation {
    position: absolute;
    z-index: 3;
    width: 100%;
    top: 91vh;
  }

  .confirmation-container {
    margin-left: 0.5em;
    margin-right: 0.5em;
  }

  .responder-container {
    width: 100%;
  }
</style>
