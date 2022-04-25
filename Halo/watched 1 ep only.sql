with halo1 as (

select distinct(v69_registration_id_nbr) from 
(
select
    video_series_nm,
  v69_registration_id_nbr  ,
  count(distinct CONCAT(video_season_nbr,video_title)) eps
FROM
    `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
  WHERE
    day_dt BETWEEN '2022-03-24' and '2022-04-20'
    AND reporting_series_nm = "Halo"
    AND video_full_episode_ind = TRUE
    and reporting_content_type_cd not in ('CLIP')
    AND v69_registration_id_nbr IS NOT NULL
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
    AND report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  GROUP BY
    1,2) where eps = 1
)

select
reporting_series_nm, 
count(distinct a.v69_registration_id_nbr) 
FROM
    `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` a join halo1 b on a.v69_registration_id_nbr = b.v69_registration_id_nbr
  WHERE
    day_dt BETWEEN '2022-03-24' and '2022-04-20'
    AND video_full_episode_ind = TRUE
    and reporting_content_type_cd not in ('CLIP')
    AND a.v69_registration_id_nbr IS NOT NULL
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
    AND report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
group by 1
order by 2 desc
limit 50
© 2022 GitHub, Inc.
Terms
