defmodule ExerciseWeb.EmployeeController do
  use ExerciseWeb, :controller

  alias Exercise.Employees
  alias Exercise.Employees.Employee
  alias Exercise.Countries

  action_fallback ExerciseWeb.FallbackController

  def index(conn, _params) do
    employees = Employees.list_employees()
    render(conn, "index.json", employees: employees)
  end

  def create(conn, %{"employee" => employee_params}) do
    with {:ok, %Employee{} = employee} <- Employees.create_employee(employee_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.employee_path(conn, :show, employee))
      |> render("show.json", employee: employee)
    end
  end

  def show(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)
    render(conn, "show.json", employee: employee)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = Employees.get_employee!(id)

    with {:ok, %Employee{} = employee} <- Employees.update_employee(employee, employee_params) do
      render(conn, "show.json", employee: employee)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Employees.get_employee!(id)

    with {:ok, %Employee{}} <- Employees.delete_employee(employee) do
      send_resp(conn, :no_content, "")
    end
  end

  def metrics_salaries_by_country(conn, %{"code" => code}) do
    metrics = Employees.get_country_metrics(code)

    case metrics do
       %{avg: x} when x != nil -> render(conn, "country_metrics.json", metrics)
        _ -> send_resp(conn, :not_found , "Not found country with code: #{code}")
    end
  end

  def metrics_salaries_by_job_title(conn, %{"job" => job}) do
    metrics = Employees.get_job_metrics(job)

    case metrics do
       %{avg: x} when x != nil -> render(conn, "job_metrics.json", metrics)
        _ -> send_resp(conn, :not_found , "Not found job with title: #{job}")
    end

  end
end
