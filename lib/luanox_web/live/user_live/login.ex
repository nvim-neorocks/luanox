defmodule LuaNoxWeb.UserLive.Login do
  use LuaNoxWeb, :live_view

  alias LuaNox.Accounts

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <div class="mx-auto max-w-sm space-y-4">
        <.header class="text-center">
          <p>Log in</p>
          <:subtitle>
            <%= if @current_scope do %>
              You need to reauthenticate to perform sensitive actions on your account.
            <% else %>
              <!-- Information about how we don't support regular logins for security -->
            <% end %>
          </:subtitle>
        </.header>

        <.form
          :let={f}
          for={@form}
          id="login_form_magic"
          action={~p"/users/login"}
          phx-submit="submit_magic"
        >
          <.input
            readonly={!!@current_scope}
            field={f[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            required
            phx-mounted={JS.focus()}
          />
          <.button class="w-full" variant="primary">
            Log in with email <span aria-hidden="true">→</span>
          </.button>
        </.form>

        <div class="divider">or</div>

        <.form
          :let={f}
          for={@form}
          id="login_form_password"
          action={~p"/users/login"}
          phx-submit="submit_password"
          phx-trigger-action={@trigger_submit}
        >
          <.input
            readonly={!!@current_scope}
            field={f[:email]}
            type="email"
            label="Email"
            autocomplete="username"
            required
          />
          <.input
            field={@form[:password]}
            type="password"
            label="Password"
            autocomplete="current-password"
          />
          <.input
            :if={!@current_scope}
            field={f[:remember_me]}
            type="checkbox"
            label="Keep me logged in"
          />
          <.button class="w-full" variant="primary">
            Log in <span aria-hidden="true">→</span>
          </.button>
        </.form>
      </div>
    </Layouts.app>
    """
  end

  def mount(%{action: "new"}, _session, socket) do
    email =
      Phoenix.Flash.get(socket.assigns.flash, :email) ||
        get_in(socket.assigns, [:current_scope, Access.key(:user), Access.key(:email)])

    form = to_form(%{"email" => email}, as: "user")

    {:ok, assign(socket, form: form, trigger_submit: false)}
  end
end
