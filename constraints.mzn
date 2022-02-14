include "parameters.mzn";
include "variables.mzn";
include "functions.mzn";

% ==================================== EQUIPMENT AND PRODUCTS CONSTRAINTS ====================================
/* The starting equipment number must be less or equal than the maximum equipment. */
constraint sum(m in Machinery)(starting_machinery[m]) <= max_n_machinery;
/* The final equipment number must be less or equal than the maximum equipment. */
constraint sum(m in Machinery)(actual_machinery[m]) <= max_n_machinery;
/* The total usage of the equipment in hours must be less or equal to the their maximum usage. */
constraint sum(m_yearly_actual_uses) <= sum(m in Machinery)(actual_machinery[m] * m_yearly_uses[m]);
/* Each piece of equipment usage must be less or equal than its maximum usage. */
constraint forall(m in Machinery)(m_yearly_actual_uses[m] <= m_yearly_uses[m] * actual_machinery[m]);
/* The total usage of the machines must be strictly equal to the total production time of the products. */
constraint sum(m_yearly_actual_uses) == products_total_time();
/* The total time to produce the goods must be less or equal than the yearly total available time. */
constraint products_total_time() + get_certifications_total_time() <= available_time_in_hours;


% ======================= CERTIFICATIONS ============================
constraint forall(c in Certifications)(starting_certifications[c] == true -> actual_certifications[c] == true);

% ========================================= MONEY RELATED CONSTRAINTS =========================================
/* The costs cannot overcome the budget. */
constraint budget - total_costs() >= 0; 
/* The equipment cost cannot overcome the equipment budget. */
constraint machine_budget + machines_total_earnings() - machines_total_costs() >= 0;
/* The total earnings must be greater or equal than the minimum decided earnings. */
constraint total_earnings() >= minimum_earnings;



predicate forbid_transportation_means() =
  if use_logistics_kpis == false 
    then true 
  else
    ((products_travel_distance < travel_means_km_per_hour[Plane] * 3 -> travel_means_used[Plane] == 0) /\ 
    (products_travel_distance < travel_means_km_per_hour[Ship] * 2 -> travel_means_used[Plane] == 0))
  endif;

/*
predicate respect_total_delivery_time() =
  if use_logistics_kpis == false 
    then true 
  else
    sum(t in Travel_Means)(travel_means_used[t] * (products_travel_distance div travel_means_km_per_hour[t])) <= products_delivery_total_time
  endif;
*/
predicate respect_total_transportation_capacity() =
  if use_logistics_kpis == false 
    then true 
  else
    forall(t in Travel_Means)(travel_means_assigned_products[t] <= travel_means_capacity[t] * travel_means_used[t])
  endif;
  
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


constraint forbid_transportation_means();
% constraint respect_total_delivery_time();
constraint respect_total_transportation_capacity();
constraint deliver_all_products();

/* Shipment times must be respected */
% constraint use_logistics_kpis = true -> (sum(t in Travel_Means)(travel_means_used[t] * (products_travel_distance / travel_means_km_per_hour[t])) <= products_delivery_total_time); 

/* All products must be shipped */
%constraint use_logistics_kpis = true -> (sum(n_products) == sum(travel_means_assigned_products));

/* The products cannot overcome the capacity of the single means of transportation */
%constraint use_logistics_kpis = true -> (forall(t in Travel_Means)(travel_means_assigned_products[t] <= travel_means_capacity[t] * travel_means_used[t]));
