select 
reporting_series_nm,
dma_nm,
SUM(video_content_duration_sec_qty)/3600 streaming_hours,
SUM(streams_cnt) streams,
COUNT(distinct v69_registration_id_nbr) active_sub_hh
       FROM `i-dss-ent-data.ent_vw.multi_channel_detail_day` a left join ent_vw.dma_affiliate_map d on a.geo_dma_cd = CAST(d.dma_id AS STRING)

       where day_dt between '2020-01-23' and '2022-12-20'
             and v69_registration_id_nbr IS NOT NULL
  AND src_system_id = 115
  and source_desc != 'CBS TVE'
  and reporting_series_nm in ("Star Trek: Picard","Star Trek: The Next Generation")
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
  and reporting_content_type_cd <> 'CLIP'

group by 1,2
order by 1,2
     
     
