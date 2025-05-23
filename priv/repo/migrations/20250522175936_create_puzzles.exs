defmodule Games.Repo.Migrations.CreatePuzzles do
  use Ecto.Migration

  def change do
    create table(:puzzles) do
      add :name, :string
      add :data, :text
      add :date, :date
      add :game_id, references(:games, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:puzzles, [:game_id])
  end
end
