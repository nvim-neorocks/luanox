defmodule LuaNoxWeb.PackageController do
  use LuaNoxWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias LuaNoxWeb.ReleaseController
  alias LuaNox.Packages.Release
  alias LuaNox.Packages
  alias LuaNox.Packages.Package

  action_fallback(LuaNoxWeb.FallbackController)

  operation(:index,
    summary: "Search packages",
    description: "Search for packages by name or keyword",
    parameters: [
      query: [
        in: :query,
        description: "Search query string",
        type: :string,
        required: true,
        example: "json"
      ]
    ],
    responses: %{
      200 =>
        {"Package search results", "application/json",
         %OpenApiSpex.Schema{
           type: :object,
           properties: %{
             data: %OpenApiSpex.Schema{
               type: :object,
               additionalProperties: %OpenApiSpex.Reference{
                 "$ref": "#/components/schemas/Package"
               }
             }
           }
         }},
      400 =>
        {"Missing query parameter", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}}
    }
  )

  def index(conn, %{"query" => query}) when is_binary(query) do
    packages = Packages.list_packages(:exact, query)
    render(conn, :index, packages: packages)
  end

  def index(_conn, _params), do: {:error, :no_query_string}

  operation(:create,
    summary: "Create a new package",
    description: "Create a new package in the repository",
    request_body:
      {"Package data", "application/json",
       %OpenApiSpex.Reference{"$ref": "#/components/schemas/PackageInput"}},
    responses: %{
      201 =>
        {"Package created successfully", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Package"}},
      422 =>
        {"Validation errors", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/ValidationError"}},
      401 =>
        {"Authentication required", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}}
    },
    security: [%{"ApiKeyAuth" => []}]
  )

  def create(conn, %{"package" => package_params}) do
    with {:ok, %Package{} = package} <-
           Packages.create_package(conn.assigns.current_scope, package_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/packages/#{package}")
      |> render(:show, package: package)
    else
      {:error, _} = ret -> ret
    end
  end

  operation(:show,
    summary: "Get a package",
    description: "Retrieve details for a specific package by name",
    parameters: [
      name: [
        in: :path,
        description: "Package name",
        type: :string,
        required: true,
        example: "lua-cjson"
      ]
    ],
    responses: %{
      200 =>
        {"Package details", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Package"}},
      404 =>
        {"Package not found", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}}
    }
  )

  def show(conn, %{"name" => name}) do
    package = Packages.get_package!(name)
    render(conn, :show, package: package)
  end

  operation(:update,
    summary: "Update a package",
    description: "Update package information",
    parameters: [
      name: [
        in: :path,
        description: "Package name",
        type: :string,
        required: true,
        example: "lua-cjson"
      ]
    ],
    request_body:
      {"Updated package data", "application/json",
       %OpenApiSpex.Reference{"$ref": "#/components/schemas/PackageInput"}},
    responses: %{
      200 =>
        {"Package updated successfully", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Package"}},
      404 =>
        {"Package not found", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}},
      422 =>
        {"Validation errors", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/ValidationError"}},
      401 =>
        {"Authentication required", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}}
    },
    security: [%{"ApiKeyAuth" => []}]
  )

  def update(conn, %{"name" => name, "package" => package_params}) do
    package = Packages.get_package!(name)

    with {:ok, %Package{} = package} <-
           Packages.update_package(conn.assigns.current_scope, package, package_params) do
      render(conn, :show, package: package)
    else
      {:error, _} = ret -> ret
    end
  end

  operation(:download,
    summary: "Download package release",
    description: "Download the latest release or a specific version of a package",
    parameters: [
      name: [
        in: :path,
        description: "Package name",
        type: :string,
        required: true,
        example: "lua-cjson"
      ],
      version: [
        in: :path,
        description: "Specific version to download (optional)",
        type: :string,
        required: false,
        example: "2.1.0"
      ]
    ],
    responses: %{
      200 =>
        {"Rockspec file", "application/octet-stream",
         %OpenApiSpex.Schema{type: :string, format: :binary}},
      404 =>
        {"Package or release not found", "application/json",
         %OpenApiSpex.Reference{"$ref": "#/components/schemas/Error"}}
    }
  )

  def download(conn, %{"name" => name, "version" => version}) do
    case Packages.get_package(name) do
      nil ->
        {:error, :not_found}

      package ->
        case Packages.get_release_by_package_and_version(package, version) do
          nil ->
            {:error, :not_found}

          %Release{} = release ->
            ReleaseController.show(conn, %{"id" => release.id})
        end
    end
  end

  def download(conn, %{"name" => name}) do
    case Packages.get_package(name) do
      nil ->
        {:error, :not_found}

      package ->
        case List.last(package.releases) do
          nil ->
            {:error, :not_found}

          %Release{} = release ->
            ReleaseController.show(conn, %{"id" => release.id})
        end
    end
  end
end
