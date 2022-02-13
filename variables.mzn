include "parameters.mzn";
include "constants.mzn";

% ========================================= PRODUCTS RELATED VARIABLES =========================================

/** Variable array containing for each product the number of units actually produced. */
array[Products] of var 0..50000: n_products;
/** Variable integer expressing the total hours of production for the products. */
var 0..available_time_in_hours: products_total_time = sum(p in Products)(product_times[p] * n_products[p]);
/** Variable integer expressing the total earning of the products. */
var 0..100000: product_total_earnings = sum (p in Products)(n_products[p] * product_selling_prices[p]);
/** Variable integer expressing the total costs related to the products. */
var 0..100000: product_total_costs = sum (p in Products)(n_products[p] * product_costs[p]);
/** Variable float expressing the total emissions related to the products. */
var 0..10000: products_total_emissions = sum(p in Products)(n_products[p] * co2_emissions[p]);


% =========================================== COSTS RELATED VARIABLES ===========================================

/** Variable integer expressing the total earnings. */
var minimum_earnings..100000: total_earnings = product_total_earnings;
/** Variable integer expressing the total costs. */
var 0..budget-machine_budget: total_costs = product_total_costs;

% ========================================= EQUIPMENT RELATED VARIABLES =========================================

/** Variable array representing the total amounts of the actually owned equipment. */
array[Machinery] of var 0..max_n_machinery: actual_machinery;
/** Variable array representing the total time of production of the actually owned equipment. */
array[Machinery] of var 0..10000: m_yearly_actual_uses;
/** Variable float representing the total emissions of the actually owned equipment. */
var 0..10000: machinery_total_emissions = sum(m in Machinery)(m_yearly_actual_uses[m] * m_co2_per_hours[m]);

/** Variable integer representing the total costs of the equipment. */
var 0..10000: machines_total_costs = sum(m in Machinery where starting_machinery[m] > actual_machinery[m])(
  m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);

/** Variable integer representing the total earnings on the equipment. */
var 0..10000: machines_total_earnings = sum(m in Machinery where starting_machinery[m] <= actual_machinery[m])(
  m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
);

/** Variable float representing the total energy consumption of the actually owned equipment. */
var 0..10000: machinery_total_energy_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_energy_per_hours[m]);

/** Variable float representing the total water consumption of the actually owned equipment. */
var 0..10000: machinery_total_water_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_water_per_hours[m]);


% ============================================ KPIs RELATED VARIABLES ============================================

/** Variable float representing the total emissions. */
var 0..10000: emissions = products_total_emissions + machinery_total_emissions;


array[KPIs] of var 0..500: kpis_ratio;

