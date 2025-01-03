# lib/my_app/text_state.ex
defmodule AppWeb.TextState do
  use GenServer

  # Inicia o GenServer com um texto inicial
  def start_link(initial_text) do
    GenServer.start_link(__MODULE__, initial_text, name: __MODULE__)
  end

  def init(initial_text) do
    {:ok, initial_text}
  end

  # Função para obter o texto atual
  def get_text do
    GenServer.call(__MODULE__, :get_text)
  end

  # Função para atualizar o texto
  def update_text(new_text) do
    GenServer.cast(__MODULE__, {:update_text, new_text})
  end

  # Resposta à chamada do cliente
  def handle_call(:get_text, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:update_text, new_text}, _state) do
    {:noreply, new_text}
  end
end
