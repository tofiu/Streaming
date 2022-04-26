with stage1 as(
select
  distinct cs.v69_registration_id_nbr 
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
where
  cs.day_dt between '2022-03-24' and '2022-04-24'
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  and reporting_series_nm='Halo'
),

stage2 as (
select count(distinct v69_registration_id_nbr) from stage1
),


-- ranking Sub fct table based on activation date in order to take the LAST subscription of the Subscriber HHs
stage3_ranking_sub_fct as (
select
  *,
  RANK() OVER(partition by s.cbs_reg_user_id_cd order by s.activation_dt_ut desc) rank1
from
  `i-dss-ent-data.ent_vw.subscription_fct` s
where
  s.src_system_id =115
),

-- getting the NEW vs EXISTING SUB HHS based on the premiere date

stage3 as (
select
  case when s.activation_dt>='2022-03-24' then 'New Sub HHs' else 'Existing Sub HHs' end as type,
  cbs_reg_user_id_cd,
  subscription_guid
from
  stage3_ranking_sub_fct s
join
  stage1 s1
on
  s.cbs_reg_user_id_cd = s1.v69_registration_id_nbr 
where
  s.src_system_id =115
  and rank1=1 
),

stage4_existing_sub_hh as (
select
  distinct 
  type,
  att.slam_show_gp_nm ,
  cbs_reg_user_id_cd
from
 ent_vw.subscription_slam_attribution_fct att 
join
  stage3 s  
on 
  att.subscription_guid = s.subscription_guid
where
  type='Existing Sub HHs'
),

stage5_attachment_rate as (
select
  type,
  video_series_nm,
  video_season_nbr,
  cs.v69_registration_id_nbr,
  SUM(cs.video_total_time_sec_qty)/60 minutes_watched,
  count(distinct CONCAT(video_season_nbr,video_episode_nbr)) eps
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
join
  stage4_existing_sub_hh s4
on
  cs.v69_registration_id_nbr  = s4.cbs_reg_user_id_cd
  and cs.video_series_nm = s4.slam_show_gp_nm
where
  cs.day_dt between '2022-03-24' and '2022-04-24'
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  and type='Existing Sub HHs'
group by 1,2,3,4
)

, stage6_attachment_rate_final as (
select
 type,
 video_series_nm,
 count(distinct case when eps>1 then v69_registration_id_nbr else null end) attached_sub_hhs,
 COUNT(distinct v69_registration_id_nbr) sub_hhs
from 
  stage5_attachment_rate
group by 1,2
order by 3 desc
)

select * from stage6_attachment_rate_final
