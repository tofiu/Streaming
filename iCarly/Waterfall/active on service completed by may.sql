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
        when expiration_dt is NOT NULL or expiration_dt >'2022-05-05'  -- '2021-09-01' '2021-06-17'
        then 'Inactive' 
        else 'Active'
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
      -- and activation_dt between '2021-06-17' and '2021-12-17'
      and activation_dt < '2021-09-01'
  ),


icarly_viewers_s1 as (
  select
    regid,
  from
  (
    select
      regid,
      reporting_series_nm,
      video_season_nbr,
      video_episode_nbr,
      length_in_seconds,
      sum(seconds) as total_seconds,
      round(
        case
          when length_in_seconds > 0
          then sum(seconds) / length_in_seconds
          else 0
        end,
        2
      ) as cmp_percent
    from
    (
      select
        v69_registration_id_nbr as regid,
        reporting_series_nm,
        video_season_nbr,
        video_episode_nbr,
        video_content_duration_sec_qty as seconds,
        length_in_seconds,
      from
        `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
      where
        day_dt between '2021-06-17' and '2021-09-01'
        and reporting_series_nm like '%iCarly%'
        and reporting_content_type_cd = 'FEP'
        and video_season_nbr = '1'
        and v69_registration_id_nbr is not null
    )
    group by
      1, 2, 3, 4, 5
  )
),

active_users as (
  select
    regid
  from
 icarly_viewers_s1
  where
   regid in (
    select
      regid
    from
      user_info
    where
      active_status = 'Active')
),
inactive_subs as(
  select 
  distinct 
  regid,
from
  icarly_viewers_s1
where
  regid in (
    select
      regid
    from
      user_info
    where
      active_status = 'Inactive' --Active
  )),
icarly_viewers_s2 as (
  select
    regid,
    eps
  from
  (
    select
    reporting_series_nm,
  video_season_nbr,
 regid ,
  count(distinct CONCAT(video_season_nbr,video_title)) eps
    from
    (
      select
        v69_registration_id_nbr as regid,
        reporting_series_nm,
        video_season_nbr,
        video_title,
        --video_episode_nbr,
        video_content_duration_sec_qty as seconds,
        length_in_seconds,
      from
        `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
      where
        day_dt between '2021-06-17' and '2022-05-05'
        and reporting_series_nm like '%iCarly%'
        and reporting_content_type_cd = 'FEP'
        and video_season_nbr = '1'
        and v69_registration_id_nbr is not null
    )
    group by
      1, 2, 3
  )
)

select count(distinct regid)
from icarly_viewers_s2 
where regid in (select regid from active_users)
and eps = 13
