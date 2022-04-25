select
  case when reporting_series_nm in ("Paramount+ Movies","CBS All Access Movies") then replace(replace(video_title," (Trailer)",""),"Paramount+ Movies - ","")
                  when reporting_series_nm in ("Paramount+ Trailers") then replace(video_title," (Trailer)","")
                  when video_title = "CBS News Hub" then video_title
                  else reporting_series_nm end as show_name,
                  --case when genre is null then 'Others' else genre end as genre,
  --video_season_nbr,
  --v31_mpx_reference_guid,
  --video_title,
  --video_air_dt_ht, 
  --MAX(day_dt),
  -- title 
  count(distinct v69_registration_id_nbr),
  --MIN(day_dt) prem_date
from
  `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`  a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.reporting_series_nm))=lower(trim(b.show))
where  
day_dt BETWEEN '2022-01-01' AND '2022-04-20'
and day_dt between video_air_dt_ht and (DATE_ADD(video_air_dt_ht, INTERVAL 9 DAY))
             and v69_registration_id_nbr IS NOT NULL
             and reporting_content_type_cd not in ('CLIP')
       AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
      --and date_diff(day_dt, video_air_dt_ht, day) = 9
and lower(video_title) like '%slime%cut%'
--and lower(genre) like '%specials%'
group by 1
