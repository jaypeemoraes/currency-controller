# Backend code exercise

Hi there!

If you're reading this, it means you're now at the coding exercise step of the engineering hiring process. We're really happy that you made it here and super appreciative of your time!

In this exercise you're asked to implement some features in an existing Phoenix application and find and fix a bug.

> 💡 The Phoenix application is an API

If you have any questions, don't hesitate to reach out directly to code_exercise@remote.com.

## Expectations

* It should be production-ready code - the code will show us how you ship things to production and be a mirror of your craft.
  * Just to be extra clear: We don't actually expect you to deploy it somewhere or build a release. It's meant as a statement regarding the quality of the solution.
* Use your best judgement when modelling the data and relationships.
* Take whatever time you need - we won’t look at start/end dates, you have a life besides this and we respect that! Moreover, if there is something you had to leave incomplete or there is a better solution you would implement but couldn’t due to personal time constraints, please try to walk us through your thought process or any missing parts, using the “Implementation Details” section below.

## About the challenge

You will be working on an existing [Phoenix](https://www.phoenixframework.org/) application that needs some functionality added.

This exercise requires you to:

1. 🔧 Fix existing bugs in the application
2. 📑 Create an employee resource and implement default CRUD operations
3. 🧮 Implement an endpoint to provide salary metrics about employees

### 🔧 1.Fix existing bugs in the application

Unfortunately the application is not behaving as expected and it can use some fixing. Find the issues and correct them.

> 💡 Tests will help you find what is broken

### 📑 2.Create an employee resource and implement default CRUD operations

The application already has two resources: `country` and `currency`. You will have to create an `employee` resource and implement default [CRUD](https://en.wikipedia.org/wiki/Create,_read,_update_and_delete) operations.

There are a few requirements for the info captured by the `employee` resource:

* It must have a full name
* It must have a job title
* It must have a country
* It must have a salary
* It must have a currency in which the salary is paid

After creating the resource please add the logic to seed 10 000 employees into the database. Seed data lives on the `./repo/seeds.exs` file.

For the seeds, the following data fields have data that must be used for their generation:
* full name to be generated by reading and combining data found in `./priv/data/first_names.txt` and `./priv/data/last_names.txt`
* job title to be generated from a subset of values found in `./priv/data/job_titles.txt` - please use a subset of 100 job titles from the provided list

There is no defined logic to what first name should go with what last name, job title, country etc. Assign them as you see fit.

You do not need to add pagination for the index endpoint.

### 🧮 3.Implement an endpoint to provide salary metrics about employees

Create a new endpoint(s) to provide data about salaries:

* Given a country, the minimum, maximum, and average salary in that country.
* Given a job title, the average salary for all the employees with that job title.

### When you're done

- Complete the "Implementation Details" section at the bottom of this README.
- Open a Pull Request in this repo and send the link to code_exercise@remote.com.
- You can also send some feedback about this exercise. Was it too short/big? Boring? Let us know!

---

## How to run the existing application

### Using Elixir natively

If you wish to run the application natively you will need the following:

* Phoenix >= 1.5.9
* Elixir >= 1.7
* Postgres >= 11.9

Check out the `.tool-versions` file for a concrete version combination we ran the application with. Using [asdf](https://github.com/asdf-vm/asdf) you could install their plugins and them via `asdf install`.

### If you use Visual Studio Code with the Remote Containers extension

There is a `.devcontainer` folder that should allow you to open the project and develop without the need to have Elixir, Phoenix or Postgres installed in your system.

> 💡 Visual Studio Code [Remote - Containers extension page](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)

### Starting the application

No matter which method you chose to run your application the commands to start the application are similar.

### To start your Phoenix server

* Install dependencies with `mix deps.get`
* Create and migrate your database with `mix ecto.setup`
* Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/api/currencies`](http://localhost:4000/api/currencies) from your browser, to see that everything works.

> 💡 An `env` directory is provided along with values for environment variables for running the application with dev and test settings. Feel free to use whatever method you prefer to set environment variables.

## Useful Resources

* [Phoenix Official Website](https://www.phoenixframework.org/)
* [Phoenix Guides](https://hexdocs.pm/phoenix/overview.html)
* [Phoenix Docs](https://hexdocs.pm/phoenix)
* [Elixir Website](https://elixir-lang.org/)
* [Elixir Guides](https://elixir-lang.org/getting-started/introduction.html)
* [Elixir Docs](https://elixir-lang.org/docs.html)

## Implementation details

* The new features and fixes were developed using native elixir 1.14.3

* For the metrics calculation I decided to implement using SQL instead of in memory calculation which would be bad. Thus avoiding getting t which   it was created a salary_usd field in the employees table.
  The salary_usd supports the metrics calculation since it gurantees all the salaries are in the same currency.
  So before inserting employees with non USD salaries their salaries are converted to usd and inserted at salary_usd column.
  By the salary_usd column it is possible to calculate salary metrics through SQL which is more  
* Changed the existing functions get_currency_by_code and get_country_by_code in order to make the call to the database case insensitive


* Some possible improvementes:
  * Increase test coverage (current is 80.34%)
  * Show associate resources in the employees get api methods. Currently they show country_id and currency_id.
  * It would be good if complete country and currency data (name, code) were shown within employee data at get endpoints.
  * Ecto Associations would be a way to implement that

