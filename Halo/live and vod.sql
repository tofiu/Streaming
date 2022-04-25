select 
--show_nm,
count(distinct v69_registration_id_nbr) as sub_hhs
from (
(SELECT 
distinct v69_registration_id_nbr,
--show_nm
FROM ent_vw.aa_schedule_stream_detail_day  a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_local_stations` b on lower(trim(a.show_nm))=lower(trim(b.show))
WHERE day_dt BETWEEN "2022-03-24" and "2022-04-20"
  AND lower (report_suite_id_nm) in ('cnetcbscomsite')
ANd v69_registration_id_nbr IS NOT NULL
--  AND stream_cnt > 0
--  AND Window_Stream_Sec_Qty > 0
  AND lower(subscription_state_desc) IN ("trial", "sub", "discount offer")
) 
union all
(
SELECT
distinct v69_registration_id_nbr,
--reporting_series_nm
FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day`
where day_dt BETWEEN "2022-03-24" and "2022-04-20"
ANd v69_registration_id_nbr IS NOT NULL
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")))

--group by 1
