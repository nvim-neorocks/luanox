<script lang="ts">
  // CSS
  import "../app.css";
  // Fonts
  import "@fontsource-variable/inter";
  import "@fontsource-variable/jetbrains-mono";

  // Global components
  import NavBar from "$lib/components/NavBar.svelte";
  import Footer from "$lib/components/Footer.svelte";

  import { onMount } from "svelte";
  import { theme } from "$lib/theme";
  import { get } from "svelte/store";

  onMount(() => {
    document.documentElement.setAttribute("data-theme", get(theme));
  });

  let { children } = $props();
</script>

<NavBar />
<div class="bg-base text-text min-h-screen">
  {@render children()}
</div>
<Footer />
