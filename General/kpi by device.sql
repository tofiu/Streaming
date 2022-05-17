SELECT --day_dt,
       reporting_series_nm,
       device_platform_nm,
       count(DISTINCT v69_registration_id_nbr) AS subscribers,
       --sum(video_start_cnt) as streams, 
       --sum(video_total_time_sec_qty/3600) as hours
FROM dw_vw.aa_video_detail_reporting_day cs
WHERE v69_registration_id_nbr IS NOT NULL
	AND day_dt BETWEEN '2022-04-14' AND '2022-05-16'
	AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  and reporting_series_nm in ('Cecilia')
GROUP BY 1,	2
ORDER BY 3 desc
