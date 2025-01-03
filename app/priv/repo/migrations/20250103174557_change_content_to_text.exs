defmodule App.Repo.Migrations.ChangeContentToText do
  use Ecto.Migration

  def change do
    alter table(:texts) do
      modify :content, :text  # Alterar o tipo de 'content' para 'text'
    end
  end
end
