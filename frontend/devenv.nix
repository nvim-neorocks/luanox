{ pkgs, config, ... }:

let root = "${config.env.DEVENV_ROOT}/frontend"; in 
{
  # https://devenv.sh/packages/
  packages = with pkgs; [
      bun
      svelte-language-server
  ];

  languages.nix.enable = true;

  processes.frontend.exec = "bun --cwd ${root} dev --port ${config.env.FRONTEND_PORT}";

  tasks = {
    "frontend:setup" = {
      exec = "bun install --cwd ${root}";
      before = [ "devenv:enterShell" "devenv:enterTest" ];
      status = "test -d ${root}/node_modules";
    };
  };

  enterTest = ''
    bunx --cwd ${root} svelte-check
  '';
}
