with stage1 as(
select
  distinct cs.v69_registration_id_nbr 
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
where
  cs.day_dt between '2022-03-24' and '2022-04-24'
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  and reporting_series_nm= 'Halo'
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
  and s.activation_dt <=  '2022-04-24'
),

-- getting the NEW vs EXISTING SUB HHS based on the premiere date

stage3 as (
select
  case when s.activation_dt>='2022-03-24' then 'New Sub HHs' else 'Existing Sub HHs' end as type,
  s.*
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

stage3_counts as (
select
  type,
  COUNT(distinct cbs_reg_user_id_cd) regs,
  COUNT(distinct subscription_guid) guids
from
  stage3
group by 1
order by 1
)

, stage9_streaming_details_part_1 as (
select
  type,
  v69_registration_id_nbr,
  COUNT(distinct CASE when cs.reporting_series_nm in ('Paramount+ Movies','CBS All Access Movies') then video_title else reporting_series_nm end) number_of_titles,
  SUM(cs.video_start_cnt) streams,
  SUM(cs.video_total_time_sec_qty)/60 minutes_watched,
  COUNT(distinct cs.v31_mpx_reference_guid) number_of_videos,
  COUNT(distinct cs.day_dt) number_of_days
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
join
  stage3 s
on
  cs.v69_registration_id_nbr = s.cbs_reg_user_id_cd
where
  cs.day_dt between '2022-03-24' and '2022-04-24'                  -- change the dates here
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
group by 1,2
),

stage10_straming_details_final_2 as (
select
  type,
  case when number_of_titles>5 then '5+' else cast(number_of_titles as string) end as number_of_titles,
  count(distinct v69_registration_id_nbr) sub_hhs
from
  stage9_streaming_details_part_1
group by 1,2
order by 1,2
)



select * from stage10_straming_details_final_2
