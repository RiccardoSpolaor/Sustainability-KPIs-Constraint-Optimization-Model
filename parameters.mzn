% ====================================== COMPANY GOALS AND PREVIOUS DATA =======================================

/** Budget of company measured in dollars ($). */
par 0..1000000: budget;
/** Minimum earning to achieve from selling products measured in dollars ($). */
par 0..1000000: minimum_earnings;
/** Tons of C02 produced the previous year. */
par 0.0..100000: previous_year_co2;
/** KWatt of energy produced the previous year. */
par 0.0..100000: previous_year_energy_consumption;
/** Liters of water consumed the previous year. */
par 0..100000: previous_year_water_consumption;
/** Maximum available production time in hours. */
par 0..10000: available_time_in_hours;
/** Current year. */
par 2010..2029: current_year;

% ========================================= PRODUCTS DATA (MANDATORY) ==========================================

/** Products that the company sells. */
enum Products;
/** Array of integer expressing the cost to make each product. */
array[Products] of par 0..10000: product_costs;
/** Array of integer expressing the selling price for each product. */
array[Products] of par 0..10000: product_selling_prices;
/** Array of integer expressing the CO2 emissions of the raw materials composing a unit of each product. */
array[Products] of par 0..10000: co2_emissions;
/** Array of integer expressing the time in hours to make a unit of each product. */
array[Products] of par 0..1000: product_times;

% ======================================== EQUIPMENT DATA (MANDATORY) ==========================================

/** Possible equipment. */
enum Machinery;
/** Array of integer expressing the maximum yearly usage in hours of each piece of equipment. */
array[Machinery] of par 0..10000: m_yearly_uses;
/** Array of float expressing the KW/h consumed by each piece of equipment. */
array[Machinery] of par 0..100: m_energy_per_hours;
/** Array of float expressing the liters of water consumed by each piece of equipment per hour. */
array[Machinery] of par 0..100: m_water_per_hours;
/** Array of integers expressing the price in dollars ($) to buy each piece of equipment. */
array[Machinery] of par 0..10000: m_prices;
/** Array of integers expressing the price in dollars ($) earned by disposing each piece of equipment. */
array[Machinery] of par 0..10000: m_resell_prices;
/** Array of integers expressing the number of units of piece of equipment that the company owns. */
array[Machinery] of par 0..max_n_machinery: starting_machinery;
/** Array of floats expressing the CO2/h that piece of equipment generates. */
array[Machinery] of par 0..1000: m_co2_per_hours;
/** Integers expressing the maximum number of machines that a company may own. */
par 0..100: max_n_machinery;
% par float: max_hour_machine_usage; % [ToDo: decide how to handle]
%array[Machinery, Products] of var bool: m_linked_products; %ToDo insert if we feel like it associates machines with products
/** Integer expressing the budget for purchasing new pieces of equipment. */
par 0..budget: machine_budget;

% ==================================== RECYCLABILITY DATA (NON MANDATORY) ======================================
/** Array of float representing the recyclable composition [0,1] for each product. (N/D = []) */
array[int] of par 0.0..1.0: product_reciclable_compositions;
