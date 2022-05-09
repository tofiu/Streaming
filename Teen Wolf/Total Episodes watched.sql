with stage1 as (
select
    video_series_nm,
 -- video_season_nbr,
  v69_registration_id_nbr  ,
  count(distinct CONCAT(video_title)) eps
FROM
    `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
  WHERE
    day_dt BETWEEN '2021-12-19' and '2022-05-06'
    AND reporting_series_nm = "Teen Wolf"
 --   and video_season_nbr = '7'
    AND video_full_episode_ind = TRUE
    AND v69_registration_id_nbr IS NOT NULL
    AND report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  GROUP BY
    1,2)
select 
  video_series_nm,
--  video_season_nbr,
eps,
  count(distinct v69_registration_id_nbr) users
from 
  stage1 
group by 
  1,2
