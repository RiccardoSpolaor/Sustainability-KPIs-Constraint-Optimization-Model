include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";
include "constraints.mzn";
include "functions.mzn";

% =========================================== ENERGY EFFICIENCY SCORE ==========================================

/* Constraint that normalizes the Energy Efficiency score and multiplies it by the Energy Efficiency KPI relevance. */
constraint kpis_scores[Energy_Efficiency_KPI] == kpis_relevances[Energy_Efficiency_KPI] *
  get_normalized_kpi_score(energy_reduction_rate_by_2030, equipment_total_energy_consumption, previous_year_energy_consumption);

% ============================================= CO2 EMISSIONS SCORE ============================================

/* Constraint that normalizes the CO2 score and multiplies it by the CO2 KPI relevance. */
constraint kpis_scores[CO2_KPI] = kpis_relevances[CO2_KPI] * 
  get_normalized_kpi_score(emissions_reduction_rate_by_2030, total_production_emissions, previous_year_co2_emissions);

% ========================================== TRANSPORTATION MODE SCORE =========================================

/** 
  Predicate that normalizes the Transporation Mode score and multiplies it by the Transporation Mode KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_mode_score() = 
  if used_kpis[Transportation_Mode_KPI] == true
    then kpis_scores[Transportation_Mode_KPI] = (kpis_relevances[Transportation_Mode_KPI] * sum(t in Transportation_Means)(transportation_means_quality_weigth * transportation_means_quality[t] * transportation_means_consumption_efficiency_weight * transportation_means_consumption_efficiency[t] * transportation_means_used[t]) / (transportation_means_quality_weigth * transportation_means_consumption_efficiency_weight * sum(transportation_means_used)))
    else kpis_scores[Transportation_Mode_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_mode_score. */
constraint transportation_mode_score();

% ============================================== CERTIFICATIONS SCORE ============================================

/* Constraint that normalizes the Certifications score and multiplies it by the Certifications KPI relevance. */
constraint kpis_scores[Certifications_KPI] == kpis_relevances[Certifications_KPI] * sum(actual_certifications) / length(actual_certifications);

% ======================================== TRANSPORTATION CAPACITY SCORE =======================================

/** 
  Predicate that normalizes the Transporation Capacity score and multiplies it by the Transporation Capacity KPI relevance.
  If logistic scores are not used for the maximization problem, the predicate sets the score at 0. 
*/
predicate transportation_capacity_score() = 
  if used_kpis[Transportation_Capacity_KPI] == true
    then kpis_scores[Transportation_Capacity_KPI] = kpis_relevances[Transportation_Capacity_KPI] * 
      sum(t in Transportation_Means)(transportation_means_assigned_items[t]) / sum(t in Transportation_Means)(transportation_means_capacity[t] * transportation_means_used[t])
    else kpis_scores[Transportation_Capacity_KPI] = 0
  endif;

/* Constraint that calls the predicate transportation_capacity_score. */
constraint transportation_capacity_score();

% ============================================ WATER EFFICIENCY SCORE =========================================

/* Constraint that normalizes the Water Efficiency score and multiplies it by the Water Efficiency KPI relevance. */
constraint kpis_scores[Water_Consumption_KPI] == kpis_relevances[Water_Consumption_KPI] *
  get_normalized_kpi_score(water_reduction_rate_by_2030, equipment_total_water_consumption, previous_year_water_consumption);

% =============================================== RECYCLING SCORE ===============================================

/** 
  Predicate that computes Recycling Efficiency score ratio and multiplies it by the Recycling Efficiency KPI relevance.
  If recycling scores are not used for the maximization problem, the predicate sets the score at 0.  
*/
predicate recycling_score() = 
  if used_kpis[Recycling_KPI] == true
    then kpis_scores[Recycling_KPI] =
      kpis_relevances[Recycling_KPI] * sum(p in Items)(produced_items_number[p] * item_reciclable_compositions[p]) / sum(produced_items_number)
    else kpis_scores[Recycling_KPI] = 0
  endif;

/* Constraint that calls the predicate recycling_score. */
constraint recycling_score();

% ========================================== EQUIPMENT REJECT RATE SCORE =========================================

