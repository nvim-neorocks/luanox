<script lang="ts">
  import luanox_icon from "$lib/svg/luanox_icon.svg";
</script>

<!-- FIXME: properly center the landing page flexbox elements on lg screens -->
<div
  class="bg-[#25252f] w-full md:w-auto flex flex-col md:flex-row items-center
lg:justify-self-center p-4 md:p-8"
>
  <div
    class="flex flex-col md:flex-row items-center md:mr-8 lg:mr-20 w-full md:w-auto mb-8 md:mb-0"
  >
    <img
      src={luanox_icon}
      alt="Luanox logo"
      class="max-w-xs md:max-x-sm lg:max-x-md w-full h-auto"
    />
    <div class="ml-0 md:ml-8 mt-4 md:mt-0">
      <p class="sm:text-lg md:text-xl lg:text-2xl text-center md:text-justify">
        <strong>Luanox</strong> is a modern Lua module host for the
        <a
          class="text-blue-400 hover:underline"
          href="https://github.com/nvim-neorocks/rocks">rocks</a
        >
        package manager that is compatible with the
        <a
          class="text-blue-400 hover:underline"
          href="https://github.com/luarocks/luarocks/wiki/Rockspec-format"
          >rockspec</a
        > format.
      </p>
    </div>
  </div>

  <div class="flex w-full items-center justify-center">
    <input
      type="text"
      placeholder="Search something..."
      class="bg-[#303040] border
    border-gray-600 rounded-md lg:w-1/2 p-2 focus:outline-none hover:border-blue-500 focus:border-blue-500 text-center md:text-left"
    />
  </div>
</div>
