// Credits:
// Bale forum posts about url handling, witchess fights
// VeracityMeatFarm.ash for introduction to combat filters and getting started with LOV tunnel
// Ezandora's KGB.ash script for handling briefcase so I don't have to
// Zarqon canadv.ash for how to check for access to purple light district


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

// duplicate witchess knight

// track candle/scroll drops from intergnat

// print screen buttons seem broken currently


// auto-craft  (umm, what was I thinking here?)

// Add for mana burning:
// clara's bell and hobopolis if 20 hobo glyphs and have access




// LINKNOIDBARF.ASH


    boolean autoConfirmBarf = false;
    string defaultOutfit = "barf";
    string manaOutfit = "Max MP";
    string dropsOutfit = "drops";

    string printColor = "orange";

// Change these values to put limits on how much of certain resources to keep back:
    int saveSpleen = 0;
    int saveStomach = 0;
    int saveLiver = 0;
    int maxUsePrintScreens = 1;
    int maxUseEnamorangs = 1;
    boolean allowExpensiveBuffs = true;
    boolean abortOnBeatenUp = false;
    boolean preferCalcUniversePvP = false;

void WriteSettings()
{
    string[string] map;
    file_to_map("linknoidfarm_" + my_name() + ".txt", map);
    map["autoConfirmBarf"] = autoConfirmBarf.to_string();
    map["defaultOutfit"] = defaultOutfit;
    map["manaOutfit"] = manaOutfit;
    map["dropsOutfit"] = dropsOutfit;
    map["printColor"] = printColor;
    map["saveSpleen"] = saveSpleen.to_string();
    map["saveStomach"] = saveStomach.to_string();
    map["saveLiver"] = saveLiver.to_string();
    map["maxUsePrintScreens"] = maxUsePrintScreens.to_string();
    map["maxUseEnamorangs"] = maxUseEnamorangs.to_string();
    map["allowExpensiveBuffs"] = allowExpensiveBuffs.to_string();
    map["abortOnBeatenUp"] = abortOnBeatenUp.to_string();
    map["preferCalcUniversePvP"] = preferCalcUniversePvP.to_string();
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
            case "autoConfirmBarf": autoConfirmBarf = value == "true"; break;
            case "defaultOutfit": defaultOutfit = value; break;
            case "manaOutfit": manaOutfit = value; break;
            case "dropsOutfit": dropsOutfit = value; break;
            case "saveSpleen": saveSpleen = value.to_int(); break;
            case "saveStomach": saveStomach = value.to_int(); break;
            case "saveLiver": saveLiver = value.to_int(); break;
            case "maxUsePrintScreens": maxUsePrintScreens = value.to_int(); break;
            case "maxUseEnamorangs": maxUseEnamorangs = value.to_int(); break;
            case "allowExpensiveBuffs": allowExpensiveBuffs = value == "true"; break;
            case "abortOnBeatenUp": abortOnBeatenUp = value == "true"; break;
            case "preferCalcUniversePvP": preferCalcUniversePvP = value == "true"; break;
        }
    }
}


    slot ToSlot(string s)
    {
        slot result = s.to_slot();
        if (result.to_string() != s)
            abort("Illegal slot " + s);
        return result;
    }
    item ToItem(string s)
    {
        item result = s.to_item();
        if (result.to_int() < 0)
            abort("Illegal item " + s);
        return result;
    }
    skill ToSkill(string s)
    {
        skill result = s.to_skill();
        if (result.to_int() < 0)
            abort("Illegal skill " + s);
        return result;
    }
    location ToLocation(string s)
    {
        location result = s.to_location();
        if (result.to_string() != s)
            abort("Illegal location " + s);
        return result;
    }
    effect ToEffect(string s)
    {
        effect result = s.to_effect();
        if (result.to_int() < 0)
            abort("Illegal effect " + s);
        return result;
    }
    familiar ToFamiliar(string s)
    {
        familiar result = s.to_familiar();
        if (result.to_int() < 0)
            abort("Illegal familiar " + s);
        return result;
    }
    thrall ToThrall(string s)
    {
        thrall result = s.to_thrall();
        if (result.to_int() < 0)
            abort("Illegal thrall " + s);
        return result;
    }
    monster ToMonster(string s)
    {
        monster result = s.to_monster();
        if (result.to_string() != s)
            abort("Illegal monster " + s);
        return result;
    }
    stat ToStat(string s)
    {
        stat result = s.to_stat();
        if (result.to_string() != s)
            abort("Illegal stat " + s);
        return result;
    }

    stat muscle = ToStat("Muscle");
    stat mysticality = ToStat("Mysticality");
    stat moxie = ToStat("Moxie");

    slot head = ToSlot("hat");
    slot back = ToSlot("back");
    slot shirt = ToSlot("shirt");
    slot weapon = ToSlot("weapon");
    slot offhand = ToSlot("off-hand");
    slot pants = ToSlot("pants");
    slot acc1 = ToSlot("acc1");
    slot acc2 = ToSlot("acc2");
    slot acc3 = ToSlot("acc3");
    slot famEqp = ToSlot("familiar");
    slot sticker1 = ToSlot("sticker1");
    slot sticker2 = ToSlot("sticker2");
    slot sticker3 = ToSlot("sticker3");


// getting access to dinsey
    item dayPass = ToItem("one-day ticket to Dinseylandfill");

// campground items
    item witchess = ToItem("Witchess Set");
    item terminal = ToItem("Source terminal");
    item mayoClinic = ToItem("portable Mayo Clinic");
    item asdonMartin = ToItem("Asdon Martin keyfob");
    effect observantly = ToEffect("Driving Observantly");
    item pieFuel = ToItem("pie man was not meant to eat");
    item water = to_item("soda water"); // food for adsonMartin
    item dough = to_item("wad of dough"); // food for adsonMartin
    item breadFuel = ToItem("loaf of soda bread");
    item sphygmayo = ToItem("sphygmayomanometer");

// items for eating
    item milk = ToItem("milk of magnesium");
    effect gotmilk = ToEffect("Got Milk");
    item mayoFullToDrunk = ToItem("Mayodiol"); // 1 full to drunk
    item mayoIncreaseBuffs = ToItem("Mayozapine"); // double stats
    item cashew = ToItem("cashew");
    item cornucopia = ToItem("cornucopia");
    item horseradish = ToItem("jumping horseradish");
    item foodCone = ToItem("Dinsey food-cone");
    item seaTruffle = ToItem("sea truffle");
    item thanks1 = ToItem("green bean casserole");
    item thanks2 = ToItem("cranberry cylinder");
    item thanks3 = ToItem("mashed potatoes");
    item thanks4 = ToItem("candied sweet potatoes");
    item thanks5 = ToItem("mince pie");
    item thanks6 = ToItem("bread roll");
    item thanks7 = ToItem("baked stuffing");
    item thanks8 = ToItem("thanksgiving turkey");
    item thanks9 = ToItem("warm gravy");
    item distention = ToItem("distention pill");
    item timeSpinner = ToItem("Time Spinner");

// booze to drink
    item dirt = ToItem("dirt julep"); // booze from plants with robortender
    item gingerWine = ToItem("high-end ginger wine"); // from gingertown
    item turkey = ToItem("Ambitious Turkey"); // from hand turkey
    item sacramento = ToItem("Sacramento wine"); // from witchess
    effect sacramentoEffect = ToEffect("Sacré Mental");
    item pinkyRing = ToItem("mafia pinky ring"); // increases adventure yield from wine

// spleen items
    item egg1 = ToItem("black paisley oyster egg");
    item egg2 = ToItem("black polka-dot oyster egg");
    item egg3 = ToItem("black striped oyster egg");
    item mojoFilter = ToItem("mojo filter");
// Sweet Synthesis
    item milkStud = ToItem("Milk Studs");
    item seniorMint = ToItem("Senior Mints");
    item daffyTaffy = ToItem("Daffy Taffy");
    item swizzler = ToItem("Swizzler");

// orphan tot
    familiar orphan = ToFamiliar("Trick-or-Treating Tot");
    item pirateCostume = ToItem("li'l Pirate Costume");

// robortender
    familiar robort = ToFamiliar("Robortender");
    item roboItems = ToItem("single entendre");
    item roboCandy = ToItem("Feliz Navidad");
    item roboMana = ToItem("hell in a bucket");
    item roboMeat = ToItem("drive-by shooting");
    item roboHobo = ToItem("Newark");

// other familiars of interest
    familiar sandworm = ToFamiliar("Baby Sandworm");
    familiar fistTurkey = ToFamiliar("Fist Turkey");
    familiar intergnat = ToFamiliar("Intergnat");
    familiar jellyfish = ToFamiliar("Space Jellyfish");
    familiar robin = ToFamiliar("Rockin' Robin");
    familiar stompingBoots = ToFamiliar("Pair of Stomping Boots");
    familiar bandersnatch = ToFamiliar("Frumious Bandersnatch");
    familiar obtuseAngel = ToFamiliar("Obtuse Angel");
    familiar reanimator = ToFamiliar("Reanimated Reanimator");

// Bjorn/crown familiars:
    item bjorn = ToItem("Buddy Bjorn");
    item crown = ToItem("Crown of Thrones");
    familiar leprechaun = ToFamiliar("Leprechaun"); // 20% meat
    familiar hoboMonkey = ToFamiliar("Hobo Monkey"); // 25% meat
    familiar goldenMonkey = ToFamiliar("Golden Monkey"); // 25% meat
    familiar happyMedium = ToFamiliar("Happy Medium"); // 25% meat
    familiar organGrinder = ToFamiliar("Knob Goblin Organ Grinder"); // 25% meat
    familiar machineElf = ToFamiliar("Machine Elf"); // drops abstractions
    familiar garbageFire = ToFamiliar("Garbage Fire"); // drops abstractions
    familiar mayoWasp = ToFamiliar("Baby Mayonnaise Wasp"); // +15% myst
    familiar grue = ToFamiliar("Grue"); // +15% myst


// familiar equipment
    item snowSuit = ToItem("Snow Suit"); // 20 pounds, but decreases over the day
    item petSweater = ToItem("Astral pet sweater"); // 10 pounds, costs 10 karma per ascension
    item sugarShield = ToItem("sugar shield"); // 10 pounds, breaks after 30 turns
    item cufflinks = ToItem("recovered cufflinks"); // 6 pounds, requires 400 pound jellyfish
    item hookah = ToItem("ittah bittah hookah"); // 5 pounds, provides buffs
    item mayflower = ToItem("Mayflower bouquet"); // 5 pounds, provides drops
    item moveableFeast = ToItem("moveable feast"); // 5 pounds, provides drops
    item filthyLeash = ToItem("filthy child leash"); // 5 pounds, deals damage, fallback if nothing else
    item quakeOfArrows = ToItem("quake of arrows"); // for a cute angel
    item embalmingFlask = ToItem("flask of embalming fluid"); // for reanimated reanimator

// pasta thralls
    thrall lasagnaThrall = ToThrall("Lasagmbie"); // for meat
    thrall spiceThrall = ToThrall("Spice Ghost"); // for items
    thrall verminThrall = ToThrall("Vermincelli"); // for mana
    thrall vampireThrall = ToThrall("Vampieroghi"); // for healing
    skill lasagnaThrallSkill = ToSkill("Bind Lasagmbie"); 
    skill spiceThrallSkill = ToSkill("Bind Spice Ghost");
    skill verminThrallSkill = ToSkill("Bind Vermincelli");
    skill vampireThrallSkill = ToSkill("Bind Vampieroghi");
    effect lasagnaThrallEffect = ToEffect("Pasta Eyeball");

// ghost busting
    item protonPack = ToItem("protonic accelerator pack");
    item talisman = ToItem("Talisman o' Namsilat");
    item antiqueAccordion = ToItem("Antique Accordion");
    location palindome = ToLocation("Inside the Palindome");
    location icyPeak = ToLocation("The Icy Peak");
    skill weakenGhost = ToSkill("Shoot Ghost");
    skill trapGhost = ToSkill("Trap Ghost");
