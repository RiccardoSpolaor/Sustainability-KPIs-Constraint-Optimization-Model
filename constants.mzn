include "parameters.mzn";

% =========================================== KPIS RELATED CONSTANTS ===========================================

/** Enum expressing the various KPIs to optimize. */
enum KPIs = {
  Energy_Efficiency_KPI, 
  CO2_KPI, 
  Transportation_Mode_KPI, 
  Certifications_KPI, 
  Transportation_Capacity_KPI, 
  Water_Consumption_KPI, 
  Recycling_KPI, 
  Equipment_Reject_KPI
};

/** Array of floats expressing the sustainability relevances of the various KPIs. */
array[KPIs] of par 0.0..5.0: kpis_relevances = [4.42, 4.31, 4.26, 4.20, 4.16, 4.06, 3.91, 3.68];

/** Array of bools expressing which KPIs are considered for optimization of the environmental sustainability of the company. */
array[KPIs] of par bool: used_kpis = [
  true, 
  true, 
  if use_logistics_kpis == true then true else false endif, 
  true, 
  if use_logistics_kpis == true then true else false endif, 
  true,
  if length(item_reciclable_compositions) == 0 then false else true endif,
  true
];

% ======================================== OPTIMIZATION RELATED CONSTANTS ======================================

/** Float expressing the target reduction rate of total CO2 emissions by 2030 that is supposed be achieved by the company . */
par 0.45..0.45: emissions_reduction_rate_by_2030 = 0.45;

/** Float expressing the target reduction rate of total energy consumption by 2030 that is supposed be achieved by the company . */
par 0.5..0.5: energy_reduction_rate_by_2030 = 0.5;

/** Float expressing the target reduction rate of total water consumption by 2030 that is supposed be achieved by the company . */
par 0.5..0.5: water_reduction_rate_by_2030 = 0.5;

% ====================================== CERTIFICATIONS RELATED CONSTANTS ======================================

/** Enum expressing the available certifications that the company may own. */
enum Certifications = {Carbon_Care, Global_Recycle_Standard, Water_Sense};

/** Array of integers representing the cost of each certification. */
array[Certifications] of par int: certifications_cost = [
  if minimum_earnings < 10000000 then 500
    elseif minimum_earnings >= 10000000 /\ minimum_earnings < 100000000 then 900
   else 2250
  endif,
  4000,
  2000
];

% ========================================= LOGISTICS RELATED CONSTANTS ========================================

/** Enum expressing the possible means of transport to deliver the items. */
enum Transportation_Means = {Plane, Ship, Truck, Train};

/** Array of integers expressing the speed of each mean of transport (Km/h). */
array[Transportation_Means] of int: transportation_means_km_per_hour = [800, 30, 80, 50];

/** Array of floats expressing the shipment quality score of each mean of transport (Regarding the integrity condition of the items and the availability of the service). */
array[Transportation_Means] of 0.0..1.0: transportation_means_quality = [1.0, 0.75, 0.25, 0.5];

/** Array of floats expressing the fuel consumption efficiency score of each mean of transport. */
array[Transportation_Means] of 0.0..1.0: transportation_means_consumption_efficiency = [0.1, 0.6, 0.8, 1.0];

/** Integer expressing the weight of the quality of transportation (used for computing the normalization of the KPI score). */
par 4..4: transportation_means_quality_weigth = 4;

/** Integer expressing the weight of the fuel consumption efficiency of transportation (used for computing the normalization of the KPI score). */
par 5..5: transportation_means_consumption_efficiency_weight = 5;

/** Array of integers expressing the capacity of each transportation mean (measured in units of items). */
array[Transportation_Means] of int: transportation_means_capacity = [80, 130, 20, 90];

/** Array of integers expressing the cost per hour in dollars ($) of each mean of transport. */
array[Transportation_Means] of int: transportation_means_cost_per_hour = [500, 50, 20, 30];
