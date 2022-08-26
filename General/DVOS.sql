select 
 month_dt,
video_show_nm,
case when allocation_cd like 'UsePrevMonth%' then 'Dormancy' else allocation_cd end as allocation_cd, 
--slam_show_att_level category_type,
sum(revenue_amt) revenue
from 
  ent_vw.dvos_show_valuation_fct 
where month_dt between '2021-03-01' and '2022-08-01'
and lower(video_show_nm) like '%star%trek%'
group by 1,2,3
