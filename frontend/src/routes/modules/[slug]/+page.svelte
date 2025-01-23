<script lang="ts">
  import { page } from "$app/stores";
  import { onMount } from "svelte";
  import { marked } from "marked";
  import {
    IconDownload,
    IconBrandGit,
    IconActivity,
    IconBrandGithubFilled,
    IconBrandGitlab,
    IconLicense,
    IconUsers,
    IconFileDescription,
    IconListDetails,
    IconTag,
  } from "@tabler/icons-svelte";
  import { createTabs, melt } from "@melt-ui/svelte";
  import { cubicInOut } from "svelte/easing";
  import { fade, crossfade } from "svelte/transition";
  import ReportPopover from "$lib/components/Module/ReportPopover.svelte";
  import { formatNumberWithDot } from "$lib/format";

  interface ModuleVersions {
    id: string;
    downloads: number;
    published_at: string;
    uploader: string;
  }

  interface Module {
    name: string;
    versions: ModuleVersions[];
    description: string;
    readme: string; // XXX: Markdown content using marked perhaps? rockspecs does not have a README field :(
    license: string; // XXX: rockspecs does not have a LICENSE field either, perhaps we can scrape it from somewhere?
    authors: string[];
    labels: string[];
    downloads: number;
    updated_at: string;
    repo_url: string;
  }

  let module: Module | null = null;
  let readmeContent = "";

  const reportReasons = [
    "Security Vulnerability",
    "Broken functionality",
    "Inappropiate content",
    "Other (provide details)",
  ];

  const {
    elements: {
      root: tabRoot,
      list: tabList,
      content: tabContent,
      trigger: tabTrigger,
    },
    states: { value: tabValue },
  } = createTabs({
    defaultValue: "readme",
  });
  const tabTriggers = [
    { id: "readme", title: "Readme" },
    { id: "metadata", title: "Metadata" }, // NOTE: this tab will display the rocks.toml file contents
    { id: "versions", title: "Versions" },
    { id: "dependencies-dependants", title: "Dependencies/Dependants" },
    { id: "stats", title: "Statistics" },
  ];

  const [send, receive] = crossfade({
    duration: 250,
    easing: cubicInOut,
  });

  onMount(async () => {
    const moduleName = $page.params.slug;

    module = {
      name: moduleName,
      versions: [
        {
          id: "9.1.1",
          downloads: 1242,
          published_at: "3 months ago",
          uploader: "neorg",
        },
        {
          id: "9.1.0",
          downloads: 150,
          published_at: "3 months ago",
          uploader: "neorg",
        },
        {
          id: "9.0.3",
          downloads: 250,
          published_at: "4 months ago",
          uploader: "vhyrro",
        },
        {
          id: "9.0.2",
          downloads: 126,
          published_at: "4 months ago",
          uploader: "vhyrro",
        },
        {
          id: "9.0.1",
          downloads: 174,
          published_at: "4 months ago",
          uploader: "neorg",
        },
        {
          id: "9.0.0",
          downloads: 1000,
          published_at: "4 months ago",
          uploader: "neorg",
        },
        {
          id: "8.9.0",
          downloads: 300,
          published_at: "6 months ago",
          uploader: "neorg",
        },
      ],
      description:
        "Modernity meets insane extensibility. The future of organizing your life in Neovim.",
      readme: "No README available",
      license: "GPL-3.0",
      authors: ["neorg", "vhyrro"],
      labels: ["neovim", "note-taking"],
      downloads: 3242,
      updated_at: "2 months",
      repo_url: "https://github.com/nvim-neorg/neorg",
    };

    // XXX: this is a dummy test for the README rendering, remove later
    try {
      const res = await fetch(
        "https://raw.githubusercontent.com/nvim-neorg/neorg/main/README.md"
      );
      if (!res.ok) {
        throw new Error(`HTTP Error. Status: ${res.status}`);
      }
      readmeContent = await marked(
        (await res.text()) || "# No README available"
      );
    } catch (err) {
      console.error("Erorr fetching module's README:", err);
    }

    // TODO: Fetch module data instead of hardcoding it
    // try {
    //   const res = await fetch(`/api/v1/modules/${moduleName}`); // Example API endpoint
    //   if (!res.ok) {
    //     throw new Error(`HTTP error! status: ${res.status}`);
    //   }
    //   module = await res.json();
    //   // readmeContent = marked(module.readme || '# No README available');
    //   readmeContent = "<h1>No README available</h1>"
    // } catch (error) {
    //   console.error("Error fetching module:", error);
    //   module = null; // Handle error gracefully
    // }
  });
</script>

