
--[JZ] 9/29/25 - IR Solution for Starts Using Title Matching

-- ==================================================================================================================================
-- ========== OVERALL VARIABLE DECLARATIONS ==========
DECLARE START_DATE DATE DEFAULT '2021-03-01'; 
DECLARE END_DATE DATE DEFAULT LAST_DAY(date_sub(CURRENT_DATE(),interval 1 month));


-- ========== GENRE OVERRIDE ARRAYS ==========
DECLARE drama_genre ARRAY<STRING> DEFAULT [
"Escape at Dannemora", "Mission: Impossible – The Final Reckoning", "Lust and Redemption", "Reign", "Victoria", "The Handmaid's Tale", "Yellowjackets (2021) Official Trailer #2", "Major Crimes", "Nurse Jackie", "Chicago Fire", "Castle", "1923 S2", "NCIS: The Cases They Can't Forget", "NCISverse: The First 1,000", "Mission: Impossible -- Dead Reckoning Part One Creating the Impossible", "True Crime 2023: Who Stole My Life?", "Who Stole My Life?", "Big House, The Pearl & The Triumph of Winston-Salem State", "Warrior", "9-1-1"
];

DECLARE horror_genre ARRAY<STRING> DEFAULT [
"Smile", "Pet Sematary: Bloodlines", "Apartment 7A", "Friday The 13th", "Erotic Ghost Story", "Sexorcist", "Orphan: First Kill Trailer", "Scream VI: Official Trailer", "Carcass"
];

DECLARE factual_genre ARRAY<STRING> DEFAULT [
"Dateline", "Forensic Files", "Matter of Fact With Soledad O'Brien", "True Crime: Identity Theft", "Storm of Suspicion", "InvestigateTV+", "InvestigateTV+ Weekend", "Forensic Factor", "Ocean Mysteries With Jeff Corwin", "Weather Gone Viral", "The CIA: Race Against Time -- The True Story of the CIA and 9/11", "America by Design", "Protecting Life on Earth", "Climate Watch: Overheated", "Our America: Mission Montford Point", "Unsung Heroes: The Story of America's Female Patriots", "Eye on Northwest Politics", "Inside Texas Politics", "Full Court Press With Greta Van Susteren", "Eye on Retirement", "Eye on the Future", "Inside West Virginia Politics", "Inside the Pride", "Inside the Huddle", "Turning Point With Dr. David Jeremiah", "Joel Osteen", "Joel Osteen Ministries", "Elevation with Steven Furtick", "In Touch With Dr. Charles Stanley", "Time of Grace With Pastor Mike Novotny", "The Winning Walk with Dr. Ed Young", "First Baptist Church", "First Baptist Church of Huntsville", "Second Baptist Church", "Dawson Family of Faith", "Ingleside Baptist Church", "Trinity Methodist", "First Presbyterian Church", "Robert Jeffress", "Word of God Ministries", "Key of David", "Mission Messiah Television", "Catch the Truth", "Turning Point", "Joni Table Talk", "The 700 Club", "Hope for Pain Sufferers", "Everyday Heroes", "Everyday Heroes: Veteran's Day", "Everyday Heroes: Our True Colors", "Everyday Heroes: Working Together To Be Stronger", "Everyday Heroes: Thanking Our Heroes", "Women on the Move", "Women on the Move: Year in Review", "Women on the Move: Hispanic Excellence", "Mentoring Kings", "Mentoring Queens", "Beyond Limits", "Together We Are Able", "Operation Smile", "Stories of Love to the Rescue by Shriners Hospitals for Children®", "Transforming Lives by Shriners Hospitals for Children®", "American Valor: A Salute to Our Heroes", "America Honors Our Veterans", "America's Heartland", "America Decides: Campaign '22", "Protect Your Memory", "Ukraine in Crisis!", "Still Missing Morgan", "9/11: 20 Years Later", "The Silent Pandemic: Heart Failure", "Alex Scott: A Stand for Hope", "America’s Bravest Heroes", "SOS: How to Survive", "Extraordinary World with Jeff Corwin", "America’s Thanksgiving Parade", "Peak of the Week", "America’s Thanksgiving Day Parade", "VAX LIVE: The Concert to Reunite the World", "Broadway and Beyond at the Tonys", "The Broadway Show With Tamsen Fadal", "The Tony Awards Presents: Broadway's Back", "The Tony Awards: Act One", "After Midnight"
];

