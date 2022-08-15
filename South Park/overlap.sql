with still_active as (select distinct
slam_show_gp_nm,
att.reg_cookie,
att.subscription_guid 
from ent_vw.subscription_slam_attribution_fct att join `i-dss-ent-data.ent_vw.subscription_fct` b on att.subscription_guid=b.subscription_guid
where att.src_system_id=115
and att.activation_dt <= '2022-06-05' 
and slam_show_gp_nm in ("SOUTH PARK: POST COVID","SOUTH PARK: POST COVID: THE RETURN OF COVID")
and (b.expiration_dt is null or b.expiration_dt >= current_date())
group by 1,2,3)

select 
count(distinct cs.v69_registration_id_nbr) active_sub
FROM dw_vw.aa_video_detail_reporting_day cs
WHERE cs.v69_registration_id_nbr IS NOT NULL
  AND v69_registration_id_nbr in (select distinct reg_cookie from still_active)
	AND day_dt between '2022-06-01' and '2022-07-10'
	AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
	AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  and reporting_series_nm = "SOUTH PARK THE STREAMING WARS"
