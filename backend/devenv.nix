{ pkgs, config, lib, ... }:

let
  root = "${config.env.DEVENV_ROOT}/backend";
  user = config.env.DATABASE_USER;
  pass = config.env.DATABASE_PASS;
in
{
  # https://devenv.sh/packages/
  # packages = with pkgs; [
  # ];

  # https://devenv.sh/languages/
  languages.elixir.enable = true;

  languages.nix.enable = true;

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

  processes.backend.exec = ''
    cd ${root}
    mix phx.server
  '';

  enterTest = ''
    cd ${root}
    mix test
  '';
}

