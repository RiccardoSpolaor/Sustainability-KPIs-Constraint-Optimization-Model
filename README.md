# LAAI-project-KPI
A constraint programming model in `Minizinc` which aims at maximizing the score of a series of environmental KPI scores of a company, while making sure given production constraints are satisfied (e.g.: minimum  earnings are achieves; production times are respected).

The program has been implemented in such a way that it can be customized for different types of companies and production goals.
In particular the user is asked to input a series of business related parameters, which are then considered for satisfying the constraints and in the concurring KPIs maximization task. 

## Usage
* Download the *Minizinc IDE*: https://www.minizinc.org/ide/;
* Download this repository and open the project with the *Minizinc IDE*;
* Open the `main.mzn` file and run the *Minizinc IDE*;
* Either provide the requested input data manually, or use the example file in `./data/input_example.dzn` or create a new `.dzn` file with personalized information about the company.

## Specifics
The program has been tested with the solver `Geocode 6.3.0` because of its general purpose characteristics.
