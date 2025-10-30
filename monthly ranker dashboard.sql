begin 

DECLARE start_date DATE DEFAULT date_trunc(date_sub(date_trunc(current_date(), month), interval 1 day), month);
DECLARE end_date DATE DEFAULT date_sub(date_trunc(current_date(), month), interval 1 day);

delete from
  `i-dss-ent-data.temp_tl.monthly_ranker_source` 

where 
month_dt between start_date and end_date; 

insert into  `i-dss-ent-data.temp_tl.monthly_ranker_source` 

(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) as month_dt,
      source_desc,
      reporting_series_nm,
      reporting_content_type_cd,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
      and v69_registration_id_nbr is not null
    group by
      1, 2, 3, 4
  )
  
);

delete from 
  `i-dss-ent-data.temp_tl.monthly_ranker_plan` 
  
where 
month_dt between start_date and end_date; 
 
insert into `i-dss-ent-data.temp_tl.monthly_ranker_plan` 

(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) as month_dt,
      case
        when lower(subscription_package_desc) like '%cf-sho%'
        then 'Premium Showtime'
        when (
          lower(subscription_package_desc) like '%lcp-sho%'
          or lower(subscription_package_desc) like '%es-sho%'
        )
        then 'Essential Showtime'
        when lower(subscription_package_desc) like '%lc-sho%'
        then 'Limited Commercial Showtime'
        when lower(subscription_package_desc) like '%cf%'
        then 'Premium'
        when (
          lower(subscription_package_desc) like '%lcp%'
          or lower(subscription_package_desc) like '%es%'
        )
        then 'Essential'
        when lower(subscription_package_desc) like '%lc%'
        then 'Limited Commercial'
      end as subscription_type,
      reporting_series_nm,
      reporting_content_type_cd,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
      and v69_registration_id_nbr is not null
    group by
      1, 2, 3, 4
  )
);

delete from
  `i-dss-ent-data.temp_tl.monthly_ranker_source_season` 
where 
month_dt between start_date and end_date; 
insert into 
  `i-dss-ent-data.temp_tl.monthly_ranker_source_season` 
 
(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) as month_dt,
      source_desc,
      reporting_series_nm,
      reporting_content_type_cd,
      case
        when reporting_content_type_cd = 'MOVIE'
        then '-'
        when video_season_nbr is null
        then '-'
        else video_season_nbr
      end as season,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
      and v69_registration_id_nbr is not null
    group by
      1, 2, 3, 4, 5
  )
);

delete from
  `i-dss-ent-data.temp_tl.monthly_ranker_plan_season` 

where 
month_dt between start_date and end_date; 

insert into `i-dss-ent-data.temp_tl.monthly_ranker_plan_season` 



(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) as month_dt,
      case
        when lower(subscription_package_desc) like '%cf-sho%'
        then 'Premium Showtime'
        when (
          lower(subscription_package_desc) like '%lcp-sho%'
          or lower(subscription_package_desc) like '%es-sho%'
        )
        then 'Essential Showtime'
        when lower(subscription_package_desc) like '%lc-sho%'
        then 'Limited Commercial Showtime'
        when lower(subscription_package_desc) like '%cf%'
        then 'Premium'
        when (
          lower(subscription_package_desc) like '%lcp%'
          or lower(subscription_package_desc) like '%es%'
        )
        then 'Essential'
        when lower(subscription_package_desc) like '%lc%'
        then 'Limited Commercial'
      end as subscription_type,
      case
        when reporting_content_type_cd = 'MOVIE'
        then '-'
        when video_season_nbr is null
        then '-'
        else video_season_nbr
      end as season,
      reporting_series_nm,
      reporting_content_type_cd,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
      and v69_registration_id_nbr is not null
    group by
      1, 2, 3, 4, 5
  )
);

delete from
  `i-dss-ent-data.temp_tl.monthly_ranker_series` 

where 
month_dt between start_date and end_date; 

insert into `i-dss-ent-data.temp_tl.monthly_ranker_series` 


(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) month_dt,
      reporting_series_nm,
      reporting_content_type_cd,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
    group by
      1, 2, 3
 )
  
);

delete from
  `i-dss-ent-data.temp_tl.monthly_ranker_season` 
where 
month_dt between start_date and end_date; 
insert into `i-dss-ent-data.temp_tl.monthly_ranker_season`

(
  select
    *,
    RANK() OVER(partition by month_dt order by streams DESC) AS streams_rank,
    RANK() OVER(partition by month_dt order by hours DESC) AS hours_rank,
  from
  (
    select
      date_trunc(day_dt, month) month_dt,
      reporting_series_nm,
      reporting_content_type_cd,
      case
        when reporting_content_type_cd = 'MOVIE'
        then '-'
        when video_season_nbr is null
        then '-'
        else video_season_nbr
      end as season,
      sum(streams_cnt) as streams,
      round(sum(content_duration_min_cnt) / 60) as hours,
      count(distinct v69_registration_id_nbr) as unique_viewers
    from
      ent_summary.fd_house_of_brands
    where
      day_dt between start_date and end_date
      and lower(subscription_state_desc) in ('sub', 'trial', 'discount offer')
      and reporting_content_type_cd in ('FEP', 'MOVIE')
    group by
      1, 2, 3, 4
  )
);

end
