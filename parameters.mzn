include "constants.mzn";

% ====================================== COMPANY GOALS AND PREVIOUS DATA =======================================

/** Integer expressing the budget of company measured in dollars ($). */
par 0..1000000: budget;

/** Integer expressing the minimum earning to achieve from selling items measured in dollars ($). */
par 0..1000000: minimum_earnings;

/** Integer expressing the Kg of C02 produced the previous year. */
par 0..1000000: previous_year_co2_emissions;

/** Integer expressing the KWatt of energy produced the previous year. */
par 0..1000000: previous_year_energy_consumption;

/** Integer expressing the liters of water consumed the previous year. */
par 0..1000000: previous_year_water_consumption;

/** Integer expressing the maximum available production time in hours. */
par 0..10000: available_time_in_hours;

/** Integer representing the years to reach the reduction goals */
par 1..10: years_to_reach_the_reduction_goals;

% ========================================= PRODUCTS DATA (MANDATORY) ==========================================

/** Enum expressing the items that the company sells. */
enum Items;

/** Array of integers expressing the cost to make each item. */
array[Items] of par 0..10000: item_costs;

/** Array of integers expressing the selling price for each item. */
array[Items] of par 0..10000: item_selling_prices;

/** Array of integers expressing the CO2 emissions of the raw materials composing a unit of each item. */
array[Items] of par 0..10000: co2_emissions;

/** Array of integers expressing the time in hours to make a unit of each item. */
array[Items] of par 0..1000: item_times;

% ======================================== EQUIPMENT DATA (MANDATORY) ==========================================

/** Enum expressing the possible equipment available. */
enum Equipment;

/** Array of integers expressing the maximum yearly usage in hours of each piece of equipment. */
array[Equipment] of par 0..10000: yearly_equipment_max_usage;

/** Array of integers expressing the KWatt/h consumed by each piece of equipment. */
array[Equipment] of par 0..100: equipment_energy_consumption_per_hour;

/** Array of integers expressing the liters of water consumed by each piece of equipment per hour. */
array[Equipment] of par 0..100: equipment_water_consumption_per_hour;

/** Array of integers expressing the price in dollars ($) to buy each piece of equipment. */
array[Equipment] of par 0..10000: equipment_prices;

/** Array of integers expressing the price in dollars ($) earned by disposing each piece of equipment. */
array[Equipment] of par 0..10000: equipment_disposal_prices;

/** Array of integers expressing the number of units of pieces of equipment that the company owns before starting production. */
array[Equipment] of par 0..max_equipment_number: starting_equipment;

/** Array of integers expressing the CO2 Kg/h that each piece of equipment generates. */
array[Equipment] of par 0..1000: equipment_co2_emission_per_hour;

/** Integer expressing the maximum number of pieces of equipment that a company can own. */
par 0..100: max_equipment_number;

/** Integer expressing the available budget for purchasing new pieces of equipment. */
par 0..budget: equipment_budget;

% ============================================ CERTIFICATIONS DATA =============================================

/** Array of bools representing the Certifications that the company owns before production starts. */
array[Certifications] of par bool: starting_certifications;

% ==================================== RECYCLABILITY DATA (NON MANDATORY) ======================================

/** Array of floats representing the recyclable composition ratio (between 0 and 1) for each item (N/D = []). */
array[int] of par 0.0..1.0: item_reciclable_compositions;

% ======================================= LOGISTICS DATA (NON MANDATORY) ======================================

/** Boolean expressing whether to include the logistics related scores in the environmental sustainability optimization. */
par bool: use_logistics_kpis;

/** Integer representing the distance in Km needed to deliver each item (Mandatory just when use_logistics_kpis is "true"). */
par opt 0..100000: items_travel_distance;
