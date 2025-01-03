defmodule AppWeb.UserSocket do
  use Phoenix.Socket

  channel "editor:shared", AppWeb.EditorChannel

  def connect(_params, socket, _connect_info) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
