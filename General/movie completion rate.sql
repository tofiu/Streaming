select case when completion < 0.25 then "<25%"
            when completion >= 0.25 and completion <0.5 then "25%-50%"
            when completion >= 0.5 and completion <0.75 then "50%-75%"
            when completion >= 0.75 and completion < 0.95 then "75%-95%"
            when completion >= 0.95 then ">95%" end completion,
        count(distinct v69_registration_id_nbr) active_sub
from (

select v69_registration_id_nbr,
       avg(completion) completion
from 

(
SELECT v69_registration_id_nbr,
       video_total_time_sec_qty/length_in_seconds as completion
FROM dw_vw.aa_video_detail_reporting_day cs
WHERE v69_registration_id_nbr IS NOT NULL
	AND day_dt BETWEEN '2021-11-26' AND '2021-12-06'
	AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
    and reporting_series_nm = 'A Loud House Christmas'
)

group by 1)

group by 1
order by 1
