include "parameters.mzn";
array[Products] of var 0..50000: n_products;

array[Machinery, Products] of var 0..50000: machinery_n_products;
array[Machinery] of var 0..5: actual_machinery;
array[Machinery] of var 0..10000: m_yearly_actual_uses;

% array[Machinery] of var 0..50000: time_per_machinery = [sum([machinery_n_products[m, p] * product_times[p] | p in Products]) | m in Machinery];