// survival
    skill curseOfIslands = ToSkill("Curse of the Thousand Islands");
    skill soulBubble = ToSkill("Soul Bubble");
    skill entanglingNoodles = ToSkill("Entangling Noodles");
    skill curseOfWeaksauce = ToSkill("Curse of Weaksauce");
    skill micrometeorite = ToSkill("Micrometeorite");


// Skills and items for extending buffs
    item bagOtricks = ToItem("Bag O' Tricks");
    item jokesterGun = ToItem("Jokester's Gun");
    item replicaBatoomerang = ToItem("Replica Bat-oomerang");
    skill shatteringPunch = ToSkill("Shattering Punch");
    skill gingerbreadMobHit = ToSkill("Gingerbread Mob Hit");
    skill missileLauncher = ToSkill("Asdon Martin: Missile Launcher");
    skill fireJokester = ToSkill("Fire the Jokester's Gun");

// increase drops in combat
    skill funkslinging = ToSkill("Ambidextrous Funkslinging");
    skill meteorShower = ToSkill("Meteor Shower");
    skill accordionBash = ToSkill("Accordion Bash");
    item bling = ToItem("Bling of the New Wave");
    item bakeBackpack = ToItem("bakelite backpack");
    item snowglobe = ToItem("KoL Con 13 snowglobe");
    item screege = ToItem("Mr. Screege's spectacles");
    item cheeng = ToItem("Mr. Cheeng's spectacles");
    item mayfly = ToItem("mayfly bait necklace");
    skill extractJelly = ToSkill("Extract Jelly");
    skill extract = ToSkill("Extract");
    skill pocketCrumbs = ToSkill("Pocket Crumbs");
    item bittyMeat = ToItem("BittyCar MeatCar");

// monster level so it can survive longer
    skill annoyingNoise = ToSkill("Drescher's Annoying Noise");
    effect annoyingNoiseEffect = ToEffect("Drescher's Annoying Noise");
    skill annoyance = ToSkill("Ur-Kel's Aria of Annoyance");
    effect annoyanceEffect = ToEffect("Ur-Kel's Aria of Annoyance");
    item greekFire = ToItem("Greek fire");
    effect greekFireEffect = ToEffect("Sweetbreads Flambé");

// running away
    skill cleesh = ToSkill("Cleesh");
    item fishermansack = ToItem("fisherman's sack"); // quest item after completing nemesis quest as AT
    item smokebomb = ToItem("fish-oil smoke bomb"); // quest item receive 3 from each fisherman's sack, use 'em or lose 'em on ascending


// Skills for more turns
    skill odeToBooze = ToSkill("The Ode to Booze");
    skill calcUniverse = ToSkill("Calculate the Universe");

// skills for +meat bonus
    skill leer = ToSkill("Disco Leer");
    skill polka = ToSkill("The Polka of Plenty");
    skill thingfinder = ToSkill("The Ballad of Richie Thingfinder");
    skill companionship = ToSkill("Chorale of Companionship");
    skill phatLoot = ToSkill("Fat Leon's Phat Loot Lyric");
    skill sweetSynth = ToSkill("Sweet Synthesis");
    skill selfEsteem = ToSkill("Incredible Self-Esteem");
// skills for pet bonus
    skill leash = ToSkill("Leash of Linguini");
    skill empathy = ToSkill("Empathy of the Newt");
    item petBuff = ToItem("Knob Goblin pet-buffing spray");
    item kinder = ToItem("resolution: be kinder");
    item joy = ToItem("abstraction: joy");

// items for +meat bonus
    item vipKey = ToItem("Clan VIP Lounge key"); // for clan VIP room access
    item poolTable = ToItem("Clan Pool Table");
    item blBackpack = ToItem("Bakelite Backpack"); // with accordion bash
    item halfPurse = ToItem("Half a Purse"); // requires Smithsness to be effective
    item sunglasses = ToItem("cheap sunglasses"); // only relevant for barf mountain
    item deck = ToItem("Deck of Every Card"); // required for knife or rope if part of outfit
    item knife = ToItem("knife"); // from deck of every card
    item rope = ToItem("rope"); // from deck of every card
    item scratchSword = ToItem("scratch 'n' sniff sword"); // only worthwhile for embezzlers
    item scratchXbow = ToItem("scratch 'n' sniff crossbow"); // only worthwhile for embezzlers
    item scratchUPC = ToItem("scratch 'n' sniff UPC sticker"); // attaches to crossbow or sword
    item nasalSpray = ToItem("Knob Goblin nasal spray"); // bought from knob goblin dispensary
    item wealthy = ToItem("resolution: be wealthier"); // from libram of resolutions
    item affirmationCollect = ToItem("Daily Affirmation: Always be Collecting"); // from new you club
    item avoidScams = ToItem("How to Avoid Scams"); // only relevant for barf mountain
    item begpwnia = ToItem("begpwnia"); // 30% from mayflower bouquet
    item flaskfull = ToItem("Flaskfull of Hollow"); // + smithness for Half a Purse
    item dice = ToItem("Glenn's golden dice"); // once a day random buffs
    item pantsGiving = ToItem("Pantsgiving"); // wear for combat skills, fullnes reduction
    item gameToken = ToItem("defective Game Grid token"); // once a day activate for 5 turns of +5 everything
    item chibiOff = ToItem("ChibiBuddy™ (off)"); // once a day activate for 5 turns of +5 familiar weight
    item chibiOn = ToItem("ChibiBuddy™ (on)"); // once a day activate for 5 turns of +5 familiar weight
    item mumming = ToItem("mumming trunk"); // cast +meat or +item on familiar

// 2 day items for +meat bonus
    item peppermint = ToItem("peppermint twist"); // candy drop from robort
    item micks = ToItem("Mick's IcyVapoHotness Inhaler"); // from semi-rare
    item sugar = ToItem("bag of powdered sugar"); // 
    item pinkHeart = ToItem("pink candy heart");
    item polkaPop = ToItem("Polka Pop");
    item cranberryCordial = ToItem("cranberry cordial");

// special activations for +meat bonus
    string summonGreed = "summon 2"; // summoning chamber if you've learned the Hoom-Ha name
    string meatEnh = "terminal enhance meat.enh"; // if you have a source terminal
    string concertWinklered = "concert Winklered"; // if you helped the Orcs in the island war and finished fliering for the concert
    string hatterDreadSack = "hatter filthy knitted dread sack"; // need a Drink-me potion and a filthy knitted dread sack from hippies

// effects for +meat bonus
    effect odeToBoozeEffect = ToEffect("Ode to Booze"); //
    effect winklered = ToEffect("Winklered"); // from concert if you helped orcs
    effect sinuses = ToEffect("Sinuses For Miles"); // from Mick's
    effect nasalSprayEffect = ToEffect("Wasabi Sinuses"); // from Knob Goblin nasal spray
    effect resolve = ToEffect("Greedy Resolve"); // from resolution: be wealthy
    effect alwaysCollecting = ToEffect("Always be Collecting"); // DailyAffirmation: always be collecting
    effect workForHours = ToEffect("Work For Hours a Week"); // DailyAffirmation: Work for hours a week
    effect begpwniaEffect = ToEffect("Can't Be a Chooser"); // from begpwnia
    effect avoidScamsEffect = ToEffect("How to Scam Tourists"); // from How to Avoid Scams
    effect leering = ToEffect("Disco Leer"); // from Disco Leer (disco bandit skill)
    effect polkad = ToEffect("Polka of Plenty"); // from Polka (accordion thief)
    effect phatLooted = ToEffect("Fat Leon's Phat Loot Lyric"); // from Fat Leon's (accordion thief)
    effect thingfinderEffect = ToEffect("The Ballad of Richie Thingfinder"); // accordion thief only
    effect companionshipEffect = ToEffect("Chorale of Companionship"); // accordion thief only
    effect meatEnhanced = ToEffect("meat.enh"); // source terminal, 60%, 3x 100 turns a day
    effect danceTweedle = ToEffect("Dances with Tweedles"); // from DRINK ME potion, once a day, 40%, 30 turns
    effect merrySmith = ToEffect("Merry Smithsness"); // from Flaskfull of Hollow
    effect kickedInSinuses = ToEffect("Kicked in the Sinuses"); // from horseradish
    effect foodConeEffect = ToEffect("The Dinsey Way"); // from Dinsey Food Cone
    effect seaTruffleEffect = ToEffect("Trufflin'"); // from the sea truffle
    effect thanksgetting = ToEffect("Thanksgetting"); // from thanksgetting feast items
    effect synthGreed = ToEffect("Synthesis: Greed"); // from Sweet Synthesis skill
    effect preternatualGreed = ToEffect("Preternatural Greed");
    effect eggEffect = ToEffect("Egg-stortionary Tactics");
    effect gingerWineEffect = ToEffect("High-Falutin'");
    effect dirtEffect = ToEffect("Here's Some More Mud in Your Eye");
    effect turkeyEffect = ToEffect("Turkey-Ambitious");
    effect joyEffect = ToEffect("Joy");
    effect pinkHeartEffect = ToEffect("Heart of Pink");
    effect polkaPopEffect = ToEffect("Polka Face");
    effect peppermintEffect = ToEffect("Peppermint Twisted");
    effect sugarEffect = ToEffect("So You Can Work More...");
    effect cranberryCordialEffect = ToEffect("Cranberry Cordiality");
    effect poolEffect = ToEffect("Billiards Belligerence");
    effect kgbMeat = ToEffect("A View to Some Meat");
    effect kgbItems = ToEffect("Items Are Forever");
    effect bagOTricksEffect1 = ToEffect("Badger Underfoot");
    effect bagOTricksEffect2 = ToEffect("Weasels Underfoot");
    effect bagOTricksEffect3 = ToEffect("Chihuahua Underfoot");

// effects for pet weight bonus
    effect leashEffect = ToEffect("Leash of Linguini");
    effect empathyEffect = ToEffect("Empathy");
    effect petBuffEffect = ToEffect("Heavy Petting");
    effect kinderEffect = ToEffect("Kindly Resolve");
    effect chibiEffect = ToEffect("ChibiChanged™");

// skills to activate Bag O' Tricks
    skill mortarShell = ToSkill("Stuffed Mortar Shell"); // this one is special because it has a one turn delay
    skill BoTspell1 = ToSkill("Spaghetti Spear"); // low damage
    skill BoTspell2 = ToSkill("Salsaball"); // low damage
    skill sauceStorm = ToSkill("Saucestorm"); // likely to have skill
    skill thrustSmack = ToSkill("Lunging Thrust-Smack");
    skill weaponPasta = ToSkill("Weapon of the Pastalord");

// between turns skills
    skill summonRes = ToSkill("Summon Resolutions");
    skill summonTaffy = ToSkill("Summon Taffy");
    skill soulFood = ToSkill("Soul Food");
// mana cost reduction
    item oscusWeapon = ToItem("Wand of Oscus");
    item oscusPants = ToItem("Oscus's dumpster waders");
    item oscusAccessory = ToItem("Oscus's pelt");
    item brimstoneBracelet = ToItem("Brimstone Bracelet");
    item kgb = ToItem("Kremlin's Greatest Briefcase");
    item rubber = ToItem("orcish rubber");
    effect rubberEffect = ToEffect("Using Protection");
// max mana increase
    item hawkings = ToItem("Hawking's Elixir of Brilliance");
    effect hawkingsEffect = ToEffect("On the Shoulders of Giants");
    item occult = ToItem("ointment of the occult");
    effect occultEffect = ToEffect("Mystically Oiled");
    item tomatoJuice = ToItem("tomato juice of powerful power");
    effect tomatoJuiceEffect = ToEffect("Tomato Power");
    item mascara = ToItem("glittery mascara");
    effect mascaraEffect = ToEffect("Glittering Eyelashes");
    item muscleToMyst = ToItem("oil of stability");
    effect muscleToMystEffect = ToEffect("Stabilizing Oiliness");
    item moxieToMyst = ToItem("oil of slipperiness");
    effect moxieToMystEffect = ToEffect("Slippery Oiliness");
    item circleDrum = ToItem("Circle Drum");
    effect circleDrumEffect = ToEffect("Feelin' the Rhythm");
    item sugarShorts = ToItem("sugar shorts");
    skill quietJudgement = ToSkill("Quiet Judgement");
    effect quietJudgementEffect = ToEffect("Quiet Judgement");


