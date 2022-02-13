include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";

function var float: normalize_kpi(0.0..1.0: reduction_by_2030_rate, var float: value, float: previous_year_value) =
  let {
    % par 0.0..1.0: target_reduction_rate = (reduction_by_2030_rate) / (goal_year - current_year);
    % par 0.0..previous_year_value: target_value = previous_year_value - previous_year_value * target_reduction_rate;
    var float: target_value = previous_year_value - previous_year_value * reduction_by_2030_rate;
    var float: min_max = 1 - ((value - target_value) / (previous_year_value - target_value));
  } in min([max([min_max, 0]), 1]);

/** Variable integer expressing the total hours of production for the products. */
function var 0..available_time_in_hours: products_total_time = sum(p in Products)(product_times[p] * n_products[p]);
/** Variable integer expressing the total earning of the products. */
function var 0..100000: product_total_earnings = sum (p in Products)(n_products[p] * product_selling_prices[p]);
/** Variable integer expressing the total costs related to the products. */
function var 0..100000: product_total_costs = sum (p in Products)(n_products[p] * product_costs[p]);
/** Variable float expressing the total emissions related to the products. */
function var 0..10000: products_total_emissions = sum(p in Products)(n_products[p] * co2_emissions[p]);
/** Variable integer expressing the total earnings. */
function var minimum_earnings..100000: total_earnings = product_total_earnings();
/** Variable integer expressing the total costs. */
function var 0..budget: total_costs = product_total_costs() + get_certifications_total_costs() + machine_budget;

/** Variable float representing the total emissions of the actually owned equipment. */
function var 0..10000: machinery_total_emissions = sum(m in Machinery)(m_yearly_actual_uses[m] * m_co2_per_hours[m]);

/** Variable integer representing the total costs of the equipment. */
function var 0..10000: machines_total_earnings = sum(m in Machinery where starting_machinery[m] > actual_machinery[m])(
  m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);

/** Variable integer representing the total earnings on the equipment. */
function var 0..10000: machines_total_costs = sum(m in Machinery where starting_machinery[m] <= actual_machinery[m])(
  m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);


/** Variable float representing the total energy consumption of the actually owned equipment. */
function var 0..10000: machinery_total_energy_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_energy_per_hours[m]);

/** Variable float representing the total water consumption of the actually owned equipment. */
function var 0..10000: machinery_total_water_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_water_per_hours[m]);

/** Variable float representing the total emissions. */
function var 0..10000: emissions = products_total_emissions() + machinery_total_emissions();



function var 0..100000: get_certifications_total_time = sum(c in Certifications where starting_certifications[c] == false /\ actual_certifications[c] == true)(certifications_time_to_earn[c]);

function var 0..100000: get_certifications_total_costs = sum(c in Certifications where starting_certifications[c] == false /\ actual_certifications[c] == true)(certifications_cost[c]);