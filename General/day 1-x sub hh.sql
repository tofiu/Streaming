select
  video_series_nm,
  video_season_nbr,
  --v31_mpx_reference_guid,
  video_title,
  video_air_dt, 
  MAX(day_dt),-- title 
  count(distinct v69_registration_id_nbr) sub_hh
  --MIN(day_dt) prem_date
from
  `i-dss-ent-data.ent_summary.ab_aa_originals_new` 
where   site_country_cd ='US'
--and day_dt between '2020-01-23' and '2020-04-07'
and date_diff(day_dt, video_air_dt, day) = 2
and video_series_nm in ('Evil')
and video_season_nbr = '2'
group by 1,2,3,4
order by 4 asc
