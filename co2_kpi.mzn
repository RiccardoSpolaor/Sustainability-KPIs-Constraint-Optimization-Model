include "parameters.mzn";
include "constants.mzn";
include "variables.mzn";

var float: emissions = sum (p in Products)(n_products[p] * co2_emissions[p])
  + sum([m_yearly_uses[m] * actual_machinery[m] * m_co2_per_hours[m] | m in Machinery]);

% Put as 0 if < 0
var float: co2_kpi = relevances[CO2_KPI] * max([(1 - (emissions / previous_year_co2)), -1]);