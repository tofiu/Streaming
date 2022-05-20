create table
  `i-dss-ent-data.temp_mk.around_the_globe_carousel_clicks`
partition by day_dt as (
  select
    day_dt,
    post_evar69_desc as user_id,
    post_evar83_desc as carousel,
    split(
      case
        when (
          post_evar63_desc is null
          or post_evar63_desc like '%null|%'
        )
        then post_evar121_desc
        else post_evar63_desc
      end
    , '|')[safe_ordinal(2)] as title,
    post_evar63_desc as series,
    post_evar121_desc as movie,
  from
    `i-dss-ent-data.dw_vw.omniture_event_cdm_cnetcbscomsite`
  where
    day_dt between '2021-10-19' and '2022-05-18'
    and post_evar69_desc != '0'
    and post_evar69_desc is not null
    and report_suite_id_nm = 'cnetcbscomsite'
    and lower(post_evar83_desc) like 'around the globe'
    and post_evar10_desc like '%front_door%'
    and (
      post_page_event_var2_desc like '%trackRowHeader%'
      or (
        post_page_event_var2_desc like '%trackCarouselSelect%'
        and post_evar1_desc not like '%ott_lg%'
        and post_evar1_desc not like '%ott_viziotv%'
        and post_evar1_desc not like '%ott_samsungtv%'
        and post_evar1_desc not like '%ott_ps4%'
        and post_evar1_desc not like '%ott_xbox%'
        and post_evar1_desc not like '%ott_comcast%'
        and post_evar1_desc not like '%ott_cox%'
      )
    )
    and page_event_type_id = 10
    and (
      post_evar63_desc is not null
      or post_evar121_desc is not null
    )
)
