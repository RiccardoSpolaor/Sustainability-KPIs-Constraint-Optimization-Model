/* Parameters */

% Company informations and goals (Mandatory).


par 0..1000000: budget; % Budget of company measured in K dollars ($)
par 0..1000000: minimum_earnings; % Minimum earning to achieve from selling measured in K dollars ($)
par 0.0..1000.0: previous_year_co2; % Tons of C02 produced previous year
par 0.0..10000.0: available_time_in_hours; % Hours available for production

% Products informations (Mandatory)
enum Products;
array[Products] of par 0..10000: product_costs;
array[Products] of par 0..10000: product_selling_prices;
array[Products] of par 0.0..1.0: co2_emissions;
array[Products] of par 0..1000: product_times;


% Machinery informations (Mandatory)
enum Machinery;
array[Machinery] of par 0..10000: m_yearly_uses;
array[Machinery] of par 0.0..100.0: m_energy_per_hours; % Measured in KW 
array[Machinery] of par 0.0..100.0: m_water_per_hours; % Measured in ???????
array[Machinery] of par 0..10000: m_prices;
array[Machinery] of par 0..10000: m_resell_prices;
array[Machinery] of par 0..max_n_machinery: starting_machinery;
array[Machinery] of par 0.0..10.0: m_co2_per_hours;
par 0..100: max_n_machinery;
par float: max_hour_machine_usage; % [ToDo: decide how to handle]
%array[Machinery, Products] of var bool: m_linked_products; %ToDo insert if we feel like it associates machines with products
par 0..10000: machine_budget;

% Recyclability informations (Non mandatory)
array[int] of par 0.0..1.0: product_reciclable_compositions;
