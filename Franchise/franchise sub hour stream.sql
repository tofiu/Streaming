SELECT --day_dt, 
distinct
       case when reporting_series_nm in ('1883',
'Yellowstone',
'Mayor of Kingstown') then 'Taylor Sheridan'
       when reporting_series_nm in ('Evil',
'The Good Wife',
'The Good Fight') then 'The Kings'
       when reporting_series_nm in ('Scream',
'Scream 2',
'Scream 3',
'Scream 4',
'Scream (2022)') then 'Scream'
       when reporting_series_nm in ("Terminator: Dark Fate",
"Terminator Genisys") then 'Terminator'
       when reporting_series_nm in ('Bumblebee',
'Transformers: Dark of the Moon',
'Transformers: Revenge of the Fallen',
'Transformers: Age of Extinction',
'Transformers: Dark Of The Moon',
'Transformers: The Last Knight') then 'Transformers'
       when reporting_series_nm in ('Jackass','Jackass Presents: Bad Grandpa .5',
'Jackass 2.5',
'Jackass Forever',
'Jackass: The Movie',
'Jackass Presents: Bad Grandpa Extended Version',
'Jackass 3',
'Jackass 3.5',
'Jackass Number Two',
'Jackass Presents: Bad Grandpa') then 'Jackass'
       when reporting_series_nm in ('A Quiet Place',
'A Quiet Place Part II') then 'A Quiet Place'
       when reporting_series_nm in ('Avatar: the Last Airbender',
'The Legend of Korra') then 'Avatar'
       when reporting_series_nm in ('Ink Master',
'Ink Master Angeles',
'Ink Master Redemption') then 'Ink Master'
       when reporting_series_nm in ('The Loud House',
'Loud House Christmas') then 'Loud House'
       when reporting_series_nm in ('Beavis & Butt-Head',
'Beavis & Butt-Head Do America') then 'Beavis & Butt-Head'
       when (reporting_series_nm in ('Indiana Jones and the Raiders of the Lost Ark',
"The Young Indiana Jones Chronicles - Treasure of the Peacock's Eye",
"The Young Indiana Jones Chronicles - Travels with Father",
"The Young Indiana Jones Chronicles - Masks of Evil",
"The Young Indiana Jones Chronicles - Hollywood Follies",
"The Young Indiana Jones Chronicles - Attack of the Hawkmen",
'Indiana Jones and the Temple of Doom',
'Indiana Jones and the Last Crusade',
'Indiana Jones and the Kingdom of the Crystal Skull') or reporting_series_nm like '%The%Young%Indiana%Jones%Chronicles%') then 'Indiana Jones'
       when reporting_series_nm in ('Indiana Jones and the Raiders of the Lost Ark',
'Indiana Jones and the Temple of Doom',
'Indiana Jones and the Last Crusade',
'The Young Indiana Jones Chronicles',
'Indiana Jones and the Kingdom of the Crystal Skull') then 'Indiana Jones'
       when reporting_series_nm in ('Paranormal Activity 3' ,
'Paranormal Activity 2' ,
'Paranormal Activity 4' ,
'Unknown Dimension: The Story Of Paranormal Activity' ,
'Paranormal Activity: The Ghost Dimension'  ,
'Paranormal Activity: Next of Kin'  ,
'Paranormal Activity: The Marked Ones'  ,
'Unknown Dimension: The Story of Paranormal Activity' ,
'Paranormal Activity') then 'Paranormal Activity'
       when (reporting_series_nm in ('Sonic Christmas Blast',
'Sonic Underground',
'Sonic the Hedgehog ',
'Adventures of Sonic the Hedgehog',
'Sonic the Hedgehog') or reporting_series_nm like '%Sonic%the%Hedgehog%') then 'Sonic'
       when reporting_series_nm in ('Bob the Builder: A Christmas to Remember',
'Bob The Builder',
'Bob the Builder (Classic)',
'Bob the Builder On Site: Green Homes & Recycling',
'Bob the Builder On Site: Houses & Playgrounds',
'Bob the Builder On Site: Roads and Bridges',
'Bob the Builder On Site: Skyscrapers',
'Bob the Builder On Site: Trains & Treehouses',
'Bob the Builder Snowed Under: The Bobblesberg Winter Games',
"Bob the Builder: Bob's Big Plan",
'Bob the Builder: Built to be Wild',
'Bob the Builder: Knights of Can-A-Lot',
'Bob the Builder: Mega Machines',
'Bob the Builder: Race to the Finish',
'Bob the Builder: Scrambler to the Rescue',
'Bob the Builder: The Big Dino Dig',
'Bob the Builder: The Legend of the Golden Hammer',
'Bob the Builder: When Bob Became a Builder') then 'Bob the Builder'
       when reporting_series_nm in ('SOUTH PARK: POST COVID',
'South Park',
'SOUTH PARK: POST COVID: THE RETURN OF COVID',
'South Park: Bigger, Longer, & Uncut') then 'SOUTH PARK'
       when reporting_series_nm in ('60 Minutes',
'60 Minutes+') then '60 Minutes'
       when reporting_series_nm in ('At The Jersey Shore',
'Snooki & JWOWW',
'Jersey Shore',
'Jersey Shore: Family Vacation') then 'Jersey Shore'
       when (reporting_series_nm in ('RENO 911! ',
'Reno 911! The Hunt for QAnon') or lower(reporting_series_nm) like '%reno%911%') then 'Reno 911'
       when reporting_series_nm in ('The Late Show with Stephen Colbert',
'The Late Late Show with James Corden') then 'The Late Show'
       when reporting_series_nm in ("Blue's Clues & You",
"Blue's Clues") then "Blue's Clues"
       when reporting_series_nm in ('Dora the Explorer',
'Dora and Friends', 'Dora and Friends: Into the City!',
'Go Diego Go!') then 'Dora'
       when reporting_series_nm in ('JoJo Siwa: My World',
'The J Team',
"JoJo's Follow Your D.R.E.A.M",
"JoJo's D.R.E.A.M Concert",
"JoJo's Dream Birthday") then 'JoJo Siwa'
       when reporting_series_nm in ("The Strawberry Shortcake Movie: Sky's the Limit",
"Strawberry Shortcake's Berry Bitty Adventures",
'Strawberry Shortcake: A Berry Grand Opening') then 'Strawberry Shortcake'
       when (reporting_series_nm in ('The SpongeBob Movie: Sponge Out of Water',
'The SpongeBob Musical', 'The SpongeBob Musical: Live on Stage!',
'SpongeBob SquarePants',
'The SpongeBob Movie: Sponge On The Run',
'SpongeBob As Told By',
"Kamp Koral: SpongeBob's Under Years",
'Spongebob Docupants') or reporting_series_nm like '%SpongeBob') then 'SpongeBob'
       when reporting_series_nm in ('Star Trek Beyond',
'Building Star Trek',
'Star Trek',
'Star Trek - Star Trek Day',
'Star Trek - The Original Series',
'Star Trek (2009)',
'Star Trek II: The Wrath of Khan',
'Star Trek III: The Search for Spock',
'Star Trek Into Darkness',
'Star Trek IV: The Voyage Home',
'Star Trek IX: Insurrection',
'Star Trek V: The Final Frontier',
'Star Trek VI: The Undiscovered Country',
'Star Trek VII: Generations',
'Star Trek VIII: First Contact',
'Star Trek X: Nemesis',
'Star Trek: Deep Space Nine',
'Star Trek: Discovery',
'Star Trek: Enterprise',
'Star Trek: Generations',
'Star Trek: Lower Decks',
'Star Trek: Picard',
'Star Trek: Prodigy',
'Star Trek: Short Treks',
'Star Trek: Strange New Worlds',
'Star Trek: The Animated Series',
'Star Trek: The Motion Picture',
"Star Trek: The Motion Picture - The Director's Edition",
'Star Trek: The Next Generation',
'Star Trek: The Original Series (Remastered)',
'Star Trek: Voyager',
'Woman In Motion: Nichelle Nichols, Star Trek and the Remaking of NASA') then 'Star Trek'
       when reporting_series_nm in ('FBI',
'FBI: Most Wanted',
'FBI International') then 'FBI'
       when reporting_series_nm in ("NCIS: The Cases They Can't Forget",
'NCIS',
'NCIS: Los Angeles',
'NCIS: New Orleans',
"NCIS: Hawai'i") then 'NCIS'
       when reporting_series_nm in ('MacGyver',
'MacGyver Classic') then 'MacGyver'
       when reporting_series_nm in ('Survivor',
'Survivor: Cagayan') then 'Survivor'
       when reporting_series_nm in ('Hawaii Five-0',
'Hawaii Five-0 (Classic)') then 'Hawaii Five-0'
       when reporting_series_nm in ('Twilight Zone',
'The Twilight Zone Classic',
'The Twilight Zone',
'The Twilight Zone (B/W)') then 'Twilight Zone'
       when reporting_series_nm in ('PAW Patrol',
'PAW Patrol: The Movie',
'PAW Patrol Live! At Home',
'Paw Patrol: Ready, Race, Rescue!',
'Paw Patrol: Mighty Pups') then 'PAW Patrol'
       when reporting_series_nm in ('A Fairly Odd Christmas',
'A Fairly Odd Summer',
'The Fairly OddParents: Fairly Odder',
'A Fairly Odd Movie: Grow Up, Timmy Turner!',
'The Fairly OddParents') then 'Fairly OddParents'
       when reporting_series_nm in ('The Real World', 'The Real World Homecoming',
'The Real World Homecoming: New York',
'The Real World Homecoming: Los Angeles',
'The Real World Homecoming: New Orleans') then 'The Real World'
       when (reporting_series_nm in ('Sam & Cat') or reporting_series_nm like '%iCarly%') then 'iCarly'
       when reporting_series_nm in ('Teen Mom',
'Teen Mom 2',
'Teen Mom 3',
'Teen Mum',
'Teen Mom: Young & Pregnant') then 'Teen Mom'
       when reporting_series_nm in ('The Challenge',
'The Challenge: All Stars',
'The Challenge: Champs vs. Stars') then 'The Challenge'
       when (reporting_series_nm in ('All Grown Up') or reporting_series_nm like '%Rugrats%') then 'Rugrats'
       when reporting_series_nm in ('The Comedy Central Roast of Flavor Flav',
'The Comedy Central Roast of Donald Trump',
'The Comedy Central Roast of David Hasselhoff',
'The Comedy Central Roast of Rob Lowe',
'The Comedy Central Roast Of James Franco',
'The Comedy Central Roast of Justin Bieber',
'The Comedy Central Roast of Bruce Willis',
'The Comedy Central Roast of Charlie Sheen',
'The Comedy Central Roast of William Shatner',
'The Comedy Central Roast of Alec Baldwin',
'Hall of Flame: Top 100 Comedy Central Roast Moments',
'Best of the Comedy Central Roast',
'The Comedy Central Roast of Bob Saget',
'The Comedy Central Roast of Pamela Anderson') then 'Comedy Central Roasts'
       when reporting_series_nm in ('The Offer',
'The Godfather',
'The Godfather, Part II',
'The Godfather, Part III',
"The Godfather Coda (Coppola's Coda)") then 'The Godfather'
       when reporting_series_nm in ('Big Brother',
'Celebrity Big Brother',
'Big Brother: Over the Top') then 'Big Brother'
       when reporting_series_nm in ("RuPaul's Drag Race", "RuPaul's Drag Race All Stars",
"RuPaul's Drag Race: All Stars",
"RuPaul's Drag Race: UNTUCKED",
"RuPaul's Drag Race All Stars Untucked",
'Queen of the Universe',
'Dragging the Classics') then 'RuPaul'
       when reporting_series_nm in ('The Daily Show',
'The Daily Show with Trevor Noah: Global Edition',
'The Daily Show with Trevor Noah') then 'The Daily Show'
       when reporting_series_nm in ('CSI: Miami',
'CSI: NY',
'CSI: Crime Scene Investigation',
'CSI: Cyber') then 'CSI'
       when reporting_series_nm in ('Love & Hip Hop','Love & Hip Hop Miami',
'Love & Hip Hop Atlanta',
'Love & Hip Hop Hollywood') then 'Love & Hip Hop'
       when reporting_series_nm in ('Mission: Impossible', 'Mission Impossible',
'Mission: Impossible II',
'Mission: Impossible III',
'Mission: Impossible - Rogue Nation',
'Mission: Impossible - Ghost Protocol',
'Mission: Impossible - Fallout') then 'Mission Impossible' else null end franchise,
       --count(DISTINCT v69_registration_id_nbr) AS subscribers,
       --sum(video_start_cnt) as streams, 
       --sum(video_total_time_sec_qty/3600) as hours
FROM dw_vw.aa_video_detail_reporting_day 
WHERE v69_registration_id_nbr IS NOT NULL
    AND day_dt BETWEEN '2022-01-01' AND '2022-05-15'
  and reporting_content_type_cd in ('FEP', 'MOVIE')
  AND report_suite_id_nm NOT IN ('cbsicbsau', 'cbsicbsca', 'cbsicbstve')
  AND LOWER(subscription_state_desc) IN ("trial", "sub", "discount offer")
--GROUP BY 1
--ORDER BY 2 DESC
