with eps_watched as 
(select distinct v69,
date_trunc(day_dt, month) mn,
  reporting_series_nm,
  video_season_nbr, 
  count(distinct concat(video_season_nbr,video_title)) eps
FROM
   ent_summary.fd_house_of_brands
  WHERE
    day_dt BETWEEN '2021-03-01' and '2022-04-30'
    AND video_full_episode_ind = TRUE
    and reporting_content_type_cd not in ('CLIP')
    AND v69 IS NOT NULL
    AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
    AND source_desc = 'O&O Platforms'
    and brand_nm1 = 'P+ Originals'
  GROUP BY
    1,2,3,4)

select 
mn,
--reporting_series_nm,
  count(distinct v69) as count_sub_hhs
from eps_watched 
where eps >= 8
group by 1
order by 1
