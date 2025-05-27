defmodule LuaNoxWeb.UserLive.Login do
  use LuaNoxWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <%!-- The height calculation inherits both the navbar and footer sizes in px --%>
      <div class="flex h-[calc(100vh-116px)] md:h-[calc(100vh-124px)]">
        <div class="max-w-sm space-y-4 py-8 m-auto">
          <.header class="text-center">
            <p>Choose an OAuth Provider</p>
            <:subtitle>
              <%= if @current_scope do %>
                You need to reauthenticate to perform sensitive actions on your account.
              <% else %>
                We don't support password logins for security reasons.
              <% end %>
            </:subtitle>
          </.header>

          <div class="flex flex-col space-y-4">
            <.link
              class="btn btn-primary"
              id="github-login"
              phx-disable-with="Redirecting..."
              navigate={~p"/auth/github"}
            >
              <.icon name={:brand_github} type={:filled} class="size-5" /> GitHub
            </.link>
          </div>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
