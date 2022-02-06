/* Parameters */
par 0.0..100000.0: budget;
par 0.0..100000.0: minimum_earnings;

enum Products;

array[Products] of par 0.0..1000.0: product_costs;
array[Products] of par 0.0..1000.0: product_selling_prices;
array[Products] of par 0.0..1000.0: co2_emissions;
array[Products] of par 0.0..1000.0: product_times;

array[int] of par 0.0..1.0: product_reciclable_compositions;

par 0.0..100000.0: previous_year_co2;

% Machinery
enum Machinery;
array[Machinery] of par 0.0..10000.0: m_yearly_uses;
array[Machinery] of par 0.0..10000.0: m_energy_per_hours;
array[Machinery] of par 0.0..10000.0: m_water_per_hours;
array[Machinery] of par 0.0..10000.0: m_prices;
array[Machinery] of par 0.0..10000.0: m_resell_prices;
array[Machinery] of par 0..5: starting_machinery;
array[Machinery] of par 0.0..1000.0: m_co2_per_hours;

par 0..100: max_n_machinery;
% par 0.0..10000: machine_budget;

%array[Machinery, Products] of par bool: m_linked_products;
% Should be <= sum(m_yearly_uses)
float: max_hour_machine_usage;