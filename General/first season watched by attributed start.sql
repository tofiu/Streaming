with seal_subs as (
select distinct 
s.activation_dt,
reg_cookie,
s.subscription_guid 
from ent_vw.subscription_slam_attribution_fct att join
ent_vw.subscription_fct s  on att.subscription_guid = s.subscription_guid and att.activation_dt = s.activation_dt
where lower(slam_show_gp_nm) like '%seal%team%'
and s.activation_dt between '2021-10-11' and '2022-01-22'
and att.src_system_id = 115),

stage1_data_prep as (
select
  v69_registration_id_nbr,
  video_season_nbr,
  strm_start_event_dt_ht,
  rank() over(partition by v69_registration_id_nbr order by strm_start_event_dt_ht) rank1,
  --case when video_content_duration_sec_qty/length_in_seconds >= 0.95 then TRUE else false end as full_view
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` 
where
  video_full_episode_ind IS TRUE
  and report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca','cbsicbstve')
  and day_dt between '2021-10-11' and '2022-01-22'
  and video_start_cnt>0
  and v69_registration_id_nbr is not null
  and subscription_state_desc IN ("trial", "sub","discount offer")
  and   reporting_series_nm in ('SEAL Team')
  and v69_registration_id_nbr in (select distinct reg_cookie from seal_subs)
)

select
  video_season_nbr,
  count(distinct v69_registration_id_nbr) 
from
  stage1_data_prep 
where
  rank1=1
  --and full_view is TRUE
group by 1
order by 1
