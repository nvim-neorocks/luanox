defmodule LuaNoxWeb.NavBar do
  use LuaNoxWeb, :html
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  def navbar(assigns) do
    ~H"""
    <nav class="navbar bg-base-300 shadow-sm px-4 md:text-lg">
      <div class="navbar-start flex-1">
        <.link class="flex items-center text-2xl" navigate={~p"/"}>
          <.logo class="h-6 md:h-8 w-auto md:mr-2" />
          <span class="hidden md:inline font-semibold">Luanox</span>
        </.link>
      </div>

    <!-- Global menu items (always there no matters if mobile or desktop) -->
      <div class="flex items-center space-x-2 md:space-x-6">
        <LuaNoxWeb.Layouts.theme_toggle />
        <button
          class="md:hidden btn btn-ghost rounded-field text-grey hover:text-base-content"
          phx-click={
            JS.toggle(to: "#mobile-menu")
            |> JS.toggle_class("hidden", to: "#menu-icon")
            |> JS.toggle_class("hidden", to: "#close-icon")
          }
        >
          <.icon id="menu-icon" name={:menu_deep} type={:outline} class="size-5" />
          <.icon id="close-icon" name={:x} type={:outline} class="hidden hover:text-error size-5" />
        </button>
      </div>

      <.desktop_menu />
      <.mobile_menu />
    </nav>
    """
  end

  defp create_dropdown(assigns) do
    ~H"""
    <!-- TODO: make this hidden unless an user is logged in -->
    <div class="dropdown dropdown-center">
      <div
        tabindex="0"
        role="button"
        class="btn btn-ghost text-grey hover:text-info rounded-field"
      >
        <.icon name={:square_plus} type={:outline} />
        <span class="mt-px">Create</span>
      </div>
      <ul
        tabindex="0"
        class="menu dropdown-content bg-base-100 rounded-box z-1 mt-4 w-52 p-2 shadow-sm"
      >
        <li>
          <.link>API Key</.link>
        </li>
        <hr class="text-dark-grey mt-1 mb-1" />
        <li>
          <.link>Module</.link>
        </li>
      </ul>
    </div>
    """
  end

  defp account_dropdown(assigns) do
    ~H"""
    <!--
      TODO: add logged user items and use conditionals.

      logged user items:
        - profile
        - settings
        - reports
        - logout (add a separator before this one)
    -->
    <div class="dropdown dropdown-center md:dropdown-end">
      <div
        tabindex="0"
        role="button"
        class="btn btn-ghost text-grey hover:text-info rounded-field"
      >
        <.icon name={:user_circle} type={:outline} />
        <span class="mt-px">Account</span>
      </div>
      <ul
        tabindex="0"
        class="menu dropdown-content bg-base-100 rounded-box z-1 mt-4 w-52 p-2 shadow-sm"
      >
        <li>
          <.link>Login</.link>
        </li>
        <hr class="text-dark-grey mt-1 mb-1" />
        <li>
          <.link>Register</.link>
        </li>
      </ul>
    </div>
    """
  end

  defp desktop_menu(assigns) do
    ~H"""
    <div class="hidden md:flex items-center space-x-2">
      <ul class="menu menu-horizontal px-1 space-x-2">
        <li>
          <.link class="btn btn-ghost text-grey hover:text-info" href="/docs">
            <.icon name={:book_2} type={:outline} />
            <span class="mt-px">Docs</span>
          </.link>
        </li>
        <.create_dropdown />
        <.account_dropdown />
      </ul>
    </div>
    """
  end

  defp mobile_menu(assigns) do
    ~H"""
    <div id="mobile-menu" class="hidden absolute top-16 left-0 w-full bg-base-300 rounded-b-md shadow-md flex flex-row items-center justify-between pt-2 pb-4 px-6 md:hidden z-10">
      <ul class="menu menu-horizontal justify-between w-full">
        <li>
          <.link class="btn btn-ghost text-grey hover:text-info" href="/docs">
            <.icon name={:book_2} type={:outline} />
              <span class="mt-px">Docs</span>
          </.link>
        </li>
        <hr class="border-l border-dark-grey h-auto" />
        <.create_dropdown />
        <hr class="border-l border-dark-grey h-auto" />
        <.account_dropdown />
      </ul>
    </div>
    """
  end
end
