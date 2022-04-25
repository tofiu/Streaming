SELECT 
dma_nm,
COUNT(distinct v69_registration_id_nbr) users,
SUM(video_content_duration_sec_qty)/3600 streaming_hours,
SUM(video_start_cnt) streams,

from
`dw_vw.aa_video_detail_reporting_day` a
left join ent_vw.dma_affiliate_map d on a.geo_dma_cd = cast(d.dma_id as string)
where
video_full_episode_ind IS TRUE
and day_dt between '2022-03-24' and '2022-04-20'
             and v69_registration_id_nbr IS NOT NULL
             and reporting_content_type_cd not in ('CLIP')
       AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
and geo_country_cd = "usa"
and reporting_series_nm = 'Halo'
group by 1
order by 2 desc

-----------
   
SELECT 
CASE WHEN geo_region_cd = 'al' THEN 'Alabama'
WHEN geo_region_cd = 'ak' THEN 'Alaska'
WHEN geo_region_cd = 'az' THEN 'Arizona'
WHEN geo_region_cd = 'ar' THEN 'Arkansas'
WHEN geo_region_cd = 'ca' THEN 'California'
WHEN geo_region_cd = 'co' THEN 'Colorado'
WHEN geo_region_cd = 'ct' THEN 'Connecticut' 
WHEN geo_region_cd = 'de' THEN 'Delaware'  
WHEN geo_region_cd = 'dc' THEN 'District of Columbia'  
WHEN geo_region_cd = 'fl' THEN 'Florida' 
WHEN geo_region_cd = 'ga' THEN 'Georgia' 
WHEN geo_region_cd = 'hi' THEN 'Hawaii' 
WHEN geo_region_cd = 'id' THEN 'Idaho' 
WHEN geo_region_cd = 'il' THEN 'Illinois'  
WHEN geo_region_cd = 'in' THEN 'Indiana' 
WHEN geo_region_cd = 'ia' THEN 'Iowa' 
WHEN geo_region_cd = 'ks' THEN 'Kansas' 
WHEN geo_region_cd = 'ky' THEN 'Kentucky' 
WHEN geo_region_cd = 'la' THEN 'Louisiana'  
WHEN geo_region_cd = 'me' THEN 'Maine'  
WHEN geo_region_cd = 'md' THEN 'Maryland' 
WHEN geo_region_cd = 'ma' THEN 'Massachusetts' 
WHEN geo_region_cd = 'mi' THEN 'Michigan'  
WHEN geo_region_cd = 'mn' THEN 'Minnesota' 
WHEN geo_region_cd = 'ms' THEN 'Mississippi' 
WHEN geo_region_cd = 'mo' THEN 'Missouri'  
WHEN geo_region_cd = 'mt' THEN 'Montana' 
WHEN geo_region_cd = 'ne' THEN 'Nebraska' 
WHEN geo_region_cd = 'nv' THEN 'Nevada' 
WHEN geo_region_cd = 'nh' THEN 'New Hampshire' 
WHEN geo_region_cd = 'nj' THEN 'New Jersey'  
WHEN geo_region_cd = 'nm' THEN 'New Mexico'  
WHEN geo_region_cd = 'ny' THEN 'New York'  
WHEN geo_region_cd = 'nc' THEN 'North Carolina' 
WHEN geo_region_cd = 'nd' THEN 'North Dakota'
WHEN geo_region_cd = 'oh' THEN 'Ohio' 
WHEN geo_region_cd = 'ok' THEN 'Oklahoma' 
WHEN geo_region_cd = 'or' THEN 'Oregon' 
WHEN geo_region_cd = 'pa' THEN 'Pennsylvania' 
WHEN geo_region_cd = 'ri' THEN 'Rhode Island' 
WHEN geo_region_cd = 'sc' THEN 'South Carolina'
WHEN geo_region_cd = 'sd' THEN 'South Dakota'
WHEN geo_region_cd = 'tn' THEN 'Tennessee' 
WHEN geo_region_cd = 'tx' THEN 'Texas'
WHEN geo_region_cd = 'ut' THEN 'Utah' 
WHEN geo_region_cd = 'vt' THEN 'Vermont'
WHEN geo_region_cd = 'va' THEN 'Virginia' 
WHEN geo_region_cd = 'wa' THEN 'Washington'  
WHEN geo_region_cd = 'wv' THEN 'West Virginia' 
WHEN geo_region_cd = 'wi' THEN 'Wisconsin'  
WHEN geo_region_cd = 'wy' THEN 'Wyoming' 
else null end geo_region_cd, 
COUNT(distinct v69_registration_id_nbr) users,
SUM(video_content_duration_sec_qty)/3600 streaming_hours,
SUM(video_start_cnt) streams,

from
`dw_vw.aa_video_detail_reporting_day`
where
video_full_episode_ind IS TRUE
and day_dt between '2022-03-24' and '2022-04-20'
             and v69_registration_id_nbr IS NOT NULL
             and reporting_content_type_cd not in ('CLIP')
       AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
and geo_country_cd = "usa"
and reporting_series_nm = 'Halo'
group by 1
order by 2 desc
