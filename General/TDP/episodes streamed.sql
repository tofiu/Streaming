with stagex as (
select reporting_series_nm as title,
       season_nbr,
       season_level_title,
       video_episode_nbr,
       date_diff(a.day_dt, b.premeire_dt, day)/7 as day_diff,
       TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) as Week,
       v69_registration_id_nbr,
       video_total_time_sec_qty,
       length_in_seconds
  FROM dw_vw.aa_video_detail_reporting_day a 
  join `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b 
  on  a.reporting_series_nm = b.title 
      and (case when reporting_content_type_cd = "MOVIE" then "1" else a.video_season_nbr end) = b.season_nbr
      and a.day_dt >= b.premeire_dt
        AND TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) <13
  where day_dt >= "2017-09-24" 
  --and reporting_series_nm = "1883"
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  and v69_registration_id_nbr IS NOT NULL
  and reporting_content_type_cd = "FEP"
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

select season_level_title, episode_streamed, count(distinct v69_registration_id_nbr) active_sub_hhs
from (
select v69_registration_id_nbr, season_level_title, count(distinct video_episode_nbr) episode_streamed
from stagex
group by 1,2)
group by 1,2
