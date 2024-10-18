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
      # XXX: add custom user and password for the database?
      { name = "luanox_test"; }
    ];
    settings = {
      log_connections = true;
      log_statement = "all";
      logging_collector = true;
      log_disconnections = true;
      log_destination = lib.mkForce "syslog";
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
