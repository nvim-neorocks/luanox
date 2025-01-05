<script lang="ts">
  import {
    createDialog,
    createPopover,
    createSeparator,
    melt,
  } from "@melt-ui/svelte";
  import { IconFlagFilled, IconX } from "@tabler/icons-svelte";
  import { fade } from "svelte/transition";

  const { reasons } = $props();
  let selectedReason = $state("");

  const {
    elements: {
      trigger: popoverTrigger,
      content: popoverContent,
      arrow: popoverArrow,
      close: popoverClose,
    },
    states: { open: popoverOpen },
  } = createPopover({ forceVisible: false });

  const {
    elements: {
      trigger: dialogTrigger,
      overlay: dialogOverlay,
      content: dialogContent,
      title: dialogTitle,
      description: dialogDescription,
      close: dialogClose,
      portalled: dialogPortalled,
    },
    states: { open: dialogOpen },
  } = createDialog({ forceVisible: false, role: "alertdialog" });

  const {
    elements: { root: separator },
  } = createSeparator();
</script>

<button
  type="button"
  class="inline-flex items-center"
  use:melt={$popoverTrigger}
  aria-label="Report rock"
>
  <IconFlagFilled size={20} />
  <span class="sr-only">Report rock</span>
</button>

{#if popoverOpen}
  <div
    class="bg-surface rounded-md border border-dark-grey"
    use:melt={$popoverContent}
    transition:fade={{ duration: 100 }}
  >
    <div
      class="border-t border-l border-dark-grey"
      use:melt={$popoverArrow}
    ></div>
    <div class="px-2 py-1 grid items-center">
      <div class="flex flex-row items-center justify-between mb-1">
        <p class="text-text">Report reason</p>
        <button class="text-red" use:melt={$popoverClose}>
          <IconX size={20} />
        </button>
      </div>
      <div class="flex flex-col items-start justify-between">
        {#each reasons as reason}
          <button
            type="button"
            class="py-1 w-full text-md text-left text-grey hover:text-blue"
            onclick={() => {
              selectedReason = reason;
            }}
            use:melt={$dialogTrigger}
            aria-label="Report due to {reason}">{reason}</button
          >
          <div
            class="h-px w-full bg-dark-grey last:hidden"
            use:melt={$separator}
          ></div>
        {/each}
      </div>
    </div>
  </div>
{/if}

{#if dialogOpen}
  <div use:melt={$dialogPortalled}>
    <div
      class="fixed inset-0 z-50 bg-transparent backdrop-blur-sm"
      use:melt={$dialogOverlay}
    >
      <div
        class="fixed left-1/2 top-1/2 z-50 max-h-[85vh] w-[90vw] max-w-[50%]
        -translate-x-1/2 -translate-y-1/2 rounded-md p-6 shadow-lg bg-surface border border-dark-grey"
        use:melt={$dialogContent}
      >
        <h2 class="m-0 text-lg font-semibold text-text" use:melt={$dialogTitle}>
          Are you sure you want to report this rock due to {selectedReason}?
        </h2>
        <p class="mb-5 mt-2 text-text" use:melt={$dialogDescription}>
          This action cannot be undone. This will send a report to our
          moderators and the rock will be evaluated to decide if the rock should
          be removed from our servers or not.
        </p>

        <div class="flex mt-6 justify-end gap-4">
          <button
            use:melt={$dialogClose}
            class="inline-flex items-center justify-center rounded-md bg-base-alt text-text h-8 px-4
          leading-none">Close</button
          >
          <button
            use:melt={$dialogClose}
            class="inline-flex items-center justify-center rounded-md bg-red text-base-alt h-8 px-4
          leading-none">Confirm</button
          >
        </div>

        <!-- <button
          class="inline-flex absolute items-center justify-center rounded-full
        right-[10px] top-[10px] h-6 w-6 text-red"
          use:melt={$dialogClose}
        >
          <IconX size={20} class="" />
        </button> -->
      </div>
    </div>
  </div>
{/if}
