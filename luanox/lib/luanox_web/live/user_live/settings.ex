defmodule LuaNoxWeb.UserLive.Settings do
  use LuaNoxWeb, :live_view

  on_mount {LuaNoxWeb.UserAuth, :require_sudo_mode}

  def mount(_params, _session, socket) do
    # TODO: actually use a changeset or create the Phoenix.HTML.Form struct by hand
    {:ok, socket |> assign(:email_form, nil) |> assign(:username_form, nil)}
  end

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header class="text-center py-8">
        Account Settings
        <:subtitle>Manage your nicknames and other credentials here.</:subtitle>
      </.header>

      <%!-- user data: email, username, aka --%>
      <%!-- TODO: Add "update nickname" and other things here --%>
      <div class="md:container md:mx-auto mx-8">
        <%!-- TODO: add handle_event function for the update_email event --%>
        <.form for={@email_form} id="email_form" phx-submit="update_email">
          <%!-- phx-change="validate_email"> --%>
          <.input
            field={@current_scope.user.email}
            type="email"
            name="user-email"
            placeholder={@current_scope.user.email}
            value=""
            label="Email"
            autocomplete="username"
            required
          />
          <button role="button" class="btn btn-primary btn-block" phx-disable-with="Changing...">
            Change Email
          </button>
        </.form>
        <div class="divider" />
        <%!-- TODO: add handle_event function for the update_email event --%>
        <.form for={@username_form} id="username_form" phx-submit="update_username">
          <%!-- phx-change="validate_username"> --%>
          <.input
            field={@current_scope.user.username}
            type="username"
            name="user-name"
            placeholder={@current_scope.user.username}
            value=""
            label="Username"
            autocomplete="username"
            required
          />
          <button role="button" class="btn btn-primary btn-block" phx-disable-with="Changing...">
            Change Username
          </button>
        </.form>
      </div>
    </Layouts.app>
    """
  end
end
