<script lang="ts">
  import { IconBrandGithub, IconServer2 } from "@tabler/icons-svelte";
</script>

<footer class="bg-base-alt py-4 px-6 w-full">
  <div
    class="container flex justify-between items-center font-medium text-xs md:text-sm text-grey"
  >
    <div class="flex items-center">
      <span
        >Copyright &copy; {new Date().getFullYear()}
        <a
          href="https://github.com/nvim-neorocks/luanox"
          class="text-blue hover:underline">nvim-neorocks</a
        >. Licensed under AGPL.</span
      >
    </div>
    <div class="flex items-center">
      <a
        href="https://github.com/nvim-neorocks/luanox"
        class="flex items-center mr-4 hover:text-blue"
      >
        <IconBrandGithub size={20} class="mr-1" />
        <span>GitHub</span>
      </a>
      <a href="/status" class="flex items-center mr-4 hover:text-blue">
        <IconServer2 size={20} class="mr-1" />
        <span>Status</span>
      </a>
    </div>
  </div>
</footer>
