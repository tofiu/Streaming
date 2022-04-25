with stage0 as (
select 
show_name,
case when show_name in ("Behind The Music",
"KACEY MUSGRAVES | star-crossed : the film",
"Madame X",
"Madame X presents: Madame Xtra Q&A",
"The New Edition Story",
"American Soul",
"Blondie's New York",
"One Last Time: An Evening with Tony Bennett and Lady Gaga",
"The 23rd Annual A Home for the Holidays at the Grove",
"The National Christmas Tree Lighting",
"Adele One Night Only",
"The Tony Awards",
"GRAMMY Awards",
"Academy Of Country Music Awards",
"CMT Crossroads",
"New Year's Eve Live: Nashville's Big Bash",
"MTV Unplugged",
"Diary",
"2021 MTV Video Music Awards",
"Oasis Knebworth 1996",
"Storytellers",
"Justin Bieber: Never Say Never") 
OR show_name like '%Academy of Country Music%'
OR show_name like '%Grammy Awards%'
OR show_name like '%Tony Awards%'
then 'Music'
when  LOWER(show_name) IN ("south park: post covid",
      "south park: post covid: the return of covid",
      "the harper house",
      "star trek: lower decks",
      "tooning out the news",
      "south park: bigger, longer, & uncut",
      "beavis and butt-head",
      "beavis and butt-head do america",
      "daria",
      "drawn together",
      "ugly americans",
      "jeff & some aliens",
      "moonbeam city",
      "trip tank",
      "vinny & the colonel",
      "celebrity deathmatch",
      "aeon flux",
      "star trek: the animated series",
      "clone high",
      "greatest party story ever")
    or (lower(show_name) like '%vinny%colonel%')
    or (lower(show_name) like '%trip%tank%') then "Adult Animation"
else genre end genre_renewed,
v69_registration_id_nbr
from(

select day_dt, 
       case when video_title = "CBS News Hub" then "CBS News Hub" else show_name end as show_name, 
       video_title,
       v31_mpx_reference_guid,
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       length_in_seconds, 
       video_content_duration_sec_qty, 
      -- video_season_nbr,
      -- case when genre is null then 'Others' else genre end as genre
       case when( genre = 'Music' or genre is null )then 'Others'
else genre end genre

from (
        select case when reporting_series_nm in ("Paramount+ Movies","CBS All Access Movies") then replace(replace(video_title," (Trailer)",""),"Paramount+ Movies - ","")
                  when reporting_series_nm in ("Paramount+ Trailers") then replace(video_title," (Trailer)","")
                  when video_title = "CBS News Hub" then video_title
                  else reporting_series_nm end as show_name,*
       FROM `i-dss-ent-data.dw_vw.aa_video_detail_reporting_day` 
       where day_dt BETWEEN '2021-08-24' AND '2022-02-24'
             
             and v69_registration_id_nbr IS NOT NULL
             and reporting_content_type_cd not in ('CLIP')
       AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
       AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
             and reporting_series_nm not in ("Live TV","Live Local TV")
     )  
     a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_without_local_stations` b on lower(trim(a.show_name))=lower(trim(b.show))
)
union all 

select
show_nm,
case when show_nm in ("Behind The Music",
"KACEY MUSGRAVES | star-crossed : the film",
"Madame X",
"Madame X presents: Madame Xtra Q&A",
"The New Edition Story",
"American Soul",
"Blondie's New York",
"One Last Time: An Evening with Tony Bennett and Lady Gaga",
"The 23rd Annual a Home for the Holidays at the Grove",
"The National Christmas Tree Lighting",
"Adele One Night Only",
"The Tony Awards",
"GRAMMY Awards",
"Academy Of Country Music Awards",
"CMT Crossroads",
"New Year's Eve Live: Nashville's Big Bash",
"MTV Unplugged",
"Diary",
"2021 MTV Video Music Awards",
"Oasis Knebworth 1996",
"Storytellers",
"Justin Bieber: Never Say Never") 
OR show_nm like '%Academy of Country Music%'
OR show_nm like '%Grammy Awards%'
OR show_nm like '%Tony Awards%'
then 'Music'
when  LOWER(show_nm) IN ("south park: post covid",
      "south park: post covid: the return of covid",
      "the harper house",
      "star trek: lower decks",
      "tooning out the news",
      "south park: bigger, longer, & uncut",
      "beavis and butt-head",
      "beavis and butt-head do america",
      "daria",
      "drawn together",
      "ugly americans",
      "jeff & some aliens",
      "moonbeam city",
      "trip tank",
      "vinny & the colonel",
      "celebrity deathmatch",
      "aeon flux",
      "star trek: the animated series",
      "clone high",
      "greatest party story ever")
    or (lower(show_nm) like '%vinny%colonel%')
    or (lower(show_nm) like '%trip%tank%') then "Adult Animation"

else genre end genre_renewed,
v69_registration_id_nbr
from(
select day_dt, 
       show_nm, 
       episode_title_nm,
       v31_mpx_reference_guid,
       v69_registration_id_nbr, 
       v126_profile_id, 
       report_suite_id_nm, 
       show_length_sec_qty, 
       window_stream_sec_qty, 
       video_content_type_nm reporting_content_type_cd,
     --  case when genre_new is null then 'Others' else genre_new end as genre
      case when( genre = 'Music' or genre is null )then 'Others'
else genre end genre
from (
select *, case when lower(show_nm) like "%news%" then 'News' else genre end genre_new
FROM `i-dss-ent-data.ent_vw.aa_schedule_stream_detail_day` a left join `i-dss-ent-data.ent_summary.dj_genre_mapping_table_local_stations` b on lower(trim(a.show_nm))=lower(trim(b.show))
where day_dt BETWEEN '2021-08-24' AND '2022-02-24'
      and report_suite_id_nm not in ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
      and LOWER(subscription_state_desc) IN ("trial","sub","discount offer"))
)
)
Select DISTINCT
show_name,
genre_renewed,
  count(distinct v69_registration_id_nbr) regs,

from 
  stage0
 --WHERE genre_renewed in ('Movie','Drama')
-- OR show_name like '%SOUTH%PARK%'

group by 1,2
 order by regs desc
