{ pkgs, config, lib, ... }:

let
  user = config.env.DATABASE_USER;
  pass = config.env.DATABASE_PASS;
in
{
    env.DATABASE_URL="postgres://${user}:${pass}@127.0.0.1/luanox";
    env.MIX_TAILWIND_PATH = "${pkgs.tailwindcss_4}/bin/tailwindcss";

    dotenv = {
        enable = true;
        filename = [ ".env.dev" ".env.prod" ];
    };

    # https://devenv.sh/languages/
    languages.elixir.enable = true;

    languages.nix.enable = true;

    packages = with pkgs; [
      alejandra     # Nix formatter
      tailwindcss_4 # We cannot use the bundled TailwindCSS CLI from Phoenix on NixOS
      inotify-tools # Required for file watching on Phoenix
      watchman      # Required for file watching on TailwindCSS CLI
    ];

    # https://devenv.sh/services/
    services.postgres = {
        enable = true;
        initialDatabases = [
          {
            name = "luanox";
            inherit user pass;
          }
        ];
        listen_addresses = "127.0.0.1,localhost";
        port = lib.toIntBase10 config.env.DATABASE_PORT;
    };

    tasks = {
      "luanox:setupHex" = {
          exec = "mix local.hex --if-missing";
          before = [ "devenv:enterShell" "devenv:enterTest" ];
      };
      "luanox:getDependencies" = {
          exec = "mix deps.get";
          status = "test -d ${config.env.DEVENV_ROOT}/deps";
          before = [ "devenv:enterShell" "devenv:enterTest" ];
          after = [ "luanox:setupHex" ];
      };
    };

    scripts = {
      migrate.exec = "mix ecto.migrate";
      genschema.exec = "mix phx.gen.schema $@";
    };

    processes.luanox.exec = ''
      mix phx.server
    '';

    enterTest = ''
      mix test
    '';
}
