defmodule App.Text do
  use Ecto.Schema
  import Ecto.Changeset

  schema "texts" do
    field :content, :string
    field :path, :string
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(text, attrs) do
    text
    |> cast(attrs, [:content, :path])
    |> validate_required([:content, :path])
    |> unique_constraint(:path)
  end
end