// locations for adventuring
    location garbagePirates = ToLocation("Pirates of the Garbage Barges"); // for orphan costume
    location covePirates = ToLocation("The Obligatory Pirate's Cove"); // alternate for orphan costume... wait a second, we should always have main pirates location
    location castleTopFloor = ToLocation("The Castle in the Clouds in the Sky (Top Floor)"); // semi-rare
    location purpleLight = ToLocation("The Purple Light District"); // semi-rare
    location treasury = ToLocation("Cobb's Knob Treasury"); // semi-rare
    location barfMountain = ToLocation("Barf Mountain"); // main adventure location
    location snojo = ToLocation("The X-32-F Combat Training Snowman");

// Maximizing mana for summoning
    location TUNNEL = ToLocation("The Tunnel of L.O.V.E.");
    monster LOVenforcer = ToMonster("LOV Enforcer");
    monster LOVengineer =  ToMonster("LOV Engineer");
    monster LOVequivocator =  ToMonster("LOV Equivocator");
    effect synthMyst = ToEffect("Synthesis: Smart"); // from Sweet Synthesis skill
    effect synthMP = ToEffect("Synthesis: Energy"); // from Sweet Synthesis skill
    item licenseChill = ToItem("License to Chill"); // mana restore
    item yexpressCard = ToItem("Platinum Yendorian Express Card"); // mana restore
    item oscusSoda = ToItem("Oscus's neverending soda");
    item aprilShower = ToItem("Clan Shower");
    item eternalBattery = ToItem("Eternal Car Battery");
    skill discoNap = ToSkill("Disco Nap");
    skill leisure = ToSkill("Adventurer of Leisure");
    skill narcolepsy = ToSkill("Executive Narcolepsy");
    skill turbo = ToSkill("Turbo");
    effect overheated = ToEffect("Overheated");
    item pilgrimHat = ToItem("Giant pilgrim hat");
    item snowFort = ToItem("Snow Fort");
    effect snowFortified = ToEffect("Snow Fortified");
    item clarasBell = ToItem("Clara's bell");
    item hoboBinder = ToItem("hobo code binder");

// healing between turns
    effect beatenUp = ToEffect("Beaten Up");
    skill walrus = ToSkill("Tongue of the Walrus");
    skill cocoon = ToSkill("Cannelloni Cocoon");

// makin' copies, at the copy machine
    item camera = ToItem("4-d camera");
    item usedcamera = ToItem("Shaking 4-d camera");
    item enamorang = ToItem("LOV Enamorang");
    item BACON = ToItem("BACON");
    item printScreen = ToItem("print screen button");
    item usedPrintScreen = ToItem("screencapped monster");
    item spookyPutty = ToItem("Spooky Putty sheet");
    item usedSpookyPutty = ToItem("Spooky Putty monster");
    item rainDoh = ToItem("Rain-Doh black box");
    item usedRainDoh = ToItem("Rain-Doh box full of monster");
    skill digitize = ToSkill("Digitize");
    skill romanticArrow = ToSkill("Fire a badly romantic arrow");
    skill winkAt = ToSkill("Wink at");

    monster embezzler = ToMonster("Knob Goblin Embezzler");
    monster mimeExecutive = ToMonster("cheerless mime executive"); // this was 1500, now it's 500
    monster tourist = ToMonster("garbage tourist");
    skill olfaction = ToSkill("Transcendent Olfaction");
    effect olfactionEffect = ToEffect("On the Trail");

// semi-rare
    item nickel = ToItem("hobo nickel");
    item billiardKey = ToItem("Spookyraven billiards room key");

// barf mountain quest
    item lubeShoes = ToItem("lube-shoes");
    static string kioskUrl = "place.php?whichplace=airport_stench&action=airport3_kiosk";
    static string maintenanceUrl = "place.php?whichplace=airport_stench&action=airport3_tunnels";

// Gingerbread
    location gingerCivic = ToLocation("Gingerbread Civic Center");
    location gingerTrain = ToLocation("Gingerbread Train Station");
    location gingerRetail = ToLocation("Gingerbread Upscale Retail District");
    item gingerHead = ToItem("gingerbread tophat");
    item gingerShirt = ToItem("gingerbread waistcoat");
    item gingerPants = ToItem("gingerbread trousers");
    item gingerAcc1 = ToItem("candy dress shoes");
    item gingerAcc2 = ToItem("candy necktie");
    item gingerAcc3 = ToItem("chocolate pocketwatch");
    item gingerSprinkles = ToItem("sprinkles");

// effect which will confuse KoLmafia
    item greendrops = ToItem("soft green echo eyedrop antidote"); // remove undesirable effects
    item homophones = ToItem("staph of homophones"); // changes words to their homophones
    item prepositions = ToItem("sword behind inappropriate prepositions"); // restructures sentences
    item papier1 = ToItem("Papier mitre"); // inserts random words into sentences
    item papier2 = ToItem("Papier-mâchuridars"); // inserts random words into sentences
    item papier3 = ToItem("papier-masque"); // inserts random words into sentences
    effect disAbled = ToEffect("Dis Abled"); // turns everything into rhymes
    effect anapests = ToEffect("Just the Best Anapests"); // turns everything into rhymes

// free combats
    item genie = ToItem("genie bottle");
    item wish = ToItem("pocket wish");
    effect covetous = ToEffect("Covetous Robbery"); // raises base meat drop on stingy monsters
    effect attunement = ToEffect("Eldritch Attunement"); // take an extra combat after free combat
    effect frosty = ToEffect("frosty"); // +200% meat, +100% item drop
    effect braaaaaains = ToEffect("Braaaaaains"); // +200% meat, -50% item drop
    skill evokeHorror = ToSkill("Evoke Eldritch Horror"); // fight an eldritch horror
    item uraniumSeal = ToItem("depleted uranium seal figurine"); // 5 extra seal fights
    item lynyrdSnare = ToItem("lynyrd snare"); // 3 free fights a day
    item scorpions = ToItem("Bowl of Scorpions"); // 11 free fights a day
    item brickoOoze = ToItem("BRICKO ooze"); // 10 free fights a day
    item brickoBrick = ToItem("BRICKO brick"); // to make oozes from
    item brickoEye = ToItem("BRICKO eye brick"); // also required to make oozes
    location machineTunnels = ToLocation("The Deep Machine Tunnels"); // needs machine elf
    monster machineTriangle = ToMonster("Perceiver of Sensations");
    monster machineCircle = ToMonster("Thinker of Thoughts");
    monster machineSquare = ToMonster("Performer of Actions");
    item abstrThought = ToItem("abstraction: thought");
    item abstrAction = ToItem("abstraction: action");
    item abstrSensation = ToItem("abstraction: sensation");
    location bowlingAlley = ToLocation("The Hidden Bowling Alley");
    item bowlingBall = ToItem("bowling ball");
    monster bowler = ToMonster("pygmy bowler");
    monster janitor = ToMonster("pygmy janitor");
    monster orderlies = ToMonster("pygmy orderlies");
// seal clubber supplies
    item bludgeon = ToItem("Brimstone Bludgeon");
    item tenderizer = ToItem("Meat Tenderizer is Murder");
    item club = ToItem("seal-clubbing club");
    item sealFigurine = ToItem("figurine of a wretched-looking seal");
    item sealCandle = ToItem("seal-blubber candle");

// banish skills and items
    skill snokebomb = ToSkill("Snokebomb");
    item louderThanBomb = ToItem("Louder Than Bomb");
    item tennisBall = ToItem("tennis ball");

// script state variables
    familiar runFamiliar;
    float snowSuitWeight = 0;
    boolean canPickpocket = false;
    boolean canPocketCrumb = false;
    boolean canRaveNirvana = false; // meat drops
    boolean canRaveConcentration = false; // item drops
    boolean canRaveSteal = false; // steal an item
    boolean canAccordionBash = false;
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
    boolean canExtract = false;
    boolean canDuplicate = false;
    boolean canTurbo = false;
    int enamorangsUsed = 0;
    boolean canJokesterGun = false;
    boolean canBatoomerang = false;
    boolean canMissileLauncher = false;
    boolean shouldMissileLauncher = false;
    boolean canShatteringPunch = false;
    boolean canMobHit = false;
    boolean hasFreeKillRemaining = false;
    boolean needBagOTricks = false;
    boolean canMortor = mortarShell.have_skill();
    int digitizeCounter = 0;
    int enamorangCounter = 0;
    int fortuneCookieCounter = 0;
    int spookyravenCounter = 0;
    int maxItemUse = funkslinging.have_skill() ? 2 : 1;
    boolean eatWithoutMayo = false;
    int semiRareAttempted = 0; // once we attempt a semi-rare on a turn, don't retry.  This is the turn number it was attempted 

    boolean ravedNirvana = false;
    boolean ravedSteal = false;
    boolean ravedConcentration = false;
    skill summonCurrent = summonRes;

    int ghostShot = 0;
    int stunRound = 0;
    boolean cursed = false;
    boolean mortored = false;
    boolean micrometeorited = false;
    boolean extracted = false;
    boolean bashed = false;
    boolean bubbled = false;
    boolean noodled = false;

    boolean outfitInitialized = false;
    item[slot] defaultOutfitPieces;
    item[slot] barfOutfitPieces;
    item[slot] dropsOutfitPieces;

