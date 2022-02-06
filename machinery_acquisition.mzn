% Machine acquisition process
include "parameters.mzn";
include "variables.mzn";

constraint sum(m in Machinery)(starting_machinery[m]) <= 5;
constraint sum(m in Machinery)(actual_machinery[m]) <= 5;


constraint sum(
  [
    if starting_machinery[m] > actual_machinery[m] 
      then m_resell_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
      else m_prices[m] * abs(starting_machinery[m] - actual_machinery[m])
    endif | m in Machinery
  ]) >= machine_budget;
/*
  (sum([m_resell_prices[m] * (starting_machinery[m] - actual_machinery[m]) | m in Machinery where actual_machinery[m] < starting_machinery[m]]) 
  - sum([m_prices[m] * (actual_machinery[m] - starting_machinery[m]) | m in Machinery where actual_machinery[m] >= starting_machinery[m]]))
  >= machine_budget;
*/
% constraint forall(m in Machinery)(current_machinery[m] == true -> actual_machinery[m] = true);
/*constraint budget + sum([m_prices[m] | m in Machinery where actual_machinery[m] == false /\ current_machinery[m] == true]) - sum([m_prices[m] | m in Machinery where actual_machinery[m] == true /\ current_machinery[m] == false]) >= 0;
*/