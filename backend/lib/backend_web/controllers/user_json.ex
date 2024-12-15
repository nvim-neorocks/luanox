defmodule LuanoxWeb.UserJSON do
  alias Luanox.Accounts.User

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      username: user.username,
      aka: user.aka,
      platform: user.platform
    }
  end
end