DECLARE comedy_genre ARRAY<STRING> DEFAULT [
  "Friends", "Seinfeld", "Two and a Half Men", "Modern Family", "The Goldbergs", "Last Man Standing", "2 Broke Girls", "Comics Unleashed With Byron Allen", "Funny You Should Ask", "Just for Laughs Gags", "Comedy.TV", "The Greatest @Home Videos: The Cedy Awards", "The Nutty Professor", "South Park: The Streaming Wars", "The Simpsons", "You Bet Your Life With Jay Leno", "Richard Pryor"
];

DECLARE reality_genre ARRAY<STRING> DEFAULT [
"Undercover Boss Celebrity Edition", "Catfish: The TV Show", "Wipeout", "Storage Wars", "Pawn Stars", "Im A Celebrity...Get Me Out Of Here", "Fast: Home Rescue", "Flip My Florida Yard", "Designing Spaces", "Raw Travel", "Military Makeover", "Small Town Big Deal", "America by Design", "HomeTown Living", "Ready, Set, Renovate", "The VeryVera Show", "The Texas Bucket List", "Today's Homeowner With Danny Lipford", "Flip Side", "Ready, Race, Rescue", "America’s Heartland" , "Positively Montana", "Destination LA", "Destination Dallas", "Destination Chicago", "Destination Dynasty", "Big Game Cajun Cookin’", "Cribbs in the CLE: Josh and Maria Live", "Real Green", "America’s Thanksgiving Day Parade", "Through the Decades", "Chef Emeril’s Air Fryer Secret + FREE PANS", "The Great Dr. Scott", "Phantom Gourmet", "Made in Hollywood", "Awesome Adventures", "Xploration Outer Space", "Science Now", "Laura McKenzie's Traveler", "Ed Sullivan's Rock n Roll Classics", "Beautiful Homes & Great Estates", "House Stealing - The Latest Cyberthreat and How To Protect Your Home", "MyDestination.TV", "Lucky Dog"
];

DECLARE sports_genre ARRAY<STRING> DEFAULT [
"PBR Camping World Team Series", "2021 PGA Championship", "Academy of Country Music Awards", "PGA Tour Golf", "NFL Today Postgame", "At the Final Four", "Major League Fishing", "Purple Pregame", "FIA Formula E World Championship Racing", "Tailgate 19", "Patriots Game Day", "Lucas Oil Pro Pulling League", "2023 TOUR Championship", "Coppa Italia Frecciarossa", "Rodeo", "Lucas Oil Late Model Dirt Series", "La Liga Premier", "The Thanksgiving Day Pregame Show", "Cornhole", "Rogue Invitational", "PBR Team Series: Road to Vegas", "USL Championship Soccer", "Jim Nantz Remembers Augusta: Mark O'Meara at the Masters", "13 Green Jackets: A Conversation With Tiger Woods, Jack Nicklaus, and Scottie Scheffler", "SEC Wrap Up Show", "Lucas Oil Drag Boat Racing", "The 5th Quarter", "74th Annual Thanksgiving Day Parade", "Bengals Weekly", "Patriots Fifth Quarter", "CBS3 Sunday Kickoff", "Big Orange Kickoff", "The Fifth Quarter", "Monday Night Countdown", "Confidential Conversations: Big Ten Football 2025", "World's Strongest Man", "2025 Women's Rugby World Cup", "The Masters: Jack and Arnie!", "NBA Basketball", "MLB Baseball", "World's Strongest Man 2024", "Boys High School Basketball", "Golf", "CrossFit Games", "Major League Pickleball", "AVP Beach Volleyball", "Drew Pearson: A Football Life", "PGA Championship Preview", "The Masters: The Magnificent 12th", "Changing The Game: Charlie Scott", "The Masters: The Second Nine on Sunday", "Major League Rugby", "The 2023 World's Strongest Man", "Tight End University", "College Football Saturday", "Football Preview", "Bengals Postgame Show", "Saints Football Live Pregame Special", "Sport Zone Sunday", "HBCU Battle of the Bands", "Sporting Classics", "Predators Live! Pregame", "NHL Blues Pre-Game", "Texans 360", "Dallas Cowboys Pre-Game", "Saints Pregame", "Saints Postgame", "Titans Pregame", "NFL End Zone", "Packers Preseason Pregame Show", "Rivals: Ohio State vs. Michigan", "Titans Gameday", "The Big Game Kickoff", "Cowboys Countdown to Kickoff", "Big Orange Kickoff Special", "Vols Basketball Preview Show", "Touchdown Friday Nights", "Red Zone Ready Preseason Special", "NFL Films Highlight Show", "Chiefs Pregame", "Panthers Huddle", "Cardinals Game Plan", "Dolphins Pregame Show", "Bills Kickoff Live", "Jets Gameday", "49ers Experience", "Commanders Kickoff", "Bengals Nation", "Razorback Football with Sam Pittman", "Texans Extra Points", "College Kickoff 2025", "Touchdown in Tampa", "Touchdown 7"
];


