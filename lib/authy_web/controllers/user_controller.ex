defmodule AuthyWeb.UserController do
  use AuthyWeb, :controller

  alias Authy.Accounts

  action_fallback AuthyWeb.FallbackController

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_user_by_email_and_password(email, password) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: "invalid email or password"})

      user ->

        {:ok, token, _claims} = Authy.Auth.encode_and_sign(%{sub: user.id})

        conn
        |> put_status(:ok)
        |> render(:login, token: token)
    end
  end

  def register(conn, %{"email" => email, "password" => password}) do
    case Accounts.register_user(%{email: email, password: password}) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(:register, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "invalid attributes", details: changeset.errors})
    end
  end

  def validate(conn, %{"token" => token}) do
    case Authy.Auth.verify_and_validate(token) do
      {:ok, claims} ->
        conn |> put_status(:ok) |> json(%{data: %{user_id: claims["sub"]}})

      {:error, _reason} ->
        conn |> put_status(:unauthorized) |> json(%{error: "invalid token"})
    end
  end
end
