defmodule LuaNoxWeb.PageLive do
  alias LuaNox.Packages
  use LuaNoxWeb, :live_view

  import LuaNoxWeb.PackageBox

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:packages, Packages.list_packages(:exact, "lua"))}
  end
end
