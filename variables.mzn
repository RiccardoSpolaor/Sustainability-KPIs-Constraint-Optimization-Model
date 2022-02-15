include "parameters.mzn";
include "constants.mzn";
include "functions.mzn";

% ============================================ KPIS RELATED VARIABLES ==========================================

/** Array of variable floats containing for each KPI the score achieved by the company. */
array[KPIs] of var 0.0..5.0: kpis_ratio;

/** Variable float expressing the total CO2 emissions during production. */
var 0..10000: total_production_co2_emissions = products_total_emissions() + machinery_total_emissions();

/** Variable float expressing the total KPI score percentage. */
var 0.0..100.0: total_kpi_percentage = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_ratio[p]) / 
  sum(p in KPIs where used_kpis[p] = true)(relevances[p]);

% ========================================= PRODUCTS RELATED VARIABLES =========================================

/** Array of variable integers containing for each item the number of units actually produced. */
array[Products] of var 0..50000: n_products;

/** Variable integer expressing the total earnings. */
var minimum_earnings..100000: total_earnings = product_total_earnings();

/** Variable integer expressing the total hours of production. */
var 0..available_time_in_hours: production_total_time = max([m_yearly_actual_uses[m] div min([1, actual_machinery[m]]) | m in Machinery]);

% ========================================= EQUIPMENT RELATED VARIABLES =========================================

/** Array of variable integers expressing the actual number of units of pieces of equipment that the company will own for production. */
array[Machinery] of var 0..max_n_machinery: actual_machinery;

/** Array of variable integers expressing the number of units of piece of equipment that the company owns. */
array[Machinery] of var 0..10000: m_yearly_actual_uses;

/** Variable float expressing the total energy consumption of the equipment after production. */
var 0..10000: machinery_total_energy_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_energy_per_hours[m]);

/** Variable float expressing the total water consumption of the equipment after production. */
var 0..10000: machinery_total_water_consumption = sum(m in Machinery)(m_yearly_actual_uses[m] * m_water_per_hours[m]);

% ====================================== CERTIFICATIONS RELATED VARIABLES =======================================

/** Array of variable bools expressing the certifications actually owned by the company during production. */
array[Certifications] of var bool: actual_certifications;

% ========================================= LOGISTICS RELATED VARIABLES =========================================

/** Array of variable integers expressing the number of carried out deliveries for each transportation mean. */
array[Travel_Means] of var 0..1000: travel_means_used;

/** Array of variable integers expressing the number of total number of items assigned to each transportation mean. */
array[Travel_Means] of var 0..10000: travel_means_assigned_products;
