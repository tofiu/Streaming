# Updated and Maintaned by Foram Dedhia; Initial Author Maunik Desai

DECLARE last_15_days, last_365_days INT64;

SET last_15_days = 15;
SET last_365_days = 365;

# Create a daily streaming table for getting active_subs, streams and hours
# We will scan only until 365 days since a show/season's premiere (usually new seasons release within a year)
# The union all in the below query is used to get streamign viewership by reporting_content_type_cd and also aggregated view for LIVE + VOD




#CREATE OR REPLACE TABLE `ent_summary.md_originals_daily_streaming_stats` AS
DELETE FROM `ent_summary.md_originals_daily_streaming_stats` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_originals_daily_streaming_stats`
select
  day_dt,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm,
  title_group_id,
  video_season_nbr,
  case
    when video_season_nbr is null then "1" # Correction for season number of movies to join with other tables
  	when (reporting_series_nm = "Cher & the Loneliest Elephant" and video_season_nbr = "2021") then "1" # Correction for unusual CLE season number value
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt<"2024-05-10") then "6.1" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "6.2" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt<"2025-05-23") then "4.1" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "4.2" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    else video_season_nbr
  end as video_season_nbr_updated, # Saving it in a different column so original video_season_nbr column stays preserved for later use
  case
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "2024-05-10" --5/9/24 AD: Create premiere date of The Chi 6.2 
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "2025-05-23" --5/23/25 AD: Create premiere date of Couples Therapy 4.2 
    else season_premeire_dt
  end as season_premeire_dt,
  genre_nm,
  case
  	when ((reporting_series_nm = "The Good Fight") and (video_season_nbr = "1")) then "FEP" # Correction for missing TGF S1 content_type_cd
  	else reporting_content_type_cd
  end as reporting_content_type_cd,
  max(day_dt) last_date,
  count(distinct v69_registration_id_nbr) active_subs_hhs,
  SUM(streams_cnt) streams,
  SUM(stream_min_cnt/60) hours_streamed 
from
  `i-dss-ent-data.ent_vw.pplus_originals_content_detail_day`
where
  (date_diff(day_dt, season_premeire_dt, day) between 0 and 364 or (reporting_series_nm="The Chi" and video_season_nbr="6" and date_diff(day_dt, "2024-05-10", day) between 0 and 364) or (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and date_diff(day_dt, "2025-05-23", day) between 0 and 364)) --5/9/24 AD: The Chi 6.2 does not have the correct premiere date in the table and Couples Therapy 4.2
  and src_system_id = 115
  and subscription_state_desc in ('sub','trial', 'discount offer')
  and day_dt >= season_premeire_dt
  and video_full_episode_ind
  and v69_registration_id_nbr is not null
    #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY))
group by all 

UNION ALL

select
  day_dt,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  case
    when video_season_nbr is null then "1" # Correction for season number of movies to join with other tables
  	when (reporting_series_nm = "Cher & the Loneliest Elephant" and video_season_nbr = "2021") then "1" # Correction for unusual CLE season number value
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt<"2024-05-10") then "6.1" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "6.2" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt<"2025-05-23") then "4.1" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "4.2" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    else video_season_nbr
  end as video_season_nbr_updated, # Saving it in a different column so original video_season_nbr column stays preserved for later use
  case
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "2024-05-10" --5/9/24 AD: Create premiere date of The Chi 6.2 
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "2025-05-23" --5/23/25 AD: Create premiere date of Couples Therapy 4.2
    else season_premeire_dt
  end as season_premeire_dt,
  genre_nm,
 "LIVE + VOD" reporting_content_type_cd,
  max(day_dt) last_date,
  count(distinct v69_registration_id_nbr) active_subs_hhs,
  SUM(streams_cnt) streams,
  SUM(stream_min_cnt/60) hours_streamed 
from
  `i-dss-ent-data.ent_vw.pplus_originals_content_detail_day`
where
  (date_diff(day_dt, season_premeire_dt, day) between 0 and 364 or (reporting_series_nm="The Chi" and video_season_nbr="6" and date_diff(day_dt, "2024-05-10", day) between 0 and 364) or (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and date_diff(day_dt, "2025-05-23", day) between 0 and 364)) --5/9/24 AD: The Chi 6.2 does not have the correct premiere date in the table and Couples Therapy 4.2
  and src_system_id = 115
  and subscription_state_desc in ('sub','trial', 'discount offer')
  and day_dt >= season_premeire_dt
  and video_full_episode_ind
  and v69_registration_id_nbr is not null
    #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY))
group by all; 

------------------------------------------------------------------------
------------------------------------------------------------------------

# For cumulative metrics, you can sum up streams and streaming hours but not active subs
# On a daily basis, which ids viewed a particular show/season across O&O and channel partners
# The union all in the below query is used to get streamign viewership by reporting_content_type_cd and also aggregated view for LIVE + VOD

#CREATE OR REPLACE TABLE `ent_summary.md_originals_daily_streaming_ids` AS
DELETE FROM `ent_summary.md_originals_daily_streaming_ids` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_originals_daily_streaming_ids`
select
  distinct
  day_dt,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  case 
    when video_season_nbr is null then "1" 
  	when (reporting_series_nm = "Cher & the Loneliest Elephant" and video_season_nbr = "2021") then "1"
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt<"2024-05-10") then "6.1" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "6.2" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt<"2025-05-23") then "4.1" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "4.2" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    else video_season_nbr
  end as video_season_nbr_updated,
  case
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "2024-05-10" --5/9/24 AD: Create premiere date of The Chi 6.2 
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "2025-05-23" --5/23/25 AD: Create premiere date of Couples Therapy 4.2
    else season_premeire_dt
  end as season_premeire_dt,
  case
  	when ((reporting_series_nm = "The Good Fight") and (video_season_nbr = "1")) then "FEP" # Correction for missing TGF S1 content_type_cd
  	else reporting_content_type_cd
  end as reporting_content_type_cd,
  v69_registration_id_nbr as originals_active_sub_id, 
  intended_v69_registration_id_nbr as originals_intended_active_sub_id
