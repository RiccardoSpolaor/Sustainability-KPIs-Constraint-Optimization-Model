include "parameters.mzn";
include "constants.mzn";

float: co2_relevance = relevances[CO2_KPI];

/* Variables. */
array[Products] of var int: n_products;

var float: earnings = sum (p in Products) (n_products[p] * product_selling_prices[p]);
var float: costs = sum (p in Products) (n_products[p] * product_costs[p]);
var float: emissions = sum (p in Products) (n_products[p] * co2_emissions[p]);

% Put as 0 if < 0
var float: co2_kpi = co2_relevance * (1 - (sum (p in Products) (n_products[p] * co2_emissions[p]) / previous_year_co2));