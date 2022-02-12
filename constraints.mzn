include "parameters.mzn";
include "variables.mzn";

% ==================================== EQUIPMENT AND PRODUCTS CONSTRAINTS ====================================
/* The starting equipment number must be less or equal than the maximum equipment. */
constraint sum(m in Machinery)(starting_machinery[m]) <= max_n_machinery;
/* The final equipment number must be less or equal than the maximum equipment. */
constraint sum(m in Machinery)(actual_machinery[m]) <= max_n_machinery;
/* The total usage of the equipment in hours must be less or equal to the their maximum usage. */
constraint sum(m_yearly_actual_uses) <= sum([actual_machinery[m] * m_yearly_uses[m] | m in Machinery]);
/* Each piece of equipment usage must be less or equal than its maximum usage. */
constraint forall(m in Machinery)(m_yearly_actual_uses[m] <= m_yearly_uses[m] * actual_machinery[m]);
/* The total usage of the machines must be strictly equal to the total production time of the products. */
constraint sum(m_yearly_actual_uses) == products_total_time;
/* The total time to produce the goods must be less or equal than the yearly total available time. */
constraint products_total_time <= available_time_in_hours;

% ========================================= MONEY RELATED CONSTRAINTS =========================================
/* The costs cannot overcome the budget. */
% constraint budget - total_costs >= 0; 
/* The equipment cost cannot overcome the equipment budget. */
constraint machine_budget + machines_total_earnings - machines_total_costs >= 0;
/* The total earnings must be greater or equal than the minimum decided earnings. */
%constraint total_earnings >= minimum_earnings;