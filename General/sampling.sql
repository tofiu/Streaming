# Pluto TV - All 
SELECT 
series_nm,
COUNT (distinct user_guid) as Unique_Streamers,
COUNT (distinct session_guid) as Streams,
SUM(duration_sec_qty)/60 as Minutes
FROM `i-dss-ent-data.ent_vw.plutotv_content_activity_day`
WHERE day_dt between '2022-09-07' and '2022-09-13' 
and series_nm = "Ink Master"
GROUP BY 1
;

# Pluto TV - All By Channel 
SELECT 
series_nm,
channel_nm,
COUNT (distinct user_guid) as Unique_Streamers,
COUNT (distinct session_guid) as Streams,
SUM(duration_sec_qty)/60 as Minutes
FROM `i-dss-ent-data.ent_vw.plutotv_content_activity_day`
WHERE  day_dt between '2022-09-07' and '2022-09-13' 
and series_nm = "Ink Master"
GROUP BY 1,2
;


# Pluto TV (Multiple Episodes) - Episodes By Channel 
SELECT 
series_nm,
episode_nm,
channel_nm,
COUNT (distinct user_guid) as Unique_Streamers,
COUNT (distinct session_guid) as Streams,
SUM(duration_sec_qty)/60 as Minutes
FROM `i-dss-ent-data.ent_vw.plutotv_content_activity_day`
WHERE day_dt between '2022-09-07' and '2022-09-13' 
and series_nm = "Ink Master"
GROUP BY 1,2,3
;



# Apple & Roku Channels
# Only use NULL for subscription_state_desc
SELECT
    subscription_state_desc,
    source_desc,
    video_series_nm,
    video_title,
        SUM(streams_cnt) AS streams,
        SUM(duration_min_cnt) AS Minutes
FROM `ent_vw.multi_channels_summary_day` cs
WHERE day_dt between '2022-09-07' and '2022-09-13' 
and video_series_nm = "Ink Master"
and video_season_nbr = '14'
and video_episode_nbr = '1'
AND site_country_cd = 'US'
AND app_nm = 'CBS AA/P+'
AND streams_cnt > 0
AND duration_min_cnt > 0
-- AND source_desc IN ("Apple Channels")
AND subscription_state_desc IS NULL
-- AND (subscription_state_desc) NOT IN ("trial", "sub", "discount offer")
GROUP BY 1, 2,3,4
;

#roku channels

SELECT
    subscription_state_desc,
    source_desc,
    video_series_nm,
    video_title,
    count(distinct post_visitor_id) as uv,
        SUM(streams_cnt) AS streams,
        SUM(video_content_duration_sec_qty)/60 AS Minutes
FROM `ent_vw.multi_channel_detail_day` cs
WHERE day_dt between '2022-10-05' and '2022-10-11' 
and video_series_nm = "The Real Love Boat"
and video_season_nbr = '1'
and video_episode_nbr = '1'
AND site_country_cd = 'US'
AND app_nm = 'CBS AA/P+'
AND streams_cnt > 0
AND video_content_duration_sec_qty > 0
AND source_desc IN ("Roku Channel")
AND subscription_state_desc IS NULL
-- AND (subscription_state_desc) NOT IN ("trial", "sub", "discount offer")
GROUP BY 1, 2,3,4

;

# Amazon Channels
# Only use "FREE" for offer_group_desc
SELECT
offer_group_desc,
series_movie_nm,
episode_nm,
--subscription_category_cd, 
count (distinct unique_visitor_cnt) AS UV,
sum(stream_cnt) AS STREAMS,
sum(stream_min_qty) AS MINUTES,
FROM `i-dss-ent-data.ent_vw.amazon_channel_vod_usage_day` 
where day_dt between '2022-09-07' and '2022-09-13' 
and series_movie_nm = "Ink Master"
AND (offer_group_desc = 'FREE' or offer_group_desc = 'PRIME')
and country_cd = "US"
group by 1,2,3
;

# O&O
Select
--day_dt,
reporting_series_nm,
video_season_nbr,
video_episode_nbr,
-- subscription_state_desc,
count(distinct post_visitor_id) as UV,
SUM(video_start_cnt) streams,
SUM((round(safe_cast( video_content_duration_sec_qty /3600 AS NUMERIC),2))) Hours
from 
dw_vw.aa_video_detail_reporting_day
Where video_full_episode_ind IS TRUE 
and day_dt between '2022-09-07' and '2022-09-13'
and reporting_series_nm = "Ink Master"
  and report_suite_id_nm not in ('cbsicbsca', 'cbsicbsau', "cbsicbstve") 
and v69_registration_id_nbr is NOT NULL
and subscription_state_desc NOT IN ("trial", "sub")
and video_episode_nbr = "1"
and video_season_nbr = "14"
Group by 1,2,3--,4
