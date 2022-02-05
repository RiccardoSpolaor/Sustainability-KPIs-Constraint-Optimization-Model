include "parameters.mzn";
/* Constants */
enum KPIs = {CO2_KPI, Recycling_KPI};

array[KPIs] of par 0.0..5.0: relevances = [4.31, 3.91];

array[KPIs] of par bool: used_kpis = [true, if length(product_reciclable_compositions) == 0 then false else true endif];