include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";
include "constraints.mzn";
include "functions.mzn";

% =========================================== ENERGY EFFICIENCY SCORE ==========================================

/* Constraint that normalizes the Energy Efficiency score and multiplies it by the Energy Efficiency KPI relevance. */
constraint kpis_ratio[Energy_Efficiency_KPI] == relevances[Energy_Efficiency_KPI] *
  normalize_kpi(energy_reduction_by_2030_rate, machinery_total_energy_consumption, previous_year_energy_consumption);

% ============================================= CO2 EMISSIONS SCORE ============================================

/* Constraint that normalizes the CO2 score and multiplies it by the CO2 KPI relevance. */
constraint kpis_ratio[CO2_KPI] = relevances[CO2_KPI] * 
  normalize_kpi(co2_reduction_by_2030_rate, total_production_co2_emissions, previous_year_co2);

% ========================================== TRANSPORTATION MODE SCORE =========================================

/** 
  Predicate that normalizes the Transporation Mode score and multiplies it by the Transporation Mode KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_mode_score() = 
  if used_kpis[Transportation_Mode_KPI] == true
    then kpis_ratio[Transportation_Mode_KPI] = (relevances[Transportation_Mode_KPI] * sum(t in Travel_Means)(travel_means_quality_weigth * travel_means_quality[t] * travel_means_consumption_efficiency_weight * travel_means_consumption_efficiency[t] * travel_means_used[t]) / (travel_means_quality_weigth * travel_means_consumption_efficiency_weight * sum(travel_means_used)))
    else kpis_ratio[Transportation_Mode_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_mode_score. */
constraint transportation_mode_score();

% ============================================== CERTIFICATIONS SCORE ============================================

/* Constraint that normalizes the Certifications score and multiplies it by the Certifications KPI relevance. */
constraint kpis_ratio[Certifications_KPI] == relevances[Certifications_KPI] * sum(actual_certifications) / length(actual_certifications);

% ======================================== TRANSPORTATION CAPACITY SCORE =======================================

/** 
  Predicate that normalizes the Transporation Capacity score and multiplies it by the Transporation Capacity KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_capacity_score() = 
  if used_kpis[Transportation_Capacity_KPI] == true
    then kpis_ratio[Transportation_Capacity_KPI] = relevances[Transportation_Capacity_KPI] * 
      sum(t in Travel_Means)(travel_means_assigned_products[t]) / sum(t in Travel_Means)(travel_means_capacity[t] * travel_means_used[t])
    else kpis_ratio[Transportation_Capacity_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_capacity_score. */
constraint transportation_capacity_score();

% ============================================ WATER EFFICIENCY SCORE =========================================

/* Constraint that normalizes the Water Efficiency score and multiplies it by the Water Efficiency KPI relevance. */
constraint kpis_ratio[Water_Consumption_KPI] == relevances[Water_Consumption_KPI] *
  normalize_kpi(water_reduction_by_2030_rate, machinery_total_water_consumption, previous_year_water_consumption);

% =============================================== RECYCLING SCORE ===============================================

/** 
  Predicate that computes Recycling Efficiency score ratio and multiplies it by the Recycling Efficiency KPI relevance.
  If recycling scores are not used for the maximization problem, the predicate sets the score at 0.  
*/
predicate recycling_score() = 
  if used_kpis[Recycling_KPI] == true
    then kpis_ratio[Recycling_KPI] =
      relevances[Recycling_KPI] * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products)
    else kpis_ratio[Recycling_KPI] = 0
  endif;

/* Constraint that calls the predicate recycling_score. */
constraint recycling_score();

% ========================================== EQUIPMENT REJECT RATE SCORE =========================================

/* Constraint that normalizes the Equipment Reject Rate score and multiplies it by the Equipment Reject Rate KPI relevance. */
constraint kpis_ratio[Equipment_Reject_KPI] == relevances[Equipment_Reject_KPI] * 
  (1 - sum(m in Machinery where starting_machinery[m] < actual_machinery[m])(abs(starting_machinery[m] - actual_machinery[m])) /
  sum(starting_machinery));

