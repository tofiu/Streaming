  /*
Author - Tiffany Liu
Aim: originals FEP summarized table for episodic completion
*/
DECLARE
  last_15_days INT64;
SET
  last_15_days = 15;


-- CREATE OR REPLACE TABLE
--   ent_summary.originals_completion
-- PARTITION BY
--   day_dt AS
  DELETE FROM ent_summary.originals_completion WHERE day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY));
  INSERT INTO `ent_summary.originals_completion`


SELECT
  a.source_desc,
  a.v69_registration_id_nbr,
  a.reporting_series_nm,
  CASE
    WHEN (a.reporting_series_nm="The Chi" AND a.video_season_nbr="6" AND day_dt<"2024-05-10"  AND a.video_episode_nbr IN ("1", "2", "3", "4", "5", "6", "7", "8") ) THEN "6.1" --Distinguish the difference between The Chi 6.1 and 6.2
    WHEN (a.reporting_series_nm="The Chi"
    AND a.video_season_nbr="6"
    AND a.day_dt>="2024-05-10" and a.video_episode_nbr IN ("9", "10","11","12","13","14","15","16") ) THEN "6.2" --Distinguish the difference between The Chi 6.1 and 6.2
    WHEN (a.reporting_series_nm="Couples Therapy" AND a.video_season_nbr="4" AND a.day_dt<"2025-05-23" AND a.video_episode_nbr IN ("1", "2", "3", "4", "5", "6", "7", "8", "9")) THEN "4.1" --Distinguish the difference between Couples Therapy 4.1 and 4.2
    WHEN (a.reporting_series_nm="Couples Therapy"
    AND a.video_season_nbr="4"
    AND a.day_dt>="2025-05-23"
    AND a.video_episode_nbr IN ("10","11","12","13","14","15","16","17","18")) THEN "4.2" --Distinguish the difference between Couples Therapy 4.1 and 4.2
    ELSE a.video_season_nbr
END
  AS video_season_nbr,
  # Saving it in a different column so original video_season_nbr column stays preserved for later use
  a.video_episode_nbr,
  a.v31_mpx_reference_guid,
  a.reporting_content_type_cd,
  b.season_level_title,
  b.genre,
  case
    when a.reporting_series_nm = "Blaze and the Monster Machines: Super Wheels" then 'DTC Movies'
    else b.release_strategy
  end as release_strategy,
  b.episodes_at_premiere,
  b.total_episodes,
  b.premeire_dt,
  b.original_ind, --(JZ) 8/12/25 added
  a.day_dt,
  a.video_title_nm,-- (JZ) 7/18/25 Added
  a.video_air_dt,--(JZ) 7/23/25 Added
  CASE
    WHEN (UPPER(a.subscription_package_desc) LIKE '%CF%' OR UPPER(a.subscription_package_desc) LIKE '%PREMIUM%') THEN 'Ad-Free Plan'
    WHEN a.subscription_package_desc IS NULL AND (LOWER(a.source_desc) LIKE '%apple%channel%' or LOWER(a.source_desc) LIKE '%hulu%') THEN 'Ad-Free Plan'
    WHEN a.subscription_package_desc IS NULL THEN 'Unknown'
    WHEN lower(a.subscription_package_desc) IN ('unknown', '-','undefined','undefined-sho','-sho') THEN 'Unknown'
    ELSE 'Ad-Supported Plan'
  END as plan_type, -- (JZ) 7/21/25 Added, 8/12 UPDATED
  a.subscription_package_desc, -- (JZ) 7/21/25 Added
  TRUNC((DATE_DIFF(a.day_dt, b.premeire_dt, day)+1)/7) AS Week,
  TRUNC((DATE_DIFF(a.day_dt, b.premeire_dt, day)+1)/30) AS Month,
  date_diff(a.day_dt, b.premeire_dt, day)+1 as Days_Diff, -- (JZ) 7/18/25 Added
  sum(a.stream_min_cnt) as streamed_mins, -- (JZ) 7/18/25 Added
  max(mpx.length_in_seconds/60.0) video_length_mins -- (JZ) 7/18/25 Added
FROM
  `ent_vw.pplus_originals_content_detail_day` a
-- (JZ) 7/18/25 Added to pull in video_length
LEFT JOIN
  `ent_vw.mpx_video_content_enhanced` mpx
ON
  mpx.mpx_reference_guid = a.v31_mpx_reference_guid
---
JOIN
  `i-dss-ent-data.ent_summary.pplus_original_premiere_date` b
ON
  LOWER(a.reporting_series_nm) = LOWER(b.title)
  AND (CASE
      WHEN a.reporting_content_type_cd = "MOVIE" THEN "1"
 WHEN (a.reporting_series_nm="The Chi" AND a.video_season_nbr="6" AND day_dt<"2024-05-10"  AND a.video_episode_nbr IN ("1", "2", "3", "4", "5", "6", "7", "8") ) THEN "6.1" --Distinguish the difference between The Chi 6.1 and 6.2
    WHEN (a.reporting_series_nm="The Chi"
    AND a.video_season_nbr="6"
    AND a.day_dt>="2024-05-10" and a.video_episode_nbr IN ("9", "10","11","12","13","14","15","16") ) THEN "6.2" --Distinguish the difference between The Chi 6.1 and 6.2
    WHEN (a.reporting_series_nm="Couples Therapy" AND a.video_season_nbr="4" AND a.day_dt<"2025-05-23" AND a.video_episode_nbr IN ("1", "2", "3", "4", "5", "6", "7", "8", "9")) THEN "4.1" --Distinguish the difference between Couples Therapy 4.1 and 4.2
    WHEN (a.reporting_series_nm="Couples Therapy"
    AND a.video_season_nbr="4"
    AND a.day_dt>="2025-05-23"
    AND a.video_episode_nbr IN ("10","11","12","13","14","15","16","17","18")) THEN "4.2" --Distinguish the difference between Couples Therapy 4.1 and 4.2
      ELSE a.video_season_nbr
  END) = b.season_nbr
  AND a.day_dt >= b.premeire_dt
  AND a.day_dt <= DATE_ADD(b.premeire_dt, INTERVAL 89 day)
WHERE
  a.src_system_id = 115
  AND a.reporting_content_type_cd IN ("FEP","MOVIE") -- (JZ) 7/18/25 Added Movies
  AND a.day_dt >= (DATE_SUB(CURRENT_DATE, INTERVAL last_15_days DAY))
  AND a.subscription_state_desc IN ("sub","trial","discount offer")
  AND (a.source_desc <> "Hulu" OR a.day_dt >= "2024-01-01")
  AND (a.video_episode_nbr IS NULL OR a.video_episode_nbr <> '0') --(JZ) 7/23/25 added for data quality
  AND (
  TRIM(LOWER(a.reporting_series_nm)) IN ('couples therapy', 'the chi')
  OR (
    a.video_episode_nbr IS NULL
    OR SAFE_CAST(a.video_episode_nbr AS INT64) <= SAFE_CAST(b.total_episodes AS INT64)
    )
  )  --(JZ) 8/6/25 added for data quality
GROUP BY ALL
