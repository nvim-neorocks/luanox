defmodule LuaNoxWeb.PageLive do
  use LuaNoxWeb, :live_view

  import LuaNoxWeb.PackageBox

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:packages, [
       %{name: "luanox", description: "A Lua package manager", version: "0.1.0"}
     ])}
  end
end
