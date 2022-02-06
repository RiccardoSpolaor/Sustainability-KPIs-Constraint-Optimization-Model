include "parameters.mzn";
include "variables.mzn";

% ToDo if m_yearly_uses is changed with a variable that determines the actual use of the machines change that.
constraint sum(p in Products)(product_times[p] * n_products[p]) <= sum([m_yearly_uses[m] * actual_machinery[m] | m in Machinery])

%constraint forall(p in Products)
%  (product_times[p] * n_products[p] <= sum([m_yearly_uses[m] | m in Machinery where m_linked_products[m,p] == true]));
  % /\ forall(m in Machinery)(machinery_actual_time[m] <= m_yearly_uses[m]));
/*
array[1..card(Machinery)*card(Products)] of var 0.0..1000.0: products_time_per_machinery;

constraint sum(p in Products)(product_times[p] * n_products[p]) <= max_hour_machine_usage;

constraint sum(products_time_per_machinery) == sum(p in Products)(product_times[p] * n_products[p]);

constraint forall(p in Products)(
  sum([products_time_per_machinery[(m-1) * card(Machinery) + p] | m in Machinery]) <= product_times[p] * n_products[p]
);

constraint forall(m in Machinery)(forall(p in Products)(
  products_time_per_machinery[(m-1) * card(Machinery) + p] >= 0 
  /\ (m_linked_products[m,p] == false -> products_time_per_machinery[(m-1) * card(Machinery) + p] = 0)
));

constraint forall(m in Machinery)(sum([products_time_per_machinery[(m-1) * card(Machinery) + p] | p in Products]) <= m_yearly_uses[m]);

+/