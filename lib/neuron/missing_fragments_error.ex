defmodule Neuron.MissingFragmentsError do
  defexception [:missing_fragments, message: "Missing fragments"]

  @impl true
  def message(exception) do
    missing_fragments = Enum.join(exception.missing_fragments, ", ")

    "Fragments #{missing_fragments} not found"
  end
end