from
  `ent_vw.pplus_originals_content_detail_day`
where
  (date_diff(day_dt, season_premeire_dt, day) between 0 and 364 or (reporting_series_nm="The Chi" and video_season_nbr="6" and date_diff(day_dt, "2024-05-10", day) between 0 and 364) or (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and date_diff(day_dt, "2025-05-23", day) between 0 and 364)) --5/9/24 AD: The Chi 6.2 does not have the correct premiere date in the table and Couples Therapy 4.2
  and src_system_id = 115
  and subscription_state_desc in ('sub','trial', 'discount offer')
  and day_dt >= season_premeire_dt
  and video_full_episode_ind
  and v69_registration_id_nbr is not null
  and (source_desc <> "Hulu" or day_dt >= "2024-01-01") -- [AD] 9/12/24 Remove Hulu subs before Jan'24
  #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY))
  GROUP BY ALL 
  
  UNION ALL
  
  select
  distinct
  day_dt,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  case 
    when video_season_nbr is null then "1" 
  	when (reporting_series_nm = "Cher & the Loneliest Elephant" and video_season_nbr = "2021") then "1"
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt<"2024-05-10") then "6.1" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "6.2" --5/9/24 AD: Distinguish the difference between The Chi 6.1 and 6.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt<"2025-05-23") then "4.1" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "4.2" --5/23/25 AD: Distinguish the difference between Couples Therapy 4.1 and 4.2
    else video_season_nbr
  end as video_season_nbr_updated,
  case
    when (reporting_series_nm="The Chi" and video_season_nbr="6" and day_dt>="2024-05-10") then "2024-05-10" --5/9/24 AD: Create premiere date of The Chi 6.2
    when (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and day_dt>="2025-05-23") then "2025-05-23" --5/23/25 AD: Create premiere date of Couples Therapy 4.2 
    else season_premeire_dt
  end as season_premeire_dt,
 "LIVE + VOD" reporting_content_type_cd,
  v69_registration_id_nbr as originals_active_sub_id, 
  intended_v69_registration_id_nbr as originals_intended_active_sub_id
from
  `ent_vw.pplus_originals_content_detail_day`
where
  (date_diff(day_dt, season_premeire_dt, day) between 0 and 364 or (reporting_series_nm="The Chi" and video_season_nbr="6" and date_diff(day_dt, "2024-05-10", day) between 0 and 364) or (reporting_series_nm="Couples Therapy" and video_season_nbr="4" and date_diff(day_dt, "2025-05-23", day) between 0 and 364)) --5/9/24 AD: The Chi 6.2 does not have the correct premiere date in the table and Couples Therapy 4.2
  and src_system_id = 115
  and subscription_state_desc in ('sub','trial', 'discount offer')
  and day_dt >= season_premeire_dt
  and video_full_episode_ind
  and v69_registration_id_nbr is not null
  and (source_desc <> "Hulu" or day_dt >= "2024-01-01") -- [AD] 9/12/24 Remove Hulu subs before Jan'24
  #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY))
  GROUP BY ALL ; 

