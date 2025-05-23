defmodule Games.AdminTest do
  use Games.DataCase

  alias Games.Admin

  describe "games" do
    alias Games.Admin.Game

    import Games.AdminFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Admin.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Admin.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      valid_attrs = %{name: "some name",  slug: "some slug"}

      assert {:ok, %Game{} = game} = Admin.create_game(valid_attrs)
      assert game.name == "some name"
      assert game.slug == "some slug"
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Game{} = game} = Admin.update_game(game, update_attrs)
      assert game.name == "some updated name"
      assert game.slug == "some updated slug"
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_game(game, @invalid_attrs)
      assert game == Admin.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Admin.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Admin.change_game(game)
    end
  end
end
