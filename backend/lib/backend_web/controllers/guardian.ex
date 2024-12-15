defmodule MyApp.Guardian do
  use Guardian, otp_app: :luanox
  alias Luanox.Accounts.User

  def subject_for_token(%User{ username: username, keys: keys }, _claims) do
    {:ok, username <> (keys |> length() |> to_string())}
  end

  def subject_for_token(_, _) do
    {:error, "expected User for token"}
  end

  def resource_from_claims(%{"sub" => id}) do

  end

  def resource_from_claims(_claims) do
    {:error, :reason_for_error}
  end
end
