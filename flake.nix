{
  description = "Lua modules hosting";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in {
      # nix develop
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          bun # JavaScript runtime
          just # Command-runner
          postgresql # Databases
          nodePackages.typescript
          nodePackages.typescript-language-server

          # PostgreSQL utilities, taken from the elixirforum and slightly modified
          # credits to https://elixirforum.com/u/water
          (pkgs.writeShellScriptBin "pg-stop" ''
            pg_ctl -D $PGDATA -U postgres stop
          '')
          (pkgs.writeShellScriptBin "pg-reset" ''
            rm -rf $PGDATA
          '')
          (pkgs.writeShellScriptBin "pg-setup" ''
            if ! test -d $PGDATA; then
              pg_ctl initdb -D $PGDATA -U postgres
              echo "unix_socket_directories = '$PGDATA'" >> $PGDATA/postgresql.conf
              echo "CREATE USER postgres WITH PASSWORD 'postgres' CREATEDB SUPERUSER;" | postgres --single -E postgres
              echo "CREATE DATABASE luna_test WITH OWNER postgres;" | postgres --single -E postgres
              echo -e "\nDefault database for testing purposes: luna_test"
            fi
          '')
          (pkgs.writeShellScriptBin "pg-start" ''
            [ ! -d $PGDATA ] && pg-setup

            # Trust localhost connections
            HOST_COMMON="host\s\+all\s\+all"
            sed -i "s|^$HOST_COMMON.*127.*$|host all all 0.0.0.0/0 trust|" $PGDATA/pg_hba.conf
            sed -i "s|^$HOST_COMMON.*::1.*$|host all all ::/0 trust|"      $PGDATA/pg_hba.conf

            pg_ctl                                                  \
              -D $PGDATA                                            \
              -l $PGDATA/postgres.log                               \
              -o "-c unix_socket_directories='$PGDATA'"             \
              -o "-c log_destination='stderr'"                      \
              -o "-c logging_collector=on"                          \
              -o "-c log_directory='log'"                           \
              -o "-c log_filename='postgresql-%Y-%m-%d_%H%M%S.log'" \
              -o "-c log_min_messages=info"                         \
              -o "-c log_min_error_statement=info"                  \
              -o "-c log_connections=on"                            \
              start
          '')
          (pkgs.writeShellScriptBin "pg-console" ''
            psql --host $PGDATA -U postgres
          '')
        ];

        shellHook = ''
          # Setup ENV
          export BACKEND_PATH=$PWD/backend
          export PGDATA="$BACKEND_PATH/.pg"

          [ ! -d "$PGDATA" ] && echo "Run pg-setup to initialize a the back-end database"
        '';
      };
    });
}
