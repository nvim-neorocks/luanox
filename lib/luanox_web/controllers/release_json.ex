defmodule LuaNoxWeb.ReleaseJSON do
  alias LuaNox.Packages.Release

  @doc """
  Renders a list of releases.
  """
  def index(%{releases: releases}) do
    %{data: for(release <- releases, do: data(release))}
  end

  @doc """
  Renders a single release.
  """
  def show(%{release: release}) do
    %{data: data(release)}
  end

  defp data(%Release{} = release) do
    %{
      version: release.version,
      rockspec: release.rockspec
    }
  end
end
