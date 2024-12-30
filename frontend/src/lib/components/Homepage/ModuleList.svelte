<script lang="ts">
  interface Module {
    name: string;
    version?: string;
    downloads?: string;
    description: string;
    labels: string[];
  }

  export let title: string;
  export let modules: Module[];
</script>

<div class="p-6">
  <h2 class="font-semibold text-xl mb-4">{title}</h2>
  {#each modules as module}
    <div class="bg-surface p-4 rounded-md mb-4 last:mb-0">
      <div class="flex justify-between items-center mb-1">
        <a href="/modules/{module.name}" class="font-medium">{module.name}</a>
        {#if module.downloads}
          <span class="font-semibold text-grey text-sm">{module.downloads}</span
          >
        {:else}
          <span class="font-semibold text-grey text-sm">{module.version}</span>
        {/if}
      </div>
      <p class="text-grey text-sm truncate">{module.description}</p>
      <div class="flex flex-row mt-4">
        {#each module.labels as label}
          <!-- We replace whitespaces with hypens in case a label is using whitespaces as separator
          for its keywords -->
          <a
            href="/labels/{label.replace(' ', '-')}"
            class="pr-3 last:pr-0 font-mono text-blue text-sm hover:underline"
            >#{label.replace(" ", "-")}</a
          >
        {/each}
      </div>
    </div>
  {/each}
</div>
