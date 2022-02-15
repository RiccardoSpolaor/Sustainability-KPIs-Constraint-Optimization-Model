include "parameters.mzn";
include "variables.mzn";
include "functions.mzn";

% ==================================== EQUIPMENT AND PRODUCTS CONSTRAINTS ====================================

/* The starting number of pieces of equipment must be less or equal than the maximum number of pieces of equipment. */
constraint sum(m in Machinery)(starting_machinery[m]) <= max_n_machinery;

/* The final number of pieces of equipment must be less or equal than the maximum number of pieces of equipment. */
constraint sum(m in Machinery)(actual_machinery[m]) <= max_n_machinery;

/* Each piece of equipment usage must be less or equal than its maximum usage time limit. */
constraint forall(m in Machinery)(m_yearly_actual_uses[m] <= m_yearly_uses[m] * actual_machinery[m]);

/* The total usage of the equipment must be strictly equal to the total production time of the items. */
constraint sum(m_yearly_actual_uses) == sum(p in Products)(product_times[p] * n_products[p]);

/* The total time to produce the items must be less or equal than the total available time for production. */
constraint production_total_time <= available_time_in_hours;


% =============================================== CERTIFICATIONS ==============================================

/* If the company owns a certification at the beginning it will own it even after production. */
constraint forall(c in Certifications)(starting_certifications[c] == true -> actual_certifications[c] == true);

/* It is necessary to own a Carbon_Care certification that the company already owns it or that it reduces the carbon emissions by at least 5%. */
constraint actual_certifications[Carbon_Care] == true -> (
  starting_certifications[Carbon_Care] == true \/ total_production_co2_emissions <= previous_year_co2 - previous_year_co2 * 0.05
);
  
/* It is necessary to own a Global_Recycle_Standard certification that the company already owns it or that it doesn't produce phisycal products or that makes items which are on average 50% recyclable. */
constraint actual_certifications[Global_Recycle_Standard] == true -> (
  starting_certifications[Global_Recycle_Standard] == true 
  \/ used_kpis[Recycling_KPI] == true
  \/ sum(p in Products)(n_products[p] * product_reciclable_compositions[p]) / sum(n_products) >= 0.5
);

/* It is necessary to own a Water_Sense certification that the company already owns it or that it reduces the water consumption by at least 20%. */
constraint actual_certifications[Water_Sense] == true -> (
  starting_certifications[Water_Sense] == true 
  \/ machinery_total_water_consumption <= previous_year_water_consumption - previous_year_water_consumption * 0.2
);

% ========================================= COSTS RELATED CONSTRAINTS =========================================

/* The total costs cannot overcome the budget. */
constraint budget - total_costs() >= 0;
 
/* The equipment costs cannot overcome the equipment budget. */
constraint machine_budget + machines_total_earnings() - machines_total_costs() >= 0;

/* The total earnings must be greater or equal than the minimum expected earnings. */
constraint total_earnings >= minimum_earnings;


/*
predicate forbid_transportation_means() =
  if use_logistics_kpis == false 
    then true 
  else
    ((products_travel_distance < travel_means_km_per_hour[Plane] * 3 -> travel_means_used[Plane] == 0) /\ 
    (products_travel_distance < travel_means_km_per_hour[Ship] * 2 -> travel_means_used[Ship] == 0))
  endif;
*/
/*
predicate respect_total_delivery_time() =
  if use_logistics_kpis == false 
    then true 
  else
    sum(t in Travel_Means)(travel_means_used[t] * (products_travel_distance div travel_means_km_per_hour[t])) <= products_delivery_total_time
  endif;
*/

/** Predicate that expresses that if the logistics scores are used, then the capacity of each mean of transportation must be respected. */
predicate respect_total_transportation_capacity() =
  if use_logistics_kpis == false 
    then true 
  else
    forall(t in Travel_Means)(travel_means_assigned_products[t] <= travel_means_capacity[t] * travel_means_used[t])
  endif;

/** Predicate that expresses that if the logistics scores are used, then every item must be delivered. */
predicate deliver_all_products() =
  if use_logistics_kpis == false 
    then true 
  else
    sum(n_products) == sum(travel_means_assigned_products)
  endif;
  
% Travel means
/* Ships and Planes are used just if there is a lot to travel */
% constraint use_logistics_kpis = true -> (products_travel_distance < travel_means_km_per_hour[Plane] * 3 -> travel_means_used[Plane] == 0);
% constraint use_logistics_kpis = true -> (products_travel_distance < travel_means_km_per_hour[Ship] * 2 -> travel_means_used[Plane] == 0);


% constraint forbid_transportation_means();
% constraint respect_total_delivery_time();

/* Constraint that checks the respect_total_transportation_capacity predicate. */
constraint respect_total_transportation_capacity();

/* Constraint that checks the deliver_all_products predicate. */
constraint deliver_all_products();

/* Shipment times must be respected */
% constraint use_logistics_kpis = true -> (sum(t in Travel_Means)(travel_means_used[t] * (products_travel_distance / travel_means_km_per_hour[t])) <= products_delivery_total_time); 

/* All products must be shipped */
%constraint use_logistics_kpis = true -> (sum(n_products) == sum(travel_means_assigned_products));

/* The products cannot overcome the capacity of the single means of transportation */
%constraint use_logistics_kpis = true -> (forall(t in Travel_Means)(travel_means_assigned_products[t] <= travel_means_capacity[t] * travel_means_used[t]));
