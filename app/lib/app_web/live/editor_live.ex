defmodule AppWeb.EditorLive do
  use AppWeb, :live_view
  import Ecto.Query
  alias Phoenix.PubSub
  alias App.Repo
  alias App.Text

  @topic_prefix "editor:shared:"

  def mount(%{"path" => path}, _session, socket) do
    topic = "#{@topic_prefix}#{path}"
    path = if is_list(path), do: List.first(path), else: path
    if connected?(socket) do
      PubSub.subscribe(App.PubSub, topic)
    end

    # Buscar o texto associado ao path
    text = Repo.get_by(Text, path: path)

    # Se não encontrar um texto, cria o texto inicial para o path
    text = if text do
      text
    else
      # Criar um changeset para o novo texto
      %Text{content: "Texto inicial", path: path}
      |> Text.changeset(%{content: "Texto inicial", path: path})  # Aplicando o changeset
      |> Repo.insert!()  # Insere o texto com o changeset validado
    end

    {:ok, assign(socket, text: text.content, path: path, topic: topic)}
  end

  def handle_event("update_text", %{"editor" => new_text}, socket) do
    path = socket.assigns.path
    topic = socket.assigns.topic

    # Buscar o texto associado ao path
    text = Repo.get_by(Text, path: path) || %Text{content: new_text, path: path}

    # Alterar o conteúdo do texto
    changeset = Text.changeset(text, %{content: new_text})

    case Repo.insert_or_update(changeset) do
      {:ok, updated_text} ->
        # Propagar a atualização para outros clientes conectados via PubSub
        PubSub.broadcast(App.PubSub, topic, {:update_text, updated_text.content})
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
