% Use this editor as a MiniZinc scratch book

% Use enums to name the various products (large manual page 38)
% list comprehension (large manual page 42)

% include "relevance_initialization.mzn";
include "parameters.mzn";
include "constants.mzn";
include "co2_kpi_demo.mzn";

/* Variables */
array[KPIs] of var float: total_earnings = [earnings, 0];
array[KPIs] of var float: total_costs = [costs, 0];

constraint budget - sum(total_costs) >= 0; % The costs cannot overcome the budget.
constraint sum(k in KPIs)(total_earnings[k] - total_costs[k]) >= minimum_earnings;

solve maximize co2_kpi;

output [
  "Co2 KPI: \(co2_kpi)\n", 
  "Number of sold products: \(["\(p): \(n_products[p])" | p in Products])\n",
  "Earnings: \(sum(k in KPIs)(total_earnings[k] - total_costs[k]))"
];
/*
enum CompanyType = {A, B, C};  
enum Relevance = {CO2, Packaging, Transportation};

par opt CompanyType: company_type;

% array[1..card(Relevance)] of opt float: relevances = get_relevances(Relevance, CompanyType, company_type);

array[CompanyType, Relevance] of par float: rank_by_company = [| 4.3, 4.4, 4.5 | 4.2, 3.5, 4 | 4.2, 3.5, 4 |];

array[Relevance] of par float: default_relevances = [4.6, 3.5, 4.6];

% par opt CompanyType: company_type;

array[Relevance] of par opt float: relevances = if company_type == <> then default_relevances else rank_by_company[company_type,..] endif;

  
output ["Relevances: \(relevances); \(relevances[CO2])"]

*/
