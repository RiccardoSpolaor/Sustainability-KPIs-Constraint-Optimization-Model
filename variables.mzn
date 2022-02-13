include "parameters.mzn";
include "constants.mzn";

% ========================================= PRODUCTS RELATED VARIABLES =========================================

/** Variable array containing for each product the number of units actually produced. */
array[Products] of var 0..50000: n_products;

% =========================================== COSTS RELATED VARIABLES ===========================================

% ========================================= EQUIPMENT RELATED VARIABLES =========================================

/** Variable array representing the total amounts of the actually owned equipment. */
array[Machinery] of var 0..max_n_machinery: actual_machinery;
/** Variable array representing the total time of production of the actually owned equipment. */
array[Machinery] of var 0..10000: m_yearly_actual_uses;

array[KPIs] of var 0.0..5.0: kpis_ratio;

array[Certifications] of var bool: actual_certifications;


