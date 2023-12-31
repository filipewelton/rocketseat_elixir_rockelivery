defmodule Rockelivery.Stack do
  use GenServer

  def start_link(state) when is_list(state) do
    GenServer.start_link(__MODULE__, state)
  end

  def push(pid, element) do
    GenServer.call(pid, {:push, element})
  end

  def pop(pid), do: GenServer.call(pid, {:pop})

  @impl true
  def init(stack) do
    {:ok, stack}
  end

  @impl true
  def handle_call({:push, element}, _from, stack) do
    new_stack = [element | stack]
    {:reply, new_stack, new_stack}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_call(:pop, _from, []), do: {:reply, nil, []}
end
