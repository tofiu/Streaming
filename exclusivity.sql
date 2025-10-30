--create or replace table ent_summary.exclusivity_tracker_movies_timeline_view as 
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_1_start_date,
       streaming_window_1_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_1_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_2_start_date,
       streaming_window_2_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_2_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_3_start_date,
       streaming_window_3_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_3_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_4_start_date,
       streaming_window_4_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_4_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_5_start_date,
       streaming_window_5_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_5_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_6_start_date,
       streaming_window_6_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_6_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_7_start_date,
       streaming_window_7_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_7_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_8_start_date,
       streaming_window_8_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_8_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_9_start_date,
       streaming_window_9_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_9_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_10_start_date,
       streaming_window_10_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_10_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_11_start_date,
       streaming_window_11_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_11_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_12_start_date,
       streaming_window_12_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_12_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_13_start_date,
       streaming_window_13_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_13_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_14_start_date,
       streaming_window_14_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_14_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_15_start_date,
       streaming_window_15_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_15_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_16_start_date,
       streaming_window_16_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_16_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_17_start_date,
       streaming_window_17_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_17_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_18_start_date,
       streaming_window_18_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_18_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       non_series_title,
       "MOVIE" as season_number,
       original_network,
       distributor, 
       distributor_group,
       genre,
       "N/A" as consolidated_genre_2,
       maturity_rating,
       streaming_window_19_start_date,
       streaming_window_19_end_date
from dw_vw.stream_metrics_non_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_non_series_window_fct)
and streaming_window_19_start_date is not null


------

select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_1_start_date,
       streaming_window_1_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_1_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_2_start_date,
       streaming_window_2_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_2_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_3_start_date,
       streaming_window_3_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_3_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_4_start_date,
       streaming_window_4_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_4_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_5_start_date,
       streaming_window_5_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_5_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_6_start_date,
       streaming_window_6_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_6_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_7_start_date,
       streaming_window_7_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_7_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_8_start_date,
       streaming_window_8_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_8_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_9_start_date,
       streaming_window_9_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_9_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_10_start_date,
       streaming_window_10_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_10_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_11_start_date,
       streaming_window_11_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_11_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_12_start_date,
       streaming_window_12_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_12_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_13_start_date,
       streaming_window_13_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_13_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_14_start_date,
       streaming_window_14_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_14_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_15_start_date,
       streaming_window_15_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_15_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_16_start_date,
       streaming_window_16_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_16_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_17_start_date,
       streaming_window_17_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_17_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_18_start_date,
       streaming_window_18_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_18_start_date is not null
union all
select distinct 
       day_dt,
       case when service_name in ("Paramount+ SHOWTIME","Paramount+") then "Paramount+" else service_name end service_name,
       series_title,
       season_number,
       season_network,
       distributor, 
       distributor_group,
       genre,
       consolidated_genre_2,
       maturity_rating,
       streaming_window_19_start_date,
       streaming_window_19_end_date
from dw_vw.stream_metrics_series_window_fct 
where offer_type = 'SVOD'
and country = "US"
and day_dt = (select max(day_dt) from dw_vw.stream_metrics_series_window_fct)
and streaming_window_19_start_date is not null
