with demo AS(
  select
  distinct
    v69,
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
FROM ent_summary.fd_house_of_brands 
LEFT OUTER JOIN
    dw_vw.registration_user_dim ru
  ON
    (
        v69 = CAST(ru.reg_user_id AS string)
        and src_system_id=108
    )
where v69 in (select distinct user_id from `i-dss-ent-data.temp_mk.around_the_globe_carousel_clicks`)
and day_dt between '2021-10-19' and '2022-05-18' 
and source_desc = 'O&O Platforms'
AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer"))

select avg(age) from demo where age between 18 and 100
--select gender, count(distinct v69) from demo group by 1
