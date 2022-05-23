with demo AS(
  select
  cohort,
  u.v69_registration_id_nbr,
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
    dw_vw.aa_video_detail_reporting_day u
  left join ent_summary.Franchise_Categorization f on lower(trim(u.reporting_series_nm))=lower(trim(f.title))
  LEFT OUTER JOIN
    dw_vw.registration_user_dim ru
  ON
    (
        v69_registration_id_nbr = CAST(ru.reg_user_id AS string)
        and src_system_id=108
    )
  where day_dt between '2021-03-04' and '2022-04-30'
        and report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca','cbsicbstve')

)

select 
cohort,
avg(age) as age,
--count(distinct case when gender = 'F' then v69_registration_id_nbr end)/count(distinct v69_registration_id_nbr) as female,
--count(distinct case when gender = 'M' then v69_registration_id_nbr end)/count(distinct v69_registration_id_nbr) as male
from demo 
where age between 18 and 100 
group by 1
