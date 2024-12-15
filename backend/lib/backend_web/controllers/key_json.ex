defmodule LuanoxWeb.KeyJSON do
  alias Luanox.Accounts.Key

  @doc """
  Renders a list of keys.
  """
  def index(%{keys: keys}) do
    %{data: for(key <- keys, do: data(key))}
  end

  @doc """
  Renders a single key.
  """
  def show(%{key: key}) do
    %{data: data(key)}
  end

  defp data(%Key{} = key) do
    %{
      id: key.id,
      hash: key.hash
    }
  end
end
