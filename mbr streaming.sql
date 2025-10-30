--[JZ] 9/29/25 - IR Solution for Consumption Using Title Matching

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
 "Forensic Files", "Matter of Fact With Soledad O'Brien", "True Crime: Identity Theft", "Storm of Suspicion", "InvestigateTV+", "InvestigateTV+ Weekend", "Forensic Factor", "Ocean Mysteries With Jeff Corwin", "Weather Gone Viral", "The CIA: Race Against Time -- The True Story of the CIA and 9/11", "America by Design", "Protecting Life on Earth", "Climate Watch: Overheated", "Our America: Mission Montford Point", "Unsung Heroes: The Story of America's Female Patriots", "Eye on Northwest Politics", "Inside Texas Politics", "Full Court Press With Greta Van Susteren", "Eye on Retirement", "Eye on the Future", "Inside West Virginia Politics", "Inside the Pride", "Inside the Huddle", "Turning Point With Dr. David Jeremiah", "Joel Osteen", "Joel Osteen Ministries", "Elevation with Steven Furtick", "In Touch With Dr. Charles Stanley", "Time of Grace With Pastor Mike Novotny", "The Winning Walk with Dr. Ed Young", "First Baptist Church", "First Baptist Church of Huntsville", "Second Baptist Church", "Dawson Family of Faith", "Ingleside Baptist Church", "Trinity Methodist", "First Presbyterian Church", "Robert Jeffress", "Word of God Ministries", "Key of David", "Mission Messiah Television", "Catch the Truth", "Turning Point", "Joni Table Talk", "The 700 Club", "Hope for Pain Sufferers", "Everyday Heroes", "Everyday Heroes: Veteran's Day", "Everyday Heroes: Our True Colors", "Everyday Heroes: Working Together To Be Stronger", "Everyday Heroes: Thanking Our Heroes", "Women on the Move", "Women on the Move: Year in Review", "Women on the Move: Hispanic Excellence", "Mentoring Kings", "Mentoring Queens", "Beyond Limits", "Together We Are Able", "Operation Smile", "Stories of Love to the Rescue by Shriners Hospitals for Children®", "Transforming Lives by Shriners Hospitals for Children®", "American Valor: A Salute to Our Heroes", "America Honors Our Veterans", "America's Heartland", "America Decides: Campaign '22", "Protect Your Memory", "Ukraine in Crisis!", "Still Missing Morgan", "9/11: 20 Years Later", "The Silent Pandemic: Heart Failure", "Alex Scott: A Stand for Hope", "America’s Bravest Heroes", "SOS: How to Survive", "America’s Bravest Heroes", "America’s Thanksgiving Parade", "Peak of the Week", "America’s Thanksgiving Day Parade", "VAX LIVE: The Concert to Reunite the World", "Broadway and Beyond at the Tonys", "The Broadway Show With Tamsen Fadal", "The Tony Awards Presents: Broadway's Back", "The Tony Awards: Act One", "After Midnight", "WWII Battles in Color", "KABLAM!", "WITS Academy", "WWII's Most Daring Raids", "WWII by Drone", "KEVIN GARNETT: Anything Is Possible", "WRONG PLACE", "WWII : The Long Road Home","Academy of Country Music Awards"

];

DECLARE comedy_genre ARRAY<STRING> DEFAULT [
  "Friends", "Seinfeld", "Two and a Half Men", "Modern Family", "The Goldbergs", "Last Man Standing", "2 Broke Girls", "Comics Unleashed With Byron Allen", "Funny You Should Ask", "Just for Laughs Gags", "Comedy.TV", "The Greatest @Home Videos: The Cedy Awards", "The Nutty Professor", "South Park: The Streaming Wars", "The Simpsons", "You Bet Your Life With Jay Leno", "Richard Pryor", "Bad News Bears (2005)",
"Bad News Bears",
"The Bad News Bears",
"The Bad News Bears in Breaking Training",
"The Bad News Bears Go to Japan"
];

DECLARE reality_genre ARRAY<STRING> DEFAULT [
"Undercover Boss Celebrity Edition", "Catfish: The TV Show", "Wipeout", "Storage Wars", "Pawn Stars", "Im A Celebrity...Get Me Out Of Here", "Fast: Home Rescue", "Flip My Florida Yard", "Designing Spaces", "Raw Travel", "Military Makeover", "Small Town Big Deal", "America by Design", "HomeTown Living", "Ready, Set, Renovate", "The VeryVera Show", "The Texas Bucket List", "Today's Homeowner With Danny Lipford", "Flip Side", "Ready, Race, Rescue", "America’s Heartland" , "Positively Montana", "Destination LA", "Destination Dallas", "Destination Chicago", "Destination Dynasty", "Big Game Cajun Cookin’", "Cribbs in the CLE: Josh and Maria Live", "Real Green", "America’s Thanksgiving Day Parade", "Through the Decades", "Chef Emeril’s Air Fryer Secret + FREE PANS", "The Great Dr. Scott", "Phantom Gourmet", "Made in Hollywood", "Awesome Adventures", "Xploration Outer Space", "Science Now", "Laura McKenzie's Traveler", "Ed Sullivan's Rock n Roll Classics", "Beautiful Homes & Great Estates", "House Stealing - The Latest Cyberthreat and How To Protect Your Home", "MyDestination.TV"
];

DECLARE sports_genre ARRAY<STRING> DEFAULT [
"PBR Camping World Team Series", "2021 PGA Championship", "Academy of Country Music Awards", "PGA Tour Golf", "NFL Today Postgame", "At the Final Four", "Major League Fishing", "Purple Pregame", "FIA Formula E World Championship Racing", "Tailgate 19", "Patriots Game Day", "Lucas Oil Pro Pulling League", "2023 TOUR Championship", "Coppa Italia Frecciarossa", "Rodeo", "Lucas Oil Late Model Dirt Series", "La Liga Premier", "The Thanksgiving Day Pregame Show", "Cornhole", "Rogue Invitational", "PBR Team Series: Road to Vegas", "USL Championship Soccer", "Jim Nantz Remembers Augusta: Mark O'Meara at the Masters", "13 Green Jackets: A Conversation With Tiger Woods, Jack Nicklaus, and Scottie Scheffler", "SEC Wrap Up Show", "Lucas Oil Drag Boat Racing", "The 5th Quarter", "74th Annual Thanksgiving Day Parade", "Bengals Weekly", "Patriots Fifth Quarter", "CBS3 Sunday Kickoff", "Big Orange Kickoff", "The Fifth Quarter", "Monday Night Countdown", "Confidential Conversations: Big Ten Football 2025", "World's Strongest Man", "2025 Women's Rugby World Cup", "The Masters: Jack and Arnie!", "NBA Basketball", "MLB Baseball", "World's Strongest Man 2024", "Boys High School Basketball", "Golf", "CrossFit Games", "Major League Pickleball", "AVP Beach Volleyball", "Drew Pearson: A Football Life", "PGA Championship Preview", "The Masters: The Magnificent 12th", "Changing The Game: Charlie Scott", "The Masters: The Second Nine on Sunday", "Major League Rugby", "The 2023 World's Strongest Man", "Tight End University", "College Football Saturday", "Football Preview", "Bengals Postgame Show", "Saints Football Live Pregame Special", "Sport Zone Sunday", "HBCU Battle of the Bands", "Sporting Classics", "Predators Live! Pregame", "NHL Blues Pre-Game", "Texans 360", "Dallas Cowboys Pre-Game", "Saints Pregame", "Saints Postgame", "Titans Pregame", "NFL End Zone", "Packers Preseason Pregame Show", "Rivals: Ohio State vs. Michigan", "Titans Gameday", "The Big Game Kickoff", "Cowboys Countdown to Kickoff", "Big Orange Kickoff Special", "Vols Basketball Preview Show", "Touchdown Friday Nights", "Red Zone Ready Preseason Special", "NFL Films Highlight Show", "Chiefs Pregame", "Panthers Huddle", "Cardinals Game Plan", "Dolphins Pregame Show", "Bills Kickoff Live", "Jets Gameday", "49ers Experience", "Commanders Kickoff", "Bengals Nation", "Razorback Football with Sam Pittman", "Texans Extra Points", "College Kickoff 2025", "Touchdown in Tampa", "Touchdown 7","News 19 Sports Iron Bowl Pregame Special",
"8 News Now After Sports",
"5NEWS Sports Special: Pregame on the Hill"
];


