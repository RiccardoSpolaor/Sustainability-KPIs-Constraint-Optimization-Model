include "parameters.mzn";
include "variables.mzn";
include "functions.mzn";

% ======================================= PARAMETERS RELATED CONSTRAINTS ======================================

/* Constraint to assert that the item_reciclable_compositions array is either empty or it has the same length as the available items. */
constraint assert(
  length(item_reciclable_compositions) == 0 \/ length(item_reciclable_compositions) == card(Items),
  "item_reciclable_compositions must be an empty array or an array that has the same length as Items"
);


% ========================================= COSTS RELATED CONSTRAINTS =========================================

/* The total costs cannot overcome the budget. */
constraint budget - get_total_costs() >= 0;
 
/* The equipment costs cannot overcome the equipment budget. */
constraint equipment_budget + get_equipment_total_earnings() - get_equipment_total_costs() >= 0;

/* The total earnings must be greater or equal than the minimum expected earnings. */
constraint total_earnings >= minimum_earnings;

% ==================================== EQUIPMENT AND PRODUCTS CONSTRAINTS ====================================

/* The starting number of pieces of equipment must be less or equal than the maximum number of pieces of equipment. */
constraint sum(m in Equipment)(starting_equipment[m]) <= max_equipment_number;

/* The final number of pieces of equipment must be less or equal than the maximum number of pieces of equipment. */
constraint sum(m in Equipment)(current_equipment[m]) <= max_equipment_number;

/* Each piece of equipment usage must be less or equal than its maximum usage time limit. */
constraint forall(m in Equipment)(yearly_equipment_actual_usage[m] <= yearly_equipment_max_usage[m] * current_equipment[m]);

/* The total usage of the equipment must be strictly equal to the total production time of the items. */
constraint sum(yearly_equipment_actual_usage) == sum(p in Items)(item_times[p] * produced_items_number[p]);

/* The total time to produce the items must be less or equal than the total available time for production. */
constraint production_total_time <= available_time_in_hours;

% ===================================== CERTIFICATIONS RELATED CONSTRAINTS ====================================

/* If the company owns a certification at the beginning it will own it even after production. */
constraint forall(c in Certifications)(starting_certifications[c] == true -> current_certifications[c] == true);

/* It is necessary to own a Carbon_Care certification that the company already owns it or that it reduces the carbon emissions by at least 5%. */
constraint current_certifications[Carbon_Care] == true -> (
  starting_certifications[Carbon_Care] == true \/ total_production_emissions <= previous_year_co2_emissions - previous_year_co2_emissions * 0.05
);
  
/* It is necessary to own a Global_Recycle_Standard certification that the company already owns it or that it doesn't produce phisycal items or that makes items which are on average 50% recyclable. */
constraint current_certifications[Global_Recycle_Standard] == true -> (
  starting_certifications[Global_Recycle_Standard] == true 
  \/ used_kpis[Recycling_KPI] == true
  \/ sum(p in Items)(produced_items_number[p] * item_reciclable_compositions[p]) / sum(produced_items_number) >= 0.5
);

/* It is necessary to own a Water_Sense certification that the company already owns it or that it reduces the water consumption by at least 20%. */
constraint current_certifications[Water_Sense] == true -> (
  starting_certifications[Water_Sense] == true 
  \/ equipment_total_water_consumption <= previous_year_water_consumption - previous_year_water_consumption * 0.2
);

% ======================================= LOGISTICS RELATED CONSTRAINTS =======================================

/** Predicate that expresses that if the logistics scores are used, then the capacity of each mean of transportation must be respected. */
predicate respect_total_transportation_capacity() =
  if use_logistics_kpis == false 
    then true 
  else
    forall(t in Transportation_Means)(transportation_means_assigned_items[t] <= transportation_means_capacity[t] * transportation_means_used[t])
  endif;

/** Predicate that expresses that if the logistics scores are used, then every item must be delivered. */
predicate deliver_all_items() =
  if use_logistics_kpis == false 
    then true 
  else
    sum(produced_items_number) == sum(transportation_means_assigned_items)
  endif;

/* Constraint that checks the respect_total_transportation_capacity predicate. */
constraint respect_total_transportation_capacity();

/* Constraint that checks the deliver_all_items predicate. */
constraint deliver_all_items();
