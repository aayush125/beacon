<script>
  let count = 0
  const increment = () => {
    count += 1
    document.body.className = (count % 2) ? "light" : "dark"
  }
</script>

<button on:click={increment} class="large-margin">
  {#if count == 0}
    Click here!
  {:else}
    Counter: {count}
  {/if}
</button>
