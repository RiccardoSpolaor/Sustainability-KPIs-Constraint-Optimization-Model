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
function var float: normalize_kpi(0.0..1.0: reduction_by_2030_rate, var float: value, float: previous_year_value) =
  let {
    var 0.0..1.0: target_reduction_rate = (reduction_by_2030_rate) / (years_to_reach_the_reduction_goals);
    var 0.0..previous_year_value: target_value = previous_year_value - previous_year_value * target_reduction_rate;
    %var float: target_value = previous_year_value - previous_year_value * reduction_by_2030_rate;
    var float: min_max = 1 - ((value - target_value) / (previous_year_value - target_value));
  } in min([max([min_max, 0]), 1]);

/** Variable integer expressing the total earning of the products increased according to the certifications owned by the companies. */
function var 0..100000: product_total_earnings() = sum (p in Products)(
  n_products[p] * product_selling_prices[p] * sum(c in Certifications)(bool2int(actual_certifications[c]) * round(product_selling_prices[p]*0.05))
);
/** Variable integer expressing the total costs related to the products. */
function var 0..100000: product_total_costs() = sum (p in Products)(n_products[p] * product_costs[p]);
/** Variable float expressing the total emissions related to the products. */
function var 0..10000: products_total_emissions = sum(p in Products)(n_products[p] * co2_emissions[p]);
/** Variable integer expressing the total costs. */
function var 0..budget: total_costs = product_total_costs() + get_certifications_total_costs() + machine_budget + get_logistics_total_costs();

/** Variable float representing the total emissions of the actually owned equipment. */
function var 0..10000: machinery_total_emissions() = sum(m in Machinery)(m_yearly_actual_uses[m] * m_co2_per_hours[m]);

/** Variable integer representing the total costs of the equipment. */
function var 0..10000: machines_total_earnings() = sum(m in Machinery where starting_machinery[m] > actual_machinery[m])(
  m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);

/** Variable integer representing the total earnings on the equipment. */
function var 0..10000: machines_total_costs() = sum(m in Machinery where starting_machinery[m] <= actual_machinery[m])(
  m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);


/* Variable float representing the total energy consumption of the actually owned equipment. */
%function var 0..10000: machinery_total_energy_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_energy_per_hours[m]);

function var 0..100000: get_certifications_total_costs() = sum(c in Certifications where starting_certifications[c] == false /\ actual_certifications[c] == true)(certifications_cost[c]);

function var 0..100000: get_logistics_total_costs() = if use_logistics_kpis == true then sum (t in Travel_Means)(
  travel_means_cost_per_hour[t] * travel_means_used[t]) % * (products_travel_distance div travel_means_km_per_hour[t]))
  else 0 endif;
  
