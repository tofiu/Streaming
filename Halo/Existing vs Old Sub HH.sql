with stage1 as(
select
  distinct  cs.v69_registration_id_nbr 
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` cs
where
  cs.day_dt between '2022-03-24' and '2022-04-24'      -- change the date
  and subscription_state_desc in ('sub','trial')
  and report_suite_id_nm NOT IN ('cbsicbstve','cbsicbsca','cbsicbsau')
  and reporting_series_nm='Halo'     -- change the show name
),

stage2 as (
select count(distinct v69_registration_id_nbr) from stage1             --total who watched the show
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
  and s.activation_dt <= '2022-04-24'            -- change the end date
),

-- getting the NEW vs EXISTING SUB HHS based on the premiere date

stage3 as (
select
  case when s.activation_dt>= '2022-03-24'  then 'New Sub HHs' else 'Existing Sub HHs' end as type,         -- change the dates
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

select * from stage3_counts
