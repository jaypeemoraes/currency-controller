defmodule Exercise.Employees do

  import Ecto.Query
  alias Exercise.Employees.Employee
  alias Exercise.Repo
  alias Exercise.Services.CurrencyConverter
  alias Exercise.Countries
  alias Exercise.Countries.Country

  def list_employees do
    Repo.all(Employee)
  end

  def get_employee!(id), do: Repo.get!(Employee, id)

  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> handle_salary_usd(attrs["currency_id"], attrs["salary"])
    |> Repo.insert()
  end

  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> handle_salary_usd(attrs["currency_id"], attrs["salary"])
    |> Repo.update()
  end

  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  def get_country_metrics(country_code) do
    Repo.one(from e in Employee,  join: c in Country, on: e.country_id == c.id,
    where: ilike(c.code, ^country_code) , select: %{min: min(e.salary_usd),
    avg: avg(e.salary_usd), max: max(e.salary_usd)})
  end

  def get_job_metrics(job_title) do
    Repo.one(from e in Employee,
    where: ilike(e.job_title, ^job_title) , select: %{avg: avg(e.salary_usd)})
  end

  defp handle_salary_usd(%Ecto.Changeset{valid?: false } = changeset,
   _currency_id, _salary_id), do: changeset

  defp handle_salary_usd(%Ecto.Changeset{valid?: true } = changeset, currency_id, _salary_id)
  when currency_id == nil  do
    changeset
  end

  defp handle_salary_usd(%Ecto.Changeset{valid?: true } = changeset, _currency_id, salary_id)
  when salary_id == nil  do
    changeset
  end

  defp handle_salary_usd(changeset, currency_id, salary) do
    try do
      currency = Countries.get_currency!(currency_id)
      with {:ok, result} <- CurrencyConverter.convert( currency.code, "USD", salary ) do
        changeset
        |> Ecto.Changeset.change( %{salary_usd: to_float(result) })
      else
        {:error, _reason} ->
           changeset
           |> Ecto.Changeset.change( %{salary_usd: to_float(salary) })
      end
    rescue
      Ecto.NoResultsError ->
        changeset
           |> Ecto.Changeset.change( %{salary_usd: to_float(salary) })
    end
  end

  defp to_float(num), do: num * 10.0/10.0

end
