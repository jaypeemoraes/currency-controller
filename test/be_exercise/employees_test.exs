defmodule Exercise.EmployeesTest do
  use Exercise.DataCase

  alias Exercise.Countries
  alias Exercise.Employees
  alias Exercise.Employees.Employee

  describe "employees" do

    @valid_attrs %{code: "some code", name: "some name", symbol: "some symbol"}
    @update_attrs %{
      full_name: "some updated name",
      job_title: "some updated job title",
      salary: 50000.0
    }
    @invalid_attrs %{full_name: nil, job_title: nil, salary: 0.0}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Countries.create_currency()

      currency
    end

    @valid_attrs %{code: "some code", name: "some name"}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Countries.create_country()

      country
    end

    defp employee_fixture() do
      country = country_fixture()
      currency = currency_fixture()

      Employees.create_employee(create_employee_attrs(currency.id, country.id))
    end

    defp create_employee_attrs(currency_id, country_id) do
      %{"full_name" => "some name",
         "job_title" => "some job title",
         "currency_id" => currency_id,
         "country_id" => country_id,
         "salary" => 95550.0  }
    end

    test "list_employees/0 returns all employees" do
      country = country_fixture()
      currency = currency_fixture()

      assert {:ok, _result} = Employees.create_employee(%{
        "full_name" => "some name",
        "job_title" => "some job title",
        "salary" => 10000,
        "country_id" => country.id,
        "currency_id" => currency.id
      })
    end

    test "get_employee!/1 returns the employee with given id" do
      {:ok, employee} = employee_fixture()
      current_employee = Employees.get_employee!(employee.id)
      assert employee = current_employee
    end

    test "update_employee/2 with valid data updates the employee" do
      {:ok, employee} = employee_fixture()

      emp = Employees.update_employee(employee, @update_attrs)

      assert {:ok, %Employee{} = employee} = emp
      assert employee.full_name == "some updated name"
      assert employee.job_title == "some updated job title"
    end

    test "update_employee/2 with invalid data returns error changeset" do
      {:ok, employee} = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Employees.update_employee(employee, @invalid_attrs)
      assert employee == Employees.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      {:ok, employee} = employee_fixture()
      assert {:ok, %Employee{}} = Employees.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Employees.get_employee!(employee.id) end
    end

    test "get salaries job metrics" do
      employee_fixture()
      assert %{avg: 95550.0} = Employees.get_job_metrics("some job title")
    end

    test "get salaries country metrics" do
      employee_fixture()
      assert %{avg: 95550.0, max: 95550.0, min: 95550.0} = Employees.get_country_metrics("some code")
    end

  end
end
