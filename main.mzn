% Use this editor as a MiniZinc scratch book

% Use enums to name the various products (large manual page 38)
% list comprehension (large manual page 42)

include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";
include "constraints.mzn";
include "functions.mzn";

% ============================================== CO2 EMISSIONS KPI =============================================

/* Variable float expressing the CO2 emissions KPI score. */
constraint kpis_ratio[CO2_KPI] = relevances[CO2_KPI] * 
  normalize_kpi(co2_reduction_by_2030_rate, emissions(), previous_year_co2);

% var 0.0..relevances[CO2_KPI]: co2_kpi = relevances[CO2_KPI] * max([(1 - (emissions / previous_year_co2)), 0]);

% ============================================ ENERGY EFFICIENCY KPI ===========================================

/* Variable float expressing the CO2 emissions KPI score. */
constraint kpis_ratio[Energy_Efficiency_KPI] == relevances[Energy_Efficiency_KPI] *
  normalize_kpi(energy_reduction_by_2030_rate, machinery_total_energy_consumption, previous_year_energy_consumption);

% ============================================ Transportation Mode KPI ===========================================

/* Variable float expressing the CO2 emissions KPI score. */

predicate logistic_kpi_ratio = 
  if used_kpis[Transportation_Mode_KPI] == true
    then kpis_ratio[Transportation_Mode_KPI] = (relevances[Transportation_Mode_KPI] * travel_means_quality_weigth * sum(t in Travel_Means)(travel_means_quality[t] * travel_means_consumption_efficiency_weight * travel_means_consumption_efficiency[t] * travel_means_used[t]) / (travel_means_quality_weigth * travel_means_consumption_efficiency_weight * sum(travel_means_used)))
    else kpis_ratio[Transportation_Mode_KPI] = 0
  endif;

constraint logistic_kpi_ratio();

% ============================================= WATER EFFICIENCY KPI ===========================================

/* Variable float expressing the CO2 emissions KPI score. */
constraint kpis_ratio[Water_Consumption_KPI] == relevances[Water_Consumption_KPI] *
  normalize_kpi(water_reduction_by_2030_rate, machinery_total_water_consumption, previous_year_water_consumption);

% ============================================ Transportation Mode KPI ===========================================

/* Variable float expressing the CO2 emissions KPI score. */

predicate logistic_volume_kpi_ratio = 
  if used_kpis[Transportation_Capacity_KPI] == true
    then kpis_ratio[Transportation_Capacity_KPI] = sum(t in Travel_Means)(travel_means_assigned_products[t]) / sum(t in Travel_Means)(travel_means_capacity[t] * travel_means_used[t])
    else kpis_ratio[Transportation_Capacity_KPI] = 0
  endif;

constraint logistic_volume_kpi_ratio();

% ================================================ RECICLING KPI ===============================================

constraint assert(
  length(product_reciclable_compositions) == 0 \/ length(product_reciclable_compositions) == card(Products),
  "product_reciclable_compositions must be an empty array or an array that has the same length as Products"
);

/* Variable float expressing the Recicling KPI score. */
constraint kpis_ratio[Recycling_KPI] == 
  if used_kpis[Recycling_KPI] == true
    then relevances[Recycling_KPI] * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products)
    else 0
  endif;

% ========================================== EQUIPMENT REJECT RATE KPI =========================================

/* Variable float expressing the Recicling KPI score. */
constraint kpis_ratio[Equipment_Reject_KPI] == relevances[Equipment_Reject_KPI] * 
  (1 - sum(m in Machinery where starting_machinery[m] < actual_machinery[m])(abs(starting_machinery[m] - actual_machinery[m])) /
  sum(starting_machinery));

% ========================================== EQUIPMENT REJECT RATE KPI =========================================

/* Variable float expressing the Recicling KPI score. */
constraint kpis_ratio[Certifications_KPI] == relevances[Certifications_KPI] * 
  (sum(c in Certifications)(bool2int(actual_certifications[c]) * certifications_weight[c]) /
  sum(certifications_weight));

% ================================================== SOLUTION ==================================================

% constraint forall(k in 1..card(KPIs) - 1)(kpis_ratio[to_enum(KPIs, k)] >= kpis_ratio[to_enum(KPIs, k + 1)]);

%var 0.0..100.0: total_kpi_percentage = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_ratio[p]) / 
%  sum(p in KPIs where used_kpis[p] = true)(relevances[p]);

solve maximize sum(p in 1..card(KPIs) - 1)(kpis_ratio[to_enum(KPIs, p)] * relevances[to_enum(KPIs, p + 1)]) + kpis_ratio[to_enum(KPIs,card(KPIs))];

/** Variable float expressing the total KPI percentage. */
var 0.0..100.0: total_kpi_percentage = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_ratio[p]) / 
  sum(p in KPIs where used_kpis[p] = true)(relevances[p]);
  

% =================================================== OUTPUT ===================================================

output [
  "Energy Consumption \(machinery_total_energy_consumption) \n",
  "Water Consumption \(machinery_total_water_consumption) \n",
  %"CO2 Emissions: \(emissions())\n",
  % "target consumption \(target_energy_this_year) \n",
  "Initial budget: \(budget)\n", 
  "Total KPI percentage: \(total_kpi_percentage)%\n",
  "Co2 KPI: \(kpis_ratio[CO2_KPI])\n", 
  "Energy Efficiency KPI: \(kpis_ratio[Energy_Efficiency_KPI])\n", 
  "Recycling KPI: \(kpis_ratio[Recycling_KPI])\n",
  "Water KPI: \(kpis_ratio[Water_Consumption_KPI])\n",
  "Equipment Reject Rate KPI \(kpis_ratio[Equipment_Reject_KPI] )\n",
  "Transportation_mode_kpis \(kpis_ratio[Transportation_Mode_KPI]) \n",
  "Transportation_mode_kpis \(kpis_ratio[Transportation_Capacity_KPI]) \n",
  "Certifications KPI \(kpis_ratio[Certifications_KPI] )\n",
  "Certifications obtained \(actual_certifications)\n",
  "Travel means used \(travel_means_used) \n",
  "Travel means used \(travel_means_assigned_products) \n",
  %   "target emissions \(target_co2_this_year) \n",
  %"Time taken: \(products_total_time())\n",
  "Current Machinery: \(actual_machinery)\n",
  "Time per Machinery: \(m_yearly_actual_uses)\n",
  "Number of sold products: \(["\(p): \(n_products[p])" | p in Products])\n",
  %"Earnings: \(total_earnings())\n",
  %"Costs: \(total_costs())\n",

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
