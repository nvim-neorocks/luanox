<script lang="ts">
  import LuanoxIcon from "$lib/components/LuanoxIcon.svelte";
</script>

<div
  class="bg-surface w-full md:w-auto grid grid-rows-1 md:grid-cols-2 items-center
lg:justify-self-center p-4 md:p-8 lg:p-12"
>
  <div
    class="flex flex-col md:flex-row items-center justify-center md:ml-20 lg:ml-36 md:w-auto mb-8 md:mb-0"
  >
    <LuanoxIcon class="max-w-xs md:max-x-sm lg:max-x-md w-full h-auto" />
    <div class="ml-0 md:ml-4 mt-4 md:mt-0">
      <p class="md:text-lg lg:text-2xl text-center md:text-justify">
        <strong>Luanox</strong> is a modern Lua module host for the
        <a
          class="text-blue hover:underline"
          href="https://github.com/nvim-neorocks/rocks">rocks</a
        >
        package manager that is compatible with the
        <a
          class="text-blue hover:underline"
          href="https://github.com/luarocks/luarocks/wiki/Rockspec-format"
          >rockspec</a
        > format.
      </p>
    </div>
  </div>

  <div class="flex w-full md:w-auto items-center justify-center mb-4 md:mb-0">
    <input
      type="text"
      placeholder="Search something..."
      class="bg-base-alt border
    border-dark-grey rounded-md lg:w-1/2 p-2 focus:outline-none hover:border-blue focus:border-blue text-center md:text-left"
    />
  </div>
</div>
