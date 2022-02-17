include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";

% =========================================== KPIs RELATED FUNCTIONS =========================================

/** Function that normalizes a KPI score.
  * Parameters:
    @ reduction_by_2030_rate: Float representing the reduction rate to achieve by 2030 of a specific value; 
    @ value: Variable float representing the actual value score to normalize;
    @ previous_year_value: Float representing the previous year value used to normalize the actual value score.
  * Returns:
    @ Variable float expressing the normalized value score.
*/ 
function var float: get_normalized_kpi_score(0.0..1.0: reduction_by_2030_rate, var float: value, float: previous_year_value) =
  let {
    var 0.0..1.0: target_reduction_rate = (reduction_by_2030_rate) / (years_to_reach_the_reduction_goals);
    var 0.0..previous_year_value: target_value = previous_year_value - previous_year_value * target_reduction_rate;
    var float: min_max = 1 - ((value - target_value) / (previous_year_value - target_value));
  } in min([max([min_max, 0]), 1]);
  
% ======================================== PRODUCTION RELATED FUNCTIONS ======================================

/** Function that computes the total earnings obtained by selling the items as a variable integer. */ 
function var 0..100000: get_item_total_earnings() = sum (p in Items)(produced_items_number[p] * item_selling_prices[p]);

/** Function that computes the total cost of the raw materials to produce the items as a variable integer. */ 
function var 0..100000: get_items_total_costs() = sum (p in Items)(produced_items_number[p] * item_costs[p]);

/** Function that computes the total CO2 emissions in kg of the raw materials used to make the items as a variable integer. */
function var 0..100000: get_items_total_emissions() = sum(p in Items)(produced_items_number[p] * item_co2_emissions[p]);

/** Function that computes the total costs of production as a variable integer. */
function var 0..budget: get_total_costs() = get_items_total_costs() + get_certifications_total_costs() + equipment_budget + get_logistics_total_costs();

/** Function that computes the total CO2 emissions in kg of the  equipment during production as a variable integer. */
function var 0..1000000: get_equipment_total_emissions() = sum(m in Equipment)(yearly_equipment_actual_usage[m] * equipment_co2_emission_per_hour[m]);

/** Function that computes the total earnings in thousands of dollars ($) that are achieved by disposing of part of the starting equipment as a variable integer. */
function var 0..100000: get_equipment_total_earnings() = sum(m in Equipment where starting_equipment[m] > current_equipment[m])(
  equipment_disposal_prices[m] * abs(starting_equipment[m] - current_equipment[m])
);

/** Function that computes the total costs in thousands of dollars ($) to buy new equipment for production as a variable integer. */
function var 0..100000: get_equipment_total_costs() = sum(m in Equipment where starting_equipment[m] <= current_equipment[m])(
  equipment_prices[m] * abs(starting_equipment[m] - current_equipment[m])
);

/** Function that computes the total costs in thousands of dollars ($) to buy new certifications as a variable integer. */
function var 0..100000: get_certifications_total_costs() = sum(c in Certifications where starting_certifications[c] == false /\ current_certifications[c] == true)(certifications_cost[c]);

/** Function that computes the total costs in thousand of dollars ($) for the logistics as a variable integer. */
function var 0..100000: get_logistics_total_costs() = if use_logistics_kpis == true then sum (t in Transportation_Means)(
  transportation_means_cost_per_km[t] * transportation_means_used[t])
  else 0 endif;
  
