defmodule LuaNoxWeb.Pipelines.ApiPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :luanox,
    module: LuaNox.Guardian,
    error_handler: LuaNoxWeb.FallbackController

  @claims %{iss: "luanox", aud: "luanox", typ: "access"}

  plug Guardian.Plug.VerifyHeader, claims: @claims, scheme: "Bearer"
  plug Guardian.Plug.LoadResource, allow_blank: true
end
