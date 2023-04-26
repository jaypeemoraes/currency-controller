defmodule Exercise.Services.CurrencyConverterTest do
  @moduledoc false

  use ExUnit.Case
  alias Exercise.Services.CurrencyConverter, as: Converter

  describe "convert/3" do
    test "converting from a less valuable to a more valuable currency results in a smaller amount" do
      amount = 100

      {:ok, result} = Converter.convert("GBP", "USD", 156205.0)

      assert result < amount
    end

    test "converting from a more valuable to a less valuable currency results in a bigger amount" do
      amount = 100

      {:ok, result} = Converter.convert("GBP", "JPY", amount)

      assert result > amount
    end

    test "when one of the currencies is unsupported we get an error tuple as a result" do
      amount = 100

      assert {:error, "unsupported currencies conversion"} =
               Converter.convert("XYZ", "GBP", amount)
    end
  end
end
