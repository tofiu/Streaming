SELECT  date_trunc(a.day_dt, quarter) quarter,
        case when genre = 'Sports' and reporting_content_type_cd <> 'MOVIE' then 'Sports'
             when genre = 'Specials' or reporting_content_type_cd = 'MOVIE' then 'Specials/Movies'
             when genre = 'Kids & Family' and reporting_content_type_cd <> 'MOVIE' then 'Kids & Family'
             when genre = 'Reality' and reporting_content_type_cd <> 'MOVIE' then "Unscripted Series"
             when genre in ("Comedy","Drama","Crime","Sci-fi","Horror","Thriller","Soap Operas") and reporting_content_type_cd <> 'MOVIE' then "Scripted Series"
       else 'Others' end as verticals,
       source_desc,
       count(distinct v69) as active_sub,
       sum(streams_cnt) as streams
FROM `i-dss-ent-data.ent_summary.fd_house_of_brands` a left join `i-dss-ent-data.temp_dj.show_genre_mapping_wo_live` b on lower(trim(a.reporting_series_nm))=lower(trim(b.show))
WHERE (a.day_dt between '2021-01-01' and '2021-03-31'
      or a.day_dt between '2021-10-01' and '2022-03-31')
group by 1,2,3
order by 1,2,3
