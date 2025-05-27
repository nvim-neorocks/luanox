defmodule LuaNoxWeb.PackageBox do
  use LuaNoxWeb, :html

  attr :name, :string, required: true
  attr :description, :string, default: ""
  attr :version, :string, default: "0.1.0"

  def package(assigns) do
    ~H"""
    <.link navigate={~p"/package/#{@name}"}>
      <div role="button" class="card w-72 md:w-96 transition-colors ease-in duration-200 motion-reduce:transition-none motion-reduce:hover:transform-none bg-base-200 hover:bg-base-300 border border-dark-grey">
        <div class="card-body">
          <div class="flex justify-between">
            <h2 class="card-title">{@name}</h2>
            <span class="font-semibold md:text-lg">v{@version}</span>
          </div>
          <p class="justify-self-start">{@description}</p>
        </div>
      </div>
    </.link>
    """
  end

  attr :packages, :map, required: true

  def packages(assigns) do
    ~H"""
    <div class="flex flex-col items-center py-4">
      <%!-- FIXME: this should show the most downloaded packages once we implement downloads count --%>
      <h2 class="text-2xl font-bold mb-4">Featured Packages</h2>
      <div class="flex flex-col md:flex-row md:flex-wrap lg:flex-nowrap gap-4 items-center justify-center max-w-screen-lg md:w-full mb-12">
        <%= for %{name: name, summary: summary, releases: releases} <- assigns[:packages] |> Enum.take(4) do %>
          <.package
            name={name}
            version={(List.last(releases) || %{version: ""}) |> Map.get(:version)}
            description={summary}
          />
        <% end %>
      </div>
      <h2 class="text-2xl font-bold mb-4">Most Recent Updates</h2>
      <div class="flex flex-col md:flex-row md:flex-wrap lg:flex-nowrap gap-4 items-center justify-center max-w-screen-lg md:w-full mb-12">
        <%= for %{name: name, summary: summary, releases: releases} <- assigns[:packages] |> Enum.take(4) do %>
          <.package
            name={name}
            version={(List.last(releases) || %{version: ""}) |> Map.get(:version)}
            description={summary}
          />
        <% end %>
      </div>
    </div>
    """
  end
end
