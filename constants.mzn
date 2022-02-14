include "parameters.mzn";
/* Constants */
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

array[KPIs] of par 0.0..5.0: relevances = [4.42, 4.31, 4.26, 4.20, 4.16, 4.06, 3.91, 3.68];

array[KPIs] of par bool: used_kpis = [
  true, 
  true, 
  if use_logistics_kpis == true then true else false endif, 
  true, 
  if use_logistics_kpis == true then true else false endif, 
  if length(product_reciclable_compositions) == 0 then false else true endif, 
  true,
  true
];

par 2030..2030: goal_year = 2030;

par 0.4..0.4: co2_reduction_by_2030_rate = 0.4;
par 0.5..0.5: energy_reduction_by_2030_rate = 0.5;
par 0.4..0.4: water_reduction_by_2030_rate = 0.4;

enum Travel_Means = {Plane, Ship, Truck, Train};

array[Travel_Means] of int: travel_means_km_per_hour = [805, 30, 70, 200];
array[Travel_Means] of 0.0..1.0: travel_means_quality = [1.0, 0.5, 0.25, 0.75];
par 2..2: travel_means_quality_weigth = 2;
par 5..5: travel_means_consumption_efficiency_weight = 5;
array[Travel_Means] of 0.0..1.0: travel_means_consumption_efficiency = [0.1, 0.6, 0.8, 1.0];
array[Travel_Means] of int: travel_means_capacity = [70, 110, 20, 50];
array[Travel_Means] of int: travel_means_cost_per_hour = [5000, 500, 20, 300];