DECLARE news_genre ARRAY<STRING> DEFAULT [
"InvestigateTV+", "Hard Truths", "Matter of Fact With Soledad O'Brien", "Dateline", "Extra", "Inside Texas Politics", "On Your Side Tonight With Jamie Boll", "Eye on Northwest Politics", "America Decides: Campaign '22", "Capital Connection", "The Issue Is", "Politics Now Las Vegas", "Face the State With Joel D. Smith", "Political Special", "Eye on Politics", "Talk Business and Politics", "Politics Unplugged", "Eye on Northwest Politics: Election Special", "Decision 2022", "Voter's Decide: Debate", "Congressional District 2 Debate", "Voters Decide: Denver Mayoral Debate", "Campaign 2024: Countdown to Election Day", "State of the State", "State of Texas In-Depth", "Nevada Gubernatorial Republican Primary Debate", "Gubernatorial Debate", "Presidential Address to the Joint Session of Congress", "President Biden Address to the Nation", "First Presidential Debate: Hosted by CNN", "Election Headquarters: US Senate Debate", "Inside Edition",
"Entertainment Tonight",
"ET Live"
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
"Academy of Country Music Awards"
  ];

DECLARE theatrical_movies_titles_content_category ARRAY<STRING> DEFAULT [
 
];

DECLARE dts_movies_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE library_movies_titles_content_category ARRAY<STRING> DEFAULT [
"Bad News Bears (2005)",
"Bad News Bears",
"The Bad News Bears",
"The Bad News Bears in Breaking Training",
"The Bad News Bears Go to Japan"
];

DECLARE library_series_titles_content_category ARRAY<STRING> DEFAULT [

];

