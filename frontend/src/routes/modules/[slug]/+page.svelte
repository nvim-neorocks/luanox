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
    // IconTagFilled,
    IconTag,
  } from "@tabler/icons-svelte";
  import { fade } from "svelte/transition";
  import ReportPopover from "$lib/components/Module/ReportPopover.svelte";
  import { formatNumberWithDot } from "$lib/format";

  interface Module {
    name: string;
    versions: string[];
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
  let htmlContent = "";

  const reportReasons = [
    "Security Vulnerability",
    "Broken functionality",
    "Inappropiate content",
    "Other (provide details)",
  ];

  onMount(async () => {
    const moduleName = $page.params.slug;

    module = {
      name: moduleName,
      versions: ["9.1.1", "9.1.0", "9.0.3", "9.0.2", "9.0.1", "9.0.0", "8.9.0"],
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
      htmlContent = await marked((await res.text()) || "# No README available");
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
    //   // htmlContent = marked(module.readme || '# No README available');
    //   htmlContent = "# No README available"
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
        <p class="text-grey text-sm">Latest version: {module.versions[0]}</p>
      </header>

      <!-- <div class="flex flex-wrap min-w-[50%] items-center mt-4 md:mt-0">
        <p class="inline-flex items-center font-semibold mr-1">
          <IconTagFilled size={20} class="mr-1" />
          Labels:
        </p>
        {#each module.labels as label}
          <a
            href="/labels/{label.replaceAll(' ', '-')}"
            class="bg-surface rounded-md mr-1 my-1 p-1 text-text-alt hover:bg-blue hover:text-base-alt text-sm"
            >#{label.replaceAll(" ", "-")}</a
          >
        {/each}
      </div> -->
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
            <IconLicense size={16} class="mr-1" /><span class="font-semibold mr-1"
              >License:</span
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

    <div
      class="!bg-surface !text-text p-6 rounded-lg markdown-body max-w-none"
      transition:fade
    >
      {@html htmlContent}
    </div>
  {:else if module === null}
    <p class="text-text">Loading module...</p>
  {:else}
    <p class="text-red">Module not found.</p>
  {/if}
</div>
