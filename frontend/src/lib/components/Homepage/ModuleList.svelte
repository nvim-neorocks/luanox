<script lang="ts">
  import {
    IconDownload,
    IconActivity,
    IconCategoryFilled,
  } from "@tabler/icons-svelte";
  import { createSeparator, melt } from "@melt-ui/svelte";
  import type { Snippet } from "svelte";
  import { formatNumberWithDot } from "$lib/format";

  interface Module {
    name: string;
    version?: string;
    downloads?: number;
    updated_at?: string;
    description: string;
    labels: string[];
  }

  interface Props {
    title: string;
    modules: Module[];
    heading?: Snippet;
  }
  let { title, modules, heading }: Props = $props();

  const {
    elements: { root: separator },
  } = createSeparator({ orientation: "vertical" });
</script>

<div class="p-6">
  <div class="flex justify-between items-center mb-4">
    <h2 class="flex items-center font-semibold text-lg md:text-xl">
      <IconCategoryFilled class="mr-1" size={20} />
      {title}
    </h2>
    {#if heading}
      {@render heading()}
    {/if}
  </div>
  {#each modules as module}
    <div class="bg-surface p-4 rounded-md mb-4 last:mb-0">
      <div class="flex items-center justify-between mb-1">
        <!-- FIXME: large rock names bugs the UI on mobile -->
        <a href="/modules/{module.name}" class="font-medium">{module.name}</a>
        <div class="flex justify-between items-end space-x-2">
          {#if module.version}
            <span class="font-semibold text-grey text-sm">{module.version}</span
            >
            <div
              class="w-px h-4 mb-0.5 md:mb-px bg-dark-grey last:hidden"
              use:melt={$separator}
            ></div>
          {/if}
          {#if module.downloads}
            <span class="flex font-semibold text-grey text-sm space-x-4"
              ><IconDownload class="mr-1" size={18} />
              {formatNumberWithDot(module.downloads)}</span
            >
            <div
              class="w-px h-4 mb-0.5 md:mb-px bg-dark-grey last:hidden"
              use:melt={$separator}
            ></div>
          {/if}
          {#if module.updated_at}
            <span class="flex font-semibold text-grey text-sm"
              ><IconActivity class="mr-1" size={18} />{module.updated_at} ago</span
            >
            <div
              class="w-px h-4 mb-0.5 md:mb-px bg-dark-grey last:hidden"
              use:melt={$separator}
            ></div>
          {/if}
        </div>
      </div>
      <p class="text-grey text-sm lg:text-md truncate">{module.description}</p>
      <div class="flex flex-row mt-4">
        {#each module.labels as label}
          <!-- We replace whitespaces with hypens in case a label is using whitespaces as separator
          for its keywords -->
          <a
            href="/labels/{label.replaceAll(' ', '-')}"
            class="mr-3 last:mr-0 font-mono text-blue text-sm hover:underline"
            >#{label.replaceAll(" ", "-")}</a
          >
        {/each}
      </div>
    </div>
  {/each}
</div>
