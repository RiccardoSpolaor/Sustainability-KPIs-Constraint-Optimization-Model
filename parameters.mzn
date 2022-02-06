/* Parameters */

% Company informations and goals (Mandatory).
par 0.0..100000.0: budget;
par 0.0..100000.0: minimum_earnings;
par 0.0..100000.0: previous_year_co2;

% Products informations (Mandatory)
enum Products;
array[Products] of par 0.0..1000.0: product_costs;
array[Products] of par 0.0..1000.0: product_selling_prices;
array[Products] of par 0.0..1000.0: co2_emissions;
array[Products] of par 0.0..1000.0: product_times;

% Machinery informations (Mandatory)
enum Machinery;
array[Machinery] of par 0.0..10000.0: m_yearly_uses;
array[Machinery] of par 0.0..10000.0: m_energy_per_hours;
array[Machinery] of par 0.0..10000.0: m_water_per_hours;
array[Machinery] of par 0.0..10000.0: m_prices;
array[Machinery] of par 0.0..10000.0: m_resell_prices;
array[Machinery] of par 0..max_n_machinery: starting_machinery;
array[Machinery] of par 0.0..1000.0: m_co2_per_hours;
par 0..100: max_n_machinery;
par float: max_hour_machine_usage; % [ToDo: decide how to handle]

% Recyclability informations (Non mandatory)
array[int] of par 0.0..1.0: product_reciclable_compositions;
