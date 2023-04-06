import { vitePreprocess } from '@sveltejs/vite-plugin-svelte'

export default {
  // Consult https://svelte.dev/docs#compile-time-svelte-preprocess
  // for more information about preprocessors

  onwarn: (warning, handler) => {
    if (warning.code.includes("a11y")) {
      return
    }
    handler(warning)
  },

  preprocess: vitePreprocess(),
}
