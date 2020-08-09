// Credits:
// Bale forum posts about visit url handling, witchess fights
// VeracityMeatFarm.ash for introduction to combat filters and getting started with LOV tunnel and the proper way to request a fax
// Ezandora's KGB Briefcase.ash script for handling briefcase so I don't have to
// Zarqon canadv.ash for how to check for access to purple light district
// lostcalpolydude for answering various questions


// Costs:
// 11 bacon @300                                          =     3,000
// 1 4-d camera @7500                                     =     7,500
// 6 cornucopia for thanksgiving feast @14,000            =    84,000
// 1 scroll of ancient forbidden unspeakable evil @3100   =     3,100
// 1 distention pill @????                                = turns
// 1 drive-by shooting  @10000                            =    10,000
// 1 hell in a bucket @2400                               =     2,400
// 1 jumping horseradish @3333                            =     3,333
// 1 Newark @4000                                         =     4,000
// 2 Milk Studs @640                                      =     1,280
// 3 pie man was not meant to eat @2500                   =     7,500
// 10 resolution: be wealthier @1300                      =    13,000
// 1 senior mints @100                                    =       100
// 1 single entendre @10000                               =    10,000
// 3 thin black candles @288                              =       900
// 24 bags of W&Ws @1300                                  =    31,200

// total                                                  =   181,313 
// income over 340 turns                                  = 2,412,711
// net gain                                               = 2,221,038



// TODO:



// For dice gear:
// Change filter to kill ticking modifier monsters immediately instead of dragging out combat
// When fighting annoying/etc. monsters, detect that skill casting has failed


// First digitize needs to visit adventure.php to actually trigger the digitize counter to start.
// Can this be done by visiting an overgrown shrine?  (used to, no longer, now we need a zone which isn't nowander)

// duplicate witchess knight (code is partly there, but it's not actually firing)
// half-fill MP from latte for MP burning summoning
// vote timer prevents LOV tunnel
// thanksgarden over-eats for required buff turns
// use vampire cloake wolf form in combat before using platinum express card so it can be extended 5 buffs



// LINKNOIDBARF.ASH


boolean isDebug = false;
boolean autoConfirmBarf = false;
boolean autoConfirm = false;
string defaultOutfit = "barf";
string meatyOutfit = "";
string dropsOutfit = "drops";
string manaOutfit = "Max MP";
string weightOutfit = "Max Weight";

string printColor = "orange";

// Change these values to put limits on how much of certain resources to keep back:
int saveSpleen = 0; // how many spleen points to save back
int saveStomach = 0; // how many stomach points to save back
int saveLiver = 0; // how many liver points to save back
boolean saveFax = false; // don't use the fax, so it can be used for other things (like factoid hunting)
int maxUsePrintScreens = 0; // how many print screens to use per day
int maxUseEnamorangs = 1; // how many lov enamorangs to throw per day
int turkeyLimit = 1; // how many ambitious turkeys to drink per day
int sacramentoLimit = 0; // how many sacramento wines to drink per day
int thanksgettingFoodCostLimit = 15000; // Don't thanksgetting foods that cost more than this
int mojoCostLimit = 6000; // Don't thanksgetting foods that cost more than this
int votedMeatLimit = 0; // Wear "I voted sticker" at appropriate times when meat buff % is below this number
boolean combatUserScript = false; // in barf mountain fights, use the user's default combat script instead of the built in logic
boolean allowExpensiveBuffs = true; // certain buffs may not be worth using
boolean abortOnBeatenUp = false; // if you get beaten up while the script is running, abort so it just doesn't keep dying over and over
boolean preferCalcUniversePvP = false; // calculate the universe for pvp fights instead of adventures
boolean autoVoraciThanksgetting = false; // eat a cuppa voraciti tea if there's 1 stomach free when ran out of thanksgetting to get more turns out of it (not generally worth the meat, but you can do it if you really want to)
string hobopolisWhitelist = ""; // Guilds in which this character has permission to enter hobopolis
string executeBeforeEat = ""; // If you want another script or command to do your eating, put it here
string executeAfterEat = ""; // If you want another script to fill you the rest of the way after you've eaten, put it here
item elfDuplicateItem; // If you specify this, the machine elf adventure will automatically duplicate this instead of aborting
monster pocketProfessorCloneMonster; // If you specify this, the pocket professor will automatically fight this
string ascendToday = ""; // stored as my_ascensions() + "," + my_daycount() if we're ascending today
boolean autoPvpCloset = false; // Automatically add and remove items from closet for protection from PVP
int catHeistValue = 7000; // The value you place on 1 cat burglar heist

void WriteSettings()
{
	string[string] map;
	file_to_map("linknoidfarm_" + my_name() + ".txt", map);
	map["autoConfirmBarf"] = autoConfirmBarf.to_string();
	map["defaultOutfit"] = defaultOutfit;
	map["meatyOutfit"] = meatyOutfit;
	map["dropsOutfit"] = dropsOutfit;
	map["manaOutfit"] = manaOutfit;
	map["weightOutfit"] = weightOutfit;
	map["printColor"] = printColor;
	map["saveSpleen"] = saveSpleen.to_string();
	map["saveStomach"] = saveStomach.to_string();
	map["saveLiver"] = saveLiver.to_string();
	map["saveFax"] = saveFax.to_string();
	map["maxUsePrintScreens"] = maxUsePrintScreens.to_string();
	map["maxUseEnamorangs"] = maxUseEnamorangs.to_string();
	map["turkeyLimit"] = turkeyLimit.to_string();
	map["sacramentoLimit"] = sacramentoLimit.to_string();
	map["thanksgettingFoodCostLimit"] = thanksgettingFoodCostLimit.to_string();
	map["mojoCostLimit"] = mojoCostLimit.to_string();
	map["votedMeatLimit"] = votedMeatLimit.to_string();
	map["combatUserScript"] = combatUserScript.to_string();
	map["allowExpensiveBuffs"] = allowExpensiveBuffs.to_string();
	map["abortOnBeatenUp"] = abortOnBeatenUp.to_string();
	map["preferCalcUniversePvP"] = preferCalcUniversePvP.to_string();
	map["autoVoraciThanksgetting"] = autoVoraciThanksgetting.to_string();
	map["hobopolisWhitelist"] = hobopolisWhitelist;
	map["executeBeforeEat"] = executeBeforeEat;
	map["executeAfterEat"] = executeAfterEat;
	map["elfDuplicateItem"] = elfDuplicateItem.to_int().to_string();
	map["pocketProfessorCloneMonster"] = pocketProfessorCloneMonster.to_string();
	map["ascendToday"] = ascendToday;
	map["autoPvpCloset"] = autoPvpCloset.to_string();
	map["catHeistValue"] = catHeistValue.to_string();
	map_to_file(map, "linknoidfarm_" + my_name() + ".txt");
}
void ReadSettings()
{
	string[string] map;
	file_to_map("linknoidfarm_" + my_name() + ".txt", map);
	foreach key,value in map
	{
		switch (key)
		{
			case "autoConfirmBarf": autoConfirmBarf = value.to_boolean(); break;
			case "defaultOutfit": defaultOutfit = value; break;
			case "meatyOutfit": meatyOutfit = value; break;
			case "dropsOutfit": dropsOutfit = value; break;
			case "manaOutfit": manaOutfit = value; break;
			case "weightOutfit": weightOutfit = value; break;
			case "printColor": printColor = value; break;
			case "saveSpleen": saveSpleen = value.to_int(); break;
			case "saveStomach": saveStomach = value.to_int(); break;
			case "saveLiver": saveLiver = value.to_int(); break;
			case "saveFax": saveFax = value.to_boolean(); break;
			case "maxUsePrintScreens": maxUsePrintScreens = value.to_int(); break;
			case "maxUseEnamorangs": maxUseEnamorangs = value.to_int(); break;
			case "turkeyLimit": turkeyLimit = value.to_int(); break;
			case "sacramentoLimit": sacramentoLimit = value.to_int(); break;
			case "thanksgettingFoodCostLimit": thanksgettingFoodCostLimit = value.to_int(); break;
			case "mojoCostLimit": mojoCostLimit = value.to_int(); break;
			case "votedMeatLimit": votedMeatLimit = value.to_int(); break;
			case "combatUserScript": combatUserScript = value.to_boolean(); break;
			case "allowExpensiveBuffs": allowExpensiveBuffs = value.to_boolean(); break;
			case "abortOnBeatenUp": abortOnBeatenUp = value.to_boolean(); break;
			case "preferCalcUniversePvP": preferCalcUniversePvP = value.to_boolean(); break;
			case "autoVoraciThanksgetting": autoVoraciThanksgetting = value.to_boolean(); break;
			case "hobopolisWhitelist": hobopolisWhitelist = value; break;
			case "executeBeforeEat": executeBeforeEat = value; break;
			case "executeAfterEat": executeAfterEat = value; break;
			case "elfDuplicateItem": elfDuplicateItem = value.to_int().to_item(); break;
			case "pocketProfessorCloneMonster": pocketProfessorCloneMonster = value.to_monster(); break;
			case "ascendToday": ascendToday = value; break;
			case "autoPvpCloset": autoPvpCloset = value.to_boolean(); break;
			case "catHeistValue": catHeistValue = value.to_int(); break;
		}
	}
}


stat muscle = $stat[Muscle];
stat mysticality = $stat[Mysticality];
stat moxie = $stat[Moxie];

slot head = $slot[hat];
slot back = $slot[back];
slot shirt = $slot[shirt];
slot weapon = $slot[weapon];
slot offhand = $slot[off-hand];
slot pants = $slot[pants];
slot acc1 = $slot[acc1];
slot acc2 = $slot[acc2];
slot acc3 = $slot[acc3];
int[slot] outfitSlots = { head:1, back:2, shirt:3, weapon:4, offhand:5, pants:6, acc1:7, acc2:8, acc3:9 };
slot famEqp = $slot[familiar];
slot sticker1 = $slot[sticker1];
slot sticker2 = $slot[sticker2];
slot sticker3 = $slot[sticker3];

item noItem = $item[none];
location noLocation = $location[none];
familiar noFamiliar = $familiar[none];

// getting access to dinsey
item dayPass = $item[one-day ticket to Dinseylandfill];

// campground items
item witchess = $item[Witchess Set];
item terminal = $item[Source terminal];
item mayoClinic = $item[portable Mayo Clinic];
item asdonMartin = $item[Asdon Martin keyfob];
item dnaLab = $item[Little Geneticist DNA-Splicing Lab];
item oven = $item[warbear induction oven];
effect observantly = $effect[Driving Observantly];
item pieFuel = $item[pie man was not meant to eat];
item water = $item[soda water]; // food for adsonMartin
item dough = $item[wad of dough]; // food for adsonMartin
item breadFuel = $item[loaf of soda bread];
item sphygmayo = $item[sphygmayomanometer];
item dnaSyringe = $item[DNA extraction syringe];

// garden
item pokeGarden = $item[packet of tall grass seeds];
item fertilizer = $item[Pok&eacute;-Gro fertilizer];
item thanksGarden = $item[packet of thanksgarden seeds];
item mushroomGarden = $item[packet of mushroom spores];

// LT&T
item telegram = $item[plaintive telegram];
location telegramLoc = $location[Investigating a Plaintive Telegram];

// items for eating
item milk = $item[milk of magnesium];
item mayoFullToDrunk = $item[Mayodiol]; // 1 full to drunk
item mayoIncreaseBuffs = $item[Mayozapine]; // double stats
item cashew = $item[cashew];
item cornucopia = $item[cornucopia];
item horseradish = $item[jumping horseradish];
item foodCone = $item[Dinsey food-cone];
item seaTruffle = $item[sea truffle];
item thanks1 = $item[green bean casserole];
item thanks2 = $item[cranberry cylinder];
item thanks3 = $item[mashed potatoes];
item thanks4 = $item[candied sweet potatoes];
item thanks5 = $item[mince pie];
item thanks6 = $item[bread roll];
item thanks7 = $item[baked stuffing];
item thanks8 = $item[thanksgiving turkey];
item thanks9 = $item[warm gravy];
item distention = $item[distention pill];
item voraciTea = $item[cuppa Voraci tea];
item timeSpinner = $item[Time-Spinner];

// booze to drink
item elementalCaip = $item[elemental caipiroska]; // cheap and good, from robortender
item dirt = $item[dirt julep]; // booze from plants with robortender
item gingerWine = $item[high-end ginger wine]; // from gingertown
item turkey = $item[Ambitious Turkey]; // from hand turkey
item sacramento = $item[Sacramento wine]; // from witchess
effect sacramentoEffect = $effect[Sacr&eacute; Mental];
item hauntedScrewdriver = $item[twice-haunted screwdriver]; // from voting ghost
item hauntedOrange = $item[haunted orange]; // to make screwdriver
item hauntedVodka = $item[haunted bottle of vodka]; // to make haunted screwdriver
item vodka = $item[bottle of vodka]; // to make haunted screwdriver
item ectoplasm = $item[ghostly ectoplasm]; // to make haunted screwdriver
effect hauntedLiver = $effect[Haunted Liver]; // from any of the haunted items
item pinkyRing = $item[mafia pinky ring]; // increases adventure yield from wine
effect beerPolka = $effect[Beer Barrel Polka]; // increases adventure yield for up to 10 drunk, but only once a day

// spleen items
item egg1 = $item[lustrous oyster egg]; // old oyster eggs no longer show up
item mojoFilter = $item[mojo filter];
// Sweet Synthesis
item milkStud = $item[Milk Studs];
item seniorMint = $item[Senior Mints];
item daffyTaffy = $item[Daffy Taffy];
item swizzler = $item[Swizzler];

