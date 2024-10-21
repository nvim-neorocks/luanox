{ pkgs, lib, config, inputs, ... }:

{
  dotenv = {
    enable = true;
    disableHint = true;
  };

  # Packages
  packages = with pkgs; [
    just # Command-runner
  ];

  # Languages
  languages.javascript = {
    enable = true;
    bun.enable = true;
  };
  languages.typescript.enable = true;

  # Services
  services.postgres = {
    enable = true;
    initialDatabases = [
      # XXX: add custom user and password for the database through an `.env` file.
      # This might imply that we must add the user role manually and assign superuser permissions to it.
      { name = "luanox_test"; }
    ];
    settings = {
      log_connections = true;
      log_statement = "all";
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
      logging_collector = true;
      listen_addresses = lib.mkForce "*";
    };
  };

  enterShell = ''
  echo "Start Postgres with 'devenv up -d' and stop it using 'devenv processes stop'."
  '';

  # https://devenv.sh/tests/
  # enterTest = ''
  #   echo "Running tests"
  # '';

  # https://devenv.sh/pre-commit-hooks/
  # pre-commit.hooks.shellcheck.enable = true;

  # See full reference at https://devenv.sh/reference/options/
}
