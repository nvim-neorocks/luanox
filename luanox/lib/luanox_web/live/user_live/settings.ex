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
      <div class="bg-base-100 border-b border-base-300">
        <div class="max-w-4xl mx-auto px-4 lg:px-8 py-6 lg:py-8">
          <div class="flex flex-col sm:flex-row items-start justify-center sm:items-center gap-4 sm:gap-6">
            <div class="w-16 h-16 sm:w-20 sm:h-20 bg-primary/10 border-2 border-primary/20 rounded-full flex items-center justify-center flex-shrink-0">
              <.icon name={:user} type={:outline} class="w-10 h-10 sm:w-12 sm:h-12 text-primary" />
            </div>

            <div class="space-y-1">
              <h1 class="text-2xl sm:text-3xl font-bold text-base-content">
                Account Settings
              </h1>
              <p class="text-sm sm:text-base text-base-content/70">
                Manage your profile, email, and account preferences
              </p>
            </div>
          </div>
        </div>
      </div>

      <div class="max-w-4xl mx-auto px-4 lg:px-8 py-6 lg:py-8">
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
          <div class="lg:col-span-1">
            <div class="bg-base-200 border border-base-300 p-6 shadow-sm space-y-6">
              <div class="text-center">
                <div class="w-24 h-24 bg-primary/10 border-2 border-primary/20 rounded-full flex items-center justify-center mx-auto mb-4">
                  <.icon name={:user} type={:outline} class="w-16 h-16 text-primary" />
                </div>

                <h3 class="text-lg font-semibold text-base-content mb-1">
                  {@current_scope.user.username}
                </h3>
                <p class="text-sm text-base-content/60 mb-4">
                  {@current_scope.user.email}
                </p>
              </div>

              <div class="border-t border-base-300 pt-4 space-y-3">
                <div class="flex justify-between items-center">
                  <span class="text-sm text-base-content/60">Member since</span>
                  <span class="text-sm font-medium">August 2025</span>
                </div>
                <div class="flex justify-between items-center">
                  <span class="text-sm text-base-content/60">Auth provider</span>
                  <span class="text-sm font-medium text-primary">GitHub</span>
                </div>
                <div class="flex justify-between items-center">
                  <span class="text-sm text-base-content/60">Account type</span>
                  <span class="text-sm font-medium text-secondary">Standard</span>
                </div>
              </div>
            </div>
          </div>
          <div class="lg:col-span-2 space-y-6">
            <div class="bg-base-200 border border-base-300 p-6 shadow-sm">
              <div class="flex items-center gap-3 mb-4">
                <.icon name={:mail} type={:outline} class="w-5 h-5 text-primary" />
                <h2 class="text-lg font-semibold text-base-content">Email Address</h2>
              </div>

              <p class="text-sm text-base-content/70 mb-4">
                Update your email address for account notifications and login.
              </p>

              <.form for={@email_form} id="email_form" phx-submit="update_email" class="space-y-4">
                <.input
                  field={@current_scope.user.email}
                  type="email"
                  name="user-email"
                  placeholder={@current_scope.user.email}
                  value=""
                  label="Email Address"
                  autocomplete="email"
                  required
                />
                <div class="pt-2">
                  <button
                    role="button"
                    class="btn bg-primary text-primary-content border-primary hover:bg-primary/90 w-full sm:w-auto"
                    phx-disable-with="Updating..."
                  >
                    <.icon name={:check} type={:outline} class="w-4 h-4" /> Update Email
                  </button>
                </div>
              </.form>
            </div>

            <div class="bg-base-200 border border-base-300 p-6 shadow-sm">
              <div class="flex items-center gap-3 mb-4">
                <.icon name={:user} type={:outline} class="w-5 h-5 text-secondary" />
                <h2 class="text-lg font-semibold text-base-content">Username</h2>
              </div>

              <p class="text-sm text-base-content/70 mb-4">
                Choose a unique username that will be displayed publicly.
              </p>

              <.form
                for={@username_form}
                id="username_form"
                phx-submit="update_username"
                class="space-y-4"
              >
                <.input
                  field={@current_scope.user.username}
                  type="text"
                  name="user-name"
                  placeholder={@current_scope.user.username}
                  value=""
                  label="Username"
                  autocomplete="username"
                  required
                />
                <div class="pt-2">
                  <button
                    role="button"
                    class="btn bg-secondary text-secondary-content border-secondary hover:bg-secondary/90 w-full sm:w-auto"
                    phx-disable-with="Updating..."
                  >
                    <.icon name={:check} type={:outline} class="w-4 h-4" /> Update Username
                  </button>
                </div>
              </.form>
            </div>

            <div class="bg-base-200 border border-base-300 p-6 shadow-sm">
              <div class="flex items-center gap-3 mb-4">
                <.icon name={:settings} type={:outline} class="w-5 h-5 text-secondary" />
                <h2 class="text-lg font-semibold text-base-content">Preferences</h2>
              </div>

              <p class="text-sm text-base-content/70 mb-4">
                Customize your experience on the platform.
              </p>

              <div class="space-y-4">
                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-sm font-medium">Email Notifications</p>
                    <p class="text-xs text-base-content/60">Receive updates about your packages</p>
                  </div>
                  <input type="checkbox" class="toggle toggle-primary" checked />
                </div>

                <div class="flex items-center justify-between">
                  <div>
                    <p class="text-sm font-medium">Package Updates</p>
                    <p class="text-xs text-base-content/60">Get notified about new releases</p>
                  </div>
                  <input type="checkbox" class="toggle toggle-primary" checked />
                </div>
              </div>
            </div>

            <div class="bg-base-200 border border-base-300 p-6 shadow-sm">
              <div class="flex items-center gap-3 mb-4">
                <.icon name={:settings} type={:outline} class="w-5 h-5 text-primary" />
                <h2 class="text-lg font-semibold text-base-content">Account Management</h2>
              </div>

              <p class="text-sm text-base-content/70 mb-4">
                Manage your account settings and connected services.
              </p>

              <div class="space-y-4">
                <div class="bg-base-100 border border-base-300 p-4 rounded">
                  <div class="flex items-center justify-between">
                    <div class="flex items-center gap-3">
                      <.icon name={:shield_check} type={:outline} class="w-5 h-5 text-green-500" />
                      <div>
                        <p class="text-sm font-medium">GitHub Account</p>
                        <p class="text-xs text-base-content/60">Authentication provider</p>
                      </div>
                    </div>
                    <span class="text-xs badge badge-success">Connected</span>
                  </div>
                </div>

                <div>
                  <button class="btn btn-neutral w-full sm:w-auto">
                    <.icon name={:refresh} type={:outline} class="w-4 h-4" /> Sync Profile Data
                  </button>
                  <button
                    class="btn btn-error w-full sm:w-auto"
                    onclick="disable_account_modal.showModal()"
                  >
                    <.icon name={:trash} type={:outline} class="w-4 h-4" /> Disable Account
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <dialog id="disable_account_modal" class="modal">
        <div class="modal-box">
          <h3 class="text-lg font-bold text-base-content mb-4">Are you sure?</h3>
          <p class="text-sm text-base-content/80 mb-6">
            Disabling your account prevents you from creating or updating any of your packages. You can reenable your account at any time.
          </p>
          <div class="modal-action">
            <form method="dialog">
              <button class="btn btn-neutral mr-3">
                Cancel
              </button>
            </form>
            <button
              class="btn btn-error"
              phx-click="disable_account"
            >
              <.icon name={:trash} type={:outline} class="w-4 h-4" /> Disable Account
            </button>
          </div>
        </div>
        <form method="dialog" class="modal-backdrop">
          <button>close</button>
        </form>
      </dialog>
    </Layouts.app>
    """
  end
end
