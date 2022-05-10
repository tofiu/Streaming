with stage1 as (
select
    video_series_nm,
  video_season_nbr,
  v69_registration_id_nbr  ,
  count(distinct CONCAT(video_season_nbr,video_title)) eps
FROM
    `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
  WHERE
    day_dt BETWEEN '2021-06-17' and '2022-04-02'
    AND reporting_series_nm = "iCarly"
    and video_season_nbr = '1'
    AND video_full_episode_ind = TRUE
    AND v69_registration_id_nbr IS NOT NULL
    AND report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  GROUP BY
    1,2,3),

icarly as (
  select v69_registration_id_nbr
from stage1 
where eps =1
),

demo AS(
  select
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
    cast(reg_user_id AS string) in (select v69_registration_id_nbr from icarly))

select 
--avg(age) from demo where age between 18 and 100 
--Age_group, count(distinct v69_registration_id_nbr) from demo where age between 18 and 100 group by 1
gender, count(distinct v69_registration_id_nbr) from demo group by 1
