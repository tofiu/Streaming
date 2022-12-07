SELECT distinct 
genre,
brand_nm1,
reporting_series_nm,
video_season_nbr,
sum(content_hours)

from  (
SELECT distinct
genre,
CASE 
		WHEN (
		(
			lower(a.category_level1_nm) like '%original%'
			OR a.reporting_Series_nm in ('The Twilight Zone', 'Coyote',
									"The Real World Homecoming: New York",
									"The SpongeBob Movie: Sponge On The Run",
									"Kamp Koral: SpongeBob's Under Years",
                  "From Cradle to Stage",
                  "Infinite",
                  "Behind The Music",
				  "Dragging The Classia: The Brady Bunch",
				  "KACEY MUSGRAVES | star-crossed : the film",
				  "26th Street Garage: The FBI's Untold Story Of 9/11",
				  "The J Team",
				  "Console Wars",
				  "Queenpins",
				  "Madame X",
          "Star Trek: Prodigy",
          "Paranormal Activity: Next of Kin",
          "Clifford the Big Red Dog",
          "Oasis Knebworth 1996",
          "The Real World Homecoming: Los Angeles",
          "The Real World Homecoming",
          "SOUTH PARK: POST COVID",
          "A Loud House Christmas",
		       "Reno 911! The Hunt for QAnon",
		       'Rumble',
          '1883',
           "The Envoys",
           "The Marfa Tapes - Jack Ingram, Miranda Lambert, Jon Randall",
           "Big Nate",
           "Queen of the Universe",
           "The In Between",
           "Scream (2022)",
		   "Halo",
		   "iCarly",
       "The Fairly OddParents: Fairly Odder",
       "Jackass Forever",
	   "Cecilia",
	   "Parot",
	   "Before I forget",
	   "Rugrats",
	   "Rugrats (2021)",
		 "The Lost City",
		 "Sonic the Hedgehog 2",
		 "SOUTH PARK THE STREAMING WARS",
		 "Joe Pickett",
		 "The Challenge: All Stars",
		 "YO! MTV Raps",
		 "Mayor of Kingstown",
		 "Love, Tom",
		 "Hip Hop My House",
		 "Jerry & Marge Go Large",
   "Cat Pack: A PAW Patrol Exclusive Event",
	 "Secrets of the Oligarch Wives",
"All Star Shore",
"Beavis And Butt-Head Do The Universe",
"76 Days",
"Destination Porto: The Unimaginable Journey",
"Clive Davis: Most Iconic Performances"  ,
"Secret Headquarters" ,
"Honor Society",
"Orphan: First Kill",
"Ascension",
"My Dream Quinceañera",
"Blue's Big City Adventure",
"Significant Other",
"Destination Paris",
"Snow Day",
"Criminal Minds: Evolution",
"Transformers: EarthSpark",
"On the Come Up",
"11 Minutes",
"Tulsa King",
"When You Least Expect It",
"Mike Judge's Beavis & Butt-Head",
"Fantasy Football"

                  )
			OR a.video_title in (	"The SpongeBob Movie: Sponge On The Run","Infinite",'A Quiet Place Part II',"PAW Patrol: The Movie", "The J Team" )
		--	   OR (lower(a.reporting_Series_nm) like '%rugrats%'and a.video_season_nbr = '1' and a.video_air_dt >= '2021-05-27')
         --OR (lower(a.reporting_Series_nm) like '%icarly%' and a.video_season_nbr = '1' and a.video_air_dt >= '2021-06-01' )
         OR (lower(a.reporting_Series_nm) = 'evil' and  video_available_dt >= '2021-06-01')
          OR (lower(a.reporting_Series_nm) = 'seal team' and  video_available_dt >= '2021-10-01')
         OR (a.reporting_Series_nm like "RuPaul%Drag%Race%All%Stars"and  a.video_air_dt >= '2021-06-24') -- and a.video_season_nbr > '6'
         OR (a.reporting_Series_nm like "RuPaul%Drag%Race%All%Stars%Untucked" and a.video_air_dt >= '2021-06-24') --and a.video_season_nbr = '3'
				OR (lower(a.reporting_Series_nm) = 'ink master'and a.video_air_dt >= '2022-09-07') --and a.video_season_nbr = '14' 
				OR ((a.reporting_Series_nm) = 'Inside Amy Schumer'and a.video_air_dt >= '2022-10-06')
        -- including trailer clips--
		OR a.video_title like "The SpongeBob Movie: Sponge On The Run%"
		OR a.video_title like "Infinite%"
		OR a.video_title like "A Quiet Place Part II%"
		OR a.video_title like "PAW Patrol: The Movie%"
		OR a.video_title like "26th Street Garage: The FBI's Untold Story Of 9/11%"
		OR a.video_title like "KACEY MUSGRAVES | star-crossed : the film%"
		OR a.video_title like "Kamp Koral: SpongeBob's Under Years%"
		OR a.video_title like "From Cradle to Stage%"
		OR a.video_title like "Behind The Music%"
		OR a.video_title like "Dragging The Classia: The Brady Bunch%"
		OR a.video_title like "The J Team%"
		OR a.video_title like "Console Wars%"
		OR a.video_title like "Queenpins%"
		OR a.video_title like "Madame X%"
    OR a.video_title like "Star Trek: Prodigy%" 
    OR a.video_title like "Paranormal Activity: Next of Kin%" 
    OR a.video_title like "Clifford the Big Red Dog%" 
    OR a.video_title like "Oasis Knebworth 1996%" 
    OR a.video_title like "The Real World Homecoming: Los Angeles%" 
    OR a.video_title like "The Real World Homecoming%"
    OR upper(a.video_title) like "SOUTH PARK: POST COVID%"
    OR a.video_title like "A Loud House Christmas%"
    OR a.video_title like "Reno 911! The Hunt for QAnon%"
    OR a.video_title like "Rumble%"
    OR a.video_title like "1883%"
    OR a.video_title like "The Envoys%"
    OR a.video_title like "The Marfa Tapes%"
    OR a.video_title like "Big Nate%"
    OR a.video_title like "Queen of the Universe%"
    OR a.video_title like "The In Between%"
  	OR a.video_title like "Scream (2022)%"
	OR a.video_title like "Halo%"
  	OR a.video_title like "The Fairly OddParents: Fairly Odder%"
    OR a.video_title like "Jackass Forever%"
	OR a.video_title like "Cecilia%"
	OR a.video_title like "Parot%"
	OR a.video_title like "Before I forget%"
	OR a.video_title like "The Lost City%"
	OR a.video_title like "Sonic the Hedgehog 2%"
	OR a.video_title like "SOUTH PARK THE STREAMING WARS%"
	OR a.video_title like "Joe Pickett%"
	OR a.video_title like "The Challenge: All Stars%"
	OR a.video_title like "Mayor of Kingstown%"
	OR a.video_title like "Love, Tom%"
	OR a.video_title like "Hip Hop My House%"
	OR a.video_title like "Jerry & Marge Go Large%"
	OR a.video_title like "Cat Pack: A PAW Patrol Exclusive Event%"
	OR a.video_title like "Secrets of the Oligarch Wives%"
	OR a.video_title like "All Star Shore%"
	OR a.video_title like"Beavis And Butt-Head Do The Universe%"
	OR a.video_title like"76 Days%"
	OR a.video_title like "Destination Porto: The Unimaginable Journey%"  
	OR a.video_title like "Clive Davis: Most Iconic Performances%"   
 	OR a.video_title like "Secret Headquarters%" 
	OR a.video_title like "Honor Society%"
	OR a.video_title like "Orphan: First Kill%"
	OR a.video_title like 	"Ascension%"
	OR a.video_title like "My Dream Quinceañera%"
	OR a.video_title like "Blue's Big City Adventure%"
	OR a.video_title like "Significant Other%"
	OR a.video_title like "Destination Paris%"
	OR a.video_title like "Snow Day%"
	OR a.video_title like "Criminal Minds: Evolution%"
	OR a.video_title like "Transformers: EarthSpark%"
	OR a.video_title like "On the Come Up%"
	OR a.video_title like "11 Minutes%"
	OR a.video_title like "Tulsa King%"
	OR a.video_title like "When You Least Expect It%"
	OR a.video_title like "Mike Judge's Beavis & Butt-Head%"
	OR a.video_title like "Fantasy Football%"

			)
		AND a.reporting_Series_nm NOT IN ('Star Trek', '60 Minutes','Sunday Morning')
		and lower(a.reporting_Series_nm) NOT like  '%big%brother%'
		)
			THEN 'P+ Originals'

			WHEN lower(video_aquisition_partner_cd) IN ('showtime')
					THEN 'Showtime'
		WHEN (lower(video_aquisition_partner_cd) IN ('bet')OR 
			  lower(a.reporting_Series_nm) in ('moesha', 'the game','everybody hates chris'))
			THEN 'BET'
		WHEN (lower(video_aquisition_partner_cd) LIKE '%nick%' or 
			  (a.reporting_Series_nm) in ('PAW Patrol: Jet to the Rescue') 
				or  a.video_title in ('Legends of the Hidden Temple')
        AND not ((lower(a.reporting_Series_nm) like '%rugrats%'
and a.video_season_nbr = '1' and a.video_air_dt >= '2021-05-27'))
			  )
			THEN 'Nickelodeon'
		WHEN lower(video_aquisition_partner_cd) IN ('smithsonian channel')
			THEN 'Smithsonian'
		WHEN( lower(video_aquisition_partner_cd) IN ('mtv')
    AND  LOWER(a.reporting_series_nm) NOT in ("From Cradle to Stage")
    )
			THEN 'MTV'
		WHEN lower(video_aquisition_partner_cd) IN ('vh1')
			THEN 'VH1'
		WHEN lower(video_aquisition_partner_cd) IN ('comedy central')
			THEN 'Comedy Central'
		WHEN lower(video_aquisition_partner_cd) IN ('tv land')
			THEN 'TV Land'
		WHEN lower(video_aquisition_partner_cd) IN ('epix')
			THEN 'Epix' 
		WHEN (lower(video_aquisition_partner_cd) IN ('paramount') 
           and ( lower(a.category_level1_nm) like '%movies%'	OR 	lower(a.reporting_series_nm) like '%movies%' or  upper(reporting_content_type_cd) in ('MOVIE'))
           OR (a.video_title) in ('Game of Death')  
           )  
			THEN 'Paramount Movies'
		WHEN ((lower(video_aquisition_partner_cd) IN ('paramount')and upper(reporting_content_type_cd) not in ('MOVIE'))
				OR lower(video_aquisition_partner_cd) IN ('cmt')
				 OR (a.reporting_series_nm) in ('Ink Master')
			)
			THEN 'MEG Other'
		WHEN (
				a.mpx_reference_guid IN (
					'70C7B4F3-E4B7-13C3-0A99-E1A1C2DE72CD', --old Live TV 
					'_55cL7EscO2mdFcpsZVcQ3VtXNA5bcA_', --New Live TV 
					'55cL7EscO2mdFcpsZVcQ3VtXNA5bcA' --Incorrect ID but has data for New Live TV, once data team backfills for August, can be removed
					) 
				)
			THEN 'CBS Local TV'
		WHEN (
				a.mpx_reference_guid IN (
					'C4552942-B263-B8ED-C2AD-612113A59478', --old CBSN
					'DKvhjg_qfZvElkdc8uTphelhywGy8eIB', --new CBSN
					'vn4vERdyJhcFf688ZEsPEWc6b943_FW8', --Sports HQ
					'nGca_Qs4Sw2D_qz3Y7LwbK_4LcHtFWBf', --New Sports HQ
					'Ay_yNGGsaAER0p53Vayq7p6ehANP1Xy_', -- ET Live
					'PIeTZr_epWoWAPvJ6p1bP0KG8l2XzCai' --ET Live 
					)
				OR  upper(a.category_level1_nm) in ('LIVE STREAMING')
				OR lower(a.reporting_series_nm) IN ( 'cbsn live stream') 
				OR lower(a.reporting_series_nm) like '%live feed%' 
				)
			THEN 'Live Channels/Feeds'
		WHEN ((   LOWER(coalesce(video_aquisition_partner_cd,a.brand_desc)) IN ('cbs', 'cbs news','cbs sports')
     OR (lower(a.reporting_series_nm)  = 'evil' and  video_available_dt < '2021-06-01')
        OR (lower(a.reporting_Series_nm) = 'seal team' and  video_available_dt < '2021-10-01')
			OR(   LOWER(coalesce(video_aquisition_partner_cd,a.brand_desc)) Is null and 
				  lower(a.category_level1_nm) IN ('classic','primetime','cbs evening news',
						'the fbi declassified','saturday morning','sunday morning',
						'primetime current season','primetime prior seasons','the takeout',
						'cbsn','news','daytime','specials','classic new classic','60 minutes',
						'late night','face the nation','cbs this morning','cbs news specials',
						'cbsn am','golf' )
      )	
		)	AND UPPER(a.category_level1_nm) NOT IN ('AA MOVIES', 'AA ORIGINALS','LIVE STREAMING')
		AND ( LOWER(a.reporting_series_nm) not in ('moesha', 'the game','everybody hates chris'))
		)
			THEN 'CBS VOD'
		WHEN  ( a.reporting_series_nm in ('60 Minutes','Big Brother','Sunday Morning','The Masters','Hockey on CBS All Access') OR 
		lower(a.reporting_series_nm)  like '%uefa%')
		THEN 'CBS VOD'
		ELSE 'Others'
		END AS brand_nm1,    
a.reporting_series_nm,
case when a.reporting_content_type_cd in ("MOVIE") then 'MOVIE' else a.video_season_nbr end as video_season_nbr,
a.video_title,
max(a.length_in_seconds)/3600 content_hours

    --   count(distinct v69_registration_id_nbr) active_sub_hh,
   --    count(distinct case when video_content_duration_sec_qty >= 120 then v69_registration_id_nbr end) intended_active_sub_hh,
     --  SUM(video_content_duration_sec_qty)/3600 AS hours
FROM  ent_vw.mpx_video_content_enhanced a left join `i-dss-ent-data.temp_dj.show_genre_mapping_wo_live` b on lower(trim(a.reporting_series_nm))=lower(trim(b.show)) 
where reporting_content_type_cd in ("MOVIE","FEP") and video_available_dt <='2022-11-30' group by 1,2,3,4,5) where video_season_nbr is not null 
and reporting_series_nm != '-' 
group by 1,2,3,4
