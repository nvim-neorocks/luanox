<script lang="ts">
  interface Label {
    name: string;
    count: number;
  }

  export let title: string;
  export let labels: Label[];
</script>

<div class="p-6">
  <h2 class="text-xl font-semibold mb-4">{title}</h2>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
    {#each labels as label}
      <div class="bg-[#25252f] rounded-md p-3">
        <div class="flex justify-between items-center">
          <p>{label.name}</p>
          <span class="text-gray-400 text-sm">{label.count} modules</span>
        </div>
      </div>
    {/each}
  </div>
</div>
