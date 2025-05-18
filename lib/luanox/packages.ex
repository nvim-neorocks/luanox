defmodule LuaNox.Packages do
  @moduledoc """
  The Packages context.
  """

  import Ecto.Query, warn: false
  alias LuaNox.Repo

  alias LuaNox.Packages.Package
  alias LuaNox.Accounts.Scope

  @doc """
  Subscribes to scoped notifications about any package changes.

  The broadcasted messages match the pattern:

    * {:created, %Package{}}
    * {:updated, %Package{}}
    * {:deleted, %Package{}}

  """
  def subscribe_packages(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LuaNox.PubSub, "user:#{key}:packages")
  end

  defp broadcast(%Scope{} = scope, message) do
    key = scope.user.id

    Phoenix.PubSub.broadcast(LuaNox.PubSub, "user:#{key}:packages", message)
  end

  @doc """
  Returns the list of packages.

  ## Examples

      iex> list_packages(scope)
      [%Package{}, ...]

  """
  def list_packages() do
    Repo.all(Package) |> Repo.preload(:releases)
  end

  @doc """
  Gets a single package.

  Raises `Ecto.NoResultsError` if the Package does not exist.

  ## Examples

      iex> get_package!(123)
      %Package{}

      iex> get_package!(456)
      ** (Ecto.NoResultsError)

  """
  def get_package!(id) do
    Repo.get_by!(Package, id: id)
  end

  @doc """
  Creates a package.

  ## Examples

      iex> create_package(%{field: value})
      {:ok, %Package{}}

      iex> create_package(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_package(%Scope{} = scope, attrs) do
    with {:ok, package = %Package{}} <-
           %Package{}
           |> Package.changeset(attrs, scope)
           |> Repo.insert() do
      broadcast(scope, {:created, package})
      {:ok, package}
    end
  end

  @doc """
  Updates a package.

  ## Examples

      iex> update_package(package, %{field: new_value})
      {:ok, %Package{}}

      iex> update_package(package, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_package(
        %Scope{} = scope,
        %Package{} = package,
        %{summary: _, description: _} = attrs
      ) do
    true = package.user_id == scope.user.id

    with {:ok, package = %Package{}} <-
           package
           |> Package.changeset(attrs, scope)
           |> Repo.update() do
      broadcast(scope, {:updated, package})
      {:ok, package}
    end
  end

  @doc """
  Deletes a package.

  ## Examples

      iex> delete_package(package)
      {:ok, %Package{}}

      iex> delete_package(package)
      {:error, %Ecto.Changeset{}}

  """
  def delete_package(%Scope{} = scope, %Package{} = package) do
    true = package.user_id == scope.user.id

    with {:ok, package = %Package{}} <-
           Repo.delete(package) do
      broadcast(scope, {:deleted, package})
      {:ok, package}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking package changes.

  ## Examples

      iex> change_package(package)
      %Ecto.Changeset{data: %Package{}}

  """
  def change_package(%Scope{} = scope, %Package{} = package, attrs \\ %{}) do
    true = package.user_id == scope.user.id

    Package.changeset(package, attrs, scope)
  end

  alias LuaNox.Packages.Release

  @doc """
  Subscribes to scoped notifications about any release changes.

  The broadcasted messages match the pattern:

    * {:created, %Release{}}
    * {:updated, %Release{}}
    * {:deleted, %Release{}}

  """
  def subscribe_releases(%Scope{} = scope) do
    key = scope.user.id

    Phoenix.PubSub.subscribe(LuaNox.PubSub, "user:#{key}:releases")
  end

  @doc """
  Returns the list of releases.

  ## Examples

      iex> list_releases(scope)
      [%Release{}, ...]

  """
  def list_releases(%Package{} = package) do
    Repo.get(Package, package)
    |> Repo.preload(:releases)
    |> Map.get(:releases)
  end

  @doc """
  Gets a single release.

  Raises `Ecto.NoResultsError` if the Release does not exist.

  ## Examples

      iex> get_release!(123)
      %Release{}

      iex> get_release!(456)
      ** (Ecto.NoResultsError)

  """
  def get_release!(id) do
    Repo.get_by!(Release, id: id)
  end

  @doc """
  Creates a release.
  """
  def add_release(%Scope{} = scope, %Package{} = package, attrs) do
    with {:ok, release} <-
           package
           |> Ecto.build_assoc(:releases)
           |> Release.changeset(attrs)
           |> Repo.insert() do
      broadcast(scope, {:created, release})
      {:ok, release}
    end
  end

  @doc """
  Deletes a release.

  ## Examples

      iex> delete_release(release)
      {:ok, %Release{}}

      iex> delete_release(release)
      {:error, %Ecto.Changeset{}}

  """
  def delete_release(%Scope{} = scope, %Release{} = release) do
    release_scope = Scope.for_release(release)

    true = release_scope == scope

    with {:ok, release = %Release{}} <-
           Repo.delete(release) do
      broadcast(scope, {:deleted, release})
      {:ok, release}
    end
  end
end
