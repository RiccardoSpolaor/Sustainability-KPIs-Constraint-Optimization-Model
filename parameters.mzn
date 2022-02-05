/* Parameters */
par float: budget;
par float: minimum_earnings;

enum Products;
array[Products] of par float: product_costs;
array[Products] of par float: product_selling_prices;
array[Products] of par float: co2_emissions;
par float: previous_year_co2;