<script lang="ts">
  // CSS
  import "../app.css";
  // Fonts
  import "@fontsource-variable/inter";
  // import "@fontsource-variable/jetbrains-mono";

  let { children } = $props();
</script>

<div class="bg-[#2a2a3a] min-h-screen text-gray-300">
  {@render children()}
</div>

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
