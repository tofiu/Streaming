DECLARE last_30_days INT64;

SET last_30_days = 30;

-- CREATE OR REPLACE TABLE temp_tl.entry_point_daily_summary as 
DELETE FROM temp_tl.entry_point_daily_summary WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY));
INSERT INTO temp_tl.entry_point_daily_summary

with stage1_originals as (
 select
    distinct
    title,
    -- case
    --   when content_type = "(Movie)" then null
    --   else season_nbr
    -- end as season_nbr,
    -- case
    --   when content_type = "(Movie)" then title
    --   else concat(title," S",season_nbr)
    -- end as show_season_title,
    case 
      when primary_genre_nm = "News & Sports" then secondary_genre_nm 
      else primary_genre_nm 
    end as genre,
    release_strategy,
    case
      when content_type is null then "FEP"
      else "MOVIE"
    end as content_type
  from `ent_summary.pplus_original_premiere_date`
  where
    premeire_dt <= current_date()
union all
select 
"South Park" as title, 
"Comedy" as genre, 
"Weekly" as release_strategy, 
"FEP" as content_type
),

stage2_originals_streaming as(
SELECT day_dt,
reporting_series_nm,
case 
  when lower(last_touch_feature_desc) like '%homepage%carousel%' then 'Homepage Carousel'
  when lower(last_touch_feature_desc) like 'homepage' then 'Homepage Carousel'
  when lower(last_touch_feature_desc) like '%content page%' then 'Content Page'
  when lower(last_touch_feature_desc) like '%cbs%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%nickelodeon%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%mtv%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%smithsonian%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%comedy central%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%bet%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%showtime%' then 'Showtime Hub'
  when lower(last_touch_feature_desc) like '%thematic%' then 'Thematic Hub'
  else last_touch_feature_desc end last_touch,
"Includes All Features" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product

FROM `ent_vw.ctd_path_summary_day` a join stage1_originals b on a.reporting_series_nm = b.title
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
group by 1,2,3,4
--order by 2 desc
UNION ALL 

select
day_dt,
reporting_series_nm,
'End Card (excl. End of Episodes)' last_touch,
"Excludes End Card - End of Episode, Content Page - Episodes, Homepage Carousel - Keep Watching" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product
from `ent_vw.ctd_path_summary_day` a join stage1_originals b on a.reporting_series_nm = b.title
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
and lower(last_touch_feature_desc) like 'end%card%'
and v132_cp_end_card_source_type_desc <> 'end of episode'
and v132_cp_end_card_source_type_desc <> 'end of show' #updated as of 7/17
and v95_cp_state_desc is not null  #updated to align with product
and v69_registration_id_nbr is not null
and v69_registration_id_nbr != ''
and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve' )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product 
group by 1,2,3

UNION ALL

SELECT 
day_dt,
reporting_series_nm,
case when lower(last_touch_feature_desc) like '%homepage%carousel%' then 'Homepage Carousel (excl. Keep Watching)'
       when lower(last_touch_feature_desc) like 'homepage' then 'Homepage Carousel (excl. Keep Watching)'
       when lower(last_touch_feature_desc) like '%content page%' then 'Content Page (Excl. Episodes)'
       when lower(last_touch_feature_desc) like '%cbs%' then 'CBS Brand Hub'
       when lower(last_touch_feature_desc) like '%nickelodeon%' then 'Nickelodeon Brand Hub'
       when lower(last_touch_feature_desc) like '%mtv%' then 'MTV Brand Hub'
       when lower(last_touch_feature_desc) like '%smithsonian%' then 'Smithsonian Brand Hub'
       when lower(last_touch_feature_desc) like '%comedy central%' then 'CC Brand Hub'
       when lower(last_touch_feature_desc) like '%bet%' then 'BET Brand Hub'
       when lower(last_touch_feature_desc) like '%showtime%' then 'Showtime Hub'
       when lower(last_touch_feature_desc) like '%thematic%' then 'Thematic Hub'
else last_touch_feature_desc end last_touch,
"Excludes End Card - End of Episode, Content Page - Episodes, Homepage Carousel - Keep Watching" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product

FROM `ent_vw.ctd_path_summary_day` a join stage1_originals b on a.reporting_series_nm = b.title
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
    and lower(last_touch_feature_desc) not in ('end cards')
    and last_touch_feature_detail_desc not in ('Homepage Carousel - Keep Watching','Content Page - Episodes')
group by 1,2,3,4),

