<script lang="ts">
  import { IconBrandGithub, IconServer2 } from "@tabler/icons-svelte";
</script>

<footer class="bg-[#303040] py-4 px-6 w-full">
  <div
    class="container mx-auto flex justify-between items-center text-xs text-[#86919E]"
  >
    <div class="flex items-center">
      <span
        >Copyright &copy; {new Date().getFullYear()}
        <a
          href="https://github.com/nvim-neorocks/luanox"
          class="text-blue-400 hover:underline">nvim-neorocks</a
        >, Licensed under AGPL</span
      >
    </div>
    <div class="flex items-center">
      <a
        href="https://github.com/nvim-neorocks/luanox"
        class="flex items-center mr-4 hover:text-white"
      >
        <IconBrandGithub size={20} class="mr-1" />
        <span>GitHub</span>
      </a>
      <a href="/status" class="flex items-center mr-4 hover:text-white">
        <IconServer2 size={20} class="mr-1" />
        <span>Status</span>
      </a>
    </div>
  </div>
</footer>
