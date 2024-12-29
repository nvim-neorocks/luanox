<script lang="ts">
  interface Module {
    name: string;
    version?: string;
    downloads?: string;
    description: string;
  }

  export let title: string;
  export let modules: Module[];
</script>

<div class="p-6">
  <h2 class="text-xl font-semibold mb-4">{title}</h2>
  {#each modules as module}
    <div class="bg-surface p-4 rounded-md mb-4 last:mb-0">
      <div class="flex justify-between items-center pb-2">
        <h3 class="font-medium">{module.name}</h3>
        {#if module.downloads}
          <span class="text-grey text-sm">{module.downloads}</span>
        {:else}
          <span class="text-grey text-sm">{module.version}</span>
        {/if}
      </div>
      <p class="text-grey text-sm truncate">{module.description}</p>
    </div>
  {/each}
</div>
