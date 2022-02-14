% ====================================== COMPANY GOALS AND PREVIOUS DATA =======================================

/** Integer expressing the budget of company measured in dollars ($). */
par 0..1000000: budget;

/** Integer expressing the minimum earning to achieve from selling products measured in dollars ($). */
par 0..1000000: minimum_earnings;

/** Integer expressing the Kg of C02 produced the previous year. */
par 0..1000000: previous_year_co2;

/** Integer expressing the KWatt of energy produced the previous year. */
par 0..1000000: previous_year_energy_consumption;

/** Integer expressing the liters of water consumed the previous year. */
par 0..1000000: previous_year_water_consumption;

/** Integer expressing the maximum available production time in hours. */
par 0..10000: available_time_in_hours;

% ========================================= PRODUCTS DATA (MANDATORY) ==========================================

/** Enum expressing the products that the company sells. */
enum Products;

/** Array of integers expressing the cost to make each product. */
array[Products] of par 0..10000: product_costs;

/** Array of integers expressing the selling price for each product. */
array[Products] of par 0..10000: product_selling_prices;

/** Array of integers expressing the CO2 emissions of the raw materials composing a unit of each product. */
array[Products] of par 0..10000: co2_emissions;

/** Array of integers expressing the time in hours to make a unit of each product. */
array[Products] of par 0..1000: product_times;

% ======================================== EQUIPMENT DATA (MANDATORY) ==========================================

/** Enum expressing the possible equipment available. */
enum Machinery;

/** Array of integers expressing the maximum yearly usage in hours of each piece of equipment. */
array[Machinery] of par 0..10000: m_yearly_uses;

/** Array of integers expressing the KWatt/h consumed by each piece of equipment. */
array[Machinery] of par 0..100: m_energy_per_hours;

/** Array of integers expressing the liters of water consumed by each piece of equipment per hour. */
array[Machinery] of par 0..100: m_water_per_hours;

/** Array of integers expressing the price in dollars ($) to buy each piece of equipment. */
array[Machinery] of par 0..10000: m_prices;

/** Array of integers expressing the price in dollars ($) earned by disposing each piece of equipment. */
array[Machinery] of par 0..10000: m_resell_prices;

/** Array of integers expressing the number of units of piece of equipment that the company owns. */
array[Machinery] of par 0..max_n_machinery: starting_machinery;

/** Array of integers expressing the CO2 Kg/h that each piece of equipment generates. */
array[Machinery] of par 0..1000: m_co2_per_hours;

/** Integer expressing the maximum number of pieces of equipment that a company can own. */
par 0..100: max_n_machinery;

/** Integer expressing the available budget for purchasing new pieces of equipment. */
par 0..budget: machine_budget;

enum Certifications;
array[Certifications] of par int: certifications_cost;
array[Certifications] of par int: certifications_time_to_earn;
array[Certifications] of par int: certifications_weight;
array[Certifications] of par bool: starting_certifications;

% ==================================== RECYCLABILITY DATA (NON MANDATORY) ======================================
/** Array of floats representing the recyclable composition ratio (between 0 and 1) for each item (N/D = []). */
array[int] of par 0.0..1.0: product_reciclable_compositions;

/* Constraint to assert that the product_reciclable_compositions array is either empty or it has the same length as the available items. */
constraint assert(
  length(product_reciclable_compositions) == 0 \/ length(product_reciclable_compositions) == card(Products),
  "product_reciclable_compositions must be an empty array or an array that has the same length as Products"
);

% ======================================= LOGISTICS DATA (NON MANDATORY) ======================================

/** Boolean expressing whether to include the logistics related scores in the environmental sustainability optimization. */
par bool: use_logistics_kpis;

/** Integer representing the distance in Km needed to deliver each product (Mandatory just when use_logistics_kpis is "true"). */
par opt 0..100000: products_travel_distance;

/* Constraint to assert that the products_travel_distance parable is assigned if use_logistics_kpis is "true". */
constraint assert(use_logistics_kpis == true -> occurs(products_travel_distance), "Insert the travel distance of the products.");