<!-- TODO: ADD TABS SIMILAR TO CRATES.IO -->
<div class="container p-6">
  {#if module}
    <div class="flex flex-col md:flex-row md:items-center">
      <header class="flex flex-col min-w-[50%] mb-2">
        <h1 class="text-3xl font-bold text-text">{module.name}</h1>
        <p class="text-grey text-sm">Latest version: {module.versions[0].id}</p>
      </header>
    </div>

    <div class="flex flex-wrap mt-4 mb-4">
      <div class="flex items-center mr-4 font-semibold">
        <IconDownload size={20} class="mr-1" />
        {formatNumberWithDot(module.downloads)} downloads
      </div>
      <div class="flex items-center mr-4 font-semibold">
        <IconActivity size={20} class="mr-1" /> Last updated: {module.updated_at}
        ago
      </div>
      {#if module.repo_url}
        <a
          href={module.repo_url}
          target="_blank"
          rel="noopener noreferrer"
          class="flex items-center mr-4 hover:text-blue"
        >
          {#if module.repo_url.includes("github")}
            <IconBrandGithubFilled size={20} class="mr-1" />
          {:else if module.repo_url.includes("gitlab")}
            <IconBrandGitlab size={20} class="mr-1" />
          {:else}
            <IconBrandGit size={20} class="mr-1" />
          {/if}
        </a>
      {/if}
      <div class="mt-1.5">
        <ReportPopover reasons={reportReasons} />
      </div>
    </div>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
      <div class="bg-surface p-6 rounded-lg">
        <h2 class="inline-flex items-center text-xl font-bold mb-2 text-text">
          <IconFileDescription size={20} class="mr-1" /> Description
        </h2>
        <p class="text-text">{module.description}</p>
      </div>
      <div class="bg-surface p-6 rounded-lg">
        <h2 class="inline-flex items-center text-xl font-bold mb-2 text-text">
          <IconListDetails size={20} class="mr-1" />Details
        </h2>
        <ul class="list-none space-y-2 text-text">
          <li class="flex flex-wrap items-center">
            <IconUsers size={16} class="mr-1" /><span class="font-semibold mr-1"
              >Authors:</span
            >
            {#each module.authors as author, idx}
              <a href="/users/{author}" class="hover:text-blue hover:underline"
                >{author}</a
              >
              {#if idx + 1 != module.authors.length}
                <span class="mr-1">,</span>
              {/if}
            {/each}
          </li>
          <li class="flex flex-wrap items-center">
            <IconLicense size={16} class="mr-1" /><span
              class="font-semibold mr-1">License:</span
            >
            <a
              href="https://opensource.org/license/{module.license}"
              class="hover:text-blue hover:underline">{module.license}</a
            >
          </li>
          <li class="flex flex-wrap items-center">
            <p class="inline-flex items-center font-semibold mr-1">
              <IconTag size={16} class="mr-1" />
              Labels:
            </p>
            {#each module.labels as label}
              <a
                href="/labels/{label.replaceAll(' ', '-')}"
                class="mr-2 last:mr-0 font-mono text-blue text-sm hover:underline"
                >#{label.replaceAll(" ", "-")}</a
              >
            {/each}
          </li>
        </ul>
      </div>
    </div>

    <!-- NOTE: this div tag is used for the first and last TailwindCSS modifiers to work properly -->
    <div class="flex flex-col md:flex-row">
      {#each tabTriggers as tabItem}
        <button
          use:melt={$tabTrigger(tabItem.id)}
          class="{$tabValue === tabItem.id
            ? 'bg-surface'
            : 'bg-base-alt'} relative py-2 px-2 last:mr-0 first:max-sm:rounded-t-lg first:md:rounded-tl-lg last:md:rounded-tr-lg"
        >
          {tabItem.title}
          {#if $tabValue === tabItem.id}
            <div
              in:send={{ key: "trigger" }}
              out:receive={{ key: "trigger" }}
              class="absolute left-1/2 h-1 w-1/2 -translate-x-1/2 rounded-full bg-blue"
            ></div>
          {/if}
        </button>
      {/each}
    </div>

    <div
      class="!body-surface !text-text md:rounded-r-lg rounded-b-lg max-w-none"
      transition:fade
    >
      <div
        class="!bg-surface !text-text p-6 md:rounded-r-lg rounded-b-lg markdown-body"
        use:melt={$tabContent("readme")}
      >
        {@html readmeContent}
      </div>
      <div
        class="!bg-surface !text-text p-6"
        use:melt={$tabContent("metadata")}
      >
        TBD...

        <p>Render the rocks.toml contents here</p>
      </div>
      <div
        class="!bg-surface !text-text p-6 md:rounded-r-lg rounded-b-lg overflow-x-auto"
        use:melt={$tabContent("versions")}
      >
        <h1 class="text-2xl mb-2">Version history</h1>
        <table class="table-auto w-full">
          <thead class="bg-base-alt text-left">
            <tr>
              <th class="px-4 py-3 font-medium" scope="col">Version</th>
              <th class="px-4 py-3 font-medium" scope="col">Downloads</th>
              <th class="px-4 py-3 font-medium" scope="col">Published</th>
              <th class="px-4 py-3 font-medium" scope="col">Uploader</th>
            </tr>
          </thead>
          <tbody class="text-left">
            {#each module.versions as version}
              <tr class="border-b border-dark-grey">
                <th class="px-4 py-3" scope="row"><a class="hover:text-blue" href="{$page.url.pathname}/v/{version.id}">{version.id}</a></th>
                <td class="px-4 py-3">{formatNumberWithDot(version.downloads)}</td>
                <td class="px-4 py-3">{version.published_at}</td>
                <td class="px-4 py-3"><a class="hover:text-blue hover:underline" href="/users/{version.uploader}">{version.uploader}</a></td>
              </tr>
            {/each}
          </tbody>
        </table>
      </div>
    </div>
  {:else if module === null}
    <p class="text-text">Loading module...</p>
  {:else}
    <p class="text-red">Module not found.</p>
  {/if}
</div>
