with complimentory_users as (
  select
    distinct cast(cbs_reg_user_id_cd as string) as regid
  from
    `i-dss-ent-data.ent_vw.cbs_aa_sub_platform_package_dim`
  where
    lower(source_desc)='cbscomp'
    and cbs_reg_user_id_cd is not null
),
user_info as (
select
      cbs_reg_user_id_cd as regid,
      case
        when expiration_dt is NULL or expiration_dt >= '2022-05-24'  
        then 'Active' 
        else 'Inactive'
      end active_status,
      activation_dt,
      trial_start_dt,
      case
        when trial_start_dt is null
        then null
        when (
          paid_start_dt is null
          and expiration_dt is not null
        )
        then expiration_dt
        else paid_start_dt
      end as trial_end_dt,
      paid_start_dt,
      cancel_dt,
      expiration_dt,
    from
      `i-dss-ent-data.ent_vw.subscription_fct` subs
    where
      cbs_reg_user_id_cd is not null
      and cbs_reg_user_id_cd not in (select regid from complimentory_users)
      and src_system_id = 115
      and activation_dt <= '2022-01-22'
      --and (activation_dt <= '2021-09-09' or trial_start_dt <= '2021-09-09')
  ),


nfl_viewers as (
  select distinct
    regid,
  from
  (
      select distinct
        v69_registration_id_nbr as regid,
      from
        `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
      where
        day_dt between '2021-09-09' and '2022-01-22'
        and reporting_series_nm like '%NFL%'
        and v69_registration_id_nbr is not null
        AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
        AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  UNION ALL 
      select distinct 
        v69_registration_id_nbr as regid, 
      from `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day`
      where day_dt between '2021-09-09' and '2022-01-22'
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
      and LOWER(subscription_state_desc) IN ("trial","sub","discount offer")
      and show_nm like '%NFL%'
  )
),

user_status as (
select distinct 
case when regid in (select regid from user_info where active_status = 'Active') then 'Active'
when regid in (select regid from user_info where active_status = 'Inactive') then 'Inactive' end sub_status,
regid

from nfl_viewers
)

select distinct 
sub_status, 
count(distinct regid) 
from user_status
group by 1

---------------


select count(distinct regid) from 
(select distinct
        v69_registration_id_nbr as regid,
      from
        `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
      where
        day_dt between '2021-09-09' and '2022-01-22'
        and reporting_series_nm like '%NFL%'
        and v69_registration_id_nbr is not null
        AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
        AND LOWER(subscription_state_desc) IN ( "sub", "discount offer")
  UNION ALL 
      select distinct 
        v69_registration_id_nbr as regid, 
      from `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day`
      where day_dt between '2021-09-09' and '2022-01-22'
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
      and LOWER(subscription_state_desc) IN ("sub","discount offer")
      and show_nm like '%NFL%')
