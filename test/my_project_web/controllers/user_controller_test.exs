defmodule MyProjectWeb.UserControllerTest do
  use MyProjectWeb.ConnCase

  alias MyProject.Accounts
  alias MyProject.Accounts.User

  @create_attrs %{
    email: "some email",
    encrypted_password: "some encrypted_password",
    first_name: "some first_name",
    last_name: "some last_name"
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "show user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = get conn, user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "email" => "some email",
        "encrypted_password" => "some encrypted_password",
        "first_name" => "some first_name",
        "last_name" => "some last_name"
      }
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
