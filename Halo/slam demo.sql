SELECT
 -- att_gp,
  gender_cd,
  --Age_group,
  COUNT(DISTINCT reg_user_id) Starts,
  --AVG(t_Age) Avg_age
FROM
  (
    SELECT
   --att_gp,
      u.reg_user_id,
      CASE
        WHEN gender_cd = "M"
        THEN "Male"
        WHEN gender_cd = "F"
        THEN "Female"
        ELSE "Other"
      END gender_cd,
      (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64)) AS t_age,
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
    FROM
      `i-dss-ent-data.dw_vw.registration_user_dim` u
    JOIN 
      (SELECT
              reg_cookie,
              --case when LOWER(slam_show_gp_nm) LIKE "%halo%" then "Halo" end att_gp
            FROM
              ent_vw.subscription_slam_attribution_fct att
            WHERE
              att.src_system_id=115
            AND att.activation_dt BETWEEN '2022-03-24' AND '2022-04-24'
            --AND (LOWER(slam_show_gp_nm) LIKE "%halo%") 
            )ua ---slam level user IDs
    ON
      (
        u.reg_user_id = CAST(ua.reg_cookie AS string)) )t
--WHERE t_age BETWEEN 18 AND 100
GROUP BY 1
