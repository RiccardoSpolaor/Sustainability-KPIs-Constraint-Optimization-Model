include "parameters.mzn";
include "variables.mzn";
include "constants.mzn";

function var float: normalize_kpi(0.0..1.0: reduction_by_2030_rate, var float: value, float: previous_year_value) =
  let {
    % par 0.0..1.0: target_reduction_rate = (reduction_by_2030_rate) / (goal_year - current_year);
    % par 0.0..previous_year_value: target_value = previous_year_value - previous_year_value * target_reduction_rate;
    var float: target_value = previous_year_value - previous_year_value * reduction_by_2030_rate;
    var float: min_max = 1 - ((value - target_value) / (previous_year_value - target_value));
  } in min([max([min_max, 0]), 1]);
