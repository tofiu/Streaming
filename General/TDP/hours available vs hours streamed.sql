with hours_avail as (
select season_level_title,
       sum(length_in_seconds/3600) hours_avail
from 
(
select season_level_title,
       v31_mpx_reference_guid,
       max(length_in_seconds) length_in_seconds
from (
(
select v31_mpx_reference_guid,
       season_level_title,
       length_in_seconds
  FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` a 
  left join `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b 
  on a.reporting_series_nm=b.title 
     and a.day_dt >= b.premeire_dt
     and (case when reporting_content_type_cd = "MOVIE" then "1" else a.video_season_nbr end) = b.season_nbr
  where day_dt >= "2017-09-24" 
  -- AND src_system_id = 115
  -- AND site_country_cd = 'US'
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  AND TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) <13
  and reporting_content_type_cd <> 'CLIP'
    and season_level_title IN 
   ('Star Trek: Discovery S1',
'Star Trek: Discovery S2',
'Star Trek: Picard S1',
'Star Trek: Lower Decks S1',
'Star Trek: Discovery S3',
'Star Trek: Lower Decks S2',
'Star Trek: Prodigy S1',
'Star Trek: Discovery S4',
'Star Trek: Picard S2',
'Star Trek: Strange New Worlds S1')
  ))
group by 1,2
)
group by 1),

hours as (
select distinct season_level_title,
       PERCENTILE_CONT(hours, 0.5 RESPECT NULLS) OVER (partition by season_level_title) AS median
from (
select v69_registration_id_nbr,
       season_level_title,
       sum(hours) hours
from (
  select v69_registration_id_nbr,
       season_level_title,
       video_total_time_sec_qty/3600 as hours
  FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` a 
  left join `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b 
  on a.reporting_series_nm=b.title 
     and a.day_dt >= b.premeire_dt
     and (case when reporting_content_type_cd = "MOVIE" then "1" else a.video_season_nbr end) = b.season_nbr
  where day_dt >= "2017-09-24" 
  -- AND src_system_id = 115
  -- and source_desc != 'CBS TVE'
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  AND TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) <13
    and season_level_title IN 
    ('Star Trek: Discovery S1',
      'Star Trek: Discovery S2',
      'Star Trek: Picard S1',
      'Star Trek: Lower Decks S1',
      'Star Trek: Discovery S3',
      'Star Trek: Lower Decks S2',
      'Star Trek: Prodigy S1',
      'Star Trek: Discovery S4',
      'Star Trek: Picard S2',
      'Star Trek: Strange New Worlds S1')
      )
group by 1,2)
)

select a.*, b.hours_avail, a.median/b.hours_avail as share
from hours a join hours_avail  b on a.season_level_title=b.season_level_title
