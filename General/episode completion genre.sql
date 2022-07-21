with stage1 as (
select
    reporting_series_nm,
  v69 ,
  count(distinct CONCAT(video_season_nbr,video_title)) eps
FROM
    ent_summary.fd_house_of_brands a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.reporting_series_nm))=lower(trim(b.show))
    
WHERE
    day_dt BETWEEN '2022-01-01' and '2022-06-30'
    AND video_full_episode_ind = TRUE
    AND v69 IS NOT NULL
    and genre in ('Reality')
    and LOWER(subscription_state_desc) IN ("trial","sub","discount offer")
    and reporting_series_nm not in ("Live TV","Live Local TV")
    and reporting_content_type_cd not in ('CLIP')
  GROUP BY
    1,2)
select 
  reporting_series_nm,
  eps,
  count(distinct v69) users
from 
  stage1 
group by 
  1,2
