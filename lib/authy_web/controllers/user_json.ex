defmodule AuthyWeb.UserJSON do
  alias Authy.Accounts.User

  def login(%{token: token}) do
    %{data: %{token: token}}
  end

  def register(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      hashed_password: user.hashed_password
    }
  end
end
