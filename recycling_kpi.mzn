include "parameters.mzn";
include "constants.mzn";
include "variables.mzn";

float: recycling_relevance = relevances[Recycling_KPI];

constraint assert(
  forall(p in Products)(product_reciclable_compositions[p] >= 0 /\ product_reciclable_compositions[p] <= 1), 
  "Recyclable composition values must be between 0 and 1" 
);

var float: n_products_sum = sum(n_products);

var 0.0..5.0: recycling_kpi = recycling_relevance * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / n_products_sum;
