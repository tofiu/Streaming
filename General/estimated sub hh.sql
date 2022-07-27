with stage1 as (
select 
--   cs.day_dt,
--   date_trunc(cs.day_dt, month) month,
--  date_trunc(day_dt, week) week,
-- CASE when cs.reporting_series_nm in ('Paramount+ Movies','CBS All Access Movies') then video_title else reporting_series_nm end reporting_series_nm_ab, 
  'Channels' source_desc,
  reporting_series_nm,
  SUM(streams_cnt) streams_cnt,
  SUM(duration_min_cnt) duration_min_cnt,
  0 as sub_hh
from
  `i-dss-ent-data.ent_vw.multi_channels_summary_day` cs
where
   day_dt between  '2021-03-04'  and  '2022-02-28' 
    and reporting_series_nm in ('NCIS',"NCIS: Hawai'i","NCIS: Los Angeles","NCIS: New Orleans") -- NCIS franchise
    and subscription_state_desc in ('sub','trial')
   and source_desc NOT IN ('CBS TVE','CBS Platforms')
   and cs.site_country_cd ='US'
   and cs.day_dt<>current_date()
group by 1,2
    
UNION ALL
(
select 
source_desc,
reporting_series_nm,
  SUM(streams_cnt) streams_cnt,
  SUM(duration_min_cnt) duration_min_cnt,
 count(distinct v69_registration_id_nbr) sub_hh

from (
select
--   cs.day_dt,
--   date_trunc(cs.day_dt, month) month,
--  date_trunc(day_dt, week) week,
-- CASE when cs.reporting_series_nm in ('Paramount+ Movies','CBS All Access Movies') then video_title else reporting_series_nm end reporting_series_nm_ab, 
  'O&O Platforms' source_desc,
  reporting_series_nm,
  v69_registration_id_nbr,
  SUM(cs.video_start_cnt) streams_cnt,
  SUM(cs.video_total_time_sec_qty/60) duration_min_cnt,
 -- count(distinct cs.v69_registration_id_nbr) sub_hh
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
where
  day_dt between '2021-03-04'  and  '2022-02-28' 
  and reporting_series_nm in ('NCIS',"NCIS: Hawai'i","NCIS: Los Angeles","NCIS: New Orleans") -- NCIS franchise
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
   and v69_registration_id_nbr IS NOT NULL
group by 1,2,3

UNION ALL

select 
'O&O Platforms' source_desc, 
show_nm as reporting_series_nm,
v69_registration_id_nbr,
  SUM(stream_cnt) streams_cnt,
  SUM(Window_Stream_Sec_Qty/60) duration_min_cnt,
 -- count(distinct v69_registration_id_nbr) sub_hh
FROM `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day` 
where day_dt between '2021-03-04'  and  '2022-02-28' 
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       and show_nm in ('NCIS',"NCIS: Hawai'i","NCIS: Los Angeles","NCIS: New Orleans") -- NCIS franchise
      and LOWER(subscription_state_desc) IN ("trial","sub")
        and v69_registration_id_nbr IS NOT NULL
group by 1,2,3
)group by 1,2

)),
stage2 as (
select
 reporting_series_nm,
  case when SUM(case when source_desc='Channels' then streams_cnt else null end) is NULL then 0 else SUM(case when source_desc='Channels' then streams_cnt else null end) end as channel_streams,
  SUM(case when source_desc='O&O Platforms' then streams_cnt else null end) as o_o_streams,
  SUM(case when source_desc='Channels' then streams_cnt else null end)/SUM(case when source_desc='Channels' then streams_cnt else null end) ratio,
  suM(sub_hh) sub_hh
from
  stage1
group by 1
)
select
 reporting_series_nm,
  channel_streams,
  o_o_streams,
  sub_hh + (sub_hh * SAFE_DIVIDE( channel_streams, o_o_streams)) estimated_sub_hh
from
  stage2
order by estimated_sub_hh desc