------------------------------------------------------------------------
------------------------------------------------------------------------

# When did a particular id watch a particular show/season for the first time
#CREATE OR REPLACE TABLE `ent_summary.md_originals_day_of_first_watch` AS
DELETE FROM `ent_summary.md_originals_day_of_first_watch` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY));
INSERT INTO `ent_summary.md_originals_day_of_first_watch`
select
  originals_active_sub_id,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  video_season_nbr_updated,
  season_premeire_dt,
  reporting_content_type_cd,
  min(day_dt) as originals_day_of_first_watch, 
from `ent_summary.md_originals_daily_streaming_ids`
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
group by all; 

#CREATE OR REPLACE TABLE `ent_summary.md_originals_day_of_first_watch_intended` AS
DELETE FROM `ent_summary.md_originals_day_of_first_watch_intended` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY));
INSERT INTO `ent_summary.md_originals_day_of_first_watch_intended`
select
  originals_intended_active_sub_id, 
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  video_season_nbr_updated,
  season_premeire_dt,
  reporting_content_type_cd,
  min(day_dt) as originals_day_of_first_watch, 
from `ent_summary.md_originals_daily_streaming_ids`
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
group by all; 

------------------------------------------------------------------------
------------------------------------------------------------------------

# How many unique viewers do we get for a particular show/season across O&O and channel partners
#CREATE OR REPLACE TABLE `ent_summary.md_originals_unique_viewers` AS
DELETE FROM `ent_summary.md_originals_unique_viewers` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY));
INSERT INTO `ent_summary.md_originals_unique_viewers`
with unique as (
  select
  originals_day_of_first_watch,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  video_season_nbr_updated,
  season_premeire_dt,
  reporting_content_type_cd,
  count(distinct originals_active_sub_id) as originals_unique_subs_hhs,
from `ent_summary.md_originals_day_of_first_watch`
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
group by all 
),

intended as (select
  originals_day_of_first_watch,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr,
  video_season_nbr_updated,
  season_premeire_dt,
  reporting_content_type_cd,
  count(distinct originals_intended_active_sub_id) as originals_unique_intended_subs_hhs,
from `ent_summary.md_originals_day_of_first_watch_intended`
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
group by all) 

select 
  a.*,
  b.originals_unique_intended_subs_hhs
from unique a
left join intended b
using (originals_day_of_first_watch,
  source_desc,
  reporting_series_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  video_season_nbr_updated,
  season_premeire_dt,
  reporting_content_type_cd)
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
;

------------------------------------------------------------------------
------------------------------------------------------------------------

# Get a daily count of total subscribers on all platforms
#CREATE OR REPLACE TABLE `ent_summary.md_service_total_subscriptions` AS
DELETE FROM `ent_summary.md_service_total_subscriptions` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_service_total_subscriptions`

select
  day_dt,
  case 
    when lower(subscription_platform_cd) like 'amazon channels%' then "Amazon Channels" -- FD 9/1/23: updated to include Amazon SHO migration
    when lower(subscription_platform_cd) like 'apple ch%' then "Apple Channels"
    when lower(subscription_platform_cd) like 'the roku channel%' then "Roku Channel"
    when lower(subscription_platform_cd) like 'hulu%' and day_dt >= "2024-01-01" then 'Hulu'
    else "O&O Platforms"
  end as source_desc,
  sum(total_subs_cnt) as service_total_subs
from `ent_vw.subscription_kpi_overall_summary_day`
where
  src_system_id = 115
  and (subscription_platform_cd not in ("HULU") or day_dt >= "2024-01-01")
  and  subscription_platform_cd <> "YOUTUBE CHANNELS" -- excluding Youtube Channels for first x days as viewership is not available 
  #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE(), INTERVAL last_15_days DAY))
group by 1,2;

------------------------------------------------------------------------
------------------------------------------------------------------------

# Get a daily sum of Content Hours to calculate % of Total Hours
#CREATE OR REPLACE TABLE `ent_summary.ad_service_total_content_hours` AS
DELETE FROM `ent_summary.ad_service_total_content_hours` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.ad_service_total_content_hours`

select 
  day_dt,
  source_desc,
  sum(content_duration_min_cnt)/60 as service_content_hrs
from `ent_summary.fd_house_of_brands`
where 
  --day_dt>='2021-03-04'
  day_dt >= (DATE_SUB(CURRENT_DATE(), INTERVAL last_15_days DAY))
group by 1,2;

------------------------------------------------------------------------
------------------------------------------------------------------------