stage3_overall as (
SELECT day_dt,
"P+ Overall" as reporting_series_nm,
case 
  when lower(last_touch_feature_desc) like '%homepage%carousel%' then 'Homepage Carousel'
  when lower(last_touch_feature_desc) like 'homepage' then 'Homepage Carousel'
  when lower(last_touch_feature_desc) like '%content page%' then 'Content Page'
  when lower(last_touch_feature_desc) like '%cbs%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%nickelodeon%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%mtv%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%smithsonian%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%comedy central%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%bet%' then 'Brand Hub'
  when lower(last_touch_feature_desc) like '%showtime%' then 'Showtime Hub'
  when lower(last_touch_feature_desc) like '%thematic%' then 'Thematic Hub'
  else last_touch_feature_desc end last_touch,
"Includes All Features" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product

FROM `ent_vw.ctd_path_summary_day` a 
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
group by 1,2,3,4
--order by 2 desc
UNION ALL 

select
day_dt,
"P+ Overall" as reporting_series_nm,
'End Card (excl. End of Episodes)' last_touch,
"Excludes End Card - End of Episode, Content Page - Episodes, Homepage Carousel - Keep Watching" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product
from `ent_vw.ctd_path_summary_day` a 
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
and lower(last_touch_feature_desc) like 'end%card%'
and v132_cp_end_card_source_type_desc <> 'end of episode'
and v132_cp_end_card_source_type_desc <> 'end of show' #updated as of 7/17
and v95_cp_state_desc is not null  #updated to align with product
and v69_registration_id_nbr is not null
and v69_registration_id_nbr != ''
and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve' )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product 
group by 1,2,3

UNION ALL

SELECT 
day_dt,
"P+ Overall" as reporting_series_nm,
case when lower(last_touch_feature_desc) like '%homepage%carousel%' then 'Homepage Carousel (excl. Keep Watching)'
       when lower(last_touch_feature_desc) like 'homepage' then 'Homepage Carousel (excl. Keep Watching)'
       when lower(last_touch_feature_desc) like '%content page%' then 'Content Page (excl. Episodes)'
       when lower(last_touch_feature_desc) like '%cbs%' then 'CBS Brand Hub'
       when lower(last_touch_feature_desc) like '%nickelodeon%' then 'Nickelodeon Brand Hub'
       when lower(last_touch_feature_desc) like '%mtv%' then 'MTV Brand Hub'
       when lower(last_touch_feature_desc) like '%smithsonian%' then 'Smithsonian Brand Hub'
       when lower(last_touch_feature_desc) like '%comedy central%' then 'CC Brand Hub'
       when lower(last_touch_feature_desc) like '%bet%' then 'BET Brand Hub'
       when lower(last_touch_feature_desc) like '%showtime%' then 'Showtime Hub'
       when lower(last_touch_feature_desc) like '%thematic%' then 'Thematic Hub'
else last_touch_feature_desc end last_touch,
"Excludes End Card - End of Episode, Content Page - Episodes, Homepage Carousel - Keep Watching" flag,
"Overal Streams" stream_type,
sum(video_playback_ind) streams #updated to align with product

FROM `ent_vw.ctd_path_summary_day` a 
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
    and lower(last_touch_feature_desc) not in ('end cards')
    and last_touch_feature_detail_desc not in ('Homepage Carousel - Keep Watching','Content Page - Episodes')
group by 1,2,3,4),

stage4_discovery_streams as (

select distinct
v69_registration_id_nbr,
video_playback_ind,
day_dt,
reporting_series_nm,
last_touch_feature_desc,
v88_player_session_nbr
from `ent_vw.ctd_path_summary_day` a join stage1_originals b on a.reporting_series_nm = b.title
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and reporting_series_nm != ''
and v69_registration_id_nbr is not null
and v69_registration_id_nbr != ''
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
    and last_touch_feature_desc is not null
    and stream_duration_sec_qty > 0
order by 1,2,3,4,5
),

stage5_first_stream as (
select a.*,
b.first_stream_day
from stage4_discovery_streams a
join (select distinct
v69_registration_id_nbr,
v88_player_session_nbr,
reporting_series_nm,
first_stream_day
from `i-dss-ent-data.temp_mk.user_first_content_stream` a join stage1_originals b on a.reporting_series_nm = b.title
where reporting_series_nm is not null
and reporting_series_nm != ''
and v69_registration_id_nbr is not null
and v69_registration_id_nbr != ''
and total_minutes > 0) b
on a.v69_registration_id_nbr=b.v69_registration_id_nbr
and a.reporting_series_nm=b.reporting_series_nm
and a.v88_player_session_nbr=b.v88_player_session_nbr
and a.day_dt=b.first_stream_day
),

