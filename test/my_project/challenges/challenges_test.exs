defmodule MyProject.ChallengesTest do
  use MyProject.DataCase

  alias MyProject.Challenges

  describe "challenges" do
    alias MyProject.Challenges.Challenge

    @valid_attrs %{chat_id: "7488a646-e31f-11e4-aace-600308960662", description: "some description", response: "some response", title: "some title"}
    @update_attrs %{chat_id: "7488a646-e31f-11e4-aace-600308960668", description: "some updated description", response: "some updated response", title: "some updated title"}
    @invalid_attrs %{chat_id: nil, description: nil, response: nil, title: nil}

    def challenge_fixture(attrs \\ %{}) do
      {:ok, challenge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Challenges.create_challenge()

      challenge
    end

    test "list_challenges/0 returns all challenges" do
      challenge = challenge_fixture()
      assert Challenges.list_challenges() == [challenge]
    end

    test "get_challenge!/1 returns the challenge with given id" do
      challenge = challenge_fixture()
      assert Challenges.get_challenge!(challenge.id) == challenge
    end

    test "create_challenge/1 with valid data creates a challenge" do
      assert {:ok, %Challenge{} = challenge} = Challenges.create_challenge(@valid_attrs)
      assert challenge.chat_id == "7488a646-e31f-11e4-aace-600308960662"
      assert challenge.description == "some description"
      assert challenge.response == "some response"
      assert challenge.title == "some title"
    end

    test "create_challenge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Challenges.create_challenge(@invalid_attrs)
    end

    test "update_challenge/2 with valid data updates the challenge" do
      challenge = challenge_fixture()
      assert {:ok, challenge} = Challenges.update_challenge(challenge, @update_attrs)
      assert %Challenge{} = challenge
      assert challenge.chat_id == "7488a646-e31f-11e4-aace-600308960668"
      assert challenge.description == "some updated description"
      assert challenge.response == "some updated response"
      assert challenge.title == "some updated title"
    end

    test "update_challenge/2 with invalid data returns error changeset" do
      challenge = challenge_fixture()
      assert {:error, %Ecto.Changeset{}} = Challenges.update_challenge(challenge, @invalid_attrs)
      assert challenge == Challenges.get_challenge!(challenge.id)
    end

    test "delete_challenge/1 deletes the challenge" do
      challenge = challenge_fixture()
      assert {:ok, %Challenge{}} = Challenges.delete_challenge(challenge)
      assert_raise Ecto.NoResultsError, fn -> Challenges.get_challenge!(challenge.id) end
    end

    test "change_challenge/1 returns a challenge changeset" do
      challenge = challenge_fixture()
      assert %Ecto.Changeset{} = Challenges.change_challenge(challenge)
    end
  end
end
