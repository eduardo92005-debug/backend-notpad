defmodule App.Text do
  use Ecto.Schema
  import Ecto.Changeset

  schema "texts" do
    field :content, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(text, attrs) do
    text
    |> cast(attrs, [:content])
    |> validate_required([:content])
  end
end
