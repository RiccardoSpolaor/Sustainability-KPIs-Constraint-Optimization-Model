include "parameters.mzn";
/* Constants */
enum KPIs = {CO2_KPI, Energy_Efficiency_KPI, Recycling_KPI};

array[KPIs] of par 0.0..5.0: relevances = [4.31, 4.42, 3.91];

array[KPIs] of par bool: used_kpis = [true, true, if length(product_reciclable_compositions) == 0 then false else true endif];

par 2030..2030: goal_year = 2030;

par 0.4..0.4: co2_reduction_by_2030_rate = 0.4;
par 0.5..0.5: energy_reduction_by_2030_rate = 0.5;