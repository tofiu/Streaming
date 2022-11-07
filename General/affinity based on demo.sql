with demo AS(
select 
v69_registration_id_nbr regid
FROM (select
  u.v69_registration_id_nbr,
    (EXTRACT(YEAR FROM CURRENT_DATE()) - CAST(birth_year_nbr AS INT64)) AS age,
      CASE
        WHEN (extract(YEAR FROM CURRENT_DATE()) - safe_cast(birth_year_nbr AS int64))
          <25
        THEN "<25"   
END AS Age_group
  from
    `dw_vw.aa_video_detail_reporting_day` u
  LEFT OUTER JOIN
    dw_vw.registration_user_dim ru
  ON
    (
        v69_registration_id_nbr = CAST(ru.reg_user_id AS string)
        and src_system_id=108
    )
  where
    video_full_episode_ind IS TRUE
    and day_dt between '2021-10-11' and '2021-11-14'
    and report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca','cbsicbstve')
)
where Age_group = "<25"),

stage0 as (
select day_dt, 
       case when video_title = "CBS News Hub" then "CBS News Hub" else reporting_series_nm end as reporting_series_nm, 
       video_title,
       v31_mpx_reference_guid,
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       length_in_seconds, 
       video_content_duration_sec_qty, 
       case when genre is null then 'Others' else genre end as genre
from (
       select case when reporting_series_nm in ("Paramount+ Movies","CBS All Access Movies") then replace(replace(video_title," (Trailer)",""),"Paramount+ Movies - ","")
                  when reporting_series_nm in ("Paramount+ Trailers") then replace(video_title," (Trailer)","")
                  when video_title = "CBS News Hub" then video_title
                  else reporting_series_nm end as show_name,*
       FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` 
       where day_dt between '2021-10-11' and '2021-11-14'
             and v69_registration_id_nbr IS NOT NULL
             and reporting_content_type_cd not in ('CLIP')
       AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
     )  
     a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.show_name))=lower(trim(b.show))

union all 

select day_dt, 
       show_nm, 
       episode_title_nm,
       v31_mpx_reference_guid,
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       show_length_sec_qty, 
       window_stream_sec_qty, 
       case when genre_new is null then 'Others' else genre_new end as genre
from (
select *, case when lower(show_nm) like "%news%" then 'News' else genre end genre_new
FROM `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day` a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_local_stations` b on lower(trim(a.show_nm))=lower(trim(b.show))
where day_dt between '2021-10-11' and '2021-11-14'
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
      and LOWER(subscription_state_desc) IN ("trial","sub","discount offer"))
),
stage2 as (
select 
  s1.*, 
  s2.genre as secondary_genre,
  s2. reporting_series_nm as secondary_series,
-- s2.video_acquisition_partner_Cd secondary_brand
from 
  stage0 s1, stage0  s2
where 
  s1.v69_registration_id_nbr = s2.v69_registration_id_nbr
  and s1.reporting_series_nm <> s2.reporting_series_nm
)
  
Select DISTINCT

  --reporting_series_nm,
  secondary_genre,
  --secondary_series,
 
  count(distinct v69_registration_id_nbr) regs,

from 
  stage2
 WHERE v69_registration_id_nbr in (select distinct regid from demo)
  
group by
  1
  order by regs desc--,secondary_series
  --limit 50