/* Constraint that normalizes the Equipment Reject Rate score and multiplies it by the Equipment Reject Rate KPI relevance. */
constraint kpis_scores[Equipment_Reject_KPI] == kpis_relevances[Equipment_Reject_KPI] * 
  (1 - sum(m in Equipment where starting_equipment[m] > actual_equipment[m])(abs(starting_equipment[m] - actual_equipment[m])) /
  sum(starting_equipment));

% =================================================== SOLUTION ===================================================

solve maximize sum(p in 1..card(KPIs) - 1)(kpis_scores[to_enum(KPIs, p)] * kpis_relevances[to_enum(KPIs, p + 1)]) + kpis_scores[to_enum(KPIs,card(KPIs))];

% ==================================================== OUTPUT ====================================================

var int: eq_emissions = sum(m in Equipment)(yearly_equipment_actual_usage[m] * equipment_co2_emission_per_hour[m]); 

output [

  "eq_emissions: \(eq_emissions)\n",
  "Initial company state: \n",
    "\t* Budget: $\(budget) ($\(equipment_budget) allocated to purchase eventual new equipment);\n",
    "\t* Available equipment: \(["\(Equipment[m]): \(starting_equipment[m])" | m in Equipment]).\n\n",

  "Company achieved results: \n",
    "\t* Total KPI percentage score: \(total_kpi_percentage_score)%\n",
    "\t* Earnings: $\(total_earnings);\n",
    "\t* Number of sold items: \(["\(p): \(produced_items_number[p])" | p in Items]);\n",
    "\t* Production time: \(production_total_time);\n",
    "\t* Final equipment: \(["\(Equipment[m]): \(actual_equipment[m])" | m in Equipment]);\n",
    "\t* Final equipment usage: \(["\(Equipment[m]): \(yearly_equipment_actual_usage[m])" | m in Equipment]).\n\n",
  
  "Co2 KPI score: \(kpis_scores[CO2_KPI]) / \(kpis_relevances[CO2_KPI])\n",
    "\t* Previous CO2 emissions: \(previous_year_co2_emissions) kg;\n",
    "\t* Reached CO2 emissions: \(total_production_emissions) kg.\n\n",
  
  "Energy efficiency KPI score: \(kpis_scores[Energy_Efficiency_KPI]) / \(kpis_relevances[Energy_Efficiency_KPI])\n", 
    "\t* Previous energy consumption \(previous_year_energy_consumption) KWatt;\n",
    "\t* Reached energy consumption \(equipment_total_energy_consumption) KWatt.\n\n",
  
  "Water KPI score: \(kpis_scores[Water_Consumption_KPI]) / \(kpis_relevances[Water_Consumption_KPI])\n",
    "\t* Previous water consumption \(previous_year_water_consumption) liters;\n",
    "\t* Reached water consumption \(equipment_total_water_consumption) liters.\n\n",
  
  "Certifications KPI score: \(kpis_scores[Certifications_KPI]) / \(kpis_relevances[Certifications_KPI])\n",
    "\t* Starting certifications: \(["\(Certifications[c]): \(starting_certifications[c])" | c in Certifications]);\n",
    "\t* Final certifications: \(["\(Certifications[c]): \(actual_certifications[c])" | c in Certifications]).\n\n",
  
  if used_kpis[Recycling_KPI] == true 
  then
    "Recycling KPI score: \(kpis_scores[Recycling_KPI]) / \(kpis_relevances[Recycling_KPI]).\n\n"
  else ""
  endif,
   
  "Equipment Reject Rate kpi score: \(kpis_scores[Equipment_Reject_KPI]) / \(kpis_relevances[Equipment_Reject_KPI]).\n\n",
  
  if use_logistics_kpis == true 
  then
    "Transportation mode KPI score: \(kpis_scores[Transportation_Mode_KPI]) / \(kpis_relevances[Transportation_Mode_KPI])\n" ++
      "\t* Transportation means usage: \(["\(Transportation_Means[t]): \(transportation_means_used[t])" | t in Transportation_Means]).\n\n" ++
    "Transportation capacity KPI score: \(kpis_scores[Transportation_Capacity_KPI]) / \(kpis_relevances[Transportation_Capacity_KPI])\n" ++
      "\t* Transportation capacity used: \([
        "\(Transportation_Means[t]): \(transportation_means_assigned_items[t]) / \(transportation_means_capacity[t] * transportation_means_used[t])" | t in Transportation_Means
      ]).\n\n"      
  else ""
  endif,
];
