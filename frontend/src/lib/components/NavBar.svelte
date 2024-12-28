<script lang="ts">
  import luanox_icon from "$lib/svg/luanox_icon.svg";
  import { createDropdownMenu, melt } from "@melt-ui/svelte";
  import {
    IconUserCircle,
    IconBook2,
    IconSquarePlus,
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
</script>

<nav class="bg-[#303040] border-b border-[#303040]">
  <div class="container mx-auto px-6 py-3 flex justify-between items-center">
    <div class="flex items-center">
      <img src={luanox_icon} alt="Luanox logo" class="h-6 w-auto mr-2" />
      <a href="/" class="text-white font-medium text-lg invisible md:visible"
        >Luanox</a
      >
    </div>

    <div class="flex items-center space-x-6">
      <a
        href="/docs"
        class="text-gray-400 hover:text-blue-400 hover:underline flex items-center"
      >
        <IconBook2 size={20} class="mr-1" /> Docs
      </a>
      <button
        type="button"
        class="text-gray-400 hover:text-blue-400 hover:underline flex items-center"
        use:melt={$createTrigger}
        aria-label="Open create section dropdown"
      >
        <IconSquarePlus size={20} class="mr-1" /> Create
      </button>
      {#if $createOpen}
        <div
          class="absolute right-0 top-14 w-48 bg-[#181820] rounded-md shadow-lg py-1 z-10"
          use:melt={$createMenu}
        >
          {#each createContent as content}
            <a
              href={content.href}
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844]
            hover:text-white"
              use:melt={$createItem}>{content.label}</a
            >
          {/each}
          <div use:melt={$createArrow}></div>
        </div>
      {/if}

      <button
        type="button"
        class="text-gray-400 hover:text-blue-400 hover:underline flex items-center"
        use:melt={$accountTrigger}
        aria-label="Open account section dropdown"
      >
        <IconUserCircle size={20} class="mr-1" /> Profile
      </button>
      {#if $accountOpen}
        <div
          class="absolute right-0 top-14 w-48 bg-[#181820] rounded-md shadow-lg py-1 z-10"
          use:melt={$accountMenu}
        >
          {#if loggedIn}
            <a
              href="/user/profile"
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
              use:melt={$accountItem}>Profile</a
            >
            <a
              href="/user/settings"
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
              use:melt={$accountItem}>Settings</a
            >
            <a
              href="/user/reports"
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
              use:melt={$accountItem}>Reports</a
            >
            <a
              href="/logout"
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
              use:melt={$accountItem}>Logout</a
            >
          {:else}
            <div
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
              use:melt={$accountItem}
            >
              Login
            </div>
            <div
              class="block px-4 py-2 text-sm text-gray-300 hover:bg-[#383844] hover:text-white"
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
