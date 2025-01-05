<script lang="ts">
  import Landing from "$lib/components/Homepage/Landing.svelte";
  import ModuleList from "$lib/components/Homepage/ModuleList.svelte";
  import LabelList from "$lib/components/Homepage/LabelList.svelte";

  // TODO: stop hardcoding this as soon as we have a functional API
  const modules = {
    recent: [
      {
        name: "neorg",
        version: "v9.1.1",
        description:
          "Modernity meets insane extensibility. The future of organizing your life in Neovim",
        labels: ["neovim", "note-taking"],
      },
      {
        name: "rocks.nvim",
        version: "v2.40.0",
        description:
          "Neovim plugin management inspired by Cargo, powered by luarocks",
        labels: ["neovim", "plugin manager"],
      },
      {
        name: "rest.nvim",
        version: "v3.6.0",
        description: "A fast Neovim http client written in Lua",
        labels: ["neovim", "http", "rest"],
      },
      {
        name: "Imathx54",
        version: "v20240907",
        description: "C99 extensions for the math library",
        labels: ["c", "math"],
      },
    ],
    downloaded: [
      {
        name: "lua-cjson",
        downloads: 20423896,
        description: "Fast JSON encoding/parsing support for Lua",
        labels: ["json", "encoding"],
      },
      {
        name: "LuaFileSystem",
        downloads: 8754192,
        description: "File System Library for the Lua Programming Language",
        labels: ["filesystem", "utilities"],
      },
      {
        name: "lua-resty-http",
        downloads: 6751472,
        description: "Lua HTTP client cosocket driver for OpenResty/nglua",
        labels: ["http", "driver", "openresty"],
      },
      {
        name: "LuaSQL-MYSQL",
        downloads: 6301749,
        description: "Database connectivity for Lua (MySQL driver)",
        labels: ["mysql", "driver", "databases"],
      },
    ],
  };

  const popularLabels = [
    { name: "audio", count: 2000 },
    { name: "authentication", count: 1874 },
    { name: "commandline", count: 1605 },
    { name: "neovim", count: 1251 },
  ];
</script>

<!-- LANDING -->
<Landing />

<!-- MODULES -->
<div class="container pb-4">
  <div class="grid grid-cols-1 md:grid-cols-2 gap-8 py-4">
    <ModuleList title="Most recent modules" modules={modules.recent} />
    <ModuleList title="Most downloaded modules" modules={modules.downloaded} />
  </div>

  <LabelList title="Most popular labels" labels={popularLabels} />
</div>
