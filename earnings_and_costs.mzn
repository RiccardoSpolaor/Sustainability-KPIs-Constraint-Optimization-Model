include "variables.mzn";

var float: product_total_earnings = sum (p in Products)(n_products[p] * product_selling_prices[p]);
var float: product_total_costs = sum (p in Products)(n_products[p] * product_costs[p]);

var float: machines_total_costs = sum(
  [
    if starting_machinery[m] > actual_machinery[m] 
      then m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
      else -m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
    endif | m in Machinery
  ]);

/* Variables */
var float: total_earnings = product_total_earnings;
var float: total_costs = product_total_costs;


% The costs cannot overcome the budget [ToDo: Move the machines constraint in other places].
constraint budget - total_costs + machines_total_costs >= 0; 
constraint total_earnings >= minimum_earnings;
