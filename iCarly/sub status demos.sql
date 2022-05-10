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
        when expiration_dt is NOT NULL or expiration_dt >='2022-04-02'  
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
        v69_registration_id_nbr as regid,
      from
        `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
      where
        day_dt between '2021-06-17' and '2022-04-02'
        and reporting_series_nm like '%iCarly%'
        and reporting_content_type_cd = 'FEP'
        and video_season_nbr = '1'
        and v69_registration_id_nbr is not null
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
demo as ( select
  CAST(reg_user_id as string) v69_registration_id_nbr,
      CASE
        WHEN LOWER(gender_cd) LIKE 'f%'
        OR  LOWER(gender_cd) = 'girls'
        THEN 'F'
        WHEN LOWER(gender_cd) LIKE 'm%'
        OR  LOWER(gender_cd) = 'boys'
        THEN 'M'
        ELSE 'NA'
    END AS gender,
    (EXTRACT(YEAR FROM CURRENT_DATE()) - CAST(birth_year_nbr AS INT64)) AS age,
      CASE
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          <18 
        THEN "17"
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          BETWEEN 18 AND 24
        THEN "18-24"
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          BETWEEN 25 AND 34
        THEN "25-34"
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          BETWEEN 35 AND 44
        THEN "35-44"
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          BETWEEN 45 AND 54
        THEN "45-54"
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          BETWEEN 55 AND 100
        THEN "55+"      
END AS Age_group
  from
    dw_vw.registration_user_dim ru
where
  CAST(reg_user_id as string) in (select regid from inactive_subs)
)

select 
avg(age) from demo where age between 18 and 100 
--Age_group, count(distinct v69_registration_id_nbr) from demo where age between 18 and 100 group by 1
--gender, count(distinct v69_registration_id_nbr) from demo group by 1
  

