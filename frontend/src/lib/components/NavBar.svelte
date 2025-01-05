<script lang="ts">
  import LuanoxIcon from "$lib/components/LuanoxIcon.svelte";
  import { createDropdownMenu, createSeparator, melt } from "@melt-ui/svelte";
  import { theme } from "$lib/theme";
  import {
    IconUserCircle,
    IconBook2,
    IconSquarePlus,
    IconCompass,
    IconSun,
    IconMoon,
    IconMenuDeep,
    IconX,
  } from "@tabler/icons-svelte";
  import { onMount } from "svelte";

  const {
    states: { open: exploreOpen },
    elements: {
      menu: exploreMenu,
      item: exploreItem,
      trigger: exploreTrigger,
      arrow: exploreArrow,
    },
  } = createDropdownMenu();

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

  // Navbar mobile menu & dropdowns separators
  const {
    elements: { root: verticalSeparator },
  } = createSeparator({ orientation: "vertical" });

  const {
    elements: { root: horizontalSeparator },
  } = createSeparator();

  const exploreContent = [
    { label: "Labels", href: "/labels" },
    { label: "Modules", href: "/modules" },
  ];

  const createContent = [
    { label: "API Key", href: "/create/api-key" },
    { label: "Module", href: "/create/module" },
  ];

  let loggedIn = $state(true);
  let isMobileMenuOpen = $state(false);

  function toggleMobileMenu() {
    isMobileMenuOpen = !isMobileMenuOpen;
  }

  onMount(() => {
    function handleResize() {
      if (window.innerWidth >= 768 && isMobileMenuOpen) {
        isMobileMenuOpen = false; // Close menu on larger screens
      }
    }

    window.addEventListener("resize", handleResize);
    return () => window.removeEventListener("resize", handleResize);
  });

  function toggleTheme() {
    theme.update((currentTheme) =>
      currentTheme === "light" ? "dark" : "light"
    );
  }
</script>

<nav class="bg-base-alt border-b border-base-alt text-text relative">
  <div
    class="container px-6 py-3 flex justify-between items-center md:flex-row"
  >
    <div class="font-medium text-lg flex items-center">
      <a href="/" class="flex items-center">
        <LuanoxIcon class="h-6 w-auto mr-2" />
        <span class="md:inline hidden">Luanox</span>
      </a>
    </div>

    <!-- Menu -->
    <div class="flex items-center md:space-x-6">
      <div class="flex items-center">
        <button
          onclick={toggleTheme}
          class="text-grey hover:text-blue mr-4 md:mr-0"
        >
          {#if $theme === "dark"}
            <IconMoon size={20} />
          {:else}
            <IconSun size={20} />
          {/if}
        </button>
        <button onclick={toggleMobileMenu} class="text-grey md:hidden">
          {#if isMobileMenuOpen}
            <IconX class="hover:text-red" size={20} />
          {:else}
            <IconMenuDeep class="hover:text-blue" size={20} />
          {/if}
        </button>
      </div>

      <!-- Desktop menu items -->
      <div class="md:flex hidden items-center space-x-6">
        <a
          href="/docs"
          class="flex items-center font-medium text-grey hover:text-blue"
        >
          <IconBook2 size={20} class="mr-1" /> Docs
        </a>
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$exploreTrigger}
          aria-label="Open explore section dropdown"
        >
          <IconCompass size={20} class="mr-1" /> Explore
        </button>
        {#if $exploreOpen}
          <div
            class="absolute flex flex-col right-0 top-14 w-1/4 md:w-28 bg-surface border border-dark-grey rounded-md shadow-lg z-10"
            use:melt={$exploreMenu}
          >
            {#each exploreContent as content, idx}
              <a
                href={content.href}
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$exploreItem}>{content.label}</a
              >
              {#if idx + 1 != exploreContent.length}
                <div
                  class="ml-2.5 h-px w-[80%] bg-dark-grey"
                  use:melt={$horizontalSeparator}
                ></div>
              {/if}
            {/each}
            <div
              class="border-t border-l border-dark-grey"
              use:melt={$exploreArrow}
            ></div>
          </div>
        {/if}
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$createTrigger}
          aria-label="Open create section dropdown"
        >
          <IconSquarePlus size={20} class="mr-1" /> Create
        </button>
        {#if $createOpen}
          <div
            class="absolute flex flex-col right-0 top-14 w-1/4 md:w-28 bg-surface border border-dark-grey rounded-md shadow-lg z-10"
            use:melt={$createMenu}
          >
            {#each createContent as content, idx}
              <a
                href={content.href}
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$createItem}>{content.label}</a
              >
              {#if idx + 1 != createContent.length}
                <div
                  class="ml-2.5 h-px w-[80%] bg-dark-grey"
                  use:melt={$horizontalSeparator}
                ></div>
              {/if}
            {/each}
            <div
              class="border-t border-l border-dark-grey"
              use:melt={$createArrow}
            ></div>
          </div>
        {/if}
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$accountTrigger}
          aria-label="Open account section dropdown"
        >
          <IconUserCircle size={20} class="mr-1" /> Account
        </button>
        {#if $accountOpen}
          <div
            class="absolute flex flex-col right-0 top-14 w-1/4 md:w-28 bg-surface border border-dark-grey rounded-md shadow-lg z-10"
            use:melt={$accountMenu}
          >
            {#if loggedIn}
              <a
                href="/user/profile"
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}>Profile</a
              >
              <a
                href="/user/settings"
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}>Settings</a
              >
              <a
                href="/user/reports"
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}>Reports</a
              >
              <div
                class="ml-2.5 h-px w-[80%] bg-dark-grey"
                use:melt={$horizontalSeparator}
              ></div>
              <a
                href="/logout"
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}>Logout</a
              >
            {:else}
              <div
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}
              >
                Login
              </div>
              <div
                class="ml-2.5 h-px w-[80%] bg-dark-grey"
                use:melt={$horizontalSeparator}
              ></div>
              <div
                class="px-4 py-2 text-sm text-grey hover:bg-base-alt hover:text-blue"
                use:melt={$accountItem}
              >
                Register
              </div>
            {/if}
            <div
              class="border-t border-l border-dark-grey"
              use:melt={$accountArrow}
            ></div>
          </div>
        {/if}
      </div>
    </div>

    {#if isMobileMenuOpen}
      <div
        class="absolute top-full left-0 w-full bg-base-alt
      rounded-b-md shadow-md flex flex-row items-center justify-between pt-2 pb-4 px-4 md:hidden z-10"
      >
        <a
          href="/docs"
          class="flex items-center font-medium text-grey hover:text-blue"
        >
          <IconBook2 size={20} class="mr-1 inline" /> Docs
        </a>
        <div class="h-4 w-px bg-dark-grey" use:melt={$verticalSeparator}></div>
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$exploreTrigger}
          aria-label="Open explore section dropdown"
        >
          <IconCompass size={20} class="mr-1" /> Explore
        </button>
        <div class="h-4 w-px bg-dark-grey" use:melt={$verticalSeparator}></div>
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$createTrigger}
        >
          <IconSquarePlus size={20} class="mr-1 inline" /> Create
        </button>
        <div class="h-4 w-px bg-dark-grey" use:melt={$verticalSeparator}></div>
        <button
          type="button"
          class="flex items-center font-medium text-grey hover:text-blue"
          use:melt={$accountTrigger}
        >
          <IconUserCircle size={20} class="mr-1 inline" /> Account
        </button>
      </div>
    {/if}
  </div>
</nav>
