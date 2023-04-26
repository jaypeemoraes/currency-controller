defmodule ExerciseWeb.EmployeeControllerTest do
  use ExerciseWeb.ConnCase

  alias Exercise.Employees
  alias Exercise.Employees.Employee
  alias Exercise.Countries

  @create_country_attrs %{
    code: "USA",
    name: "some name"
  }

  @create_currency_attrs %{
    code: "CHF",
    name: "some name",
    symbol: "some symbol"
  }

  @update_attrs %{
    full_name: "some updated name",
    job_title: "some updated job title",
    salary: 50000.0
  }

  @invalid_attrs %{
    "full_name" => nil,
    "job_title" => nil,
    "currency_id" => nil,
    "country_id" => nil,
    "salary" => 0.0}

  def fixture(:currency) do
    {:ok, currency} = Countries.create_currency(@create_currency_attrs)
    currency
  end

  def fixture(:country) do
    {:ok, country} = Countries.create_country(@create_country_attrs)
    country
  end


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all employees", %{conn: conn} do
      conn = get(conn, Routes.employee_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create employee" do
    setup [:create_currency]
    setup [:create_country]

    test "renders employee when data is valid", %{conn: conn, currency: currency, country: country} do



      employee_atrrs = create_employee_attrs(currency.id, country.id)


      conn = post(conn, Routes.employee_path(conn, :create), employee: employee_atrrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.employee_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "some name",
               "job_title" => "some job title",
               "salary" => 95550.0,
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.employee_path(conn, :create), employee: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update employee" do
    setup [:create_employee]

    test "renders employee when data is valid", %{conn: conn, employee: %Employee{id: id} = employee} do
      conn = put(conn, Routes.employee_path(conn, :update, employee), employee: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.employee_path(conn, :show, id))

      assert %{
               "id" => ^id,
               "full_name" => "some updated name",
               "job_title" => "some updated job title",
               "salary" => 50000.0
             } = json_response(conn, 200)["data"]
    end
  end

  describe "delete employee" do
    setup [:create_employee]

    test "deletes chosen country", %{conn: conn, employee: employee} do
      conn = delete(conn, Routes.employee_path(conn, :delete, employee))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.country_path(conn, :show, employee))
      end
    end
  end

  describe "salaries metrics" do
    setup [:create_employee]

    test "country metrics", %{conn: conn} do
      conn = get(conn, Routes.employee_path(conn, :metrics_salaries_by_country, "USA"))
      assert %{"average_salary" => "105382.095 USD",
        "max_salary" => "105382.095 USD",
        "min_salary" => "105382.095 USD"
      } = json_response(conn, 200)

    end

    test "job title metrics", %{conn: conn} do
      conn = get(conn, Routes.employee_path(conn, :metrics_salaries_by_job_title, "some job title"))
      assert %{"average_salary" => "105382.095 USD" } = json_response(conn, 200)

    end
  end

  defp create_country(_) do
    country = fixture(:country)
    %{country: country}
  end

  defp create_currency(_) do
    currency = fixture(:currency)
    %{currency: currency}
  end

  defp create_employee(_) do
    country = fixture(:country)
    currency = fixture(:currency)

    {:ok, employee} = Employees.create_employee(create_employee_attrs(currency.id, country.id))
    %{employee: employee}

  end

  defp create_employee_attrs(currency_id, country_id) do
    %{"full_name" => "some name",
       "job_title" => "some job title",
       "currency_id" => currency_id,
       "country_id" => country_id,
       "salary" => 95550.0  }
  end

end
