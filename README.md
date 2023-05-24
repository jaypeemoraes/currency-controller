

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

