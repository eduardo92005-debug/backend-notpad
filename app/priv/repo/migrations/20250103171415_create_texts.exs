defmodule App.Repo.Migrations.CreateTexts do
  use Ecto.Migration

  def change do
    create table(:texts) do
      add :content, :string

      timestamps(type: :utc_datetime)
    end
  end
end
