defmodule LuaNox.Repo do
  use Ecto.Repo,
    otp_app: :luanox,
    adapter: Ecto.Adapters.Postgres
end
