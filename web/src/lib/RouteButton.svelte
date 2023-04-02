<script>
  import { push } from "svelte-spa-router";

  export let route;
</script>

<button on:click={() => setTimeout(() => push(route), 100)} class="medium-margin">
  <slot />
</button>
