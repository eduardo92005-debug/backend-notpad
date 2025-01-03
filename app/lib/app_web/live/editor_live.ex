defmodule AppWeb.EditorLive do
  use AppWeb, :live_view
  alias Phoenix.PubSub

  @topic "editor:shared"

  def mount(_params, _session, socket) do
    if connected?(socket) do
      PubSub.subscribe(App.PubSub, @topic)
      #push_event(socket, "init_text", %{text: socket.assigns.text})
    end

    initial_text = AppWeb.TextState.get_text()
    {:ok, assign(socket, text: initial_text)}
  end

  def handle_event("update_text", %{"editor" => new_text}, socket) do
    PubSub.broadcast(App.PubSub, @topic, {:update_text, new_text})
    {:noreply, assign(socket, text: new_text)}
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