stage6_discovery_streams_final as (
select   
day_dt, 
reporting_series_nm,
       case when lower(last_touch_feature_desc) like '%homepage%carousel%' then 'Homepage Carousel'
       when lower(last_touch_feature_desc) like 'homepage' then 'Homepage Carousel'
       when lower(last_touch_feature_desc) like '%content page%' then 'Content Page'
       when lower(last_touch_feature_desc) like '%cbs%' then 'CBS Brand Hub'
       when lower(last_touch_feature_desc) like '%nickelodeon%' then 'Nickelodeon Brand Hub'
       when lower(last_touch_feature_desc) like '%mtv%' then 'MTV Brand Hub'
       when lower(last_touch_feature_desc) like '%smithsonian%' then 'Smithsonian Brand Hub'
       when lower(last_touch_feature_desc) like '%comedy central%' then 'CC Brand Hub'
       when lower(last_touch_feature_desc) like '%bet%' then 'BET Brand Hub'
       when lower(last_touch_feature_desc) like '%showtime%' then 'Showtime Hub'
       when lower(last_touch_feature_desc) like '%thematic%' then 'Thematic Hub'
       else last_touch_feature_desc end last_touch,
"Includes All Features" flag,
"Discovery Streams" stream_type,
sum(video_playback_ind) streams,
from stage5_first_stream
group by 1,2,3


)

select * from stage2_originals_streaming
union all 
select * from stage3_overall
union all 
select * from stage6_discovery_streams_final


------------

-- detailed view

DECLARE last_30_days INT64;

SET last_30_days = 30;

--CREATE OR REPLACE TABLE temp_tl.entry_point_detailed as (
DELETE FROM temp_tl.entry_point_detailed WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY));
INSERT INTO temp_tl.entry_point_detailed

with stage1_originals as (
 select
    distinct
    title,
    -- case
    --   when content_type = "(Movie)" then null
    --   else season_nbr
    -- end as season_nbr,
    -- case
    --   when content_type = "(Movie)" then title
    --   else concat(title," S",season_nbr)
    -- end as show_season_title,
    case 
      when primary_genre_nm = "News & Sports" then secondary_genre_nm 
      else primary_genre_nm 
    end as genre,
    release_strategy,
    case
      when content_type is null then "FEP"
      else "MOVIE"
    end as content_type
  from `ent_summary.pplus_original_premiere_date`
  where
    premeire_dt <= current_date()
union all
select 
"South Park" as title, 
"Comedy" as genre, 
"Weekly" as release_strategy, 
"FEP" as content_type
)

SELECT
day_dt,
reporting_series_nm,
case when last_touch_feature_detail_desc like 'Homepage Marquee%' then trim(REGEXP_REPLACE(last_touch_feature_detail_desc, r'[^Homepage\sMarquee]', ''))
when last_touch_feature_detail_desc like 'My List%' then trim(REGEXP_REPLACE(last_touch_feature_detail_desc, r'[^My\sList]', ''))
when last_touch_feature_detail_desc like 'End Cards' and v132_cp_end_card_source_type_desc not in ('end of episode', 'end of show') then 'End Cards (excluding end of Episodes)'
when last_touch_feature_detail_desc like 'End Cards' then 'End Cards(including end of Episodes)'
else last_touch_feature_detail_desc
end last_touch,
sum(video_playback_ind) streams
FROM `ent_vw.ctd_path_summary_day` a join stage1_originals b on a.reporting_series_nm = b.title
where day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_30_days DAY))
    and last_touch_feature_desc is not null
    and report_suite_id_nm not in (
      'cbsicbsau',
      'cbsicbsca',
      'cbsicbstve'
    )
    AND report_suite_id_nm = 'cnetcbscomsite'  #updated to align with product
    and v1_brand_nm not like 'pplusintl_%'
    and v1_brand_nm like 'pplus_%'
    AND LOWER(reporting_content_type_cd) IN ('movie', 'fep','live')  #updated to align with product
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")  #updated to align with product
    AND LOWER(subscription_package_desc) IN ('cf', 'lc', 'lcp', 'cf-sho', 'lc-sho', 'lcp-sho')  #updated to align with product
group by 1,2,3

