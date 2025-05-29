defmodule LuaNoxWeb.UserLive.Keys do
  use LuaNoxWeb, :live_view

  alias Phoenix.LiveView.JS

  on_mount {LuaNoxWeb.UserAuth, :require_sudo_mode}

  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header class="text-center py-4">
        API Keys
        <:subtitle>Manage your API keys here.</:subtitle>
      </.header>

      <div class="flex flex-col items-center">
        <button role="button" class="btn btn-primary btn-soft btn-wide " phx-click="generate_key" onclick="api_modal.showModal()">
          Create API Key
        </button>
      </div>

      <div class="pt-4 md:container mx-8 md:mx-auto" :if={@generated_key}>
        <div class="divider"></div>
        <p class="py-4 font-semibold">Here is your API key:</p>
        <div class="p-4 bg-base-300 rounded-sm">
          <p id="generated-key" class="font-bold font-mono wrap-anywhere">{@generated_key}</p>
        </div>
        <button class="btn btn-primary btn-soft btn-block mt-4" phx-click={JS.dispatch("phx:clipcopy", to: "#generated-key") |> JS.push("copy_key")}>
          <.icon name={:clipboard_text} type={:filled} class="size-5" />
          Copy API key
        </button>
        <p class="py-4 font-bold">Please make sure to keep it somewhere safe.</p>
        <%!-- TODO: make the whole generated API key div a modal so that this works --%>
        <%!-- <div class="modal-action">
          <form method="dialog">
            <!-- if there is a button in form, it will close the modal -->
            <button class="btn">Close</button>
          </form>
        </div> --%>
      </div>
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

    {:noreply, assign(socket, :generated_key, token)}
  end

  def handle_event("delete_key", _params, socket) do
    {:noreply, socket |> assign(:generated_key, nil)}
  end

  def handle_event("copy_key", _params, socket) do
    socket
    |> clear_flash()
    |> put_flash(:info, "Copied successfully!")
    |> (&{:noreply, &1}).()
  end
end