// orphan tot
familiar orphan = $familiar[Trick-or-Treating Tot];
item pirateCostume = $item[li'l Pirate Costume];

// robortender
familiar robort = $familiar[Robortender];
item roboItems = $item[single entendre];
item roboCandy = $item[Feliz Navidad];
item roboMana = $item[hell in a bucket];
item roboMeat = $item[drive-by shooting];
item roboHobo = $item[Newark];
item peppermintSprig = $item[peppermint sprig];
item anis = $item[bottle of an&iacute;s];
item boxedWine = $item[boxed wine];
item tequila = $item[bottle of tequila];
item doubleEntendre = $item[double entendre];
item mentholatedWine = $item[mentholated wine];
item orange = $item[orange];
item lemon = $item[lemon];
monster crayonElf = $monster[Black Crayon Crimbo Elf];
item cigar = $item[exploding cigar];

// random action familiars that give meat
familiar unspeakachu = $familiar[Unspeakachu]; // extends buffs
familiar boa = $familiar[Feather Boa Constrictor];
familiar npzr = $familiar[Ninja Pirate Zombie Robot];
familiar stocking = $familiar[Stocking Mimic];
familiar[int] freeCombatFamiliars =
{
//		0 : unspeakachu, // small chance to increase 1/2 your buffs by 5 turn duration, not sure if this is better or not
	1 : boa,
	2 : npzr,
	3 : stocking
};
item loathingLegionEqp = $item[Loathing Legion helicopter];
skill jingleBells = $skill[Jingle Bells];
effect jingleBellsEffect = $effect[Jingle Jangle Jingle];
item dictionary = $item[dictionary]; // for burning rounds for familiar to take actions
item faxdictionary = $item[facsimile dictionary]; // in case you already converted your dictionary

// other familiars of interest
familiar pocketProf = $familiar[Pocket Professor]; // many copies
familiar sandworm = $familiar[Baby Sandworm]; // 5 drops a day
familiar xenomorph = $familiar[Li'l Xenomorph]; // 5 drops a day
familiar llama = $familiar[Llama Lama]; // 5 drops a day
familiar rogue = $familiar[Rogue Program]; // 5 drops a day
familiar badger = $familiar[Astral Badger]; // 5 drops a day
familiar greenPixie = $familiar[Green Pixie]; // 5 drops a day
familiar fistTurkey = $familiar[Fist Turkey]; // 5 drops a day
familiar intergnat = $familiar[Intergnat]; // drops 1 scroll, 3 candles a day
familiar jellyfish = $familiar[Space Jellyfish]; // extract with diminishing returns
familiar robin = $familiar[Rockin' Robin]; // drop every 30 turns
familiar xoskeleton = $familiar[XO Skeleton]; // drop every 11 turns
familiar stompingBoots = $familiar[Pair of Stomping Boots]; // free runaways
familiar bandersnatch = $familiar[Frumious Bandersnatch]; // free runaways
familiar obtuseAngel = $familiar[Obtuse Angel]; // 3 copies
familiar reanimator = $familiar[Reanimated Reanimator]; // 3 copies
familiar cornbeefadon = $familiar[Cornbeefadon]; // familiar equipment

// Bjorn/crown familiars:
item bjorn = $item[Buddy Bjorn];
item crown = $item[Crown of Thrones];
familiar leprechaun = $familiar[Leprechaun]; // 20% meat
familiar hoboMonkey = $familiar[Hobo Monkey]; // 25% meat
familiar goldenMonkey = $familiar[Golden Monkey]; // 25% meat
familiar happyMedium = $familiar[Happy Medium]; // 25% meat
familiar organGrinder = $familiar[Knob Goblin Organ Grinder]; // 25% meat
familiar machineElf = $familiar[Machine Elf]; // drops abstractions
familiar garbageFire = $familiar[Garbage Fire]; // drops burning newspaper
familiar optimisticCandle = $familiar[Optimistic Candle]; // drops hot wax
familiar grimBrother = $familiar[Grim Brother]; // drops grim fairy tales
familiar grimstoneGolem = $familiar[Grimstone Golem]; // drops grimstone mask
familiar warbearDrone = $familiar[Warbear Drone]; // drops whosits
familiar mayoWasp = $familiar[Baby Mayonnaise Wasp]; // +15% myst
familiar grue = $familiar[Grue]; // +15% myst
familiar godLobster = $familiar[God Lobster]; // free fights
familiar[] weightFamiliars =
{
	$familiar[Ghost Pickle on a Stick],
	$familiar[Pair of Ragged Claws],
	$familiar[Spooky Pirate Skeleton],
	$familiar[Autonomous Disco Ball],
	// familiars which deal damage (which we probably don't want):
	$familiar[Misshapen Animal Skeleton],
	$familiar[Animated Macaroni Duck],
	$familiar[Barrrnacle],
	$familiar[Gelatinous Cubeling],
	$familiar[Penguin Goodfella],
};


// familiar equipment
item snowSuit = $item[Snow Suit]; // 20 pounds, but decreases over the day
item petSweater = $item[Astral pet sweater]; // 10 pounds, costs 10 karma per ascension
item sugarShield = $item[sugar shield]; // 10 pounds, breaks after 30 turns
item cufflinks = $item[recovered cufflinks]; // 6 pounds, requires 400 pound jellyfish
item hookah = $item[ittah bittah hookah]; // 5 pounds, provides buffs
item mayflower = $item[Mayflower bouquet]; // 5 pounds, provides drops
item moveableFeast = $item[moveable feast]; // 5 pounds, provides drops
item filthyLeash = $item[filthy child leash]; // 5 pounds, deals damage, fallback if nothing else
item quakeOfArrows = $item[quake of arrows]; // for a cute angel
item embalmingFlask = $item[flask of embalming fluid]; // for reanimated reanimator
// melting familiar gear from pokegarden
item pokeEqpBlock = $item[razor fang];
item pokeEqpMeat = $item[amulet coin];
item pokeEqpItem = $item[luck incense];
item pokeEqpDamage = $item[muscle band];
item pokeEqpHeal = $item[shell bell];
item pokeEqpRun = $item[smoke ball];
item familiarJacks = $item[box of Familiar Jacks]; // to create familiar equipment
skill clipArt = $skill[Summon Clip Art]; // to summon familiar jacks

// pasta thralls
thrall lasagnaThrall = $thrall[Lasagmbie]; // for meat
thrall spiceThrall = $thrall[Spice Ghost]; // for items
thrall verminThrall = $thrall[Vermincelli]; // for mana
thrall vampireThrall = $thrall[Vampieroghi]; // for healing
skill lasagnaThrallSkill = $skill[Bind Lasagmbie]; 
skill spiceThrallSkill = $skill[Bind Spice Ghost];
skill verminThrallSkill = $skill[Bind Vermincelli];
skill vampireThrallSkill = $skill[Bind Vampieroghi];
effect lasagnaThrallEffect = $effect[Pasta Eyeball];

// ghost busting
item protonPack = $item[protonic accelerator pack];
item talisman = $item[Talisman o' Namsilat];
item coldHead = $item[eXtreme scarf];
item coldPants = $item[snowboarder pants];
item coldAcc = $item[eXtreme mittens];
item aeroAccordion = $item[aerogel accordion];
item antiqueAccordion = $item[Antique Accordion];
location palindome = $location[Inside the Palindome];
location icyPeak = $location[The Icy Peak];
skill weakenGhost = $skill[Shoot Ghost];
skill trapGhost = $skill[Trap Ghost];
// survival
skill curseOfIslands = $skill[Curse of the Thousand Islands];
skill soulBubble = $skill[Soul Bubble];
skill stealthMistletoe = $skill[Stealth Mistletoe];
skill entanglingNoodles = $skill[Entangling Noodles];
skill curseOfWeaksauce = $skill[Curse of Weaksauce];
skill micrometeorite = $skill[Micrometeorite];
skill loveGnats = $skill[Summon Love Gnats];
item littleRedBook = $item[little red book];
item indigoCup = $item[Rain-Doh indigo cup];
item blueBalls = $item[Rain-Doh blue balls];
item beehive = $item[beehive];
skill shellUp = $skill[Shell Up];
skill silentKnife = $skill[Silent Knife];


// Skills and items for extending buffs
item bagOtricks = $item[Bag O' Tricks];
item jokesterGun = $item[The Jokester's gun];
item replicaBatoomerang = $item[Replica Bat-oomerang];
skill shatteringPunch = $skill[Shattering Punch];
skill gingerbreadMobHit = $skill[Gingerbread Mob Hit];
skill missileLauncher = $skill[Asdon Martin: Missile Launcher];
skill fireJokester = $skill[Fire the Jokester's Gun];
skill xray = $skill[Chest X-Ray];

// increase drops in combat
skill funkslinging = $skill[Ambidextrous Funkslinging];
skill meteorShower = $skill[Meteor Shower];
skill accordionBash = $skill[Accordion Bash];
item boomBox = $item[SongBoom&trade; BoomBox];
skill singAlong = $skill[Sing Along];
item bling = $item[Bling of the New Wave];
item bakeBackpack = $item[bakelite backpack];
item carpe = $item[carpe];
item snowglobe = $item[KoL Con 13 snowglobe];
item screege = $item[Mr. Screege's spectacles];
item cheeng = $item[Mr. Cheeng's spectacles];
item mayfly = $item[mayfly bait necklace];
skill extractJelly = $skill[Extract Jelly];
skill extract = $skill[Extract];
skill duplicate = $skill[Duplicate];
skill pocketCrumbs = $skill[Pocket Crumbs];
item bittyMeat = $item[BittyCar MeatCar];
item vampCloake = $item[vampyric cloake];
skill wolfForm = $skill[Become a Wolf];

// monster level so it can survive longer
skill annoyingNoise = $skill[Drescher's Annoying Noise];
effect annoyingNoiseEffect = $effect[Drescher's Annoying Noise];
skill annoyance = $skill[Ur-Kel's Aria of Annoyance];
effect annoyanceEffect = $effect[Ur-Kel's Aria of Annoyance];
item greekFire = $item[Greek fire];
effect greekFireEffect = $effect[Sweetbreads Flamb&eacute;];

// running away
skill cleesh = $skill[Cleesh];
item fishermansack = $item[fisherman's sack]; // quest item after completing nemesis quest as AT
item smokebomb = $item[fish-oil smoke bomb]; // quest item receive 3 from each fisherman's sack, use 'em or lose 'em on ascending


// Skills for more turns
skill odeToBooze = $skill[The Ode to Booze];
effect odeToBoozeEffect = $effect[Ode to Booze]; //
//item songSpaceAcc = $item[La Hebilla del Cinturón de Lopez];
item songSpaceAcc = $item[La Hebilla del Cintur&oacute;n de Lopez];
skill calcUniverse = $skill[Calculate the Universe];

// skills for +meat bonus
skill leer = $skill[Disco Leer];
skill polka = $skill[The Polka of Plenty];
skill thingfinder = $skill[The Ballad of Richie Thingfinder];
skill companionship = $skill[Chorale of Companionship];
skill phatLoot = $skill[Fat Leon's Phat Loot Lyric];
skill sweetSynth = $skill[Sweet Synthesis];
skill selfEsteem = $skill[Incredible Self-Esteem];
skill favoriteBird = $skill[Visit your Favorite Bird];
item birdCalendar = $item[Bird-a-Day calendar];
skill seekBird = $skill[Seek out a bird];
effect seekBirdEffect = $effect[Blessing of the bird];
// skills for pet bonus
skill leash = $skill[Leash of Linguini];
skill empathy = $skill[Empathy of the Newt];
//item petBuff = $item[Knob Goblin pet-buffing spray];
item kinder = $item[resolution: be kinder];
item blueTaffy = $item[pulled blue taffy];
item joy = $item[abstraction: joy];
skill bloodBond = $skill[Blood Bond];
effect bloodBondEffect = $effect[Blood Bond];
skill antibiotic = $skill[Antibiotic Saucesphere]; // to help cancel the HP drain of blood bond, in case you're missing HP regen

// items for +meat bonus
item vipKey = $item[Clan VIP Lounge key]; // for clan VIP room access
item floundry = $item[Clan Floundry]; // for carpe
item poolTable = $item[Clan Pool Table];
item faxMachine = $item[deluxe fax machine];
item blBackpack = $item[Bakelite Backpack]; // with accordion bash
item halfPurse = $item[Half a Purse]; // requires Smithsness to be effective
item sunglasses = $item[cheap sunglasses]; // only relevant for barf mountain
item deck = $item[Deck of Every Card]; // required for knife or rope if part of outfit
item knife = $item[knife]; // from deck of every card
item rope = $item[rope]; // from deck of every card
item burningCrane = $item[burning paper crane]; // folding burning newspaper
item bastille = $item[Bastille Battalion control rig];
item brogues = $item[Brutal brogues]; // from Bastille Battalion
item cologne = $item[beggin' cologne]; // 1 spleen for 100% for 60 turns
effect cologneEffect = $effect[Eau d' Clochard]; // 1 spleen for 100% for 60 turns

item mafiaPointerRing = $item[mafia pointer finger ring]; // gets +200% base meat from crits
skill furiousWallop = $skill[Furious Wallop]; // seal clubber skill with guaranteed crit
item haikuKatana = $item[haiku katana]; // IotM weapon with guaranteed crit
skill haikuCrit = $skill[Summer Siesta]; // guaranteed critical hit skill from haiku katana
item patriotShield = $item[Operation Patriot Shield]; // IotM offhand with guaranteed crit
skill patriotCrit = $skill[Throw Shield]; // guaranteed critical hit skill from haiku katana

item cosplaySaber = $item[Fourth of May Cosplay Saber]; // for the +10 familiar weight
item scratchSword = $item[scratch 'n' sniff sword]; // only worthwhile for embezzlers
item scratchXbow = $item[scratch 'n' sniff crossbow]; // only worthwhile for embezzlers
item scratchUPC = $item[scratch 'n' sniff UPC sticker]; // attaches to crossbow or sword
//item nasalSpray = $item[Knob Goblin nasal spray]; // bought from knob goblin dispensary
item wealthy = $item[resolution: be wealthier]; // from libram of resolutions
item affirmationCollect = $item[Daily Affirmation: Always be Collecting]; // from new you club
item avoidScams = $item[How to Avoid Scams]; // only relevant for barf mountain
item begpwnia = $item[begpwnia]; // 30% from mayflower bouquet
item geneConstellation = $item[Gene Tonic: Constellation];
effect geneConstellationEffect = $effect[Human-Constellation Hybrid];
item geneFish = $item[Gene Tonic: Fish];
effect geneFishEffect = $effect[Human-Fish Hybrid];
item flaskfull = $item[Flaskfull of Hollow]; // + smithness for Half a Purse
item dice = $item[Glenn's golden dice]; // once a day random buffs
item pantsGiving = $item[Pantsgiving]; // wear for combat skills, fullnes reduction
item gameToken = $item[defective Game Grid token]; // once a day activate for 5 turns of +5 everything
item chibiOff = $item[ChibiBuddy&trade; (off)]; // once a day activate for 5 turns of +5 familiar weight
item chibiOn = $item[ChibiBuddy&trade; (on)]; // once a day activate for 5 turns of +5 familiar weight
item mumming = $item[mumming trunk]; // cast +meat or +item on familiar
item comb = $item[Beach Comb]; // cast +5 familiar weight once a day

// 2 day items for +meat bonus
item peppermint = $item[peppermint twist]; // candy drop from robort
item micks = $item[Mick's IcyVapoHotness Inhaler]; // from semi-rare
item sugar = $item[baggie of powdered sugar]; // 
item pinkHeart = $item[pink candy heart];
item polkaPop = $item[Polka Pop];
item cranberryCordial = $item[cranberry cordial];

// special activations for +meat bonus
string summonGreed = "summon 2"; // summoning chamber if you've learned the Hoom-Ha name
string meatEnh = "terminal enhance meat.enh"; // if you have a source terminal
string concertWinklered = "concert Winklered"; // if you helped the Orcs in the island war and finished fliering for the concert
string concertOptimistPrimal = "concert Optimist Primal"; // if you helped the Hippies in the island war and finished fliering for the concert
string hatterDreadSack = "hatter filthy knitted dread sack"; // need a Drink-me potion and a filthy knitted dread sack from hippies

// effects for +meat bonus
effect winklered = $effect[Winklered]; // from concert if you helped orcs
effect sinuses = $effect[Sinuses For Miles]; // from Mick's
//effect nasalSprayEffect = $effect[Wasabi Sinuses]; // from Knob Goblin nasal spray
effect resolve = $effect[Greedy Resolve]; // from resolution: be wealthy
effect alwaysCollecting = $effect[Always be Collecting]; // DailyAffirmation: always be collecting
effect workForHours = $effect[Work For Hours a Week]; // DailyAffirmation: Work for hours a week
effect begpwniaEffect = $effect[Can't Be a Chooser]; // from begpwnia
effect avoidScamsEffect = $effect[How to Scam Tourists]; // from How to Avoid Scams
effect leering = $effect[Disco Leer]; // from Disco Leer (disco bandit skill)
effect polkad = $effect[Polka of Plenty]; // from Polka (accordion thief)
effect phatLooted = $effect[Fat Leon's Phat Loot Lyric]; // from Fat Leon's (accordion thief)
effect thingfinderEffect = $effect[The Ballad of Richie Thingfinder]; // accordion thief only
effect companionshipEffect = $effect[Chorale of Companionship]; // accordion thief only
effect meatEnhanced = $effect[meat.enh]; // source terminal, 60%, 3x 100 turns a day
effect danceTweedle = $effect[Dances with Tweedles]; // from DRINK ME potion, once a day, 40%, 30 turns
effect merrySmith = $effect[Merry Smithsness]; // from Flaskfull of Hollow
effect kickedInSinuses = $effect[Kicked in the Sinuses]; // from horseradish
effect foodConeEffect = $effect[The Dinsey Way]; // from Dinsey Food Cone
effect seaTruffleEffect = $effect[Trufflin']; // from the sea truffle
effect thanksgetting = $effect[Thanksgetting]; // from thanksgetting feast items
effect synthGreed = $effect[Synthesis: Greed]; // from Sweet Synthesis skill
effect preternatualGreed = $effect[Preternatural Greed];
effect eggEffect = $effect[Egg-stortionary Tactics];
effect gingerWineEffect = $effect[High-Falutin'];
effect dirtEffect = $effect[Here's Some More Mud in Your Eye];
effect turkeyEffect = $effect[Turkey-Ambitious];
effect joyEffect = $effect[Joy];
effect pinkHeartEffect = $effect[Heart of Pink];
effect polkaPopEffect = $effect[Polka Face];
effect peppermintEffect = $effect[Peppermint Twisted];
effect sugarEffect = $effect[So You Can Work More...];
effect cranberryCordialEffect = $effect[Cranberry Cordiality];
effect poolEffect = $effect[Billiards Belligerence];
effect kgbMeat = $effect[A View to Some Meat];
effect kgbItems = $effect[Items Are Forever];
effect bagOTricksEffect1 = $effect[Badger Underfoot];
effect bagOTricksEffect2 = $effect[Weasels Underfoot];
effect bagOTricksEffect3 = $effect[Chihuahua Underfoot];

// effects for pet weight bonus
effect leashEffect = $effect[Leash of Linguini];
effect empathyEffect = $effect[Empathy];
effect petBuffEffect = $effect[Heavy Petting];
effect kinderEffect = $effect[Kindly Resolve];
effect blueTaffyEffect = $effect[Blue Swayed];
effect chibiEffect = $effect[ChibiChanged&trade;];
effect beachHeadWeight = $effect[Do I Know You From Somewhere?];

// skills to activate Bag O' Tricks
skill mortarShell = $skill[Stuffed Mortar Shell]; // this one is special because it has a one turn delay
skill BoTspell1 = $skill[Spaghetti Spear]; // low damage
skill BoTspell2 = $skill[Salsaball]; // low damage
skill sauceStorm = $skill[Saucestorm]; // likely to have skill
skill thrustSmack = $skill[Lunging Thrust-Smack];
skill weaponPasta = $skill[Weapon of the Pastalord];

// between turns skills
skill summonRes = $skill[Summon Resolutions];
skill summonTaffy = $skill[Summon Taffy];
skill summonCandy = $skill[Summon Candy Heart];
skill summonParty = $skill[Summon Party Favor];
skill summonLove = $skill[Summon Love Song];
skill summonBricko = $skill[Summon BRICKOs];
skill summonDice = $skill[Summon Dice];
skill soulFood = $skill[Soul Food];
// mana cost reduction
item oscusWeapon = $item[Wand of Oscus];
item oscusPants = $item[Oscus's dumpster waders];
item oscusAccessory = $item[Oscus's pelt];
item brimstoneBracelet = $item[Brimstone Bracelet];
item kgb = $item[Kremlin's Greatest Briefcase];
item rubber = $item[orcish rubber];
effect rubberEffect = $effect[Using Protection];
// max mana increase
item hawkings = $item[Hawking's Elixir of Brilliance];
effect hawkingsEffect = $effect[On the Shoulders of Giants];
item onePill = $item[one pill];
effect onePillLarge = $effect[Larger];
effect onePillSmall = $effect[Small];
skill notAKnife = $skill[That's Not a Knife];
item candyKnife = $item[candy knife];
item occult = $item[ointment of the occult];
effect occultEffect = $effect[Mystically Oiled];
item tomatoJuice = $item[tomato juice of powerful power];
effect tomatoJuiceEffect = $effect[Tomato Power];
item mascara = $item[glittery mascara];
effect mascaraEffect = $effect[Glittering Eyelashes];
effect anyToMystEffect = $effect[Phairly Balanced];
item muscleToMyst = $item[oil of stability];
effect muscleToMystEffect = $effect[Stabilizing Oiliness];
item moxieToMyst = $item[oil of slipperiness];
effect moxieToMystEffect = $effect[Slippery Oiliness];
item circleDrum = $item[Circle Drum];
effect circleDrumEffect = $effect[Feelin' the Rhythm!];
item sugarShorts = $item[sugar shorts];
skill quietJudgement = $skill[Quiet Judgement];
effect quietJudgementEffect = $effect[Quiet Judgement];
effect cucumberEffect = $effect[Uncucumbered];


// locations for adventuring
location garbagePirates = $location[Pirates of the Garbage Barges]; // for orphan costume
location uncleGator = $location[Uncle Gator's Country Fun-Time Liquid Waste Sluice];
location toxicTeacups = $location[The Toxic Teacups];
location covePirates = $location[The Obligatory Pirate's Cove]; // alternate for orphan costume... wait a second, we should always have main pirates location
location castleTopFloor = $location[The Castle in the Clouds in the Sky (Top Floor)]; // semi-rare
location purpleLight = $location[The Purple Light District]; // semi-rare
location treasury = $location[Cobb's Knob Treasury]; // semi-rare
location barfMountain = $location[Barf Mountain]; // main adventure location
location snojo = $location[The X-32-F Combat Training Snowman];
location neverParty = $location[The Neverending Party];
item football = $item[cosmetic football];

// Maximizing mana for summoning
location TUNNEL = $location[The Tunnel of L.O.V.E.];
monster LOVenforcer = $monster[LOV Enforcer];
monster LOVengineer =  $monster[LOV Engineer];
monster LOVequivocator =  $monster[LOV Equivocator];
effect synthMyst = $effect[Synthesis: Smart]; // from Sweet Synthesis skill
effect synthMP = $effect[Synthesis: Energy]; // from Sweet Synthesis skill
effect favorLyle = $effect[Favored by Lyle];
item licenseChill = $item[License to Chill]; // mana restore
item yexpressCard = $item[Platinum Yendorian Express Card]; // mana restore
item oscusSoda = $item[Oscus's neverending soda];
item aprilShower = $item[Clan Shower];
item eternalBattery = $item[Eternal Car Battery];
skill discoNap = $skill[Disco Nap];
skill leisure = $skill[Adventurer of Leisure];
skill narcolepsy = $skill[Executive Narcolepsy];
skill turbo = $skill[Turbo];
effect overheated = $effect[Overheated];
item pilgrimHat = $item[Giant pilgrim hat];
item snowFort = $item[Snow Fort];
effect snowFortified = $effect[Snow Fortified];
item clarasBell = $item[Clara's bell];
item hoboBinder = $item[hobo code binder];
skill getBig = $skill[Get Big];
effect big = $effect[Big];
item powerGlove = $item[Powerful Glove];
skill tripleSize = $skill[CHEAT CODE: Triple Size];
effect tripleSizeEffect = $effect[Triple-Sized];

// healing between turns
effect beatenUp = $effect[Beaten Up];
skill walrus = $skill[Tongue of the Walrus];
skill cocoon = $skill[Cannelloni Cocoon];

// makin' copies, at the copy machine
item camera = $item[4-d camera];
item usedcamera = $item[Shaking 4-d camera];
item beerLens = $item[beer lens];
item nothingInTheBox = $item[nothing-in-the-box];
item enamorang = $item[LOV Enamorang];
item BACON = $item[BACON];
item usedFax = $item[photocopied monster];
item printScreen = $item[print screen button];
item usedPrintScreen = $item[screencapped monster];
item spookyPutty = $item[Spooky Putty sheet];
item usedSpookyPutty = $item[Spooky Putty monster];
item unopenedRainDoh = $item[can of Rain-Doh];
item rainDoh = $item[Rain-Doh black box];
item usedRainDoh = $item[Rain-Doh box full of monster];
skill digitize = $skill[Digitize];
skill romanticArrow = $skill[Fire a badly romantic arrow];
skill winkAt = $skill[Wink at];

monster embezzler = $monster[Knob Goblin Embezzler];
monster mimeExecutive = $monster[cheerless mime executive]; // this was 1500, now it's 500
monster meatyMonster = embezzler;
monster tourist = $monster[garbage tourist];
skill olfaction = $skill[Transcendent Olfaction];
effect olfactionEffect = $effect[On the Trail];

// semi-rare
item nickel = $item[hobo nickel];
item pillKeeper = $item[Eight Days a Week Pill Keeper];
// keys
item billiardKey = $item[Spookyraven billiards room key];
item keyCardAlpha = $item[keycard &alpha;];
item keyCardBeta = $item[keycard &beta;];
item keyCardGamma = $item[keycard &gamma;];
item keyCardDelta = $item[keycard &delta;];

// barf mountain quest
item bagOfGarbage = $item[bag of park garbage];
item lubeShoes = $item[lube-shoes];
string kioskUrl = "place.php?whichplace=airport_stench&action=airport3_kiosk";
string maintenanceUrl = "place.php?whichplace=airport_stench&action=airport3_tunnels";

// Gingerbread
location gingerCivic = $location[Gingerbread Civic Center];
location gingerTrain = $location[Gingerbread Train Station];
location gingerRetail = $location[Gingerbread Upscale Retail District];
item gingerHead = $item[gingerbread tophat];
item gingerShirt = $item[gingerbread waistcoat];
item gingerPants = $item[gingerbread trousers];
item gingerAcc1 = $item[candy dress shoes];
item gingerAcc2 = $item[candy necktie];
item gingerAcc3 = $item[chocolate pocketwatch];
item gingerSprinkles = $item[sprinkles];

// Madness bakery
item strawberry = $item[strawberry];
item icing = $item[glob of enchanted icing];
item popPart = $item[popular part];

// effect which will confuse KoLmafia
item greendrops = $item[soft green echo eyedrop antidote]; // remove undesirable effects
item homophones = $item[staph of homophones]; // changes words to their homophones
item prepositions = $item[sword behind inappropriate prepositions]; // restructures sentences
item papier1 = $item[papier-mitre]; // inserts random words into sentences
item papier2 = $item[Papier-m&acirc;churidars]; // inserts random words into sentences
item papier3 = $item[papier-masque]; // inserts random words into sentences
item moonSpoon = $item[hewn moon-rune spoon]; // converts random words into rhymes
effect disAbled = $effect[Dis Abled]; // turns everything into rhymes
effect anapests = $effect[Just the Best Anapests]; // turns everything into rhymes
effect haikuMind = $effect[Haiku State of Mind]; // turns everything into haiku
effect tempBlind = $effect[Temporary Blindness]; // makes messages just say you're blind

// free combats
item genie = $item[genie bottle];
item wish = $item[pocket wish];
effect covetous = $effect[Covetous Robbery]; // raises base meat drop on stingy monsters
effect attunement = $effect[Eldritch Attunement]; // take an extra combat after free combat
effect frosty = $effect[frosty]; // +200% meat, +100% item drop
effect braaaaaains = $effect[Braaaaaains]; // +200% meat, -50% item drop
skill evokeHorror = $skill[Evoke Eldritch Horror]; // fight an eldritch horror
item uraniumSeal = $item[depleted uranium seal figurine]; // 5 extra seal fights
item lynyrdSnare = $item[lynyrd snare]; // 3 free fights a day
item scorpions = $item[Bowl of Scorpions]; // 11 free fights a day
item brickoOoze = $item[BRICKO ooze]; // 10 free fights a day
item brickoBrick = $item[BRICKO brick]; // to make oozes from
item brickoEye = $item[BRICKO eye brick]; // also required to make oozes
location machineTunnels = $location[The Deep Machine Tunnels]; // needs machine elf
monster machineTriangle = $monster[Perceiver of Sensations];
monster machineCircle = $monster[Thinker of Thoughts];
monster machineSquare = $monster[Performer of Actions];
item abstrThought = $item[abstraction: thought];
item abstrAction = $item[abstraction: action];
item abstrSensation = $item[abstraction: sensation];
location bowlingAlley = $location[The Hidden Bowling Alley];
item bowlingBall = $item[bowling ball];
monster bowler = $monster[pygmy bowler];
monster janitor = $monster[pygmy janitor];
monster orderlies = $monster[pygmy orderlies];
item votedSticker = $item[&quot;I Voted!&quot; sticker];
monster mutant = $monster[terrible mutant];
item mutantArm = $item[mutant arm];
item mutantLegs = $item[mutant legs];
item mutantCrown = $item[mutant crown];
item doctorBag = $item[Lil' Doctor&trade; Bag];
item kramco = $item[Kramco Sausage-o-Matic&trade;];
monster kramcoGoblin = $monster[sausage goblin];
item glitch = $item[[Glitch season reward name]];
monster tentacle = $monster[eldritch tentacle];

// seal clubber supplies
item bludgeon = $item[Brimstone Bludgeon];
item tenderizer = $item[Meat Tenderizer is Murder];
item club = $item[seal-clubbing club];
item sealFigurine = $item[figurine of a wretched-looking seal];
item sealCandle = $item[seal-blubber candle];

// banish skills and items
skill snokebomb = $skill[Snokebomb];
item louderThanBomb = $item[Louder Than Bomb];
item tennisBall = $item[tennis ball];

// cheesy items to increase rollover adventures
item cheeseStaff = $item[Staff of Queso Escusado];
item cheeseSword = $item[stinky cheese sword];
item cheesePants = $item[stinky cheese diaper];
item cheeseShield = $item[stinky cheese wheel];
item cheeseAccessory = $item[stinky cheese eye];

// mojo filter farming
location oasis = $location[The Oasis];
effect ultrahydrated = $effect[Ultrahydrated];
skill squint = $skill[Steely-Eyed Squint];
effect squintEffect = $effect[Steely-Eyed Squint];
item garbageTote = $item[January's Garbage Tote];
item champagne = $item[broken champagne bottle];
item fairCoin = $item[perfectly fair coin];
effect fairCoinEffect = $effect[What Are The Odds!?];
item legendaryBeat = $item[The Legendary Beat];
effect legendaryBeatEffect = $effect[Clyde's Blessing];
familiar hipster = $familiar[Mini-Hipster];
familiar goth = $familiar[Artistic Goth Kid];
familiar hand = $familiar[Disembodied Hand];
familiar cat = $familiar[Cat Burglar];

// script state variables
familiar runFamiliar;
float snowSuitWeight = 0;
boolean canPickpocket = false;
boolean canPocketCrumb = false;
boolean canRaveNirvana = false; // meat drops
boolean canRaveConcentration = false; // item drops
boolean canRaveSteal = false; // steal an item
boolean canAccordionBash = false;
boolean canSingAlong = false;
string bagOTricksSkill = "";
boolean needsSpookyPutty = false;
boolean needsRainDoh = false;
boolean needsDigitize = false;
boolean needsPrintScreen = false;
boolean needsCamera = false;
boolean needsEnamorang = false;
boolean needsRomanticArrow = false;
boolean needsWinkAt = false;
boolean needsMeteorShower = false;
boolean needsMayfly = false;
boolean needsCleesh = false;
boolean needsSmokeBomb = false;
boolean needsCrit = false;
boolean canExtract = false;
boolean canDuplicate = false;
boolean canTurbo = false;
boolean needWolfForm = false;
int enamorangsUsed = 0;
boolean digitizeActivationNeeded = false;
boolean canJokesterGun = false;
boolean canBatoomerang = false;
boolean canXray = false;
boolean canMissileLauncher = false;
boolean canUseForce = false;
boolean shouldMissileLauncher = false;
boolean canShatteringPunch = false;
boolean canMobHit = false;
boolean hasFreeKillRemaining = false;
boolean needBagOTricks = false;
boolean canMortar = mortarShell.have_skill();
int digitizeCounter = 0;
int enamorangCounter = 0;
int voteCounter = 0;
int fortuneCookieCounter = 0;
int spookyravenCounter = 0;
int maxItemUse = funkslinging.have_skill() ? 2 : 1;
boolean eatWithoutMayo = false;
int semiRareAttempted = 0; // once we attempt a semi-rare on a turn, don't retry.  This is the turn number it was attempted 

boolean ravedNirvana = false;
boolean ravedSteal = false;
boolean ravedConcentration = false;
boolean timeSpinnered = false;
skill summonCurrent = summonRes;

int ghostShot = 0;
int stunRound = 0;
boolean cursed = false;
boolean mortared = false;
boolean duplicated = false;
boolean micrometeorited = false;
boolean extracted = false;
boolean bashed = false;
boolean bubbled = false;
boolean noodled = false;
boolean critted = false;
boolean shielded = false;
boolean abstractioned = false;
boolean usedForce = false;
boolean lecturedRelativity = false;
int staggerOption = 0;

item[slot] defaultOutfitPieces; // const outfit initialized on first use
item[slot] meatyOutfitPieces; // const outfit initialized on first use
item[slot] dropsOutfitPieces; // const outfit initialized on first use
item[slot] weightOutfitPieces; // const outfit initialized on first use
item[slot] barfOutfitPieces; // working outfit for barf mountain, modified by various constraints

// forward declarations of functions:
void ChooseDropsFamiliar(boolean isElemental);
boolean TryEquipFamiliarEquipment(item eqp, float eqpBonus);
void CastSkill(skill sk, int requestedTurns, boolean regenMP);
void PrepareFamiliar(boolean forMeaty);
void PrepareMeaty();
boolean TryEat(item food, effect desiredEffect, int providedFullness, int followupFullness, int turnLimit, boolean eatUnique);
void UseWarbearOven();
void BeforeSwapOutDNALab();
void BeforeSwapOutAsdon();
void BeforeSwapOutMayo();
void BeforeSwapOutWorkshop(item newItem);
void TryReduceManaCost(skill sk);
void MaxManaSummons();
void ChooseEducate(boolean duplicate, boolean digitize);
void ChooseThrall(boolean forMeat);  //, boolean forItems)
void EquipBjornCrownFamiliars(familiar first, familiar second);
void ChooseBjornCrownFamiliars(boolean forMeaty);
void ActivateChibiBuddy();
void ActivateFortuneTeller();
void BuffInRun(int turns, boolean restoreMP);
item[slot] SwapOutSunglasses(item[slot] selectedOutfit);
item[slot] InitOutfit(string outfitName);
item[slot] InitOutfit(string outfitName, item[slot] result);
void DebugOutfit(string name, item[slot] o);
item ChooseCheapestThanksgetting();
boolean TryHandleNonCombat(string page);
boolean TryScratchNSniff(item[slot] forOutfit);
void DoVoting();
void PrepGarden();

// general utility functions
boolean RoomToEat(int size)
{
	return size <= fullness_limit() - my_fullness() - saveStomach;
}
boolean RoomToDrink(int size)
{
	return size <= inebriety_limit() - my_inebriety() - saveLiver;
}
boolean RoomToSpleen(int size)
{
	return size <= spleen_limit() - my_spleen_use() - saveSpleen;
}
boolean UserConfirmDefault(string message, boolean defaultValue)
{
	if (autoConfirm)
	{
		print("Skipping confirmation for request '" + message + "' with default value = " + defaultValue, printColor);
		return defaultValue;
	}
	boolean result = user_confirm(message);
	print("User responded to query '" + message + "' with value = " + result, printColor);
	return result;
}
int FindVariableChoice(string page, string match, boolean matchTextIsButtonText)
{
	int ix = page.index_of(match);
	if (ix <= 0)
		return -1;

	string optionSearch = "<input type=hidden name=option value=";
	if (matchTextIsButtonText) // the name=option value=1 comes before the button text
		ix = last_index_of(page, optionSearch, ix);
	else // otherwise we found a prefix with that text
		ix = page.index_of(optionSearch, ix);
	if (ix <= 0)
		return -1;
	ix += optionSearch.length();

	string choice = page.substring(ix, ix + 2); // allow up to 99 options
	choice = choice.replace_string(">", "").replace_string("/", "").replace_string(" ", ""); // strip off extra invalid character
	return choice.to_int();
}
boolean PushChoiceAdventureButton(string page, string buttonText)
{
	int ix = FindVariableChoice(page, buttonText, true);
	if (ix < 0)
		return false;
	run_choice(ix);
	return true;
}
boolean InList(string value, string list, string delimiter)
{
	if (value == list)
		return true;
	if (list.length() <= value.length())
		return false;
	if (list.contains_text(delimiter + value + delimiter))
		return true;
	if (list.substring(0, value.length() + 1) == value + delimiter)
		return true;
	if (list.substring(list.length() - value.length() - 1) == delimiter + value)
		return true;
	return false;
}
boolean LoadChoiceAdventure(string url, string loc, boolean optional)
{
	string page = visit_url(url);

	if (TryHandleNonCombat(page))
		return false; // already handled, don't make caller think they get to choose

	if (page.contains_text("choice.php"))
		return true;

	if (!optional)
		abort("Unexpected adventure at " + loc);
	return false;
}
boolean LoadChoiceAdventure(location loc, boolean optional)
{
	return LoadChoiceAdventure(loc.to_url().to_string(), loc.to_string(), optional);
}
boolean CanCast(skill sk)
{
	if (!sk.have_skill())
		return false;
	return sk.mp_cost() <= my_mp();
}

boolean HaveEaten(item food)
{
	string eatenList = get_property("_timeSpinnerFoodAvailable");
	string itemID = food.to_int().to_string();
	return InList(itemID, eatenList, ",");
}

boolean TryGetFromCloset(item i, int count)
{
	if (count <= 0)
		return true;
	if (!autoPvpCloset)
		return false;
	if (i.item_amount() < count && i.closet_amount() > 0)
	{
		int takeCount = i.closet_amount();
		if (takeCount > count)
			takeCount = count;
		takeCount -= i.item_amount();
		if (takeCount > 0)
			take_closet(takeCount, i);
	}
	if (i.item_amount() < count && i.storage_amount() > 0)
	{
		int takeCount = i.storage_amount();
		if (takeCount > count)
			takeCount = count;
		takeCount -= i.item_amount();
		if (takeCount > 0)
			take_storage(takeCount, i);
	}
	return i.item_amount() >= count;
}
void UseOneTotal(item i, effect e)
{
	if (e.have_effect() == 0)
	{
		i.TryGetFromCloset(1);
		if (i.item_amount() > 0)
		{
			use(1, i);
		}
	}
}
void BuyAndUseOneTotal(item i, effect e, int maxCost)
{
	if (e.have_effect() > 0)
		return;
	i.TryGetFromCloset(1);
	if (i.item_amount() == 0)
	{
		buy(1, i, maxCost);
	}
	else if (i.mall_price() == 100)
	{
		buy(1, i, 100);
	}
	if (i.item_amount() > 0)
	{
		use(1, i);
	}
}

boolean familiarListInitialized = false;
familiar[int] cachedFamiliarList;
familiar[int] GetFamiliarList()
{
	if (familiarListInitialized)
		return cachedFamiliarList;
	familiarListInitialized = true;
	foreach fam in $familiars[]
	{
		if (fam.have_familiar())
			cachedFamiliarList[fam.to_int()] = fam;
	}
	return cachedFamiliarList;
}

boolean HaveEquipment(item itm)
{
	if ( itm.item_amount() > 0 || itm.have_equipped() )
		return true;
	if (itm.to_slot() == weapon)
		return $familiar[disembodied hand].familiar_equipped_equipment() == itm;
	if (itm.to_slot() == offhand)
		return $familiar[left-hand man].familiar_equipped_equipment() == itm;
	if (itm.to_slot() == famEqp)
	{
		familiar[int] myFamiliars = GetFamiliarList();
		foreach id, fam in myFamiliars
		{
			if (fam.familiar_equipped_equipment() == itm)
				return true;
		}
	}
	return false;
}
boolean OutfitContains(string outfit, item eq)
{
	foreach key,value in outfit_pieces(outfit)
		if (value == eq)
			return true;
	return false;
}
boolean OutfitContains(item[slot] outfitDef, item eq)
{
	foreach key,value in outfitDef
		if (value == eq)
			return true;
	return false;
}

boolean AscensionScheduledToday()
{
	return ascendToday == (my_ascensions() + "," + my_daycount());
}

void SetBastilleBattalionMode(int option, string target)
{
	if (target == "")
		return;
	string page;
	for (int i = 0; i < 3; i++)
	{
		page = visit_url("choice.php?whichchoice=1313&option=" + option + "&pwd=" + my_hash());
		if (page.contains_text(target))
			return;
	}
	abort("Failed to set Bastille Battallion mode to " + target);
}
void ExecuteBastilleBattalion(string target1, string target2, string target3)
{
	if (bastille.item_amount() == 0
		&& get_property("_bastilleGames").to_int() == 0)
	{
		return;
	}
	visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9928");
	SetBastilleBattalionMode(1, target1);
	SetBastilleBattalionMode(2, target2);
	SetBastilleBattalionMode(3, target3);

	visit_url("choice.php?whichchoice=1313&option=5&pwd=" + my_hash());
	for (int i = 0; i < 31; i++) // up to 15 rounds, each round requires 2 choices
	{
		int choiceCount = available_choice_options().count();
		if (choiceCount == 0)
			return;
		if (choiceCount != 3)
			abort("Unexpected number of choices");
		run_choice(3); // Always take the 3rd option, the last time #3 should be "I'm done for now"
	}
	run_choice(8); // just in case the last option required is "Walk Away", not sure what the difference is
}
void MakeMeltingGear(item[slot] outfitDef)
{
	if (!HaveEquipment(knife)
		&& OutfitContains(outfitDef, knife)
		&& deck.item_amount() > 0
		&& get_property("_deckCardsDrawn").to_int() <= 10)
	{
		cli_execute("cheat knife");
	}
	if (!HaveEquipment(rope)
		&& OutfitContains(outfitDef, rope)
		&& deck.item_amount() > 0
		&& get_property("_deckCardsDrawn").to_int() <= 10)
	{
		cli_execute("cheat rope");
	}
	if (!HaveEquipment(brogues)
		&& OutfitContains(outfitDef, brogues)
		&& bastille.item_amount() > 0
		&& get_property("_bastilleGames").to_int() == 0)
	{
		ExecuteBastilleBattalion("", "BRUTALIST", "GESTURE"); // BRUTALIST = brogues, GESTURE = +25 meat
	}
	if (!HaveEquipment(burningCrane)
		&& OutfitContains(outfitDef, burningCrane)
		&& $item[burning newspaper].item_amount() > 0)
	{
		cli_execute("create burning paper crane");
	}
	if (!HaveEquipment(carpe)
		&& OutfitContains(outfitDef, carpe)
		&& vipKey.item_amount() > 0
		&& get_property("_floundryItemCreated") == "false"
		&& get_clan_lounge() contains floundry)
	{
		if (user_confirm("Spend 10 of your guild's fish to make a carpe?  (Make sure you refill it if you do.)"))
			cli_execute("create carpe");
	}
	if ((!HaveEquipment(scratchXbow) && OutfitContains(outfitDef, scratchXbow))
			|| (!HaveEquipment(scratchSword) && OutfitContains(outfitDef, scratchSword)))
	{
		TryScratchNSniff(outfitDef);
	}
	if (OutfitContains(outfitDef, cosplaySaber)
		&& HaveEquipment(cosplaySaber)
		&& get_property("_saberMod") == "0")
	{
		string page = visit_url("main.php?action=may4");
		if (page.contains_text("Empathy Chip"))
			visit_url("choice.php?whichchoice=1386&option=4"); // +10 familiar weight
	}
}

item[slot] GetCurrentGear()
{
	item[slot] result;
	foreach sl,i in outfitSlots
		if (sl.equipped_item() != noItem)
			result[sl] = sl.equipped_item();
	return result;
}

int CountOutfitMatches(item[slot] outfitGoal, item[slot] swapGear)
{
	int result = 0;
	foreach sl,it in outfitGoal
	{
		if (!it.HaveEquipment())
			return -1;
		if (swapGear[sl] == it
			&& (outfitSlots contains sl)) // don't count familiar equipment or stickers here
		{
			result++;
		}
	}
	return result;
}

// lazy initialize, Mafia doesn't return the number of an outfit, so manually create the mapping
// from custom outfit name to outfit #
int[string] outfitsByNumber;
boolean outfitsByNumberInitialized = false;
void CalcOutfitsByNumber()
{
	if (outfitsByNumberInitialized)
		return;
	outfitsByNumberInitialized = true;
	static string searchPattern = "#(\\d*).*?name=.*?value=\"(.*?)\"\\s*>";
	string page = visit_url("account_manageoutfits.php");
	
	matcher m = searchPattern.create_matcher(page);
	while (m.find())
	{
		outfitsByNumber[m.group(2)] = m.group(1).to_int();
		//print("outfit # = '" + m.group(1) + "', name ='" + m.group(2) + "'", printColor); // DEBUG
	}
}

void WearOutfit(item[slot] outfitDef)
{
	if (isDebug)
	{
		DebugOutfit("Current gear", GetCurrentGear());
		DebugOutfit("Goal outfit", outfitDef);
	}
//abort("Debugging");
	MakeMeltingGear(outfitDef);
	boolean matches = true;
	foreach sl,it in outfitDef
	{
		if (it != $item[none] && sl.equipped_item() != it)
			matches = false;
	}
	if (matches)
		return;
	int maxMatches = 0;
	string bestMatch = "";
	foreach ignoreNumber,outfitName in get_custom_outfits()
	{
		//print("Checking outfit " + outfitName, printColor); // DEBUG
		int matchCount = CountOutfitMatches(outfitDef, InitOutfit(outfitName, GetCurrentGear()));
		if (matchCount > maxMatches)
		{
			print("Better outfit match with " + outfitName + " matches = " + matchCount, printColor);
			maxMatches = matchCount;
			bestMatch = outfitName;
		}
	}
	foreach ignoreNumber,outfitName in get_outfits()
	{
		int matchCount = CountOutfitMatches(outfitDef, InitOutfit(outfitName, GetCurrentGear()));
		if (matchCount > maxMatches)
		{
			print("Better outfit match with " + outfitName + " matches = " + matchCount, printColor);
			maxMatches = matchCount;
			bestMatch = outfitName;
		}
	}
	int currentMatchCount = CountOutfitMatches(outfitDef, GetCurrentGear());
	// has to be at least 2 closer to make an "outfit" command more efficient than swapping a single item
	if (maxMatches >= currentMatchCount + 2)
	{
		print("Swapping outfit to " + bestMatch, printColor);
		// if the outfit contains illegal items, mafia will refuse to even try to equip it on a call to "outfit", so
		// manually call the url to equip the outfit closest to our goal:
		CalcOutfitsByNumber();
		if (outfitsByNumber contains bestMatch)
		{
			int outfitNum = outfitsByNumber[bestMatch];
			print("wearing outfit " + bestMatch + " #" + outfitNum);
			string url = "inv_equip.php?action=outfit&which=2&whichoutfit=-" + outfitNum;
			//boolean ignore = cli_execute("try; visit_url " + url);
			string ignore = visit_url(url);
		}
		else
		{
			print("outfit(" + bestMatch + ")", printColor);
			//cli_execute("try; /outfit " + bestMatch);
			outfit(bestMatch);
		}
	}
	// remove wrong accessories, in case the slots don't match up
	foreach sl, it in outfitDef
	{
		if (sl == acc1 || sl == acc2 || sl == acc3)
			continue;
		if (sl.equipped_item() != it && HaveEquipment(it) && it.can_equip())
		{
			sl.equip(it);
		}
	}
	slot[3] slots = { acc1, acc2, acc3 };
	boolean[3] matchedItems;
	boolean[3] matchedSlots;
	for (int i = 0; i < 3; i++)
	{
		if (outfitDef[slots[i]] == noItem)
		{
			matchedItems[i] = true;
			continue;
		}
		for (int j = 0; j < 3; j++)
		{
			if (matchedItems[i])
				continue;
			if (matchedSlots[j])
				continue;
			if (outfitDef[slots[i]] == slots[j].equipped_item())
			{
				matchedItems[i] = true;
				matchedSlots[j] = true;
			}
		}
	}
	for (int i = 0; i < 3; i++)
	{
		for (int j = 0; j < 3; j++)
		{
			if (matchedItems[i])
				continue;
			if (matchedSlots[j])
				continue;
			item it = outfitDef[slots[i]];
			if (it.can_equip() && HaveEquipment(it))
				slots[j].equip(it);
			matchedItems[i] = true;
			matchedSlots[j] = true;
		}
	}
}
void WearOutfit(string outfitName)
{
	item[slot] o;
	o = InitOutfit(outfitName, o);
	WearOutfit(o);
}
boolean IsAccordion(item it)
{
	return it.item_type() == "accordion";
}

// more specific helper functions

boolean IsMeatyMonster(monster mon)
{
	return mon == embezzler;
		//|| mon == mimeExecutive;
}
boolean IsMeatyMonster(string mon)
{
	return IsMeatyMonster(mon.to_monster());
}

boolean MeatyFaxable()
{
	if (IsMeatyMonster(get_property("photocopyMonster")))
		return true;
	if (saveFax)
		return false;
	if (vipKey.item_amount() == 0 || !(get_clan_lounge() contains faxMachine))
		return false;
	if (get_property("_photocopyUsed") != "false")
		return false;
	if (!can_faxbot(meatyMonster))
		return false;
	return true;
}
boolean MeatyPrintScreened()
{
	string capped = get_property("screencappedMonster");
	return IsMeatyMonster(capped)
		&& get_property("_printscreensUsedToday").to_int() < maxUsePrintScreens; // need guard to prevent infinite print screening
}
boolean MeatyCameraed()
{
	string capped = get_property("cameraMonster");
	return IsMeatyMonster(capped)
		&& !get_property("_cameraUsed").to_boolean();
}
boolean MeatyRainDohed()
{
	string capped = get_property("rainDohMonster");
	return IsMeatyMonster(capped);
}
boolean MeatyPuttied()
{
	string capped = get_property("spookyPuttyMonster");
	return IsMeatyMonster(capped);
}
boolean MeatyEnamoranged()
{
	string capped = get_property("enamorangMonster");
	return IsMeatyMonster(capped);
}
boolean MeatyDigitized()
{
	string capped = get_property("digitized");
	return IsMeatyMonster(capped);
}
boolean MeatyChateaud()
{
	string capped = get_property("chateauMonster");
	return IsMeatyMonster(capped)
		&& get_property("_chateauMonsterFought") == "false";
}
boolean BuyItemIfNeeded(item itm, int count, int maxPrice)
{
	TryGetFromCloset(itm, count);
	int buyCount = count - itm.item_amount();
	if (buyCount <= 0)
		return true;
	if (maxPrice < 0)
		return false;
	int mallPrice = itm.mall_price();
	if (mallPrice <= maxPrice)
	{
		buy(buyCount, itm, maxPrice);
	}
	return itm.item_amount() >= count;
}

boolean InCombat(string page)
{
	return page.contains_text("You're fighting");
}
void ResetCombatState()
{
	ravedNirvana = false;
	ravedSteal = false;
	ravedConcentration = false;
	timeSpinnered = false;
	mortared = false;
	duplicated = false;
	cursed = false;
	micrometeorited = false;
	extracted = false;
	bashed = false;
	bubbled = false;
	noodled = false;
	critted = false;
	shielded = false;
	canPocketCrumb = pantsGiving.have_equipped();
	staggerOption = 0;
	abstractioned = false;
	usedForce = false;
	lecturedRelativity = false;
	canAccordionBash = accordionBash.have_skill()
		&& IsAccordion(weapon.equipped_item())
		&& bakeBackpack.have_equipped();

	canSingAlong = singAlong.have_skill();
}
void DisableFreeKills()
{
	// combat will be free anyway, so don't waste them on this combat
	canJokesterGun = false;
	canBatoomerang = false;
	canXray = false;
	canMissileLauncher = false;
	canUseForce = false;
	canShatteringPunch = false;
	canMobHit = false;
	hasFreeKillRemaining = false;
}

boolean TryChoose(string text)
{
	string withQuotes = "&quot;" + text + "&quot;";
	foreach key, value in available_choice_options()
	{
		if (value == text || value == withQuotes)
		{
			print("Running choice " + key + " => " + value + " for adventure " + last_choice(), printColor);
			visit_url("choice.php?option=" + key + "&pwd=" + my_hash() + "&whichchoice=" + last_choice());
			return true;
		}
	}
	return false;
}

boolean CheckPostCombat(string pageResult, string combatFilter)
{
	//int[item] itemsGained = extract_items(result);
	//if (my_bjorned_familiar() == orphan || my_enthroned_familiar() == orphan)
	//{
	//	int wadCount = itemsGained[$item[hoarded candy wad]];
	//	//if (wadCount > 0)
	//}
	if (attunement.have_effect() > 0 && pageResult.contains_text("fight.php")) // Eldritch attunement means an extra combat
	{
		DisableFreeKills();
		ResetCombatState();
		visit_url("fight.php");
		run_combat(combatFilter);
		return true;
	}
	if (pageResult.contains_text("The phone in your doctor's bag rings"))
	{
		string page = visit_url("choice.php");
		run_choice(1); // Accept the case
		return true;
	}
	if (pageResult.contains_text("You investigate the now-still nightstand..."))
	{
		string page = visit_url("choice.php");
		if (TryChoose("Check the top drawer")
			|| TryChoose("Open the top drawer")
			|| TryChoose("Look in the top drawer")
			|| TryChoose("Break a leg (off of the nightstand"))
		{
			// haunted bedroom nightstands post-combat
			return true;
		}
	}

	return false;
}
// want to return true if we actually succeeded, and false if something prevented combat from running
boolean RunCombat(string filter)
{
	string result = run_combat(filter);
	boolean hasPostCombat = CheckPostCombat(result, filter);
	return hasPostCombat || result.contains_text("scripts/fight.js");
}

void HandleLightsOut(string page)
{
	if (page.contains_text("Light Out in the Storage Room"))
	{
		if (TryChoose("Look out the Window"))
			return;
	}
	else if (page.contains_text("Light Out in the Laundry Room"))
	{
		if (TryChoose("Check a Pile of Stained Sheets"))
			return;
	}
	else if (page.contains_text("Light Out in the Bathroom"))
	{
		if (TryChoose("Inspect the Bathtub"))
			return;
	}
	else if (page.contains_text("Light Out in the Kitchen"))
	{
		if (TryChoose("Make a Snack"))
			return;
	}
	else if (page.contains_text("Light Out in the Library"))
	{
		if (TryChoose("Go to the Childrens' Section"))
			return;
	}
	else if (page.contains_text("Light Out in the Ballroom"))
	{
		if (TryChoose("Dance with Yourself"))
			return;
	}
	else if (page.contains_text("Light Out in the Gallery"))
	{
		// save Elizabeth fight for when user is in control
	}
	else if (page.contains_text("Light Out in the Bedroom"))
	{
		if (TryChoose("Search for a light")
			&& TryChoose("Search a nearby nightstand")
			&& TryChoose("Check a nightstand on your left"))
			return;
	}
	else if (page.contains_text("Light Out in the Nursery"))
	{
		if (TryChoose("Search for a lamp")
			&& TryChoose("Search over by the (gaaah) stuffed animals")
			&& TryChoose("Examine the dresser")
			&& TryChoose("Open the bear and put your hand inside")
			&& TryChoose("Unlock the box"))
			return;
	}
	else if (page.contains_text("Light Out in the Conservatory"))
	{
		if (TryChoose("Make a torch")
			&& TryChoose("Examine the graves")
			&& TryChoose("Examine the grave marked \"Crumbles\""))
			return;
	}
	else if (page.contains_text("Light Out in the Billiards Room"))
	{
		if (TryChoose("Search for a light")
			&& TryChoose("What the heck, let's explore a bit")
			&& TryChoose("Examine the taxidermy heads"))
			return;
	}
	else if (page.contains_text("Light Out in the Wine Cellar"))
	{
		if (TryChoose("Try to find a light")
			&& TryChoose("Keep your cool")
			&& TryChoose("Investigate the wine racks")
			&& TryChoose("Examine the Pinot Noir rack"))
			return;
	}
	else if (page.contains_text("Light Out in the Boiler Room"))
	{
		if (TryChoose("Look for a light")
			&& TryChoose("Search the barrel")
			&& TryChoose("No, but I will anyway"))
			return;
	}
	else if (page.contains_text("Light Out in the Laboratory"))
	{
		// save Stephen fight for when user is in control
	}
	if (TryChoose("Get the heck out of here")) // lights out
		return;
	if (TryChoose("Get out of here right now go go go")) // lights out in the wine cellar
		return;
	if (TryChoose("Quit the Gallery")) // lights out in the gallery
		return;
	if (TryChoose("Get the heck out of here")) // Lights out in the Haunted Billiards Room
		return;
	if (TryChoose("Get out of the Ballroom")) // Lights out in the Ballroom
		return;
	if (TryChoose("Leave well enough alone")) // Lights out in the Laboratory
		return;
	if (TryChoose("Flee")) // Lights out in the Bedroom
		return;
	if (TryChoose("Fumble Your Way to the Door")) // Lights out in the Bathroom
		return;
	abort("Unhandled lights out quest");
}

boolean TryHandleNonCombat(string page)
{
	if (!page.contains_text("choice.php"))
		return false;
	// Machine elf item duplication:
	if (page.contains_text("A little") && page.contains_text(", familiar, beckoning"))
	{
		if (elfDuplicateItem != noItem && elfDuplicateItem.item_amount() > 0)
		{
			print("Duplicating item " + elfDuplicateItem);
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1119&option=4");
			page = visit_url("choice.php?whichchoice=1125&pwd=" + my_hash() + "&option=1&iid=" + elfDuplicateItem.to_int());
			if (!page.contains_text("Where it was, is another."))
			{
				print(page);
				abort("Duplicate item failed");
			}
		}
		else if (UserConfirmDefault("Chance to duplicate a consumable, do you want to abort so you can choose (otherwise it will skip this adventure)?", true))
			abort("Aborting so you can choose whether to duplicate an item");
	}
	foreach key,value in available_choice_options()
	{
		switch (value)
		{
			// Turtle tamer:
			case "Tame it":
			case "Tame It":
			case "Tame it!":
			case "Artfully tame it":
			case "Try to tame it":
			case "T... T... Tame it?":
			case "Recue him":
			case "Grab Him":
			case "Grab Him!":
			case "Grab him!":
			case "Grab it":
			case "Get her out":
			case "Help her out":
			case "Hop on!":
			case "Tackle It":
			case "Dive in after him":
			case "Can it?":
			case "Can you save its life?":
			case "Tame the tortoise":
			case "Tame the Turtle":
			case "Tame the turtle":
			case "Tame the wild spirit":
			case "Tame the two turtles!":
			case "Duel the turtle":
			case "Rescue the turtle":
			case "Rescue it!":
			case "Train the train":
			case "Investigate":
			case "Walk the line":
			case "And your changes for looting are fertile.":
			case "Fortune favors the bold -- tame it":
				run_choice(key); // tame the turtle
				return true;

			// Ghost dog:
			case "Throw a stick": // ghost dog chow
			case "Throw it down the road": // tennis ball
			case "Give me the booze!": // gimme booze
				run_choice(key);
				return true;

			// Machine elf after item duplication:
			case "A path away. All ways. Always.":
				run_choice(key); // skip the adventure
				return true;
		}
	}
	if (page.contains_text("Lights Out in the"))
	{
		HandleLightsOut(page);
		return true;
	}
	if (page.contains_text("Is There A Doctor In The House?"))
	{
		run_choice(1); // Accept the case
		return true;
	}
	if (page.contains_text("A Pound of Cure"))
	{
		run_choice(1); // Cure patient
		set_property("doctorBagQuestLocation", "");
		return true;
	}

	return false;
}
boolean ChooseSkipNoncombat(string page)
{
	if (!page.contains_text("choice.php"))
		return false;
	if (TryHandleNonCombat(page))
		return true;
	if (page.contains_text("A Pound of Cure"))
	{
		run_choice(1); // Cure patient
		return true;
	}

	if (TryChoose("Hustle away")) // Welcome to Our ool Table
		return true;
	if (page.contains_text("Louvre It or Leave It") && TryChoose("Pass on by")) // Haunted Gallery
		return true;
	if (page.contains_text("Out in the Garden") && TryChoose("None of the above")) // Haunted Gallery
		return true;
	if (TryChoose("Walk away")) // Aww, Craps
		return true;
	if (TryChoose("Punch the hobo")) // Dumpster Diving
		return false;
	if (TryChoose("Introduce them to avant-garde")) // The Entertainer
		return true;
	if (TryChoose("Sorry, no time.")) // Please, Hammer
		return true;
	if (TryChoose("Umm, no thanks. Seriously.")) // Under the Knife
		return true;
	if (TryChoose("Exit through the gift shop")) // Action Elevator, Hidden Apartment Building
		return true;
	if (TryChoose("Take the day off")) // Working Holiday, Hidden Office Building
		return true;
	if (TryChoose("Dammit, door, I'm an Adventurer, not a doctor!")) // You, M.D., Hidden Hospital
		return true;
	if (TryChoose("Let's don't")) // Life is Like a Cherry of Bowls, Hidden Bowling Alley
		return true;
	if (TryChoose("Sorry, gotta run.")) // Outskirts of Cobb's Knob
		return true;
	if (TryChoose("Leave the scene")) // Welcome to the Footlocker, Cobb's Knob Barracks
		return true;
	if (TryChoose("Kick the chef")) // Knob Goblin BBQ, Outskirts of Cobb's Knob
		return false; // converted to combat
	if (TryChoose("Plot a cunning escape")) // Malice in Chains, Outskirts of Cobb's Knob
		return false; // converted to combat
	if (TryChoose("Explore the stream")) // Arboreal Respite, Spooky Forest
		if (TryChoose("Go further upstream")) // Consciouness of a Stream
			if (TryChoose("Inter the vampire")) // An Interesting Choice
				return false; // convert to combat

	// Castle Ground Floor choices:
	if (TryChoose("Go out the Way You Came In")) // There's No Ability Like Possibility
		return true;
	if (TryChoose("Get out of this Junk")) // Putting Off is Off-Putting
		return true;
	if (TryChoose("Seek the Egress Anon")) // Huzzah!
		return true;
	if (TryChoose("Leave through a vent")) // Home on the Free Range
		return true;


	// if non-combat choice adventure, try to skip turn by Copper Feel => Investigate the Whirligigs and Gimcrackery
	TryChoose("Check Behind the Giant Poster"); // goto punk rock
	
	if (!TryChoose("Check behind the trash can")) // goto punk rock
		if (TryChoose("Get the Punk's Attention")) // goto punk rock
			return false; // converted to combat
	
	if (!TryChoose("Gimme Steam")) // goto steampunk
		if (TryChoose("End His Suffering")) // fight goth
			return false; // converted to combat

	if (TryChoose("Investigate the Whirligigs and Gimcrackery"))
		return true;

	TryChoose("Crawl Through the Heating Duct"); // neckbeard choice
	TryChoose("Crawl through the Heating Vent"); // fitness choice
	if (TryChoose("Check out the Mirror")) // skip the adventure
		return true;

	if (TryChoose("Investigate the crew quarters")) // Random Lack of an Encounter
		return false; // converted to combat
	if (TryChoose("Pay no attention to the stuff in front of the curtain")) // Curtains
		return true;
	if (TryChoose("Play 'Le Mie Cose Favorite'")) // Strung-Up Quartet
		return true;

	foreach key, value in available_choice_options()
		print(key + " = " + value, "red");
	abort("Unhandled non-combat encountered, please fix this script");
	return false;
}

void RunAdventure(location loc, string filter)
{
	string page = visit_url(loc.to_url().to_string());
	if (TryHandleNonCombat(page))
		return;
	string combatResult = run_combat(filter);
	CheckPostCombat(combatResult, filter);
}
boolean ActivateCopyItem(item copyItem, string filter)
{
	print("Trying to activate copy " + copyItem.to_string(), printColor);
	visit_url("inv_use.php?whichitem=" + copyItem.to_int());
	RunCombat(filter);
	return true;
}
boolean ActivateCopyItem(item copyItem)
{
	return ActivateCopyItem(copyItem, "Filter_Standard");
}

boolean CanDistention()
{
	return distention.item_amount() > 0 && !get_property("_distentionPillUsed").to_boolean();
}
void ChooseSummonType()
{
	if (summonTaffy.have_skill() && get_property("_taffyYellowSummons").to_int() == 0)
	{
		summonCurrent = summonTaffy;
	}
	else if (summonBricko.have_skill() && get_property("_brickoEyeSummons").to_int() < 3)
	{
		summonCurrent = summonBRICKO;
	}
	else if (summonRes.have_skill())
	{
		summonCurrent = summonRes;
	}
	else if (summonDice.have_skill())
	{
		summonCurrent = summonDice;
	}
	else if (summonCandy.have_skill())
	{
		summonCurrent = summonCandy;
	}
	else if (summonParty.have_skill())
	{
		summonCurrent = summonParty;
	}
}
void BurnManaSummoning(int keepMana)
{
	if (!summonCurrent.have_skill())
		return;
	while (true)
	{
		int availableMana = my_mp() - keepMana;
		int castCount = 0;
		int baseManaCost = summonCurrent.mp_cost();
		//if (keepMana == 0)
		//{
		//	// if not saving any mana back, we don't have to take into account the growing costs, the
		//	// server will do that for us
		//	castCount = availableMana / baseManaCost;
		//}
		//else
		{
			// Just make a very rough estimate because we don't know how many casts already made, mana adjustment
			// makes the calculation more complex.  Don't want to overshoot on mana usage, but reducing the number
			// of casts required from dozens to 3 or 4
			int totalManaCost = baseManaCost;
			while (totalManaCost < availableMana)
			{
				castCount++;
				if (baseManaCost < 10)
				{
					baseManaCost *= 2;
				}
				else if (baseManaCost < 100)
				{
					baseManaCost += baseManaCost / 2;
				}
				else if (baseManaCost < 1000)
				{
					baseManaCost += baseManaCost / 5;
				}
				else
				{
					baseManaCost += baseManaCost / 20;
				}
				totalManaCost += baseManaCost;
			}
		}
		if (castCount == 0)
			break;
		print( "casting " + summonCurrent + " " + castCount + " times", printColor );
		use_skill(castCount, summonCurrent);
		ChooseSummonType();
	}
}
void BurnManaSummoning()
{
	BurnManaSummoning(20);
}
void SoulSauceToMana()
{
	if (!soulFood.have_skill())
		return;
	while ((my_soulsauce() > 90 && my_mp() + 15 < my_maxmp())
		|| (my_mp() < 30 && my_maxmp() > 30 && my_soulsauce() > 5))
	{
		use_skill(1, soulFood);
	}
}
boolean ShouldSummonRestore(int keep, int soulsauceManaAvailable, int minRestore, int maxRestore)
{
	if (maxRestore + my_mp() > my_maxmp())
		return false;
	if (minRestore + soulsauceManaAvailable + my_mp() < summonCurrent.mp_cost() + keep)
		return false;
	return true;
}
boolean FreeDailyManaRestore()
{
	int restoreLimit = my_maxmp() - my_mp();
	if (restoreLimit > 300 && get_property("oscusSodaUsed") == "false" && oscusSoda.item_amount() > 0)
	{
		use(1, oscusSoda);
		return true;
	}
	if (restoreLimit >= 55 && get_property("_eternalCarBatteryUsed") == "false" && eternalBattery.item_amount() > 0)
	{
		use(1, eternalBattery);
		return true;
	}
	if (restoreLimit >= 1000 && get_property("sidequestNunsCompleted") == "fratboy" && get_property("nunsVisits").to_int() < 3)
	{
		cli_execute("nuns");
		return true;
	}
	if (restoreLimit >= 1000 && get_property("_aprilShower") != "true" && vipKey.item_amount() > 0 && get_clan_lounge() contains aprilShower)
	{
		cli_execute("shower hot");
		return true;
	}
	if (soulFood.have_skill() && restoreLimit >= 15 && my_soulsauce() >= 5)
	{
		int wantCastCount = restoreLimit / 15;
		int maxCastCount = my_soulsauce() / 5;
		if (wantCastCount > maxCastCount)
			wantCastCount = maxCastCount;
		use_skill(wantCastCount, soulFood);
		return true;
	}
	if (get_property("timesRested").to_int() < total_free_rests())
	{
		int restAmount = 80;
		if (HaveEquipment(pantsGiving)) // increases rest
		{
			pants.equip(pantsGiving);
			restAmount = 250;
		}
		if (restAmount < restoreLimit)
		{
			if (get_campground() contains pilgrimHat // pilgrim hat gives random buffs, which may be useful
			   || (get_campground() contains snowFort && snowFortified.have_effect() == 0) // snow fort gives +meat buff and +item buff on first use
			   || pants.equipped_item() == pantsGiving) // get more mana from campground than chateau when pantsgiving is equipped
			{
				visit_url("campground.php?action=rest");
			}
			else
				cli_execute("rest 1"); // use the default resting, which may be chateau
			return true;
		}
	}
	return false;
}
void BurnManaAndRestores(int keepMana, boolean burnDailyRestores)
{
	if (!summonCurrent.have_skill())
		return;
	BurnManaSummoning(keepMana);
	boolean changed = true;
	while (changed)
	{
		changed = false;

		int soulsauceBonus = my_soulsauce() / 5;
		soulsauceBonus *= 3;
		int cost = summonCurrent.mp_cost() + keepMana;
		if (ShouldSummonRestore(keepMana, soulsauceBonus, 200, 300) && get_property("oscusSodaUsed") == "false" && oscusSoda.item_amount() > 0)
		{
			use(1, oscusSoda);
		}
		else if (ShouldSummonRestore(keepMana, soulsauceBonus, 45, 55) && get_property("_eternalCarBatteryUsed") == "false" && eternalBattery.item_amount() > 0)
		{
			use(1, eternalBattery);
		}
		else if (ShouldSummonRestore(keepMana, soulsauceBonus, 1000, 1000) && get_property("sidequestNunsCompleted") == "fratboy" && get_property("nunsVisits").to_int() < 3)
		{
			cli_execute("nuns");
		}
		else if (soulFood.have_skill() && my_soulsauce() >= 5
			&& ShouldSummonRestore(keepMana, 0, 15, soulsauceBonus))
		{
			use_skill(1, soulFood);
			changed = true;
		}
		BurnManaSummoning(keepMana);
	}
}
void HealUp(boolean HPOnly)
{
	if (beatenUp.have_effect() > 0)
	{
		if (abortOnBeatenUp)
			abort("Cannot continue because beaten up");
		int freeRests = total_free_rests() - get_property("timesRested").to_int();
		if (freeRests > 0)
		{
			if (get_campground() contains snowFort && snowFortified.have_effect() == 0)
			{
				if (HaveEquipment(pantsGiving)) // increases rest mana
					pants.equip(pantsGiving);
				visit_url("campground.php?action=rest");
			}
		}
		if (walrus.have_skill() && my_mp() > 8)
		{
			use_skill(1, walrus);
		}
	}
	if (my_hp() > 10000)
		return;
	if (my_maxhp() - my_hp() > 10000 && vipKey.item_amount() > 0 && get_property("_hotTubSoaks").to_int() < 5)
	{
		cli_execute("hottub");
		return;
	}
	if (my_hp() / (my_maxhp() + 0.5) < .75 && my_maxhp() > 200)
	{
		if (cocoon.have_skill() && my_mp() > 20)
		{
			use_skill(1, cocoon);
		}
	}
	if (my_hp() / (my_maxhp() + 0.5) < .75)
	{
		restore_hp(my_maxhp() - my_hp());
	}
	if (my_mp() < 20)
	{
		restore_mp(20);
	}
}
void HealUp()
{
	HealUp(false);
}



int SumWeightModifiers(item[slot] o)
{
	int result = 0;
	int weight = 0;
	foreach s,i in o
	{
		weight = numeric_modifier(i, "Familiar Weight");
		if (weight == 0 && (i == $item[Buddy Bjorn] || i == $item[Crown of Thrones]))
		{
			weight = 5;
		}
	//		if (isDebug)
	//			print("Item " + i + " in slot " + s + " gives weight = " + weight + ", total = " + result);
		result += weight;
	}
	foreach s in $skills[]
	{
		if (s.have_skill())
		{
			weight = numeric_modifier(s, "Familiar Weight");
			if (weight > 0)
			{
	//				if (isDebug)
	//					print("Skill " + s + " gives weight = " + weight + ", total = " + result);
				result += weight;
			}
		}
	}
	foreach e in $effects[]
	{
		if (e.have_effect() > 0)
		{
			weight = numeric_modifier(e, "Familiar Weight");
			if (weight > 0)
			{
	//				if (isDebug)
	//					print("Effect " + e + " gives weight = " + weight + ", total = " + result);
				result += weight;
			}
		}
	}
	return result;
}

int CalculateFamiliarWeight(familiar f, item[slot] o)
{
	int result = 0;
	int weight = 0;
	
	item[slot] newOutfit = GetCurrentGear();
	if (is_familiar_equipment_locked())
		newOutfit[famEqp] = my_familiar().familiar_equipped_equipment();
	else
		newOutfit[famEqp] = f.familiar_equipped_equipment();
	foreach s,i in o
	{
		if (i.can_equip())
			newOutfit[s] = i;
	}
	result += SumWeightModifiers(newOutfit);
	weight = f.familiar_weight();
	if (isDebug)
		print("familiar " + f + " base weight = " + weight + ", total = " + result);
	result += weight;
	return result;
}

boolean FamiliarOnFeastedList(familiar f)
{
	string wasFeasted = get_property("_feastedFamiliars");
	string expiredFeasted = get_property("_feastedFamiliarsExpired");
	return wasFeasted.contains_text(f.to_string())
		&& !expiredFeasted.contains_text(f.to_string());
}
boolean FeastingAvailable(familiar f)
{
	return f.have_familiar()
		&& $item[Moveable Feast].item_amount() > 0
		&& get_property("_feastUsed").to_int() < 5
		&& !get_property("_feastedFamiliars").contains_text(f.to_string());
}

boolean FamiliarCurrentlyFeasted()
{
	if (FamiliarOnFeastedList(my_familiar()))
	{
		item[slot] curOutfit = GetCurrentGear();
		curOutfit[famEqp] = my_familiar().familiar_equipped_equipment();
		int curWeightModifiers = SumWeightModifiers(curOutfit);
		if (modifier_eval("W") >= 10 + curWeightModifiers + my_familiar().familiar_weight())
			return true;
		string expired = get_property("_feastedFamiliarsExpired");
		if (expired.length() > 0)
			expired += ";";
		set_property("_feastedFamiliarsExpired", expired + my_familiar().to_string());
	}
	return false;
}
int[familiar] feastChecked; // track which familiars we checked based on experience, I think it should generally only wear off if familiar earns experience (might not be 100% accurate)
boolean CalculateFeasted(familiar f)
{
	if (!FamiliarOnFeastedList(f))
		return false;
	if (feastChecked[f] == f.experience) // verified on the feasted list with current experience, must be feasted
		return true;
	if (f != my_familiar())
	{
		if (!f.have_familiar())
			return false;
		if (my_familiar() != f)
			f.use_familiar();
	}
	if (f == my_familiar())
	{
		feastChecked[f] = f.experience;
		return FamiliarCurrentlyFeasted();
	}
	return false;
}
// this is an estimated value based on equipping a familiar and items in slots, but (probably) less trustworthy than calling the below version with everything already equipped
int GetFamiliarRunaways(familiar f, item[slot] o)
{
	if (!f.have_familiar())
		return 0;
	int weight = CalculateFamiliarWeight(f, o);
	int runaways = weight / 5;
	runaways -= get_property("_banderRunaways").to_int();
	if (runaways == -1 || runaways == 0) // only time feasted matters is when we get down to 0, and this could trigger changing familiars, which we want to minimize
	{
		// weight_adjustment doesn't account for movable feast, but modifier_eval("W") does
		// http://kolmafia.us/showthread.php?20249-Getting-Familiar-Weight
		if (CalculateFeasted(f))
			runaways += 2;
	}
	return runaways;
}
// This should get the number of runaways available based on current familiar and equipment, and it should be accurate
int GetFamiliarRunaways()
{
	if (my_familiar() != stompingBoots && my_familiar() != bandersnatch)
		return 0;
	int familiarWeight = modifier_eval("W");

	int result = familiarWeight / 5;
	result -= get_property("_banderRunaways").to_int();
	return result;
}
int GetNonFamiliarRunaways()
{
	return smokebomb.item_amount() + fishermansack.item_amount() * 3;
}
int GetFreeRunaways(familiar f, item[slot] o)
{
	return GetFamiliarRunaways(f, o) + GetNonFamiliarRunaways();
}
int GetFreeRunaways()
{
	return GetFamiliarRunaways() + GetNonFamiliarRunaways();
}
int BakeBread(int fuelRequired) // returns number of breads to reach that much fuel
{
	int totalBread = (fuelRequired + 4) / 5; // this number might be an overshoot
	int bakeBread = totalBread - breadFuel.item_amount();
	if (bakeBread > 0)
	{
		if (dough.item_amount() < bakeBread)
			buy(bakeBread - dough.item_amount(), dough);
		if (water.item_amount() < bakeBread)
			buy(bakeBread - water.item_amount(), water);
		craft("cook", bakeBread, dough, water);
	}
	return totalBread;
}
boolean FuelAsdon(int requestedFuel)
{
	if (!(get_campground() contains asdonMartin))
		return false;
	int hadFuel = get_fuel();
	while (hadFuel < requestedFuel)
	{
		// 150 fuel on average per pie means it's cheaper than bread up to 2837.5 meat per pie
		if (pieFuel.item_amount() > 0)
			cli_execute("asdonmartin fuel 1 " + pieFuel.to_string());
		else
		{
	// 4540 meat for average 240 fuel = 18.916666 meat per fuel (or less with a discount)
			int breadCount = BakeBread(requestedFuel - hadFuel);
			cli_execute("asdonmartin fuel " + breadCount + " " + breadFuel.to_string());
		}
		if (get_fuel() == hadFuel)
		{
			abort("Asdon Martin is out of gas, please refuel manually, or acquire pies or bake soda bread before resuming.");
		}
		hadFuel = get_fuel();
	}
	return true;
}
item[slot] CopyOutfit(item[slot] o)
{
	item[slot] eqSet;
	foreach key, value in o
		eqSet[key] = value;
	return eqSet;
}
item[slot] GetModifiableOutfit(boolean forDrops)
{
	item[slot] eqSet;
	if (covetous.have_effect() > 0)
	{
		foreach key, value in defaultOutfitPieces
			eqSet[key] = value;
	}
	else
	{
		foreach key, value in dropsOutfitPieces
			eqSet[key] = value;
	}
	return eqSet;
}

void RemoveConfusionEffects(item i, boolean firstCheck)
{
	if (i.have_equipped())
	{
		i.to_slot().equip(noItem);
		if (!firstCheck)
			abort("Wearing " + i + " confuses KoLMafia, and therefore, this script, please remove that from your standard outfit");
	}
}
void RemoveConfusionEffects(effect e)
{
	if (e.have_effect() > 0 && greendrops.item_amount() > 0)
		cli_execute("uneffect " + e);
}
void RemoveConfusionEffects(boolean firstCheck)
{
	RemoveConfusionEffects(homophones, firstCheck);
	RemoveConfusionEffects(prepositions, firstCheck);
	RemoveConfusionEffects(papier1, firstCheck);
	RemoveConfusionEffects(papier2, firstCheck);
	RemoveConfusionEffects(papier3, firstCheck);
	RemoveConfusionEffects(moonSpoon, firstCheck);
	RemoveConfusionEffects(disAbled);
	RemoveConfusionEffects(anapests);
	RemoveConfusionEffects(haikuMind);
}

boolean PrepareAsdonLauncher()
{
	if ((get_campground() contains asdonMartin)
		&& get_property("_missileLauncherUsed") == "false")
	{
		FuelAsdon(100);
		canMissileLauncher = get_fuel() >= 100;
		return canMissileLauncher;
	}
	return false;
}



void PrepareFilterState(boolean forCurrentEquipped)
{
	needsCleesh = false; // always reset this, don't want to cleesh on accident
	ResetCombatState();
	if (!canPickpocket)
	{
		canPickpocket = my_class() == $class[Disco Bandit] || my_class() == $class[Accordion Thief];
		if (my_class().to_string() == "Disco Bandit")
		{
			canRaveNirvana = get_property("raveCombo5") != "";
			canRaveConcentration = get_property("raveCombo3") != "";
			canRaveSteal = get_property("raveCombo4") != "" && get_property("_raveStealCount").to_int() < 30;
		}
	}
	canPocketCrumb = pantsGiving.have_equipped();


	needsMeteorShower = meteorShower.have_skill()
		&& runFamiliar != orphan
		&& get_property("_meteorShowerUses").to_int() < 5;

	needsCrit = mafiaPointerRing.have_equipped();

	if (!needsSpookyPutty)
	{
		needsSpookyPutty = spookyPutty.item_amount() > 0
			&& get_property("spookyPuttyCopiesMade").to_int() < 5;
	}
	needBagOTricks = false;
	string countersString = get_property("relayCounters");
	string[int] counters = countersString.split_string(":");
	fortuneCookieCounter = 0;
	digitizeCounter = 0;
	enamorangCounter = 0;
	voteCounter = 0;
	for (int i = 2; i < counters.count(); i += 3)
	{
		int turns = counters[i - 2].to_int();
		string type = counters[i - 1];
		if (type.index_of("Digitize Monster") >= 0)
		{
			digitizeCounter = turns;
		}
		else if (type.index_of("Enamorang Monster") >= 0)
		{
			enamorangCounter = turns;
		}
		else if (type.index_of("Vote Monster") >= 0)
		{
			voteCounter = turns;
		}
		else if (type.index_of("Fortune Cookie") >= 0)
		{
			if (fortuneCookieCounter == 0 || turns < fortuneCookieCounter)
				fortuneCookieCounter = turns;
		}
		else if (type.index_of("Spookyraven Lights Out") >= 0)
		{
			spookyravenCounter = turns;
		}
	}
	int digitizeCount = get_property("_sourceTerminalDigitizeUses").to_int();
	needsDigitize = digitizeCount == 0;
	if (digitizeCount < 3 && !needsDigitize)
	{
		int turnsUntilDigitized = digitizeCounter - my_turnCount(); // how many turns until the next digitized monster shows up?
		int turnsAfterNextDigitized = my_adventures();			  // how many adventures will I have left after it shows up?
		if (turnsUntilDigitized > 0)								// in case the counter is brain damaged
			turnsAfterNextDigitized -= turnsUntilDigitized;
		int monstersPerDigitize = 4; // 7, 27, 57, 97

		// todo: my brain is tired, these numbers might need revisiting.
		// But worst case scenario, it digitizes at 97 when it should have been at 147, or vice versa,
		// so nothing too horrible

		// If you need to digitize every 147 adventures, you need at
		// 97 turns left for the last digitize, and 147 more for the next
		// to middle digitize.  But also need to account for number of
		// turns before the next digitize encounter
		if ((digitizeCount == 1 && turnsAfterNextDigitized >= 245)
			|| (digitizeCount == 2 && turnsAfterNextDigitized >= 105))
		{
			monstersPerDigitize = 5; // 7, 27, 57, 97, 147
		}
		int copiesFought = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
		if (copiesFought >= monstersPerDigitize) // in case we somehow missed the intended fight, guarantee the next embezzler is digitized
			needsDigitize = true;
		else if (turnsUntilDigitized <= 0 && copiesFought == (monstersPerDigitize - 1)) // otherwise we're searching for the last in the sequence
		{
			needsDigitize = true;
			needBagOTricks = true;
		}
			
	}
	if (forCurrentEquipped)
		ChooseEducate(false, needsDigitize);

	needsEnamorang = enamorang.item_amount() > 0 && get_property("enamorangMonster") == "";
	if (camera.item_amount() == 0 && beerLens.item_amount() > 0 && forCurrentEquipped)
	{
		cli_execute("acquire nothing-in-the-box");
		craft("paste", 1, nothingInTheBox, beerLens);
	}
	needsCamera = usedCamera.item_amount() == 0 && camera.item_amount() > 0;
	needsPrintScreen = printScreen.item_amount() > 0 && get_property("screencappedMonster") == "" && get_property("_printscreensUsedToday").to_int() < maxUsePrintScreens;
	needsRainDoh = rainDoh.item_amount() > 0 && usedRainDoh.item_amount() == 0;
	needsSpookyPutty = spookyPutty.item_amount() > 0 && usedSpookyPutty.item_amount() == 0;

	canJokesterGun = false;
	if (get_property("_firedJokestersGun") == "false")
	{
		if (jokesterGun.have_equipped())
			canJokesterGun = true;
		else if (my_familiar() == hand && hand.familiar_equipped_equipment() == jokesterGun)
			canJokesterGun = true;
		else if (!forCurrentEquipped && jokesterGun.HaveEquipment())
			canJokesterGun = true;
	}
	

	canMissileLauncher = PrepareAsdonLauncher();

	canUseForce = get_property("_saberForceUses").to_int() < 5
		&& (cosplaySaber.have_equipped()
			|| (!forCurrentEquipped && cosplaySaber.HaveEquipment()));

	if (get_property("_chestXRayUsed").to_int() < 3
		&& (doctorBag.have_equipped()
			|| (!forCurrentEquipped && doctorBag.HaveEquipment())))
	{
		canXray = true;
	}
	if (replicaBatoomerang.item_amount() > 0
		&& get_property("_usedReplicaBatoomerang").to_int() < 3)
	{
		canBatoomerang = true;
	}
	if (shatteringPunch.have_skill()
		&& get_property("_shatteringPunchUsed").to_int() < 3)
	{
		canShatteringPunch = true;
	}
	if (gingerbreadMobHit.have_skill()
		&& !get_property("_gingerbreadMobHitUsed").to_boolean())
	{
		canMobHit = true;
	}
	needWolfForm = false;
	hasFreeKillRemaining =
		canJokesterGun
		|| canXray
		|| canBatoomerang
		|| canMissileLauncher
		|| canShatteringPunch
		|| canMobHit;

	if (forCurrentEquipped)
	{
		RemoveConfusionEffects(false);
		HealUp();
	}
}
void PrepareFilterState()
{
	PrepareFilterState(true);
}

location GetDoctorBagQuestLocation()
{
	location zone = get_property("doctorBagQuestLocation").to_location();
	if (zone != noLocation)
	{
		item questItem = get_property("doctorBagQuestItem").to_item();
		TryGetFromCloset(questItem, 3); // in case of pvp steal, we need to have multiple on hand to reduce changes of losing quest item while trying to complete quest
		if (questItem.item_amount() == 0)
			buy(1, questItem, 10000); // Not everything is buyable, how should we deal with this then?
		if (questItem.item_amount() > 0)
			return zone;
	}
	return noLocation;
}

boolean IsNoWanderZone(location loc)
{
	switch (loc)
	{   // list from here: https://kol.coldfront.net/thekolwiki/index.php/Wandering_monsters
		case $location[A Massive Ziggurat]:
		case $location[An Overgrown Shrine (Northeast)]:
		case $location[An Overgrown Shrine (Southeast)]:
		case $location[An Overgrown Shrine (Northwest)]:
		case $location[An Overgrown Shrine (Southwest)]:
		case $location[The Daily Dungeon]:
		case $location[The Dire Warren]:
		case $location[The Shore, Inc. Travel Agency]:
		case $location[Gingerbread Civic Center]:
		case $location[Gingerbread Industrial Zone]:
		case $location[Gingerbread Sewers]:
		case $location[Gingerbread Train Station]:
		case $location[Gingerbread Upscale Retail District]:
		case $location[The X-32-F Combat Training Snowman]:
		case $location[Through the Spacegate]:
			return true;
	}
	return false;
}

boolean AllNoncombatsSkippable(location loc)
{
	switch (loc)
	{
		case $location[The Castle in the Clouds in the Sky (Top Floor)]:
		case $location[The Castle in the Clouds in the Sky (Ground Floor)]:
		case $location[The Castle in the Clouds in the Sky (Basement)]:
		case $location[The Penultimate Fantasy Airship]:
		case $location[The Hole in the Sky]:
		case $location[The Sleazy Back Alley]:
		case $location[The Arid, Extra-Dry Desert]:
		case $location[The Unquiet Garves]:
		case $location[The VERY Unquiet Garves]:
		case $location[Pandamonium Slums]:
		case $location[The Dire Warren]:
		case $location[Noob Cave]:
		case $location[The Spooky Forest]:
		case $location[The Degrassi Knoll Restroom]:
		case $location[The Degrassi Knoll Bakery]:
		case $location[The Degrassi Knoll Gym]:
		case $location[The Degrassi Knoll Garage]:
		case $location[The Haunted Gallery]:
		case $location[The Haunted Wine Cellar]:
		case $location[The Haunted Laundry Room]:
		case $location[The Haunted Boiler Room]:
		case $location[The Haunted Kitchen]:
		case $location[The Haunted Conservatory]:
		case $location[The Haunted Billiards Room]:
		case $location[The Outskirts of Cobb's Knob]:
		case $location[Cobb's Knob Barracks]:
		case $location[Cobb's Knob Kitchens]:
		case $location[Cobb's Knob Harem]:
		case $location[Cobb's Knob Laboratory]:
		case $location[Cobb's Knob Menagerie, Level 1]:
		case $location[Cobb's Knob Menagerie, Level 2]:
		case $location[Cobb's Knob Menagerie, Level 3]:
		case $location[The Bat Hole Entrance]:
		case $location[The Beanbat Chamber]:
		case $location[Guano Junction]:
		case $location[The Batrat and Ratbat Burrow]:
		case $location[The Goatlet]:
		case $location[Lair of the Ninja Snowmen]:
		case $location[The Hidden Apartment Building]:
		case $location[The Hidden Office Building]:
		case $location[The Hidden Hospital]:
		case $location[The Hidden Bowling Alley]:
		case $location[The Red Zeppelin]:
		case $location[A Mob of Zeppelin Protesters]:
		case $location[The Upper Chamber]:
		case $location[The Middle Chamber]:
		case $location[The "Fun" House]:
		case $location[The Fungal Nethers]:
			return true;
	}
	return false;
}

location ChooseRunawayZone()
{
	location zone = GetDoctorBagQuestLocation();
	if (AllNoncombatsSkippable(zone))
		return zone;
	if (keyCardDelta.item_amount() == 0)
		return uncleGator;
	else if (keyCardBeta.item_amount() == 0)
		return garbagePirates;
	else if (keyCardGamma.item_amount() == 0)
		return toxicTeacups;
	return noLocation;
}
location ChooseWandererZone()
{
	location zone = GetDoctorBagQuestLocation();
	if (zone == noLocation || IsNoWanderZone(zone))
		zone = ChooseRunawayZone();
	if (zone == noLocation || IsNoWanderZone(zone))
		zone = barfMountain; // last resort
	return zone;
}

string ChooseFreeKillMethodForFilter()
{
	if (canJokesterGun)
	{
		canJokesterGun = false;
		return "skill " + fireJokester.to_string();
	}
	if (canMissileLauncher)
	{
		canMissileLauncher = false;
		return "skill " + missileLauncher.to_string();
	}
	if (canShatteringPunch)
	{
		canShatteringPunch = false;
		return "skill " + shatteringPunch;
	}
	if (canMobHit)
	{
		canMobHit = false;
		return "skill " + gingerbreadMobHit;
	}
	if (canBatoomerang)
	{
		canBatoomerang = false;
		return "item " + replicaBatoomerang;
	}
	if (canXray)
	{
		canXray = false;
		return "skill " + xray;
	}
	return "";
}

string Filter_Duplicate(int round, monster mon, string page)
{
	if (canDuplicate && (mon == $monster[Witchess Knight] || mon == $monster[Witchess Bishop]))
	{
		if (canMortar && !mortared)
		{
			mortared = true;
			return "skill " + mortarShell.to_string();
		}
		if (canDuplicate && !duplicated)
		{
			duplicated = true;
			return "skill " + duplicate.to_string();
		}
		if (cigar.item_amount() > 0)
		{
			return "item " + cigar.to_string();
		}
	}
	return "";
}
string Filter_ChooseCrit()
{
	if (!critted)
	{
		if (furiousWallop.have_skill() && my_fury() > 0)
		{
			critted = true;
			return "; skill " + furiousWallop.to_string();
		}
		if (haikuKatana.have_equipped())
		{
			critted = true;
			return "; skill " + haikuCrit.to_string();
		}
		if (patriotShield.have_equipped())
		{
			if (!shielded)
			{
				shielded = true;
				critted = true;
				return "; skill " + patriotCrit.to_string() + "; attack";
			}
			critted = true;
			return "attack";
		}
	}
	return "";
}

string Filter_Standard(int round, monster mon, string page)
{
	if (round == 0)
		print("using Filter_Standard", printColor);

	if (needsCleesh)
	{
		needsCleesh = false;
		return "skill Cleesh";
	}

	if (IsMeatyMonster(mon)) // capture meaty monster
	{
		if (canPickpocket && can_still_steal() && mon == mimeExecutive) // embezzler not worth pickpocketing
		{
			return "\"pickpocket\"";
		}
		if (needsRomanticArrow)
		{
			digitizeActivationNeeded = true;
			needsRomanticArrow = false;
			return "skill " + romanticArrow.to_string();
		}
		if (needsWinkAt)
		{
			digitizeActivationNeeded = true;
			needsWinkAt = false;
			return "skill " + winkAt.to_string();
		}
		if (needsDigitize)
		{
			digitizeActivationNeeded = true;
			needsDigitize = false;
			return "skill " + digitize.to_string();
		}
		if (needWolfForm && vampCloake.have_equipped())
		{
			needWolfForm = false;
			return "skill " + wolfForm.to_string();
		}
		if (needsMeteorShower
			&& my_familiar() != obtuseAngel && my_familiar() != reanimator) // if familiar was chosen for copying instead of meat, don't waste meteor
		{
			needsMeteorShower = false;
			return "skill " + meteorShower.to_string();
		}
		string s = "";
		int itemCount = 0;
		if (needsSpookyPutty)
		{
			s += spookyPutty.to_string();
			needsSpookyPutty = false;
			itemCount++;
		}
		if (needsPrintScreen && itemCount < maxItemUse)
		{
			if (itemCount == 1)
				s += ",";
			s += printScreen.to_string();
			needsPrintScreen = false;
			itemCount++;
		}
		if (needsCamera && itemCount < maxItemUse)
		{
			if (itemCount == 1)
				s += ",";
			s += camera.to_string();
			needsCamera = false;
			itemCount++;
		}
		if (needsRainDoh && itemCount < maxItemUse)
		{
			if (itemCount == 1)
				s += ",";
			s += rainDoh.to_string();
			needsRainDoh = false;
			itemCount++;
		}
		if (needsEnamorang && itemCount < maxItemUse)
		{
			enamorangsUsed = get_property("_enamorangsUsedToday").to_int();
			if (enamorangsUsed < maxUseEnamorangs)
			{
				set_property("_enamorangsUsedToday", (++enamorangsUsed).to_string());
				if (itemCount == 1)
					s += ",";
				s += enamorang.to_string();
				enamorangsUsed++;
				needsEnamorang = false;
				itemCount++;
			}
		}
		if (itemCount > 0)
		{
			if (itemCount == 1)
				s += ",none";
			return "item " + s;
		}
		if (needsCrit)
		{
			string crit = Filter_ChooseCrit();
			if (crit != "")
				return crit;
		}
	}
	if (combatUserScript)
		return "";

	string dup = Filter_Duplicate(round, mon, page);
	if (dup != "")
		return dup;

	if (canMissileLauncher && shouldMissileLauncher)
	{
		// if "shouldMissileLauncher" is true, takes precedence over jokester's gun
		canMissileLauncher = false;
		return "skill " + missileLauncher.to_string();
	}
	boolean fastkill = false;
	if (get_property("_VYKEACompanionType") != "")
	{
		if (mon.monster_hp() < 800)
			fastkill = true;
	}

	string result = "";
	if (canPickpocket && can_still_steal()) // don't bother pickpocketing the embezzler, priority is copying and free kills
	{
		result += "pickpocket";
	}
	if (mon == tourist && olfaction.have_skill() && olfactionEffect.have_effect() == 0 && my_mp() > 50)
	{
		result += "; skill " + olfaction.to_string();
	}
if (false) // TODO: free kills are now worthless for farming, don't waste them here
{
		string result = ChooseFreeKillMethodForFilter();
		if (result != "")
			return result;
}
	if (!fastkill && CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
	{
		cursed = true;
		result += "; skill " + curseOfWeaksauce.to_string();
	}
	if (!fastkill && expected_damage() * 8 > my_hp())
	{
		if (CanCast(micrometeorite) && !micrometeorited) // reduce damage taken
		{
			micrometeorited = true;
			return result + "; skill " + micrometeorite.to_string();
		}
	}
	if (canAccordionBash)
	{
		canAccordionBash = false;
		result += "; skill Accordion Bash";
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		result += "; skill Sing Along";
	}
	if (needsMayfly && mayfly.have_equipped())
	{
		needsMayfly = false;
		result += "; skill Summon Mayfly Swarm";
	}
	if (extractJelly.have_skill() && !extracted)
	{
		extracted = true;
		result += "; skill " + extractJelly.to_string();
	}
	boolean CanCombo = my_hp() > 100
		&& (expected_damage() * 4 < my_hp()); // a combo will take 3 turns to execute, so make sure we can survive 4

	// rave checks come after embezzler special handling, because we could accidentally kill embezzler too early
	if (!fastkill && canRaveNirvana && CanCombo) // increase meat drops
	{
		if (!ravedNirvana)
		{
			ravedNirvana = true;
			result += "; combo rave nirvana";
		}
	}
	if (mon == mimeExecutive // tough scaling monster, don't want to dink around while getting beat up
		|| round > 18) // maybe for a damage immune wandering monster?
	{
		if (result != "")
		{
print("Running filter = " + result, printColor);
			return result;
		}
		if (canMortar && !mortared)
		{
			mortared = true;
			return "skill " + mortarShell.to_string();
		}
		if (monster_hp() > 300)
		{
			if (CanCast(weaponPasta))
				return "skill " + weaponPasta;
			// else punt to secondary script
		}
		else
		{
			if (CanCast(sauceStorm))
				return "skill " + sauceStorm;
			else if (CanCast(weaponPasta))
				return "skill " + weaponPasta;
		}
	}
	if (canTurbo) // bonus meat drops are higher priority than mana regen, but other combos are lower
	{
		canTurbo = false;
		result += "; skill Turbo";
	}
	if (!fastkill && canRaveConcentration && CanCombo) // increase item drops
	{
		if (!ravedConcentration)
		{
			ravedConcentration = true;
			result += "; combo rave concentration";
		}
	}
	if (!fastkill && canExtract && my_mp() > 10)
	{
		canExtract = false;
		result += "; skill " + extract.to_string();
	}
	if (!fastkill && canPocketCrumb && pantsGiving.have_equipped())
	{
		canPocketCrumb = false;
		result += "; skill " + pocketCrumbs.to_string();
	}
	if (needsCrit)
	{
		string crit = Filter_ChooseCrit();
		if (crit != "")
			result += crit;
	}

	if (!fastkill && canRaveSteal && CanCombo) // sometimes steals an item, but don't do it in long running or difficult fights
	{
		if (!ravedSteal)
		{
			ravedSteal = true;
			result += "; combo rave steal";
		}
	}

print("Running filter = " + result, printColor);
	return result;
}

string Filter_Seal(int round, monster mon, string page)
{
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill Sing Along";
	}
	if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
	{
		cursed = true;
		return "skill " + curseOfWeaksauce.to_string();
	}
	return "skill " + thrustSmack.to_string();
}

void TryOpenRainDoh()
{
	static boolean rainDohChecked = false;
	if (!rainDohChecked)
	{
		rainDohChecked = true;
		if (rainDoh.item_amount() == 0
			&& usedRainDoh.item_amount() == 0
			&& unopenedRainDoh.item_amount() > 0)
		{
			if (UserConfirmDefault("Rain-doh hasn't been opened this ascension yet, do you wish to open it now for copying?", true))
			{
				use(1, unopenedRainDoh);
			}
		}
	}
}

int PuttyCopiesRemaining()
{
	TryOpenRainDoh();
	int puttyAvailable = 0;
	boolean hasPutty = spookyPutty.item_amount() > 0;
	boolean hasRaindoh = rainDoh.item_amount() > 0;
	if (hasPutty)
		puttyAvailable++;
	if (hasRaindoh)
		puttyAvailable++;
	if (puttyAvailable == 0)
		return 0;
	puttyAvailable += 4; // both have 5 individually, combined they get 6 total
	int puttiesUsed = get_property("spookyPuttyCopiesMade").to_int();
	int raindohsUsed = get_property("_raindohCopiesMade").to_int();
	return puttyAvailable - (puttiesUsed + raindohsUsed);
}


boolean CopiedMeatyAvailable()
{
	if (MeatyPrintScreened())
		return true;
	if (MeatyCameraed())
		return true;
	if (MeatyRainDohed())
		return true;
	if (MeatyPuttied())
		return true;
	if (MeatyChateaud())
		return true;
	if (MeatyFaxable())
		return true;
	if (pillKeeper.HaveEquipment() && get_property("_freePillKeeperUsed") == "false")
		return true;
	return false;
}
boolean KramcoScheduled()
{
	if (!kramco.HaveEquipment())
		return false;

	// TODO: from discussion in /hardcore:
	// Katarn: Ezandora: (y+1) / (5+x*3+max(0,x-5)^3) where y = turns since last goblin and x is the number of goblins encountered so far

	// this is based on the code in Ezandora's Guide (relay_Guid.ash), which has the comment:
	// "These ceilings are not correct; they are merely what I have spaded so far. The actual values are higher".
	// So if better values are spaded, this should also be updated to match
	int lastGoblin = get_property("_lastSausageMonsterTurn").to_int();
	int sausageFights = get_property("_sausageFights").to_int();
	int delay = 220;
	switch (sausageFights)
	{
		case 0: delay = 0; break;
		case 1: delay = 7; break;
		case 2: delay = 10; break;
		case 3: delay = 13; break;
		case 4: delay = 16; break;
		case 5: delay = 19; break;
		case 6: delay = 23; break;
		case 7: delay = 33; break;
		case 8: delay = 54; break;
		case 9: delay = 93; break;
		case 10: delay = 154; break;
		case 11: delay = 219; break;
	}
	return (total_turns_played() - lastGoblin >= delay);
}
string WandererScheduled()
{
	if (my_turncount() == digitizeCounter)
	{
		return get_property("_sourceTerminalDigitizeMonster");
	}
	if (my_turncount() == enamorangCounter)
	{
		return get_property("enamorangMonster");
	}
	return "";
}
boolean MeatyScheduled()
{
	string wanderer = WandererScheduled();
	return IsMeatyMonster(wanderer);
}

void DebugOutfit(string name, item[slot] o)
{
	if (!isDebug)
		return;
	print("outfit = " + name + ":", printColor);
	foreach sl,it in o
	{
		print("*   slot " + sl + " = " + it, printColor);
	}
}

item[slot] InitOutfit(string outfitName, item[slot] result)
{
	boolean acc1Used = false, acc2Used = false, acc3USed = false, mainHandUsed = false;
	foreach ix, it in outfit_pieces(outfitName)
	{
		slot s = it.to_slot();
		if (s == acc1 || s == acc2 || s == acc3)
		{
			if (!acc1Used)
			{
				acc1Used = true;
				result[acc1] = it;
			}
			else if (!acc2Used)
			{
				acc2Used = true;
				result[acc2] = it;
			}
			else if (!acc3Used)
			{
				acc3Used = true;
				result[acc3] = it;
			}
			else
				abort("Not enough slots for accessory " + it);
		}
		else if (s == weapon)
		{
			if (mainHandUsed)
				result[offhand] = it;
			else
				result[weapon] = it;
			mainHandUsed = true;
		}
		else
			result[s] = it;
	}
	return result;
}
item[slot] InitOutfit(string outfitName)
{
	item[slot] result;
	return InitOutfit(outfitName, result);
}

void InitOutfits()
{
	defaultOutfitPieces = InitOutfit(defaultOutfit);
	if (meatyOutfit != "")
		meatyOutfitPieces = InitOutfit(meatyOutfit);
	else
		meatyOutfitPieces = SwapOutSunglasses(defaultOutfitPieces);
	dropsOutfitPieces = InitOutfit(dropsOutfit);
	weightOutfitPieces = InitOutfit(weightOutfit);
	if (HaveEquipment(loathingLegionEqp))
	{
		weightOutfitPieces[famEqp] = loathingLegionEqp;
	}
	DebugOutfit(defaultOutfit, defaultOutfitPieces);
	DebugOutfit(meatyOutfit, meatyOutfitPieces);
	DebugOutfit(dropsOutfit, dropsOutfitPieces);
	DebugOutfit(weightOutfit, weightOutfitPieces);
}


boolean TryEquipFamiliarEquipment(item eqp, float eqpBonus)
{
	// snowsuit weight drops over time, once it gets too low, swap it out
	if (snowSuitWeight > eqpBonus)
	{
		if (famEqp.equipped_item() != snowSuit)
			famEqp.equip(snowSuit);
		return true;
	}
	if (!HaveEquipment(eqp))
		return false;
	if (famEqp.equipped_item() != eqp)
		famEqp.equip(eqp);
	return true;
}
void SwitchToFamiliar(familiar fam)
{
	if (my_familiar() == fam)
		return;
   
	fam.use_familiar();
}
record familiarPair
{
	familiar first;
	familiar second;
};
void EquipBjornCrownFamiliars(familiar first, familiar second)
{
	if (bjorn.have_equipped() && first.to_string() != noFamiliar)
	{
		if (my_bjorned_familiar() != first)
		{
			first.bjornify_familiar();
			first = second;
		}
	}
	if (crown.have_equipped() && first.to_string() != noFamiliar)
	{
		if (my_enthroned_familiar() != first)
			first.enthrone_familiar();
	}
}
familiarPair ChooseBjornCrownFamiliar(familiarPair currentChoice, familiar newOption)
{
	if (my_familiar() == newOption)
		return currentChoice;
	if (!newOption.have_familiar())
		return currentChoice;
	familiarPair result;
	result.first = newOption;
	result.second = currentChoice.first;
	return result;
}
familiarPair ChooseBjornCrownFamiliar(familiar[] choices)
{
	familiarPair best;
	foreach ix, fam in choices
	{
		best = ChooseBjornCrownFamiliar(best, fam);
	}
	return best;
}
void ChooseBjornCrownFamiliars(boolean forMeaty)
{
	if (!bjorn.have_equipped() && !crown.have_equipped())
		return;

	// work our way from the least valuable to most valuable choice:
	familiarPair choice;
	choice = ChooseBjornCrownFamiliar(choice, leprechaun);
	choice = ChooseBjornCrownFamiliar(choice, obtuseAngel);
	if (!forMeaty) // can't choose one that does damage
		choice = ChooseBjornCrownFamiliar(choice, hoboMonkey);
	choice = ChooseBjornCrownFamiliar(choice, goldenMonkey);
	choice = ChooseBjornCrownFamiliar(choice, happyMedium);
	choice = ChooseBjornCrownFamiliar(choice, organGrinder);

	// ~65 mpa for +25% meat in barf mountain, with 20% drop chance of
	// whosit, as long as whosits are over 325 meat each, this is a
	// better use of a bjorn/crown
	if (!forMeaty)
		choice = ChooseBjornCrownFamiliar(choice, warbearDrone);

	// Mafia can't detect bjorn/crown drops while in machine elf tunnels
	// which means counts don't get updated, which means these thresholds
	// won't get triggered, which means it will bjornify the wrong familiar
	// waiting for the remaining drops forever.  So don't use these familiars
	// inside the machine elf tunnels.
	if (my_familiar() != machineElf && !forMeaty)
	{
		if (get_property("_abstractionDropsCrown").to_int() < 15)
			choice = ChooseBjornCrownFamiliar(choice, machineElf);
		if (get_property("_hoardedCandyDropsCrown").to_int() < 3)
			choice = ChooseBjornCrownFamiliar(choice, orphan);
		if (get_property("_optimisticCandleDropsCrown").to_int() < 3)
			choice = ChooseBjornCrownFamiliar(choice, optimisticCandle);
		if (get_property("_garbageFireDropsCrown").to_int() < 3)
			choice = ChooseBjornCrownFamiliar(choice, garbageFire);
		if (get_property("_grimFairyTaleDropsCrown").to_int() < 2)
			choice = ChooseBjornCrownFamiliar(choice, grimBrother);
		if (get_property("_grimstoneMaskDropsCrown").to_int() < 1)
			choice = ChooseBjornCrownFamiliar(choice, grimstoneGolem);
	}
// todo: if robortender, maybe do weight buff instead

	EquipBjornCrownFamiliars(choice.first, choice.second);
}
void ActivateMumming()
{
	if (mumming.item_amount() > 0)
	{
		if (my_familiar() != runFamiliar)
			SwitchToFamiliar(runFamiliar);
		if (my_familiar() == noFamiliar)
			return;
		string page = visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9592");
		if (page.contains_text("type=submit value=\"The Captain\""))
		{
			run_choice(1); // The Captain, +meat
		}
		else
		{
			visit_url("main.php");
			//run_choice(8); // Never mind
		}
	}
}

void TryUseMovableFeast()
{
	if (my_familiar() == machineElf)
		return;
	if (FeastingAvailable(my_familiar()))
	{
		use(1, moveableFeast);
	}
}

item ChooseFamiliarEquipmentForWeight(familiar f)
{
	item fEq = f.familiar_equipment();
	if (!HaveEquipment(fEq))
		fEq = $item[none];
	float fEqWeight = fEq.numeric_modifier("Familiar Weight");
	if (HaveEquipment(snowSuit))
		snowSuitWeight = snowSuit.numeric_modifier("Familiar Weight");
	if (fEqWeight >= 10 && fEqWeight >= snowSuitWeight)
		return fEq;
	if (snowSuitWeight > 10)
		return snowSuit;
	if (pokeEqpMeat.HaveEquipment())
		return pokeEqpMeat;
	if (pokeEqpItem.HaveEquipment())
		return pokeEqpItem;
	if (pokeEqpHeal.HaveEquipment())
		return pokeEqpHeal;
	if (pokeEqpBlock.HaveEquipment())
		return pokeEqpBlock;
	if (pokeEqpRun.HaveEquipment())
		return pokeEqpRun;
	if (petSweater.HaveEquipment())
		return petSweater;
	if (pokeEqpDamage.HaveEquipment())
		return pokeEqpDamage;
	if (sugarShield.HaveEquipment())
		return sugarShield;
	if (fEqWeight >= 6 && fEqWeight >= snowSuitWeight)
		return fEq;
	if (snowSuitWeight > 6)
		return snowSuit;
	if (cufflinks.HaveEquipment())
		return cufflinks;
	return fEq;
}

void PrepareFamiliar(boolean forMeaty)
{
	if (my_familiar() != runFamiliar)
		SwitchToFamiliar(runFamiliar);
	ChooseBjornCrownFamiliars(forMeaty);
	if (my_familiar() == orphan)
	{
		// counts as an 80+ pound leprechaun, but just chose some arbitrary number larger
		// than the 20 pound max of snow suit
		TryEquipFamiliarEquipment(pirateCostume, 80);
		return;
	}
	if (forMeaty)
	{
		// should use this during the most valuable times, when we're fighting a 1000 or 1500 base
		// monster, since it only last 20 combats, not 20 adventures
		TryUseMovableFeast();
	}

	if (HaveEquipment(snowSuit))
		snowSuitWeight = snowSuit.numeric_modifier("Familiar Weight");

	if (get_property("_mayflowerDrops").to_int() < 5 && !forMeaty && TryEquipFamiliarEquipment(mayflower, 11))
	{
		// mayflower drops take precedence over weight bonus unless embezzler
		return;
	}
	if (TryEquipFamiliarEquipment(pokeEqpMeat, forMeaty ? 25 : 15))
		return;
	if (TryEquipFamiliarEquipment(pokeEqpItem, 11))
		return;
	if (TryEquipFamiliarEquipment(pokeEqpHeal, 10.1))
		return;
	if (TryEquipFamiliarEquipment(pokeEqpBlock, 10.1))
		return;
	if (TryEquipFamiliarEquipment(pokeEqpRun, 10.1))
		return;

	if (TryEquipFamiliarEquipment(petSweater, 10))
		return;
	if (TryEquipFamiliarEquipment(pokeEqpDamage, 9.9))
		return;
   
	if (forMeaty && TryEquipFamiliarEquipment(sugarShield, 10))
		return;
	if (TryEquipFamiliarEquipment(cufflinks, 6))
		return;
	if (get_property("_mayflowerDrops").to_int() < 5 && TryEquipFamiliarEquipment(mayflower, 5.1))
		return;
	// slight weight bonus for hookah because it gives buffs (but how does that
	// compare to the +10% item drop from snow suit even at 5 pounds?)
	if (TryEquipFamiliarEquipment(hookah, 5.2))
		return;
	// final fallback, if no other equipment is matching, this should give +5 weight
	TryEquipFamiliarEquipment(filthyLeash, 5);
}
item[slot] SwapOutSunglasses(item[slot] selectedOutfit)
{
	// replace cheap sunglasses because they only work in barf mountain
	slot matching;
	if (selectedOutfit[acc1] == sunglasses)
		matching = acc1;
	else if (selectedOutfit[acc2] == sunglasses)
		matching = acc2;
	else if (selectedOutfit[acc3] == sunglasses)
		matching = acc3;
	else
		return selectedOutfit;
	item best = noItem;
	float bestPercent = 0;
	foreach i in get_inventory()
	{
		if (i.have_equipped() || !i.can_equip())
			continue;
		float percent = i.numeric_modifier("Meat Percent");
		if (percent > bestPercent)
		{
			best = i;
			bestPercent = percent;
		}
	}
	if (bestPercent <= 0)
		return selectedOutfit;

	item[slot] result;
	foreach key, value in selectedOutfit
	{
		result[key] = value;
	}
	result[matching] = best;
	return result;
}
boolean TryScratchNSniff(item[slot] forOutfit)
{
	if (forOutfit[weapon] == haikuKatana
		&& (forOutfit[acc1] == mafiaPointerRing
		|| forOutfit[acc2] == mafiaPointerRing
		|| forOutfit[acc3] == mafiaPointerRing))
	{
		return false; // +200% for katana is better than +75% for scratch and sniff stickers
	}

	//float meatMultiplier = 1000 * 20 / 100; // 20 embezzlers * 1000 meat / 100 percent
	//float currentWeaponMeat = meatMultiplier * weapon.equipped_item().numeric_modifier("Meat Percent");
	//float scratchMeat = meatMultiplier * 75; // 75% from 3 stickers
	//float difference = scratchMeat - currentWeaponMeat;
	//if (difference < 300 || scratchUPC.mall_price() * 3 > difference)
	//	return false;

	item eq;
	if (HaveEquipment(scratchXbow))
		eq = scratchXbow;
	else
		eq = scratchSword;
	if ((sticker1.equipped_item() == noItem
		&& sticker2.equipped_item() == noItem
		&& sticker3.equipped_item() == noItem)
		|| (!HaveEquipment(scratchXbow) && !HaveEquipment(scratchSword)))
	{
		if (scratchUPC.item_amount() < 3)
		{
			print("Buying 3 scratch and sniff stickers", printColor);
			buy(3 - scratchUPC.item_amount(), scratchUPC);
		}
		if (scratchUPC.item_amount() >= 3)
			cli_execute("stickers upc, upc, upc");
		else
		{
			print("Couldn't acquire stickers, no scratch 'n' sniff for you", "red");
			return false;
		}
	}
	forOutfit[weapon] = eq;
	return true;
}
void BuffNonPMThrall()
{
	if (my_class().to_string() != "Pastamancer"
		&& my_mp() > 1000
		&& lasagnaThrallSkill.have_skill()
		&& lasagnaThrallEffect.have_effect() <= 0)
	{
		// only worthwhile if we'll have lots of mana leftover, really expensive for the payback, 100 meat per embezzler for 200 mana
		use_skill(1, lasagnaThrallSkill);
	}
}
void PrepareMeaty()
{
	item[slot] meatOutfit = CopyOutfit(meatyOutfitPieces);
	TryScratchNSniff(meatOutfit);
	if (vampCloake.HaveEquipment() && get_property("_vampyreCloakeFormUses").to_int() < 10)
	{
		meatOutfit[back] = vampCloake;
		needWolfForm = true;
	}
	WearOutfit(meatOutfit);

	if (obtuseAngel.have_familiar())
	{
		if (get_property("_badlyRomanticArrows") == "0") // can only use once per day
		{
			obtuseAngel.use_familiar();
			if (HaveEquipment(quakeOfArrows))
				famEqp.equip(quakeOfArrows);
			needsRomanticArrow = true;
		}
	}
	else if (reanimator.have_familiar())
	{
		//if (get_property("???") == "") // can only use once per day
		if (false) // not sure if this uses the same property _badlyRomanticArrows
		{
			reanimator.use_familiar();
			if (HaveEquipment(embalmingFlask))
				famEqp.equip(embalmingFlask);
			needsWinkAt = true;
		}
	}
	ChooseThrall(true);
	BuffNonPMThrall();
	RemoveConfusionEffects(false);
}

boolean IsLeprechaunType(familiar f)
{
	return f == leprechaun; // todo: add others
}

int EstimateMeatBonusPercent(item eq)
{
	if (eq == sunglasses)
		return 60;
	if (eq == mafiaPointerRing)
		return 180;
	int weight = eq.numeric_modifier("Familiar Weight");
	int meat = eq.numeric_modifier("Meat Drop");
	if (runFamiliar == orphan)
		return meat;
	else if (runFamiliar == robort)
		meat += weight * 25; // just a rough estimate
	else if (runFamiliar == hoboMonkey)
		meat += weight * 17;
	else if (IsLeprechaunType(runFamiliar))
		meat += weight * 13;
	return meat;
}

slot ChooseBarfReplacementAccessory(item[slot] forOutfit)
{
	int meat1 = EstimateMeatBonusPercent(forOutfit[acc1]);
	int meat2 = EstimateMeatBonusPercent(forOutfit[acc2]);
	int meat3 = EstimateMeatBonusPercent(forOutfit[acc3]);
	if (meat1 < meat2 && meat1 < meat3)
		return acc1;
	else if (meat2 < meat1 && meat2 < meat3)
		return acc2;
	else
		return acc3;
}

void PrepareBarf(boolean RequireOutfit)
{
	boolean mayflyEq = false;
	boolean protonEq = false;
	foreach s, i in defaultOutfitPieces
	{
		barfOutfitPieces[s] = i;
		if (i == mayfly)
			mayflyEq = true;
		if (i == protonPack)
			protonEq = true;
	}

	if (HaveEquipment(mayfly) && get_property("_mayflySummons").to_int() < 30)
	{
		if (!mayflyEq)
		{
			barfOutfitPieces[ChooseBarfReplacementAccessory(barfOutfitPieces)] = mayfly;
		}
		needsMayfly = true;
	}
	else if (HaveEquipment(doctorBag) && get_property("doctorBagQuestLocation") == "" && !OutfitContains(barfOutfitPieces, doctorBag))
	{
		barfOutfitPieces[ChooseBarfReplacementAccessory(barfOutfitPieces)] = doctorBag;
	}
	if (HaveEquipment(protonPack) && back.equipped_item() != protonPack)
	{
		if (total_turns_played() > get_property("nextParanormalActivity").to_int() + 5)
		{
			if (!protonEq)
				barfOutfitPieces[back] = protonPack;
		}
	}
	WearOutfit(barfOutfitPieces);

	ChooseThrall(true);
	RemoveConfusionEffects(false);

}
boolean CanWitchess()
{
	return (get_campground() contains witchess
		&& get_property("_witchessFights").to_int() < 5);
}
string ActivateWitchess(monster m)
{
	int piece;
	switch (m)
	{
		case $monster[Witchess Bishop]: piece = 1942; break;
		case $monster[Witchess King]: piece = 1940; break;
		case $monster[Witchess Knight]: piece = 1936; break;
		case $monster[Witchess Ox]: piece = 1937; break;
		case $monster[Witchess Pawn]: piece = 1935; break;
		case $monster[Witchess Queen]: piece = 1939; break;
		case $monster[Witchess Rook]: piece = 1938; break;
		case $monster[Witchess Witch]: piece = 1941; break;
		default: return "";
	}
	if (piece == 0)
		return "";
	visit_url("campground.php?action=witchess", false);
	run_choice(1);
	return visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=" + piece, false);
}
boolean TryRunWitchess(string filter)
{
	if (CanWitchess())
	{
		if (filter == "Filter_Standard" && cigar.item_amount() > 0)
		{
			ChooseEducate(true, false);
		}
		string page = ActivateWitchess($monster[Witchess Knight]);
		if (page != "")
		{
			RunCombat(filter);
			return true;
		}
	}
	return false;
}
string ActivateEldritchTentacle()
{
	if (get_property("_eldritchTentacleFought") != "false")
		return "";
	string page = visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
	int choiceId = FindVariableChoice(page, "Can I fight that tentacle you saved for science?", true);
	if (choiceId >= 0)
	{
		return run_choice(choiceId, false);
	}
	return "";
}
boolean ValidateSnojoFreeFights()
{
	if (get_property("snojoAvailable") != "true")
		return false;
	if (get_property("_snojoFreeFights").to_int() >= 10)
		return false;
	string page = visit_url("place.php?whichplace=snojo");
	if (page.contains_text("Fight the X-32-F Combat Training Snowman (1)")) // the pokefam path doesn't give free fights, make sure this is valid
	{
		print("Snojo fights aren't free in this path, skipping.", printColor);
		return false;
	}
	return true;
}
boolean SnojoFreeFightsAllowed = ValidateSnojoFreeFights();
boolean TryRunSnojo(string filter)
{
	if (!SnojoFreeFightsAllowed)
		return false;
	if (get_property("snojoAvailable").to_boolean()
		&& get_property("_snojoFreeFights").to_int() < 10)
	{
		if (get_property("snojoSetting") == "NONE")
		{
			print("Snojo not configured yet, setting to Muscle mode", printColor);
			visit_url("place.php?whichplace=snojo&action=snojo_controller");
			run_choice(1); // start with muscle
			if (get_property("snojoSetting") == "NONE")
				return false;
		}
		RunAdventure(snojo, filter);
		return true;
	}
	return false;
}
boolean TryRunNeverendingParty(string filter)
{
	if (get_property("_neverendingPartyFreeTurns").to_int() >= 10)
		return false;
	if (get_property("_neverPartyQuest") == "Megawoots")
	{
		football.TryGetFromCloset(1);
		if (!HaveEquipment(football))
		{
			offhand.equip(football);
		}
	}
	string page = visit_url(neverParty.to_url());
	if (page.contains_text("The Beginning of the Neverend"))
	{
		if (page.contains_text("Geraldine"))
		{
			set_property("_neverPartyQuest", "Geraldine");
			run_choice(1); // take the quest
			return true;
		}
		else if (page.contains_text("Gerald"))
		{
			set_property("_neverPartyQuest", "Gerald");
			run_choice(1); // take the quest
			return true;
		}
		else if (page.contains_text("megawoots right now"))
		{
			set_property("_neverPartyQuest", "Megawoots");
			run_choice(1); // take the quest
			return true;
		}
		else if (page.contains_text("wants a bunch of Meat"))
		{
			set_property("_neverPartyQuest", "Meat");
			run_choice(1); // take the quest
			return true;
		}
		else if (page.contains_text("It's the trash that they'll object to"))
		{
			set_property("_neverPartyQuest", "Trash");
			run_choice(1); // accept quest
			return true;
		}
		else if (page.contains_text("got all of the people to leave"))
		{
			set_property("_neverPartyQuest", "None");
			run_choice(2); // reject quest
			return true;
		}
		// todo: add these as they're encountered
		//else if (page.contains_text(""))
		//{
		//}
		else abort("Unhandled neverending party quest");
	}
	else if (page.contains_text("It Hasn't Ended, It's Just Paused"))
	{
		if (get_property("_neverPartyQuest") == "Geraldine")
		{
			run_choice(2); // Check out the kitchen
			run_choice(3); // Talk to the woman
			return true;
		}
		else if (get_property("_neverPartyQuest") == "Gerald")
		{
			run_choice(3); // Go to the back yard
			run_choice(3); // Talk to gerald
			return true;
		}
		else if (get_property("_neverPartyQuest") == "Megawoots")
		{
			run_choice(1); // Head upstairs
			run_choice(5); // Toss the red dress on the lamp
			set_property("_neverPartyQuest", "Megawoots2");
			return true;
		}
		else if (get_property("_neverPartyQuest") == "Megawoots2")
		{
			run_choice(4); // Head to the basement
			run_choice(4); // Modify the living room lights
			return true;
		}
		else if (get_property("_neverPartyQuest") == "None")
		{
			run_choice(1); // Go upstairs
			run_choice(1); // Take a nap
			BurnManaSummoning(100);
			return true;
		}
		//else if (get_property("_neverPartyQuest") == )
		//{
		//}
		else
			abort("Unhandled adventure in neverending party");
	}
	else if (page.contains_text("You're fighting"))
	{
		RunCombat(filter);
		return true;
	}
	else if (page.contains_text("All Done!"))
	{
		run_choice(1);
		return false;
	}
	else if (page.contains_text("Party's Over"))
	{
		set_property("_neverendingPartyFreeTurns", 10);
		return false;
	}
	else if (TryHandleNonCombat(page))
	{
		return false;
	}
	else
		abort("Unhandled adventure in neverending party");
	return false;
}
boolean TryFightSeal(string filter)
{
	if (sealFigurine.item_amount() == 0)
		buy(10, sealFigurine);
	if (sealCandle.item_amount() == 0)
		buy(10, sealCandle);
	string page = visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=" + sealFigurine.to_int()); // use(1, sealFigurine);
	if (page.contains_text("Begin the Ritual"))
	{
		page = visit_url("inv_use.php?pwd=" + my_hash() + "&whichitem=" + sealFigurine.to_int() + "&checked=1");
		if (page.contains_text("You light the candle"))
		{
			RunCombat(filter);
			return true;
		}
	}
	return false;
}
boolean TryRunMachineTunnels(string filter)
{
// todo
	return false;
}

boolean IsFreeFightMonster(monster m)
{
	switch (m)
	{
		case $monster[%monster%]: return true;
		case $monster[Angry bassist]: return true;
		case $monster[Black Crayon Beast]: return true;
		case $monster[Black Crayon Beetle]: return true;
		case $monster[Black Crayon Constellation]: return true;
		case $monster[Black Crayon Crimbo Elf]: return true;
		case $monster[Black Crayon Demon]: return true;
		case $monster[Black Crayon Elemental]: return true;
		case $monster[Black Crayon Fish]: return true;
		case $monster[Black Crayon Flower]: return true;
		case $monster[Black Crayon Frat Orc]: return true;
		case $monster[Black Crayon Goblin]: return true;
		case $monster[Black Crayon Golem]: return true;
		case $monster[Black Crayon Hippy]: return true;
		case $monster[Black Crayon Hobo]: return true;
		case $monster[Black Crayon Man]: return true;
		case $monster[Black Crayon Manloid]: return true;
		case $monster[Black Crayon Mer-kin]: return true;
		case $monster[Black Crayon Penguin]: return true;
		case $monster[Black Crayon Pirate]: return true;
		case $monster[Black Crayon Shambling Monstrosity]: return true;
		case $monster[Black Crayon Slime]: return true;
		case $monster[Black Crayon Spiraling Shape]: return true;
		case $monster[Black Crayon Undead Thing]: return true;
		case $monster[Blue-haired girl]: return true;
		case $monster[Boneless blobghost]: return true;
		case $monster[BRICKO airship]: return true;
		case $monster[BRICKO bat]: return true;
		case $monster[BRICKO cathedral]: return true;
		case $monster[BRICKO elephant]: return true;
		case $monster[BRICKO gargantuchicken]: return true;
		case $monster[BRICKO octopus]: return true;
		case $monster[BRICKO ooze]: return true;
		case $monster[BRICKO oyster]: return true;
		case $monster[BRICKO python]: return true;
		case $monster[BRICKO turtle]: return true;
		case $monster[BRICKO vacuum cleaner]: return true;
		case $monster[Broodling seal]: return true;
		case $monster[Eldritch Tentacle]: return true;
		case $monster[Emily Koops, a spooky lime]: return true;
		case $monster[Evil ex-girlfriend]: return true;
		case $monster[Heat seal]: return true;
		case $monster[Hermetic seal]: return true;
		case $monster[Lynyrd]: return true;
		case $monster[Navy seal]: return true;
		case $monster[Peeved roommate]: return true;
		case $monster[Random scenester]: return true;
		case $monster[Sausage goblin]: return true;
		case $monster[Servant of Grodstank]: return true;
		case $monster[Shadow of Black Bubbles]: return true;
		case $monster[Spawn of Wally]: return true;
		case $monster[The ghost of Ebenoozer Screege]: return true;
		case $monster[The ghost of Jim Unfortunato]: return true;
		case $monster[The ghost of Lord Montague Spookyraven]: return true;
		case $monster[The ghost of Monsieur Baguelle]: return true;
		case $monster[The ghost of Oily McBindle]: return true;
		case $monster[The ghost of Richard Cockingham]: return true;
		case $monster[The ghost of Sam McGee]: return true;
		case $monster[The ghost of Vanillica "Trashblossom" Gorton]: return true;
		case $monster[The ghost of Waldo the Carpathian]: return true;
		case $monster[The Headless Horseman]: return true;
		case $monster[The Icewoman]: return true;
		case $monster[Time-spinner prank]: return true;
		case $monster[Watertight seal]: return true;
		case $monster[Wet seal]: return true;
		case $monster[Witchess Bishop]: return true;
		case $monster[Witchess King]: return true;
		case $monster[Witchess Knight]: return true;
		case $monster[Witchess Ox]: return true;
		case $monster[Witchess Pawn]: return true;
		case $monster[Witchess Queen]: return true;
		case $monster[Witchess Rook]: return true;
		case $monster[Witchess Witch]: return true;
	}
	return false;
}

void WishFor(string wishFor)
{
	if (get_property("_genieWishesUsed").to_int() >= 3
		|| genie.item_amount() == 0)
	{
		BuyItemIfNeeded(wish, 1, 55000);
	}
	cli_execute("genie wish " + wishFor);
}
void WishForEffect(effect e)
{
	if (e.have_effect() > 0) // wishes are expensive, only wish for things you don't already have
		return;
	WishFor("I was " + e);
}

int CountBrickoFights(boolean nextDay)
{
	int count = 10; // brickos
	if (!nextDay)
		count -= get_property("_brickoFights").to_int();
	return count;
}
int CountLynyrdFights(boolean nextDay)
{
	int count = 3;  // lynyrds
	if (!nextDay)
		count -= get_property("_lynyrdSnareUses").to_int();
	return count;
}
int CountSealFights(boolean nextDay)
{
	int count = 0;
	if (my_class().to_string() == "Seal Clubber")
	{
		count += 5;
		if (uraniumSeal.item_amount() > 0)
			count += 5;
		if (!nextDay)
			count -= get_property("_sealsSummoned").to_int();
	}
	return count;
}
int CountWitchessFights(boolean nextDay)
{
	int count = 0;
	if (get_campground() contains witchess)
	{
		count += 4; // reserve one witchess fight for other stuff
		if (!nextDay)
			count -= get_property("_witchessFights").to_int();
		if (count < 0)
			count = 0;
	}
	return count;
}
int CountSnojoFights(boolean nextDay)
{
	int count = 0;
	if (get_property("snojoAvailable").to_boolean())
	{
		count += 10; // snojo
		if (!nextDay)
			count -= get_property("_snojoFreeFights").to_int();
	}
	return count;
}
int CountMachineTunnelFights(boolean nextDay)
{
	int count = 0;
	if (machineElf.have_familiar())
	{
		count += 5;
		if (!nextDay)
			count -= get_property("_machineTunnelsAdv").to_int();
		if (attunement.have_effect() > 0) // but the 5th fight will trigger another eldritch fight, so you'll get 6
			count += 1;
	}
	return 0;
}
int CountEldritchFights(boolean nextDay)
{
	int count = 0;
	if (nextDay || (get_property("_eldritchTentacleFought") == "false"))
		count += 1;
	if (evokeHorror.have_skill())
		if (nextDay || (get_property("_eldritchHorrorEvoked") == "false"))
			count += 1;
	return count;
}
boolean CanFightMushroomGarden()
{
	if (get_property("_mushroomGardenVisited") != "false") // whether we've fertilized/picked yet
		return false;
	// not sure if we should handle the choice automatically, this commented code will prevent visiting the pick/fertilize choice adventure
	//int foughtCount = get_property("_mushroomGardenFights").to_int();
	//if (foughtCount == 1 || foughtCount == 5) // once we've fought it once (or 5 times after a plumber run), no more
	//	return false;
	foreach it, count in get_campground()
	{
		if (it == mushroomGarden)
		{
			return true;
		}
		if (it == pokeGarden || it == cornucopia || it == thanksGarden)
		{
			if (mushroomGarden.item_amount() > 0)
			{
				if (count > 1)
				{
					print("Can't swap to mushroom garden because current garden needs harvesting first", printColor);
					return false;
				}
				use(1, mushroomGarden);
				return true;
			}
		}
	}
	return false;
}

int EstimateFreeFightCost(boolean nextDay)
{
	return
		(brickoEye.historical_price() + 2 * brickoBrick.historical_price()) * CountBrickoFights(nextDay)
		+ lynyrdSnare.historical_price() * CountLynyrdFights(nextDay)
		+ 400 * CountSealFights(nextDay);
}

int CountFreeCombatsAvailable(boolean nextDay)
{
	int count = 0;
	count += CountSnojoFights(nextDay);
	count += CountWitchessFights(nextDay);
	count += CountBrickoFights(nextDay);
	count += CountLynyrdFights(nextDay);
	count += CountSealFights(nextDay);

	if (attunement.have_effect() > 0) // if we have Eldritch attunement, get an extra free fight after each
	{
		count *= 2;
		count += 11; // drunk pygmy
		if (!nextDay)
			count -= get_property("_drunkPygmyBanishes").to_int();
	}

	count += CountMachineTunnelFights(nextDay); // eldritch attunement fights count against free fights here, so don't double them

	// the eldritch free fights don't trigger eldritch attunement:
	count += CountEldritchFights(nextDay);
	return count;
}
boolean IsCombatMeatFamiliar(familiar f)
{
	switch (f)
	{
		case boa:
		case npzr:
		case stocking:
		case fistTurkey:
			return true;
	}
	return false;
}
void PrepareFreeCombat(item[slot] selectedOutfit, familiar chosenFamiliar)
{
	if (my_familiar() != chosenFamiliar)
		SwitchToFamiliar(chosenFamiliar);
	if (IsCombatMeatFamiliar(my_familiar()))
		TryUseMovableFeast();
	if (jingleBells.have_skill())
		CastSkill(jingleBells, 1, true); // only need 1 turn of it
	WearOutfit(SwapOutSunglasses(selectedOutfit));
	ChooseBjornCrownFamiliars(false); // don't want drops familiar bjornified with machine elf
	ChooseThrall(true);
	RemoveConfusionEffects(false);
	HealUp();
	ResetCombatState();
}
void PrepareFreeCombat(item[slot] selectedOutfit)
{
	familiar fam = runFamiliar;
	foreach ix, f in freeCombatFamiliars
	{
		if (f.have_familiar())
		{
			fam = f;
			break;
		}
	}
	PrepareFreeCombat(selectedOutfit, fam);
}

string ChooseDictionaryCombatAction()
{
	if (dictionary.item_amount() > 0)
		return "item " + dictionary;
	else if (faxdictionary.item_amount() > 0)
		return "item " + faxdictionary;
	abort("Why don't you have at least 1 dictionary?  Up to you to figure out how to handle this combat");
	return "";
}
string WrapInSafetyCheck(string actionString)
{
//return actionString;
//return "; " + actionString;
	return "; if !hppercentbelow 33"
	//return "; if monsterhpabove 350 && !hppercentbelow 33"
		+ "; " + actionString + "; endif";
}
string WrapInSafetyCheck(skill sk)
{
	if (sk.have_skill())
	{
		if (sk.mp_cost() > my_mp())
		{
			print("Not enough MP for " + sk, printColor);
			return "";
		}
		return WrapInSafetyCheck("skill " + sk);
	}
	print("no " + sk, printColor);
	return "";
}
string WrapInSafetyCheck(item it)
{
	if (it.item_amount() > 0)
		return WrapInSafetyCheck("use " + it.to_int());
		//return WrapInSafetyCheck("item " + it);
	print("no " + it, printColor);
	return "";
}

string Filter_ScalingFreeKill(int round, monster mon, string page)
{
	if (my_hp() * 3 < my_maxhp()) // too low on health, end it
		return ChooseFreeKillMethodForFilter();
	if (monster_hp() < 350 || round > 22) // don't take a chance of it using up a turn
		return ChooseFreeKillMethodForFilter();
	string result = "";
	if (staggerOption < 1)
	{
		staggerOption = 1;
		result += WrapInSafetyCheck(stealthMistletoe);
	}
	if (staggerOption < 2)
	{
		staggerOption = 2;
		result += WrapInSafetyCheck(curseOfWeaksauce);
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		result += "; skill Sing Along";
	}
	if (staggerOption < 3)
	{
		staggerOption = 3;
		result += WrapInSafetyCheck(micrometeorite);
	}
	if (staggerOption < 4)
	{
		staggerOption = 4;
		result += WrapInSafetyCheck(loveGnats);
	}
	if (staggerOption < 5)
	{
		staggerOption = 5;
		result += WrapInSafetyCheck(entanglingNoodles);
	}
	if (result != "")
	{
		result = result.substring(2);
		print("Running macro: " + result, printColor);
		return result;
	}
	if (staggerOption < 6)
	{
		staggerOption = 6;
		result += WrapInSafetyCheck(timeSpinner);
	}
	if (staggerOption <= 6)
	{
		staggerOption = 7;
		result += WrapInSafetyCheck(littleRedBook);
	}
	if (staggerOption <= 7)
	{
		staggerOption = 8;
		result += WrapInSafetyCheck(indigoCup);
	}
	if (staggerOption <= 8)
	{
		staggerOption = 9;
		result += WrapInSafetyCheck(blueBalls);
	}
	if (staggerOption <= 9)
	{
		staggerOption = 10;
		result += WrapInSafetyCheck(beehive);
	}
	if (staggerOption <= 10)
	{
		staggerOption = 11;
		result += WrapInSafetyCheck(shellUp);
	}
	if (staggerOption <= 11)
	{
		staggerOption = 12;
		result += WrapInSafetyCheck(silentKnife);
	}
	if (result != "")
	{
		result = result.substring(2);
		print("Running macro: " + result, printColor);
		return result;
	}
	return ChooseDictionaryCombatAction();
}
boolean IsFreeCombat(monster mon)
{
	if (   mon == kramcoGoblin
		|| mon == tentacle
		|| mon == $monster[angry bassist]
		|| mon == $monster[blue-haired girl]
		|| mon == $monster[evil ex-girlfriend]
		|| mon == $monster[peeved roommate]
		|| mon == $monster[random scenester]
		)
	{
		return true;
	}
	string name = mon.to_string();
	if (   name.starts_with("Black Crayon ")
		|| name.starts_with("Witchess ")
		)
	{
		return true;
	}
	return false;
}
string Filter_FreeCombat(int round, monster mon, string page)
{
	if (round <= 10)
	{
		if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
		{
			cursed = true;
			return "skill " + curseOfWeaksauce.to_string();
		}
		if (!timeSpinnered && timeSpinner.item_amount() > 0)
		{
			timeSpinnered = true;
			return "item " + timeSpinner;
		}
		if (CanCast(micrometeorite) && !micrometeorited) // reduce damage taken
		{
			micrometeorited = true;
			return "skill " + micrometeorite.to_string();
		}
		if (canSingAlong)
		{
			canSingAlong = false;
			return "skill Sing Along";
		}
		return ChooseDictionaryCombatAction();
	}
	string dup = Filter_Duplicate(round, mon, page);
	if (dup != "")
		return dup;
	return "";
}

int snokebombTurn = 0;
int politicsTurn = 0;
int kgbDartTurn = 0;
int reflexHammerTurn = 0;
int louderThanBombTurn = 0;
int tennisballTurn = 0;
boolean batterUpUsed = false;
boolean nanorhinoUsed = false;
string ChooseBanish()
{
	if (snokebombTurn < my_turnCount())
	{
		snokebombTurn = my_turnCount() + 30;
		return "skill Snokebomb";
	}
	if (reflexHammerTurn < my_turnCount() && doctorBag.have_equipped())
	{
		reflexHammerTurn = my_turnCount() + 30;
		return "skill Reflex Hammer";
	}
	if (kgbDartTurn < my_turnCount() && kgb.have_equipped())
	{
		kgbDartTurn = my_turnCount() + 20;
		return "skill KGB tranquilizer dart";
	}
	if (tennisballTurn < my_turnCount() && tennisBall.item_amount() > 0)
	{
		tennisballTurn = my_turnCount() + 30;
		return "item " + tennisBall + ", none";
	}
	if (louderThanBombTurn < my_turnCount() && louderThanBomb.item_amount() > 0)
	{
		louderThanBombTurn = my_turnCount() + 20;
		return "item " + louderThanBomb + ", none";
	}
	if (politicsTurn < my_turnCount() && pantsGiving.have_equipped())
	{
		politicsTurn = my_turnCount() + 30;
		return "skill Talk About Politics";
	}
	return "";
}


// todo: check if we actually have these skills/items
string Filter_BowlingAlley(int round, monster mon, string page)
{
	if (IsFreeCombat(mon))
		return Filter_FreeCombat(round, mon, page);
	if (mon == bowler || mon == orderlies || mon == janitor)
	{
		string banish = ChooseBanish();
		if (banish != "")
			return banish;
	}
	return Filter_Standard(round, mon, page);
}
string Filter_MachineTunnels(int round, monster mon, string page)
{
	if (can_still_steal())
	{
		return "\"pickpocket\"";
	}
	if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
	{
		cursed = true;
		return "skill " + curseOfWeaksauce.to_string();
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill Sing Along";
	}
	if (!abstractioned)
	{
		if (mon == machineTriangle) // triangle monster
		{
			abstractioned = true;
			if (abstrThought.item_amount() > 0)
				return "item " + abstrThought + ", none";
		}
		else if (mon == machineCircle) // circle monster
		{
			abstractioned = true;
			if (abstrAction.item_amount() > 0)
				return "item " + abstrAction + ", none";
		}
		else if (mon == machineSquare) // square monster
		{
			abstractioned = true;
			if (abstrSensation.item_amount() > 0)
				return "item " + abstrSensation + ", none";
		}
	}
	return Filter_Standard(round, mon, page);
}

boolean TryEquip(item[slot] outfitItems, item eqp)
{
	if (!eqp.HaveEquipment())
		return false;
	outfitItems[famEqp] = eqp;
	return true;
}

boolean RunFreeCombat(item[slot] selectedOutfit, string filter, boolean forMeat)
{
	if (machineElf.have_familiar() && get_property("_machineTunnelsAdv").to_int() < 5)
	{
		PrepareFreeCombat(selectedOutfit, machineElf);
		RunAdventure(machineTunnels, "Filter_MachineTunnels");
		return true;
	}
	if (godLobster.have_familiar() && get_property("_godLobsterFights").to_int() < 3)
	{
		item[slot] withEqp = CopyOutfit(selectedOutfit);
		if (!TryEquip(withEqp, $item[God Lobster's Crown]))
			if (!TryEquip(withEqp, $item[God Lobster's Robe]))
				if (!TryEquip(withEqp, $item[God Lobster's Rod]))
					if (!TryEquip(withEqp, $item[God Lobster's Ring]))
						TryEquip(withEqp, $item[God Lobster's Scepter]);
		PrepareFreeCombat(withEqp, godLobster);
		string page = visit_url("main.php?fightgodlobster=1");
		if (InCombat(page))
		{
			page = run_combat(filter);
			if (InCombat(page))
			{
				page = visit_url("choice.php");
				if ($item[God Lobster's Crown].have_equipped())
					PushChoiceAdventureButton(page, "I'd like some experience.");
				else
					PushChoiceAdventureButton(page, "I'd like part of your regalia.");
			}
			else
			{
				print("God lobster fight failed.", printColor);
				print(page);
				abort();
			}
		}
		return true;
	}
	if (!forMeat || covetous.have_effect() > 0)
	{
		if (get_property("_brickoFights").to_int() < 10)
		{
			int brickosNeeded = 10 - brickoOoze.item_amount();
			if (brickosNeeded > 0)
			{
				BuyItemIfNeeded(brickoBrick, 2 * brickosNeeded, 500);
				BuyItemIfNeeded(brickoEye, brickosNeeded, 1000);
			}
			while (brickoOoze.item_amount() < 10 && brickoBrick.item_amount() >= 2 && brickoEye.item_amount() >= 1)
			{
				use(2, brickoBrick);
			}
			if (brickoOoze.item_amount() > 0)
			{
				PrepareFreeCombat(selectedOutfit);
				use(1, brickoOoze);
				RunCombat(filter);
				return true;
			}
		}
		if (get_property("_lynyrdSnareUses").to_int() < 3)
		{
			BuyItemIfNeeded(lynyrdSnare, 3, 1000);
			if (lynyrdSnare.item_amount() > 0)
			{
				PrepareFreeCombat(selectedOutfit);
				use(1, lynyrdSnare);
				RunCombat(filter);
				return true;
			}
		}
	}
	if (get_property("_eldritchTentacleFought") == "false" && pocketProfessorCloneMonster != $monster[Eldritch Tentacle])
	{
		PrepareFreeCombat(selectedOutfit);
		string page = ActivateEldritchTentacle();
		if (page != "")
		{
			RunCombat(filter);
			return true;
		}
	}
	if (evokeHorror.have_skill() && get_property("_eldritchHorrorEvoked") == "false")
	{
		PrepareFreeCombat(selectedOutfit);
		use_skill(1, evokeHorror);
		RunCombat(filter);
		return true;
	}
	if (attunement.have_effect() > 0 && get_property("_drunkPygmyBanishes").to_int() < 11 && scorpions.item_amount() > 0)
	{
		string page = visit_url("place.php?whichplace=hiddencity");
		if (!page.contains_text("Uh Oh!"))  // city not unlocked
		{
			// you don't get bonus from these fights, but they should trigger eldritch attunement fights
			if (scorpions.item_amount() < 11)
			{
				buy(11 - scorpions.item_amount(), scorpions);
			}
			if (HaveEquipment(kgb)
				&& selectedOutfit[acc1] != kgb
				&& selectedOutfit[acc2] != kgb
				&& selectedOutfit[acc3] != kgb)
			{
				selectedOutfit[acc1] = kgb;
			}
			PrepareFreeCombat(selectedOutfit);
			if (bowlingBall.item_amount() > 0)
				put_closet(bowlingBall.item_amount(), bowlingBall);
			RunAdventure(bowlingAlley, "Filter_BowlingAlley");
			return true;
		}
	}
	if (get_property("snojoAvailable") == "true" && get_property("_snojoFreeFights").to_int() < 10)
	{
		PrepareFreeCombat(selectedOutfit);
		if (TryRunSnojo(filter))
			return true;
	}
	if (get_property("neverendingPartyAlways") == "true" && get_property("_neverendingPartyFreeTurns").to_int() < 10)
	{
		PrepareFreeCombat(selectedOutfit);
		if (TryRunNeverendingParty(filter))
			return true;
	}
	if (get_campground() contains witchess
		&& get_property("_witchessFights").to_int() < 4) // save one for manual running to cast duplicate
	{
		PrepareFreeCombat(selectedOutfit);
		if (TryRunWitchess(filter))
			return true;
	}
	if (glitch.item_amount() > 0 && get_property("_glitchMonsterFights").to_int() == 0)
	{
		PrepareFreeCombat(selectedOutfit);
		string page = visit_url("inv_eat.php?which=f0&whichitem=10207");
		if (InCombat(page))
		{
			RunCombat(filter);
			return true;
		}
	}
	if (CanFightMushroomGarden())
	{
		PrepareFreeCombat(selectedOutfit);
		string page = visit_url("adventure.php?snarfblat=543");
		if (InCombat(page))
		{
			RunCombat(filter);
			return true;
		}
		else
		{
			int cropLevel = get_property("mushroomGardenCropLevel").to_int();
			string crop;
			switch (cropLevel)
			{
				case 0:
				case 1: crop = "free-range mushroom"; break;
				case 2: crop = "plump free-range mushroom"; break;
				case 3: crop = "bulky free-range mushroom"; break;
				case 4: crop = "giant free-range mushroom"; break;
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
				case 10: crop = "immense free-range mushroom"; break;
				case 11:
				default: crop = "colossal free-range mushroom"; break;
			}
			boolean defaultConfirm = cropLevel >= 5; // pick once it's immense by default
			if (AscensionScheduledToday() || UserConfirmDefault("Pick " + crop + " today, with " + (cropLevel - 1) + " days fertilized?", defaultConfirm))
				run_choice(2); // pick the mushroom
			else
				run_choice(1); // fertilize the mushroom
			PrepGarden();
		}
	}
	// todo:
// infernal seals
	if (my_class().to_string() == "Seal Clubber")
	{
		int sealsRemaining = 5 - get_property("_sealsSummoned").to_int();
		if (uraniumSeal.item_amount() > 0)
			sealsRemaining += 5;
		if (sealsRemaining > 0)
		{
			if (selectedOutfit[weapon].item_type() != "club")
			{
				if (HaveEquipment(tenderizer))
					selectedOutfit[weapon] = tenderizer;
				else if (HaveEquipment(bludgeon))
					selectedOutfit[weapon] = bludgeon;
				else if (HaveEquipment(club))
					selectedOutfit[weapon] = club;
			}
			print("Trying to equip club for seal fight: " + selectedOutfit[weapon], printColor);

			PrepareFreeCombat(selectedOutfit);
			if (weapon.equipped_item().item_type() == "club")
			{
				return TryFightSeal("Filter_Seal");
			}
			else
				print("Cannot fight seal because no club found, wearing " + weapon.equipped_item().to_string(), printColor);
		}
	}
	return false;
}
boolean RunFreeCombat(item[slot] selectedOutfit, boolean forMeat)
{
	string filter = "Filter_FreeCombat";
	return RunFreeCombat(selectedOutfit, filter, forMeat);
}
boolean RunFreeCombat(boolean forMeat)
{
	return RunFreeCombat(CopyOutfit(weightOutfitPieces), forMeat);
}

void FreeCombatsForProfit()
{
	boolean runFree = covetous.have_effect() > 0;
	foreach ix, f in freeCombatFamiliars
	{
		if (f.have_familiar())
			runFree = true;
	}
	if (runFree)
	{
		HealUp();
		while (RunFreeCombat(true)) // true = forMeat
		{
			if (beatenUp.have_effect() > 0)
				abort("Lost during free combat, do you need to adjust your combat parameters?");
			BurnManaAndRestores(100, false);
		}
	}
}


// dead code, replaced with "drops" outfit:
//	void EnsureSingleHandedWeapon()
//	{
//		if (weapon.equipped_item().weapon_hands() < 2)
//			return;
//		weapon.equip(noItem);
//	}
//	void EquipDropsItems()
//	{
//		if (scratchSword.have_equipped() || scratchXbow.have_equipped())
//		{
//			weapon.equip(noItem);
//			foreach ix,itm in outfit_pieces(defaultOutfit)
//			{
//				if (itm.to_slot() == weapon)
//				{
//					weapon.equip(itm);
//					break;
//				}
//			}
//		}
//		EnsureSingleHandedWeapon();
//		if (snowglobe.item_amount() > 0)  // don't benefit from meat drop, may as well get a bonus item drop
//			offhand.equip(snowglobe);
//		if (screege.item_amount() > 0 && !screege.have_equipped())
//			acc1.equip(screege);
//		if (cheeng.item_amount() > 0 && !cheeng.have_equipped())
//			acc2.equip(cheeng);
//		ChooseBjornCrownFamiliars(false); // drops familiar
//	}

string AvailableSpellForBagOfTricks()
{
	if (CanCast(mortarShell))
		return "skill " + mortarShell.to_string();
	if (CanCast(BoTspell1))
		return "skill " + BoTspell1.to_string();
	if (CanCast(BoTspell2))
		return "skill " + BoTspell2.to_string();
	if (CanCast(sauceStorm))
		return "skill " + sauceStorm.to_string();
	return "";
}
string NonSpellWhileWearingBagOfTricks()
{
	if (CanCast(thrustSmack))
		return "skill " + thrustSmack.to_string();
	if (CanCast(weaponPasta))
		return "skill " + weaponPasta.to_string();
	return "attack";
}
boolean HaveBagOTricksBuff()
{
	if (bagOtricksEffect1.have_effect() > 0) // can't re-activate
		return true;
	if (bagOtricksEffect2.have_effect() > 0) // can't re-activate
		return true;
	if (bagOtricksEffect3.have_effect() > 0) // can't re-activate
		return true;
	return false;
}
string Filter_BagOTricks(int round, monster mon, string page)
{
	if (!HaveBagOTricksBuff())
	{
		if (get_property("bagOTricksCharges").to_int() > 0)
			return "skill Open the Bag o' Tricks";
		else
			return AvailableSpellForBagOfTricks();
	}
	return NonSpellWhileWearingBagOfTricks(); // finish them off with non-spell skills
}


void TryActivateBagOTricks(item[slot] eqSet)
{
	if (!HaveEquipment(bagOtricks))
		return;
	if (HaveBagOTricksBuff())
		return;
	if (AvailableSpellForBagOfTricks() == "")
		return;
	if (get_property("_bagOTricksBuffs").to_int() >= 3) // max 3 per day
		return;
	item oldOffhand = offhand.equipped_item();
	eqSet[offhand] = bagOtricks;
	if (eqSet[weapon].weapon_hands() >= 2)
	{
		// two handed-weapon, how do we deal with this?  don't want to fight empty-handed
		if (HaveEquipment(cheeseSword))
			eqSet[weapon] = cheeseSword;
		else
			eqSet[weapon] = noItem;
	}
	if (bagOtricks.have_equipped())
	{
		RunFreeCombat(eqSet, "Filter_BagOTricks", false);
	}
	offhand.equip(oldOffhand); // make sure we don't accidentally wear it when we don't intend to, or the buffs will get messed up
}
boolean TryActivatePantsgivingFullness()
{
	if (!HaveEquipment(pantsGiving))
		return false;
	if (my_fullness() != fullness_limit())
		return false;

	item[slot] eqSet = CopyOutfit(dropsOutfitPieces);
	eqSet[pants] = pantsGiving;
	print("Trying to activate Pantsgiving to increase max fullness by 1", printColor);
	boolean first = true;
	while (get_property("_pantsgivingFullness").to_int() == 0)
	{
		WearOutfit(eqSet);
		if (!pantsGiving.have_equipped())
			break;
		ChooseDropsFamiliar(false);
		if (first)
		{
			first = false;
			TryActivateBagOTricks(eqSet);
		}
		else
		{
			if (!RunFreeCombat(eqSet, false))
			{
				abort("Failed to run free combat for Pantsgiving"); // todo: change this to a print once it's debugged
				break;
			}
		}
	}
	return my_fullness() == fullness_limit() - 1;
}

string Filter_TrapGhost(int round, monster mon, string page)
{
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill Sing Along";
	}
	if (CanCast(curseOfIslands) && !cursed) // reduce chances of stun breaking early
	{
		cursed = true;
		return "skill " + curseOfIslands.to_string();
	}
	if (extractJelly.have_skill())
	{
		extracted = true;
		return "skill " + extractJelly.to_string();
	}
	if (CanCast(accordionBash) && round >= stunRound && !bashed) // always stun if you have it
	{
		bashed = true;
		stunRound = round + 3;
		return "skill " + accordionBash.to_string();
	}
	if (soulBubble.have_skill() && round >= stunRound && !bubbled) // only works if you are sauceror and have soulsauce
	{
		bubbled = true;
		stunRound = round + 3;
		return "skill " + soulBubble.to_string();
	}
	if (CanCast(entanglingNoodles) && round >= stunRound && !noodled) // only stuns if you are a pastamancer
	{
		noodled = true;
		stunRound = round + 3;
		return "skill " + entanglingNoodles.to_string();
	}
	if (weakenGhost.have_skill() && ghostShot < 3)
	{
		ghostShot++;
		return "skill " + weakenGhost.to_string();
	}
	if (trapGhost.have_skill())
		return "skill " + trapGhost.to_string();
	return "";
}
void EquipGhostGear(location loc)
{
	item[slot] gear = CopyOutfit(dropsOutfitPieces);
	if (loc == palindome)
	{
		gear[acc3] = talisman;
	}
	else if (loc == icyPeak)
	{
		gear[head] = coldHead; // need 5 resist to visit location
		gear[pants] = coldPants;
		gear[acc3] = coldAcc;
	}
	gear[back] = protonPack;
	if (accordionBash.have_skill())
	{
		if (aeroAccordion.item_amount() > 0)
		{
			gear[weapon] = aeroAccordion;
			if (gear[offhand].to_slot() == weapon)
				gear[offhand] = noItem;
		}
		else
		{
			gear[weapon] = antiqueAccordion;
			gear[offhand] = noItem;
		}
	}
	WearOutfit(gear);
}
void ChooseDropsFamiliar(boolean isElemental)
{
	float[familiar] dropRates;
	int[familiar] itemDrops;
	if (cat.have_familiar())
	{
		int charges = get_property("_catBurglarCharge").to_int();
		int nextHeist = 10;
		while (charges >= nextHeist)
		{
			charges -= nextHeist; // charges doesn't get reset to 0, it just keeps incrementing
			nextHeist *= 2;
		}
		dropRates[cat] = 1.0 / (nextHeist - charges);
		itemDrops[cat] = catHeistValue; // value determined by user
	}
	if (sandworm.have_familiar())
	{
		switch (get_property("_aguaDrops").to_int())
		{
			case 0: dropRates[sandworm] = 0.20; break;
			case 1: dropRates[sandworm] = 0.15; break;
			case 2: dropRates[sandworm] = 0.10; break;
			case 3: dropRates[sandworm] = 0.05; break;
			case 4: dropRates[sandworm] = 0.05; break;
			default: dropRates[sandworm] = 0; break;
		}
		itemDrops[sandworm] = $item[agua de vida].historical_price();
	}
	if (fistTurkey.have_familiar() && get_property("_turkeyBooze").to_int() < 5)
	{
		switch (get_property("_turkeyBooze").to_int())
		{
			case 0: dropRates[fistTurkey] = 0.15; break;
			case 1: dropRates[fistTurkey] = 0.10; break;
			case 2: dropRates[fistTurkey] = 0.10; break;
			case 3: dropRates[fistTurkey] = 0.05; break;
			case 4: dropRates[fistTurkey] = 0.05; break;
			default: dropRates[fistTurkey] = 0; break;
		}
		itemDrops[fistTurkey] = turkey.historical_price();
	}
	if (xenomorph.have_familiar())
	{
		switch (get_property("_transponderDrops").to_int())
		{
			case 0: dropRates[xenomorph] = 0.25; break;
			case 1: dropRates[xenomorph] = 0.20; break;
			case 2: dropRates[xenomorph] = 0.15; break;
			case 3: dropRates[xenomorph] = 0.10; break;
			case 4: dropRates[xenomorph] = 0.05; break;
			default: dropRates[xenomorph] = 0; break;
		}
		itemDrops[xenomorph] = $item[transporter transponder].historical_price();
	}
	if (llama.have_familiar())
	{
		switch (get_property("_gongDrops").to_int())
		{
			case 0: dropRates[llama] = 0.20; break;
			case 1: dropRates[llama] = 0.15; break;
			case 2: dropRates[llama] = 0.10; break;
			case 3: dropRates[llama] = 0.05; break;
			case 4: dropRates[llama] = 0.05; break;
			default: dropRates[llama] = 0; break;
		}
		itemDrops[llama] = $item[llama lama gong].historical_price();
	}
	if (rogue.have_familiar())
	{
		switch (get_property("_tokenDrops").to_int())
		{
			case 0: dropRates[rogue] = 0.25; break;
			case 1: dropRates[rogue] = 0.20; break;
			case 2: dropRates[rogue] = 0.15; break;
			case 3: dropRates[rogue] = 0.10; break;
			case 4: dropRates[rogue] = 0.05; break;
			default: dropRates[rogue] = 0; break;
		}
		itemDrops[rogue] = $item[Game Grid token].historical_price();
	}
	if (badger.have_familiar())
	{
		switch (get_property("_astralDrops").to_int())
		{
			case 0: dropRates[badger] = 0.25; break;
			case 1: dropRates[badger] = 0.20; break;
			case 2: dropRates[badger] = 0.15; break;
			case 3: dropRates[badger] = 0.10; break;
			case 4: dropRates[badger] = 0.05; break;
			default: dropRates[badger] = 0; break;
		}
		itemDrops[badger] = $item[Astral Mushroom].historical_price();
	}
	if (greenPixie.have_familiar())
	{
		switch (get_property("_absintheDrops").to_int())
		{
			case 0: dropRates[greenPixie] = 0.20; break;
			case 1: dropRates[greenPixie] = 0.15; break;
			case 2: dropRates[greenPixie] = 0.10; break;
			case 3: dropRates[greenPixie] = 0.05; break;
			case 4: dropRates[greenPixie] = 0.05; break;
			default: dropRates[greenPixie] = 0; break;
		}
		itemDrops[greenPixie] = $item[tiny bottle of absinthe].historical_price();
	}
	if (isElemental && jellyfish.have_familiar())
	{
		switch (get_property("_spaceJellyfishDrops").to_int())
		{
			case 0: dropRates[jellyfish] = 1.00; break;
			case 1: dropRates[jellyfish] = 0.50; break;
			case 2: dropRates[jellyfish] = 0.33; break;
			case 3: dropRates[jellyfish] = 0.25; break;
			case 4: dropRates[jellyfish] = 0.20; break;
			default: dropRates[jellyfish] = 0.05; break;
		}
		if ($skill[Macrometeorite].have_skill() || powerGlove.HaveEquipment())
		{
			// jellyfish drops are easy to get all at once using macrometeorite, don't
			// waste real turns on jellyfish unless it's the last resort
			itemDrops[jellyfish] = 200;
		}
		else
			itemDrops[jellyfish] = $item[hot jelly].historical_price();
	}
	if (intergnat.have_familiar())
	{
		dropRates[intergnat] = 1;
		itemDrops[intergnat] = $item[BACON].historical_price();
	}
	if (xoskeleton.have_familiar())
	{
		dropRates[xoskeleton] = 1.0 / 11.0;
		itemDrops[xoskeleton] = ($item[X].historical_price() + $item[O].historical_price()) / 2;
	}
	if (robin.have_familiar())
	{
		dropRates[robin] = 1.0 / 30.0;
		itemDrops[robin] = $item[robin's egg].historical_price();
	}
	familiar best = $familiar[none];
	float bestValue = 0;
	foreach fam,rate in dropRates
	{
		float value = rate * itemDrops[fam];
		if (isDebug)
			print("Familiar " + fam + " has drop rate " + rate + " of value " + itemDrops[fam] + " for total value of " + value, printColor);
		if (value > bestValue)
		{
			best = fam;
			bestValue = value;
		}
	}
	if (best != $familiar[none])
	{
		SwitchToFamiliar(best);
		return;
	}
	if (robort.have_familiar())
	{
		SwitchToFamiliar(robort); // drops booze
		return;
	}
}
boolean EnsureOneSongSpace()
{
	int songSpace = 3;
	if ($skill[Mariachi Memory].have_skill())
		songSpace++;

	boolean[effect] songs = // boolean whether we should shrug the buff.  Stuff that's relevant to meat farming shouldn't be shrugged
	{
		$effect[The Moxious Madrigal]                   : true,
		$effect[The Magical Mojomuscular Melody]        : true,
		$effect[Cletus's Canticle of Celerity]          : true,
		$effect[Power Ballad of the Arrowsmith]         : true,
		$effect[Polka of Plenty]                        : false, // buffs meat drops
		$effect[Jackasses' Symphony of Destruction]     : true,
		$effect[Fat Leon's Phat Loot Lyric]             : false, // buffs item drops
		$effect[Brawnee's Anthem of Absorption]         : true,
		$effect[Psalm of Pointiness]                    : true,
		$effect[Stevedave's Shanty of Superiority]      : true,
		$effect[Aloysius' Antiphon of Aptitude]         : true,
		$effect[Ode to Booze]                           : true,
		$effect[The Sonata of Sneakiness]               : true,
		$effect[Carlweather's Cantata of Confrontation] : true,
		$effect[Ur-Kel's Aria of Annoyance]             : true,
		$effect[The Ballad of Richie Thingfinder]       : false, // buffs item and meat drops
		$effect[Benetton's Medley of Diversity]         : true,
		$effect[Elron's Explosive Etude]                : true,
		$effect[Chorale of Companionship]               : false, // buffs pet weight
		$effect[Prelude of Precision]                   : true,
		$effect[Donho's Bubbly Ballad]                  : true,
		$effect[Cringle's Curative Carol]               : true,
		$effect[Inigo's Incantation of Inspiration]     : true  
	};

	int activeSongs = songSpace;
	while (activeSongs >= songSpace)
	{
		activeSongs = 0;
		effect shrugBuff;
		string song;
		boolean canRemove;

		foreach song, canRemove in songs
		{
			if (song.have_effect() > 0)
			{
				activeSongs++;
				if (canRemove)
					shrugBuff = song;
			}
		}

		if (activeSongs >= songSpace && shrugBuff != $effect[none])
		{
			cli_execute("uneffect " + shrugBuff);
			activeSongs--;
		}
		else
			break;
	}
	return activeSongs < songSpace;
}
void BuffMonsterLevel()
{
	if (current_mcd() < 10)
		change_mcd(10);
	if (annoyanceEffect.have_effect() == 0 && annoyance.have_skill())
	{
		if (EnsureOneSongSpace())
		{
			use_skill(1, annoyance);
			if (annoyanceEffect.have_effect() > 0)
				return;
		}
	}
	if (annoyingNoiseEffect.have_effect() <= 0)
	{
		if (annoyingNoise.have_skill())
		{
			use_skill(1, annoyingNoise);
		}
	}
	BuyAndUseOneTotal(greekFire, greekFireEffect, 2000);
}
void ChooseThrall(boolean forMeat) //, boolean forItems)
{
	if (my_class().to_string() != "Pastamancer")
		return;
	thrall choice;
	skill toBind;
	int mpCost = 0;
	if (forMeat && lasagnaThrallSkill.have_skill())
	{
		choice = lasagnaThrall;
		toBind = lasagnaThrallSkill;
		mpCost = 200;
	}
	else if (spiceThrallSkill.have_skill())
	{
		choice = spiceThrall;
		toBind = spiceThrallSkill;
		mpCost = 250;
	}
	//else if (verminThrallSkill.have_skill())
	//{
	//	choice = verminThrall;
	//	toBind = verminThrallSkill;
	//	mpCost = 200;
	//}
	if (mpCost > 0) // have a legitimate skill
	{
		if (choice != my_thrall() // already have that thrall
			&& my_mp() > mpCost + 250) // make sure we have enough mana to switch, and then switch back
		{
			use_skill(1, toBind);
		}
	}
	if (hasFreeKillRemaining && (my_thrall() == lasagnaThrall || my_thrall() == vampireThrall))
	{
		// don't want lasagmbie to kill before we can get a free kill
		BuffMonsterLevel();
	}
}
boolean TryFightGhost()
{
	location loc = get_property("ghostLocation").to_location();
	if (loc == noLocation)
		return false;
	EquipGhostGear(loc);
	ChooseDropsFamiliar(true);
	ghostShot = 0;
	stunRound = 0;
	adv1(loc, -1, "Filter_TrapGhost");
	return true;
}
void PreparePirates()
{
}



void UseItem(item itm, effect resultingEffect, int requestedTurns, int turnsPerItem, int maxPrice) // turnsPerItem should be overestimated, not underestimated, if the expected count varies
{
	int buffsNeeded = requestedTurns - resultingEffect.have_effect();
	while (buffsNeeded > 0)
	{
		int useCount = (buffsNeeded + turnsPerItem - 1) / turnsPerItem; // round up to the nearest integer
		itm.TryGetFromCloset(useCount);
		if (maxPrice > 0)
		{
			int buyCount = useCount - itm.item_amount();
			if (buyCount > 0)
			{
				if (buyCount < 10) // buy in groups of 10 to reduce server hits
					buyCount = 10;
				BuyItemIfNeeded(itm, buyCount, maxPrice);
			}
		}
		if (useCount > itm.item_amount())
			useCount = itm.item_amount();
		if (useCount <= 0)
			break;
		int oldTurns = resultingEffect.have_effect();
		use(useCount, itm);
		int newTurns = resultingEffect.have_effect();
		if (oldTurns == newTurns) // prevent infinite loop in case it fails
		{
			print("Buff failed " + itm + " => " + resultingEffect, "red");
			break;
		}
		buffsNeeded = requestedTurns - resultingEffect.have_effect();
	}
}
void UseItem(item itm, effect resultingEffect, int requestedTurns, int turnsPerItem)
{
	UseItem(itm, resultingEffect, requestedTurns, turnsPerItem, 0); // price limit 0, don't ever buy on mall
}

int kgbManaBonus = 1; // 1 means hasn't been checked yet, should be 0 or -3

void TryReduceManaCost(skill forSkill)
{
	if (mysticality.my_basestat() >= 200
		&& HaveEquipment(oscusWeapon)
		&& HaveEquipment(oscusPants)
		&& HaveEquipment(oscusAccessory))
	{
		if (weapon.equipped_item().weapon_hands() > 1)
			weapon.equip(noItem);
		offhand.equip(oscusWeapon);
		pants.equip(oscusPants);
		acc1.equip(oscusAccessory);
	}
	if (HaveEquipment(kgb) && kgbManaBonus == 1)
	{
		string page = visit_url("desc_item.php?whichitem=311743898");
		if (page.contains_text("-3 MP to use Skills"))
			kgbManaBonus = -3;
		else
			kgbManaBonus = 0;
		print("kgb mana cost modifier = " + kgbManaBonus, printColor);
	}
	if (kgbManaBonus == -3)
	{
		acc2.equip(kgb);
	}
	else if (forSkill.mp_cost() > 2 && forSkill.mp_cost() < 12 // Too small, no effect. Too big, insignificant cost reduction
		&& rubberEffect.have_effect() <= 0
		&& rubber.item_amount() > 0)
	{
		use(1, rubber);
	}
	if (mysticality.my_basestat() >= 30
		&& HaveEquipment(brimstoneBracelet))
	{
		acc3.equip(brimstoneBracelet);
	}
}

void CastSkill(skill sk, int requestedTurns, boolean regenMP)
{
	effect resultingEffect = sk.to_effect();
	if (resultingEffect.have_effect() >= requestedTurns || !sk.have_skill())
		return;
	if (regenMP)
		TryReduceManaCost(sk);
	int keepMP = 20;
	while (resultingEffect.have_effect() < requestedTurns && sk.have_skill())
	{
		if (sk.mp_cost() > my_mp() - keepMP)
		{
			if (!regenMP && resultingEffect.have_effect() > 0)
			{
				print("Not extending " + sk + " because not enough MP", printColor);
				break;
			}
			if (regenMP)
			{
				if (FreeDailyManaRestore()) // this can change equipment, so need to swap back
					TryReduceManaCost(sk);
			}
			if (sk.mp_cost() > my_mp() - keepMP)
				restore_mp(sk.mp_cost() - (my_mp() - keepMP));
		}
		if (turns_per_cast(sk) <= 0) // divide by 0 otherwise
			return;
		int beforeTurns = resultingEffect.have_effect();
		int timesCast = (requestedTurns - resultingEffect.have_effect() + turns_per_cast(sk) - 1) / turns_per_cast(sk);
		if (timesCast <= 0)
		{
			break;
		}
		if (sk.mp_cost() * timesCast > my_mp() - keepMP)
		{
			timesCast = (my_mp() - keepMP) / sk.mp_cost();
		}
		if (timesCast <= 0) // sanity check, should not hit this unless we don't have enough mp
			timesCast = 1;
		use_skill(timesCast, sk);
		int afterTurns = resultingEffect.have_effect();
		if (beforeTurns == afterTurns)
		{
			print("Casting " + sk + " failed, skipping", printColor);
			break;
		}
	}
}
void AdventureEffect(string activator, effect resultingEffect, int requestedTurns)
{
	int haveTurns = resultingEffect.have_effect();
	while (haveTurns < requestedTurns)
	{
		if (cli_execute(activator))
		{
			int newTurns = resultingEffect.have_effect();
			if (newTurns == haveTurns)
				break;
			haveTurns = newTurns;
		}
		else
		{
			break;
		}
	}
}

boolean BuyCashews(int count, boolean preferCashews, int costLimitPerCashew)
{
	if (count <= 0)
		return true;
	int oldCashewCount = cashew.item_amount();
	while (count > 0 && cornucopia.item_amount() > 0)
	{
		use(1, cornucopia);
		if (cashew.item_amount() == oldCashewCount)
			break;
		count -= cashew.item_amount() - oldCashewCount;
		oldCashewCount = cashew.item_amount();
	}
	if (count <= 0)
		return true;
	if (thanksgettingFoodCostLimit < 0)
		return false;
	if (preferCashews)
	{
		if (buy(count, cashew, costLimitPerCashew) == count)
			return true;
	}
	while (count > 0)
	{
		if (buy(1, cornucopia, costLimitPerCashew * 3) < 1)
			return false;
		use(1, cornucopia);
		if (cashew.item_amount() == oldCashewCount)
			break;
		count -= cashew.item_amount() - oldCashewCount;
		oldCashewCount = cashew.item_amount();
	}
	return count <= 0;
}

item ChooseCheapest(item i1, item i2)
{
	if (i1.mall_price() < i2.mall_price())
		return i1;
	else
		return i2;
}
item ChooseCheapestThanksgetting()
{
	item bestThanks = ChooseCheapest(thanks1, thanks2);
	bestThanks = ChooseCheapest(bestThanks, thanks3);
	bestThanks = ChooseCheapest(bestThanks, thanks4);
	bestThanks = ChooseCheapest(bestThanks, thanks5);
	bestThanks = ChooseCheapest(bestThanks, thanks6);
	bestThanks = ChooseCheapest(bestThanks, thanks7);
	bestThanks = ChooseCheapest(bestThanks, thanks8);
	bestThanks = ChooseCheapest(bestThanks, thanks9);
	return bestThanks;
}

boolean AcquireFeast(item food, int cashewCost, boolean forWarbearOven)
{
	if (forWarbearOven && get_property("_warbearInductionOvenUsed") == "true")
		return false;

	food.TryGetFromCloset(1);
	if (food.item_amount() > 0 && !forWarbearOven)
		return true;

	item cashewIngredient = noItem;
	item foodIngredient = noItem;
	foreach ingr in food.get_ingredients()
	{
		if (ingr.fullness > 0)
			foodIngredient = ingr;
		else
			cashewIngredient = ingr;
	}
	if (cashewIngredient.to_int() < 0 || foodIngredient.to_int() < 0)
	{
		print("Invalid ingredients for " + food.to_string(), printColor);
	}
	cashewIngredient.TryGetFromCloset(1);
	foodIngredient.TryGetFromCloset(1);
	int priceLimit = thanksgettingFoodCostLimit;
	boolean preferCashews = false;
	if (priceLimit >= 0)
	{
		int cashewPrice = cashew.mall_price() * cashewCost + foodIngredient.mall_price();
		int cornucopiaPrice = cornucopia.mall_price() * cashewCost / 3; // assume average of 3 cashews per cornucopia
		if (forWarbearOven)
			priceLimit *= 2; // should get two of them back, not just one
		if (cashewPrice > priceLimit
			&& cornucopiaPrice > priceLimit)
		{
			print("Thanksgetting feast cost exceeds " + priceLimit + ", skipping", "red");
			return false;
		}
		int ingredientPrice = cashewIngredient.mall_price() + foodIngredient.mall_price();
		int finishedPrice = food.mall_price();
		if (finishedPrice <= ingredientPrice && finishedPrice <= cashewPrice)
		{
			// cheapest to buy finished product
			if (buy(1, food))
				return true;
		}
		if (foodIngredient.item_amount() < 1)
		{
			if (!buy(1, foodIngredient))
				return false;
		}
		preferCashews = cashewPrice < cornucopiaPrice;
	}
	if (cashewIngredient.item_amount() == 0)
	{
		if (!BuyCashews(cashewCost - cashew.item_amount(), preferCashews, priceLimit / cashewCost))
			return false;
		if (!cashewIngredient.seller.buy(1, cashewIngredient))
			return false;
	}
	int craftCount = craft("cook", 1, cashewIngredient, foodIngredient);
	if (craftCount > 0 && get_campground() contains oven)
		set_property("_warbearInductionOvenUsed", "true");
	return craftCount > 0;
}
boolean AcquireFeast(item food, int cashewCost)
{
	return AcquireFeast(food, cashewCost, false);
}

boolean TrySpleenSpace(int providedSpleen)
{
	while (!RoomToSpleen(providedSpleen))
	{
		if (get_property("currentMojoFilters").to_int() >= 3 || my_spleen_use() == 0)
			return false;

	   BuyItemIfNeeded(mojoFilter, 1, mojoCostLimit);
	   if (mojoFilter.item_amount() == 0)
		   return false;
	   use(1, mojoFilter);
	}
	return true;
}

void TrySpleen(item spleenItem, effect desiredEffect, int providedSpleen, int turnLimit)
{
	if (desiredEffect.have_effect() >= turnLimit)
		return;

	if (!TrySpleenSpace(providedSpleen))
	{
		print("Not enough spleen space remaining for " + spleenItem);
		return;
	}
	spleenItem.TryGetFromCloset(1);
	if (spleenItem.item_amount() == 0)
	{
		print("Cannot spleen with " + spleenItem + ", buy in mall if you want me to use it.", "red");
		return;
	}

	chew(1, spleenItem);
}

boolean ignoreOde = false;
void TryDrink(item booze, effect desiredEffect, int providedDrunk, int turnLimit)
{
	if (desiredEffect.have_effect() >= turnLimit)
		return;
	if (!RoomToDrink(providedDrunk))
		return;
	booze.TryGetFromCloset(1);
	if (booze.item_amount() < 1)
		return;

	if (odeToBoozeEffect.have_effect() < providedDrunk)
	{
		if (odeToBoozeEffect.have_effect() == 0
			&& !EnsureOneSongSpace())
		{
			if (HaveEquipment(songSpaceAcc) && songSpaceAcc.can_equip() && !songSpaceAcc.have_equipped())
			{
				// slots 1 and 2 are for MP cost reduction
				acc3.equip(songSpaceAcc);
			}
		}
		if (odeToBooze.have_skill())
			CastSkill(odeToBooze, providedDrunk, true);
		else
		{
			print("Requesting Ode to Booze buff from Buffy the buff bot", printColor);
			cli_execute("/msg buffy ode");
			for (int i = 0; i < 5; i++)
			{
				waitq(2);
				refresh_status();
				if (odeToBoozeEffect.have_effect() >= providedDrunk)
				{
					print("Got ode to booze from buffy, sending 2000 meat as thanks", printColor);
					cli_execute("csend 2000 meat to buffy");
					break;
				}
			}
			if (!ignoreOde
				&& odeToBoozeEffect.have_effect() < providedDrunk)
			{
				if (UserConfirmDefault("Could not get Ode to Booze, do you want to abort before drinking?", false))
					abort("Aborting before drink because no Ode to Booze");
				else
					ignoreOde = true;
			}
		}
	}
	if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
		put_closet(swizzler.item_amount(), swizzler);

	if (get_property("barrelShrineUnlocked") == "true"
		&& my_class().to_string() == "Accordion Thief"
		&& get_property("_barrelPrayer") != "true"
		&& RoomToDrink(10)) // if there's not enough liver left to benefit, wait for nightcap
	{
		cli_execute("barrelprayer buff"); // bonus adventures from drinking
	}
	if (HaveEquipment(pinkyRing) && !pinkyRing.have_equipped())
	{
		acc1.equip(pinkyRing);
	}
	
	drink(1, booze);
}



void ConsumeMayo(boolean convertToDrunk)
{
	if (!(get_campground() contains mayoClinic))
	{
		if (!eatWithoutMayo)
		{
			if (get_property("_workshedItemUsed") == "false"
				&& mayoClinic.item_amount() > 0)
			{
				if (AscensionScheduledToday())
				{
					// force a prompt, don't want to swap workshed without permissions
					if (user_confirm("Mayo clinic not installed, do you wish to install for eating?"))
					{
						BeforeSwapOutWorkshop(mayoClinic);
						use(1, mayoClinic);
					}
				}
				else if (UserConfirmDefault("Mayo clinic not installed, do you wish to install for eating?", true))
				{
					BeforeSwapOutWorkshop(mayoClinic);
					use(1, mayoClinic);
				}
			}
			if (!(get_campground() contains mayoClinic)
				&& !UserConfirmDefault("Mayo clinic is not in workshed, do you wish to eat without mayo?", true))
			{
				abort("Stopping without eating because no mayo clinic");
			}
			eatWithoutMayo = true;
		}
	}
	if (eatWithoutMayo && !(get_campground() contains mayoClinic))
		return;


	item mayo;
	if (convertToDrunk)
	{
		mayo = mayoFullToDrunk;
	}
	else
	{
		mayo = mayoIncreaseBuffs;
	}
	if (mayo.item_amount() <= 0)
	{
		cli_execute("buy 10 " + mayo.to_string());
	}
	if (mayo.item_amount() <= 0)
	{
		abort("No " + mayo.to_string() + " to eat with, please buy some manually.");
	}

	if (mayo.item_amount() > 0)
	{
		use(1, mayo);
	}

}
boolean TimeSpinnerEat(item i)
{
	string pageText = visit_url("inv_use.php?whichitem=9104");
	if (!pageText.contains_text("Travel back to a Delicious Meal"))
		return false;
	pageText = visit_url("choice.php?whichchoice=1195&option=2");
	if (!pageText.contains_text("Recall a delicious meal"))
		return false;
	pageText = visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1197&foodid=" + i.to_int(), true);
	return true;
}
boolean TryBonusEatThanksgetting(boolean unique)
{
	if (!RoomToEat(2))
		return true;
	// specifying number of turns of effect as basically infinite because we already did
	// an effect limit check before we got here, but didn't pass in the required number,
	// and this should buff exactly once
	int infTurns = 10000;
	// specify a 2 fullness remaining because we don't want to convert to drunk
	if (thanks1.item_amount() == 0 && thanks2.item_amount() == 0 && thanks3.item_amount() == 0)
	{
		item bestThanks = ChooseCheapestThanksgetting();
		if (!AcquireFeast(bestThanks, 1))
			return false;
	}
	if (RoomToEat(2)) { return TryEat(thanks1, thanksgetting, 2, 0, infTurns, unique); }
	if (RoomToEat(2)) { return TryEat(thanks2, thanksgetting, 2, 0, infTurns, unique); }
	if (RoomToEat(2)) { return TryEat(thanks3, thanksgetting, 2, 0, infTurns, unique); }
	return false;
}
boolean TryBonusSpinThanksgetting()
{
	if (timeSpinner.item_amount() < 0) // no time spinner
		return false;
	if (get_property("_timeSpinnerMinutesUsed") > 7) // no time left
		return false;
	ConsumeMayo(false);
	if (HaveEaten(thanks1) && TimeSpinnerEat(thanks1)) return true;
	if (HaveEaten(thanks2) && TimeSpinnerEat(thanks2)) return true;
	if (HaveEaten(thanks3) && TimeSpinnerEat(thanks3)) return true;
	if (HaveEaten(thanks4) && TimeSpinnerEat(thanks4)) return true;
	if (HaveEaten(thanks5) && TimeSpinnerEat(thanks5)) return true;
	if (HaveEaten(thanks6) && TimeSpinnerEat(thanks6)) return true;
	if (HaveEaten(thanks7) && TimeSpinnerEat(thanks7)) return true;
	if (HaveEaten(thanks8) && TimeSpinnerEat(thanks8)) return true;
	if (HaveEaten(thanks9) && TimeSpinnerEat(thanks9)) return true;
	return false;
}
boolean TryBonusThanksgetting()
{
	print("Attempting bonus eating, fullness at " + my_fullness() + " / " + fullness_limit(), printColor);
	if (!RoomToEat(2))
	{
		return false;
	}
	
	if (TryBonusEatThanksgetting(true)) // give first shot at eating un-eaten foods
		return true;
	if (TryBonusSpinThanksgetting()) // try re-eating something we already ate to increase duration
		return true;
	return TryBonusEatThanksgetting(false); // second chance if the time-spinner eating failed, for a non-unique food
}

boolean TryEat(item food, effect desiredEffect, int providedFullness, int followupFullness, int turnLimit, boolean eatUnique)
{
	if (desiredEffect.have_effect() >= turnLimit)
		return false;

	if (eatUnique && HaveEaten(food))
		return false;

	if (food.item_amount() <= 0)
		return false;

	if (!RoomToEat(providedFullness))
		return false;

	if (get_property("_milkOfMagnesiumUsed") != "true")
	{
		TryGetFromCloset(milk, 1);
		if (milk.item_amount() <= 0)
			BuyItemIfNeeded(milk, 10, 2000);
		if (milk.item_amount() > 0)
			use(1, milk);
	}

	boolean convertToDrunk = RoomToDrink(1) && !RoomToEat(providedFullness + followupFullness);
	ConsumeMayo(convertToDrunk);

	if (get_property("barrelShrineUnlocked") == "true"
		&& my_class().to_string() == "Turtle Tamer"
		&& get_property("_barrelPrayer") != "true")
	{
		cli_execute("barrelprayer buff"); // bonus adventures for eating
	}

	eat(1, food);
	return true;
}

int meatBuffCost;
item meatBuffCandy1, meatBuffCandy2;
void ChooseSweetMeat(int[item] candies1, int[item] candies2)
{
	item best1, best2;
	foreach candy1, count1 in candies1
	{
		if (count1 < 1)
			continue;
		if (candy1.historical_price() > meatBuffCost)
			continue;
		foreach candy2, count2 in candies2
		{
			if (count2 < 1)
				continue;
			if (candy1 == candy2 && count2 < 2)
				continue;
			int cost = candy1.historical_price() + candy2.historical_price();
			if (cost > meatBuffCost)
				continue;
			meatBuffCandy1 = candy1;
			meatBuffCandy2 = candy2;
			meatBuffCost = cost;
		}
	}
}

// convert strings to the corresponding item and count in inventory
int[item] ToItemAndCount(item[] items)
{
	int[item] result;
	foreach ix,i in items
	{
		int count = i.item_amount();
		if (autoPvpCloset || i == swizzler)
			count += i.closet_amount();
		result[i] = count;
	}
	return result;
}

item[] candy1Str = 
	{
		$item[bag of W&Ws], // trick or treat
		$item[Crimbo Candied Pecan], // summon crimbo candy
		$item[breath mint], // glass gnoll eye once a day
		$item[Now and Earlier],
		$item[abandoned candy],
		//$item[Wax Flask],
		$item[piece of after eight],
		$item[licorice root],
		$item[garbage-juice-flavored Hob-O],
		$item[Necbro wafers],
		$item[sugar shank],
	};
item[] candy2Str =
	{
		$item[box of Dweebs], // trick or treat
		$item[Crimbo Fudge], // summon crimbo candy
		$item[sugar-coated pine cone],
		$item[PlexiPips],
		$item[sugar shillelagh],
		$item[licorice boa],
		$item[double-ice gum],
		$item[fry-oil-flavored Hob-O],
		$item[Good 'n' Slimy],
		$item[black candy heart],
		$item[fruitfilm],
		$item[fudge spork],
		$item[peanut brittle shield],
		$item[irradiated candy cane],
		$item[bag of many confections],
	};
item[] candy3Str =
	{
		$item[Peez dispenser], // trick or treat
		$item[hoarded candy wad], // from buddy bjorn + orphan tot
		$item[Atomic Pop],
		$item[Pain Dip],
		$item[Gummi-DNA],
		$item[spooky sap],
		$item[nanite-infested candy cane],
		$item[sugar chapeau],
		$item[dubious peppermint],
		$item[sugar shirt],
		$item[strawberry-flavored Hob-O],
	};
item[] candy4Str =
	{
		milkStud, // trick or treat
		$item[frostbite-flavored Hob-O],
		$item[Nuclear Blastball],
		$item[ribbon candy],
		$item[children of the candy corn],
		$item[elderly jawbreaker],
	   
	};
item[] candy5Str =
	{
		swizzler,
		//$item[nasty gum], // does this drop from robortender?  Maybe I just bought a bunch on the market
		$item[Comet Drop],
		$item[sterno-flavored Hob-O],
		$item[Fudgie Roll],
	};

void SweetMeat(int requestedTurns)
{
	if (!sweetSynth.have_skill())
		return;

	if (synthGreed.have_effect() >= requestedTurns)
		return;

	print("Doing sweet synthesis for +300% meat", printColor);

	// Since this is used for farming, don't want to waste irreplacible candy (even if it's
	// temporarily cheaper).  Only use stuff which is relatively easy to replace.

	// pair 1: w&w/crimbo candied pecan/breath mint with itself
	int[item] candy1_1 = ToItemAndCount(candy1Str);

	// pair 2: dweebs or crimbo fudge with peez or hoarded candy wad
	int[item] candy2_1 = ToItemAndCount(candy2Str);
	int[item] candy2_2 = ToItemAndCount(candy3Str); 

	// pair 3: milk studs with swizzler
	int[item] candy3_1 = ToItemAndCount(candy4Str);
	int[item] candy3_2 = ToItemAndCount(candy5Str);
	

	while (synthGreed.have_effect() < requestedTurns && TrySpleenSpace(1))
	{
		print("Calculating candies...", printColor);
		meatBuffCandy1 = noItem;
		meatBuffCandy2 = noItem;
		meatBuffCost = 250 * 3 * 30; // has to be less than 22500 meat to be worth buffing
		ChooseSweetMeat(candy3_1, candy3_2);
		ChooseSweetMeat(candy2_1, candy2_2);
		ChooseSweetMeat(candy1_1, candy1_1);
		if (meatBuffCandy1 == noItem || meatBuffCandy2 == noItem)
		{
			print("Out of candy for sweet synthesis, skipping", printColor);
			break;
		}
		if (meatBuffCandy1 == meatBuffCandy2)
			meatBuffCandy1.TryGetFromCloset(2);
		else
		{
			meatBuffCandy1.TryGetFromCloset(1);
			meatBuffCandy2.TryGetFromCloset(1);
		}
		print("Sweet synthesis candies = " + meatBuffCandy1 + ", " + meatBuffCandy2, printColor);

		while (synthGreed.have_effect() < requestedTurns && TrySpleenSpace(1))
		{
			if (meatBuffCandy1.item_amount() == 0)
				break;
			if (meatBuffCandy2.item_amount() == 0)
				break;
			if (meatBuffCandy1 == meatBuffCandy2 && meatBuffCandy2.item_amount() < 2)
				break;
			sweet_synthesis(meatBuffCandy1, meatBuffCandy2);
			candy1_1[meatBuffCandy1]--;
			candy1_1[meatBuffCandy2]--;
			candy2_1[meatBuffCandy1]--;
			candy2_1[meatBuffCandy2]--;
			candy2_2[meatBuffCandy1]--;
			candy2_2[meatBuffCandy2]--;
			candy3_1[meatBuffCandy1]--;
			candy3_1[meatBuffCandy2]--;
			candy3_2[meatBuffCandy1]--;
			candy3_2[meatBuffCandy2]--;
		}
	}
	if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
		put_closet(swizzler.item_amount(), swizzler);
}

void GetPirateCostume()
{
	// do this first because it takes a turn, and we don't want to waste other buffs
	if (orphan.have_familiar())
	{
		location pirates = garbagePirates;
		for (int i = 0; i < 5; i++)
		{
			if (HaveEquipment(pirateCostume))
			{
				break;
			}
			PreparePirates();
			if (!pirates.adv1(0, "Filter_Standard"))
			{
				pirates = covePirates;
			}
		}
	}
}
void ValidateRobortender(item booze, string drinkList, string purpose)
{
	if (InList(booze.to_string(), drinkList, ","))
		return;
	if (booze.item_amount() > 0)
		return;
	if (autoPvpCloset && (booze.closet_amount() > 0 || booze.storage_amount() > 0))
		return;

	if (!UserConfirmDefault("Don't have Robotender booze " + booze.to_string() + " for " + purpose + ", do you wish to continue?", purpose != "meat"))
		abort("Cannot buff Robortender, no " + booze.to_string());
}
void FeedRobortender(item booze, string drinkList)
{
	if (!InList(booze.to_string(), drinkList, ","))
	{
		TryGetFromCloset(booze, 1);
		if (booze.item_amount() > 0)
			cli_execute("robo " + booze.name);
	}
}

item elfCopiedTo; // only copy once, after 2 drops, the drop rate quickly drops off
string Filter_Elvish(int round, monster mon, string page)
{
	if (elfCopiedTo == noItem)
	{
		if (needsSpookyPutty)
		{
			elfCopiedTo = usedSpookyPutty;
			return "item " + spookyPutty.to_string();
		}
		if (needsRainDoh)
		{
			elfCopiedTo = usedRainDoh;
			return "item " + rainDoh;
		}
		if (needsCamera)
		{
			elfCopiedTo = usedCamera;
			return "item " + camera.to_string();
		}
		elfCopiedTo = deck; // dumb placeholder, so it's not none
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill Sing Along";
	}
	if (mon == crayonElf) // don't waste free kills on Crayon Elf, it's already a free fight
	{
		if (cigar.item_amount() > 0)
			return "item " + cigar.to_string();
		else
		{
			print("No exploding cigar available, falling back on your character's combat filter.", printColor);
			return "";
		}
	}
	if (round < 4)
		return ChooseFreeKillMethodForFilter();
	abort("Unexpected failure of combat in elvish fight, please run manually");
	return "";
}
void CraftRobortenderDrink(item baseDrop, item firstTier, item secondTier, item firstMixer, item secondMixer)
{
	boolean haveStill = get_campground() contains $item[warbear high-efficiency still];
	if (haveStill || secondTier.item_amount() == 0) // only craft it if we're out, or a warbear still is installed
	{
		int craftAmount;
		if (haveStill)
			craftAmount = baseDrop.item_amount();
		else if (firstTier.item_amount() > 0)
			craftAmount = 0;
		else
			craftAmount = 1;

		if (craftAmount > 0)
		{
			if (firstMixer.item_amount() < craftAmount)
				buy(craftAmount + 5, firstMixer);
			craft("cocktail", 1, baseDrop, firstMixer);
		}

		if (haveStill)
			craftAmount = firstTier.item_amount();
		else
			craftAmount = 1;

		if (craftAmount > 0)
		{
			if (secondMixer.item_amount() < craftAmount)
				buy(craftAmount + 5, secondMixer);
			craft("cocktail", 1, firstTier, secondMixer);
		}
	}
}
void TryElvishRobortender()
{
	// each peppermint sprig is worth like 40k+, so definitely worth the use of 2 free kills and a copy to grab 2

	monster chateauMon = get_property("chateauMonster").to_monster();
	boolean chateauElf = chateauMon.phylum.to_string() == "elf";
	if (chateauElf)
	{
		if (get_property("_chateauMonsterFought") != "false")
			return;
	}
	else if (deck.item_amount() == 0
		|| get_property("_deckCardsDrawn").to_int() > 0)
	{
		return;
	}
	TryOpenRainDoh();
	print("Prepping to fight elf as Robortender", printColor);
	if (chateauMon != crayonElf && HaveEquipment(jokesterGun))
	{
		item[slot] jokeOutfit = CopyOutfit(dropsOutfitPieces);
		jokeOutfit[weapon] = jokesterGun;
		WearOutfit(jokeOutfit);
		if (!jokesterGun.have_equipped())
		{
			print("Failure to equip jokester's gun", printColor);
		}
	}
	PrepareFilterState();
	if (chateauMon == crayonElf)
	{
		if (cigar.item_amount() < 2)
		{
			// hmm, what other preparation should be made here?
		}
	}
	else if (!hasFreeKillRemaining)
	{
		print("No free kills remain, skipping first peppermint sprig", printColor);
		return;
	}

	if (chateauElf)
	{
		print("Using Chateau painting " + chateauMon, printColor);
		visit_url("place.php?whichplace=chateau&action=chateau_painting");
		RunCombat("Filter_Elvish");
	}
	else
	{
		print("Using deck of every card for elf", printColor);
		string page = visit_url("inv_use.php?cheat=1&pwd=" + my_hash() + "&whichitem=8382");
		if (page.contains_text("Christmas Card"))
		{
			page = visit_url("choice.php?whichchoice=1086&option=1&pwd=" + my_hash() + "&which=28"); // chrismas card
			if (!page.contains_text("Also, what's Christmas?"))
				abort("Debug: deck should have let me draw a christmas card");
			visit_url("choice.php?whichchoice=1085&pwd=" + my_hash() + "&option=1"); // start the fight
			RunCombat("Filter_Elvish");
		}
	}
	if (elfCopiedTo != noItem && elfCopiedTo != deck)
	{
		print("Activating copy of elf for a second robortender drop", printColor);
		PrepareFilterState();
		ActivateCopyItem(elfCopiedTo, "Filter_Elvish");
	}
	CraftRobortenderDrink(peppermintSprig, mentholatedWine, roboCandy, boxedWine, orange);
}
void FeedRobotender()
{
	if (!robort.have_familiar())
		return;

	string drinkList = get_property("_roboDrinks");
	if (InList(roboMeat.to_string(), drinkList, ",")) // already fed robortender, don't check again
		return;

	ValidateRobortender(roboMeat, drinkList, "meat");
	ValidateRobortender(roboItems, drinkList, "item");
	ValidateRobortender(roboMana, drinkList, "mana");
	ValidateRobortender(roboHobo, drinkList, "hobo");
	ValidateRobortender(roboCandy, drinkList, "candy");
	if (get_property("_roboDrinks") == "")
	{
		SwitchToFamiliar(robort);
		FeedRobortender(roboMeat, drinkList);
		CraftRobortenderDrink(anis, doubleEntendre, roboItems, tequila, lemon);
		FeedRobortender(roboItems, drinkList);
		FeedRobortender(roboMana, drinkList);
		FeedRobortender(roboHobo, drinkList);
		CraftRobortenderDrink(peppermintSprig, mentholatedWine, roboCandy, boxedWine, orange);
		if (roboCandy.item_amount() == 0)
			TryElvishRobortender();
		FeedRobortender(roboCandy, drinkList);
	}
	TryElvishRobortender(); // if it didn't happen because of a lack of feliz navidad, do it now
}
void DriveObservantly(int turns, boolean promptForActivate)
{
	if (observantly.have_effect() >= turns)
		return;
	   
	if (!(get_campground() contains asdonMartin))
	{
		if (!promptForActivate)
			return;
		if (get_property("_workshedItemUsed") != "false")
			return;
		if (asdonMartin.item_amount() == 0)
			return;
		string confirmText = "Fullness at " + my_fullness() + " / " + fullness_limit() + ", do you wish to switch to Asdon Martin for buffing?";
		if (AscensionScheduledToday())
		{
			if (user_confirm(confirmText))
			{
				BeforeSwapOutWorkshop(asdonMartin);
				use(1, asdonMartin);
			}
		}
		else if (UserConfirmDefault(confirmText, my_fullness() >= fullness_limit()))
		{
			BeforeSwapOutWorkshop(asdonMartin);
			use(1, asdonMartin);
		}
	}
	if (!(get_campground() contains asdonMartin))
		return;

	int effectTurns = observantly.have_effect();
	while (effectTurns < turns)
	{
		FuelAsdon(37);
		print("Trying to drive observantly, fuel = " + get_fuel().to_string() + ", existing turns = " + observantly.have_effect(), printColor);
		cli_execute("asdonmartin drive observantly");
		//visit_url("campground.php?pwd="+my_hash()+"&preaction=drive&whichdrive=7");  // apparently this works even while already driving

		if (effectTurns == observantly.have_effect()) // number of effect turns should have increased
		{
			print("drive observantly failed to buff", "red");
			waitq(10); // wait 10 seconds for user to see
			return;
		}
		effectTurns = observantly.have_effect();
	}
}
static int kgbClickLimit = 21;
void KGBBuff(int turns, effect kgbBuff, string keyword)
{
	int effectTurns = kgbBuff.have_effect();
	while (effectTurns < turns)
	{
		if (get_property("_kgbClicksUsed").to_int() > kgbClickLimit) // not enough clicks left, skipping
			return;
		cli_execute("Briefcase b " + keyword);
		if (effectTurns == kgbBuff.have_effect())
		{
			print("KGB buff failed, is Ezandora's briefcase script installed?  Are you out of clicks for the day?", "red");
			waitq(10); // wait 10 seconds for user to see
			return;
		}
		effectTurns = kgbBuff.have_effect();
	}
}
void KGBBuff(int turns)
{
	if (!HaveEquipment(kgb))
		return;
	if (get_property("_kgbClicksUsed").to_int() > kgbClickLimit) // not enough clicks left, skipping
		return;
	// code to control briefcase is too complex, we depend on Ezandora's briefcase script
	cli_execute("Briefcase martinis"); // make sure to get martinis first
	KGBBuff(turns, kgbMeat, "meat");
	KGBBuff(turns, kgbItems, "item"); // any leftover clicks after done buffing +meat go to +item
}
void RentAHorse()
{
	if (get_property("horseryAvailable") != "true")
		return;
	if (get_property("_horsery") != "")
		return;
	if (LoadChoiceAdventure("place.php?whichplace=town_right&action=town_horsery", "A Horsery", true))
	{
		run_choice(3); // Rent a Crazy horse
	}
}

boolean AcquireFullFeast()
{
	horseradish.TryGetFromCloset(8);
	cli_execute("acquire 8 jumping horseradish");
	UseWarbearOven();
	boolean success = true;
	success = AcquireFeast(thanks1, 1) && success;
	success = AcquireFeast(thanks2, 1) && success;
	success = AcquireFeast(thanks3, 1) && success;
	success = AcquireFeast(thanks4, 2) && success;
	success = AcquireFeast(thanks5, 2) && success;
	success = AcquireFeast(thanks6, 2) && success;
	success = AcquireFeast(thanks7, 3) && success;
	success = AcquireFeast(thanks8, 3) && success;
	success = AcquireFeast(thanks9, 3) && success;
	return success;
}
void AcquirePrintScreen()
{
	if (get_property("_internetPrintScreenButtonBought") == "false"
		&& BACON.item_amount() >= 111)
	{
	   cli_execute("coinmaster buy bacon " + printScreen.to_string());
	}
}
void CastEducate(boolean doDuplicate, boolean doDigitize, boolean doTurbo, boolean doExtract)
{
	canExtract = doExtract;
	canTurbo = doTurbo;
	canDuplicate = doDuplicate;
	string educate1 = get_property("sourceTerminalEducate1");
	string educate2 = get_property("sourceTerminalEducate2");
	boolean hasDuplicate = educate1 == "duplicate.edu" || educate2 == "duplicate.edu";
	boolean hasDigitize = educate1 == "digitize.edu" || educate2 == "digitize.edu";
	boolean hasTurbo = educate1 == "turbo.edu" || educate2 == "turbo.edu";
	boolean hasExtract = educate1 == "extract.edu" || educate2 == "extract.edu";
	
	int incorrectCount = 0;
	if (doDuplicate && !hasDuplicate) incorrectCount++;
	if (doDigitize && !hasDigitize) incorrectCount++;
	if (doTurbo && !hasTurbo) incorrectCount++;
	if (doExtract && !hasExtract) incorrectCount++;
	if (incorrectCount == 0)
		return;

	if (doDuplicate) cli_execute("terminal educate duplicate.edu");
	if (doDigitize)  cli_execute("terminal educate digitize.edu");
	if (doTurbo)     cli_execute("terminal educate turbo.edu");
	if (doExtract)   cli_execute("terminal educate extract.edu");
	
}
void ChooseEducate(boolean doduplicate, boolean dodigitize)
{
	string known = get_property("sourceTerminalEducateKnown");
	if (known == "")
		return;

	doduplicate = doduplicate
		&& (get_property("_sourceTerminalDuplicateUses") == "0")
		&& known.contains_text("duplicate.edu");

	dodigitize = dodigitize
		&& get_property("_sourceTerminalDigitizeUses").to_int() < 3
		&& known.contains_text("digitize.edu");

	boolean doturbo = (!doduplicate || !dodigitize)
		&& known.contains_text("turbo.edu")
		&& overheated.have_effect() == 0
		&& (my_mp() + 1000) < (my_maxmp() / 2); // this will reduce by 50% afterwards, so don't use it unless we'll have capacity to keep the mana after

	if (summonCurrent.have_skill()) // don't want to spoil max mana if summon resolution hasn't been cast yet
		doturbo &= summonCurrent.mp_cost() < (my_maxmp() / 2) && summonCurrent.mp_cost() > 1000;

	boolean doextract = (!doduplicate && !dodigitize) || (!doduplicate && !doturbo) || (!dodigitize && !doturbo);
	CastEducate(doduplicate, dodigitize, doturbo, doextract);
}

void TryDistentionForThanksgetting(int turns)
{
	if (CanDistention()
		&& thanksgetting.have_effect() < turns // only if more turns of the effect were requested
		&& my_fullness() == fullness_limit() - 1) // in case we're at 14/15
	{
		use(1, distention);
	}
}
void TryBuffForFreeCombats(boolean nightBefore)
{
	int freeCombats = CountFreeCombatsAvailable(false);
	if (nightBefore)
		freeCombats += CountFreeCombatsAvailable(true);
	print("Free combats = " + freeCombats);
	float expectedMeatPerAdventure = 100.0;
	// modifier no longer matters much, since there's a 1000 limit
	float meatmodifier = 1 + (meat_drop_modifier() / 100.0);
	if (meatModifier > 10)
		meatModifier = 10;
	expectedMeatPerAdventure *= meatmodifier;
	float expectedMeat = freeCombats * expectedMeatPerAdventure - EstimateFreeFightCost(false);
	if (nightBefore)
		expectedMeat -= EstimateFreeFightCost(true);
	print("Expected meat from free combats = " + expectedMeat, printColor);
	if (expectedMeat > 55000) // will buy wishes up to 55000 meat
	{
		print("Buffing specifically for free combats, expect payback of approximately "
			+ freeCombats * expectedMeatPerAdventure, printColor);

		WishForEffect(covetous); // this effect makes the lowest base meat drop = 100

		// This is apparently disallowed...unfortunately
		// WishForEffect(attunement);
	}
}
void TryLimitedAccordionBuff(skill limitedSkill, effect limitedEffect, string castProperty, int turns)
{
	if (!EnsureOneSongSpace())
		return;

	if (my_class().to_string() == "Accordion Thief"
		&& limitedSkill.have_skill()
		&& get_property(castProperty).to_int() < 10)
	{
		CastSkill(limitedSkill, turns, true);
	}
}

boolean needWeightBuffs = true;
 
void BuffInRun(int turns, boolean restoreMP)
{
	if (polkad.have_effect() > 0 || EnsureOneSongSpace())
	{
		CastSkill(polka, turns, restoreMP);
	}
	CastSkill(leer, turns, restoreMP);
	if (needWeightBuffs)
	{
		CastSkill(leash, turns, restoreMP);
		CastSkill(empathy, turns, restoreMP);
		if (bloodBond.have_skill())
		{
			if (bloodBondEffect.have_effect() < 3 && my_hp() > 100) // special case, uses HP instead of MP
				use_skill(1, bloodBond);
			CastSkill(antibiotic, turns, restoreMP);
		}
	}
	if (phatLooted.have_effect() > 0 ||  EnsureOneSongSpace())
	{
		CastSkill(phatLoot, turns, restoreMP);
	}
	if (my_class() == $class[Accordion Thief] && my_level() >= 15)
	{
		if (get_property("_companionshipCasts").to_int() < 10 && companionship.have_skill())
		{
			if (companionshipEffect.have_effect() > 0 || EnsureOneSongSpace())
			{
				CastSkill(companionship, turns, restoreMP);
			}
		}
		if (get_property("_thingfinderCasts").to_int() < 10 && thingfinder.have_skill())
		{
			if (thingfinderEffect.have_effect() > 0 || EnsureOneSongSpace())
			{
				CastSkill(thingfinder, turns, restoreMP);
			}
		}
	}
}

void AcquireAmuletCoin()
{
	if (cornbeefadon.have_familiar() && !HaveEquipment(pokeEqpMeat))
	{
		if (familiarJacks.item_amount() == 0)
		{
			if (clipArt.have_skill() && get_property("_clipartSummons").to_int() < 3)
			{
				print("Summoning kitten/kitten/kitten for familiar jacks", printColor);
				visit_url("campground.php?pwd=" + my_hash() + "&action=bookshelf&preaction=combinecliparts&clip1=03&clip2=03&clip3=03");
			}
			else
			{
				buy(1, familiarJacks, 15000);
			}
		}
		if (familiarJacks.item_amount() == 0)
		{
			print("Could not acquire familiar jacks for cornbeefadon", printColor);
			return;
		}
		SwitchToFamiliar(cornbeefadon);
		use(1, familiarJacks);
	}
}

void BuffTurns(int turns)
{
	needWeightBuffs = true;
// special case, if we're buffing in preparation for the next day, don't do all the thanksgarden eating and such, just buff for minimum number of turns
// so we can copy some embezzlers before sleep and have buffs ready to go the next day
	boolean nightBefore = turns < 0;
	boolean expensiveBuffs =
		nightBefore
		&& allowExpensiveBuffs
		&& (PuttyCopiesRemaining() >= 5);

	if (bittyMeat.item_amount() > 0 && get_property("_bittycar") != "meatcar")
		use(1, bittyMeat);

	AcquirePrintScreen();
	if (RoomToEat(2))
		AcquireFullFeast();

	if (get_property("getawayCampsiteUnlocked") == "true")
	{
		for (int i = 0; i < 4; i++)
			if (get_property("_campAwaySmileBuffs").to_int() < 3)
				visit_url("place.php?whichplace=campaway&action=campaway_sky");
	}

	if (runFamiliar == orphan)
	{
		needWeightBuffs = false;
		GetPirateCostume();
	}
	else if (runFamiliar == noFamiliar)
	{
		needWeightBuffs = false;
	}
	else if (runFamiliar == robort)
	{
		if (!nightBefore)
			FeedRobotender();
	}
	DoVoting();
	ActivateMumming();
	if (turns > 100 && runFamiliar != orphan)
		AcquireAmuletCoin();

	if (get_property("demonSummoned") != "true" && get_property("demonName2") != "")
	{
		if (BuyItemIfNeeded($item[tattered scrap of paper], 1, 6000)
			&& BuyItemIfNeeded($item[disintegrating quill pen], 1, 1000)
			&& BuyItemIfNeeded($item[inkwell], 1, 1000))
		{
			cli_execute(summonGreed);
		}
	}
	if (get_property("concertVisited") != "true")
	{
		if (get_property("sidequestArenaCompleted") == "fratboy")
			cli_execute(concertWinklered);
		else if (get_property("sidequestArenaCompleted") == "hippy")
			cli_execute(concertOptimistPrimal);
	}

	if (nightBefore)
	{
		turns = 1;
		SweetMeat(1);
		if (expensiveBuffs)
		{
			UseOneTotal(micks, sinuses);
			UseOneTotal(peppermint, peppermintEffect);
			UseOneTotal(sugar, sugarEffect);
			UseOneTotal(cranberryCordial, cranberryCordialEffect);
			UseOneTotal(polkaPop, polkaPopEffect);
			if (needWeightBuffs)
			{
				UseOneTotal(kinder, kinderEffect);
				TrySpleen(joy, joyEffect, 1, 1);
			}
			if (egg1.item_amount() > 0)
			{
				TrySpleen(egg1, eggEffect, 1, 1);
			}
			TryBuffForFreeCombats(true);
			//if (covetous.have_effect() > 0 && CopiedMeatyAvailable() && PuttyCopiesRemaining() > 4)
			//{
			//    // The test for this isn't a very accurate calculation, but it should get us in the
			//    // ballpark of whether these wishes are worthwhile or not.
			//    // 50k/wish > 2 days * 10 embezzlers/day * 1000 meat/embezzler * 200% multiplier,
			//    // but with free fights giving meat, it can beat break-even over 2 days, and come
			//    // out ahead when accounting for 20 turns of barf monsters (and more with buff extenders)

			//    // 2 +200% meat effects:
			//    WishForEffect(frosty);
			//    WishForEffect(braaaaaains);
			//}
		}
	}

	if (birdCalendar.item_amount() > 0)
	{
		if (favoriteBird.have_skill()
			&& get_property("_favoriteBirdVisited") == "false"
			&& get_property("yourFavoriteBirdMods").contains_text("Meat Drop"))
		{
			use_skill(1, favoriteBird);
		}
		if (get_property("_birdOfTheDayMods").contains_text("Meat Drop") && seekBirdEffect.have_effect() > 0)
		{
		}
		else if (!seekBird.have_skill())
		{
			birdCalendar.use(1);
		}
		if (get_property("_birdOfTheDayMods").contains_text("Meat Drop"))
		{
			while (seekBird.mp_cost() < 200 // stop when it gets to 320, but checking against 200 to be safe
				&& seekBird.mp_cost() <= my_mp()
				&& seekBirdEffect.have_effect() < turns)
			{
				seekBird.use_skill(1);
			}
		}
	}

	// want to maximize our chances of increasing the limited/expensive effects, rather than the cheaper ones
	if (bagOtricks.item_amount() > 0 && get_property("_bagOTricksUsed") == "false")
	{
		use(1, bagOtricks);
	}
	if (!get_property("_defectiveTokenUsed").to_boolean()
		&& gameToken.item_amount() > 0)
	{
		use(1, gameToken);
	}
	if (dnaLab.item_amount() > 0 || get_campground() contains dnaLab)
	{
		BeforeSwapOutDNALab();
		UseItem(geneConstellation, geneConstellationEffect, 20, 30, 0);
		if (needWeightBuffs)
			UseItem(geneFish, geneFishEffect, 10, 30, 0);
	}
	UseOneTotal(pinkHeart, pinkHeartEffect);
	if (summonTaffy.have_skill() && needWeightBuffs)
	{
		UseItem(blueTaffy, blueTaffyEffect, 50, 10, 0);
	}
	DriveObservantly(turns, false); // false = only buff if the Asdon Martin is installed
	//UseItem(nasalSpray, nasalSprayEffect, turns, 10, 150);
	if (summonRes.have_skill())
		UseItem(wealthy, resolve, turns, 20);
	else
		UseItem(wealthy, resolve, 1, 20, 1000);

	TrySpleen(cologne, cologneEffect, 1, 10);

	if (mayflower.item_amount() > 0 && begpwnia.item_amount() > 0)
		UseOneTotal(begpwnia, begpwniaEffect);
	UseItem(avoidScams, avoidScamsEffect, turns, 20, 500);
	CastSkill(leer, quietJudgement.have_skill() ? 1 : turns, true);
	CastSkill(polka, 10, true);
	RentAHorse();

	if (needWeightBuffs)
	{
		CastSkill(leash, 10, true);
		CastSkill(empathy, 10, true);
		if (bloodBond.have_skill())
		{
			if (bloodBondEffect.have_effect() < 3 && my_hp() > 100) // special case, uses HP instead of MP
				use_skill(1, bloodBond);
		}
		TrySpleen(joy, joyEffect, 1, 1);

		if (vipKey.item_amount() > 0 && get_clan_lounge() contains poolTable)
		{
			while (get_property("_poolGames").to_int() < 3 && poolEffect.have_effect() < turns)
			{
				cli_execute("pool aggressive");
			}
		}

		if ((get_campground() contains witchess)
			 && !get_property("_witchessBuff").to_boolean())
		{
			cli_execute("witchess");
		}
		ActivateChibiBuddy();
		if (comb.item_amount() > 0)
		{
			visit_url("main.php"); // convince game we're not stuck in choice encounter
			cli_execute("beach head familiar");
		}
	}
	ActivateFortuneTeller();

	if (get_property("_sourceTerminalEnhanceUses").to_int() < 3)
		AdventureEffect(meatEnh, meatEnhanced, turns);

	if (get_property("_madTeaParty") != "true")
		AdventureEffect(hatterDreadSack, danceTweedle, 1);

	if (OutfitContains(defaultOutfit, halfPurse))
	{
		UseItem(flaskfull, merrySmith, turns, 150, 1000);
	}

	if (!get_property("_glennGoldenDiceUsed").to_boolean()
		&& dice.item_amount() > 0)
	{
		use(1, dice);
	}
	if (selfEsteem.have_skill()
		&& get_property("_incredibleSelfEsteemCast") == "false"
		&& (alwaysCollecting.have_effect() > 0
		|| workForHours.have_effect() > 0))
	{
		use_skill(1, selfEsteem);
	}
	if (turns >= 50 
		&& get_property("barrelShrineUnlocked") == "true"
		&& my_class().to_string() == "Pastamancer"
		&& get_property("_barrelPrayer") != "true")
	{
		cli_execute("barrelprayer buff"); // +90% item drop
	}

	SweetMeat(turns);
	KGBBuff(turns);

	if (executeBeforeEat != "")
	{
		cli_execute(executeBeforeEat);
	}

	UseWarbearOven();
	if (nightBefore)
	{
		TryEat(horseradish, kickedInSinuses, 1, 0, turns, false);
		TryEat(foodCone, foodConeEffect, 2, 0, turns, false);
		if (RoomToEat(2))
		{
			item bestThanks = ChooseCheapestThanksgetting();
			TryEat(bestThanks, thanksgetting, 2, 0, turns, false);
		}
		if (expensiveBuffs || fistTurkey.have_familiar())
		{
			TryDrink(turkey, turkeyEffect, 1, turns);
		}
	}
	else
	{
		// always 18 turns of thanksgetting to account for, eat as many horseradish as necessary first,
		// but they should get converted to drunk unless it's feast of Boris
		for (int remaining = 30; remaining >= 18; remaining--)
		{
			if (horseradish.item_amount() < 1)
			{
				horseradish.TryGetFromCloset(1);
				cli_execute("acquire 1 jumping horseradish");
			}
			TryEat(horseradish, kickedInSinuses, 1, remaining, turns, false);
		}
		TryEat(thanks1, thanksgetting, 2, 16, turns, true);

		// if we don't have pantsgiving, use the distention pill early so we can mayo more intelligently
		if (CanDistention() && !HaveEquipment(pantsGiving))
		{
			use(1, distention);
		}
		TryEat(thanks2, thanksgetting, 2, 14, turns, true);
		TryEat(thanks3, thanksgetting, 2, 12, turns, true);
		TryEat(thanks4, thanksgetting, 2, 10, turns, true);
		TryEat(thanks5, thanksgetting, 2, 8, turns, true);
		TryEat(thanks6, thanksgetting, 2, 6, turns, true);
		TryEat(thanks7, thanksgetting, 2, 4, turns, true);
		TryEat(thanks8, thanksgetting, 2, 2, turns, true);
		TryDistentionForThanksgetting(turns);
		TryEat(thanks9, thanksgetting, 2, 0, turns, true);
		while (thanksgetting.have_effect() < turns && RoomToEat(2))
		{
			// try re-eating something we already ate to increase duration
			if (TryBonusSpinThanksgetting())
				continue;
			item bestThanks = ChooseCheapestThanksgetting();
			if (!AcquireFeast(bestThanks, 1))
				break;
			if (!TryBonusEatThanksgetting(false))
				break;
		}
		TryBonusThanksgetting();
		if (CanDistention() // only worth doing a pantsgiving fullness run if we can get a second fullness point from distention pill
			&& thanksgetting.have_effect() < turns // only if more turns of the effect were requested
			&& my_fullness() == fullness_limit()) // pants can't activate without being completely full
		{
			TryBuffForFreeCombats(false);
			TryActivatePantsgivingFullness(); // open up 1 more fullness
		}
		while (thanksgetting.have_effect() < turns)
		{
			TryDistentionForThanksgetting(turns);
			if (!TryBonusThanksgetting())
				break;
		}

	}
	if (executeAfterEat != "")
	{
		cli_execute(executeAfterEat);
	}
	TryDrink(dirt, dirtEffect, 1, 1);
	TryDrink(gingerWine, gingerWineEffect, 2, 1);
	if (hauntedLiver.have_effect() == 0 && get_property("voteAlways") == "true")
	{
		if (hauntedScrewdriver.item_amount() == 0 && ectoplasm.item_amount() >= 2)
		{
			if (hauntedOrange.item_amount() == 0)
			{
				if (orange.item_amount() > 0)
					buy(1, orange);
				craft("cook", 1, orange, ectoplasm);
			}
			if (hauntedVodka.item_amount() == 0)
			{
				if (vodka.item_amount() > 0)
					buy(1, vodka);
				craft("cocktail", 1, vodka, ectoplasm);
			}
			craft("cocktail", 1, hauntedVodka, hauntedOrange);
		}
		TryDrink(hauntedScrewdriver, hauntedLiver, 2, 1);
	}
	if (!nightBefore)
	{
		if (fistTurkey.have_familiar())
		{
			int turkeyturns = turns > 25 * turkeyLimit ? 25 * turkeyLimit : turns; // limit to 5 turkeys a day, since that's all that can drop per day
			for (int i = 0; i < turkeyLimit; i++)
				TryDrink(turkey, turkeyEffect, 1, turkeyturns);
		}
		for (int i = 0; i < sacramentoLimit; i++) // drink sacramento wine for +item buff
			TryDrink(sacramento, sacramentoEffect, 1, turns);

		while (RoomToDrink(1)
			&& (my_adventures() < turns || beerPolka.have_effect() >= 5)
			&& elementalCaip.item_amount() > 0)
		{
			TryDrink(elementalCaip, $effect[none], 1, 1000000);
		}
	}

	// don't finish with accordion buffs until after we've drunk, because we might need to shrug Ode to fit the song in our head
	TryLimitedAccordionBuff(thingfinder, thingfinderEffect, "_thingfinderCasts", turns < 0 ? 500 : turns);
	TryLimitedAccordionBuff(companionship, companionshipEffect, "_companionshipCasts", turns < 0 ? 500 : turns);

	if (EnsureOneSongSpace())
	{
		CastSkill(phatLoot, 10, true);
	}

	DriveObservantly(turns, true); // true == request to install the Asdon Martin
	TryBuffForFreeCombats(false);
	MaxManaSummons();
	TryReduceManaCost(leer);
	BuffInRun(turns, false);

	MakeMeltingGear(defaultOutfitPieces);
	MakeMeltingGear(meatyOutfitPieces);
	MakeMeltingGear(dropsOutfitPieces);
	MakeMeltingGear(weightOutfitPieces);

	//if (needWeightBuffs)
	//{
	//    // this reduces all stats, so use after MaxManaSummons
	//    UseItem(petBuff, petBuffEffect, turns, 10, 250);
	//}
}


string Filter_Runaway(int round, monster mon, string page)
{
	if (IsFreeCombat(mon))
		return Filter_FreeCombat(round, mon, page);
	if (needsCleesh)
	{
		needsCleesh = false;
		return "skill Cleesh";
	}
	if (needsSmokeBomb)
	{
		needsSmokeBomb = false;
		return "item " + smokebomb.to_string() + ", none";
	}
	return "run away";
}
void PrepareSmokeBomb()
{
	if (GetFamiliarRunaways() > 0)
	{
		needsSmokeBomb = false;
		return;
	}
	if (smokebomb.item_amount() == 0 && fishermansack.item_amount() > 0)
	{
		use(1, fishermansack); // convert to fish-oil smoke bomb X3
	}
	needsSmokeBomb = true;
}
string ReadyRunaway()
{
	if (stompingBoots.have_familiar())
	{
		SwitchToFamiliar(stompingBoots);
	}
	else if (bandersnatch.have_familiar())
	{
		SwitchToFamiliar(bandersnatch);
		CastSkill(odeToBooze, 1, true); // only need 1 turn of it
	}
	if (GetFreeRunaways() > 0)
	{
		PrepareSmokeBomb();
		return "Filter_Runaway";
	}
	else
		return "Filter_Standard";
}


  
boolean IsPurpleLightAvailable()
{
	if (!hobopolisWhitelist.contains_text(get_clan_name()))
		return false;
	
	matcher imgNum = create_matcher("purplelightdistrict(\\d+)\\.gif", visit_url("clan_hobopolis.php?place=8"));
	return imgNum.find() && imgNum.group(1).to_int() < 10;
}


boolean HaveGingerbreadBest()
{
	if (!HaveEquipment(gingerHead)) return false;
	if (!HaveEquipment(gingerShirt)) return false;
	if (!HaveEquipment(gingerPants)) return false;
	if (!HaveEquipment(gingerAcc1)) return false;
	if (!HaveEquipment(gingerAcc2)) return false;
	if (!HaveEquipment(gingerAcc3)) return false;
	return true;
}
void WearGingerbreadBest()
{
	outfit("Gingerbread Best");
	//head.equip(gingerHead);
	//shirt.equip(gingerShirt);
	//pants.equip(gingerPants);
	//acc1.equip(gingerAcc1);
	//acc2.equip(gingerAcc2);
	//acc3.equip(gingerAcc3);
}

boolean CheesyRunaway(item i, slot s, familiar f, item[slot] o, boolean realCheese)
{
	if (realCheese && get_property("_stinkyCheeseCount").to_int() >= 100)
		return false;
	if (o[s] == i)
		return true;
	if (!i.HaveEquipment() || !i.can_equip())
		return false;
	int oldRunaways = GetFamiliarRunaways(f, o);
	item old = o[s];
	o[s] = i;

	int newRunaways = GetFamiliarRunaways(f, o);
	if (newRunaways < oldRunaways && newRunaways < 0)
	{
		print("Not enough runaways with " + i + " equipped, swapping back", printColor);
		o[s] = old;
	}
	print("CheesyRunaway: Setting slot " + s + " to " + o[s]);
	return o[s] == i;
}

void CheesyRunaway(familiar f, item[slot] o)
{
	// getting doctor bag quest takes precedence over incrementing counters
	if (get_property("doctorBagQuestLocation") == "" && doctorBag.HaveEquipment() && !OutfitContains(o, doctorBag))
	{
		foreach ix,sl in slot[] { acc1, acc2, acc3 }
		{
			if (CheesyRunaway(doctorBag, sl, f, o, false))
				break;
		}
	}
	// having these cheesy items equipped during runaways counts towards combats for the day
	if (!CheesyRunaway(cheeseStaff, weapon, f, o, true))
		CheesyRunaway(cheeseSword, weapon, f, o, true);
	if (!CheesyRunaway(pantsgiving, pants, f, o, false))
		CheesyRunaway(cheesePants, pants, f, o, true);
	if (!CheesyRunaway(cheeseShield, offhand, f, o, true))
		CheesyRunaway(kramco, offhand, f, o, false);
	if (!OutfitContains(o, cheeseAccessory))
	{
		foreach ix,sl in slot[] { acc1, acc2, acc3 }
		{
			if (o[sl] != doctorBag)
				if (CheesyRunaway(cheeseAccessory, sl, f, o, true))
					break;
		}
	}
}

void BjornCrownWeightFamiliar()
{
	boolean bjornEq = bjorn.have_equipped();
	boolean crownEq = crown.have_equipped();
	if (!bjornEq && !crownEq)
		return;
	familiar curFamiliar;
	if (bjornEq)
		curFamiliar = my_bjorned_familiar();
	else
		curFamiliar = my_enthroned_familiar();

	foreach ix,f in weightFamiliars
	{
		if (curFamiliar == f)
			return;
	}
	foreach ix,f in weightFamiliars
	{
		if (f.have_familiar())
		{
			if (bjornEq)
				f.bjornify_familiar();
			else
				f.enthrone_familiar();
			return;
		}
	}
}

boolean TryReplaceWeightSlot(item[slot] o, item replacement, slot s, float weight)
{
	if (o.OutfitContains(replacement))
		return true;
	float oldWeight = s.equipped_item().numeric_modifier("familiar weight");
	if (weight > oldWeight)
	{
		o[s] = replacement;
		return true;
	}
	return false;
}

// don't want the full maximizer, just replace equipment based on familiar
item[slot] MaximizeWeight(familiar f)
{
	item[slot] result;
	result = CopyOutfit(weightOutfitPieces);
	if (bjorn.HaveEquipment())
	{
		result[back] = bjorn;
		if (result[head] == crown)
			result[head] = $item[none];
	}
	foreach i in $items[]
	{
		slot s = i.to_slot();
		if (s == $slot[none] || s == famEqp)
			continue;
		if (!i.can_equip() || !i.HaveEquipment())
			continue;
		float modifier = i.numeric_modifier("familiar weight");
		if (modifier == 0)
			continue;
		switch (i)
		{
			case $item[hewn moon-rune spoon]: // messes with text, breaks tracking
			case $item[furry halo]: // only unarmed
				// don't use these items
				continue;
			case $item[warbear foil hat]:
				if (my_class() == $class[Turtle Tamer])
				{
					modifier = 5;
					// list of robots is actually much bigger, do we care about any other familiars?
					//  https://kol.coldfront.net/thekolwiki/index.php/Category:Robotic_Familiars
					if (f == robort || f == npzr)
						modifier = 15;
				}
				break;
			case $item[Crown of Thrones]: // can't use with Buddy Bjorn
				if (bjorn.HaveEquipment())
					continue;
				modifier = 5; // in case there's not a weight familiar enthroned
				break;
			case $item[Buddy Bjorn]:
				modifier = 5; // in case there's not a weight familiar bjorned
				break;
		}
		if (s == acc1 || s == acc2 || s == acc3)
		{
			if (!TryReplaceWeightSlot(result, i, acc1, modifier))
				if (!TryReplaceWeightSlot(result, i, acc2, modifier))
					TryReplaceWeightSlot(result, i, acc3, modifier);
		}
		else
			TryReplaceWeightSlot(result, i, s, modifier);
	}
	result[famEqp] = ChooseFamiliarEquipmentForWeight(f);
	return result;
}

boolean TryPrepareFamiliarRunaways()
{
	familiar f;
	if (stompingBoots.have_familiar())
		f = stompingBoots;
	else if (bandersnatch.have_familiar())
		f = bandersnatch;
	else
		return false;
	item[slot] weightOF = MaximizeWeight(f);
	int runaways = GetFamiliarRunaways(f, weightOF);
	if (FeastingAvailable(f))
		runaways += 2;

	if (runaways <= 0)
		return false;
	if (runaways > 1)
		CheesyRunaway(f, weightOF);
	f.use_familiar();
	if (f == bandersnatch)
	{
		CastSkill(odeToBooze, 1, true); // only need 1 turn of it
		if (odeToBoozeEffect.have_effect() == 0)
			return false;
	}
	WearOutfit(weightOF);
	BjornCrownWeightFamiliar();
	runaways = GetFamiliarRunaways();
	if (runaways > 0)
		return true;

	if (runaways > -2)
		TryUseMovableFeast();
	return GetFamiliarRunaways() > 0;
}

int GingerbreadTurns()
{
	int turns = get_property("_gingerbreadCityTurns").to_int();
	if (get_property("_gingerbreadClockAdvanced") == "true")
		turns += 5;
	print("Gingerbread turns = " + turns);
	return turns;
}
int GingerbreadVirtualTurns()
{
	int turns = get_property("_gingerbreadCityTurns").to_int();
	if (get_property("gingerAdvanceClockUnlocked") == "true")
	{
		turns += 6;
	}
	return turns;
}
boolean CanGingerbreadCandy(int runsAvail)
{
	return GingerbreadTurns() <= 9
		&& GingerbreadVirtualTurns() + runsAvail >= 9;
}
boolean CanGingerbreadParty(int runsAvail)
{
	return GingerbreadTurns() <= 19
		&& GingerbreadVirtualTurns() + runsAvail >= 19;
}

void RunawayGingerbread()
{
	visit_url("place.php?whichplace=gingerbreadcity");
	if (get_property("gingerbreadCityAvailable") != "true" // not accessible
		|| GingerbreadTurns() > 20) // already ran turns
	{
		return;
	}
	familiar f = my_familiar();
	if (stompingBoots.have_familiar())
		f = stompingBoots;
	else if (bandersnatch.have_familiar())
		f = bandersnatch;
	int runs = GetFreeRunaways(f, weightOutfitPieces);
	iF (!CanGingerbreadCandy(runs) && !CanGingerbreadParty(runs))
		return;
	if (!UserConfirmDefault("Do you want to auto-clear gingerbread today for candy and chocolate sculpture/ginger wine using free runaway familiar?", true))
	{
		return;
	}
	string page;
	if (get_property("gingerAdvanceClockUnlocked") == "true"
		&& get_property("_gingerbreadClockAdvanced") != "true")
	{
		page = LoadChoiceAdventure(gingerCivic, false); // civic center
		run_choice(1); // clock choice
	}
	TryPrepareFamiliarRunaways();
	string filter = ReadyRunaway();
	if (filter != "Filter_Runaway")
		return;
	runs = GetFreeRunaways();
	while (CanGingerbreadCandy(runs))
	{
		if (GingerbreadTurns() == 9)
			break;
		TryPrepareFamiliarRunaways();
		PrepareSmokeBomb();
		if (GetFreeRunaways() < 1)
		{
			print("Out of free runaways, " + (9 - GingerbreadVirtualTurns()) + " adventures left until train candy.", "red");
			return;
		}
		gingerTrain.adv1(-1, filter);
		runs--;
	}
	if (GingerbreadTurns() == 9)
	{
		page = LoadChoiceAdventure(gingerTrain, false);
		run_choice(1); // dig for candy
		if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
			put_closet(swizzler.item_amount(), swizzler);
	}

	if (!HaveGingerbreadBest())
		return;
	runs = GetFreeRunaways(f, weightOutfitPieces);
	while (CanGingerbreadParty(runs))
	{
		if (GingerbreadTurns() == 19)
			break;
		TryPrepareFamiliarRunaways();
		PrepareSmokeBomb();
		gingerRetail.adv1(-1, filter);
	}
	if (GingerbreadTurns() == 19)
	{
		WearGingerbreadBest();
		page = LoadChoiceAdventure(gingerRetail, false);
		run_choice(2); // enter party
		if (gingerSprinkles.item_amount() >= 300)
			run_choice(2); // buy chocolate sculpture
		else
		{
			print("Out of sprinkles, taking a drink instead of chocolate sculpture.", printColor);
			run_choice(1); // take a free drink
		}
	}
}



void RunawayDinseyBurnDelay()
{
	boolean first = true;
	while (TryPrepareFamiliarRunaways())
	{
		location zone = ChooseRunawayZone();
		if (zone == noLocation)
			return;
		if (first)
		{
			first = false;
			if (!UserConfirmDefault("Use free runaways to burn delay in Dinsey zones to unlock keycards?", true))
				return;
		}
		string filter = ReadyRunaway();
		if (filter != "Filter_Runaway")
			return;
		print("Burning delay in " + zone, printColor);
//waitq(3);
		RemoveConfusionEffects(false);
		HealUp(true);
		string page = visit_url(zone.to_url().to_string());
		while (ChooseSkipNoncombat(page))
		{
			page = visit_url(zone.to_url().to_string());
		}
		run_combat(filter);
		if (tempBlind.have_effect() > 0 && (my_familiar() == bandersnatch || my_familiar() == stompingBoots))
		{
			// experimental, this needs to be incremented because Mafia can't track it if you get blinded
			set_property("_banderRunaways", (get_property("_banderRunaways").to_int() + 1).to_string());
		}

//waitq(3);
	}
}

boolean RunawayDoctorBagQuest()
{
	if (WandererScheduled() != "")
		return false;
	location zone = GetDoctorBagQuestLocation();
	if (zone == $location[none])
		return false;
	if (!AllNoncombatsSkippable(zone))
		return false;
	print("Try to burn delay on doctor bag quest", printColor);
	if (!TryPrepareFamiliarRunaways())
		return false;
	string filter = "Filter_Runaway";
	RemoveConfusionEffects(false);
	HealUp(true);
	string page = visit_url(zone.to_url().to_string());
	while (ChooseSkipNoncombat(page))
	{
		page = visit_url(zone.to_url().to_string());
	}
	RunCombat(filter);
	return true;
}

void RunawayMadnessBakery()
{
	boolean first = true;

	while (strawberry.item_amount() > 0
		&& dough.item_amount() > 0
		&& icing.item_amount() > 0
		&& (popPart.item_amount() > 0 || get_property("popularTartUnlocked") == "true")
		&& TryPrepareFamiliarRunaways())
	{
		if (RunawayDoctorBagQuest()) // this is higher priority than madness bakery
			continue;
		if (first)
		{
			first = false;
			if (!UserConfirmDefault("Use free runaways to make popular tarts?", true))
				return;
		}
		string filter = ReadyRunaway();
		if (filter != "Filter_Runaway")
			return;
		print("Visiting Madness Bakery with free runaways", printColor);
		string page = visit_url("adventure.php?snarfblat=440");
		if (page.contains_text("choice.php"))
		{
			run_choice(3); // popular machine
			run_choice(1); // make popular tart
		}
		else
			run_combat(filter);
	}
}
string Filter_MojoFarm(int round, monster mon, string page)
{
	if (IsFreeCombat(mon))
	{
		return Filter_FreeCombat(round, mon, page);
	}
	if (mon == $monster[swarm of scarab beatles])
	{
		if (canMissileLauncher)
		{
			canMissileLauncher = false;
			return "skill " + missileLauncher.to_string();
		}
		if (!usedForce && canUseForce)
		{
			usedForce = visit_url("fight.php?action=skill&whichskill=7311").contains_text("You will drop your things and walk away.");
			//return "skill Use the Force, " + my_name() + "!";
		}
		if (usedForce)
		{
			visit_url("choice.php?whichchoice=1387&option=3"); // "You will drop your things and walk away."
			// this code is really old, does it actually need this part anymore:
			visit_url("fight.php"); // make KoLMafia recognize that we're no longer in a fight
			return "";
		}
		return ChooseFreeKillMethodForFilter();
	}
	return ChooseBanish();
}

void FarmMojoFilters()
{
print("FarmMojoFilters.Enter " + ultrahydrated.have_effect(), printColor);
//waitq(10);
	if (ultrahydrated.have_effect() == 0)
		return;

	PrepareFilterState(false);
print("Jokester = " + canJokesterGun);
print("Xray = " + canXray);
print("batoom = " + canBatoomerang);
print("missile = " + canMissileLauncher);
print("punch = " + canShatteringPunch);
print("mob = " + canMobHit);
//abort("Stop here");
	boolean freeKills = hasFreeKillRemaining;
	boolean needSquint = (squint.have_skill() && get_property("_steelyEyedSquintUsed") == "false");
	boolean doubleDrops = needSquint || squintEffect.have_effect() > 0
		|| (garbageTote.item_amount() > 0 && get_property("garbageChampagneCharge").to_int() > 0);
print("Can use force = " + canUseForce, printColor);
//waitq(5);
	if (!canUseForce && !(freeKills && doubleDrops))
	{
		print("No force uses and no free kills, skipping", printColor);
		return;
	}

	if (!UserConfirmDefault("Use free kills and saber charges to farm mojo filters?", true))
		return;

	if (canUseForce)
	{
		if (hipster.have_familiar())
			SwitchToFamiliar(hipster);
		else if (goth.have_familiar())
			SwitchToFamiliar(goth);
		item[slot] forceOutfit = GetModifiableOutfit(true);
		forceOutfit[weapon] = cosplaySaber;
		if (doctorBag.HaveEquipment())
			forceOutfit[acc3] = doctorBag;
		if (kgb.HaveEquipment())
			forceOutfit[acc2] = kgb; // for dart banish
		WearOutfit(forceOutfit);
		PrepareFilterState(true);
	}
	while (canUseForce || canMissileLauncher)
	{
		print("Using the force or missile launcher for mojo filter", printColor);
//waitq(5);
		string page = visit_url(oasis.to_url());
		if (TryHandleNonCombat(page))
			continue;
		RunCombat("Filter_MojoFarm");

		PrepareFilterState(true);
	}
	if (freeKills)
	{
		if (needSquint && squintEffect.have_effect() == 0)
		{
			CastSkill(squint, 1, true);
		}
		PrepareFilterState(false);
	}
	while (freeKills)
	{
//waitq(5);
		item[slot] fkOutfit = GetModifiableOutfit(true);
		boolean chamCharges = false;
		if (garbageTote.item_amount() > 0)
		{
			if (get_property("garbageChampagneCharge").to_int() > 0 || get_property("_garbageItemChanged") == "false")
				chamCharges = true;
			if (chamCharges && champagne.item_amount() == 0 && !champagne.have_equipped())
			{
				cli_execute("fold broken champagne bottle");
				chamCharges = get_property("garbageChampagneCharge").to_int() > 0;
			}
			fkOutfit[weapon] = champagne;
		}
		if (!chamCharges && squintEffect.have_effect() == 0)
		{
			print("Out of champagne bottle/squint turns", printColor);
			break;
		}
		if (doctorBag.HaveEquipment())
			fkOutfit[acc3] = doctorBag;
		if (kgb.HaveEquipment())
			fkOutfit[acc2] = kgb; // for dart banish
		if (canJokesterGun && hand.have_familiar())
		{
			fkOutfit[famEqp] = jokesterGun;
			PrepareFreeCombat(fkOutfit, hand);
		}
		else
		{
			ChooseDropsFamiliar(false);
			PrepareFreeCombat(fkOutfit, my_familiar());
		}
		if (legendaryBeat.item_amount() > 0
			&& legendaryBeatEffect.have_effect() == 0
			&& get_property("_legendaryBeat") == "false")
		{
			use(1, legendaryBeat);
		}

		float dropRate = (1.0 + item_drop_modifier() / 100.0) * 0.05;
	
		print("Using free kill for mojo filter, item modifier = " + item_drop_modifier()
			+ ", expected drop rate = " + dropRate, printColor);
		if (dropRate > 0.6 && dropRate < 1 && fairCoin.item_amount() > 0 && fairCoinEffect.have_effect() == 0)
		{
			print("Drop rate needs perfectly fair coin to guarantee mojo filter drop", printColor);
//waitq(5);
			use(1, fairCoin);
		}
//waitq(5);
		PrepareFilterState(true);
		string page = visit_url(oasis.to_url());
		if (TryHandleNonCombat(page))
			continue;
		RunCombat("Filter_MojoFarm");

		PrepareFilterState(false);
		freeKills = hasFreeKillRemaining;
	}
}


void SemiRareCastle()
{
	TryPrepareFamiliarRunaways();
	string filter = ReadyRunaway(); // should be a non-combat, so runaway if it's not
	//castleTopFloor.adv1(-1, filter);
	string page = visit_url("adventure.php?snarfblat=324"); // castle top floor
	if (ChooseSkipNoncombat(page))
		return;
	RunCombat(filter);
}
void SemiRareBilliard()
{
	TryPrepareFamiliarRunaways();
	string filter = ReadyRunaway(); // should be a non-combat, so runaway if it's not
	string page = visit_url("adventure.php?snarfblat=391"); // spookyraven billiard room

	if (page.contains_text("Get the heck out of here")) // in case of lights out
	{
		run_choice(2); // get the heck out of here
		page = visit_url("adventure.php?snarfblat=391"); // try again
	}
	if (page.contains_text("choice.php"))
	{
		run_choice(1); // rack 'em up
	}
	else
		RunCombat(filter);
}
void SemiRarePurpleLight()
{
	TryPrepareFamiliarRunaways();
	needsCleesh = cleesh.have_skill();
	string filter = ReadyRunaway(); // should be a non-combat, so runaway if it's not
	//purpleLight.adv1(-1, filter);
	string page = visit_url("adventure.php?snarfblat=172"); // purple light district
	if (page.contains_text("choice.php"))
		run_choice(1);
	else
		RunCombat(filter);
}
void SemiRareEmbezzler()
{
	PrepareMeaty();
	//treasury.adv1(-1, "Filter_Standard");
	visit_url("adventure.php?snarfblat=260"); // treasury
	RunCombat("Filter_Standard");
}
void BypassCounterError()
{
	// This is just an invalid URL to trigger the semi-rare warning so we can get past it, without crashing this
	// script, so it won't actually take a turn unless it happens to trigger a counter script:
	boolean ignore = cli_execute("try; visit_url adventure.php?snarfblat=99999999");
}

void RunSemiRare()
{
	semiRareAttempted = my_turnCount();

	BypassCounterError();

	if (semiRareAttempted != my_turnCount()) // make sure we're still on the same turn in case a counter script got triggered
		return;


	string lastLocation = get_property("semirareLocation");
	if (lastLocation != castleTopFloor.to_string())
	{
		SemiRareCastle();
	}
	else if (billiardKey.item_amount() > 0 && get_property("poolSharkCount").to_int() < 25)
	{
		SemiRareBilliard();
	}
	else if (IsPurpleLightAvailable() && nickel.item_amount() >= 5)
	{
		SemiRarePurpleLight();
	}
	else
	{
		SemiRareEmbezzler();
	}
}


void TryPrepareFax(monster mon)
{
	if (usedFax.item_amount() > 0) // must use existing copy before requesting a new one
		return;
	boolean chatWasOpen = false;
	try
	{
		// this code pattern came from VMF, but there wasn't anything about a way to close chat afterwords if it wasn't
		// already open
		// chatWasOpen = ???
		cli_execute("chat"); // apparently chat has to be open to receive a fax
		waitq(5); // 5 seconds for chat to open
		if (faxbot(meatyMonster))
		{
			if (usedFax.item_amount() > 0)
			{
				print("Got fax of " + get_property("photocopyMonster"), printColor);
				return;
			}
		}
		print("Fax failed for " + mon, printColor);
	}
	finally
	{
		// todo: shut chat if it wasn't already open
		// if (!chatWasOpen)
		//	 cli_execute(close chat ???);
	}
}

void TryActivateDigitize()
{
	if (digitizeActivationNeeded)
	{
		digitizeActivationNeeded = false;
		// visit "An Overgrown shrine", shouldn't take an adventure, but will activate
		// the digitize counter immediately (which combat through items won't do):
		string page = visit_url("adventure.php?snarfblat=349");
		if (page.contains_text("choice.php"))
			run_choice(6); // Back off
		else
			RunCombat("Filter_Standard");
	}
}

boolean TryForceSemirare()
{
	if (fortuneCookieCounter < my_turnCount() && get_property("_freePillKeeperUsed") == "false" && pillKeeper.HaveEquipment())
	{
		cli_execute("pillkeeper semirare");
		PrepareFilterState();
		print("Fortune cookie counter = " + fortuneCookieCounter + ", on turn " + my_turnCount());
	}
	return fortuneCookieCounter == my_turnCount();
}

boolean RunCopiedMeaty()
{
	TryActivateDigitize();
	PrepareMeaty();

	// any copying item that we're using up should be set to "need to use" to
	// replenish the copy

	if (MeatyFaxable())
	{
		TryPrepareFax(meatyMonster);
		if (IsMeatyMonster(get_property("photocopyMonster").to_monster()))
		{
			return ActivateCopyItem(usedFax);
		}
		else
		{
			print("Fax failed for " + meatyMonster);
		}
	}
	if (MeatyPuttied())
	{
		print("using spooky putty " + meatyMonster, printColor);
		needsSpookyPutty = get_property("spookyPuttyCopiesMade").to_int() < 5;
		return ActivateCopyItem(usedSpookyPutty);
	}
	else if (MeatyRainDohed())
	{
		print("using rain doh " + meatyMonster, printColor);
		needsRainDoh = true;
		return ActivateCopyItem(usedRainDoh);
	}
	else if (MeatyPrintScreened())
	{
		print("using print screen " + meatyMonster, printColor);

		set_property("_printscreensUsedToday", (get_property("_printscreensUsedToday").to_int() + 1).to_string()); // to avoid using all the print screens in one day
		needsPrintScreen = true;
		return ActivateCopyItem(usedPrintScreen);
	}
	else if (MeatyCameraed())
	{
		print("using camera " + meatyMonster, printColor);
		needsCamera = true;
		return ActivateCopyItem(usedcamera);
	}
	else if (MeatyChateaud())
	{
		print("using Chateau painting " + meatyMonster, printColor);
		visit_url("place.php?whichplace=chateau&action=chateau_painting");
		RunCombat("Filter_Standard");
		return true;
	}
	else if (PuttyCopiesRemaining() >= 4
		|| (get_property("_sourceTerminalDigitizeUses").to_int() == 0
		&& get_property("sourceTerminalEducateKnown").contains_text("digitize.edu")))
	{
		print("Digitize or putty/black box available, checking if we can generate a new embezzler for copying", printColor);
		if (meatyMonster == embezzler && TryForceSemirare())
		{
			print("Forcing semi-rare in treasury to generate an embezzler", printColor);
			string page = visit_url(treasury.to_url()); // first visit to skip the semi-rare warning
			if (isDebug)
			{
				print("visited treasury url, resulting page:");
				print("=============================", "orange");
				print(page, "green");
				print("=============================", "orange");
			}


			page = visit_url(treasury.to_url());
			if (isDebug)
			{
				print("visited treasury url, resulting page:");
				print("=============================", "orange");
				print(page, "green");
				print("=============================", "orange");
			}
			RunCombat("Filter_Standard");
			return true;
		}
		if (get_property("_genieFightsUsed").to_int() < 3)
		{
			// A wish is worth more than a single embezzler, but if we're copying a bunch,
			// it's worth a wish.
			print("Wishing for " + meatyMonster, printColor);
			WishFor("to fight a " + meatyMonster);
			visit_url("fight.php");
			RunCombat("Filter_Standard");
			return true;
		}
	}
	print("no " + meatyMonster + " found", printColor);
	return false;
}

boolean universesLeft = true;
boolean TryCalculateUniverse()
{
	if (!universesLeft || my_mp() < 1)
		return false;
	static int moonSignInt = -1;
	if (moonSignInt < 0)
	{
		switch (my_sign()) // cache this value, it won't change while script is running
		{
			case "Mongoose": moonSignInt = 1; break;
			case "Wallaby": moonSignInt = 2; break;
			case "Vole": moonSignInt = 3; break;
			case "Platypus": moonSignInt = 4; break;
			case "Opossum": moonSignInt = 5; break;
			case "Marmot": moonSignInt = 6; break;
			case "Wombat": moonSignInt = 7; break;
			case "Blender": moonSignInt = 8; break;
			case "Packrat": moonSignInt = 9; break;
			case "Bad Moon": moonSignInt = 10; break;
			default: moonSignInt = 0; break;
		}
	}
	universesLeft = get_property("_universeCalculated").to_int() < get_property("skillLevel144").to_int();
	if (!universesLeft)
		return false;
	int desiredNumber;
	if (hippy_stone_broken() && preferCalcUniversePvP)
		desiredNumber = 37;
	else
		desiredNumber = 69;

	int multiplier = my_spleen_use() + my_level();
	int sum = (moonSignInt + my_ascensions()) * multiplier + my_adventures();
	// solve for x: ( x * multiplier = desiredNumber - sum ) modulo 100

	int targetNum = (desiredNumber - sum + 100000000) % 100; // try to make sure it's positive before remainder
	for (int i = 0; i < 100; i++)
	{
		if ((i * multiplier) % 100 == targetNum)
		{
			print("Calculate the universe " + i, printColor);
			cli_execute("numberology " + desiredNumber);
			return true;
		}
	}
	print("Numberology not available this turn", printColor);
	return false;
}

void ActivateChibiBuddy()
{
	print("chibi: Off = " + chibiOff.item_amount() + ", on =" + chibiOn.item_amount(), printColor);
	if (chibiOff.item_amount() > 0 && chibiOn.item_amount() == 0)
	{
		//use(1, chibiOff);
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=5925");
		string page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=633&option=1&chibiname=ChibiBuffMaker");
		if (chibiOn.item_amount() == 0)
		{
			print("Chibibuddy activation failed", printColor);
			print(page);
		}
	}
	if (chibiOn.item_amount() > 0 && chibiEffect.have_effect() == 0)
	{
		string page = visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=5908");
		PushChoiceAdventureButton(page, "Have a ChibiChat");
	}
}
void ActivateFortuneTeller()
{
	// todo: this can probably be simplified later once Mafia has full support

	if (vipKey.item_amount() <= 0)
		return;

	string page = visit_url("clan_viplounge.php?preaction=lovetester");
	if (!page.contains_text("Pick a Testee"))
	{
		page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1278&option=2"); // Nevermind
		return;
	}
	page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1278&option=1&which=-3&q1=Pizza&q2=MadameZatara&q3=Hello");
}

boolean needsLube = false;
// Don't like polluting settings file with script-specific stuff, but a daily setting should disappear tomorrow, right?
boolean lubeChecked = get_property("_linknoidbarfCheckedQuest") == "true";

void CheckLubeQuest()
{
	if (lubeChecked)
		return;

	lubeChecked = true;
	if (get_property("_dinseyGarbageDisposed") != "true")
	{
		bagOfGarbage.TryGetFromCloset(1);
		if (LoadChoiceAdventure(maintenanceUrl, "Maint Misbehavin'", false))
		{
			run_choice(6); // Waste Disposal
		}
	}

	// is there a better way to check this setting?  End up re-checking each time the script runs

	string page = visit_url("questlog.php?which=7");
	if (page.contains_text("rollercoaster in order to lubricate the tracks"))
	{
		needsLube = true;
	}
	set_property("_linknoidbarfCheckedQuest", "true");
	if (needsLube)
		return;
	page = visit_url(kioskUrl);
	int choice = FindVariableChoice(page, "Track Maintenance", false);
	if (choice > 0)
	{
		print("Taking quest Track Maintenance option " + choice.to_string());
		run_choice(choice);
		needsLube = true;
	}
}

boolean boomedBox = false;
void CheckBoomBoxSong()
{
	if (boomedBox || boomBox.item_amount() == 0 || get_property("_boomBoxSongsLeft").to_int() < 2)
		return;
	if (get_property("boomBoxSong") == "Total Eclipse of Your Meat")
		return;
	boomedBox = true;
	if (!UserConfirmDefault("Do you wish to switch your BoomBox song to \"Total Eclipse of Your Meat\"?", true))
		return;
	visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9919");
	run_choice(5); // Total Eclipse of Your Meat
}

boolean TryRunKramco()
{
	if (!KramcoScheduled())
		return false;
	location zone = ChooseWandererZone();
	if (zone == noLocation)
		zone = barfMountain;
	item[slot] o = GetModifiableOutfit(true);
	o[offhand] = kramco;
	ChooseDropsFamiliar(true);
	WearOutfit(o);
	if (!kramco.have_equipped())
	{
		print("Failed to equip Kramco in offhand", "red");
		return false;
	}
	print("Kramco Sausage-o-Matic combat scheduled, attempting to fight sausage goblin", printColor);
	string page = visit_url(zone.to_url());
	if (TryHandleNonCombat(page))
		return false; // already handled, don't make caller think they get to choose
	else if (page.contains_text("choice.php"))
		abort("Unexpected non-combat running Kramco in zone " + zone);
	RunCombat("Filter_FreeCombat");
	return true;
}

boolean RunBarfMountain(boolean requireOutfit)
{
	location zone = barfMountain;
	if (MeatyScheduled())
	{
		PrepareMeaty();
		zone = ChooseWandererZone();
		if (zone == noLocation)
			zone = barfMountain;
	}
	else
	{
		PrepareBarf(requireOutfit);
		CheckLubeQuest();
	}

	if (LoadChoiceAdventure(zone, true))
	{
		if (needsLube)
		{
			print("Skipping adventure to equip lube-shoes and come back in.", printColor);
			run_choice(6);  // skip and come back later
			if (!lubeShoes.have_equipped())
				acc3.equip(lubeShoes);
			needsLube = false;
			LoadChoiceAdventure(barfMountain, false);
			run_choice(1);  // ride the rollercoaster
			print("Lubed the tracks, now turning in adventure", printColor);
			if (LoadChoiceAdventure(kioskUrl, "Employee Assignment Kiosk", false))
				run_choice(3); // turn in the quest
		}
		else
			run_choice(1);  // ride the rollercoaster
		return true;
	}
	else
	{
		return RunCombat("Filter_Standard");
	}
}

string Filter_LOVTunnel(int round, monster mon, string page)
{
	string repeatAction = "";
	if (mon == LOVenforcer)
	{
		repeatAction = "attack";
	}
	else if (mon == LOVengineer)
	{
		if (weaponPasta.have_skill() && my_mp() > weaponPasta.mp_cost())
			repeatAction = "skill " + weaponPasta.to_string();
		else
		{
			if (canMortar && my_mp() < mortarShell.mp_cost() && !mortared)
			{
				mortared = true;
				return "skill " + mortarShell.to_string();
			}
	 
			if (sauceStorm.have_skill() && my_mp() > sauceStorm.mp_cost()) // saucestorm
				return "skill " + sauceStorm.to_string();
		}
	}
	else // equivaocator
	{
		if (can_still_steal())
			return "\"pickpocket\"";
		if (canSingAlong)
		{
			canSingAlong = false;
			return "skill Sing Along";
		}
		if (canMortar && my_mp() < mortarShell.mp_cost() && !mortared)
		{
			mortared = true;
			return "skill " + mortarShell.to_string();
		}
	}
	if (repeatAction == "" && thrustSmack.have_skill() && my_mp() > thrustSmack.mp_cost())
		repeatAction =  "skill " + thrustSmack.to_string();
	if (repeatAction == "" && sauceStorm.have_skill() && my_mp() > sauceStorm.mp_cost())
		repeatAction = "skill " + sauceStorm.to_string();
	if (repeatAction != "")
	{
		string result = "";
		for (int i = 0; i < 24; i++)
		{
			result += "; " + repeatAction;
		}
		result = result.substring(2);
		print("Running combat macro: " + result, printColor);
		return result;
	}
	return "";
}

void RunLOVTunnel()
{
	if (!summonCurrent.have_skill())
		return;

	if (get_property("loveTunnelAvailable") != "true" || get_property("_loveTunnelUsed") == "true")
		return;

	if (jellyfish.have_familiar() && canPickpocket)
		SwitchToFamiliar(jellyfish);
	else
		ChooseDropsFamiliar(false); // hmm tradeoff between familiar drops, familiar assist, or non-acting to get elixir...
	print("Running LOV tunnel", printColor);
	HealUp(true); // true == HP only, no MP, since first round of combat involves only weapon attacks

	visit_url("place.php?whichplace=town_wrong");
	if (!LoadChoiceAdventure("place.php?whichplace=town_wrong&action=townwrong_tunnel", "LOV Tunnel", false))
		return;
	ResetCombatState();
	run_choice(1); // Enter the tunnel

	// cannot use run_choice() to start the fight, or you won't get a combat filter? 
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1223&option=1"); // Fight LOV Enforcer
	RunCombat("Filter_LOVTunnel");
	LoadChoiceAdventure("choice.php", "Choose LOV gear", false);
	run_choice(3); // LOV Earrings, +50% meat

	ResetCombatState();
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1225&option=1"); // Fight LOV Engineer
	RunCombat("Filter_LOVTunnel");
	LoadChoiceAdventure("choice.php", "Choose LOV buff", false);
	run_choice(2); // open heart surgery, +10 pet weight

	ResetCombatState();
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1227&option=1"); // Fight LOV Equivocator
	RunCombat("Filter_LOVTunnel");
	LoadChoiceAdventure("choice.php", "Choose LOV gift", false);
	run_choice(1); // LOV Enamorang, copy monster
}
void MaxManaSummons()
{
	if (!summonCurrent.have_skill())
		return;
	if (summonCurrent.mp_cost() > 1000) // already cast many times previously, don't want to re-buff here
		return;
	if (!UserConfirmDefault("Do you wish to maximize mana to summon as many resolutions as possible?", true))
		return;
	int minKeep = 50;
	if (leer.have_skill() && quietJudgement.have_skill())
		minKeep = 400; // estimate 1 MP per turn to cast leer after
	BurnManaAndRestores(0, true);

	// increase max mana before doing the 100% restores
	if (HaveEquipment(protonPack) && get_property("_streamsCrossed") != "true")
	{
		back.equip(protonPack);
		cli_execute("crossstreams");
	}
	if (sweetSynth.have_skill())
	{
		if (synthMP.have_effect() == 0 && milkStud.item_amount() > 0 && seniorMint.item_amount() > 0 && TrySpleenSpace(1))
		{
			sweet_synthesis(milkStud, seniorMint);
		}
		if (synthMyst.have_effect() == 0 && milkStud.item_amount() > 0 && daffyTaffy.item_amount() > 0 && TrySpleenSpace(1))
			sweet_synthesis(milkStud, daffyTaffy);
	}

	if (get_property("telescopeUpgrades").to_int() > 0 && get_property("telescopeLookedHigh") == "false")
		cli_execute("telescope high"); // +stats

	if (favorLyle.have_effect() == 0)
		visit_url("place.php?whichplace=monorail&action=monorail_lyle");

	if (get_property("spacegateVaccine") != "true" && get_property("spacegateAlways") == "true")
		cli_execute("spacegate vaccine 2"); // +stats

	if (big.have_effect() == 0)
		use_skill(1, getBig);

	if (powerGlove.HaveEquipment() && tripleSizeEffect.have_effect() == 0)
	{
		if (powerGlove.item_amount() > 0)
			acc1.equip(powerGlove);
		//use_skill(1, tripleSize); // this is currently broken, use url directly:
		visit_url("runskillz.php?action=Skillz&whichskill=7325&targetplayer=2813705&quantity=1");
	}
	if (anyToMystEffect.have_effect() == 0)
	{
		if (muscle.my_basestat() > mysticality.my_basestat() && muscle.my_basestat() > moxie.my_basestat())
		{
			BuyAndUseOneTotal(muscleToMyst, muscleToMystEffect, 5000);
		}
		else if (moxie.my_basestat() > mysticality.my_basestat())
		{
			BuyAndUseOneTotal(moxieToMyst, moxieToMystEffect, 5000);
		}
	}
	if (quietJudgementEffect.have_effect() == 0 && quietJudgement.have_skill())
	{
		use_skill(1, quietJudgement);
	}

	if (vipKey.item_amount() > 0 && get_property("_hotTubSoaks").to_int() < 5)
	{
		while (onePillLarge.have_effect() == 0)
		{
			if (onePill.item_amount() == 0)
				buy(20, onePill, 200);
			if (onePill.item_amount() > 0)
			{
				use(1, onePill);
			}
		}
		if (onePillSmall.have_effect() > 0)
		{
			if (notAKnife.have_skill() && get_property("_discoKnife") == "false")
			{
				int knifeamount = candyKnife.item_amount();
				put_closet(knifeamount, candyKnife);
				use_skill(1, notAKnife); // summon a candy knife, which can be used for sweet synthesis
				take_closet(knifeamount, candyKnife);
			}
			cli_execute("hottub");
		}
	}

	BuyAndUseOneTotal(hawkings, hawkingsEffect, 1000);
	BuyAndUseOneTotal(occult, occultEffect, 400);
	BuyAndUseOneTotal(tomatoJuice, tomatoJuiceEffect, 400);
	BuyAndUseOneTotal(mascara, mascaraEffect, 30);
	if (circleDrum.item_amount() > 0 && get_property("_circleDrumUsed") != "true")
	{
		UseOneTotal(circleDrum, circleDrumEffect);
	}
	if (get_property("_ballpit") != "true" && get_property("ballpitBonus").to_int() >= 1)
	{
		cli_execute("ballpit");
	}
	if (cucumberEffect.have_effect() == 0 && get_property("daycareOpen") == "true")
	{
		cli_execute("daycare mysticality");
	}

	if (!HaveEquipment(sphygmayo) && (get_campground() contains mayoClinic))
		cli_execute("buy 1 " + sphygmayo.to_string());
	while (FreeDailyManaRestore())
	{
		BurnManaAndRestores(20, true);
	}
	WearOutfit(manaOutfit);
	if (bjorn.have_equipped() || crown.have_equipped())
	{
		EquipBjornCrownFamiliars(mayoWasp, grue); // extra 15% mysticality
	}
	RunLOVTunnel();
	int keep = (licenseChill.item_amount() > 0 && get_property("_licenseToChillUsed") == "false") ? 0 : minKeep;
	BurnManaAndRestores(keep, true);
	if (keep == 0)
		use(1, licenseChill);
	keep = (yexpressCard.item_amount() > 0 && get_property("expressCardUsed") == "false") ? 0 : minKeep;
	BurnManaAndRestores(keep, true);
	if (keep == 0)
		use(1, yexpressCard);
	keep = minKeep;
	if (clarasBell.item_amount() > 0 && get_property("_claraBellUsed") == "false"
		&& HaveEquipment(hoboBinder))
	{
		// todo: maybe grab mana restore from hobopolis using clara's bell.
		// Maybe this should go at the beginning before any other buffs have been given,
		// because this will cost a turn.  That means we'd want to pre-buff mana as well
		// before triggering the restore
	}
	BurnManaAndRestores(keep, true);
	if (pants.equipped_item() == sugarShorts)
		pants.equip(noItem);
}

item MoreValuableCrafting(item i1, item i2)
{
	// for crafting purposes, the item we have the least of is most valuable for duplicating,
	// and if they're tied, choose by the most expensive mall price
	if (i1.item_amount() < i2.item_amount())
		return i1;
	if (i1.item_amount() > i2.item_amount())
		return i2;
	if (i1.mall_price() > i2.mall_price())
		return i1;
	return i2;
}

void UseWarbearOven()
{
	if (get_property("_warbearInductionOvenUsed") == "true")
		return;
	if (!(get_campground() contains oven))
		return;
	item best = MoreValuableCrafting(thanks7, thanks8);
	best = MoreValuableCrafting(best, thanks9);
	print("Attempting to duplicate craft " + best + " using warbear induction oven", printColor);
	AcquireFeast(best, 3, true);
}

void BeforeSwapOutDNALab()
{
	if (get_campground() contains dnaLab)
	{
		string syringeType = get_property("dnaSyringe");
		if (syringeType == "constellation" || syringeType == "fish")
		{
			int potionCount = 3 - get_property("_dnaPotionsMade").to_int();
			for (int i = 0; i < potionCount; i++)
				visit_url("campground.php?action=dnapotion");
		}
	}
}

void BeforeSwapOutMayo()
{
	if (get_campground() contains mayoClinic)
	{
		// make sure to grab the sphygmayomanometer before switching items
		if (!HaveEquipment(sphygmayo))
			cli_execute("buy 1 " + sphygmayo.to_string());
		// Soak in the mayo tank
		visit_url("shop.php?action=bacta&whichshop=mayoclinic", false);
		ConsumeMayo(false);
	}
}
// If we have the Asdon Martin active and are about to switch to mayo clinic, want to
// use the missile launcher before it becomes unavailable.  We won't get full buffs for
// this, but it should still be more than worth the fuel it uses
void BeforeSwapOutAsdon()
{
	if ((get_campground() contains asdonMartin)
		&& mayoClinic.item_amount() > 0
		&& get_property("_workshedItemUsed") == "false"
		&& get_property("_missileLauncherUsed") == "false")
	{
		print("Using Missile Launcher while Asdon Martin is active", printColor);
		shouldMissileLauncher = true;
		FuelAsdon(100);
		PrepareFilterState();
		PrepareFamiliar(false);
		RunBarfMountain(false);
	}
}
void BeforeSwapOutWorkshop(item newItem)
{
	if (get_campground() contains newItem)
		return;
	if (get_campground() contains asdonMartin)
		BeforeSwapOutAsdon();
	else if (get_campground() contains mayoClinic)
		BeforeSwapOutMayo();
	else if (get_campground() contains dnaLab)
		BeforeSwapOutDNALab();
	else if (get_campground() contains oven)
		UseWarbearOven();
}

boolean CheckJokesterGunState()
{
	if (HaveEquipment(jokesterGun)
		&& jokesterGun.can_equip()
		&& get_property("_firedJokestersGun") == "false")
	{
		hasFreeKillRemaining = true;
		return true;
	}
	return false;
}

void TryRunLTTFreeKills(int turns)
{

	if (get_property("telegraphOfficeAvailable") != "true") // no telegraph office to run
		return;
	if (my_maxhp() < 1000)
		return; // don't want to mess around with this if we're not tough enough for scaling monsters to survive a good long while
	PrepareFilterState();
	CheckJokesterGunState();
	if (!hasFreeKillRemaining) // without free kills, no point
		return;
print("Jokester = " + canJokesterGun);
print("Xray = " + canXray);
print("batoom = " + canBatoomerang);
print("missile = " + canMissileLauncher);
print("punch = " + canShatteringPunch);
print("mob = " + canMobHit);
	if ( !UserConfirmDefault("Run all free kills in LT&T?", false) )
		return;
	print("Checking for need telegram, count = " + telegram.item_amount(), printColor);
	string page;
	//if (telegram.item_amount() == 0)
	{
		//print("No telegram, checking LT&T office", printColor);
		page = visit_url("place.php?whichplace=town_right&action=townright_ltt");
		if (page.contains_text("(Hard)"))
		{
			print("LT&T Hard quest available", printColor);
			page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1171&option=3"); // grab the hard quest
			if (telegram.item_amount() > 0)
			{
				print("Got a telegram, using it", printColor);
				page = visit_url(telegramLoc.to_url().to_string());
				if (page.contains_text("The Investigation Begins"))
				{
					page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1172&option=1"); // Giddiup/Investigate the mine/
				}
			}
		}
	}
	CheckJokesterGunState();
	print("Trying free kills " + hasFreeKillRemaining + " difficulty " +  get_property("lttQuestDifficulty").to_int(), printColor);
	while (hasFreeKillRemaining
		&& get_property("lttQuestDifficulty").to_int() > 0)
	{
		print("Attempting LT&T telegram turn", printColor);
		int turnNum = get_property("lttQuestStageCount").to_int();
		int turnsBefore = my_turnCount();
		if (turnNum == 9 || turnNum == 19)
		{
			if (UserConfirmDefault("Skip LT&T free kills because next turn is an unskippable non-combat?", true))
				break;
			turnsBefore++;
		}
		else if (turnNum == 29)
		{
			print("Skipping LT&T because you're already at the boss", printColor);
			break;
		}
		PrepareFreeCombat(CopyOutfit(weightOutfitPieces));
		if (CheckJokesterGunState())
			weapon.equip(jokesterGun);
		PrepareFilterState();
		if (!hasFreeKillRemaining) // this gets re-calculated by PrepareFilterState
		{
			print("Out of free kills, stopping LT&T", printColor);
			break;
		}
		RunAdventure(telegramLoc, "Filter_ScalingFreeKill");
//waitq(5);
		int turnsAfter = my_turnCount();
		if (turnsAfter > turnsBefore)
			abort("Free kill algorithm failed, please debug this script");
		BuffInRun(turns, false);
		BurnManaAndRestores(100, false);
	}
}

boolean voraciTeaChecked = false;
void TryAutoExtendThanksGetting(int turnsRemaining)
{
	if (!autoVoraciThanksgetting || saveStomach > 0) // saving back stomach makes this pointless
		return;
	if (turnsRemaining <= thanksgetting.have_effect() + 20)
		return;

	if (my_fullness() + 1 != fullness_limit()) // need exactly 1 stomach remaining for this to trigger
		return;
	if (get_property("_voraciTeaUsed") != "false") // if it's already used, can't do it again
		return;
	if (voraciTea.item_amount() == 0) // no tea?  too bad
		return;
	if (voraciTeaChecked)
		return;

	voraciTeaChecked = true;
	if (UserConfirmDefault("Extend Thanksgetting buff length by consuming cuppa Voraci tea?", true))
	{
		use(1, voraciTea);
		if (!(get_campground() contains mayoClinic))
			eatWithoutMayo = true;
		TryBonusThanksgetting();
	}
}

boolean swappedGarden = false;
void PrepGarden()
{
	// Credit to Erosionseeker for pointing out that you can swap gardens multiple times a day, and that
	// you keep 1 day's growth each time, which means you can force 1 day's growth using fertilizer
	// and then swap back to thanksgarden at the end of the day to harvest 3 a day, plus get two
	// more fertilizer from turns spent, for a total of up to 5 cornucopias a day
	foreach it, count in get_campground()
	{
		if ((it == thanksGarden || it == cornucopia || it == mushroomGarden) && pokeGarden.item_amount() > 0)
		{
			if (count > 1 && UserConfirmDefault("Harvest " + count + " from Thanksgiving garden to switch to " + pokeGarden, true))
			{
				cli_execute("garden pick");
				count = 0;
			}
			if (count <= 1)
			{
				use(1, pokeGarden);
				swappedGarden = true;
			}
		}
	}
}
void RestoreGarden()
{
	if (!swappedGarden)
		return;
	foreach it, count in get_campground()
	{
		if (it == pokeGarden && thanksGarden.item_amount() > 0)
		{
			if (count == 0 && fertilizer.item_amount() > 0)
			{
				use(1, fertilizer); // this will get converted to a single cornucopia, but it should grow to 3 tomorrow
			}
			if (count <= 1)
			{
				use(1, thanksGarden);
			}
		}
	}
}

int GetVotePriority(int num)
{
	string value = get_property("_voteLocal" + num);
	if (value == "")
	{
		visit_url("place.php?whichplace=town_right&action=townright_vote");
		value = get_property("_voteLocal" + num);
	}
	switch (value) // not sure if all these texts match up exactly with expected, so there's an abort if none match
	{
		// positive effect sorted by usefulness:
		case "Meat Drop: +30":
			return 32;
		case "Item Drop: +15":
			return 31;
		case "Adventures: +1":
			return 30;
		case "Maximum MP Percent: +30":
			return 29;
		case "Mysticality Percent: +25":
			return 28;
		case "Candy Drop: +30":
		case "Food Drop: +30":
		case "Booze Drop: +30":
		case "Pants Drop: +30":
		case "Gear Drop: +30":
			return 27;
		case "Experience (familiar): +2":
			return 26;
		case "Experience (Mysticality): +4":
			return 25;
		case "Experience: +3":
			return 24;
		case "Experience (Muscle): +4":
		case "Experience (Moxie): +4":
			return 23;
		case "Muscle Percent: +25":
		case "Moxie Percent: +25":
			return 22;
		case "Maximum HP Percent: +30":
			return 21;
		case "Monster Level: +10":
			return 20;
		case "Stench Resistance: +3":
			return 19;
		case "Hot Resistance: +3":
		case "Cold Resistance: +3":
		case "Spooky Resistance: +3":
		case "Sleaze Resistance: +3":
			return 18;
		case "Initiative: +25":
			return 17;
		case "Hot Damage: +10":
		case "Cold Damage: +10":
		case "Stench Damage: +10":
		case "Spooky Damage: +10":
		case "Sleaze Damage: +10":
		case "Ranged Damage Percent: +100":
		case "Weapon Damage Percent: +100":
		case "Spell Damage Percent: +20":
		case "Unarmed Damage: +20":
			return 16;
		case "Monster Level: -10":
			return 15;

		// negative effects
		case "Muscle: -20":
		case "Mysticality: -20":
		case "Moxie: -20":
		case "Maximum HP Percent: -50":
		case "Maximum MP Percent: -50":
		case "Experience (familiar): -2":
		case "Weapon Damage Percent: -50":
		case "Spell Damage Percent: -50":
		case "Critical Hit Percent: -10":
		case "Initiative: -30":
		case "Adventures: -2":
		case "Experience: -3":
		case "Item Drop: -20":
		case "Meat Drop: -30":
		case "Gear Drop: -50":
			return -1;

		default:
			if (value == "" // +20 Damage to Unarmed Attacks, shows up as "" in properties
				&& get_property("_voteLocal" + ((num % 4) + 1)) != "") // and there's another property which isn't blank, so we know it found something
			{
				return 16;
			}
			abort("_voteLocal" + num + " preference '" + value + "' doesn't match any expected string"
				+ " in this script, please fix this script to handle this case.");
	}
	return -1;
}

boolean votePrompted = false;
void DoVoting()
{
	if (get_property("voteAlways") != "true" && get_property("_voteToday") != "true")
		return;
	if (HaveEquipment(votedSticker))
		return;

	if (!votePrompted)
	{
		votePrompted = true;
		if (!UserConfirmDefault("Do you wish to automatically vote?  Main candidate will be chosen randomly, so do your own voting if you care.", true))
			return;
	}
	string page = visit_url("place.php?whichplace=town_right&action=townright_vote");
	if (!page.contains_text("Daily Loathing Ballot"))
		abort("Voting booth visit unexpectedly failed");

	int candidate = 1 + random(2); // if multiple people run this and don't care, votes should cancel out in favor of people who do care
	int[4] priorities;
	for (int i = 0; i < 4; i++)
		priorities[i] = GetVotePriority(i + 1);
	int local1 = 0, local2 = 0;
	for (int i = 1; i < 4; i++)
		if (priorities[i] > priorities[local1])
			local1 = i;
	if (local1 == 0)
		local2 = 1;
	for (int i = 0; i < 4; i++)
		if (i != local1 && priorities[i] > priorities[local2])
			local2 = i;

	print("Voting for "
		+ get_property("_voteLocal" + (local1 + 1))
		+ " and "
		+ get_property("_voteLocal" + (local2 + 1)),
		printColor);
	string voteURL = "choice.php?pwd=" + my_hash() + "&option=1&whichchoice=1331&g=" + candidate + "&local[]=" + local1 + "&local[]=" + local2;
	page = visit_url(voteURL);
}

boolean HandleVoteMonster()
{
	if (get_property("voteAlways") != "true" && get_property("_voteToday") != "true")
		return false;

	if ((total_turns_played() % 11) != 1 || get_property("lastVoteMonsterTurn").to_int() == total_turns_played())
		return false;

	DoVoting();
	if (!HaveEquipment(votedSticker))
		return false;

	int freeFightsLeft = 3 - get_property("_voteFreeFights").to_int();
	boolean underLimit = meat_drop_modifier() < votedMeatLimit;
	if (!underLimit)
	{
		if (freeFightsLeft <= 0) // only run free fights until we're under the meat bonus limit
			return false;
		if (HaveEquipment(doctorBag) && get_property("doctorBagQuestLocation") == "") // save free fights for wanderers for doctor bag quest
			return false;
	}

	monster mon = get_property("_voteMonster").to_monster();
	if (mon == $monster[none]) // already voted, but don't know who it is yet
		visit_url("place.php?whichplace=town_right&action=townright_vote");

	item[slot] localOutfit = CopyOutfit(dropsOutfitPieces);
	if (!OutfitContains(localOutfit, votedSticker))
	{
		print("Wearing I Voted sticker for wandering monsters", printColor);
		localOutfit[acc3] = votedSticker;
	}
	if (HaveEquipment(doctorBag) && get_property("doctorBagQuestLocation") == "")
	{
		if (HaveEquipment(doctorBag) && !OutfitContains(localOutfit, doctorBag) && get_property("doctorBagQuestLocation") == "")
		{
			localOutfit[acc2] = doctorBag;
		}
	}
	if (mon == mutant)
	{
		if (!HaveEquipment(mutantCrown) && HaveEquipment(mutantLegs))
			localOutfit[pants] = mutantLegs;
		if (!HaveEquipment(mutantLegs) && HaveEquipment(mutantArm))
			localOutfit[weapon] = mutantArm;
	}
	location zone = ChooseWandererZone();
	if (zone == noLocation)
		return false;
	WearOutfit(localOutfit);
	ChooseDropsFamiliar(false);
	ChooseBjornCrownFamiliars(false);

	HealUp(true);
	print("Sending wandering vote monster to " + zone, printColor);
	string page = visit_url(zone.to_url().to_string());
	if (TryHandleNonCombat(page))
		return false;
	else if (page.contains_text("choice.php"))
		abort("TODO: unhandled non-combat when wanderer expected");
	RunCombat("Filter_Standard");
	return true;
}


string Filter_PocketProfessor(int round, monster mon, string page)
{
	if (!lecturedRelativity)
	{
		lecturedRelativity = true;
		return "skill lecture on relativity";
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill Sing Along";
	}
	if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
	{
		cursed = true;
		return "skill " + curseOfWeaksauce.to_string();
	}
	return "";
}

item[slot] ChooseDoctorBagSlot(item[slot] o)
{
	if (!HaveEquipment(doctorBag))
		return o;
	if (OutfitContains(o, doctorBag))
		return o;
	float lowestWeight = 1000;
	slot bestSlot;
	foreach ix,sl in slot[] { acc1, acc2, acc3 }
	{
		float weight = o[sl].numeric_modifier("Familiar Weight");
		if (weight < lowestWeight)
		{
			lowestWeight = weight;
			bestSlot = sl;
		}
	}
	o[bestSlot] = doctorBag;
	return o;
}
int CalculateRemainingProfessorCopies(int weight)
{
	int used = get_property("_pocketProfessorLectures").to_int();
	int copies = 2; // 2 from familiar equipment
	int nextCost = 1;
	int nextCostIncrement = 1;
	while (nextCost <= weight)
	{
		copies++;
		nextCost += nextCostIncrement;
		nextCostIncrement += 2;
	}
	if (isDebug)
		print("Total professor copies " + copies, printColor);
	copies -= used;
	if (isDebug)
		print("Remaining professor copies " + copies, printColor);
	return copies;
}

string ActivateMonsterFight(monster m)
{
	if (m == $monster[none])
		return "";

	string result = ActivateWitchess(m);
	if (result != "")
		return result;

	if (m == $monster[Eldritch Tentacle])
		result = ActivateEldritchTentacle();
	if (result != "")
		return result;


	monster wanderer = WandererScheduled().to_monster();
	if (wanderer == m)
	{
		location zone = ChooseWandererZone();
		if (zone == noLocation)
			zone = barfMountain;
		return visit_url(zone.to_url());
	}
	
	return "";
}

boolean HandleProfessorCopies(boolean beforeRunaways)
{
	if (!pocketProf.have_familiar())
		return false;
	monster m = pocketProfessorCloneMonster;
	if (m == $monster[none])
		return false;
	boolean hasDoctorQuest = get_property("doctorBagQuestLocation") != "";
	if (beforeRunaways && hasDoctorQuest)
		return false;
	item[slot] o = CopyOutfit(weightOutfitPieces);
	if (!hasDoctorQuest)
		o = ChooseDoctorBagSlot(o);
	o[famEqp] = $item[Pocket Professor memory chip];
	int weight = CalculateFamiliarWeight(pocketProf, o);
	int copies = CalculateRemainingProfessorCopies(weight);
	int copiesWithFeast = copies;
	if (FeastingAvailable(pocketProf))
	{
		copiesWithFeast = CalculateRemainingProfessorCopies(weight + 10);
	}
	print(copiesWithFeast + " lectures remaining for pocket professor");
	if (copies <= 0)
		return false;

	if (my_familiar() != pocketProf)
		pocketProf.use_familiar();
	if (my_familiar() != pocketProf)
		return false;
	WearOutfit(o);

	PrepareFilterState(true);
	if (copiesWithFeast > copies || !IsFreeFightMonster(m)) // if not a free fight, weight could change in the middle
		TryUseMovableFeast();

	if (get_property("friarsBlessingReceived") == "false") // professor benefits from bonus exp
		cli_execute("friars familiar");

	string page = ActivateMonsterFight(m);
	while (InCombat(page))
	{
		page = run_combat("Filter_PocketProfessor");
		if (page.contains_text("STEP INTO FOLD IN SPACETIME"))
		{
			ResetCombatState();
			visit_url("fight.php");
			page = "You're fighting";
		}
		else
			CheckPostCombat(page, "Filter_PocketProfessor");
	}

	return true;
}


void RunTurns(int turnCount)
{
	if (turnCount == 0)
		return;

	int startTurnCount = my_turnCount();
	int endTurnCount = startTurnCount + turnCount;

	CheckBoomBoxSong();
	TryCalculateUniverse();
	TryOpenRainDoh();
	PrepGarden();
	try
	{
		while (RunawayDoctorBagQuest()) { }

		if (IsFreeFightMonster(pocketProfessorCloneMonster))
		{
			HandleProfessorCopies(true);
			while (RunawayDoctorBagQuest()) { }
		}

		// things to do while familiar weight is maxxed
		TryRunLTTFreeKills(turnCount);
		FarmMojoFilters();
		FreeCombatsForProfit();

		RunawayGingerbread();
		RunawayDinseyBurnDelay();
		RunawayMadnessBakery();

		if (IsFreeFightMonster(pocketProfessorCloneMonster))
			HandleProfessorCopies(false);

		int infiniteLoopCounter = 0;
		while (my_turnCount() <= endTurnCount)
		{
			int turnsRemaining = endTurnCount - my_turnCount();
			print("LinknoidBarf Turns remaining = " + turnsRemaining);
			for (int j = 0; j < 4; j++) // current limit is 4 on a player
				if (!TryCalculateUniverse())
					break;
			TryAutoExtendThanksGetting(turnsRemaining);
			if (my_adventures() <= 0)
			{
				print("Out of adventures, stopping");
				break;
			}
			BuffInRun(turnsRemaining, false);
			BurnManaAndRestores(20, false);
			PrepareFilterState();

			if (HandleVoteMonster())
				continue;
		  
			if (needBagOTricks)
				TryActivateBagOTricks(CopyOutfit(dropsOutfitPieces));

			TryAutoExtendThanksgetting(turnsRemaining);
			SoulSauceToMana();
			if (spookyravenCounter == my_turnCount())
			{
				print("Skipping Spookyraven in this script, if you don't want it to skip, add a 'counter script' in KoLmafia");
				BypassCounterError();
			}

			if ((turnsRemaining) % 5 == 1)  // only check every 5 turns
			{
				if (TryFightGhost())
				{
					infiniteLoopCounter = 0;
					continue;
				}
			}
			if (RunawayDoctorBagQuest())
			{
				infiniteLoopCounter = 0;
				continue;
			}
			if (my_turnCount() >= endTurnCount)
				return;

			if (fortuneCookieCounter == my_turnCount()
				&& semiRareAttempted != my_turnCount())
			{
				print("Running semi-rare");
				RunSemiRare();
				continue;
			}
			if (CopiedMeatyAvailable())
			{
				print("Running copied " + meatyMonster);
				PrepareFamiliar(true);
				if (RunCopiedMeaty())
				{
					infiniteLoopCounter = 0;
					continue;
				}
			}
			if (TryRunKramco())
			{
				infiniteLoopCounter = 0;
				continue;
			}
			PrepareFamiliar(false);
			print("Running barf mountain");
			if (RunBarfMountain(true))
				infiniteLoopCounter = 0;
			else if (++infiniteLoopCounter > 10)
			{
				// just a sanity check, want a little leeway so it doesn't assume infinite loop immediately, but if we've
				// gone 10 rounds without doing anything, assume we're stuck
				print("Looks like we're in an infinite loop, stopping", printColor);
				break;
			}
			if (turnsRemaining > 2)
				TryForceSemirare();
		}
	}
	finally
	{
		RestoreGarden();

		if (HaveEquipment(pantsGiving))
		{
			int pantsCount = get_property("_pantsgivingCount").to_int();
			if (pantsCount < 500)
			{
				int remaining;
				if (pantsCount < 5)
					remaining = 5 - pantsCount;
				else if (pantsCount < 50)
					remaining = 50 - pantsCount;
				else
					remaining = 500 - pantsCount;
				print("Pantsgiving " + remaining + " adventures until next fullness.", printColor);
			}
		}
	}
}


void SetRunFamiliar(string familiarName, int buffTurns)
{
	familiar fam;
	if (familiarName != "")
		fam = familiarName.to_familiar();
	else if (get_property("_roboDrinks").contains_text(roboMeat.to_string()))
		fam = robort;
	else if (buffTurns >= 100 && robort.have_familiar()) // 2x weight leprechaun
		fam = robort;
	else if (hoboMonkey.have_familiar()) // 1.25x weight leprechaun
		fam = hoboMonkey;
	else if (leprechaun.have_familiar()) // 1x weight leprechaun
		fam = leprechaun;
	else
		fam = my_familiar();

	if (familiarName != "none" && !fam.have_familiar())
		abort("Cannot run, do not own familiar " + fam);
	print("Running with familiar " + fam, printColor);
	runFamiliar = fam;
}

boolean HasAccess()
{
	string page = visit_url("place.php?whichplace=airport");
	return page.contains_text("plane_stinko_dinko.gif");
}

void EnsureAccess()
{
	if (HasAccess())
		return;

	if (!UserConfirmDefault("No access to Dinsey, use a day pass?", get_property("stenchAirportAlways") != "true"))
		abort("No access to Dinsey");

	if (dayPass.item_amount() == 0)
		buy(1, dayPass);
	if (dayPass.item_amount() == 0)
		abort("Could not acquire " + dayPass.to_string());
	use(1, dayPass);
}

void ValidateNotBusy()
{
	string mainPage = visit_url("main.php");
	if (mainPage.contains_text("choice.php"))
		abort("Script cannot start while you are stuck in a choice adventure");
	if (InCombat(mainPage))
		abort("Script cannot start while you are stuck in combat");
}

// pass -1 for buffTurns if you're doing "night before" buffing
void main(int buffTurns, int runTurns, string familiarOrDirective)
{
	ValidateNotBusy();
	ReadSettings();
	WriteSettings(); // in case there are new properties
	autoConfirm = autoConfirmBarf || user_confirm("Auto-confirm all prompts this run?");
	InitOutfits();
	ChooseSummonType();
	string[int] parts = familiarOrDirective.split_string("[,;]");
	string familiarName = "";
	foreach ix,part in parts
	{
		switch (part)
		{
			case "ascend":
				ascendToday = my_ascensions() + "," + my_daycount();
				print("Setting ascension for today = " + ascendToday, printColor);
				break;
			case "noascend":
				ascendToday = "";
				print("Clearing ascension for today", printColor);
				break;
			default: familiarName = part; break;
		}
	}
	SetRunFamiliar(familiarName, buffTurns);

	RemoveConfusionEffects(true);
	
	if (buffTurns > 0 || runTurns > 0)
		EnsureAccess();
	if (buffTurns != 0)
		BuffTurns(buffTurns);
	if (runTurns != 0)
		RunTurns(runTurns);
}

