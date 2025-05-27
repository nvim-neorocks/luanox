defmodule LuaNoxWeb.UserLive.Settings do
  use LuaNoxWeb, :live_view

  on_mount {LuaNoxWeb.UserAuth, :require_sudo_mode}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header class="text-center py-4">
        Account Settings
        <:subtitle>Manage your nicknames and other credentials here.</:subtitle>
      </.header>

      <%!-- TODO: Add "update nickname" and other things here --%>
      <%!-- <.form for={@email_form} id="email_form" phx-submit="update_email" phx-change="validate_email"> --%>
      <%!--   <.input --%>
      <%!--     field={@email_form[:email]} --%>
      <%!--     type="email" --%>
      <%!--     label="Email" --%>
      <%!--     autocomplete="username" --%>
      <%!--     required --%>
      <%!--   /> --%>
      <%!--   <.button variant="primary" phx-disable-with="Changing...">Change Email</.button> --%>
      <%!-- </.form> --%>

      <%!-- <div class="divider" /> --%>

    </Layouts.app>
    """
  end
end
