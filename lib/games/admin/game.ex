defmodule Games.Admin.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    field :name, :string
    field :slug, :string
    has_many :puzzles, Games.Admin.Puzzle

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:name, :slug])
    |> validate_required([:name, :slug])
  end
end
