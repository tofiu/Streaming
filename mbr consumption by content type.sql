/*
[JZ] 4/4/25 - Updated tables to same tables used for Topline Business KPIs to improve efficiency and reduce cost.
*/

DECLARE START_DATE, END_DATE DATE;
SET START_DATE = "2021-03-01";
SET END_DATE = "2025-09-30";

-- --CREATE OR REPLACE TABLE `ent_summary.ir_doc_billing_partner_id_mapping` AS
-- DELETE FROM `ent_summary.ir_doc_billing_partner_id_mapping` WHERE month_dt between START_DATE AND END_DATE;
-- INSERT INTO `ent_summary.ir_doc_billing_partner_id_mapping` 
-- with cte_1_sub_day_view as (
--   select
--     date_trunc(day_dt,month) as month_dt,
--     v69_registration_id_nbr,
--     -- case
--     --   when subscription_platform_cd in (
--     --     "AMAZON CHANNELS",
--     --     "AMAZON CHANNELS NICK",
--     --     "AMAZON CHANNELS NOGGIN",
--     --     "AMAZON CHANNELS SHO",
--     --     "APPLE CHANNELS",
--     --     "APPLE CHNL BUNDLE",
--     --     "THE ROKU CHANNEL",
--     --     "THE ROKU CHANNEL NOGGIN",
--     --     "THE ROKU CHANNEL SHO",
--     --     "YOUTUBE CHANNELS") then "Channels"
--     --   when subscription_platform_cd in (
--     --     "CHARTER",
--     --     "MVPD",
--     --     --"HULU", Handled separately with day_dt
--     --     --"HULU SHO",
--     --     "TMOBILE",
--     --     "TMOBILE-AMDOCS",
--     --     "TMOBILE-HSI",
--     --     "WALMART") then "Wholesale/MVPD/vMVPD"
--     --   when subscription_platform_cd in ("HULU", "HULU SHO") and day_dt >= "2024-01-01" then "Wholesale/MVPD/vMVPD"
--     --   when subscription_platform_cd IS NULL AND LOWER(source_desc) LIKE '%channel%' then "Channels"
--     --   when subscription_platform_cd IS NULL AND LOWER(source_desc) LIKE '%hulu%' then "Wholesale/MVPD/vMVPD"
--     --   else "Direct/IAP" 
--     --   /* Direct IAP will have 
--     --   "AMAZON",
--     --   "Apple iOS",
--     --   "Apple iOS SHO",
--     --   "Apple TV",
--     --   "Apple TV SHO",
--     --   "COMCAST",
--     --   "GOOGLE",
--     --   "PSP",
--     --   "RECURLY",
--     --   "RECURLY SHO",
--     --   "RECURLY-SHO-ADDON",
--     --   "SHOWTIME",
--     --   "ROKU",
--     --   "ROKU SHO",
--     --   "VERIZON"*/
--     -- end as billing_partner,
--     billing_platform_type as billing_partner,
--     -- case
--     --   when mc.reporting_series_nm = "Live TV" then mc.video_series_nm
--     --   when mc.reporting_series_nm in ('Paramount+ Movies','CBS All Access Movies','Paramount +','Paramount+',"Movies") then mc.video_title
--     --   when mc.reporting_series_nm is null then mc.video_series_nm
--     --   else mc.reporting_series_nm
--     -- end as reporting_series_nm,
--     title_updated as reporting_series_nm,
--     title_id,
--   -- from `ent_vw.multi_channel_detail_sub_day` mc
--   from `temp_st.st_topline_kpi_base_engagement_table`
--   WHERE 
--     day_dt between START_DATE AND END_DATE
--     -- and src_system_id = 115
--     -- AND subscription_state_desc IN ('sub', 'trial', 'discount offer')
--     -- AND (source_desc NOT IN ("Hulu") OR day_dt >= "2024-01-01")
--   group by 1,2,3,4,5
-- )

-- select
--   month_dt,
--   v69_registration_id_nbr,
--   billing_partner,
--   case 
--     when reporting_series_nm = "RuPaul's Drag Race All Stars" then "RuPaul's Drag Race: All Stars"
--     when reporting_series_nm = "Frasier" then "Frasier (2023)"
--     when reporting_series_nm = "Dora" then "DORA"
--     when reporting_series_nm in ('NFL Football','Super Bowl LVIII', 'NFL on CBS','NFL 2023 Regular Season','VIX DEPORTES 1') then "NFL"
--     when reporting_series_nm like "NFL on %" then "NFL"
--     when reporting_series_nm like "NFL ON %" then "NFL"
--     else reporting_series_nm  
--   end as reporting_series_nm,
-- from cte_1_sub_day_view;

CREATE OR REPLACE TABLE `ent_summary.ir_doc_consumption_by_billing_partner_and_content_category` AS
-- DELETE FROM `ent_summary.ir_doc_consumption_by_billing_partner_and_content_category` WHERE month_dt between START_DATE AND END_DATE;
-- INSERT INTO `ent_summary.ir_doc_consumption_by_billing_partner_and_content_category`
 select
    month_dt,
    -- case when lower(coalesce(pt.reporting_series_nm, c6.reporting_series_nm)) LIKE '%south park%' then 'South Park' else content_cohort_flag end as content_cohort_flag,
    content_category,
      case
    when reporting_content_type_cd in 
      ("CBS LIVE TV", 
      "LIVE FEED", 
      "LIVE CHANNELS", 
      "P+ CHANNELS") 
    then "Live"
    when reporting_content_type_cd in 
      ("CLIP", 
      "TRAILER", 
      "Other", 
      "core-starts") 
    then "Other"
    when reporting_content_type_cd in ("FEP") 
    then "Series"
    when reporting_content_type_cd in ("MOVIE") 
    then "Movies"
    end as content_type,
    genre_nm,
    brand,
    billing_partner,
    --reporting_series_nm,
    v69_registration_id_nbr,
    sum(hours) as hours
  from 
    `ent_summary.jz_consumption_content_categories`
  group by all;