// forward declarations of functions:
    void ChooseDropsFamiliar(boolean isElemental);
    boolean TryEquipFamiliarEquipment(item eqp, float eqpBonus);
    void PrepareFamiliar(boolean forMeaty);
    void PrepareMeaty();
    void InitOutfit();
    boolean TryEat(item food, effect desiredEffect, int providedFullness, int followupFullness, int turnLimit, boolean eatUnique);
    void BeforeSwapOutAsdon();
    void BeforeSwapOutMayo();
    void TryReduceManaCost(skill sk);
    void MaxManaSummons();
    void ChooseEducate(boolean duplicate, boolean digitize);
    void ChooseThrall(boolean forMeat);  //, boolean forItems)
    void EquipBjornCrownFamiliars(familiar first, familiar second);
    void ChooseBjornCrownFamiliars(boolean forMeaty, boolean forDrops);
    void ActivateChibiBuddy();
    void ActivateFortuneTeller();


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
        if (autoConfirmBarf)
            return defaultValue;
        return user_confirm(message);
    }
    int LastIndexOf(string page, string match, int beforeIndex) // this doesn't appear to be part of the ASH standard API, not sure why
    {
        int ix = page.index_of(match);
        int result = -1;
        while (ix < beforeIndex && ix >= 0)
        {
            result = ix;
            ix = page.index_of(match, ix + 1);
        }
        return result;
    }
    int FindVariableChoice(string page, string match, boolean matchTextIsButtonText)
    {
        int ix = page.index_of(match);
        if (ix <= 0)
            return -1;

        string optionSearch = "<input type=hidden name=option value=";
        if (matchTextIsButtonText) // the name=option value=1 comes before the button text
            ix = LastIndexOf(page, optionSearch, ix);
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
    void UseOneTotal(item i, effect e)
    {
        if (i.item_amount() > 0 && e.have_effect() == 0)
        {
            use(1, i);
        }
    }
    void BuyAndUseOneTotal(item i, effect e, int maxCost)
    {
        if (e.have_effect() > 0)
            return;
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
        if (itm.to_slot() != famEqp)
            return false;
        familiar[int] myFamiliars = GetFamiliarList();
        foreach id, fam in myFamiliars
        {
            if (fam.familiar_equipped_equipment() == itm)
                return true;
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
    void CheatKnifeIfNeeded(item[slot] outfitDef)
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
    }
    void WearOutfit(item[slot] outfitDef)
    {
        CheatKnifeIfNeeded(outfitDef);
        // remove wrong accessories, in case the slots don't match up
        foreach sl, it in outfitDef
        {
            if ((sl == acc1 || sl == acc2 || sl == acc3) && sl.equipped_item() != it)
            {
                sl.equip("none".to_item());
            }
        }
        foreach sl, it in outfitDef
        {
            if (sl.equipped_item() != it && HaveEquipment(it))
            {
                if (it.have_equipped())
                {
                    if (sl == acc1 || sl == acc2 || sl == acc3) // in case it's in the wrong slot, and need to move it
                        sl.equip("none".to_item());
                }
                sl.equip(it);
            }
        }
    }
    boolean IsAccordion(item it)
    {
        return it.item_type() == "accordion";
    }

// more specific helper functions

    boolean IsMeatyMonster(string monsterName)
    {
        return monsterName == embezzler.to_string();
            //|| monsterName == mimeExecutive.to_string();
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
    void BuyItemIfNeeded(item itm, int numberRequested, int maxPrice)
    {
        int mallPrice = itm.mall_price();
        if (mallPrice <= maxPrice && (itm.item_amount() < numberRequested || mallPrice < 500))
        {
            int buyCount = numberRequested;
            if (buyCount < 1)
                buyCount = 1;
            buy(buyCount, itm);
        }
    }
    void ResetCombatState()
    {
        ravedNirvana = false;
        ravedSteal = false;
        ravedConcentration = false;
        cursed = false;
        micrometeorited = false;
        extracted = false;
        bashed = false;
        bubbled = false;
        noodled = false;
        canPocketCrumb = HaveEquipment(pantsGiving);
    }
    void DisableFreeKills()
    {
        // combat will be free anyway, so don't waste them on this combat
        canJokesterGun = false;
        canBatoomerang = false;
        canMissileLauncher = false;
        canShatteringPunch = false;
        canMobHit = false;
        hasFreeKillRemaining = false;
    }

    void CheckPostCombat(string pageResult, string combatFilter)
    {
        //int[item] itemsGained = extract_items(result);
        //if (my_bjorned_familiar() == orphan || my_enthroned_familiar() == orphan)
        //{
        //    int wadCount = itemsGained[ToItem("hoarded candy wad")];
        //    //if (wadCount > 0)
        //}
        if (attunement.have_effect() > 0 && pageResult.contains_text("fight.php")) // Eldritch attunement means an extra combat
        {
            DisableFreeKills();
            ResetCombatState();
            visit_url("fight.php");
            run_combat(combatFilter);
        }
    }
    void RunCombat(string filter)
    {
        string result = run_combat(filter);
        CheckPostCombat(result, filter);
    }
    void RunAdventure(location loc, string filter)
    {
        string page = visit_url(loc.to_url().to_string());
        if (page.contains_text("choice.php") && page.contains_text("value=\"Tame it!\""))
        {
            run_choice(1); // tame the turtle
            return;
        }
        string combatResult = run_combat(filter);
        CheckPostCombat(combatResult, filter);
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
        else if (summonRes.have_skill())
        {
            summonCurrent = summonRes;
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
            //    // if not saving any mana back, we don't have to take into account the growing costs, the
            //    // server will do that for us
            //    castCount = availableMana / baseManaCost;
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
        if (restoreLimit >= 1000 && get_property("_aprilShower") != true && vipKey.item_amount() > 0 && get_clan_lounge() contains aprilShower)
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
            else if (soulFood.have_skill()
                && ShouldSummonRestore(keepMana, 0, 15, soulsauceBonus))
            {
                use_skill(1, soulFood);
                changed = true;
            }
            BurnManaSummoning(keepMana);
        }
    }
    void HealUp()
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
    int GetFamiliarRunaways()
    {
        int result = (my_familiar().familiar_weight() + weight_adjustment()) / 5;
        result -= get_property("_banderRunaways").to_int();
        return result;
    }
    int GetFreeRunaways()
    {
        return GetFamiliarRunaways() + smokebomb.item_amount() + fishermansack.item_amount() * 3;
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
            if (pieFuel.item_amount() > 0)
                cli_execute("asdonmartin fuel 1 " + pieFuel.to_string());
            else
            {
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
    item[slot] GetModifiableOutfit(boolean forDrops)
    {
        InitOutfit();
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
            i.to_slot().equip("none".to_item());
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
        RemoveConfusionEffects(disAbled);
        RemoveConfusionEffects(anapests);
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



    void PrepareStandardFilter()
    {
        needsCleesh = false; // always reset this, don't want to cleesh on accident
        ResetCombatState();
        if (!canPickpocket)
        {
            canPickpocket = my_class().to_string() == "Disco Bandit" || my_class().to_string() == "Accordion Thief";
            if (my_class().to_string() == "Disco Bandit")
            {
                canRaveNirvana = get_property("raveCombo5") != "";
                canRaveConcentration = get_property("raveCombo3") != "";
                canRaveSteal = get_property("raveCombo4") != "" && get_property("_raveStealCount").to_int() < 30;
            }
        }
        canPocketCrumb = HaveEquipment(pantsGiving);

        canAccordionBash = accordionBash.have_skill()
            && IsAccordion(weapon.equipped_item())
            && bakeBackpack.have_equipped();

        needsMeteorShower = meteorShower.have_skill()
            && runFamiliar != orphan
            && get_property("_meteorShowerUses").to_int() < 5;

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
        if (digitizeCount < 3)
        {
            int digitizeRange = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
            if (digitizeRange >= 4)
                needsDigitize = true;
            else if (my_turnCount() >= digitizeCounter && digitizeRange == 3)
            {
                needsDigitize = true;
                needBagOTricks = true;
            }
                
        }
        ChooseEducate(false, needsDigitize);

        needsEnamorang = enamorang.item_amount() > 0 && get_property("enamorangMonster") == "";
        needsCamera = usedCamera.item_amount() == 0 && camera.item_amount() > 0;
        needsPrintScreen = printScreen.item_amount() > 0 && get_property("screencappedMonster") == "";
        needsRainDoh = rainDoh.item_amount() > 0 && usedRainDoh.item_amount() == 0;
        needsSpookyPutty = spookyPutty.item_amount() > 0 && usedSpookyPutty.item_amount() == 0;

        canJokesterGun = get_property("_firedJokestersGun") == "false"
            && jokesterGun.have_equipped();

        canMissileLauncher = PrepareAsdonLauncher();

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
        hasFreeKillRemaining =
            canJokesterGun
            || canBatoomerang
            || canMissileLauncher
            || canShatteringPunch
            || canMobHit;

        RemoveConfusionEffects(false);
        HealUp();
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
                needsRomanticArrow = false;
                return "skill " + romanticArrow.to_string();
            }
            if (needsWinkAt)
            {
                needsWinkAt = false;
                return "skill " + winkAt.to_string();
            }
            if (needsDigitize)
            {
                needsDigitize = false;
                return "skill " + digitize.to_string();
            }
            if (needsMeteorShower)
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
            // free kill, needs to go last in the items.  Also Jokester's gun gets first
            // priority because we don't want to equip that more than 1 turn
            if (canBatoomerang && itemCount < maxItemUse && !canJokesterGun)
            {
                if (itemCount == 1)
                    s += ",";
                s += replicaBatoomerang.to_string();
                canBatoomerang = false;
                itemCount++;
            }
            if (itemCount > 0)
            {
                if (itemCount == 1)
                    s += ",none";
                return "item " + s;
            }
        }
        if (canPickpocket && can_still_steal()) // don't bother pickpocketing the embezzler, priority is copying and free kills
        {
            return "\"pickpocket\"";
        }
        if (mon == tourist && olfaction.have_skill() && olfactionEffect.have_effect() == 0 && my_mp() > 50)
        {
            return "skill " + olfaction.to_string();
        }
if (false) // TODO: free kills are now worthless for farming, don't waste them here
{
        if (canMissileLauncher && shouldMissileLauncher)
        {
            // if "shouldMissileLauncher" is true, takes precedence over jokester's gun
            canMissileLauncher = false;
            return "skill " + missileLauncher.to_string();
        }
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
            return "skill " + shatteringPunch.to_string();
        }
        if (canMobHit)
        {
            canMobHit = false;
            return "skill " + gingerbreadMobHit.to_string();
        }
}
        if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
        {
            cursed = true;
            return "skill " + curseOfWeaksauce.to_string();
        }
        if (expected_damage() * 8 > my_hp())
        {
            if (CanCast(micrometeorite) && !micrometeorited) // reduce damage taken
            {
                micrometeorited = true;
                return "skill " + micrometeorite.to_string();
            }
        }
        if (canAccordionBash)
        {
            canAccordionBash = false;
            return "skill Accordion Bash";
        }
        if (needsMayfly)
        {
            needsMayfly = false;
            return "skill Summon Mayfly Swarm";
        }
        if (extractJelly.have_skill() && !extracted)
        {
            extracted = true;
            return "skill " + extractJelly.to_string();
        }
        boolean CanCombo = my_hp() > 100
            && (expected_damage() * 4 < my_hp()); // a combo will take 3 turns to execute, so make sure we can survive 4

        // rave checks come after embezzler special handling, because we could accidentally kill embezzler too early
        if (canRaveNirvana && CanCombo) // increase meat drops
        {
            if (!ravedNirvana)
            {
                ravedNirvana = true;
                return "combo rave nirvana";
            }
        }
        if (mon == mimeExecutive // tough scaling monster, don't want to dink around while getting beat up
            || round > 18) // maybe for a damage immune wandering monster?
        {
            if (canMortor && !mortored)
            {
                mortored = true;
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
            return "skill Turbo";
        }
        if (canRaveConcentration && CanCombo) // increase item drops
        {
            if (!ravedConcentration)
            {
                ravedConcentration = true;
                return "combo rave concentration";
            }
        }
        if (canExtract && my_mp() > 10)
        {
            canExtract = false;
            return "skill " + extract.to_string();
        }
        if (canPocketCrumb)
        {
            canPocketCrumb = false;
            return "skill " + pocketCrumbs.to_string();
        }

        if (canRaveSteal && CanCombo) // sometimes steals an item, but don't do it in long running or difficult fights
        {
            if (!ravedSteal)
            {
                ravedSteal = true;
                return "combo rave steal";
            }
        }
            
        return "";
    }

    string Filter_Seal(int round, monster mon, string page)
    {
        if (CanCast(curseOfWeaksauce) && !cursed) // reduce damage taken
        {
            cursed = true;
            return "skill " + curseOfWeaksauce.to_string();
        }
        return "skill " + thrustSmack.to_string();
    }

    int PuttyCopiesRemaining()
    {
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
        int count = 0;
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
        return false;
    }


    void InitOutfit()
    {
        if (outfitInitialized)
            return;
        outfitInitialized = true;
        foreach ix, it in outfit_pieces(defaultOutfit)
        {
            slot s = it.to_slot();
            if (s == acc1 || s == acc2 || s == acc3)
            {
                if (defaultOutfitPieces[acc1].to_string() == "none")
                    defaultOutfitPieces[acc1] = it;
                else if (defaultOutfitPieces[acc2].to_string() == "none")
                    defaultOutfitPieces[acc2] = it;
                else if (defaultOutfitPieces[acc3].to_string() == "none")
                    defaultOutfitPieces[acc3] = it;
                else
                    abort("Not enough slots for accessory " + it);
            }
            else
                defaultOutfitPieces[s] = it;
        }
        foreach ix, it in outfit_pieces(dropsOutfit)
        {
            slot s = it.to_slot();
            if (s == acc1 || s == acc2 || s == acc3)
            {
                if (dropsOutfitPieces[acc1].to_string() == "none")
                    dropsOutfitPieces[acc1] = it;
                else if (dropsOutfitPieces[acc2].to_string() == "none")
                    dropsOutfitPieces[acc2] = it;
                else if (dropsOutfitPieces[acc3].to_string() == "none")
                    dropsOutfitPieces[acc3] = it;
                else
                    abort("Not enough slots for accessory " + it);
            }
            else
                dropsOutfitPieces[s] = it;
        }
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
        if (bjorn.have_equipped() && first.to_string() != "none")
        {
            if (my_bjorned_familiar() != first)
            {
                first.bjornify_familiar();
                first = second;
            }
        }
        if (crown.have_equipped() && first.to_string() != "none")
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
    void ChooseBjornCrownFamiliars(boolean forMeaty, boolean forDrops)
    {
        if (!bjorn.have_equipped() && !crown.have_equipped())
            return;

        familiarPair choice;
        choice = ChooseBjornCrownFamiliar(choice, leprechaun);
        choice = ChooseBjornCrownFamiliar(choice, obtuseAngel);
        if (!forMeaty) // can't choose one that does damage
            choice = ChooseBjornCrownFamiliar(choice, hoboMonkey);
        choice = ChooseBjornCrownFamiliar(choice, goldenMonkey);
        choice = ChooseBjornCrownFamiliar(choice, happyMedium);
        choice = ChooseBjornCrownFamiliar(choice, organGrinder);
        if (forDrops && get_property("_abstractionDropsCrown").to_int() < 20)
            choice = ChooseBjornCrownFamiliar(choice, machineElf);
        if (forDrops && get_property("_hoardedCandyDropsCrown").to_int() < 3)
            choice = ChooseBjornCrownFamiliar(choice, orphan);
        if (forDrops && get_property("_garbageFireDropsCrown").to_int() < 3)
            choice = ChooseBjornCrownFamiliar(choice, garbageFire);
// todo: if robortender, maybe do weight buff instead

        EquipBjornCrownFamiliars(choice.first, choice.second);
    }
    void ActivateMumming()
    {
        if (mumming.item_amount() > 0)
        {
            if (my_familiar() != runFamiliar)
                SwitchToFamiliar(runFamiliar);
            if (my_familiar().to_string() == "none")
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

    void PrepareFamiliar(boolean forMeaty)
    {
        if (my_familiar() != runFamiliar)
            SwitchToFamiliar(runFamiliar);
        ChooseBjornCrownFamiliars(forMeaty, false);
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
            if (moveableFeast.item_amount() > 0
                && get_property("_feastUsed").to_int() < 5
                && !get_property("_feastFamiliars").contains_text(runFamiliar.to_string()))
            {
                use(1, moveableFeast);
            }
        }

        if (HaveEquipment(snowSuit))
            snowSuitWeight = snowSuit.numeric_modifier("Familiar Weight");

        if (TryEquipFamiliarEquipment(petSweater, 10))
            return;
        if (forMeaty && TryEquipFamiliarEquipment(sugarShield, 10))
            return;
        if (get_property("_mayflowerDrops").to_int() < 5 && !forMeaty && TryEquipFamiliarEquipment(mayflower, 6.1))
        {
            // mayflower drops take precedence over weight bonus unless embezzler
            return;
        }
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
        item best = "none".to_item();
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
    boolean TryScratchNSniff()
    {
        float meatMultiplier = 1000 * 20 / 100; // 20 embezzlers * 1000 meat / 100 percent
        float currentWeaponMeat = meatMultiplier * weapon.equipped_item().numeric_modifier("Meat Percent");
        float scratchMeat = meatMultiplier * 75; // 75% from 3 stickers
        float difference = scratchMeat - currentWeaponMeat;
        if (difference < 300 || scratchUPC.mall_price() * 3 > difference)
            return false;

        item eq;
        if (HaveEquipment(scratchXbow))
            eq = scratchXbow;
        else
            eq = scratchSword;
        if (sticker1.equipped_item().to_string() == "none"
            && sticker2.equipped_item().to_string() == "none"
            && sticker3.equipped_item().to_string() == "none")
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
        weapon.equip(eq);
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
        WearOutfit(SwapOutSunglasses(defaultOutfitPieces));
        if (HaveEquipment(jokesterGun)
            && jokesterGun.can_equip()
            && get_property("_firedJokestersGun") == "false")
        {
            weapon.equip(jokesterGun);
            canJokesterGun = true;
        }
        else if (!TryScratchNSniff())
        {
        }

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


    void PrepareBarf(boolean RequireOutfit)
    {
        InitOutfit();
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

        if (!hasFreeKillRemaining && HaveEquipment(mayfly) && get_property("_mayflySummons").to_int() < 30)
        {
            if (!mayflyEq)
                barfOutfitPieces[acc1] = mayfly;
            needsMayfly = true;
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
    boolean TryRunWitchess(string filter)
    {
        if (get_campground() contains witchess
            && get_property("_witchessFights").to_int() < 5)
        {
            visit_url("campground.php?action=witchess", false);
            run_choice(1);
            // fight the knight, because we eat a lot of horseradish
            visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1936", false);
            RunCombat(filter);
            return true;
        }
        return false;
    }
    boolean TryRunSnojo(string filter)
    {
        if (get_property("snojoAvailable").to_boolean()
            && get_property("_snojoFreeFights").to_int() < 10)
        {
            if (get_property("snojoSetting") == "NONE")
            {
                print("Cannot run snojo because it hasn't been configured yet", printColor);
                return false;
            }
            RunAdventure(snojo, filter);
            return true;
        }
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

    int CountFreeCombatsAvailable(boolean nextDay)
    {
        int count = 0;
        if (get_property("snojoAvailable").to_boolean())
            count += 10 - get_property("_snojoFreeFights").to_int();
        if (get_campground() contains witchess)
            count += 5 - get_property("_witchessFights").to_int();
        count += 10 - get_property("_brickoFights").to_int();
        count += 3 - get_property("_lynyrdSnareUses").to_int();
        if (my_class().to_string() == "Seal Clubber")
        {
            count += 5 - get_property("_sealsSummoned").to_int();
            if (uraniumSeal.item_amount() > 0)
                count += 5;
        }
        if (machineElf.have_familiar())
            count += 5 - get_property("_machineTunnelsAdv").to_int();

        if (attunement.have_effect() > 0) // if we have Eldritch attunement, get an extra free fight after each
        {
            count *= 2;
            count += 11 - get_property("_drunkPygmyBanishes").to_int();
        }

        // the remaining free fights don't trigger eldritch attunement:

        if (get_property("_eldritchTentacleFought") == "false")
            count += 1;
        if (evokeHorror.have_skill() && get_property("_eldritchHorrorEvoked") == "false")
            count += 1;
        return count;
    }
    void PrepareFreeCombat(item[slot] selectedOutfit, familiar chosenFamiliar)
    {
        if (my_familiar() != chosenFamiliar)
            SwitchToFamiliar(chosenFamiliar);
        InitOutfit();
        WearOutfit(SwapOutSunglasses(selectedOutfit));
        ChooseBjornCrownFamiliars(false, true);
        ChooseThrall(true);
        RemoveConfusionEffects(false);
        HealUp();
        ResetCombatState();
    }
    void PrepareFreeCombat(item[slot] selectedOutfit)
    {
        PrepareFreeCombat(selectedOutfit, runFamiliar);
    }
    int snokebombTurn = 0;
    int politicsTurn = 0;
    int kgbDartTurn = 0;
    int louderThanBombTurn = 0;
    int tennisballTurn = 0;
    boolean batterUpUsed = false;
    boolean nanorhinoUsed = false;
// todo: check if we actually have these skills/items
    string Filter_BowlingAlley(int round, monster mon, string page)
    {
        if (mon == bowler || mon == orderlies || mon == janitor)
        {
            if (snokebombTurn < my_turnCount())
            {
                snokebombTurn = my_turnCount() + 30;
                return "skill Snokebomb";
            }
            if (kgbDartTurn < my_turnCount())
            {
                kgbDartTurn = my_turnCount() + 20;
                return "skill KGB tranquilizer dart";
            }
            if (louderThanBombTurn < my_turnCount())
            {
                louderThanBombTurn = my_turnCount() + 20;
                return "item " + louderThanBomb + ",none";
            }
            if (tennisballTurn < my_turnCount())
            {
                tennisballTurn = my_turnCount() + 30;
                return "item " + tennisBall + ",none";
            }
            if (politicsTurn < my_turnCount())
            {
                politicsTurn = my_turnCount() + 30;
                return "skill Talk About Politics";
            }
        }
        return Filter_Standard(round, mon, page);
    }
    boolean abstractioned = false;
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
        if (!abstractioned)
        {
            if (mon == machineTriangle) // triangle monster
            {
                abstractioned = true;
                if (abstrThought.item_amount() > 0)
                    return "item " + abstrThought + ",none";
            }
            else if (mon == machineCircle) // circle monster
            {
                abstractioned = true;
                if (abstrAction.item_amount() > 0)
                    return "item " + abstrAction + ",none";
            }
            else if (mon == machineSquare) // square monster
            {
                abstractioned = true;
                if (abstrSensation.item_amount() > 0)
                    return "item " + abstrSensation + ",none";
            }
        }
        return Filter_Standard(round, mon, page);
    }
    
    boolean RunFreeCombat(item[slot] selectedOutfit, string filter)
    {
        if (get_property("_eldritchTentacleFought") == "false")
        {
            PrepareFreeCombat(selectedOutfit);
            string page = visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
            int choiceId = FindVariableChoice(page, "Can I fight that tentacle you saved for science?", true);
            if (choiceId >= 0)
            {
                run_choice(choiceId, false);
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
        if (machineElf.have_familiar() && get_property("_machineTunnelsAdv").to_int() < 5)
        {
            PrepareFreeCombat(selectedOutfit, machineElf);
            abstractioned = false;
            RunAdventure(machineTunnels, "Filter_MachineTunnels");
            return true;
        }
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
        if (attunement.have_effect() > 0 && get_property("_drunkPygmyBanishes").to_int() < 11 && scorpions.item_amount() > 0)
        {
            // you don't get bonus from these fights, but they should trigger eldritch attunement fights
            if (scorpions.item_amount() < 11)
            {
                buy(11 - scorpions.item_amount(), scorpions);
            }
            PrepareFreeCombat(selectedOutfit);
            if (bowlingBall.item_amount() > 0)
                put_closet(bowlingBall.item_amount(), bowlingBall);
            RunAdventure(bowlingAlley, "Filter_BowlingAlley");
            return true;
        }
        if (get_property("snojoAvailable") == "true" && get_property("_snojoFreeFights").to_int() < 10)
        {
            PrepareFreeCombat(selectedOutfit);
            if (TryRunSnojo(filter))
                return true;
        }
        if (get_campground() contains witchess
            && get_property("_witchessFights").to_int() < 4) // save one for manual running to cast duplicate
        {
            PrepareFreeCombat(selectedOutfit);
            if (TryRunWitchess(filter))
                return true;
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
    boolean RunFreeCombat(item[slot] selectedOutfit)
    {
        string filter = "Filter_Standard"; // this might need to change
        return RunFreeCombat(selectedOutfit, filter);
    }
    boolean RunFreeCombat()
    {
        return RunFreeCombat(GetModifiableOutfit(true));
    }

    void FreeCombatsForProfit()
    {
        if (covetous.have_effect() > 0)
        {
            HealUp();
            while (RunFreeCombat())
            {
                if (beatenUp.have_effect() > 0)
                    abort("Lost during free combat, do you need to adjust your combat parameters?");
            }
        }
    }
    

    void EnsureSingleHandedWeapon()
    {
        if (weapon.equipped_item().weapon_hands() < 2)
            return;
        weapon.equip("none".to_item());
    }
    void EquipDropsItems()
    {
        if (scratchSword.have_equipped() || scratchXbow.have_equipped())
        {
            weapon.equip("none".to_item());
            foreach ix,itm in outfit_pieces(defaultOutfit)
            {
                if (itm.to_slot() == weapon)
                {
                    weapon.equip(itm);
                    break;
                }
            }
        }
        EnsureSingleHandedWeapon();
        if (snowglobe.item_amount() > 0)  // don't benefit from meat drop, may as well get a bonus item drop
            offhand.equip(snowglobe);
        if (screege.item_amount() > 0 && !screege.have_equipped())
            acc1.equip(screege);
        if (cheeng.item_amount() > 0 && !cheeng.have_equipped())
            acc2.equip(cheeng);
        ChooseBjornCrownFamiliars(false, true); // drops familiar
    }

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


    void TryActivateBagOTricks()
    {
        if (!HaveEquipment(bagOtricks))
            return;
        if (HaveBagOTricksBuff())
            return;
        if (AvailableSpellForBagOfTricks() == "")
            return;
        if (get_property("_bagOTricksBuffs").to_int() >= 3) // max 3 per day
            return;
        item[slot] eqSet = GetModifiableOutfit(covetous.have_effect() > 0);
        item oldOffhand = offhand.equipped_item();
        eqSet[offhand] = bagOtricks;
        if (eqSet[weapon].weapon_hands() >= 2)
        {
            // two handed-weapon, how do we deal with this?  don't want to fight empty-handed
            eqSet[weapon] = "none".to_item();
        }
        if (bagOtricks.have_equipped())
        {
            RunFreeCombat(eqSet, "Filter_BagOTricks");
        }
        offhand.equip(oldOffhand);
    }
    boolean TryActivatePantsgivingFullness()
    {
        if (!HaveEquipment(pantsGiving))
            return false;
        if (my_fullness() != fullness_limit())
            return false;

        item[slot] eqSet = GetModifiableOutfit(covetous.have_effect() > 0);
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
                TryActivateBagOTricks();
                continue;
            }
            else
            {
                if (!RunFreeCombat(eqSet))
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
        if (loc == palindome)
        {
            acc3.equip(talisman);
        }
        else if (loc == icyPeak)
        {
            outfit("eXtreme Cold-Weather Gear"); // need 5 resist to visit location
        }
        if (!protonPack.have_equipped())
        {
            if (protonPack.item_amount() < 1)
                return;
            back.equip(protonPack);
        }
        if (!IsAccordion(weapon.equipped_item())
            && accordionBash.have_skill())
        {
            weapon.equip(antiqueAccordion);
        }
    }
    void ChooseDropsFamiliar(boolean isElemental)
    {
        if (sandworm.have_familiar() && get_property("_aguaDrops").to_int() < 5)
        {
            SwitchToFamiliar(sandworm); // drops agua de vida
            return;
        }
        if (fistTurkey.have_familiar() && get_property("_turkeyBooze").to_int() < 5)
        {
            SwitchToFamiliar(fistTurkey); // drops booze
            return;
        }
        if (isElemental && jellyfish.have_familiar() && get_property("_spaceJellyfishDrops").to_int() < 3)
        {
            SwitchToFamiliar(jellyfish); // drops jelly
            return;
        }
        if (intergnat.have_familiar())
        {
            SwitchToFamiliar(intergnat); // drops bacon
            return;
        }
        if (robin.have_familiar())
        {
            SwitchToFamiliar(intergnat); // drops eggs
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
        if (ToSkill("Mariachi Memory").have_skill())
            songSpace++;

        boolean[string] songs = // boolean whether we should shrug the buff.  Stuff that's relevant to meat farming shouldn't be shrugged
        {
            "The Moxious Madrigal"                   : true,
            "The Magical Mojomuscular Melody"        : true,
            "Cletus's Canticle of Celerity"          : true,
            "Power Ballad of the Arrowsmith"         : true,
            "Polka of Plenty"                        : false, // buffs meat drops
            "Jackasses' Symphony of Destruction"     : true,
            "Fat Leon's Phat Loot Lyric"             : false, // buffs item drops
            "Brawnee's Anthem of Absorption"         : true,
            "Psalm of Pointiness"                    : true,
            "Stevedave's Shanty of Superiority"      : true,
            "Aloysius' Antiphon of Aptitude"         : true,
            "Ode to Booze"                           : true,
            "The Sonata of Sneakiness"               : true,
            "Carlweather's Cantata of Confrontation" : true,
            "Ur-Kel's Aria of Annoyance"             : true,
            "The Ballad of Richie Thingfinder"       : false, // buffs item and meat drops
            "Benetton's Medley of Diversity"         : true,
            "Elron's Explosive Etude"                : true,
            "Chorale of Companionship"               : false, // buffs pet weight
            "Prelude of Precision"                   : true,
            "Donho's Bubbly Ballad"                  : true,
            "Cringle's Curative Carol"               : true,
            "Inigo's Incantation of Inspiration"     : true  
        };

        int activeSongs = songSpace;
        while (activeSongs >= songSpace)
        {
            activeSongs = 0;
            string shrugBuff = "";
            string song;
            boolean canRemove;

            foreach song, canRemove in songs
            {
                if (ToEffect(song).Have_effect() > 0)
                {
                    activeSongs++;
                    if (canRemove)
                        shrugBuff = song;
                }
            }
    
            if (activeSongs >= songSpace && shrugBuff != "")
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
        //    choice = verminThrall;
        //    toBind = verminThrallSkill;
        //    mpCost = 200;
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
        if (loc.to_string() == "none")
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
            if (maxPrice > 0)
            {
                BuyItemIfNeeded(itm, useCount - itm.item_amount(), maxPrice);
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

    int kgbManaBonus = 1; // -1 means hasn't been checked yet, should be 0 or -3

    void TryReduceManaCost(skill forSkill)
    {
        if (mysticality.my_basestat() >= 200
            && HaveEquipment(oscusWeapon)
            && HaveEquipment(oscusPants)
            && HaveEquipment(oscusAccessory))
        {
            if (weapon_hands(weapon.equipped_item()) > 1)
                weapon.equip("none".to_item());
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

    void CastSkill(skill sk, effect resultingEffect, int requestedTurns, int maxExpectedTurnsPerCast)
    {
        if (resultingEffect.have_effect() >= requestedTurns || !sk.have_skill())
            return;
        TryReduceManaCost(sk);
        while (resultingEffect.have_effect() < requestedTurns && sk.have_skill())
        {
            if (sk.mp_cost() > my_mp())
            {
                if (FreeDailyManaRestore()) // this can change equipment, so need to swap back
                    TryReduceManaCost(sk);
                if (sk.mp_cost() > my_mp())
                    restore_mp(sk.mp_cost() - my_mp());
            }
            int beforeTurns = resultingEffect.have_effect();
            int timesCast = (requestedTurns - resultingEffect.have_effect() + maxExpectedTurnsPerCast - 1) / maxExpectedTurnsPerCast;
            if (timesCast <= 0)
            {
            }
            if (sk.mp_cost() * timesCast > my_mp())
            {
                timesCast = my_mp() / sk.mp_cost();
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

    boolean BuyCashews(int count, boolean preferCashews)
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
        if (preferCashews)
        {
            if (buy(count, cashew))
                return true;
        }
        while (count > 0)
        {
            if (!buy(1, cornucopia))
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

    boolean AcquireFeast(item food, int cashewCost)
    {
        if (food.item_amount() > 0)
            return true;

        item cashewIngredient = "none".to_item();
        item foodIngredient = "none".to_item();
        foreach ingr in food.get_ingredients()
        {
            if (ingr.fullness > 0)
                foodIngredient = ingr;
            else
                cashewIngredient = ingr;
        }
        if (cashewIngredient.to_int() < 0 || foodIngredient.to_int() < 0)
        {
            abort("Invalid ingredients for " + food.to_string());
        }
        int finishedPrice = food.mall_price();
        int ingredientPrice = cashewIngredient.mall_price() + foodIngredient.mall_price();
        int cashewPrice = cashew.mall_price() * cashewCost + foodIngredient.mall_price();
        int cornucopiaPrice = cornucopia.mall_price() * cashewCost / 3; // assume average of 3 cashews per cornucopia
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
        if (cashewIngredient.item_amount() == 0)
        {
            if (!BuyCashews(cashewCost - cashew.item_amount(), cashewPrice < cornucopiaPrice))
                return false;
            if (!cashewIngredient.seller.buy(1, cashewIngredient))
                return false;
        }
        return craft("cook", 1, cashewIngredient, foodIngredient) > 0;
    }

    boolean TrySpleenSpace(int providedSpleen)
    {
        while (!RoomToSpleen(providedSpleen))
        {
            if (get_property("currentMojoFilters").to_int() >= 3 || my_spleen_use() == 0)
                return false;

           BuyItemIfNeeded(mojoFilter, 1, 6000);
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
        if (booze.item_amount() < 1)
            return;
        if (desiredEffect.have_effect() >= turnLimit)
            return;
        if (!RoomToDrink(providedDrunk))
            return;

        if (odeToBoozeEffect.have_effect() < providedDrunk)
        {
            if (odeToBooze.have_skill())
                CastSkill(odeToBooze, odeToBoozeEffect, providedDrunk, 25);
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
        if (HaveEquipment(pinkyRing))
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
                    && mayoClinic.item_amount() > 0
                    && UserConfirmDefault("Mayo clinic not installed, do you wish to install for eating?", true))
                {
                    BeforeSwapOutAsdon();
                    use(1, mayoClinic);
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
        if (RoomToEat(2)) { return TryEat(thanks1, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks2, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks3, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks4, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks5, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks6, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks7, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks8, thanksgetting, 2, 0, infTurns, unique); }
        if (RoomToEat(2)) { return TryEat(thanks9, thanksgetting, 2, 0, infTurns, unique); }
        return false;
    }
    boolean TryBonusSpinThanksgetting()
    {
        if (timeSpinner.item_amount() < 0) // no time spinner
            return false;
        if (get_property("_timeSpinnerMinutesUsed") > 7) // no time left
            return false;
        ConsumeMayo(false);
        UseItem(milk, gotmilk, 2, 20, 2000);
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

        if (!RoomToEat(providedFullness))
            return false;
        UseItem(milk, gotmilk, 2, 20, 2000);

        boolean convertToDrunk = RoomToDrink(1) && !RoomToEat(providedFullness + followupFullness);
        ConsumeMayo(convertToDrunk);

        if (get_property("barrelShrineUnlocked") == "true"
            && my_class().to_string() == "Turtle Tamer"
            && get_property("_barrelPrayer") != "true")
        {
            cli_execute("barrelprayer buff");
        }

        eat(1, food);
        return true;
    }

    item meatBuffCandy1, meatBuffCandy2;
    void ChooseSweetMeat(int[item] candies1, int[item] candies2)
    {
        foreach candy1, count1 in candies1
        {
            if (count1 < 1)
                continue;
            foreach candy2, count2 in candies2
            {
                if (count2 < 1)
                    continue;
                if (candy1 == candy2 && count2 < 2)
                    continue;
                meatBuffCandy1 = candy1;
                meatBuffCandy2 = candy2;
                return;
            }
        }
    }

    // convert strings to the corresponding item and count in inventory
    int[item] ToItemAndCount(string[] items)
    {
        int[item] result;
        foreach ix,s in items
        {
            item i = ToItem(s);
            result[i] = i.item_amount();
        }
        return result;
    }
    
    void SweetMeat(int requestedTurns)
    {
        if (!sweetSynth.have_skill())
            return;

        if (synthGreed.have_effect() >= requestedTurns)
            return;

        print("Doing sweet synthesis for +300% meat", printColor);

        // Since this is used for farming, don't want to waste irreplacible candy (even if it's
        // temporarily cheaper).  Only use stuff which is relatively easy to replace.

        string[] temp;

        // pair 1: w&w/crimbo candied pecan/breath mint with itself
        temp =
        {
            "bag of W&Ws", // trick or treat
            "Crimbo Candied Pecan", // summon crimbo candy
            "breath mint", // glass gnoll eye once a day
            "Now and Earlier",
            "abandoned candy",
            "Wax Flask",
            "piece of after eight",
            "licorice root",
            "garbage-juice flavored Hob-O",
            "Necbro wafers",
            "sugar shank",
        };
        int[item] candy1_1 = ToItemAndCount(temp);

        // pair 2: dweebs or crimbo fudge with peez or hoarded candy wad
        temp =
        {
            "Dweebs", // trick or treat
            "Crimbo Fudge", // summon crimbo candy
            "sugar-coated pine cone",
            "PlexiPips",
            "sugar shillelagh",
            "licorice boa",
            "double-ice gum",
            "fry-oil-flavored Hob-O",
            "Good 'n' Slimy",
            "black candy heart",
            "fruitfilm",
            "fudge spork",
            "peanut brittle shield",
            "irradiated candy cane",
            "bag of many confections",
        };

        int[item] candy2_1 = ToItemAndCount(temp);
        temp =
        {
            "Peez dispenser", // trick or treat
            "hoarded candy wad", // from buddy bjorn + orphan tot
            "Atomic Pop",
            "Pain Dip",
            "Gummi-DNA",
            "spooky sap",
            "nanite-infested candy cane",
            "sugar chapeau",
            "dubious peppermint",
            "sugar shirt",
            "strawberry-flavored Hob-O",
        };
        int[item] candy2_2 = ToItemAndCount(temp); 

        // pair 3: milk studs with swizzler
        temp =
        {
            milkStud.to_string(), // trick or treat
            "frostbite-flavored Hob-O",
            "Nuclear Blastball",
            "ribbon candy",
            "children of the candy corn",
            "elderly jawbreaker",
           
        };
        int[item] candy3_1 = ToItemAndCount(temp);
        temp =
        {
            swizzler.to_string(),
            //"nasty gum", // does this drop from robortender?  Maybe I just bought a bunch on the market
            "Comet Drop",
            "sterno-flavored Hob-O",
            "Fudgie Roll",
        };
        int[item] candy3_2 = ToItemAndCount(temp);
        candy3_2[swizzler] += swizzler.closet_amount();
        

        while (synthGreed.have_effect() < requestedTurns && TrySpleenSpace(1))
        {
            print("Calculating candies...", printColor);
            meatBuffCandy1 = "none".to_item();
            meatBuffCandy2 = "none".to_item();
            ChooseSweetMeat(candy3_1, candy3_2);
            ChooseSweetMeat(candy2_1, candy2_2);
            ChooseSweetMeat(candy1_1, candy1_1);
            if (meatBuffCandy1.to_string() == "none" || meatBuffCandy2.to_string() == "none")
            {
                print("Out of candy for sweet synthesis, skipping", printColor);
                break;
            }
            if (meatBuffCandy1 == swizzler || meatBuffCandy2 == swizzler)
            {
                take_closet(swizzler.closet_amount(), swizzler);
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
        if (booze.item_amount() <= 0)
        {
            if (!UserConfirmDefault("Don't have Robotender booze " + booze.to_string() + " for " + purpose + ", do you wish to continue?", purpose != "meat"))
                abort("Cannot buff Robortender, no " + booze.to_string());
        }
    }
    void FeedRobortender(item booze, string drinkList)
    {
        if (booze.item_amount() > 0 && !InList(booze.to_string(), drinkList, ","))
            cli_execute("robo " + booze.name);
    }
    void FeedRobotender()
    {
        if (!robort.have_familiar())
            return;

        string drinkList = get_property("_roboDrinks");

        ValidateRobortender(roboMeat, drinkList, "meat");
        ValidateRobortender(roboItems, drinkList, "item");
        ValidateRobortender(roboMana, drinkList, "mana");
        ValidateRobortender(roboHobo, drinkList, "hobo");
        ValidateRobortender(roboCandy, drinkList, "candy");
        if (get_property("_roboDrinks") == "")
        {
            SwitchToFamiliar(robort);
            FeedRobortender(roboMeat, drinkList);
            FeedRobortender(roboItems, drinkList);
            FeedRobortender(roboMana, drinkList);
            FeedRobortender(roboHobo, drinkList);
            FeedRobortender(roboCandy, drinkList);
        }
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
            if (UserConfirmDefault("Fullness at " + my_fullness() + " / " + fullness_limit() + ", do you wish to switch to Asdon Martin for buffing?", true))
            {
                BeforeSwapOutMayo();
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
            cli_execute("briefcase b " + keyword);
            if (effectTurns == kgbBuff.have_effect())
            {
                print("KGB buff failed, is Ezandora's briefcase script installed?  Are you out of clicks for the day?", "red");
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
        cli_execute("briefcase martinis"); // make sure to get martinis first
        KGBBuff(turns, kgbMeat, "meat");
        KGBBuff(turns, kgbItems, "item");
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

    void AcquireFullFeast()
    {
        cli_execute("acquire 8 jumping horseradish");
        AcquireFeast(thanks1, 1);
        AcquireFeast(thanks2, 1);
        AcquireFeast(thanks3, 1);
        AcquireFeast(thanks4, 2);
        AcquireFeast(thanks5, 2);
        AcquireFeast(thanks6, 2);
        AcquireFeast(thanks7, 3);
        AcquireFeast(thanks8, 3);
        AcquireFeast(thanks9, 3);
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
        float meatmodifier = 1 + (meat_drop_modifier() / 100.0);
        expectedMeatPerAdventure *= meatmodifier;
        expectedMeatPerAdventure -= 400; // subtract 400 for potential cost to get the adventure, particularly bricko and lynyrd
        float expectedMeat = freeCombats * expectedMeatPerAdventure;
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
            CastSkill(limitedSkill, limitedEffect, turns, 25);
        }
    }


    void BuffTurns(int turns)
    {
        boolean needWeightBuffs = true;
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

        if (runFamiliar == orphan)
        {
            needWeightBuffs = false;
            GetPirateCostume();
        }
        else if (runFamiliar.name == "none")
        {
            needWeightBuffs = false;
        }
        else if (runFamiliar == robort)
        {
            if (!nightBefore)
                FeedRobotender();
        }
        ActivateMumming();

        if (get_property("demonSummoned") != "true")
            AdventureEffect(summonGreed, preternatualGreed, turns);
        if (get_property("sidequestArenaCompleted") == "fratboy" && get_property("concertVisited") != "true")
            AdventureEffect(concertWinklered, winklered, turns);
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
                UseOneTotal(pinkHeart, pinkHeartEffect);
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
                else if (egg2.item_amount() > 0)
                {
                    TrySpleen(egg2, eggEffect, 1, 1);
                }
                else if (egg3.item_amount() > 0)
                {
                    TrySpleen(egg3, eggEffect, 1, 1);
                }
                //TryBuffForFreeCombats(true);
                if (covetous.have_effect() > 0 && CopiedMeatyAvailable() && PuttyCopiesRemaining() > 8)
                {
                    // The test for this isn't a very accurate calculation, but it should get us in the
                    // ballpark of whether these wishes are worthwhile or not.
                    // 50k/wish > 2 days * 10 embezzlers/day * 1000 meat/embezzler * 200% multiplier,
                    // but with free fights giving meat, it can beat break-even over 2 days, and come
                    // out ahead when accounting for 20 turns of barf monsters (and more with buff extenders)

                    // 2 +200% meat effects:
                    WishForEffect(frosty);
                    WishForEffect(braaaaaains);
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
        DriveObservantly(turns, false); // false = only buff if the Asdon Martin is installed
        UseItem(nasalSpray, nasalSprayEffect, turns, 10, 150);
        if (summonRes.have_skill())
            UseItem(wealthy, resolve, turns, 20);
        else
            UseItem(wealthy, resolve, 1, 20, 1000);
        if (mayflower.item_amount() > 0 && begpwnia.item_amount() > 0)
            UseOneTotal(begpwnia, begpwniaEffect);
        UseItem(avoidScams, avoidScamsEffect, turns, 20, 500);
        CastSkill(leer, leering, quietJudgement.have_skill() ? 1 : turns, 10);
        CastSkill(polka, polkad, turns, 25);
        RentAHorse();

        if (needWeightBuffs)
        {
            CastSkill(leash, leashEffect, turns, 10);
            CastSkill(empathy, empathyEffect, turns, 35);
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
            cli_execute("barrelprayer buff"); // bonus adventures from eating
        }

        SweetMeat(turns);
        KGBBuff(turns);

        TryDrink(dirt, dirtEffect, 1, 1);

        BeforeSwapOutAsdon();
        if (nightBefore)
        {
            TryEat(horseradish, kickedInSinuses, 1, 0, turns, false);
            TryEat(foodCone, foodConeEffect, 2, 0, turns, false); // thanksgetting 
            if (expensiveBuffs || fistTurkey.have_familiar())
            {
                TryDrink(turkey, turkeyEffect, 1, turns);
            }
            if (expensiveBuffs)
            {
                TryDrink(gingerWine, gingerWineEffect, 2, turns);
            }
            item bestThanks = ChooseCheapestThanksgetting();
            TryEat(bestThanks, thanksgetting, 2, 0, turns, false);
        }
        else
        {
            // always 18 turns of thanksgetting to account for, eat as many horseradish as necessary first,
            // but they should get converted to drunk unless it's feast of Boris
            for (int remaining = 30; remaining >= 18; remaining--)
            {
                if (horseradish.item_amount() < 1)
                    cli_execute("acquire 1 jumping horseradish");
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
            if (fistTurkey.have_familiar())
            {
                int turkeyturns = turns > 110 ? 110 : turns; // limit to 5 turkeys a day, since that's all that can drop per day
                for (int i = 0; i < 5; i++)
                    TryDrink(turkey, turkeyEffect, 1, turkeyturns);
            }
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

            for (int i = 0; i < 5; i++) // fill up the rest with +item buff
                TryDrink(sacramento, sacramentoEffect, 1, turns);
        }

        // don't finish with accordion buffs until after we've drunk, because we might need to shrug Ode to fit the song in our head
        TryLimitedAccordionBuff(thingfinder, thingfinderEffect, "_thingfinderCasts", turns);
        TryLimitedAccordionBuff(companionship, companionshipEffect, "_companionshipCasts", turns);

        if (EnsureOneSongSpace())
        {
            CastSkill(phatLoot, phatLooted, turns, 25);
        }

        DriveObservantly(turns, true); // true == request to install the Asdon Martin
        TryBuffForFreeCombats(false);
        MaxManaSummons();
        // switching from Quiet Judgement +MP to Disco Leer +meat
        CastSkill(leer, leering, turns, 10);

        if (needWeightBuffs)
        {
            // this reduces all stats, so use after MaxManaSummons
            UseItem(petBuff, petBuffEffect, turns, 10, 250);
        }
    }


    string runawayFilter(int round, monster mon, string page)
    {
        if (needsCleesh)
        {
            needsCleesh = false;
            return "skill Cleesh";
        }
        if (needsSmokeBomb)
        {
            needsSmokeBomb = false;
            return "item " + smokebomb.to_string() + ",none";
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
            SwitchToFamiliar(stompingBoots);
            CastSkill(odeToBooze, odeToBoozeEffect, 1, 25); // only need 1 turn of it
        }
        if (GetFreeRunaways() > 0)
        {
            PrepareSmokeBomb();
            return "runawayFilter";
        }
        else
            return "Filter_Standard";
    }
      
    boolean IsPurpleLightAvailable()
    {
        if (!get_property("LinknoidBarf.HobopolisWhitelist").contains_text(get_clan_name()))
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


    void RunawayGingerbread()
    {
        visit_url("place.php?whichplace=gingerbreadcity");
        if (get_property("_gingerbreadCityToday") != "true" // not accessible
            || get_property("_gingerbreadCityTurns").to_int() > 0 // already ran turns
            || get_property("_gingerbreadClockAdvanced") != "false" // already advanced clock
            || get_property("gingerAdvanceClockUnlocked") != "true") // can't advance the clock
        {
            return;
        }
        if (!stompingBoots.have_familiar() && !bandersnatch.have_familiar())
            return;
        if (GetFreeRunaways() < 3)
            return;
        if (!UserConfirmDefault("Do you want to auto-clear gingerbread today for candy and chocolate sculpture using free runaway familiar?", true))
        {
            return;
        }
        string filter = ReadyRunaway();
        if (filter != "runawayFilter")
            return;
        string page = LoadChoiceAdventure(gingerCivic, false); // civic center
        run_choice(1); // clock choice
        for (int i = 0; i < 3; i++) // run away 3 times
        {
            if (GetFreeRunaways() < 1)
            {
                print("Out of free runaways, " + (3 - i) + " adventures left until train candy.", "red");
                return;
            }
            PrepareSmokeBomb();
            gingerTrain.adv1(-1, filter);
        }
        page = LoadChoiceAdventure(gingerTrain, false);
        run_choice(1); // dig for candy
        if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
            put_closet(swizzler.item_amount(), swizzler);

        if (GetFreeRunaways() < 9)
        {
            print("9 adventures left until midnight, not enough free runaways.", "red");
            return;
        }
        if (!HaveGingerbreadBest())
            return;
        for (int i = 0; i < 9; i++) // run away 9 times
        {
            PrepareSmokeBomb();
            gingerRetail.adv1(-1, filter);
        }
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


    void SemiRareCastle()
    {
        string filter = ReadyRunaway(); // should be a non-combat, so runaway if it's not
        //castleTopFloor.adv1(-1, filter);
        string page = visit_url("adventure.php?snarfblat=324"); // castle top floor
        if (page.contains_text("choice.php"))
        {
            // if non-combat choice adventure, try to skip turn by Copper Feel => Investigate the Whirligigs and Gimcrackery
            if (page.contains_text("Check Behind the Giant Poster")) // goto punk rock
            {
                page = visit_url("choice.php?option=4&pwd=" + my_hash() + "&whichchoice=676", false); // check behind the giant poster
            }
            if (page.contains_text("Check behind the trash can")) // goto steampunk
            {
                page = visit_url("choice.php?option=3&pwd=" + my_hash() + "&whichchoice=678", false); // check behind the trash can
            }
            else if (page.contains_text("Get the Punk's Attention")) // fight punk rock
            {
                page = visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=678", false); // get the punk's attention
                RunCombat(filter);
                return;
            }
            if (page.contains_text("Gimme Steam")) // goto steampunk
            {
                page = visit_url("choice.php?option=4&pwd=" + my_hash() + "&whichchoice=675", false); // gimme steam
            }
            else if (page.contains_text("End His Suffering")) // fight goth
            {
                page = visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=675", false); // end his suffering
                RunCombat(filter);
                return;
            }
            if (page.contains_text("Copper Feel"))
                run_choice(2); // investigate whirligigs, skip adventure
        }
        else
            RunCombat(filter);
    }
    void SemiRareBilliard()
    {
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

    boolean ActivateCopyItem(item copyItem)
    {
        print("Trying to activate " + copyItem.to_string() + " for embezzler", printColor);
        visit_url("inv_use.php?whichitem=" + copyItem.to_int());
        RunCombat("Filter_Standard");
        return true;
    }
    boolean MeatyScheduled()
    {
        if (my_turnCount() == digitizeCounter)
        {
            return get_property("_sourceTerminalDigitizeMonster") == embezzler.to_string();
        }
        if (my_turnCount() == enamorangCounter)
        {
            return get_property("enamorangMonster") == embezzler.to_string();
        }
        return false;
    }
    boolean RunCopiedMeaty()
    {
        PrepareMeaty();

        // any copying item that we're using up should be set to "need to use" to
        // replenish the copy

        if (MeatyPuttied())
        {
            print("using spooky putty embezzler", printColor);
            needsSpookyPutty = get_property("spookyPuttyCopiesMade").to_int() < 5;
            return ActivateCopyItem(usedSpookyPutty);
        }
        else if (MeatyRainDohed())
        {
            print("using rain doh embezzler", printColor);
            needsRainDoh = true;
            return ActivateCopyItem(usedRainDoh);
        }
        else if (MeatyPrintScreened() && get_property("_printscreensUsedToday").to_int() < maxUsePrintScreens)
        {
            print("using print screen embezzler", printColor);

            set_property("_printscreensUsedToday", (get_property("_printscreensUsedToday").to_int() + 1).to_string()); // to avoid using all the print screens in one day
            needsPrintScreen = true;
            return ActivateCopyItem(usedPrintScreen);
        }
        else if (MeatyCameraed())
        {
            print("using camera embezzler", printColor);
            needsCamera = true;
            return ActivateCopyItem(usedcamera);
        }
        else if (MeatyChateaud())
        {
            print("using Chateau painting embezzler", printColor);
            visit_url("place.php?whichplace=chateau&action=chateau_painting");
            RunCombat("Filter_Standard");
            return true;
        }
        print("no embezzler found", printColor);
        return false;
    }

    int moonSignInt = -1;
    boolean universesLeft = true;
    void TryCalculateUniverse()
    {
        if (!universesLeft || my_mp() < 1)
            return;
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
                return;
            }
        }
    }

    void ActivateChibiBuddy()
    {
        if (chibiOff.item_amount() > 0)
        {
            //use(1, chibiOff);
            visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=5925");
            visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=633&name=ChibiBuffMaker");
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
            return;
        page = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1278&option=1&which=-3&q1=Pizza&q2=MadameZatara&q3=Hello");
    }

    boolean needsLube = false;
    boolean lubeChecked = false;

    void CheckLubeQuest()
    {
        if (lubeChecked)
            return;

        lubeChecked = true;
        if (get_property("_dinseyGarbageDisposed") != "true")
        {
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


    void RunBarfMountain(boolean requireOutfit)
    {
        if (MeatyScheduled())
        {
            PrepareMeaty();
        }
        else
        {
            PrepareBarf(requireOutfit);
        }
        CheckLubeQuest();

        if (LoadChoiceAdventure(barfMountain, true))
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
        }
        else
        {
            RunCombat("Filter_Standard");
        }
    }

    int CanMortar = 0;
    string Filter_LOVTunnel(int round, monster mon, string page)
    {
        if (mon == LOVenforcer)
        {
            return "attack";
        }
        else if (mon == LOVengineer)
        {
            if (weaponPasta.have_skill() && my_mp() > weaponPasta.mp_cost())
                return "skill " + weaponPasta.to_string();
            if (CanMortar >= 2)
            {
                CanMortar = 1;
                return "skill " + mortarShell.to_string();
            }
     
            if (sauceStorm.have_skill() && my_mp() > sauceStorm.mp_cost()) // saucestorm
                return "skill " + sauceStorm.to_string();
        }
        else // equivaocator
        {
            if (can_still_steal())
                return "\"pickpocket\"";
            if (CanMortar >= 1)
            {
                CanMortar = 0;
                return "skill " + mortarShell.to_string();
            }
        }
        if (thrustSmack.have_skill() && my_mp() > thrustSmack.mp_cost())
            return "skill " + thrustSmack.to_string();
        if (sauceStorm.have_skill() && my_mp() > sauceStorm.mp_cost()) // saucestorm
            return "skill " + sauceStorm.to_string();
        return "";
    }
    void PrepareFilterLOV()
    {
        CanMortar = mortarShell.have_skill() ? 3 : 0;
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
        print("Running LOV tunnel");
        PrepareFilterLOV();
        HealUp();
    
        visit_url("place.php?whichplace=town_wrong");
        if (!LoadChoiceAdventure("place.php?whichplace=town_wrong&action=townwrong_tunnel", "LOV Tunnel", false))
            return;
        run_choice(1); // Enter the tunnel

        // cannot use run_choice() to start the fight, or you won't get a combat filter? 
        visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1223&option=1"); // Fight LOV Enforcer
        RunCombat("Filter_LOVTunnel");
        LoadChoiceAdventure("choice.php", "Choose LOV gear", false);
        run_choice(3); // LOV Earrings, +50% meat
    
        visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1225&option=1"); // Fight LOV Engineer
        RunCombat("Filter_LOVTunnel");
        LoadChoiceAdventure("choice.php", "Choose LOV buff", false);
        run_choice(2); // open heart surgery, +10 pet weight
    
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
            if (synthMP.have_effect() == 0 && milkStud.item_amount() > 0 && seniorMint.item_amount() > 0 && RoomToSpleen(1))
                sweet_synthesis(milkStud, seniorMint);
            if (synthMyst.have_effect() == 0 && milkStud.item_amount() > 0 && daffyTaffy.item_amount() > 0 && RoomToSpleen(1))
                sweet_synthesis(milkStud, daffyTaffy);
        }

        if (get_property("telescopeUpgrades").to_int() > 0 && get_property("telescopeLookedHigh") == "false")
            cli_execute("telescope high"); // +stats

        visit_url("place.php?whichplace=spacegate"); // have to visit it to see if we have access
        if (get_property("spacegateVaccine") != "true" && get_property("_spacegateToday") == "true")
            cli_execute("spacegate vaccine 2"); // +stats

        if (muscle.my_basestat() > mysticality.my_basestat())
        {
            BuyAndUseOneTotal(muscleToMyst, muscleToMystEffect, 5000);
        }
        else if (moxie.my_basestat() > mysticality.my_basestat())
        {
            BuyAndUseOneTotal(moxieToMyst, moxieToMystEffect, 5000);
        }
        if (quietJudgementEffect.have_effect() == 0 && quietJudgement.have_skill())
        {
            use_skill(1, quietJudgement);
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

        if (!HaveEquipment(sphygmayo) && (get_campground() contains mayoClinic))
            cli_execute("buy 1 " + sphygmayo.to_string());
        while (FreeDailyManaRestore())
        {
            BurnManaAndRestores(20, true);
        }
        outfit(manaOutfit);
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
            pants.equip("none".to_item());
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
            print("Using Missile Launcher while Asdon Martin is active");
            shouldMissileLauncher = true;
            FuelAsdon(100);
            PrepareStandardFilter();
            PrepareFamiliar(false);
            RunBarfMountain(false);
        }
    }


    void RunTurns(int turnCount)
    {
        if (turnCount != 0)
        {
            //FreeCombatsForProfit();
            RunawayGingerbread();
        }
        for (int i = 0; i < turnCount || (turnCount < 0); i++)
        {
            print("LinknoidBarf Turns remaining = " + (turnCount - i));
            TryCalculateUniverse();
            BurnManaAndRestores(20, false);
          
            PrepareStandardFilter();
            if (turnCount < 0 && !hasFreeKillRemaining)
                return;
            if (needBagOTricks)
                TryActivateBagOTricks();
            
            SoulSauceToMana();
            if (spookyravenCounter == my_turnCount())
            {
                print("Skipping Spookyraven in this script, if you don't want it to skip, add a 'counter script' in KoLMafia");
                BypassCounterError();
            }

            if (fortuneCookieCounter == my_turnCount()
                && semiRareAttempted != my_turnCount())
            {
                print("Running semi-rare");
                RunSemiRare();
                continue;
            }
            if ((turnCount - i) % 10 == 1)  // only check every 10 turns
            {
                if (TryFightGhost())
                {
                    continue;
                }
            }
            if (CopiedMeatyAvailable())
            {
                print("Running copied embezzler");
                PrepareFamiliar(true);
                if (RunCopiedMeaty())
                    continue;
            }
            PrepareFamiliar(false);
            print("Running barf mountain");
            RunBarfMountain(true);
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
    
        if (!UserConfirmDefault("No access to Dinsey, use a day pass?", true))
            abort("No access to Dinsey");
    
        if (dayPass.item_amount() == 0)
            buy(1, dayPass);
        if (dayPass.item_amount() == 0)
            abort("Could not acquire " + dayPass.to_string());
        use(1, dayPass);
    }


// pass -1 for buffTurns if you're doing "night before" buffing
    void main(int buffTurns, int runTurns, string familiarName)
    {
        ReadSettings();
        WriteSettings(); // in case there are new properties
        ChooseSummonType();
        SetRunFamiliar(familiarName, buffTurns);

        RemoveConfusionEffects(true);
        
        if (buffTurns > 0 || runTurns > 0)
            EnsureAccess();
        if (buffTurns != 0)
            BuffTurns(buffTurns);
        if (runTurns != 0)
            RunTurns(runTurns);
    }