# Get a daily count of active subscribers on all platforms
#CREATE OR REPLACE TABLE `ent_summary.md_service_active_subs` AS
DELETE FROM `ent_summary.md_service_active_subs` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_service_active_subs`

SELECT
  day_dt,
  source_desc,
  count (distinct v69_registration_id_nbr) as service_total_active_subs
  from `ent_summary.fd_house_of_brands` --5/9/24 AD: Changed from MC to HoB
where 
  subscription_state_desc in ('sub','trial', 'discount offer')
  and v69_registration_id_nbr is not null
  #DELTA FILTER
  and day_dt >= (DATE_SUB(CURRENT_DATE(), INTERVAL last_15_days DAY))
group by 1,2;

------------------------------------------------------------------------
------------------------------------------------------------------------

# On a daily basis, which ids viewed anything on the service
#CREATE OR REPLACE TABLE `ent_summary.md_service_daily_streaming_ids` AS
DELETE FROM `ent_summary.md_service_daily_streaming_ids` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_service_daily_streaming_ids`
select 
  distinct 
  day_dt,
  source_desc,
  v69_registration_id_nbr as service_active_sub_id,
from `ent_summary.fd_house_of_brands` --5/9/24 AD: Changed from MC to HoB
where
    subscription_state_desc in ('sub','trial', 'discount offer')
    and v69_registration_id_nbr is not null
    #DELTA FILTER
    and day_dt >= (DATE_SUB(CURRENT_DATE(), INTERVAL last_15_days DAY));

------------------------------------------------------------------------
------------------------------------------------------------------------

# When did a particular id watch for the first time on the service
#CREATE OR REPLACE TABLE `ent_summary.md_service_day_of_first_watch` AS
DELETE FROM `ent_summary.md_service_day_of_first_watch` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY));
INSERT INTO `ent_summary.md_service_day_of_first_watch`
# Getting a list of all unique premiere dates
with season_premeires as (
  select 
    distinct   
      premeire_dt AS season_premeire_dt
  from `ent_summary.pplus_original_premiere_date`
  where
    #DELTA FILTER 
    premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
)

select
  source_desc,
  service_active_sub_id,
  season_premeire_dt,
  min(day_dt) as service_day_of_first_watch,
from season_premeires sp 
join `ent_summary.md_service_daily_streaming_ids` ds
on 
  ds.day_dt >= sp.season_premeire_dt
where
  date_diff(day_dt, season_premeire_dt, day) between 0 and 364
group by 1, 2, 3;

------------------------------------------------------------------------
------------------------------------------------------------------------

# How many unique viewers do we get on the service
#CREATE OR REPLACE TABLE `ent_summary.md_service_unique_viewers` AS
DELETE FROM `ent_summary.md_service_unique_viewers` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY));
INSERT INTO `ent_summary.md_service_unique_viewers`
select
  service_day_of_first_watch,
  source_desc,
  season_premeire_dt,
  count(distinct service_active_sub_id) as service_unique_subs_hhs
from `ent_summary.md_service_day_of_first_watch`
where
  #DELTA FILTER
  season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_365_days DAY))
group by 1,2,3;

------------------------------------------------------------------------
------------------------------------------------------------------------

