include "variables.mzn";

var 0.0..100000.0: product_total_earnings = sum (p in Products)(n_products[p] * product_selling_prices[p]);
var 0.0..100000.0: product_total_costs = sum (p in Products)(n_products[p] * product_costs[p]);

var 0..10000: machines_total_costs = sum(
  [
    if starting_machinery[m] > actual_machinery[m] 
      then m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
      else -m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
    endif | m in Machinery
  ]);

/* Variables */
var 0.0..100000.0: total_earnings = product_total_earnings;
var 0.0..100000.0: total_costs = product_total_costs;


% The costs cannot overcome the budget [ToDo: Move the machines constraint in other places].
/*
constraint budget - total_costs + machines_total_costs >= 0; 
constraint total_earnings >= minimum_earnings;
*/

constraint budget - total_costs >= 0; 
constraint machine_budget + machines_total_costs >= 0;
constraint total_earnings >= minimum_earnings;