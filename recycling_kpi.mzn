include "parameters.mzn";
include "constants.mzn";
include "variables.mzn";

constraint assert(
  length(product_reciclable_compositions) == 0 \/ length(product_reciclable_compositions) == card(Products),
  "product_reciclable_compositions must be an empty array or an array that has the same length as Products"
);

% Redundant
constraint assert(
  length(product_reciclable_compositions) == card(Products) -> forall(p in Products)((product_reciclable_compositions[p] >= 0 /\ product_reciclable_compositions[p] <= 100)), 
  "Recyclable composition values  must be an integer between 0 and 100"
);

var 0.0..5.0: recycling_kpi = 
  if sum(product_reciclable_compositions) != 0
    then relevances[Recycling_KPI] * sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products)
    else 0
  endif;

% var 0.0..5.0: recycling_kpi = 0.1;