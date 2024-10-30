{ config, ... }: {
    env.DATABASE_URL="postgres://${config.env.DATABASE_USER}:${config.env.DATABASE_PASS}@127.0.0.1/luanox";

    dotenv = {
        enable = true;
        filename = [ ".env.dev" ".env.prod" ];
    };

    # Bind together Rocket and Sveltekit
    services.caddy = {
        enable = true;
        ca = null;
        config = ''
        :8080 {
            route /api/* {
                reverse_proxy localhost:${config.env.BACKEND_PORT}
            }
            route /* {
                reverse_proxy localhost:${config.env.FRONTEND_PORT}    
            }
        }
        '';
    };
}
