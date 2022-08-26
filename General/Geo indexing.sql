---- against US ---- 
With Viewers AS
(
SELECT
DISTINCT (v69_registration_id_nbr) AS subscribers,
FROM dw_vw.aa_video_detail_reporting_day cs
WHERE v69_registration_id_nbr IS NOT NULL
AND day_dt BETWEEN '2021-03-04' AND '2022-08-21'
AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
AND video_content_duration_sec_qty > 0
AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
AND lower(reporting_series_nm) like '%star%trek%'
ORDER BY 1
),
Active_HHs AS
(
SELECT
cbs_reg_user_id_cd,
postal_cd
FROM `i-dss-ent-data.dw_vw.registration_user_dim`
WHERE cbs_reg_user_id_cd IN
(
select
distinct cbs_reg_user_id_cd
FROM
`i-dss-ent-data.ent_vw.subscription_fct`
WHERE
src_system_id=115
AND ( expiration_dt IS NULL OR expiration_dt>current_date())
)
AND src_system_id=108
),
State AS
(
SELECT
CASE
WHEN LENGTH(CAST(zip AS STRING)) = 5 THEN CAST(zip AS STRING)
WHEN LENGTH(CAST(zip AS STRING)) = 4 THEN CAST(CONCAT("0",zip) AS STRING)
WHEN LENGTH(CAST(zip AS STRING)) = 3 THEN CAST(CONCAT("00",zip) AS STRING)
ELSE CAST(zip AS STRING)
END AS Zipcode,
state AS State
FROM `i-dss-ent-data.et_pt.Zipcode_Database`
GROUP BY 1,2
),
Population AS
(
SELECT * FROM `i-dss-ent-data.et_pt.Us_Population_State_AJ`
),
Final AS
(
SELECT
c.State,
b.postal_cd,
COUNT(DISTINCT(a.Subscribers)) AS Active_HHs,
Population_2020 AS Population
FROM Viewers a
INNER JOIN Active_HHs b ON (a.subscribers = b.cbs_reg_user_id_cd)
LEFT JOIN State c ON (b.postal_cd=c.Zipcode)
LEFT JOIN Population d ON (lower(c.State)=d.State)
GROUP BY 1,2,4
ORDER BY 1,2
)

SELECT
State,
Population,
SUM(Active_HHs) AS Active_HHs
FROM
Final
WHERE Population IS NOT NULL
GROUP BY 1,2
ORDER BY 1


----- P+ ------


with
Viewers AS
(
SELECT  distinct v69_registration_id_nbr AS subscribers,
FROM ent_vw.aa_schedule_stream_detail_day
WHERE day_dt between "2021-03-04" and "2022-08-21"
ORDER BY 1
),

Active_HHs AS
(
SELECT
cbs_reg_user_id_cd,
postal_cd
FROM `i-dss-ent-data.dw_vw.registration_user_dim`
WHERE cbs_reg_user_id_cd IN
(
select
distinct cbs_reg_user_id_cd
FROM
`i-dss-ent-data.ent_vw.subscription_fct`
WHERE
src_system_id=115
AND ( expiration_dt IS NULL OR expiration_dt>current_date())
)
AND src_system_id=108
),
State AS
(
SELECT
CASE
WHEN LENGTH(CAST(zip AS STRING)) = 5 THEN CAST(zip AS STRING)
WHEN LENGTH(CAST(zip AS STRING)) = 4 THEN CAST(CONCAT("0",zip) AS STRING)
WHEN LENGTH(CAST(zip AS STRING)) = 3 THEN CAST(CONCAT("00",zip) AS STRING)
ELSE CAST(zip AS STRING)
END AS Zipcode,
state AS State
FROM `i-dss-ent-data.et_pt.Zipcode_Database`
GROUP BY 1,2
),
Population AS
(
SELECT * FROM `i-dss-ent-data.et_pt.Us_Population_State_AJ`
),
Final AS
(
SELECT
c.State,
b.postal_cd,
COUNT(DISTINCT(a.Subscribers)) AS Active_HHs,
Population_2020 AS Population
FROM Viewers a
INNER JOIN Active_HHs b ON (a.subscribers = b.cbs_reg_user_id_cd)
LEFT JOIN State c ON (b.postal_cd=c.Zipcode)
LEFT JOIN Population d ON (lower(c.State)=d.State)
GROUP BY 1,2,4
ORDER BY 1,2
)

SELECT
State,
Population,
SUM(Active_HHs) AS Active_HHs
FROM
Final
WHERE Population IS NOT NULL
GROUP BY 1,2
ORDER BY 1
