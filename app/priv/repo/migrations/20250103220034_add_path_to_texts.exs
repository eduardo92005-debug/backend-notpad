defmodule App.Repo.Migrations.AddPathToTexts do
  use Ecto.Migration

  def change do
    alter table(:texts) do
      add :path, :string, null: false  # Adiciona a coluna path, não permitindo valores nulos
    end

    create unique_index(:texts, [:path])  # Garante que cada path seja único
  end
end
