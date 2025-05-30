defmodule GamesWeb.GameControllerTest do
  use GamesWeb.ConnCase

  import Games.AdminFixtures

  @create_attrs %{name: "some name",  slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  describe "index" do
    test "lists all games", %{conn: conn} do
      conn = get(conn, ~p"/games")
      assert html_response(conn, 200) =~ "Listing Games"
    end
  end

  describe "new game" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/games/new")
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "create game" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/games", game: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/games/#{id}"

      conn = get(conn, ~p"/games/#{id}")
      assert html_response(conn, 200) =~ "#{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/games", game: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Game"
    end
  end

  describe "edit game" do
    setup [:create_game]

    test "renders form for editing chosen game", %{conn: conn, game: game} do
      conn = get(conn, ~p"/games/#{game}/edit")
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "update game" do
    setup [:create_game]

    test "redirects when data is valid", %{conn: conn, game: game} do
      conn = put(conn, ~p"/games/#{game}", game: @update_attrs)
      assert redirected_to(conn) == ~p"/games/#{game}"

      conn = get(conn, ~p"/games/#{game}")
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, game: game} do
      conn = put(conn, ~p"/games/#{game}", game: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Game"
    end
  end

  describe "delete game" do
    setup [:create_game]

    test "deletes chosen game", %{conn: conn, game: game} do
      conn = delete(conn, ~p"/games/#{game}")
      assert redirected_to(conn) == ~p"/games"

      assert_error_sent 404, fn ->
        get(conn, ~p"/games/#{game}")
      end
    end
  end

  defp create_game(_) do
    game = game_fixture()
    %{game: game}
  end
end
