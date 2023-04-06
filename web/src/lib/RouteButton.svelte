<script>
  import { push } from "svelte-spa-router";

  export let route;
</script>

<button on:click={() => setTimeout(() => push(route), 100)} class="small-elevate medium-margin">
  <slot />
</button>
