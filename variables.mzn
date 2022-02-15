include "parameters.mzn";
include "constants.mzn";
include "functions.mzn";

% ============================================ KPIS RELATED VARIABLES ==========================================

/** Array of variable floats containing for each KPI the score achieved by the company. */
array[KPIs] of var 0.0..5.0: kpis_scores;

/** Variable float expressing the total CO2 emissions during production. */
var 0..10000: total_production_emissions = get_items_total_emissions() + get_equipment_total_emissions();

/** Variable float expressing the total KPI score percentage. */
var 0.0..100.0: total_kpi_percentage_score = 100 * sum(p in KPIs where used_kpis[p] = true)(kpis_scores[p]) / 
  sum(p in KPIs where used_kpis[p] = true)(kpis_relevances[p]);

% ========================================= PRODUCTS RELATED VARIABLES =========================================

/** Array of variable integers containing for each item the number of units actually produced. */
array[Items] of var 0..50000: produced_items_number;

/** Variable integer expressing the total earnings. */
var minimum_earnings..100000: total_earnings = get_item_total_earnings();

/** Variable integer expressing the total hours of production. */
var 0..available_time_in_hours: production_total_time = max([yearly_equipment_actual_usage[m] div min([1, actual_equipment[m]]) | m in Equipment]);

% ========================================= EQUIPMENT RELATED VARIABLES =========================================

/** Array of variable integers expressing the actual number of units of pieces of equipment that the company will own for production. */
array[Equipment] of var 0..max_equipment_number: actual_equipment;

/** Array of variable integers expressing the number of units of piece of equipment that the company owns. */
array[Equipment] of var 0..10000: yearly_equipment_actual_usage;

/** Variable float expressing the total energy consumption of the equipment after production. */
var 0..10000: equipment_total_energy_consumption = sum(m in Equipment)(yearly_equipment_actual_usage[m] * equipment_energy_consumption_per_hour[m]);

/** Variable float expressing the total water consumption of the equipment after production. */
var 0..10000: equipment_total_water_consumption = sum(m in Equipment)(yearly_equipment_actual_usage[m] * equipment_water_consumption_per_hour[m]);

% ====================================== CERTIFICATIONS RELATED VARIABLES =======================================

/** Array of variable bools expressing the certifications actually owned by the company during production. */
array[Certifications] of var bool: actual_certifications;

% ========================================= LOGISTICS RELATED VARIABLES =========================================

/** Array of variable integers expressing the number of carried out deliveries for each transportation mean. */
array[Transportation_Means] of var 0..1000: transportation_means_used;

/** Array of variable integers expressing the number of total number of items assigned to each transportation mean. */
array[Transportation_Means] of var 0..10000: transportation_means_assigned_items;