DECLARE news_genre ARRAY<STRING> DEFAULT [
"InvestigateTV+", "Hard Truths", "Matter of Fact With Soledad O'Brien", "Dateline", "Extra", "Inside Texas Politics", "On Your Side Tonight With Jamie Boll", "Eye on Northwest Politics", "America Decides: Campaign '22", "Capital Connection", "The Issue Is", "Politics Now Las Vegas", "Face the State With Joel D. Smith", "Political Special", "Eye on Politics", "Talk Business and Politics", "Politics Unplugged", "Eye on Northwest Politics: Election Special", "Decision 2022", "Voter's Decide: Debate", "Congressional District 2 Debate", "Voters Decide: Denver Mayoral Debate", "Campaign 2024: Countdown to Election Day", "State of the State", "State of Texas In-Depth", "Nevada Gubernatorial Republican Primary Debate", "Gubernatorial Debate", "Presidential Address to the Joint Session of Congress", "President Biden Address to the Nation", "First Presidential Debate: Hosted by CNN", "Election Headquarters: US Senate Debate"
];

DECLARE kids_family_genre ARRAY<STRING> DEFAULT [
"Blaze and the Monster Machines: Wild Wheels Escape to Animal Island", "Blaze and the Monster Machines: Racecar Adventures", "Blaze and the Monster Machines: Big Rig to the Rescue!", "Max & the Midknights", "The Wild Thornberrys Movie", "Rudolph the Red-Nosed Reindeer", "Frosty the Snowman", "Robbie the Reindeer in Hooves of Fire", "Robbie the Reindeer in Legend of the Lost Tribe", "Jet to the Rescue", "The Tiger’s Apprentice", "When Christmas Was Young", "Fit for Christmas", "Dear Santa", "Dear Santa (starring Jack Black)", "Nashville Music Special, Home for the Holidays", "Mariah Carey: Merry Christmas To All!", "Sounds of the Season", "A Baylor Christmas", "Christmas Across America: A Small Town Big Deal Celebration"
];

DECLARE other_genre ARRAY<STRING> DEFAULT [
];


-- ========== CONTENT CATEGORY ARRAYS ==========

DECLARE original_series_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE local_live_titles_content_category ARRAY<STRING> DEFAULT [

  ];

DECLARE theatrical_movies_titles_content_category ARRAY<STRING> DEFAULT [
 
];

DECLARE dts_movies_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE library_movies_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE library_series_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE sports_titles_content_category ARRAY<STRING> DEFAULT [
"PBR Camping World Team Series", "2021 PGA Championship", "Academy of Country Music Awards", "PGA Tour Golf", "NFL Today Postgame", "At the Final Four", "Major League Fishing", "Purple Pregame", "FIA Formula E World Championship Racing", "Tailgate 19", "Patriots Game Day", "Lucas Oil Pro Pulling League", "2023 TOUR Championship", "Coppa Italia Frecciarossa", "Rodeo", "Lucas Oil Late Model Dirt Series", "La Liga Premier", "The Thanksgiving Day Pregame Show", "Cornhole", "Rogue Invitational", "PBR Team Series: Road to Vegas", "USL Championship Soccer", "Jim Nantz Remembers Augusta: Mark O'Meara at the Masters", "13 Green Jackets: A Conversation With Tiger Woods, Jack Nicklaus, and Scottie Scheffler", "SEC Wrap Up Show", "Lucas Oil Drag Boat Racing", "The 5th Quarter", "74th Annual Thanksgiving Day Parade", "Bengals Weekly", "Patriots Fifth Quarter", "CBS3 Sunday Kickoff", "Big Orange Kickoff", "The Fifth Quarter", "Monday Night Countdown", "Confidential Conversations: Big Ten Football 2025", "World's Strongest Man", "2025 Women's Rugby World Cup", "The Masters: Jack and Arnie!", "NBA Basketball", "MLB Baseball", "World's Strongest Man 2024", "Boys High School Basketball", "Golf", "CrossFit Games", "Major League Pickleball", "AVP Beach Volleyball", "Drew Pearson: A Football Life", "PGA Championship Preview", "The Masters: The Magnificent 12th", "Changing The Game: Charlie Scott", "The Masters: The Second Nine on Sunday", "Major League Rugby", "The 2023 World's Strongest Man", "Tight End University", "College Football Saturday", "Football Preview", "Bengals Postgame Show", "Saints Football Live Pregame Special", "Sport Zone Sunday", "HBCU Battle of the Bands", "Sporting Classics", "Predators Live! Pregame", "NHL Blues Pre-Game", "Texans 360", "Dallas Cowboys Pre-Game", "Saints Pregame", "Saints Postgame", "Titans Pregame", "NFL End Zone", "Packers Preseason Pregame Show", "Rivals: Ohio State vs. Michigan", "Titans Gameday", "The Big Game Kickoff", "Cowboys Countdown to Kickoff", "Big Orange Kickoff Special", "Vols Basketball Preview Show", "Touchdown Friday Nights", "Red Zone Ready Preseason Special", "NFL Films Highlight Show", "Chiefs Pregame", "Panthers Huddle", "Cardinals Game Plan", "Dolphins Pregame Show", "Bills Kickoff Live", "Jets Gameday", "49ers Experience", "Commanders Kickoff", "Bengals Nation", "Razorback Football with Sam Pittman", "Texans Extra Points", "College Kickoff 2025", "Touchdown in Tampa", "Touchdown 7"
];

