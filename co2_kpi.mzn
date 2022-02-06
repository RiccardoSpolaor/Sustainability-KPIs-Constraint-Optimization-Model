include "parameters.mzn";
include "constants.mzn";
include "variables.mzn";

var float: emission_products = sum(p in Products)(n_products[p] * co2_emissions[p]);
var float: emission_machinery = sum([m_yearly_uses[m] * actual_machinery[m] * m_co2_per_hours[m] | m in Machinery]);
var float: emissions = emission_products + emission_machinery;

% Put as 0 if < 0
var float: co2_kpi = relevances[CO2_KPI] * max([(1 - (emissions / previous_year_co2)), -1]);