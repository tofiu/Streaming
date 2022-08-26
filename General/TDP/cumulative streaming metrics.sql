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

required_daily_info as (
  select
  co.title,
  co.prem_date,
  day_dt,
  v69_registration_id_nbr
  from `ent_summary.ab_aa_originals_new` st
  LEFT JOIN prem_dates_table co
    ON st.video_series_nm = co.reporting_series_nm
    and st.video_season_nbr = co.video_season_nbr
  where
    day_dt >= "2017-09-24"
    and date_diff(day_dt, co.prem_date, day) between 0 and 91
    and v69_registration_id_nbr is not null
    and subscription_state_desc in ('sub','trial')
    and streaming_minutes >= 2
  group by 1, 2, 3, 4
),

first_watch_details as (
  select
    vd.v69_registration_id_nbr,
    vd.prem_date,
    vd.title,
    min(vd.day_dt) as active_first_watch,
 FROM required_daily_info vd
group by 1, 2, 3
),

originals_intended as (
  select
    prem_date,
    title,
    active_first_watch,
    date_diff(active_first_watch, prem_date, day) as days_diff,
    count(distinct v69_registration_id_nbr) as unique_intended_subs
  from first_watch_details
  group by 1,2, 3
  order by 1,2, 3
),


cumulative_metrics_again as (
select
    *,
  sum(unique_intended_subs)
over
  (partition by title order by days_diff) as cumulative_unique_subs,
from originals_intended
)

select * from cumulative_metrics_again
order by 2, 3;


----------------------------------------------------------------------------------------------------------------------


-- Daily Consumption Active Sub HHs
with streams as (
SELECT
-- distinct
b.season_level_title,
TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) as Week,
       SUM(case when source_desc = "CBS Platforms" then streams_cnt end) AS weekly_cbs_streams,
       coalesce(SUM(case when source_desc = "Apple Channels" then streams_cnt end),0) AS weekly_apple_streams,
       coalesce(SUM(case when source_desc = "Amazon Channels" then streams_cnt end),0) AS weekly_amazon_streams,
FROM `ent_vw.multi_channels_summary_day` a 
left join `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b 
  on a.reporting_series_nm=b.title 
     and a.day_dt >= b.premeire_dt
     and (case when reporting_content_type_cd = "MOVIE" then "1" else a.video_season_nbr end) = b.season_nbr
WHERE a.day_dt >='2017-09-24'
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
  AND site_country_cd = 'US'
  AND app_nm = 'CBS AA/P+'
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  AND duration_min_cnt >= 2
  and TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) <= 12
  -- and source_Desc <> "Amazon Channels"
group by 1, 2
),
active_sub as (
SELECT
  b.season_level_title,
  TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) as Week,
  count(distinct v69_registration_id_nbr) as weekly_cbs_sub_HH
FROM dw_vw.aa_video_detail_reporting_day a
left join `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b 
  on a.reporting_series_nm=b.title 
     and a.day_dt >= b.premeire_dt
     and (case when reporting_content_type_cd = "MOVIE" then "1" else a.video_season_nbr end) = b.season_nbr
WHERE v69_registration_id_nbr IS NOT NULL
AND a.day_dt >='2017-09-24'
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
  AND video_content_duration_sec_qty >= 120
  and TRUNC(date_diff(a.day_dt, b.premeire_dt, day)/7) <= 12
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
group by 1,2
)
-- ,cumulative_cbs_subs AS
-- (SELECT 
--     season_level_title
--     ,Week
--     ,sum( sum(case when seqnum = 1 then 1 else 0 end)
--         ) over (partition by season_level_title order by Week) as cume_distinct_acc
-- FROM (
--     SELECT 
--         f.*
--         ,row_number() over (partition by v69_registration_id_nbr, season_level_title order by Week) as seqnum
--     FROM active_sub f
-- ) f
-- group by season_level_title, Week
-- )
,cumulative_streams AS
(SELECT 
    distinct
    season_level_title
    ,Week
    ,SUM(weekly_cbs_streams) OVER(PARTITION BY season_level_title ORDER BY Week ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cbs_streams
    ,SUM(weekly_apple_streams) OVER(PARTITION BY season_level_title ORDER BY Week ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS apple_streams
    ,SUM(weekly_amazon_streams) OVER(PARTITION BY season_level_title ORDER BY Week ASC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS amazon_streams
    FROM streams
)
select
    a.season_level_title
    ,a.Week,
    weekly_cbs_streams,
    weekly_apple_streams,
    weekly_amazon_streams,
    cbs_streams,
    apple_streams,
    amazon_streams,
    weekly_cbs_sub_HH
    -- cume_distinct_acc
    from streams a join active_sub b on a.week=b.week and a.season_level_title = b.season_level_title
    join cumulative_streams c on a.week = c.week and a.season_level_title = c.season_level_title
    -- join cumulative_cbs_subs d on a.week=d.week and a.season_level_title = d.season_level_title



-- select 
-- --"Multichannel Table" source,
-- season_level_title
--  week,
--  weekly_cbs_sub_HH,
-- --  weekly_apple_sub_hhs+weekly_amazon_sub_hhs weekly_total_sub_hhs,
--  weekly_cbs_streams,
--  weekly_apple_streams,
--  weekly_amazon_streams,
-- --  weekly_hours
-- from (
-- select a.*, 
--        weekly_cbs_sub_HH,
--        coalesce(weekly_cbs_sub_HH*weekly_apple_streams/weekly_cbs_streams,0) as weekly_apple_sub_hhs,
--         coalesce(weekly_cbs_sub_HH*weekly_amazon_streams/weekly_cbs_streams,0) as weekly_amazon_sub_hhs
-- from streams a join active_sub b on a.week=b.week and a.season_level_title = b.season_level_title)
-- -- -- --where reporting_series_nm <> 'Live TV'
-- order by day_dt, video_episode_nbr asc
