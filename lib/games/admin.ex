defmodule Games.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Games.Repo

  alias Games.Admin.Game
  alias Games.Admin.Puzzle

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id) |> Repo.preload(:puzzles)

  def get_game_by!(id), do: Repo.get_by!(Game, slug: id) |> Repo.preload(:puzzles)


  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

   @doc """
  Deletes a game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{data: %Game{}}

  """
  def change_game(%Game{} = game, attrs \\ %{}) do
    Game.changeset(game, attrs)
  end

  alias Games.Admin.Puzzle

  @doc """
  Returns the list of puzzles.

  ## Examples

      iex> list_puzzles()
      [%Puzzle{}, ...]

  """

  def list_puzzles do
    Repo.all(Puzzle)
  end

  @doc """
  Gets a single puzzle.

  Raises `Ecto.NoResultsError` if the Puzzle does not exist.

  ## Examples

      iex> get_puzzle!(123)
      %Puzzle{}

      iex> get_puzzle!(456)
      ** (Ecto.NoResultsError)

  """
  def get_puzzle!(id), do: Repo.get!(Puzzle, id)

  @doc """
  Creates a puzzle.

  ## Examples

      iex> create_puzzle(%{field: value})
      {:ok, %Puzzle{}}

      iex> create_puzzle(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  #def create_puzzle(attrs \\ %{}) do
  #  %Puzzle{}
  #  |> Puzzle.changeset(attrs)
  #  |>IO.inspect(label: "Save puzzle")
  #  |> Repo.insert()
  #end

  def create_puzzle(game, attrs) do
    attrs = Map.put(attrs, "game_id", game.id)

    %Puzzle{}
    |> Puzzle.changeset(attrs)
    |> Repo.insert()
  end



   @doc """
  Updates a puzzle.

  ## Examples

      iex> update_puzzle(puzzle, %{field: new_value})
      {:ok, %Puzzle{}}

      iex> update_puzzle(puzzle, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_puzzle(%Puzzle{} = puzzle, attrs) do
    puzzle
    |> Puzzle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a puzzle.

  ## Examples

      iex> delete_puzzle(puzzle)
      {:ok, %Puzzle{}}

      iex> delete_puzzle(puzzle)
      {:error, %Ecto.Changeset{}}

  """
  def delete_puzzle(%Puzzle{} = puzzle) do
    Repo.delete(puzzle)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking puzzle changes.

  ## Examples

      iex> change_puzzle(puzzle)
      %Ecto.Changeset{data: %Puzzle{}}

  """
  def change_puzzle(%Puzzle{} = puzzle, attrs \\ %{}) do
    Puzzle.changeset(puzzle, attrs)
    |> IO.inspect
  end
end
