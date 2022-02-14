include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";
include "constraints.mzn";
include "functions.mzn";

% ============================================= CO2 EMISSIONS SCORE ============================================

/* Constraint that normalizes the CO2 score and multiplies it by the CO2 KPI relevance. */
constraint kpis_ratio[CO2_KPI] = relevances[CO2_KPI] * 
  normalize_kpi(co2_reduction_by_2030_rate, emissions(), previous_year_co2);

% =========================================== ENERGY EFFICIENCY SCORE ==========================================

/* Constraint that normalizes the Energy Efficiency score and multiplies it by the Energy Efficiency KPI relevance. */
constraint kpis_ratio[Energy_Efficiency_KPI] == relevances[Energy_Efficiency_KPI] *
  normalize_kpi(energy_reduction_by_2030_rate, machinery_total_energy_consumption, previous_year_energy_consumption);

% ========================================== TRANSPORTATION MODE SCORE =========================================

/** 
  Predicate that normalizes the Transporation Mode score and multiplies it by the Transporation Mode KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_mode_score() = 
  if used_kpis[Transportation_Mode_KPI] == true
    then kpis_ratio[Transportation_Mode_KPI] = (relevances[Transportation_Mode_KPI] * travel_means_quality_weigth * sum(t in Travel_Means)(travel_means_quality[t] * travel_means_consumption_efficiency_weight * travel_means_consumption_efficiency[t] * travel_means_used[t]) / (travel_means_quality_weigth * travel_means_consumption_efficiency_weight * sum(travel_means_used)))
    else kpis_ratio[Transportation_Mode_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_mode_score. */
constraint transportation_mode_score();

% ============================================ WATER EFFICIENCY SCORE =========================================

/* Constraint that normalizes the Water Efficiency score and multiplies it by the Water Efficiency KPI relevance. */
constraint kpis_ratio[Water_Consumption_KPI] == relevances[Water_Consumption_KPI] *
  normalize_kpi(water_reduction_by_2030_rate, machinery_total_water_consumption, previous_year_water_consumption);

% ============================================ Transportation Mode KPI ===========================================

/** 
  Predicate that normalizes the Transporation Capacity score and multiplies it by the Transporation Capacity KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_capacity_score() = 
  if used_kpis[Transportation_Capacity_KPI] == true
    then kpis_ratio[Transportation_Capacity_KPI] = sum(t in Travel_Means)(travel_means_assigned_products[t]) / sum(t in Travel_Means)(travel_means_capacity[t] * travel_means_used[t])
    else kpis_ratio[Transportation_Capacity_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_capacity_score. */
constraint transportation_capacity_score();

% =============================================== RECYCLING SCORE ===============================================

/* 
  Constraint that normalizes the Water Efficiency score and multiplies it by the Water Efficiency KPI relevance.
  If recycling scores are not used for the maximization problem, the predicate sets the score at 0.  
*/
constraint kpis_ratio[Recycling_KPI] == 
  if used_kpis[Recycling_KPI] == true
    then relevances[Recycling_KPI] * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products)
    else 0
  endif;

% ========================================== EQUIPMENT REJECT RATE SCORE =========================================

/* Constraint that normalizes the Equipment Reject Rate score and multiplies it by the Equipment Reject Rate KPI relevance. */
constraint kpis_ratio[Equipment_Reject_KPI] == relevances[Equipment_Reject_KPI] * 
  (1 - sum(m in Machinery where starting_machinery[m] < actual_machinery[m])(abs(starting_machinery[m] - actual_machinery[m])) /
  sum(starting_machinery));

% ============================================== CERTIFICATIONS SCORE ============================================

/* Constraint that normalizes the Certifications score and multiplies it by the Certifications KPI relevance. */
constraint kpis_ratio[Certifications_KPI] == relevances[Certifications_KPI] * 
  (sum(c in Certifications)(bool2int(actual_certifications[c]) * certifications_weight[c]) /
  sum(certifications_weight));

% =================================================== SOLUTION ===================================================

solve maximize sum(p in 1..card(KPIs) - 1)(kpis_ratio[to_enum(KPIs, p)] * relevances[to_enum(KPIs, p + 1)]) + kpis_ratio[to_enum(KPIs,card(KPIs))];

/** Variable float expressing the total KPI score percentage. */
var 0.0..100.0: total_kpi_percentage = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_ratio[p]) / 
  sum(p in KPIs where used_kpis[p] = true)(relevances[p]);
  

% ==================================================== OUTPUT ====================================================

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
