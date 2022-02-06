include "parameters.mzn";
include "constants.mzn";
include "variables.mzn";

var float: earnings = sum (p in Products) (n_products[p] * product_selling_prices[p]);
var float: costs = sum (p in Products) (n_products[p] * product_costs[p]);
var float: emissions = sum (p in Products) (n_products[p] * co2_emissions[p]);

% Put as 0 if < 0
var float: co2_kpi = relevances[CO2_KPI] * max([(1 - (sum (p in Products) (n_products[p] * co2_emissions[p]) / previous_year_co2)), 0]);