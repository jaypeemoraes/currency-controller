defmodule ExerciseWeb.EmployeeView do
  use ExerciseWeb, :view
  alias ExerciseWeb.EmployeeView

  def render("index.json", %{employees: employees}) do
    %{data: render_many(employees, EmployeeView, "employee.json")}
  end

  def render("show.json", %{employee: employee}) do
    %{data: render_one(employee, EmployeeView, "employee.json")}
  end

  def render("employee.json", %{employee: employee}) do
    %{id: employee.id, full_name: employee.full_name, job_title: employee.job_title,
     salary: employee.salary, currency_id: employee.currency_id, country_id: employee.country_id}
  end

  def render("country_metrics.json", %{min: min, avg: avg, max: max}) do
    %{average_salary: "#{avg} USD", min_salary: "#{min} USD", max_salary: "#{max} USD" }
  end

  def render("job_metrics.json", %{avg: avg}) do
    %{average_salary: "#{avg} USD" }
  end
end
