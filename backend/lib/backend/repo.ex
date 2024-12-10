defmodule Luanox.Repo do
  use Ecto.Repo,
    otp_app: :backend,
    adapter: Ecto.Adapters.Postgres
end
