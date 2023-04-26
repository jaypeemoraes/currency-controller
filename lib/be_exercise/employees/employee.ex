defmodule Exercise.Employees.Employee do
  use Ecto.Schema
  import Ecto.Changeset

  schema "employees" do
    field :full_name, :string
    field :job_title, :string
    field :salary, :float
    field :salary_usd, :float
    field :currency_id, :id
    field :country_id, :id

    timestamps()
  end

  @doc false
  def changeset(employee, attrs) do
    employee
    |> cast(attrs, [:full_name, :job_title, :salary, :country_id, :currency_id])
    |> validate_required([:full_name, :job_title, :salary])
    |> foreign_key_constraint(:country_id)
    |> foreign_key_constraint(:currency_id)
  end
end
