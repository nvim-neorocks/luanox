<script lang="ts">
  // CSS
  import "../app.css";
  // Fonts
  import "@fontsource-variable/inter";
  // import "@fontsource-variable/jetbrains-mono";

  // Global components
  import NavBar from "$lib/components/NavBar.svelte";
  import Footer from "$lib/components/Footer.svelte";

  let { children } = $props();
</script>

<NavBar />
<div class="bg-[#2a2a3a] min-h-screen text-gray-300">
  {@render children()}
</div>
<Footer />

<style>
  :global(body) {
    font-family:
      "Inter Variable",
      system-ui,
      -apple-system,
      BlinkMacSystemFont,
      "Segoe UI",
      Roboto,
      Oxygen,
      Ubuntu,
      Cantarell,
      "Open Sans",
      "Helvetica Neue",
      sans-serif;
  }
</style>
