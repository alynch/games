defmodule Games.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Games.Admin` context.
  """

  @doc """
  Generate a game.
  """
  def game_fixture(attrs \\ %{}) do
    {:ok, game} =
      attrs
      |> Enum.into(%{
        date: ~D[2025-05-15],
        name: "some name",
        slug: "some slug"
      })
      |> Games.Admin.create_game()

    game
  end
end
