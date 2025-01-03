defmodule AppWeb.EditorLive do
  use AppWeb, :live_view
  import Ecto.Query
  alias Phoenix.PubSub
  alias App.Repo
  alias App.Text

  @topic "editor:shared"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      PubSub.subscribe(App.PubSub, @topic)
    end

    # Usando o from corretamente e garantindo que a consulta esteja bem definida
    query = from t in Text, order_by: [asc: t.id], limit: 1
    text = Repo.one(query)

    # Se não encontrar um texto, cria o texto inicial
    initial_text = if text do
      text
    else
      %Text{content: "Texto inicial"}
      |> Repo.insert!()  # Cria um novo texto com o conteúdo inicial
    end

    {:ok, assign(socket, text: initial_text.content)}
  end

  def handle_event("update_text", %{"editor" => new_text}, socket) do
    # Buscar o texto mais recente
    query = from t in Text, order_by: [asc: t.id], limit: 1
    text = Repo.one(query) || %Text{content: new_text}

    # Alterar o conteúdo do texto
    changeset = Text.changeset(text, %{content: new_text})

    case Repo.insert_or_update(changeset) do
      {:ok, updated_text} ->
        # Propagar a atualização para outros clientes conectados via PubSub
        PubSub.broadcast(App.PubSub, @topic, {:update_text, updated_text.content})
        {:noreply, assign(socket, text: updated_text.content)}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def handle_info({:update_text, new_text}, socket) do
    {:noreply, assign(socket, text: new_text)}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Rich Text Editor</h1>
      <form phx-change="update_text">
        <textarea
          id="editor"
          name="editor"
          rows="15"
          cols="80"
          phx-debounce="500">
          <%= @text %>
        </textarea>
      </form>
    </div>
    """
  end
end
