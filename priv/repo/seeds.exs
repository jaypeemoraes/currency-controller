# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Exercise.Repo.insert!(%Exercise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Exercise.Countries
alias Exercise.Employees

# Seed the 8 supported currencies
# Euro (EUR)
# UK Pound Sterling (GBP)
# Australian Dollar (AUD)
# New Zealand Dollar (NZD)
# Unites States Dollar (USD)
# Canadian Dollar (CAD)
# Swiss Franc (CHF)
# Japanese Yen (JPY)
currency_data = [
  ["European Euro", "EUR", "€"],
  ["United Kingdom Pound Sterling", "GBP", "£"],
  ["Australian Dollar", "AUD", "$"],
  ["New Zealand Dollar", "NZD", "$"],
  ["United States Dollar", "USD", "$"],
  ["Canadian Dollar", "CAD", "$"],
  ["Swiss Franc", "CHF", "¥"],
  ["Japanese Yen", "JPY", "CHF"]
]

for currency <- currency_data do
  [name, code, symbol] = currency

  {:ok, _currency} = Countries.create_currency(%{
    name: name,
    code: code,
    symbol: symbol
  })

end

# Seed the 12 supported countries
country_data = [
  ["Australia", "AUS", "AUD"],
  ["Canada", "CAN", "CAD"],
  ["France", "FRA", "EUR"],
  ["Japan", "JPN", "JPY"],
  ["Italy", "ITA", "EUR"],
  ["Liechtenstein", "LIE", "CHF"],
  ["New Zealand", "NZL", "NZD"],
  ["Portugal", "PRT", "EUR"],
  ["Spain", "ESP", "EUR"],
  ["Switzerland", "CHE", "CHF"],
  ["United Kingdom", "GBR", "GBP"],
  ["United States", "USA", "USD"]
]

for country <- country_data do
  [name, code, currency_code] = country
  currency = Countries.get_currency_by_code!(currency_code)

  {:ok, _country} = Countries.create_country(%{
    name: name,
    code: code,
    currency_id: currency.id
  })

end

## Seed 10.000 employees from local files
job_titles = File.stream!("priv/data/job_titles.txt") |> Stream.take(100) |> Enum.to_list()
first_names = File.stream!("priv/data/first_names.txt") |> Enum.to_list()
last_names = File.stream!("priv/data/last_names.txt") |> Enum.to_list()

countries_data = Countries.list_countries()
currencies_data = Countries.list_currencies()

Enum.each(1..10000, fn(_s) ->

  first_name = first_names |> Enum.random()
  last_name = last_names |> Enum.random()
  current_currency = currencies_data |> Enum.random()
  current_country = countries_data |> Enum.random()

  Employees.create_employee(%{
    "full_name" => "#{first_name} #{last_name}" |> String.replace("\n", ""),
    "job_title" => job_titles |> Enum.random() |> String.replace("\n", ""),
    "salary" => 100000..150000 |> Enum.random(),
    "currency_id" => current_currency.id,
    "country_id" => current_country.id
  })

end)
