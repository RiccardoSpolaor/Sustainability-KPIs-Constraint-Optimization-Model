% Co2 Relevance [ToDo move in main module and pass here]
float: co2_relevance = 4.6;

/* Input parameters. */
par float: budget;
par float: minimum_earnings;
par float: previous_year_co2;
enum Products;
array[Products] of par float: product_costs;
array[Products] of par float: product_selling_prices;
array[Products] of par float: co2_emissions;

/* Variables. */
array[Products] of var int: n_products;
var float: earnings = sum (p in Products) (n_products[p] * product_selling_prices[p]);
var float: costs = sum (p in Products) (n_products[p] * product_costs[p]);
var float: emissions = sum (p in Products) (n_products[p] * co2_emissions[p]);
% Variable to maximize.
var float: co2_kpi = co2_relevance * (1 - (sum (p in Products) (n_products[p] * co2_emissions[p]) / previous_year_co2));

/* Constraints. */
constraint forall(p in n_products) (p >= 0); % The sold products must be >= 0. 
constraint budget - costs >= 0; % The costs cannot overcome the budget.
constraint earnings - costs >= minimum_earnings; % The total earnings must be greater than the minimum earnings.
  
solve maximize co2_kpi;

output ["Co2 KPI: \(co2_kpi) / previous_year_co2))); Number of products: \(["\(p): \(n_products[p])" | p in Products])"];