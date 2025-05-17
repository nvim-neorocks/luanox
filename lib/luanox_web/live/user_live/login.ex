defmodule LuaNoxWeb.UserLive.Login do
  use LuaNoxWeb, :live_view

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm space-y-4 py-8">
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
            navigate={~p"/auth/github"}
            id="github-login"
            phx-hook="GithubLogin"
          >
            <%!-- <.icon name={:github} type={:filled} class="mr-2" /> --%> GitHub
          </.link>
        </div>
      </div>
    </Layouts.app>
    """
  end
end
