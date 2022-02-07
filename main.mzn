% Use this editor as a MiniZinc scratch book

% Use enums to name the various products (large manual page 38)
% list comprehension (large manual page 42)

include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";
include "constraints.mzn";

% ============================================== CO2 EMISSIONS KPI =============================================

/** Variable float expressing the CO2 emissions KPI score. */
var 0.0..relevances[CO2_KPI]: co2_kpi = relevances[CO2_KPI] * max([(1 - (emissions / previous_year_co2)), 0]);

% ================================================ RECICLING KPI ===============================================

constraint assert(
  length(product_reciclable_compositions) == 0 \/ length(product_reciclable_compositions) == card(Products),
  "product_reciclable_compositions must be an empty array or an array that has the same length as Products"
);

/** Variable float expressing the Recicling KPI score. */
var 0.0..relevances[Recycling_KPI]: recycling_kpi = 
  if length(product_reciclable_compositions) != 0
    then relevances[Recycling_KPI] * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products)
    else 0
  endif;


% ================================================== SOLUTION ==================================================

/** Variable float expressing the total KPI percentage. */
var 0.0..100.0: total_kpi_percentage = 100 * (co2_kpi + recycling_kpi) / sum([relevances[p] | p in KPIs where used_kpis[p] = true]);

solve maximize total_kpi_percentage;

% =================================================== OUTPUT ===================================================

output [
  "Initial budget: \(budget)\n", 
  "Total KPI percentage: \(total_kpi_percentage)%\n",
  "Co2 KPI: \(co2_kpi)\n", 
  "Recycling KPI: \(recycling_kpi)\n",
  "Emissions: \(emissions)\n",
  "Time taken: \(products_total_time)\n",
  "Current Machinery: \(actual_machinery)\n",
  "Time per Machinery: \(m_yearly_actual_uses)\n",
  "Number of sold products: \(["\(p): \(n_products[p])" | p in Products])\n",
  "Earnings: \(total_earnings)\n",
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