% =================================================== SOLUTION ===================================================

solve maximize sum(p in 1..card(KPIs) - 1)(kpis_ratio[to_enum(KPIs, p)] * relevances[to_enum(KPIs, p + 1)]) + kpis_ratio[to_enum(KPIs,card(KPIs))];

/** Variable float expressing the total KPI score percentage. */
var 0.0..100.0: total_kpi_percentage = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_ratio[p]) / 
  sum(p in KPIs where used_kpis[p] = true)(relevances[p]);
  

% ==================================================== OUTPUT ====================================================

output [
  "Initial company state: \n",
    "\t* Budget: $\(budget) ($\(machine_budget) allocated to purchase eventual new equipment);\n",
    "\t* Available equipment: \(["\(Machinery[m]): \(starting_machinery[m])" | m in Machinery]).\n\n",

  "Company achieved results: \n",
    "\t* Total KPI percentage score: \(total_kpi_percentage)%\n",
    "\t* Earnings: $\(total_earnings);\n",
    "\t* Number of sold products: \(["\(p): \(n_products[p])" | p in Products]);\n",
    "\t* Production time: \(production_total_time);\n",
    "\t* Final equipment: \(["\(Machinery[m]): \(actual_machinery[m])" | m in Machinery]);\n",
    "\t* Final equipment usage: \(["\(Machinery[m]): \(m_yearly_actual_uses[m])" | m in Machinery]).\n\n",
  
  "Co2 KPI score: \(kpis_ratio[CO2_KPI]) / \(relevances[CO2_KPI])\n",
    "\t* Previous CO2 emissions: \(previous_year_co2) kg;\n",
    "\t* Reached CO2 emissions: \(total_production_co2_emissions) kg.\n\n",
  
  "Energy efficiency KPI score: \(kpis_ratio[Energy_Efficiency_KPI]) / \(relevances[Energy_Efficiency_KPI])\n", 
    "\t* Previous energy consumption \(previous_year_energy_consumption) KWatt;\n",
    "\t* Reached energy consumption \(machinery_total_energy_consumption) KWatt.\n\n",
  
  "Water KPI score: \(kpis_ratio[Water_Consumption_KPI]) / \(relevances[Water_Consumption_KPI])\n",
    "\t* Previous water consumption \(previous_year_water_consumption) liters;\n",
    "\t* Reached water consumption \(machinery_total_water_consumption) liters.\n\n",
  
  "Certifications KPI score: \(kpis_ratio[Certifications_KPI]) / \(relevances[Certifications_KPI])\n",
    "\t* Starting certifications: \(["\(Certifications[c]): \(starting_certifications[c])" | c in Certifications]);\n",
    "\t* Final certifications: \(["\(Certifications[c]): \(actual_certifications[c])" | c in Certifications]).\n\n",
  
  if length(product_reciclable_compositions) != 0 
  then
    "Recycling KPI score: \(kpis_ratio[Recycling_KPI]) / \(relevances[Recycling_KPI]).\n\n"
  else ""
  endif,
   
  "Equipment Reject Rate kpi score: \(kpis_ratio[Equipment_Reject_KPI]) / \(relevances[Equipment_Reject_KPI]).\n\n",
  
  if use_logistics_kpis == true 
  then
    "Transportation mode KPI score: \(kpis_ratio[Transportation_Mode_KPI]) / \(relevances[Transportation_Mode_KPI])\n" ++
      "\t* Transportation means usage: \(["\(Travel_Means[t]): \(travel_means_used[t])" | t in Travel_Means]).\n\n" ++
    "Transportation capacity KPI score: \(kpis_ratio[Transportation_Capacity_KPI]) / \(relevances[Transportation_Capacity_KPI])\n" ++
      "\t* Transportation capacity used: \([
        "\(Travel_Means[t]): \(travel_means_assigned_products[t]) / \(travel_means_capacity[t] * travel_means_used[t])" | t in Travel_Means
      ]).\n\n"      
  else ""
  endif,
];
