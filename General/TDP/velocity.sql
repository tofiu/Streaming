with star_trek_titles as (
  select 
    * 
  FROM `i-dss-ent-data.ent_summary.md_content_type_info` 
    where title IN (
      'Star Trek: Discovery S1',
      'Star Trek: Discovery S2',
      'Star Trek: Picard S1',
      'Star Trek: Lower Decks S1',
      'Star Trek: Discovery S3',
     'Star Trek: Lower Decks S2',
     'Star Trek: Prodigy S1',
      'Star Trek: Discovery S4',
    'Star Trek: Picard S2',
      'Star Trek: Strange New Worlds S1'
    )
),

prem_dates_table as (
  select
  co.*,
  prem_date
  from `i-dss-ent-data.ent_summary.md_show_premiere_dates` sp
  JOIN 
    (select * from star_trek_titles) co
      ON sp.video_series_nm = co.reporting_series_nm
      and sp.video_season_nbr = co.video_season_nbr
  where
    prem_date >= "2017-09-24"
),
 stage3 as (
  select 
    co.title,
    cs.video_series_nm,
    cs.video_season_nbr,
    cs.video_episode_nbr,
    cs.video_air_dt,
    cs.v69_registration_id_nbr,
    activation_dt, 
    min(day_dt) first_stream,
    min(video_air_dt) min_video_air_dt,
    date_diff(min(day_dt),case when activation_dt> min(video_air_dt) then activation_dt else min(video_air_dt) end, day) days_diff
  from
    `i-dss-ent-data.ent_summary.ab_aa_originals_new` cs
  LEFT JOIN prem_dates_table co
    ON cs.video_series_nm = co.reporting_series_nm
    and cs.video_season_nbr = co.video_season_nbr
  join
    (select * from `i-dss-ent-data.ent_vw.subscription_fct` s where s.src_system_id =115) s2
    
  on
    cs.v69_registration_id_nbr = s2.cbs_reg_user_id_cd and day_dt between activation_dt and coalesce(expiration_dt, current_date())
  where
    day_dt >= '2017-09-24'
    and date_diff(day_dt, co.prem_date, day) between 0 and 91
    and video_air_dt>= '2017-09-24'
    and site_country_cd='US'
  group by
    1,2,3,4,5,6,7
)

select  
  distinct
  title,
  ROUND(avg(days_diff),1) avg_number_of_days,
  APPROX_QUANTILES(days_diff, 100)[OFFSET(50)] as median_velocity,
  count(distinct v69_registration_id_nbr) sub_hhs,
from 
  stage3
where 
  days_diff>=0            -- where condition to filter out the data issues, major data issue being the inaccurate video air dates causing negative days_diff
group by 1
order by 1
