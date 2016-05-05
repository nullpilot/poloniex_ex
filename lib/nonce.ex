defmodule Nonce do
  use GenServer

  def init(_), do: {:ok, 0}

  def start_link, do: GenServer.start_link(__MODULE__, nil)

  def generate do
    GenServer.call(self, :generate)
  end

  def handle_call(:generate, _, state) do
    if :os.system_time == state do
      {:reply, state + 1, state + 1}
    else
      {:reply, :os.system_time, :os.system_time}
    end
  end

end
