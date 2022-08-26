with 

stage1 as (
select 
  distinct 
  v69_registration_id_nbr,
  reporting_series_nm,
  rank() over(partition by v69_registration_id_nbr order by cs.strm_start_event_dt_ht) rank1
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
where
  day_dt between '2021-03-04' and '2022-08-21'
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  and reporting_content_type_cd = 'FEP'
  and video_content_duration_sec_qty >= 120    --minimum of 2 minutes viewed
  and v69_registration_id_nbr IS NOT NULL
  and lower(reporting_series_nm) like '%star%trek%'
 -- and video_air_dt_ht<='2017-01-01'              --past series, which will elimniate Star Trek Discovery (2017), Picard (2020), Strange new worlds etc
),

stage2 as (
select
  v69_registration_id_nbr,
  reporting_series_nm,
  MIN(rank1) rank1
from
  stage1
group by
  1,2
),


stage3 as (
select 
  v69_registration_id_nbr,
  STRING_AGG(reporting_series_nm order by rank1) order_of_title
from 
  stage2
group by 1
)

select  
  order_of_title, 
  count(distinct v69_registration_id_nbr) active_sub_hhs
from 
  stage3
group by 1
order by 2 desc

