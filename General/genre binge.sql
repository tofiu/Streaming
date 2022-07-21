with stage1 as
(
select
day_dt
,visit_session_id
,post_visitor_id
,v69_registration_id_nbr
,video_series_nm
, concat ('S',video_season_nbr,'E', video_episode_nbr) as episode
, case when ((case when video_content_duration_sec_qty <= 0 then .0001 else video_content_duration_sec_qty end)/
nullif(length_in_seconds, 0)) >=1
then 1
else safe_cast(((case when video_content_duration_sec_qty <= 0 then .0001 else video_content_duration_sec_qty end)/
nullif(length_in_seconds, 0)) as float64) end as completion_percent
from
dw_vw.aa_video_detail_reporting_day  a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.reporting_series_nm))=lower(trim(b.show))
where day_dt between "2022-01-01" and "2022-06-30"
and reporting_content_type_cd not in ('CLIP')
and LOWER(subscription_state_desc) IN ("trial","sub","discount offer")
AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
and genre in ('Reality')
),
stage2 as (
select
visit_session_id,
video_series_nm,
count(distinct episode) episodes_in_session
from
stage1
where completion_percent>=0.75
group by
1,2
),
stage3 as (
select
video_series_nm,
--case when episodes_in_session>=3 then 'binge' end binge_sessions,
--case when episodes_in_session>=6 then 'marathon' end marathon_sessions,
count(distinct visit_session_id) sessions
from
stage2
where
episodes_in_session>=1 --total
--episodes_in_session>=3 --binge
--episodes_in_session>=6 --marathon
group by
1
)
select * from stage3
order by sessions desc