DECLARE news_titles_content_category ARRAY<STRING> DEFAULT [
"InvestigateTV+", "Hard Truths", "Matter of Fact With Soledad O'Brien", "Dateline", "Extra", "Inside Texas Politics", "On Your Side Tonight With Jamie Boll", "Eye on Northwest Politics", "America Decides: Campaign '22", "Capital Connection", "The Issue Is", "Politics Now Las Vegas", "Face the State With Joel D. Smith", "Political Special", "Eye on Politics", "Talk Business and Politics", "Politics Unplugged", "Eye on Northwest Politics: Election Special", "Decision 2022", "Voter's Decide: Debate", "Congressional District 2 Debate", "Voters Decide: Denver Mayoral Debate", "Campaign 2024: Countdown to Election Day", "State of the State", "State of Texas In-Depth", "Nevada Gubernatorial Republican Primary Debate", "Gubernatorial Debate", "Presidential Address to the Joint Session of Congress", "President Biden Address to the Nation", "First Presidential Debate: Hosted by CNN", "Election Headquarters: US Senate Debate"
];


-- ==================================================================================================================================

CREATE OR REPLACE TABLE `ent_summary.jz_starts_content_categories`
partition by activation_month
AS (
with cte_1_cbs_titles as (
  select
    mpd.reporting_series_nm as title,
    cast(mpd.title_id as string) as title_id,
  from `i-dss-ent-data.temp_ad.cbs_pplus_premiere_date` pd
  join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
    on cast(pd.content_id as string) = cast(mpd.parent_id as string)
  group by all
),

cte_2_cbs_current_seasons as (
select 
  mpd.reporting_series_nm as title,
  cast(pd_left.season_nbr as string) as video_season_nbr,
  cast(mpd.title_id as string) as title_id,
  case
    when pd_left.season_nbr = 1 then START_DATE 
    else pd_left.premiere_dt
  end as season_premiere_dt,
  case
    when pd_right.season_nbr is null then date_add(pd_left.premiere_dt,interval 364 day)
    when date_add(pd_left.premiere_dt,interval 364 day) < pd_right.premiere_dt then date_add(pd_left.premiere_dt,interval 364 day)
    else date_sub(pd_right.premiere_dt, interval 1 day)
  end as slam_season_window_end,
  from `i-dss-ent-data.temp_ad.cbs_pplus_premiere_date` pd_left
  left join `i-dss-ent-data.temp_ad.cbs_pplus_premiere_date` pd_right
    on
      pd_left.title = pd_right.title
      and cast(pd_left.season_nbr as int64) + 1 = cast(pd_right.season_nbr as int64)
  join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
    on cast(pd_left.content_id as string) = cast(mpd.parent_id as string)
  where
    pd_left.season_level_title is not null
  group by all
),

cte_3_original_seasons_only as ( 
  select
    mpd.reporting_series_nm as title,
    case
      when content_type = "(Movie)" then null
      else season_nbr
    end as video_season_nbr,
    cast(mpd.title_id as STRING) as title_id,
    case 
      when content_id in ("61457332") then "News" --"60 Minutes+"
      when content_id in ("61460697") then "Sports" --"Inside the NFL" 
      --when content_id in ("956159958") then "Factual" --Thirst Trap: The Fame. The Fantasy. The Fallout.
      --when content_id in ("rcaREc9ukH_RRWXku6ODuAblgLG9Iv3U") then "Factual" --Bodyguard of Lies
      --when content_id in ("QVomEH1jQt_PAKRDKeBl1j8ceZo7bvj_") then "Factual" --Ozzy: No Escape From Now
      else pd.genre 
    end as genre_nm,
    release_strategy,
    case
      when content_type is null then "FEP"
      else "MOVIE"
    end as content_type,
    premeire_dt,
    case
      when content_id not in (
      "61456641", -- "RuPaul's Drag Race All Stars"
      "61459324", -- "RuPaul's Drag Race All Stars Untucked"
      "61456321", -- "SEAL Team"
      "61457217", -- "Ink Master"
      "393",      -- "Criminal Minds"
      "61456496", -- "Evil"
      "61456699", -- "Are You The One?"
      "61456483", -- "Blood & Treasure"
      "61456866", -- "Inside Amy Schumer"
      "61457025", -- "Billions"
      "61460697", -- "Inside the NFL"
      "62468457", -- "The Chi"
      "61466437", -- "The Circus"
      "61457230", -- "Yellowjackets"
      "61464293"  -- "Couples Therapy"
      )
      then "Always Original"
      else "Turned Original"
    end as original_conversion_flag
  from `ent_summary.pplus_original_premiere_date` pd
  join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
    on cast(pd.content_id as string) = cast(mpd.parent_id as string)
  where
    content_id is not null --This condition will remove The Chi and Couples Therapy Breakout seasons (i.e. 4.1, 4.2, 6.1, 6.2) here
    and title is not null
    and premeire_dt <= END_DATE
  group by all
),

cte_5_starts_data as (
    select
      activation_dt,
      date_trunc(activation_dt, month) as activation_month,
      title_id,
      title_group_id,
      title_group_nm,
      reporting_series_nm,
      reporting_content_type_cd,
      primary_genre_nm,
      secondary_genre_nm,
      case
        when primary_genre_nm in ("News & Sports") then secondary_genre_nm
        else primary_genre_nm
      end as genre_nm,
      comet_taxonomy_brand_nm as brand,
      subscription_guid,
      subscription_platform_cd,
      case
        when subscription_platform_cd in (
          "AMAZON CHANNELS",
          "AMAZON CHANNELS NICK",
          "AMAZON CHANNELS NOGGIN",
          "AMAZON CHANNELS SHO",
          "APPLE CHANNELS",
          "APPLE CHNL BUNDLE",
          "THE ROKU CHANNEL",
          "THE ROKU CHANNEL NOGGIN",
          "THE ROKU CHANNEL SHO",
          "YOUTUBE CHANNELS") then "Channels"
        when subscription_platform_cd in (
          "CHARTER",
          "MVPD",
          "HULU",
          "HULU SHO",
          "TMOBILE",
          "TMOBILE-AMDOCS",
          "TMOBILE-HSI",
          "WALMART") then "Wholesale/MVPD/vMVPD"
        else "Direct/IAP" 
          /* Direct IAP will have 
          "AMAZON",
          "Apple iOS",
          "Apple iOS SHO",
          "Apple TV",
          "Apple TV SHO",
          "COMCAST",
          "GOOGLE",
          "PSP",
          "RECURLY",
          "RECURLY SHO",
          "RECURLY-SHO-ADDON",
          "SHOWTIME",
          "ROKU",
          "ROKU SHO",
          "VERIZON"*/
      end as billing_partner,
    from `ent_vw.subscription_slam_attribution_fct` ss 
    where
      src_system_id = 115
      and activation_dt between START_DATE and END_DATE
    and acquisition_type_cd = "Starts"
    group by all
),

cte6_ranked_genres_by_title as (
  select
    title_group_id,
    genre_nm,
    row_number() over (partition by title_group_id order by count(distinct subscription_guid) desc) title_group_rank,

  from cte_5_starts_data
  where 
    genre_nm IS NOT NULL
    and title_group_nm <> "Other"
    and title_group_nm <> "-"
    and reporting_content_type_cd not like "%core%"
    and reporting_series_nm not like "%core%"
    and reporting_series_nm not in ("-")
    and reporting_series_nm IS NOT NULL
  group by all
),

cte7_top_genres_by_title as (
  select
    title_group_id,
    genre_nm
  from cte6_ranked_genres_by_title
  where 
    title_group_rank = 1
  group by all
),

cte_8_ranked_brand_by_title as (
  select
    title_group_id,
    brand,
    row_number() over (partition by title_group_id order by count(distinct subscription_guid) desc) title_group_rank,
  from cte_5_starts_data
    where brand IS NOT NULL
    and title_group_nm <> "Other"
    and title_group_nm <> "-"
    and reporting_content_type_cd not like "%core%"
    and reporting_series_nm not like "%core%"
    and reporting_series_nm not in ("-")
    and reporting_series_nm IS NOT NULL
  group by all
),

cte_9_top_brand_by_title as (
select
  title_group_id,
  brand
from cte_8_ranked_brand_by_title
where 
  title_group_rank = 1
group by all
),

cte8_content_categories_classified as (
 select
    c5.title_group_id,
    c5.title_id,
    c5.title_group_nm,
    c5.reporting_series_nm,
    c5.reporting_content_type_cd,
    c5.subscription_platform_cd,
    c5.billing_partner,
    c5.activation_month,
    c5.activation_dt,
    case
      --------------------------
      --- Content Categories ---
      --------------------------
      -- 1. Manual primary genre overrides by array (before anything else)
      --WHEN c5.title_group_nm IN UNNEST(cbs_current_titles_content_category) THEN "CBS Current"
      WHEN c5.title_group_nm IN UNNEST(original_series_titles_content_category) THEN "Original Series"
      WHEN c5.title_group_nm IN UNNEST(dts_movies_titles_content_category) THEN "DTS Movies"
      WHEN c5.title_group_nm IN UNNEST(theatrical_movies_titles_content_category) THEN "Theatrical Movies"
      WHEN c5.title_group_nm IN UNNEST(sports_titles_content_category) THEN "Sports"
      WHEN c5.title_group_nm IN UNNEST(news_titles_content_category) THEN "News"
      WHEN c5.title_group_nm IN UNNEST(local_live_titles_content_category) THEN "Local + Live"
      WHEN c5.title_group_nm IN UNNEST(library_movies_titles_content_category) THEN "Library Movies"
      WHEN c5.title_group_nm IN UNNEST(library_series_titles_content_category) THEN "Library Series"

      -- 2. (MD) Other (Catch All) - This bucket includes all the core except core-nfl-window (which gets taken care by cte_5 join) and all undefined Starts
      when c5.title_group_nm in ("Paramount +","undefined","Paramount+") then "Other (Catch All)"
      when c5.title_group_nm like "core%" and c5.title_group_nm not in ("core-nfl-window") then "Other (Catch All)"
      
      -- 3.CBS Current Logic
      when (c2.title is not null or c2.title_id is not null)
      and (c5.reporting_content_type_cd is null OR c5.reporting_content_type_cd not in ("MOVIE")) then "CBS Current"

      -- 4. Original Series
      when (c3.title is not null or c3.title_id is not null) and c3.content_type = "FEP"
      and (c5.reporting_content_type_cd is null OR c5.reporting_content_type_cd not in ("MOVIE")) then "Original Series"

      -- 5. South Park
      when lower(c5.title_group_nm) LIKE '%south%park%' or lower(c5.title_group_nm) like '%casa%mi%amor%' then 'South Park'

      -- 6. DTS and Theatrical Movies
      when (c3.title is not null or c3.title_id is not null) and c3.content_type = "MOVIE" and c3.release_strategy = "DTC Movies"
      and (c5.reporting_content_type_cd is null OR c5.reporting_content_type_cd not in ("FEP")) then "DTS Movies"
      
      when (c3.title is not null or c3.title_id is not null) and c3.content_type = "MOVIE" and c3.release_strategy = "Theatrical Release" 
      and (c5.reporting_content_type_cd is null OR c5.reporting_content_type_cd not in ("FEP")) then "Theatrical Movies"

      -- 7. Sports
      when c7.genre_nm = "Sports" then "Sports"
      when (UPPER(c5.title_group_nm) like "%SPORTS%")
        and (c5.title_group_nm not in ("KHOU 11 Sports Extra"))
        and ((c5.primary_genre_nm is null)
        or (c5.primary_genre_nm = "News & Sports")
        or (c5.secondary_genre_nm = "Sports"))
      then "Sports"
      WHEN (c5.secondary_genre_nm = "Sports" AND LOWER(TRIM(c5.title_group_nm)) NOT IN ("local news", "we need to talk"))
      THEN "Sports"

      -- 8. News
      when c7.genre_nm = "News" then "News"
      when
        (UPPER(c5.title_group_nm) like "%NEWS%")
        and ((c5.primary_genre_nm is null) 
            or (c5.primary_genre_nm = "News & Sports")
            or (c5.secondary_genre_nm = "News")) 
      THEN "News"
      WHEN c5.secondary_genre_nm = "News"
          OR (
            REGEXP_CONTAINS(LOWER(c5.title_group_nm), r'news|this morning|good morning')
            OR REGEXP_CONTAINS(c5.title_group_nm, r'^(K|W)[A-Z0-9]{2,}')  -- station codes
            OR REGEXP_CONTAINS(c5.title_group_nm,   r'(?i)on\s+(K|W)[A-Z0-9-]{2,}\s*\d{1,3}')  -- station codes
          )
        THEN "News"
      
      -- 9. Library Movies
      when c5.reporting_content_type_cd in ("MOVIE") then "Library Movies"

      -- 10. Local and Live
      when
      (upper(reporting_content_type_cd) in ("CBS LIVE TV", "LIVE FEED", "LIVE CHANNELS", "P+ CHANNELS","LIVE") 
        OR (c5.title_group_nm like "P+ Live%")
        OR (lower(c5.title_group_nm) like "% live %")
        OR (c5.title_group_nm like "P+ Channels%")) then "Local + Live"

      -- 11. Others Catch All
      when
        lower(c5.title_group_nm) LIKE '%manual test%'
        or lower(c5.title_group_nm) LIKE '%test event%'
        or lower(c5.title_group_nm) LIKE '%testing%'
        or lower(c5.title_group_nm) LIKE '%sb test%'
        or lower(c5.title_group_nm) LIKE '%cbsaa%'
        or lower(c5.title_group_nm) LIKE '%election%'
        or lower(c5.title_group_nm) LIKE '%mixible%'
        or lower(c5.title_group_nm) LIKE '%channel%'
        or lower(c5.title_group_nm) LIKE '%broadcast%'
        OR REGEXP_CONTAINS(c5.title_group_nm, r'\b[A-Z0-9-]{10,}\b')
        OR lower(c5.title_group_nm) LIKE '%all%access%'
        OR lower(c5.title_group_nm) LIKE '%paramount%'
        OR REGEXP_CONTAINS(c5.title_group_nm, r'(?i)\bCBS\s*\d+\b')
        OR REGEXP_CONTAINS(c5.title_group_nm, r'\b\d{1,2}/\d{1,2}\b')
        OR REGEXP_CONTAINS(c5.title_group_nm, r'\b\d{1,2}(:\d{2})?\s*[ap]\.?m\.?\b')
        OR c5.title_id = "_55cL7EscO2mdFcpsZVcQ3VtXNA5bcA_"
      then "Local + Live"

      -- 12. CBS Library
      when (c1.title_id is not null or c1.title IS NOT NULL) 
      then "CBS Library"

      -- 13. Awards and Specials
      when ((UPPER(c5.title_group_nm) LIKE '%AWARD%')
      OR (lower(c5.title_group_nm) like "% concert %")
      OR (lower(c5.title_group_nm) like "% concert")
      OR (lower(c5.title_group_nm) like "concert %")
      or (lower(c5.title_group_nm) like "% special %")
      or (lower(c5.title_group_nm) like "% special")
      or (lower(c5.title_group_nm) like "special %"))
      then "Library Specials"

      -- 14. Trailers Catch All

      when (lower(c5.title_group_nm) like "%trailer%"
        or lower(c5.title_group_nm) like "%(trailer)%"
        or lower(c5.title_group_nm) like "%teaser%"
        or lower(c5.title_group_nm) like "%preview%"
        or reporting_content_type_cd in ("TRAILER", "CLIP")) then "Library Other"


      -- 15. Catch All as Library Series
      else "Library Series"
      end as content_category,

      case
      --------------------------
      --------- Genres ---------
      --------------------------
        -- 1. Manual primary genre overrides by array (before anything else)
      WHEN c5.title_group_nm IN UNNEST(drama_genre) THEN "Drama"
      WHEN c5.title_group_nm IN UNNEST(horror_genre) THEN "Horror"
      WHEN c5.title_group_nm IN UNNEST(factual_genre) THEN "Factual"
      WHEN c5.title_group_nm IN UNNEST(comedy_genre) THEN "Comedy"
      WHEN c5.title_group_nm IN UNNEST(reality_genre) THEN "Reality"
      WHEN c5.title_group_nm IN UNNEST(kids_family_genre) THEN "Kids & Family"
      WHEN c5.title_group_nm IN UNNEST(sports_genre) THEN "Sports"
      WHEN c5.title_group_nm IN UNNEST(news_genre) THEN "News"
      WHEN c5.title_group_nm IN UNNEST(other_genre) THEN "Other"

      -- (MD) Other (Catch All) - This bucket includes all the core except core-nfl-window (which gets taken care by cte_5 join) and all undefined Starts
      when c5.title_group_nm in ("Paramount +","undefined","Paramount+") then "Other"
      when c5.title_group_nm like "core%" and c5.title_group_nm not in ("core-nfl-window") then "Other"

      -- 1.5 Get Originals Genre from the table
      when (c3.title is not null or c3.title_id is not null) then c3.genre_nm

      -- 2. "Core" or undefined
      WHEN LOWER(TRIM(c5.title_group_nm)) LIKE "core%" AND LOWER(TRIM(c5.title_group_nm)) NOT IN ("core-nfl-window") THEN "Other"

      -- 3. Sports logic
      when c7.genre_nm = "Sports" then "Sports"
      when (UPPER(c5.title_group_nm) like "%SPORTS%")
        and (c5.title_group_nm not in ("KHOU 11 Sports Extra"))
        and ((c5.primary_genre_nm is null)
        or (c5.primary_genre_nm = "News & Sports")
        or (c5.secondary_genre_nm = "Sports"))
      then "Sports"
      WHEN (c5.secondary_genre_nm = "Sports" AND LOWER(TRIM(c5.title_group_nm)) NOT IN ("local news", "we need to talk"))
      THEN "Sports"

      -- 4. News logic
      when c7.genre_nm = "News" then "News"
      when
        (UPPER(c5.title_group_nm) like "%NEWS%")
        and ((c5.primary_genre_nm is null) 
            or (c5.primary_genre_nm = "News & Sports")
            or (c5.secondary_genre_nm = "News")) 
      THEN "News"
      WHEN c5.secondary_genre_nm = "News"
          OR (
            REGEXP_CONTAINS(LOWER(c5.title_group_nm), r'news|this morning|good morning')
            OR REGEXP_CONTAINS(c5.title_group_nm, r'^(K|W)[A-Z0-9]{2,}')  -- station codes
            OR REGEXP_CONTAINS(c5.title_group_nm,   r'(?i)on\s+(K|W)[A-Z0-9-]{2,}\s*\d{1,3}')  -- station codes
          )
        THEN "News"

      -- 5. Use most frequent genre if not null
      WHEN c7.genre_nm IS NOT NULL THEN c7.genre_nm

      -- 6. Default
      WHEN (c7.genre_nm is null and c5.primary_genre_nm IS NOT NULL) then c5.primary_genre_nm
      ELSE "Other"
    end as genre_nm,

      --------------------------
      --------- Brands ---------
      --------------------------
      case
        when c9.brand is not null then c9.brand 
        when c5.brand is not null then c5.brand
        else "Other"
      end as brand_nm,

      --------------------------
      --------- Metrics ---------
      --------------------------
      subscription_guid,
  from cte_5_starts_data c5
  -- (CBS Current) Join all content type based on content id, season number, and cbs current window
  left join cte_2_cbs_current_seasons c2
  on
    c5.title_id = c2.title_id 
    -- and (c5.video_season_nbr is null OR c5.video_season_nbr = c2.video_season_nbr) --if null seasons fall within the window, will be current
    and c5.activation_dt between c2.season_premiere_dt and c2.slam_season_window_end

  left join cte_3_original_seasons_only c3
  on
    c5.title_id = c3.title_id 
    -- (MD) For titles that are always original, keep no min date range scan, for turned originals, start counting from premiere date onwards
    and c5.activation_dt >=
      case
        when c3.original_conversion_flag = "Always Original" then START_DATE
        else c3.premeire_dt
      end
  
  -- (CBS Library) Join all CBS titles at title_id level
  left join cte_1_cbs_titles c1
  on
    c5.title_id = c1.title_id

  -- (Genre Corrections) correcting incorrect or null genres
  LEFT JOIN cte7_top_genres_by_title c7
  ON 
    c5.title_group_id = c7.title_group_id
  
  LEFT JOIN cte_9_top_brand_by_title c9
  ON 
    c5.title_group_id = c9.title_group_id
  group by all
)

select
*,
  case
      when content_category in (
        "Library Specials",
        "Library Other",
        "Library Series",
        "Library Movies",
        "CBS Library")
      then "Library"
      else content_category
  end as content_category_aggregated
from cte8_content_categories_classified
);

