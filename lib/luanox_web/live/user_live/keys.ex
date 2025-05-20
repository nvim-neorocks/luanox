defmodule LuaNoxWeb.UserLive.Keys do
  use LuaNoxWeb, :live_view

  on_mount {LuaNoxWeb.UserAuth, :require_sudo_mode}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header class="text-center py-4">
        API Keys
        <:subtitle>Manage your API keys here.</:subtitle>
      </.header>
      <.button phx-click="generate_key" onclick="api_modal.showModal()">
        Create API Key
      </.button>

      <dialog id="api_modal" class="modal" phx-blur="delete_key">
        <div class="modal-box">
          <h3 class="text-lg font-bold">Hello!</h3>
          <p class="py-4">Here is your API key:</p>
          <p class="py-4">
            <span class="font-bold">{@generated_key}</span>
          </p>
          <p class="py-4">Yap yap keep it somewhere safe please.</p>
          <div class="modal-action">
            <form method="dialog">
              <!-- if there is a button in form, it will close the modal -->
              <button class="btn">Close</button>
            </form>
          </div>
        </div>
      </dialog>
    </Layouts.app>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:generated_key, nil)}
  end

  def handle_event("generate_key", _params, socket) do
    user = socket.assigns.current_scope.user
    true = user != nil

    # TODO: Add customizable claims and TTL
    # Never allow unbounded TTL as it will not only be a security risk but also
    # cause us to have to store a potentially infinite amount of revoked tokens in our database.
    # with bounded TTLs we can sweep the database for revoked tokens every 24h or so.
    {:ok, token, _claims} =
      LuaNox.Guardian.encode_and_sign(user, %{allowed_packages: nil, write_restriction: false},
        ttl: {4 * 24, :weeks}
      )

    # TODO: Remove
    IO.puts("Generated token: #{token}")

    {:noreply, assign(socket, :generated_key, token)}
  end

  def handle_event("delete_key", _params, socket) do
    {:noreply, socket |> assign(:generated_key, nil)}
  end
end