# Create a daily starts table for the service
#CREATE OR REPLACE TABLE `ent_summary.md_service_daily_starts` AS
DELETE FROM `ent_summary.md_service_daily_starts` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_service_daily_starts`

select
  case 
    when source_cd like 'Hulu%' then 'Hulu'
    when source_cd= 'CBS Platforms' then 'O&O Platforms' 
    when source_cd like 'The Roku Channel%' then 'Roku Channel'
    when source_cd like "Amazon Channels%" then "Amazon Channels" 
    when source_cd like "Apple Channels%" then 'Apple Channels'
    else 'O&O Platforms'  
  end as source_cd,                                           
  case 
    when slam_show_gp_nm in ('The Real World Homecoming','The Real World Homecoming: New York','The Real World Homecoming: Los Angeles') then 'The Real World Homecoming' 
    when slam_show_gp_nm in ("Reinventing Elvis: The '68 Comeback") then "Reinventing Elvis: The '68 Comeback"
    when slam_show_gp_nm in ("Teenage Mutant Ninja Turtles: Mutant Mayhem | Now Streaming on Paramount+","Teenage Mutant Ninja Turtles: Mutant Mayhem") then "Teenage Mutant Ninja Turtles: Mutant Mayhem" -- TL 10/2 update
   when slam_show_gp_nm in ("The Caine Mutiny Court Martial") then "The Caine Mutiny Court-Martial" -- Davida 10/25 update; AD 2/6/24 swapped the order of title
   when slam_show_gp_nm in ("Hollywood Squares") then "Hollywood Squares (2025)"
    else slam_show_gp_nm
  end as slam_show_gp_nm,
  title_id, 
  title_group_nm, 
  title_group_id, 
  s.day_dt,
  SUM(s.start_cnt) as start_cnt 
from
  `i-dss-ent-data.ent_vw.subscription_slam_summary_day` s
where
  day_dt >= DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY)
  --day_dt >= "2021-03-01"
  AND acquisition_type_cd = "Starts" --restatement
group by all 

 /*
  
  UNION ALL

  # Get CBS Platform starts from att_summary table before launch date
  select
    'O&O Platforms' as slam_source,
    CASE when att_level_up_noduel='Star Trek: Discovery / After Trek' then 'Star Trek: Discovery' else att_level_up_noduel end as slam_show_gp_nm,
    '0' as title_id, 
    '0' as title_group_nm, 
    '0' as title_group_id, 
    start_dt as day_dt,
    SUM(estimated_attribution_nbr) estimated_start_cnt 
  from
    `i-dss-ent-data.ent_summary.att_summary_ltd`
  where
    start_dt < '2021-03-01'
  group by all 

  UNION ALL

  # Get Amazon starts from amazon_premium_vod table before launch date
  select
    'Amazon Channels' as slam_source,
    series_movie_nm as slam_show_gp_nm,
    '0' as title_id, 
    '0' as title_group_nm, 
    '0' as title_group_id, 
    CAST(report_dt as DATE) as day_dt,
    SUM(first_title_subscriber_cnt) as estimated_start_cnt 
  from
    `i-dss-ent-data.ent_vw.amazon_premium_vod_title_day` 
  where
    CAST(report_dt as DATE) < '2021-03-01'
  group by all 

  UNION ALL

  # Get Apple starts from apple_channels_streams table before launch date
  select
    'Apple Channels' as slam_source,
    series_nm as slam_show_gp_nm,
    '0' as title_id, 
    '0' as title_group_nm, 
    '0' as title_group_id, 
    day_dt,
    SUM(a.total_unique_cnt ) as estimated_start_cnt 
  from
    `i-dss-ent-data.ent_vw.apple_channels_streams_sum_day` a
  where
    a.first_streams_ind 
    and day_dt < '2021-03-01'
  group by all 

  UNION ALL

  # Get Amazon missing starts from temp table created by Maunik Desai to estimate starts for Amazon Channels before the Amazon data was made available to Paramount+
  select
    slam_source,
    show_name as slam_show_gp_nm,
    '0' as title_id, 
    '0' as title_group_nm, 
    '0' as title_group_id, 
    day_dt,
    SUM(estimated_amazon_starts) as estimated_start_cnt 
  from
    `i-dss-ent-data.ent_summary.md_originals_amazon_starts` a             
  group by all 
*/
;
------------------------------------------------------------------------
------------------------------------------------------------------------

# Correcting the season number for SLAM starts to account for multi-season show's start attribution
CREATE OR REPLACE TABLE `ent_summary.md_originals_season_starts_date_ranges` AS
#DELETE FROM `ent_summary.md_originals_season_starts_date_ranges` WHERE season_premeire_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
#INSERT INTO `ent_summary.md_originals_season_starts_date_ranges`
# Getting a list of all shows, their seasons and premiere dates
with show_seasons as (
  select
    distinct
    title_id, --restatement
    title as reporting_series_nm,
    case
      when season_nbr is null then "1" # Correction for season number of movies to join with other tables
  	  when (title = "Cher & the Loneliest Elephant" and season_nbr = "2021") then "1" # Correction for unusual CLE season number value
      else season_nbr
    end as video_season_nbr,
    premeire_dt as season_premeire_dt,
  from `ent_summary.pplus_original_premiere_date` pd
  where
    premeire_dt is not null
    and title_id is not null

UNION ALL
  --For SOUTH PARK FIRST X Tab
  select 
    distinct 
    mpd.title_id, --restatement
    reporting_title,
    season_number,
    premiere_date
  from `i-dss-ent-data.ent_summary.mtv_music_dates` mtv
  join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd -- FD 2025.9.23 added this join to pick up title_id and reporting_series_nm from title matching tables
  on mtv.reporting_title = mpd.reporting_series_nm
  where reporting_title='South Park'
),

# Getting total season count as well as max season nbr
season_info as (
  select
    title_id, --restatement
    reporting_series_nm,
    count(distinct video_season_nbr) as total_seasons,
    max(CAST(video_season_nbr as INT)) as current_season_nbr,
    min(CAST(video_season_nbr as INT)) as first_season_nbr,
  from show_seasons
  group by 1,2 --restatement
),

# Getting the next premiere date for shows with multiple seasons
current_and_next_season_premiere as (
  select 
    a.title_id, --restatement
    a.reporting_series_nm,
    a.video_season_nbr,
    a.season_premeire_dt,
    b.video_season_nbr as next_season,
    b.season_premeire_dt as next_season_premeire_dt,
    t.total_seasons,
    t.current_season_nbr,
  from show_seasons a
  join show_seasons b
    using 
      (title_id,reporting_series_nm) --restatement
  join season_info t
    using 
      (title_id,reporting_series_nm) --restatement
  where
    # For shows with only 1 season, next_season_premeire_dt is the same
    # For shows with multiple seasons, except for its last season, the next_season_premeire_dt is next season's prem date; for its last season, next_season_premeire_dt is same
    ((t.total_seasons = 1 and a.video_season_nbr = b.video_season_nbr)
    or (t.total_seasons != 1 
    and (cast(a.video_season_nbr as int) = cast(b.video_season_nbr as int) - 1) 
      or (cast(a.video_season_nbr as int) = t.current_season_nbr) and (cast(b.video_season_nbr as int) = t.current_season_nbr)))
)

# Need to correct the next_season_premeire_dt for shows with 1 seasons and last season of shows with multiple season

# Manually changed The Chi S6 entry and added The Chi S6.2 --5/10/24 AD
# Manually changed Couples Therapy entry and added Couples Therapy S4.2 --5/23/25 AD

select
  title_id, --restatement
  reporting_series_nm,
  CASE 
    WHEN reporting_series_nm="The Chi" and video_season_nbr="6" then "6.1"
    WHEN reporting_series_nm="Couples Therapy" and video_season_nbr="4" then "4.1"
    ELSE video_season_nbr
  END as video_season_nbr,
  season_premeire_dt,
  CASE 
    WHEN reporting_series_nm="The Chi" and video_season_nbr="6" then "6.2"
    WHEN reporting_series_nm="Couples Therapy" and video_season_nbr="4" then "4.2"
    ELSE next_season
  END as next_season,
  CASE 
    WHEN reporting_series_nm="The Chi" and video_season_nbr="6" then "2024-05-10"
     WHEN reporting_series_nm="Couples Therapy" and video_season_nbr="4" then "2025-05-23"
    ELSE next_season_premeire_dt
  END as next_season_premeire_dt,
  total_seasons,
  current_season_nbr,
  case 
    when reporting_series_nm="The Chi" and video_season_nbr="6" then "2024-05-10"
    when reporting_series_nm="Couples Therapy" and video_season_nbr="4" then "2025-05-23"
    when total_seasons = 1 then current_date()
    when total_seasons != 1 and (video_season_nbr = next_season and CAST(next_season as INT) = current_season_nbr) then current_date()
    else next_season_premeire_dt
  end as scan_thru_date
from current_and_next_season_premiere
UNION ALL
select
  title_id, --restatement
  "The Chi" as reporting_series_nm,
  "6.2" as video_season_nbr,
  "2024-05-10" as  season_premeire_dt,
  next_season,
  next_season_premeire_dt,
  total_seasons,
  current_season_nbr,
  CASE
    WHEN (video_season_nbr = next_season and CAST(next_season as INT) = current_season_nbr) then current_date()
    else next_season_premeire_dt
  end as scan_thru_date
from current_and_next_season_premiere
where 
  reporting_series_nm="The Chi"
  and video_season_nbr="6"
UNION ALL
select
  title_id, --restatement
  "Couples Therapy" as reporting_series_nm,
  "4.2" as video_season_nbr,
  "2025-05-23" as  season_premeire_dt,
  next_season,
  next_season_premeire_dt,
  total_seasons,
  current_season_nbr,
  CASE
    WHEN (video_season_nbr = next_season and CAST(next_season as INT) = current_season_nbr) then current_date()
    else next_season_premeire_dt
  end as scan_thru_date
from current_and_next_season_premiere
where 
  reporting_series_nm="Couples Therapy"
  and video_season_nbr="4"
;

------------------------------------------------------------------------
------------------------------------------------------------------------


#CREATE OR REPLACE TABLE `ent_summary.md_originals_daily_starts` AS
DELETE FROM `ent_summary.md_originals_daily_starts` WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
INSERT INTO `ent_summary.md_originals_daily_starts`
# Join with slam table to account for correct season number
select
  source_cd,                                         
  slam_show_gp_nm,  
  su.title_id, --restatement
  su.title_group_nm, --restatement
  su.title_group_id,   --restatement                                              
  su.day_dt,
  start_cnt, 
  video_season_nbr as slam_show_season_nbr
from `ent_summary.md_service_daily_starts` su
join `ent_summary.md_originals_season_starts_date_ranges` st
  on
    --su.title_id=st.title_id --restatement
    (CASE WHEN su.day_dt<'2021-03-01' then trim(lower(su.slam_show_gp_nm)) ELSE su.title_id END) = (CASE WHEN st.season_premeire_dt <'2021-03-01' then trim(lower(st.reporting_series_nm)) else st.title_id END) 
    and su.day_dt >= season_premeire_dt
    and su.day_dt < st.scan_thru_date
where
  #DELTA FILTER
 su.day_dt >= DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY) 
 ;

------------------------------------------------------------------------
------------------------------------------------------------------------

------------------------------------------------------------------------
------------------------------------------------------------------------

------------------------------------------------------------------------
------------------------------------------------------------------------

CREATE OR REPLACE TABLE `ent_summary.md_originals_first_x_days_renewed` AS

with daily_stats as (
  select
    distinct
    # show metadata
    trim(ss.reporting_series_nm) as reporting_series_nm, --restatement
    ss.title_id, 
    ss.title_group_nm, 
    ss.title_group_id, 
    CASE
      WHEN ss.reporting_series_nm="The Chi" and ss.video_season_nbr="6" then ss.video_season_nbr_updated --5/10/24 AD Added in to distinguish The Chi S6 parts
      WHEN ss.reporting_series_nm="Couples Therapy" and ss.video_season_nbr="4" then ss.video_season_nbr_updated --5/23/25 AD Added in to distinguish Couples Therapy S4 parts
      ELSE ss.video_season_nbr
    END as video_season_nbr,
    ss.video_season_nbr_updated,
    ss.season_premeire_dt,
    ss.genre_nm,
    ss.reporting_content_type_cd,

    # day tracker
    ss.day_dt,
    date_diff(ss.day_dt, ss.season_premeire_dt, day)+1 as days_diff,

    # source (O&O, Amazon, Apple, Roku)
    ss.source_desc,                                                       

    # daily title specific subs_hhs data
    ss.active_subs_hhs as originals_active_subs_hhs,
    uv.originals_unique_subs_hhs as originals_unique_subs_hhs,
    uv.originals_unique_intended_subs_hhs as originals_unique_intended_subs_hhs,

    # daily platform specific subs_hhs data
    ac.service_total_active_subs as service_active_subs_hhs,
    un.service_unique_subs_hhs as service_unique_subs_hhs,

    # daily platform specific total subs
    ts.service_total_subs as service_total_subs,

    # daily platform specific total content hours
    ch.service_content_hrs as service_content_hrs,

    # starts
    # FD 11/21/23 added case statements below to remove Starts from Live TV as SLAM doesn not provide breakdown by content type
    case when ss.reporting_content_type_cd ="LIVE TV" then null else ds.start_cnt end as starts,                            

    # streaming activity
    ss.streams,
    ss.hours_streamed

  FROM `ent_summary.md_originals_daily_streaming_stats` ss
  LEFT JOIN `ent_summary.md_originals_daily_starts` ds
    ON  (CASE WHEN ss.day_dt<'2021-03-01' then trim(lower(ss.reporting_series_nm)) ELSE ss.title_id END) = (CASE WHEN ds.day_dt<'2021-03-01' then trim(lower(ds.slam_show_gp_nm)) else ds.title_id END) 
    and ss.video_season_nbr_updated = ds.slam_show_season_nbr
    and ss.source_desc = ds.source_cd                                          
    and ss.day_dt = ds.day_dt
  LEFT JOIN `ent_summary.md_originals_unique_viewers` uv
    ON ss.reporting_series_nm = uv.reporting_series_nm
    and ss.video_season_nbr_updated = uv.video_season_nbr_updated
    and ss.source_desc = uv.source_desc
    and ss.day_dt = uv.originals_day_of_first_watch
   and ss.reporting_content_type_cd = uv.reporting_content_type_cd   --FD 11/21/23 added to join by content_type_cd to avoid duplication
  LEFT JOIN `ent_summary.md_service_unique_viewers` un
    ON ss.season_premeire_dt = un.season_premeire_dt
    and ss.source_desc = un.source_desc
    and ss.day_dt = un.service_day_of_first_watch
  LEFT JOIN `ent_summary.md_service_total_subscriptions` ts
    ON ss.source_desc = ts.source_desc
    and (CASE --10/8/25   
          WHEN ss.day_dt> DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY) then DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
          ELSE ss.day_dt
        END) = ts.day_dt
    -- ss.day_dt = ts.day_dt
  LEFT JOIN `ent_summary.md_service_active_subs` ac
    ON ss.source_desc = ac.source_desc
    and ss.day_dt = ac.day_dt
  LEFT JOIN `ent_summary.ad_service_total_content_hours` ch
    ON ss.source_desc = ch.source_desc
    and ss.day_dt = ch.day_dt
),

hulu_add_in as (
  select
    reporting_series_nm,
    title_id, 
    title_group_nm, 
    title_group_id, 
    video_season_nbr,
    video_season_nbr_updated,
    season_premeire_dt,
    genre_nm,
    reporting_content_type_cd,
    ds.day_dt,
    days_diff,
    'Hulu' as source_desc,
    ts.service_total_subs
  from daily_stats  ds
  LEFT JOIN `ent_summary.md_service_total_subscriptions` ts
    ON ts.source_desc='Hulu'
    and (CASE --10/8/25   
          WHEN ds.day_dt> DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY) then DATE_SUB(CURRENT_DATE(), INTERVAL 3 DAY)
          ELSE ds.day_dt
        END) = ts.day_dt
  GROUP BY ALL
),

# derive key cumulative metrics
daily_stats_with_cumulative_metrics as (
select 
  COALESCE(ds.reporting_series_nm, ha.reporting_series_nm) as reporting_series_nm, --restatement
    COALESCE(ds.title_id, ha.title_id) as title_id,
    COALESCE(ds.title_group_nm, ha.title_group_nm) as title_group_nm, 
    COALESCE(ds.title_group_id, ha.title_group_id) as title_group_id, 
    COALESCE(ds.video_season_nbr, ha.video_season_nbr) as video_season_nbr,
    COALESCE(ds.video_season_nbr_updated, ha.video_season_nbr_updated) as video_season_nbr_updated,
    COALESCE(ds.season_premeire_dt, ha.season_premeire_dt) as season_premeire_dt,
    COALESCE(ds.genre_nm, ha.genre_nm) as genre_nm,
    COALESCE(ds.reporting_content_type_cd, ha.reporting_content_type_cd) as reporting_content_type_cd,
    COALESCE(ds.day_dt, ha.day_dt) as  day_dt,   
    COALESCE(ds.days_diff, ha.days_diff) as days_diff,
    COALESCE(ds.source_desc, ha.source_desc) as source_desc,                                                      
    originals_active_subs_hhs,
    originals_unique_subs_hhs,
    originals_unique_intended_subs_hhs,
    service_active_subs_hhs,
    service_unique_subs_hhs,
    COALESCE(ds.service_total_subs, ha.service_total_subs) as service_total_subs,
    service_content_hrs,
    starts,                            
    streams,
    hours_streamed,

  sum(originals_unique_subs_hhs) over 
  (partition by  reporting_series_nm, video_season_nbr_updated, reporting_content_type_cd, source_desc order by days_diff) as cumulative_originals_unique_subs_hhs,
  
  # Fd 11/21/23 added the below condition to prevent duplication in cumulative calculations
 -- sum(starts) over 
  sum (case when reporting_content_type_cd = "LIVE + VOD" then starts end) over
  (partition by  reporting_series_nm, video_season_nbr_updated, reporting_content_type_cd, source_desc order by days_diff) as cumulative_starts, 

  sum(hours_streamed) over 
  (partition by  reporting_series_nm, video_season_nbr_updated, reporting_content_type_cd, source_desc order by days_diff) as cumulative_hours_streamed,
  
  sum(streams) over 
  (partition by  reporting_series_nm, video_season_nbr_updated, reporting_content_type_cd, source_desc order by days_diff) as cumulative_streams,
  
from daily_stats ds
FULL OUTER JOIN hulu_add_in ha
 USING (reporting_series_nm,
    title_id, 
    title_group_nm, 
    title_group_id, 
    video_season_nbr,
    video_season_nbr_updated,
    season_premeire_dt,
    genre_nm,
    reporting_content_type_cd,
    day_dt,
    days_diff,
    source_desc,
    service_total_subs)
)

select 
  *,
  EXTRACT(DATETIME FROM current_timestamp() AT TIME ZONE "America/Los_Angeles") as last_refresh_timestamp
from daily_stats_with_cumulative_metrics;
