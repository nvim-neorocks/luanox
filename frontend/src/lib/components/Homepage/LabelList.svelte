<script lang="ts">
  import { IconTagFilled } from "@tabler/icons-svelte";

  interface Label {
    name: string;
    count: number;
  }

  export let title: string;
  export let labels: Label[];
</script>

<div class="p-6">
  <div class="flex justify-between items-center mb-4">
    <h2 class="flex items-center font-semibold text-xl">
      <IconTagFilled class="mr-1" size={20} />
      {title}
    </h2>
  </div>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    {#each labels as label}
      <div class="bg-surface rounded-md p-3">
        <div class="flex justify-between items-center">
          <!-- We replace whitespaces with hypens in case a label is using whitespaces as separator
          for its keywords -->
          <a href="/labels/{label.name.replaceAll(' ', '-')}"
            >{label.name.replaceAll(" ", "-")}</a
          >
          <span class="font-semibold text-grey text-sm"
            >{label.count} modules</span
          >
        </div>
      </div>
    {/each}
  </div>
</div>
