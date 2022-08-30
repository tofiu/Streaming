with stage1 as (
select reporting_series_nm,
       day_dt,
       v69_registration_id_nbr
  FROM `i-dss-ent-data.ent_vw.multi_channel_detail_day`
  where day_dt between "2022-07-06" and "2022-08-29"
  and reporting_series_nm = "The Challenge: USA"
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  and v69_registration_id_nbr is not null
    and src_system_id = 115
    and subscription_state_desc in ('sub','trial')
    and reporting_content_type_cd not in ("CLIP")
),

daily_active as (
SELECT 
    reporting_series_nm
    ,day_dt
    ,sum( sum(case when seqnum = 1 then 1 else 0 end)
        ) over (partition by reporting_series_nm order by day_dt) as cume_distinct_acc
FROM (
    SELECT 
        f.*
        ,row_number() over (partition by v69_registration_id_nbr, reporting_series_nm order by day_dt) as seqnum
    FROM stage1 f
) f
group by reporting_series_nm, day_dt
order by 2)

select * from daily_active
order by 1,2

