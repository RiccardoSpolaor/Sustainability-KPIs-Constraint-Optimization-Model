/*
function array[int] of opt float: get_relevances(set of int: Relevance, set of int: CompanyType, opt int: company_type) = 
  let { 
    array[CompanyType, Relevance] of par float: rank_by_company = [| 
        4.3, 4.4, 4.5 
      | 4.2, 3.5, 4 
      | 4.2, 3.5, 4 
    |];
    array[Relevance] of par float: default_relevances = [4.6, 3.5, 4.6];
  } 
  
in
  
  if company_type == <> 
    then default_relevances 
    else rank_by_company[company_type,..] 
  endif;
*/