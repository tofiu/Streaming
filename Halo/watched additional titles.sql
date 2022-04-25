with 
stage1 as (
Select distinct
  day_dt,
  v69_registration_id_nbr,
  video_genre_nm,
  reporting_series_nm,
  video_season_nbr,
  video_episode_nbr,
  video_title,
  video_acquisition_partner_Cd,
  SUM(video_start_cnt) streams,
from
dw_vw.aa_video_detail_reporting_day
where  reporting_content_type_cd NOT in ('CLIP')
    and  day_dt between '2022-03-24' and '2022-04-06' 
  and  report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
group by
  1,2,3,4,5,6,7,8
)
,
stage2 as (
select 
  s1.*, 
  s2.video_genre_nm as secondary_genre,
  s2. reporting_series_nm as secondary_series,
 --s2.video_acquisition_partner_Cd secondary_brand
from 
  stage1 s1, stage1  s2
where 
  s1.v69_registration_id_nbr = s2.v69_registration_id_nbr
  and s1.reporting_series_nm <> s2.reporting_series_nm
)


select 
case when shows =0 then '0 Show'
when shows =1 then '1 Show'
 when shows between 2 and 3 then '2-3 Shows'
  when shows  between 4 and 5 then '4-5 Shows'
  else '5+ Shows'
  end shows,
 count(distinct v69_registration_id_nbr) sub_hhs
 from (

Select 
  v69_registration_id_nbr,
  count(distinct secondary_series) shows,

from 
  stage2
 where (reporting_series_nm) = 'Halo' 
  group by 1
  )
  group by 1
