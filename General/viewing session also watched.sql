WITH vod AS (
  SELECT   
    visit_session_id as session
    , v69_registration_id_nbr
    , v31_mpx_reference_guid
    , reporting_series_nm
    --, strm_start_event_dt_ht   -- change this to stream start field
    --, RANK() OVER (PARTITION BY visit_session_id ORDER BY strm_start_event_dt_ht) AS vid_rank      -- change this to stream start field
  FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`  
  where 
  day_dt between '2021-07-07' And '2021-09-29' 
  and video_start_cnt >0
  and lower(reporting_series_nm) in ('big brother', 'big brother live feed')
  and v69_registration_id_nbr is not null
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
 AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")

),

live as (

  SELECT 
  visit_session_id as session
  , v69_registration_id_nbr
  , v31_mpx_reference_guid
  , show_nm
  --, window_stream_start_dt_ut
  --, RANK() OVER (PARTITION BY visit_session_id ORDER BY window_stream_start_dt_ut) as vid_rank)
  from ent_vw.aa_schedule_stream_detail_day
  where day_dt between '2021-07-07' And '2021-09-29' 
  and show_nm in ('Big Brother') 
  and v69_registration_id_nbr is not null
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
)

, stage2 as (
  SELECT
    s1.session
    , show_nm
    , s1.v69_registration_id_nbr
    , reporting_series_nm
  from
    live s1, vod s2 where s1.session = s2.session
    and s1.v69_registration_id_nbr = s2.v69_registration_id_nbr
  GROUP BY
    1,2,3,4
)
  SELECT distinct
  show_nm
  , reporting_series_nm
  , count(distinct v69_registration_id_nbr)
  from stage2
  GROUP BY 1,2
