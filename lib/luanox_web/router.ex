defmodule LuaNoxWeb.Router do
  use LuaNoxWeb, :router

  import LuaNoxWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {LuaNoxWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LuaNoxWeb do
    pipe_through :browser

    live_session :default, on_mount: [{LuaNoxWeb.UserAuth, :mount_current_scope}] do
      live "/", PageLive
    end

    live_session :current_user,
      on_mount: [{LuaNoxWeb.UserAuth, :mount_current_scope}] do
      live "/login", UserLive.Login, :new
    end
  end

  # Authentication routes
  scope "/", LuaNoxWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user do
      live "/settings", UserLive.Settings, :edit
    end

    delete "/logout", UserAuthController, :log_out_user
  end

  scope "/auth", LuaNoxWeb do
    pipe_through :browser

    get "/:provider", UserOauth, :request
    get "/:provider/callback", UserOauth, :callback
  end

  # Other scopes may use custom stacks.
  scope "/api", LuaNoxWeb do
    pipe_through :api
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:luanox, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: LuaNoxWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
