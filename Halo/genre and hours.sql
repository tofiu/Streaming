with stage0 as 
(
select day_dt, 
       case when video_title = "CBS News Hub" then "CBS News Hub" else reporting_series_nm end as reporting_series_nm, 
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       length_in_seconds, 
       video_total_time_sec_qty, 
       case when genre is null then 'Others' else genre end as genre
from (
       select case when reporting_series_nm in ("Paramount+ Movies","CBS All Access Movies") then replace(replace(video_title," (Trailer)",""),"Paramount+ Movies - ","")
                  when reporting_series_nm in ("Paramount+ Trailers") then replace(video_title," (Trailer)","")
                  when video_title = "CBS News Hub" then video_title
                  else reporting_series_nm end as show_name,*
       FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` 
       where day_dt between "2022-03-24" and "2022-04-20"
             and v69_registration_id_nbr IS NOT NULL
	     AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	     AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
     )  
     a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.show_name))=lower(trim(b.show))

union all 

select day_dt, 
       show_nm, 
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       show_length_sec_qty, 
       window_stream_sec_qty, 
       case when genre_new is null then 'Others' else genre_new end as genre
from (
select *, case when lower(show_nm) like "%news%" then 'News' else genre end genre_new
FROM `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day` a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_local_stations` b on lower(trim(a.show_nm))=lower(trim(b.show))
where day_dt between "2022-03-24" and "2022-04-20"
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
      and LOWER(subscription_state_desc) IN ("trial","sub","discount offer"))
)
                         
select --date_trunc(day_dt, month) as month,
       case when genre in ("Kids & Family","Reality","Comedy","Drama","Crime","Horror","Sports","Thriller","News","Sci-fi") then genre else 'Others' end as genre,
       count(distinct v69_registration_id_nbr) as sub_hh,
       sum(video_total_time_sec_qty/3600) as hours
from stage0
group by 1
order by 2