DECLARE sports_titles_content_category ARRAY<STRING> DEFAULT [
"PBR Camping World Team Series", "2021 PGA Championship", "Academy of Country Music Awards", "PGA Tour Golf", "NFL Today Postgame", "At the Final Four", "Major League Fishing", "Purple Pregame", "FIA Formula E World Championship Racing", "Tailgate 19", "Patriots Game Day", "Lucas Oil Pro Pulling League", "2023 TOUR Championship", "Coppa Italia Frecciarossa", "Rodeo", "Lucas Oil Late Model Dirt Series", "La Liga Premier", "The Thanksgiving Day Pregame Show", "Cornhole", "Rogue Invitational", "PBR Team Series: Road to Vegas", "USL Championship Soccer", "Jim Nantz Remembers Augusta: Mark O'Meara at the Masters", "13 Green Jackets: A Conversation With Tiger Woods, Jack Nicklaus, and Scottie Scheffler", "SEC Wrap Up Show", "Lucas Oil Drag Boat Racing", "The 5th Quarter", "74th Annual Thanksgiving Day Parade", "Bengals Weekly", "Patriots Fifth Quarter", "CBS3 Sunday Kickoff", "Big Orange Kickoff", "The Fifth Quarter", "Monday Night Countdown", "Confidential Conversations: Big Ten Football 2025", "World's Strongest Man", "2025 Women's Rugby World Cup", "The Masters: Jack and Arnie!", "NBA Basketball", "MLB Baseball", "World's Strongest Man 2024", "Boys High School Basketball", "Golf", "CrossFit Games", "Major League Pickleball", "AVP Beach Volleyball", "Drew Pearson: A Football Life", "PGA Championship Preview", "The Masters: The Magnificent 12th", "Changing The Game: Charlie Scott", "The Masters: The Second Nine on Sunday", "Major League Rugby", "The 2023 World's Strongest Man", "Tight End University", "College Football Saturday", "Football Preview", "Bengals Postgame Show", "Saints Football Live Pregame Special", "Sport Zone Sunday", "HBCU Battle of the Bands", "Sporting Classics", "Predators Live! Pregame", "NHL Blues Pre-Game", "Texans 360", "Dallas Cowboys Pre-Game", "Saints Pregame", "Saints Postgame", "Titans Pregame", "NFL End Zone", "Packers Preseason Pregame Show", "Rivals: Ohio State vs. Michigan", "Titans Gameday", "The Big Game Kickoff", "Cowboys Countdown to Kickoff", "Big Orange Kickoff Special", "Vols Basketball Preview Show", "Touchdown Friday Nights", "Red Zone Ready Preseason Special", "NFL Films Highlight Show", "Chiefs Pregame", "Panthers Huddle", "Cardinals Game Plan", "Dolphins Pregame Show", "Bills Kickoff Live", "Jets Gameday", "49ers Experience", "Commanders Kickoff", "Bengals Nation", "Razorback Football with Sam Pittman", "Texans Extra Points", "College Kickoff 2025", "Touchdown in Tampa", "Touchdown 7",   "CBS Sports HQ", "CBS Sports Golazo Network", "Sports Central on CBS Los Angeles", "Courage in Sports: Gridiron Greatness",
  "Sports Xtra", "Sports Stars of Tomorrow", "KC Sports Tonight", "Whacked Out Sports", "Oklahoma Sports Blitz",
  "Sunday Sports Central", "KHOU 11 Sports Extra", "LiUNA! Sports Wrap", "The Nightly Sports Call: Special Edition",
  "Action Sports JAX Primetime", "Greatest Sports Legends: Then and Now", "Wall to Wall Sports", "DraftKings Sportsbook Report",
  "CBS Philadelphia Sports Zone", "SportsWrap", "Sports Final", "Gray Sports World", "Cochran Sports Showdown",
  "KELOLAND Sports Zone", "CBS 3 Sports Zone", "Sports Sunday", "Friday Sports Blitz", "STIHL Timbersports",
  "Inside High School Sports", "WKRG Sports Overtime", "CBS Austin Sports Sunday", "WLKY Sports Saturday",
  "Saturday Sports Extra", "CBS46 Sports Sunday", "Sports Desk", "CBS Sports Confidential: Big Ten Football 2023",
  "Sports Gone Wild", "Sunday Sports Showdown", "CBS46 Sports Saturday", "Action Sports Jax: SEC Tonight",
  "Action Sports Jax: Countdown to Kickoff", "The Sports Authority", "CBS 42 Sports Sunday", "College Sports Xtra",
  "Sports Central", "Action Sports Jax: College Football Tonight", "Sports Overtime", "CBS Sports Spectacular",
  "Sports Zone", "The Best of Greatest Sports Legends: Class of 1977", "SportsWrap With Jason Page",
  "Texas A&M Sports: The Pulse", "DraftKings Sportsbook is Live in NY!", "The Ultimate Florida Sports Show", "Sports Blitz",
  "DraftKings Sportsbook Report - Now Available in North Carolina!", "Audi Sports Desk", "Athletes Unlimited: A Pro Sports Revolution",
  "Action Sports JAX: Battle at the Border Georgia vs. Florida Postgame", "Action Sports Jax: Friday Night Blitz",
  "Scripps Sports Saturday Showdown Postgame", "Action Sports Jax: First & Ten Training Camp",
  "Action Sports Jax: Monday NIght Football Post Game Show", "Sports Zone Saturday", "Sports Wrap",
  "Action Sports Jax: Jacksonville Jaguars Preseason Postgame Show", "DraftKings Casino and Sportsbook Report",
  "Greatest Sports Legends", "Salt Water Sportsman National Seminar Series", "Action Sports Jax: Countdown to Kickoff, Monday NIght Football",
  "Action Sports Jax: Preseason Football Postgame", "CBS Sports Network Live", "Action Sports Jax SEC Championship Post Game",
  "Action Sports Jax - Jags Report Live", "Action Sports JAX: Battle at the Border Postgame", "Inside LSU Sports", "9 Sports Extra",
  "KELOLAND Sportszone HS Football Preview", "Special Olympics: Where Sports Mean More", "Sports Central: Countdown to Kickoff",
  "Action Sports Jax: First and Ten", "WAFB 9 Sportsline Friday Night", "Action Sports Jax: Jaguars Preseason Pregame Show",
  "The Best of Greatest Sports Legends: Class of 1988", "LevelNext EA Sports FIFA 22 College National Championship",
  "The Best of Greatest Sports Legends", "Action Sports Jax: Jaguars Preseason Postgame Show", "Action Sports Jax: Chase For The Championship",
  "The Best of Greatest Sports Legends: Class of 1987", "13 Sports Special", "The Best of the Greatest Sports Legends",
  "Elk Grove Plumbing & Drain Sports Sunday", "The Best of Greatest Sports Legends: Class of 1990", "Wall to Wall Sports Extra",
  "Sports Central Presents: Never Give Up", "CBS Philadelphia Sports Zone: Go Birds", "TN Sports Hall of Fame", "HS Sports Xtra",
  "Altamaha River Sportsman", "Sports Special", "Hometown Sports", "KCCI 8 Sports: U of Iowa Football Pregame Show",
  "High School Sports Xtra", "The Best of Greatest Sports Legends: Class of 1981", "WWL Sports Special: LSU Post Show",
  "Action Sports Jax: Jacksonville Jaguars Preseason Pregame Show", "Action Sports JAX: Battle at the Border Pregame",
  "Scripps Sports Saturday Showdown Pregame", "The Best of Greatest Sports Legends: Class of 1989",
  "Action Sports Jax: Preseason Football Pregame", "RVA Sports Awards", "OU Sports Programming", "Staycation: Sports Edition",
  "Florida Sportsman Watermen", "UConn Winter Sports Special", "KC Sports Tonight: In the Paint", "KCCI Sports: NFL Preview Special",
  "KKTV 11 Sports Bracket Breakdown", "The Best of Greatest Sports Legends: Class of 1976", "Action Sports Jax: Making of a Champion",
  "The Best of Greatest Sports Legends: Class of 1984", "KELOLAND Sportszone HS Basketball Preview",
  "WWL Local Sports Special: Ultimate New Orleans Sports Show", "Sports Zone 12: Egg Bowl Preview", "KCCI 8 Sports: Road to Final Four",
  "CBS Philadelphia Sports Zone: Truist Championship", "KCCI Sports: Caitlin Clark Fever", "The Best of Greatest Sports Legends: Class of 1983",
  "The Best of Greatest Sports Legends: Class of 1982", "UCONN Fall Sports Special", "KCCI 8 Sports: CyHawk Showdown",
  "Action Sports Jax: Jags 2021 NFL Draft Special", "UCONN Spring Sports Spotlight", "Kingdom Rising: Eyewitness Sports Special",
  "CBS3 Sports Zone: Playoff Edition", "Action Sports Jax: At the Players", "Action Sports JAX: Florida Georgia Countdown to Kickoff",
  "FOX Sports Ohio Opening Day Pregame Show", "Action Sports Jax: NFL Season Preview", "KCCI 8 Sports Road To The Final Four: Last Stop",
  "The Best of Greatest Sports Legends: Class of 1980", "WTOL 11 Sports: Teeing off the Dana",
  "DraftKings Sportsbook Report - Now Available in Washington DC!", "CBS3 Sports Zone: Hoop Mania",
  "Action Sports Jax: College Football Preview", "The Best of Greatest Sports Legends: Class of 1974", "KCCI Sports Road to the Final Four",
  "Courage in Sports", "Action Sports Jax: Jags Social", "WTOL 11 Sports Special: The Rivalry", "Action Sports Jax: Jaguars All Access",
  "Sports Spectacular", "KCCI 8 Sports: Chief's Championship Blitz", "College Sports Xtra Preview Show",
  "Sports Zone 12: Ole Miss Road to Omaha", "KCCI 8 Sports: Road to Final Four Sweet Sixteen",
  "The Best of Greatest Sports Legends: Class of 1985", "BBN Gameday - Big Blue Nation UK Sports",
  "13 Sports Special: The Chiefs 2024", "Inside High School Sports 10th Anniversary Special", "Living Room Sports",
  "WWL Sports Special", "KIRO Sports Presents: On Home Ice", "The Best of Greatest Sports Legends: Class of 1975",
  "WTOL 11 Sports: Browns and Lions Chasing Glory", "KIRO 7 Sports Presents Home On Ice", "Sports Extra OT",
  "DraftKings Sportsbook Report - Now Available in Maine!", "KCCI 8 Sports: CyHawk", "Sports Zone Special: SEC Media Day",
  "MTN Sports Presents: A Year to Remember", "WWL Sports Black & Gold Special", "KIRO 7 Sports: Training Camp 2023 Wrap Special",
  "6 Shining Moments: The 6 Sports Year in Review", "WCTV Sports Special: FSU Football Goes to Ireland",
  "Action Sports Jax: 2021 Year End Special", "The Lion's Super Season: A WNEM Sports Special", "Ultimate New Orleans Sports Show",
  "Sports Sunday Early Edition", "Local Sports Special", "Warrick Dunn Sportsline Friday Nite Player of the Year Special",
  "The Best of Greatest Sports Legends: Class of 1979", "Action Sports Jax 2021 College Football Preview",
  "Action Sports Jax Sunday", "KREM 2 Special: Inland Northwest Sports", "Sports Zone Saturday SWAC Championship",
  "Action Sports Jax Jaguars 2021 NFL Preview Special", "KIRO 7 Sports Training Camp 2023 Preview Special",
  "Sports Zone Conference Tip Off", "Action Sports Jax: 2022 Year End Special", "2023 Central Ohio High School Sports Awards",
  "WWL Sports Special: Saints Home Opener", "Warrick Dunn Sportsline Friday Nite Player of the Year", "Oregon Sports Awards",
  "10th Annual Wisconsin Sports Awards Presents History Made", "Action Sports Jax: Tony Boselli HOF Ceremony",
  "Sports Zone Saturday: Preview Ole Miss vs. Auburn", "The High School Sports Awards", "Ultimate Florida Sports Show",
  "WBTW Sports Special - High School Blitz Awards Show", "Sports Daily", "Eyewitness Sports Presents: Thunder In The Poconos",
  "Action Sports JAX Primetime: Blitzie Awards", "Sports Zone Special: Egg Bowl Preview", "NEA Sports Preseason Basketball Show",
  "MTN Fall Sports Special", "Action Sports Jax: Blitzies Award Show", "KELOLAND Sportszone High School Football Preview",
  "Sports Weekly", "MTN Sports Presents: Top of the Treasure State", "Sports Zone Saturday Preview Ole Miss/Tulsa FB Game",
  "Tennessee Sports Hall of Fame", "Georgia High School Sports Daily", "Sports Outdoors TV", "Talkin' Sports With My Dad",
  "WNEM TV-5 Sports Special: Two Teams, One Dream", "Best in Sports Rotfeld Productions", "Tennessee Sports Hall of Fame: Class of 2021",
  "The Texas Sportsman", "Lights to LA - Sports Blitz", "WOWK-TV Sports Presents: Sports Zone WV High School Tournament",
  "CBS Sports Special", "KREM 2 Special: Sports Story Telling", "Action Sports JAX", "CBS Sports: We Need to Talk",
  "Sports Zone Special: USM vs Ole Miss", "SSN Sports", "SWLA Sports Show Basketball", "Sports Zone Saturday Egg Bowl Special",
  "DraftKings Sportsbook", "High School Sports Awards", "The Best of Greatest Sports Legends: Class of 1978",
  "Sports Zone Saturday: Preview Ole Miss vs. LSU", "Wisconsin Sports Awards", "WANE 15 Sports Special",
  "SportsZone Saturdays", "MTN Sports Presents: A Season of Champions", "HS Sports Extra",
  "Friday Night Live - High School Sports Preview", "Eyewitness Sports Top 10 High School Football Countdown",
  "WYMT Sports Overtime", "UK Sports Special: Pre-Season UK Basketball Special",
  "Sports Zone Saturday: Preview Ole Miss vs. Kentucky", "Sports HQ FreeWheel Test Steam",
  "NC State Wolfpack Sports: One with Wolfpack Football", "Fresno State Sports Focus - Show 2",
  "Saltwater Sportsman", "CBS Sports", "Fresno State Sports Focus: Show 1",
  "Collegiate Esports National Championship", "Texas Sportsman", "WNBA Basketball","News 19 Sports Iron Bowl Pregame Special",
"8 News Now After Sports",
"5NEWS Sports Special: Pregame on the Hill"
];

