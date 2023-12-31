defmodule Rockelivery.ViaCep.Behavior do
  alias Rockelivery.Error

  @callback get_cep_info(String.t()) :: {:ok, map()} | {:erro, Error.t()}
end
