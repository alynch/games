defmodule Games.Admin.Puzzle do
  use Ecto.Schema
  import Ecto.Changeset

  schema "puzzles" do
    field :name, :string
    field :data, :string
    field :date, :date
    belongs_to :game, Games.Admin.Game

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(puzzle, attrs) do

    puzzle
    |> cast(attrs, [:name, :data, :date, :game_id])
    |> validate_required([:data, :date])
    |> IO.inspect
  end
end
