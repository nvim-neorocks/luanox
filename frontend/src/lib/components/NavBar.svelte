<script lang="ts">
  import LuanoxIcon from "$lib/components/LuanoxIcon.svelte";
  import { createDropdownMenu, melt } from "@melt-ui/svelte";
  import { theme } from "$lib/theme";
  import {
    IconUserCircle,
    IconBook2,
    IconSquarePlus,
    IconSun,
    IconMoon,
  } from "@tabler/icons-svelte";

  const {
    states: { open: createOpen },
    elements: {
      menu: createMenu,
      item: createItem,
      trigger: createTrigger,
      arrow: createArrow,
    },
  } = createDropdownMenu();

  const {
    states: { open: accountOpen },
    elements: {
      menu: accountMenu,
      item: accountItem,
      trigger: accountTrigger,
      arrow: accountArrow,
    },
  } = createDropdownMenu();

  const createContent = [
    { label: "API Key", href: "/create/api-key" },
    { label: "Module", href: "/create/module" },
  ];

  let loggedIn = $state(true);

  function toggleTheme() {
    theme.update((currentTheme) =>
      currentTheme === "light" ? "dark" : "light"
    );
  }
</script>

<nav class="bg-base-alt border-b border-base-alt text-text">
  <div class="container px-6 py-3 flex justify-between items-center">
    <div class="flex items-center">
      <LuanoxIcon class="h-6 w-auto mr-2" />
      <a href="/" class="font-medium text-lg invisible md:visible">Luanox</a>
    </div>

    <div class="flex items-center space-x-6">
      <button onclick={toggleTheme} class="text-grey hover:text-blue">
        {#if $theme === "dark"}
          <IconMoon size={20} />
        {:else}
          <IconSun size={20} />
        {/if}
      </button>
      <a
        href="/docs"
        class="text-grey hover:text-blue hover:underline flex items-center"
      >
        <IconBook2 size={20} class="mr-1" /> Docs
      </a>
      <button
        type="button"
        class="text-grey hover:text-blue hover:underline flex items-center"
        use:melt={$createTrigger}
        aria-label="Open create section dropdown"
      >
        <IconSquarePlus size={20} class="mr-1" /> Create
      </button>
      {#if $createOpen}
        <div
          class="absolute right-0 top-14 w-48 bg-surface rounded-md shadow-lg py-1 z-10"
          use:melt={$createMenu}
        >
          {#each createContent as content}
            <a
              href={content.href}
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt
            hover:text-text-alt"
              use:melt={$createItem}>{content.label}</a
            >
          {/each}
          <div use:melt={$createArrow}></div>
        </div>
      {/if}

      <button
        type="button"
        class="text-grey hover:text-blue hover:underline flex items-center"
        use:melt={$accountTrigger}
        aria-label="Open account section dropdown"
      >
        <IconUserCircle size={20} class="mr-1" /> Profile
      </button>
      {#if $accountOpen}
        <div
          class="absolute right-0 top-14 w-48 bg-surface rounded-md shadow-lg py-1 z-10"
          use:melt={$accountMenu}
        >
          {#if loggedIn}
            <a
              href="/user/profile"
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}>Profile</a
            >
            <a
              href="/user/settings"
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}>Settings</a
            >
            <a
              href="/user/reports"
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}>Reports</a
            >
            <a
              href="/logout"
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}>Logout</a
            >
          {:else}
            <div
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}
            >
              Login
            </div>
            <div
              class="block px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-text-alt"
              use:melt={$accountItem}
            >
              Register
            </div>
          {/if}
          <div use:melt={$accountArrow}></div>
        </div>
      {/if}
    </div>
  </div>
</nav>
