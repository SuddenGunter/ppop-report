defmodule Transaction do
  @derive [Poison.Encoder]
  defstruct [:id, :time, :description, :amount, :comment]
end
