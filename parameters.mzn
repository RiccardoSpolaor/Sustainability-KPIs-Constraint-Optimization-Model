/* Parameters */
par 0.0..100000.0: budget;
par 0.0..100000.0: minimum_earnings;

enum Products;
array[Products] of par 0.0..1000.0: product_costs;
array[Products] of par 0.0..1000.0: product_selling_prices;
array[Products] of par 0.0..1000.0: co2_emissions;
array[Products] of par 0.0..1.0: product_reciclable_compositions;

par 0.0..10000.0: previous_year_co2;