DECLARE news_titles_content_category ARRAY<STRING> DEFAULT [
"InvestigateTV+", "Hard Truths", "Matter of Fact With Soledad O'Brien", "Dateline", "Extra", "Inside Texas Politics", "On Your Side Tonight With Jamie Boll", "Eye on Northwest Politics", "America Decides: Campaign '22", "Capital Connection", "The Issue Is", "Politics Now Las Vegas", "Face the State With Joel D. Smith", "Political Special", "Eye on Politics", "Talk Business and Politics", "Politics Unplugged", "Eye on Northwest Politics: Election Special", "Decision 2022", "Voter's Decide: Debate", "Congressional District 2 Debate", "Voters Decide: Denver Mayoral Debate", "Campaign 2024: Countdown to Election Day", "State of the State", "State of Texas In-Depth", "Nevada Gubernatorial Republican Primary Debate", "Gubernatorial Debate", "Presidential Address to the Joint Session of Congress", "President Biden Address to the Nation", "First Presidential Debate: Hosted by CNN", "Election Headquarters: US Senate Debate", "WCCO Mid-Morning", "KCAL Mornings 6a on CBS Los Angeles", "KIRO 7 Tonight", "WCCO the 4", "WTOC Morning Break", "WDBJ7 Early Mornin'", "WNEM TV-5 Wake-Up at 6:00am", "KOAM Morning Show",
  "WTOL 11 Good Day", "WCBI Sunrise", "KELOLAND Living", "WNEM TV-5 Wake-Up", "WNEM TV-5 Wake-Up at 5:00am", "WBZ Morning Mix", "KTAB Daybreak", "WNEM-TV5 Weekend Wake-up",
  "WCBI Early Sunrise", "WNEM-TV5 Wakeup Sunday", "WTOL 11 Your Day", "KIRO 7 Game Day Live", "KBTX Brazos Valley Early Morning", "WIFR Early Edition", "WSBT 22 First in the Morning Saturday",
  "KBTX Live at Five", "WIFR Morning Blend", "KCAL Mornings 7a on CBS Los Angeles", "KMVT Rise and Shine at 6a", "KTAB NOONTAB", "WNBA Tip-Off Show", "KREX5 at 6a",
  "WSBT 22 First in the Morning Sunday", "WTOC Afternoon Break", "KTAB 4U", "KNOE 8 Weekend Report", "WIFR First Edition", "KELOLAND Sportzone", "KREX5 at 5a", "KLBK Rise and Smile",
  "KCTV5 Locker Room Show", "KIRO 7 Scouting Report with Chris Francis", "KMVT Rise and Shine at 530a", "KDKA-TV Fan N'ATion", "KELOLAND Weather NOW", "KCTV5 Post Game",
  "WCBI Sunrise Saturday", "WSL U.S. Open of Surfing Kick-Off", "KMVT Rise and Shine at 5a", "WLKY Road to the Final Four", "WJZ Community MVP Special", "KWTX Weather Xtra!",
  "KOIN Local 6 at 11", "KREX5 at 5p", "KILL COVID-19 WITH CLEANBOSS!", "WMAZ Football Friday Night", "WVU Coaches Show", "WVU Coach's Show", "WABI TV5 Time Capsule",
  "WBTV Investigates: Voices for Change", "WMBD Sunday Morning", "KMOV Thanksgiving Day Parade", "WHIO Reports", "KELOLAND Spring Doppler Special", "WLKY Derby Day Live",
  "WLKY Live from Valhalla", "KREM 2 Boomtown: Special", "WWL Louisiana: Mardi Gras Special 2025", "WNEM High School Football Championship Show", "WLKY March Madness Preview",
  "WNEM-TV5 Presents: Sounds of the Season", "WLKY Road to Final Four 2023", "WLKY Balloon Race & Mini Marathon", "KREM 2 Verify Special", "KCAL Mornings 9am", "WKRG Iron Bowl Special",
  "KCAL On Your Side", "KHOU Special: Juneteenth: 1865 to 2021", "KRQE Presents: KRQE Cares", "WLKY Mini Marathon", "WTOL 11 Presents: Band of the Week", "KTAB Football Extreme",
  "WBTV Black History Month Special: Then Now and Forever", "WHIO 75th Station Anniversary Special", "KREM 2 Inland Northbest Special", "KELOLAND: Your Home for 70 Years", "KOAM+ at 3pm",
  "WJZ's School at the Zoo", "KOIN 6 Town Hall: A State of Pain-Oregon's Drug Crisis", "WLKY Derby Day Coverage", "WLKY Derby Day", "WCCO's The Uplift", "WWMT's 75th Anniversary Special",
  "KOIN 6 Debate for Oregon Attorney General", "KIRO 7 Western WA Gets Real - A Year in Stories", "WAFB's Weekend Kickoff", "WLKY Bell Awards", "KHOU Special: Juneteenth 1865-2024: A Legacy of Song",
  "WLKY 2023 Holiday Flashback", "WCTV Hurricane Special 2023", "KOIN's On Air Job Fair", "KRQE Media Presents: River of Lights", "KCCI Iowa Kickoff", "WTOL 11 Weather: Winter Weather",
  "WBTV Carolina Camera Special", "WLKY The Great Eclipse", "KOIN 6 Town Hall", "WTOL 11 Race for the Cure Special Coverage", "KDKA-TV 75th Anniversary Special", "KHOU Special: Strange But True",
  "WBTV Originals: No Place to Call Home", "KELOLAND Winter Doppler Special", "KELOLAND Sportzone Preview Show", "WNEM Better Deals", "KHOU Special: Juneteenth 1865-2023: Freedom to Learn",
  "KCCI Archives: Holiday Stories from the Heartland", "WTOC Special: It's More Than An Arena", "KOIN 6 Debate for Washington State US House of Representatives", "WKRG Year End",
  "KHOU Special: 2025 MLK Scholarship Program", "KUTV's Salute to Sterling Poulson", "WTOL 11 Weather ALERT Special", "WTOL 11 Year End Special", "WJZ Opening Day Special", "WLKY Oaks Coverage",
  "KFVS: A Centennial Celebration", "KUTV Road to Las Vegas", "KHOU 11 Live at Fan Fest", "WCTV Hurricane Special 2022", "WAFB9 Weekend Kickoff", "KRQE Summer Weather Special",
  "KENS 5 Special: Wear the Gown", "WBZ-TV Patriots' Day Special", "KIRO 7's Best of Jesse Jones Investigates", "KHOU Special: Eye on the Storm: Houston's Fight to Weather What's Next",
  "WTRF Special: Main Street Bank Fantasy in Lights Parade", "WKRG Hurricane Special", "KPIX Year End Special", "WTOL 11 Presents Race for the Cure", "WUSA Town Hall: MD Governor Wes Moore",
  "KRQE Winter Weather Special", "KIRO 7 Western Washington Gets Real: Crimes Against Asians", "WTOC Year in Review", "WCTV 2025 Hurricane Special", "KENS5 Special: Wear the Gown", "WOW - Women Of Wrestling",
  "KREM 2 Special: Boomtown", "KHOU Special: The Invisible Project", "KELOLAND Investigates: Cold Cases", "WNEM 70th Anniversary Special", "WDBJ7 Target 7 Special", "WAFB Saturday Morning Football",
  "WTOL 11 Weather: Solar Eclipse", "KLFY Hurricane Special", "WIBW Shop Local Holiday Special #2", "KOAM Severe Weather Program", "KHQA Spring Weather Special", "WLKY Holiday Flashback",
  "WTKR First Warning Weather Severe Storm Special", "WMLW Bucks Pregame Show", "KREM 2 Special: Story Telling", "WLKY Selection Sunday", "WENY Weather Special", "KTAB 4U Special Edition",
  "WWAY Hurricane Special 2023", "KLST Severe Weather Threat Special", "WLTX Christmas Messages", "WAKA Seasons Greetings", "KTUU/KYES Celebrates America's History",
    "InvestigateTV+",
  "Dateline",
  "Matter of Fact With Soledad O'Brien",
  "America Decides: Campaign '22",
  "Eye on Northwest Politics",
  "Inside Texas Politics","Inside Edition",
"Entertainment Tonight",
"ET Live"
];
/*
--------==================================================================================================================================
--(JZ) This table is used to track all consumption data overall
DELETE `ent_summary.ir_doc_cte_0_all_consumption_data` where month_dt between start_date and end_date;
INSERT INTO `ent_summary.ir_doc_cte_0_all_consumption_data` (

---------------------------------------------------------------------
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_0_all_consumption_data`
-- partition by month_dt as (
-----------------------------------------------------------------------
  select
    date_trunc(be.day_dt, month) as month_dt,
    cast(coalesce(be.title_id,'-') as string) as title_id,
    coalesce(be.title_group_id,'-') title_group_id,
    coalesce(mpd.title_group_nm, be.title_group_nm) as title_group_nm,
    be.title_updated,
    REGEXP_REPLACE(LOWER(be.title_updated), r'[^a-z0-9]', '') as mod_reporting_series_nm,
    be.season_nbr as video_season_nbr,
    be.reporting_content_type_cd,
    be.primary_genre_nm,
    hob.secondary_genre_nm,
    case 
      when be.primary_genre_nm IN ("News & Sports")
      then hob.secondary_genre_nm
      ELSE be.primary_genre_nm
    end genre_nm,
    hob.comet_taxonomy_brand_nm as brand,

    case
      when plan_type = 'Ad-Free Plan' then "Ad-Free"
      else "Ad-Tier"
    end as plan_type,

     case
      when billing_platform_type = "Wholesale/vMVPD/MVPD"
      then "Wholesale/MVPD/vMVPD" --reordered MVPD and vMVPD for IR Sheet lookups to work
      else billing_platform_type
    end as billing_partner,

    -- billing_platform,

    v69_registration_id_nbr,
    sum(total_duration_mins)/60 as hours,
    -- sum(video_total_time_sec_qty)/3600 as hours,
  from `temp_st.st_topline_kpi_base_engagement_table` be
  left join (select distinct title_id, title_group_id, reporting_series_nm, secondary_genre_nm, comet_taxonomy_brand_nm from `ent_summary.fd_house_of_brands`) hob
    on be.title_id = hob.title_id
      and be.title_group_id = hob.title_group_id
      and be.title_updated = hob.reporting_series_nm
      and be.title_id IS NOT NULL and be.title_group_id IS NOT NULL
  left join (select distinct title_id, title_group_id, title_group_nm from `i-dss-ent-data.ent_vw.title_mapping_parent_dim`) mpd 
        on be.title_id = mpd.title_id
      and be.title_group_id = mpd.title_group_id
      and be.title_id IS NOT NULL and be.title_group_id IS NOT NULL
  where
    day_dt between START_DATE and END_DATE
  group by all
);

--   --(MD) 8/11/24 - Based on CBS Current definition change, the following cte has been changed to have row level cbs current month for each title, season combination
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_1a_cbs_titles` as (
--   -- First get all the content ids at a title level to identify CBS Shows
--   select
--     mpd.reporting_series_nm,
--     -- REGEXP_REPLACE(LOWER(title), r'[^a-z0-9]', '') as mod_title,
--     cast(title_id as string) as title_id,
--   from `i-dss-ent-data.temp_ad.cbs_pplus_premiere_date` pd
--       join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
--     on cast(pd.content_id as string) = cast(mpd.parent_id as string)
--   group by all
-- );

-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_1b_cbs_current_seasons` as (
--   -- First get all the content ids at a title level to identify CBS Shows
--   select
--     mpd.reporting_series_nm as title,
--     -- REGEXP_REPLACE(LOWER(pd_left.title), r'[^a-z0-9]', '') as mod_title,
--     cast(pd.season_nbr as string) as video_season_nbr,
--     cast(title_id as string) as title_id,
--     date_trunc(premiere_dt,month) as scan_thru_start_month_dt,
--     date_add(date_trunc(premiere_dt,month),interval 11 month) as scan_thru_end_month_dt,
--     cbs_current_month,
--   from `i-dss-ent-data.temp_ad.cbs_pplus_premiere_date` pd
--   join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
--     on cast(pd.content_id as string) = cast(mpd.parent_id as string),
--   UNNEST (GENERATE_DATE_ARRAY(date_trunc(premiere_dt,month), date_add(date_trunc(premiere_dt,month),interval 11 month), INTERVAL 1 MONTH)) as cbs_current_month
--   where
--     mpd.reporting_series_nm IS NOT NULL
--   group by all
-- );

-- # (MD) The following table maintains the list of Originals with their season_nbr, primary_genre_nm, release_strategy, and content_type
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_2_originals_season_level_titles` as (

-- -- need to join to intermediate table to get the correct reporting_Series_nm and title_id
--   select
--     distinct
--     mpd.reporting_series_nm as title,
--     -- REGEXP_REPLACE(LOWER(title), r'[^a-z0-9]', '') as mod_title,
--     case
--       when content_type = "(Movie)" then null
--       else season_nbr
--     end as video_season_nbr,
--     cast(title_id as STRING) as title_id,
--     case 
--       when content_id in ("61457332") then "News" --"60 Minutes+"
--       when content_id in ("61460697") then "Sports" --"Inside the NFL" 
--       when content_id in ("956159958") then "Factual" --Thirst Trap: The Fame. The Fantasy. The Fallout.
--       when content_id in ("rcaREc9ukH_RRWXku6ODuAblgLG9Iv3U") then "Factual" --Bodyguard of Lies
--       when content_id in ("QVomEH1jQt_PAKRDKeBl1j8ceZo7bvj_") then "Factual" --vlookup in originals tracker failed --Ozzy: No Escape From Now
--       else primary_genre_nm 
--     end as genre,
--     release_strategy,
--     case
--       when content_type is null then "FEP"
--       else "MOVIE"
--     end as content_type,
--     premeire_dt,
--     case
--       when content_id not in (
--       "61456641", -- "RuPaul's Drag Race All Stars"
--       "61459324", -- "RuPaul's Drag Race All Stars Untucked"
--       "61456321", -- "SEAL Team"
--       "61457217", -- "Ink Master"
--       "393",      -- "Criminal Minds"
--       "61456496", -- "Evil"
--       "61456699", -- "Are You The One?"
--       "61456483", -- "Blood & Treasure"
--       "61456866", -- "Inside Amy Schumer"
--       "61457025", -- "Billions"
--       "61460697", -- "Inside the NFL"
--       "62468457", -- "The Chi"
--       "61466437", -- "The Circus"
--       "61457230", -- "Yellowjackets"
--       "61464293"  -- "Couples Therapy"
--       )
--       then "Always Original"
--       else "Turned Original"
--     end as original_conversion_flag
--   from `ent_summary.pplus_original_premiere_date` pd
--     join `i-dss-ent-data.ent_vw.title_mapping_parent_dim` mpd 
--     on cast(pd.content_id as string) = cast(mpd.parent_id as string)
--   where
--     content_id is not null --This condition will remove The Chi and Couples Therapy Breakout seasons (i.e. 4.1, 4.2, 6.1, 6.2) here
--     and title is not null
--   group by all
-- );

-- -- (MD) The following table ranks occurence of more than 1 genre (if exists) for the same title
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_3_ranked_genre_by_title` AS (
--   select
--     -- title_id,
--     title_group_id,
--     -- title_updated,
--     -- mod_reporting_series_nm,
--     genre_nm,
--     -- row_number() over (partition by title_updated order by sum(hours) desc) title_rank,
--     -- row_number() over (partition by mod_reporting_series_nm order by sum(hours) desc) mod_title_rank,
--     -- row_number() over (partition by title_id order by sum(hours) desc) title_id_rank,
--     row_number() over (partition by title_group_id order by sum(hours) desc) title_group_id_rank
--   from `ent_summary.ir_doc_cte_0_all_consumption_data`
--   where genre_nm IS NOT NULL
--     and title_group_nm <> "Other"
--     and reporting_content_type_cd not like "%core%"
--     and title_updated not like "%core%"
--     and title_updated not in ("-")
--     and title_updated IS NOT NULL
--     and title_group_id NOT IN ('-')
--   group by all
-- );


-- -- (MD) The following table finds and stores the genre that has the highest number of hours for titles with more than 1 genre
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_4_top_genre_by_title` AS (
-- select
--   -- title_id,
--   title_group_id,
--   -- title_updated,
--   -- mod_reporting_series_nm,
--   genre_nm
-- from `ent_summary.ir_doc_cte_3_ranked_genre_by_title`
-- where (title_group_id_rank = 1)
-- group by all
-- );

-- -- (MD) The following table ranks occurence of more than 1 genre (if exists) for the same title
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_5_ranked_brand_by_title` AS (
--   select
--     -- title_id,
--     title_group_id,
--     -- title_updated,
--     -- mod_reporting_series_nm,
--     brand,
--     -- row_number() over (partition by title_updated order by sum(hours) desc) title_rank,
--     -- row_number() over (partition by mod_reporting_series_nm order by sum(hours) desc) mod_title_rank,
--     -- row_number() over (partition by title_id order by sum(hours) desc) title_id_rank,
--     row_number() over (partition by title_group_id order by sum(hours) desc) title_group_id_rank
--   from `ent_summary.ir_doc_cte_0_all_consumption_data`
--   where brand IS NOT NULL
--     and title_group_nm <> "Other"
--     and reporting_content_type_cd not like "%core%"
--     and title_updated not like "%core%"
--     and title_updated not in ("-")
--     and title_updated IS NOT NULL
--     and title_group_id NOT IN ('-')
--   group by all
-- );


-- -- (MD) The following table finds and stores the genre that has the highest number of hours for titles with more than 1 genre
-- CREATE OR REPLACE TABLE `ent_summary.ir_doc_cte_6_top_brand_by_title` AS (
-- select
--   -- title_id,
--   title_group_id,
--   -- title_updated,
--   -- mod_reporting_series_nm,
--   brand
-- from `ent_summary.ir_doc_cte_5_ranked_brand_by_title`
-- where (title_group_id_rank = 1)
-- group by all
-- );

-- -- ==================================================================================================================================
*/
CREATE OR REPLACE TABLE `ent_summary.jz_consumption_content_categories`
partition by month_dt
AS (

--DELETE `ent_summary.jz_consumption_content_categories` where month_dt BETWEEN start_date and end_date;
--INSERT INTO `ent_summary.jz_consumption_content_categories` (
with cte8_content_categories_classified as (
  select
    c0.title_id,
    c0.title_group_id,
    c0.title_group_nm,
    c0.title_updated,
    -- c0.video_season_nbr,
    c0.reporting_content_type_cd,
    c0.billing_partner,
    c0.plan_type,
    c0.month_dt,
    case
      --------------------------
      --- Content Categories ---
      --------------------------
      -- 1. Manual primary genre overrides by array (before anything else)
      WHEN c0.title_group_nm IN UNNEST(original_series_titles_content_category) THEN "Original Series"
      WHEN c0.title_group_nm IN UNNEST(dts_movies_titles_content_category) THEN "DTS Movies"
      WHEN c0.title_group_nm IN UNNEST(theatrical_movies_titles_content_category) THEN "Theatrical Movies"
      WHEN c0.title_group_nm IN UNNEST(sports_titles_content_category) THEN "Sports"
      WHEN c0.title_group_nm IN UNNEST(news_titles_content_category) THEN "News"
      WHEN c0.title_group_nm IN UNNEST(local_live_titles_content_category) THEN "Local + Live"
      WHEN c0.title_group_nm IN UNNEST(library_movies_titles_content_category) THEN "Library Movies"
      WHEN c0.title_group_nm IN UNNEST(library_series_titles_content_category) THEN "Library Series"
-- (MD) Other (Catch All) - This bucket includes all undefined 
      when c0.title_group_nm in ("Paramount +","undefined","Paramount+") then "Other (Catch All)"
      when c0.title_group_nm like "core%" and c0.title_group_nm not in ("core-nfl-window") then "Other (Catch All)"

      -- 2.CBS Current Logic
      when (c1b.title is not null or c1b.title_id is not null)
      and (c0.reporting_content_type_cd is null OR c0.reporting_content_type_cd not in ("MOVIE")) then "CBS Current"

      -- 3. Original Series
      when (c2.title is not null or c2.title_id is not null) and c2.content_type = "FEP"
      and (c0.reporting_content_type_cd is null OR c0.reporting_content_type_cd not in ("MOVIE")) then "Original Series"

     -- 3.5 South Park
      when lower(c0.title_group_nm) LIKE '%south%park%' or lower(c0.title_group_nm) like '%casa%mi%amor%' then 'South Park'

      -- 4. DTS and Theatrical Movies
      when (c2.title is not null or c2.title_id is not null) and c2.content_type = "MOVIE" and c2.release_strategy = "DTC Movies"
      and (c0.reporting_content_type_cd is null OR c0.reporting_content_type_cd not in ("FEP")) then "DTS Movies"
      
      when (c2.title is not null or c2.title_id is not null) and c2.content_type = "MOVIE" and c2.release_strategy = "Theatrical Release" 
      and (c0.reporting_content_type_cd is null OR c0.reporting_content_type_cd not in ("FEP")) then "Theatrical Movies"
      
      -- 5. Sports
      when c4.genre_nm = "Sports" then "Sports"
      WHEN ((c0.secondary_genre_nm = "Sports" AND LOWER(TRIM(c0.title_group_nm)) NOT IN ("local news", "we need to talk"))
          OR c0.title_group_nm IN UNNEST(sports_titles_content_category)
          OR c0.title_group_nm IN UNNEST(sports_genre)
          )
      THEN "Sports"

      -- 6. News
      when c4.genre_nm = "News" then "News"
      when
        (UPPER(c0.title_group_nm) like "%NEWS%")
        and ((c0.primary_genre_nm is null) 
            or (c0.primary_genre_nm = "News & Sports")
            or (c0.secondary_genre_nm = "News")) 
      THEN "News"      
      WHEN c0.secondary_genre_nm = "News"
          OR c0.title_group_nm IN UNNEST(news_titles_content_category)
          OR c0.title_group_nm IN UNNEST(news_genre)
          OR (
            REGEXP_CONTAINS(LOWER(c0.title_group_nm), r'news|this morning|good morning')
            OR REGEXP_CONTAINS(c0.title_group_nm, r'^(K|W)[A-Z0-9]{2,}^')  -- station codes
            OR REGEXP_CONTAINS(c0.title_group_nm,   r'(?i)on\s+(K|W)[A-Z0-9-]{2,}\s*\d{1,3}')  -- station codes
          ) 
      then "News"
      
      -- 7. Library Movies
      when (c0.reporting_content_type_cd in ("MOVIE")) then "Library Movies"

      -- 8. Local and Live & Award Shows
      when
      (upper(reporting_content_type_cd) in ("CBS LIVE TV", "LIVE FEED", "LIVE CHANNELS", "P+ CHANNELS","LIVE") 
        OR (UPPER(c0.title_group_nm) LIKE '%AWARD%')
        OR (c0.title_group_nm like "P+ Live%")
        OR (lower(c0.title_group_nm) like "% live %")
        OR (c0.title_group_nm like "P+ Channels%")
        OR (lower(c0.title_group_nm) like "% concert %"))
      then "Local + Live"


      -- 9. CBS Library
      when (c1a.title_id is not null or c1a.reporting_series_nm IS NOT NULL) then "CBS Library"

      --10. Others Catch All
      when
        lower(c0.title_group_nm) LIKE '%manual test%'
        or lower(c0.title_group_nm) LIKE '%test event%'
        or lower(c0.title_group_nm) LIKE '%testing%'
        or lower(c0.title_group_nm) LIKE '%sb test%'
        or lower(c0.title_group_nm) LIKE '%cbsaa%'
        or lower(c0.title_group_nm) LIKE '%election%'
        or lower(c0.title_group_nm) LIKE '%mixible%'
        or lower(c0.title_group_nm) LIKE '%channel%'
        or lower(c0.title_group_nm) LIKE '%broadcast%'
        OR REGEXP_CONTAINS(c0.title_group_nm, r'\b[A-Z0-9-]{10,}\b')
        OR lower(c0.title_group_nm) LIKE '%all%access%'
        OR lower(c0.title_group_nm) LIKE '%paramount%'
        OR REGEXP_CONTAINS(c0.title_group_nm, r'(?i)\bCBS\s*\d+\b')
        OR REGEXP_CONTAINS(c0.title_group_nm, r'\b\d{1,2}/\d{1,2}\b')
        OR REGEXP_CONTAINS(c0.title_group_nm, r'\b\d{1,2}(:\d{2})?\s*[ap]\.?m\.?\b')
        OR c0.title_id = "_55cL7EscO2mdFcpsZVcQ3VtXNA5bcA_"
      then "Local + Live"

      -- 11. Awards and Specials
      when ((UPPER(c0.title_group_nm) LIKE '%AWARD%')
      OR (lower(c0.title_group_nm) like "% concert %")
      OR (lower(c0.title_group_nm) like "% concert")
      OR (lower(c0.title_group_nm) like "concert %")
      or (lower(c0.title_group_nm) like "% special %")
      or (lower(c0.title_group_nm) like "% special")
      or (lower(c0.title_group_nm) like "special %"))
      then "Library Specials"

      -- 12. Trailers Catch All

      when (lower(c0.title_group_nm) like "%trailer%"
        or lower(c0.title_group_nm) like "%(trailer)%"
        or lower(c0.title_group_nm) like "%teaser%"
        or lower(c0.title_group_nm) like "%preview%"
        or reporting_content_type_cd in ("TRAILER", "CLIP")) then "Library Other"


      -- 13. Catch All as Library Series
      else "Library Series"
      end as content_category,


      case
      --------------------------
      --------- Genres ---------
      --------------------------
        -- 1. Manual primary genre overrides by array (before anything else)
      WHEN c0.title_group_nm IN UNNEST(drama_genre) THEN "Drama"
      WHEN c0.title_group_nm IN UNNEST(horror_genre) THEN "Horror"
      WHEN c0.title_group_nm IN UNNEST(factual_genre) THEN "Factual"
      WHEN c0.title_group_nm IN UNNEST(comedy_genre) THEN "Comedy"
      WHEN c0.title_group_nm IN UNNEST(reality_genre) THEN "Reality"
      WHEN c0.title_group_nm IN UNNEST(kids_family_genre) THEN "Kids & Family"
      WHEN c0.title_group_nm IN UNNEST(sports_genre) THEN "Sports"
      WHEN c0.title_group_nm IN UNNEST(news_genre) THEN "News"
      WHEN c0.title_group_nm IN UNNEST(other_genre) THEN "Other"

      -- (MD) Other (Catch All) - This bucket includes all the core except core-nfl-window (which gets taken care by cte_5 join) and all undefined Starts
      when c0.title_group_nm in ("Paramount +","undefined","Paramount+") then "Other"
      when c0.title_group_nm like "core%" and c0.title_group_nm not in ("core-nfl-window") then "Other"

      -- 1.5 Get Originals Genre from the table
      when (c2.title is not null or c2.title_id is not null) then c2.genre

      -- 2. "Core" or undefined
      WHEN LOWER(TRIM(c0.title_group_nm)) LIKE "core%" AND LOWER(TRIM(c0.title_group_nm)) NOT IN ("core-nfl-window") THEN "Other"

      -- 3. Sports logic
      when c4.genre_nm = "Sports" then "Sports"
      when (UPPER(c0.title_group_nm) like "%SPORTS%")
        and ((c0.primary_genre_nm is null)
        or (c0.primary_genre_nm = "News & Sports")
        or (c0.secondary_genre_nm = "Sports"))
      then "Sports"
      WHEN (c0.secondary_genre_nm = "Sports" AND LOWER(TRIM(c0.title_group_nm)) NOT IN ("local news", "we need to talk"))
          OR c0.title_group_nm IN UNNEST(sports_titles_content_category)
          OR c0.title_group_nm IN UNNEST(sports_genre)
      THEN "Sports"

      -- 4. News logic
      when c4.genre_nm = "News" then "News"
      when
        (UPPER(c0.title_group_nm) like "%NEWS%")
        and ((c0.primary_genre_nm is null) 
            or (c0.primary_genre_nm = "News & Sports")
            or (c0.secondary_genre_nm = "News")) 
      THEN "News"
      WHEN c0.secondary_genre_nm = "News"
          OR c0.title_group_nm IN UNNEST(news_titles_content_category)
          OR c0.title_group_nm IN UNNEST(news_genre)
          OR (
            REGEXP_CONTAINS(LOWER(c0.title_group_nm), r'news|this morning|good morning')
            OR REGEXP_CONTAINS(c0.title_group_nm, r'^(K|W)[A-Z0-9]{2,}')  -- station codes
            OR REGEXP_CONTAINS(c0.title_group_nm,   r'(?i)on\s+(K|W)[A-Z0-9-]{2,}\s*\d{1,3}')  -- station codes
          )
        THEN "News"

      -- 5. Use most frequent genre if null
      WHEN c4.genre_nm IS NOT NULL THEN c4.genre_nm

      -- 6. Default
      WHEN (c0.genre_nm IS NOT NULL AND c4.genre_nm IS NULL) then c0.genre_nm
      ELSE "Other"
    end as genre_nm,



      --------------------------
      --------- Brands ---------
      --------------------------

      case
        when c6.brand IS NOT NULL then c6.brand
        when c0.brand is not null then c0.brand
        else "Other"
      end as brand,

      --------------------------
      --------- Metrics ---------
      --------------------------
      sum(hours) as hours,
      v69_registration_id_nbr,



  from `ent_summary.ir_doc_cte_0_all_consumption_data` c0
  -- (CBS Current) Join all content type based on content id, season number, and cbs current window
  left join `ent_summary.ir_doc_cte_1b_cbs_current_seasons` c1b
  on
    c0.title_id = c1b.title_id 
    and (c0.video_season_nbr is null OR c0.video_season_nbr ='0' OR c0.video_season_nbr = c1b.video_season_nbr) --if null seasons fall within the window, will be current
    and c0.month_dt = c1b.cbs_current_month
    and c0.reporting_content_type_cd not in ("CBS LIVE TV", "LIVE FEED", "LIVE CHANNELS", "P+ CHANNELS","LIVE") 

  -- (Original Series) Join all content type based on content id, and season number
  left join `ent_summary.ir_doc_cte_2_originals_season_level_titles` c2
  on
    (c0.title_id = c2.title_id
    -- OR c5.mod_reporting_series_nm = c2.mod_title
    )
    and (c2.video_season_nbr IS NULL or c2.video_season_nbr = c0.video_season_nbr)
    and c0.reporting_content_type_cd not in ("CBS LIVE TV", "LIVE FEED", "LIVE CHANNELS", "P+ CHANNELS","LIVE") 
  
  -- (CBS Library) Join all CBS titles at title_id level
  left join `ent_summary.ir_doc_cte_1a_cbs_titles` c1a
  on
    c0.title_id = c1a.title_id
    and c0.reporting_content_type_cd not in ("CBS LIVE TV", "LIVE FEED", "LIVE CHANNELS", "P+ CHANNELS","LIVE") 

  -- (Genre Corrections) correcting incorrect or null genres
  LEFT JOIN `ent_summary.ir_doc_cte_4_top_genre_by_title` c4
  ON 
   c0.title_group_id = c4.title_group_id
  
-- (Brand Corrections) correcting incorrect or null genres
  LEFT JOIN `ent_summary.ir_doc_cte_6_top_brand_by_title` c6
  ON 
   c0.title_group_id = c6.title_group_id

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


---------------------------------------------------------------------------------------------------------
