defmodule MyProjectWeb.ChallengeControllerTest do
  use MyProjectWeb.ConnCase

  alias MyProject.Challenges
  alias MyProject.Challenges.Challenge

  @create_attrs %{
    chat_id: "7488a646-e31f-11e4-aace-600308960662",
    description: "some description",
    response: "some response",
    title: "some title"
  }
  @update_attrs %{
    chat_id: "7488a646-e31f-11e4-aace-600308960668",
    description: "some updated description",
    response: "some updated response",
    title: "some updated title"
  }
  @invalid_attrs %{chat_id: nil, description: nil, response: nil, title: nil}

  def fixture(:challenge) do
    {:ok, challenge} = Challenges.create_challenge(@create_attrs)
    challenge
  end

  def fixture(:user) do
    {:ok, user} =
      MyProject.Accounts.create_user(%{
        email: "alex@riedler.ca",
        first_name: "Alex",
        last_name: "Riedler",
        password: "foobar"
      })

    user
  end

  setup %{conn: conn} do
    user = fixture(:user)
    {:ok, conn: login_user(conn, user)}
  end

  describe "index" do
    test "lists all challenges", %{conn: conn} do
      conn = get(conn, challenge_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create challenge" do
    test "renders challenge when data is valid", %{conn: conn} do
      conn = post(conn, challenge_path(conn, :create), challenge: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, challenge_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "chat_id" => "7488a646-e31f-11e4-aace-600308960662",
               "description" => "some description",
               "response" => "some response",
               "title" => "some title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, challenge_path(conn, :create), challenge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update challenge" do
    setup [:create_challenge, :create_user]

    setup %{conn: conn, user: user} do
      {:ok, conn: login_user(conn, user)}
    end

    test "renders challenge when data is valid", %{
      conn: conn,
      challenge: %Challenge{id: id} = challenge,
      user: user
    } do
      conn = put(conn, challenge_path(conn, :update, challenge), challenge: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, challenge_path(conn, :show, id))

      assert json_response(conn, 200)["data"] == %{
               "id" => id,
               "chat_id" => "7488a646-e31f-11e4-aace-600308960668",
               "description" => "some updated description",
               "response" => "some updated response",
               "title" => "some updated title"
             }
    end

    test "renders errors when data is invalid", %{conn: conn, challenge: challenge} do
      conn = put(conn, challenge_path(conn, :update, challenge), challenge: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete challenge" do
    setup [:create_challenge, :create_user]

    setup %{conn: conn, user: user} do
      {:ok, conn: login_user(conn, user)}
    end

    test "deletes chosen challenge", %{conn: conn, challenge: challenge} do
      conn = delete(conn, challenge_path(conn, :delete, challenge))
      assert response(conn, 204)

      assert_error_sent(404, fn ->
        get(conn, challenge_path(conn, :show, challenge))
      end)
    end
  end

  defp create_challenge(_) do
    challenge = fixture(:challenge)
    {:ok, challenge: challenge}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end

  defp login_user(conn, user) do
    {:ok, token, _} = MyProject.Guardian.encode_and_sign(user, %{}, token_type: :access)

    conn
    |> put_req_header("accept", "application/json")
    |> put_req_header("authorization", "bearer: " <> token)
  end
end
