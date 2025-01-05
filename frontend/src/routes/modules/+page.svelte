<script lang="ts">
  import ModuleList from "$lib/components/Homepage/ModuleList.svelte";
  import {
    createPagination,
    createSelect,
    createSeparator,
    melt,
  } from "@melt-ui/svelte";
  import {
    IconChevronDown,
    IconChevronLeft,
    IconChevronRight,
    IconSortAscendingShapesFilled,
  } from "@tabler/icons-svelte";
  import { onMount } from "svelte";
  import { fade } from "svelte/transition";

  // TODO: find a way to export the interface from ModuleList instead of duplicating it
  interface Module {
    name: string;
    version?: string;
    downloads?: number;
    updated_at?: string;
    description: string;
    labels: string[];
  }

  const allModules = [
    {
      name: "neorg",
      version: "v9.2.1",
      downloads: 3242,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "foo",
      version: "v9.2.1",
      downloads: 5640965,
      updated_at: "1 week",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "bar",
      version: "v9.2.1",
      downloads: 1234,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "fizz",
      version: "v9.2.1",
      downloads: 123,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "buzz",
      version: "v9.2.1",
      downloads: 321,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "brainfuck2",
      version: "v9.2.1",
      downloads: 231,
      updated_at: "1 year",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },

    {
      name: "neorg",
      version: "v9.2.1",
      downloads: 3242,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "foo",
      version: "v9.2.1",
      downloads: 5640965,
      updated_at: "3 weeks",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "bar",
      version: "v9.2.1",
      downloads: 1234,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "fizz",
      version: "v9.2.1",
      downloads: 123,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "buzz",
      version: "v9.2.1",
      downloads: 321,
      updated_at: "2 months",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
    {
      name: "brainfuck",
      version: "v9.2.1",
      downloads: 231,
      updated_at: "5 days",
      description: "Modernity meets note taking",
      labels: ["neovim", "note taking"],
    },
  ];

  // Pagination
  const {
    elements: { root: paginationRoot, pageTrigger, prevButton, nextButton },
    states: { pages, range, totalPages },
  } = createPagination({
    count: allModules.length,
    perPage: 10,
    defaultPage: 1,
    siblingCount: 1,
  });

  // Separator
  const {
    elements: { root: separator },
  } = createSeparator({ orientation: "vertical", decorative: true });

  // Sorting, there is no "best match" because we are sorting _all_ the available modules
  const sortOptions = [
    "Alphabetical",
    "Most recent",
    "Least recent",
    "Most downloaded",
    "Least downloaded",
  ];

  const {
    elements: {
      trigger: sortTrigger,
      menu: sortMenu,
      option: sortOption,
      label: sortLabel,
    },
    states: { selectedLabel: sortSelectedLabel, open: sortOpen },
    // helpers: { isSelected: sortIsSelected },
  } = createSelect<string>({
    forceVisible: false,
    positioning: {
      placement: "bottom",
      fitViewport: true,
      sameWidth: true,
    },
  });

  // Modules sorting
  let sortedModules: Module[] = $state([]);

  function sortModules(modules: Module[], sortBy: string): Module[] {
    switch (sortBy) {
      case "Alphabetical":
        return [...modules].sort((a, b) => a.name.localeCompare(b.name));
      case "Most recent":
        return [...modules].sort((a, b) => {
          const aDate = parseDate(a.updated_at as string);
          const bDate = parseDate(b.updated_at as string);
          return bDate.getTime() - aDate.getTime();
        });
      case "Least recent":
        return [...modules].sort((a, b) => {
          const aDate = parseDate(a.updated_at as string);
          const bDate = parseDate(b.updated_at as string);
          return aDate.getTime() - bDate.getTime();
        });
      case "Most downloaded":
        return [...modules].sort(
          (a, b) => (b.downloads as number) - (a.downloads as number)
        );
      case "Least downloaded":
        return [...modules].sort(
          (a, b) => (a.downloads as number) - (b.downloads as number)
        );
      default:
        return modules;
    }

    function parseDate(dateString: string): Date {
      if (dateString.includes("day")) {
        const days = parseInt(dateString.split(" ")[0]);
        const now = new Date();
        return new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
      } else if (dateString.includes("week")) {
        const weeks = parseInt(dateString.split(" ")[0]);
        const now = new Date();
        return new Date(now.getTime() - weeks * 7 * 24 * 60 * 60 * 1000);
      } else if (dateString.includes("month")) {
        const months = parseInt(dateString.split(" ")[0]);
        const now = new Date();
        return new Date(
          now.getFullYear(),
          now.getMonth() - months,
          now.getDate()
        );
      } else if (dateString.includes("year")) {
        const years = parseInt(dateString.split(" ")[0]);
        const now = new Date();
        return new Date(
          now.getFullYear() - years,
          now.getMonth(),
          now.getDate()
        );
      } else {
        return new Date();
      }
    }
  }

  onMount(() => {
    sortedModules = sortModules(
      allModules,
      $sortSelectedLabel || sortOptions[0]
    );
  });

  $effect(() => {
    sortedModules = sortModules(
      allModules,
      $sortSelectedLabel || sortOptions[0]
    );
  });
</script>

{#snippet filterButton()}
  <div
    class="flex flex-col md:flex-row items-start md:items-center justify-between bg-surface p-2
  rounded-md"
  >
    <span
      class="flex items-center font-semibold text-grey truncate"
      use:melt={$sortLabel}
      ><IconSortAscendingShapesFilled class="mr-1" size={18} /> Sort by</span
    >
    <div
      class="w-px h-4 mx-2 md:mb-px bg-dark-grey hidden md:inline"
      use:melt={$separator}
    ></div>
    <button
      class="flex items-center justify-between font-medium rounded-md min-w-40 md:min-w-48 text-wrap"
      use:melt={$sortTrigger}
      aria-label="Sort"
    >
      {$sortSelectedLabel || sortOptions[0]}
      <IconChevronDown class="ml-1" size={18} />
    </button>
    {#if sortOpen}
      <div
        class="flex flex-col overflow-y-auto rounded-md mt-1 bg-surface text-text-alt border
      border-dark-grey shadow z-10"
        use:melt={$sortMenu}
        transition:fade={{ duration: 1500 }}
      >
        {#each sortOptions as option}
          <div
            class="relative cursor-pointer py-1 pl-2 hover:text-blue hover:bg-base-alt"
            use:melt={$sortOption({ value: option, label: option })}
          >
            {option}
          </div>
        {/each}
      </div>
    {/if}
  </div>
{/snippet}

<div class="container p-4 md:p-8 lg:p-12">
  <ModuleList
    title="All modules ({allModules.length})"
    modules={sortedModules.slice($range.start, $range.end)}
    heading={filterButton}
  />

  <nav
    class="flex flex-col justify-between items-center"
    use:melt={$paginationRoot}
  >
    <p class="mb-2">Showing {$range.end} out of {allModules.length} modules</p>
    <div class="flex flex-row justify-between items-center space-x-2">
      <button
        class="bg-surface p-1.5 rounded-md hover:bg-blue hover:text-surface"
        use:melt={$prevButton}
      >
        <IconChevronLeft size={20} />
      </button>
      {#each $pages as page (page.key)}
        {#if page.type === "ellipsis"}
          <span
            class="bg-surface py-1 px-3 rounded-md hover:bg-blue hover:text-surface"
            >...</span
          >
        {:else}
          <button
            class="bg-surface py-1 px-3 rounded-md hover:bg-blue hover:text-surface"
            use:melt={$pageTrigger(page)}>{page.value}</button
          >
        {/if}
      {/each}
      <button
        class="bg-surface p-1.5 rounded-md hover:bg-blue hover:text-surface"
        use:melt={$nextButton}
      >
        <IconChevronRight size={20} />
      </button>
    </div>
  </nav>
</div>
