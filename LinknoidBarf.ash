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
// 2 Milk Studs @640                                      =      1280
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

// auto-choose familiar if it's blank (instead of using current)

// free fight "Evoke Eldritch Horror" and tentacle for science
// duplicate witchess knight

// validate hobopolis access via get_clan_name() and settings whitelist before assuming we can use the instance
// auto-cleesh and run away in purple light district if we get a combat

// warn if wearing text-changing items or have text-changing buffs that it will confuse the KolMafia (like Papier mitre, staph of homophones, wormwood buff, etc)

// get buff bot requests working

// Add for mana burning:
// clara's bell and hobopolis if 20 hobo glyphs and have access



// LINKNOIDBARF.ASH


    string defaultOutfit = "barf";

    int usePrintScreens = 1;
    int useEnamorangs = 1;
    boolean allowExpensiveBuffs = true;


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


// getting access to dinsey
    item dayPass = ToItem("one-day ticket to Dinseylandfill");

// campground items
    item witchess = ToItem("Witchess Set");
    item terminal = ToItem("Source terminal");
    item mayoClinic = ToItem("portable Mayo Clinic");
    item asdonMartin = ToItem("Asdon Martin keyfob");
    effect observantly = ToEffect("Driving Observantly");
    item pieFuel = ToItem("pie man was not meant to eat");
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

// spleen items
    item egg1 = ToItem("black paisley oyster egg");
    item egg2 = ToItem("black polka-dot oyster egg");
    item egg3 = ToItem("black striped oyster egg");
// Sweet Synthesis
    item ww = ToItem("bag of W&Ws");
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
    familiar fistTurkey = ToFamiliar("Fist Turkey");
    familiar intergnat = ToFamiliar("Intergnat");
    familiar jellyfish = ToFamiliar("Space Jellyfish");
    familiar robin = ToFamiliar("Rockin' Robin");
    familiar stompingBoots = ToFamiliar("Pair of Stomping Boots");
    familiar bandersnatch = ToFamiliar("Frumious Bandersnatch");
    familiar obtuseAngel = ToFamiliar("Obtuse Angel");
    familiar reanimator = ToFamiliar("Reanimated Reanimator");

// familiar equipment
    item snowSuit = ToItem("Snow Suit"); // 20 pounds, but decreases over the day
    item petSweater = ToItem("Astral pet sweater"); // 10 pounds, costs 10 karma per ascension
    item sugarShield = ToItem("sugar shield"); // 10 pounds, breaks after 30 turns
    item cufflinks = ToItem("recovered cufflinks"); // 6 pounds, requires 400 pound jellyfish
    item hookah = ToItem("ittah bittah hookah"); // 5 pounds, provides buffs
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
    skill curseOfIslands = ToSkill("Curse of the Thousand Islands");
    skill soulBubble = ToSkill("Soul Bubble");
    skill entanglingNoodles = ToSkill("Entangling Noodles");


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
    skill extractJelly = ToSkill("Extract Jelly");
    skill extract = ToSkill("Extract");
    skill pocketCrumbs = ToSkill("Pocket Crumbs");

// monster level so it can survive longer
    skill annoyingNoise = ToSkill("Drescher's Annoying Noise");
    effect annoyingNoiseEffect = ToEffect("Drescher's Annoying Noise");
    skill annoyance = ToSkill("Ur-Kel's Aria of Annoyance");
    effect annoyanceEffect = ToEffect("Ur-Kel's Aria of Annoyance");
    item greekFire = ToItem("Greek fire");
    effect greekFireEffect = "Sweetbreads Flamb".to_effect(); // this has a non-ascii character in it which won't match, so effect verification in ToEffect will fail


// Skills for consumption
    skill odeToBooze = ToSkill("The Ode to Booze");

// skills for +meat bonus
    skill leer = ToSkill("Disco Leer");
    skill polka = ToSkill("The Polka of Plenty");
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
    item blBackpack = ToItem("Bakelite Backpack"); // with accordion bash
    item halfPurse = ToItem("Half a Purse"); // requires Smithsness to be effective
    item sunglasses = ToItem("cheap sunglasses"); // only relevant for barf mountain
    item scratchSword = ToItem("scratch 'n' sniff sword"); // only worthwhile for embezzlers
    item scratchXbow = ToItem("scratch 'n' sniff crossbow"); // only worthwhile for embezzlers
    item scratchUPC = ToItem("scratch 'n' sniff UPC sticker"); // attaches to crossbow or sword
    item nasalSpray = ToItem("Knob Goblin nasal spray"); // bought from knob goblin dispensary
    item wealthy = ToItem("resolution: be wealthier"); // from libram of resolutions
    item affirmationCollect = ToItem("Daily Affirmation: Always be Collecting"); // from new you club
    item avoidScams = ToItem("How to Avoid Scams"); // only relevant for barf mountain
    item flaskfull = ToItem("Flaskfull of Hollow"); // + smithness for Half a Purse
    item dice = ToItem("Glenn's golden dice"); // once a day random buffs
    item pantsGiving = ToItem("Pantsgiving"); // wear for combat skills, fullnes reduction
    item gameToken = ToItem("defective Game Grid token"); // once a day activate for 5 turns of +5 everything

// 2 day items for +meat bonus
    item peppermint = ToItem("peppermint twist"); // candy drop from robort
    item micks = ToItem("Mick's IcyVapoHotness Inhaler"); // from semi-rare
    item sugar = ToItem("bag of powdered sugar"); // 
    item pinkHeart = ToItem("pink candy heart");

// special activations for +meat bonus
    string summonGreed = "summon 2"; // summoning chamber if you've learned the Hoom-Ha name
    string meatEnh = "terminal enhance meat.enh"; // if you have a source terminal
    string concertWinklered = "concert Winklered"; // if you helped the Orcs in the island war and finished fliering for the concert
    string hatterDreadSack = "hatter filthy knitted dread sack"; // need a Drink-me potion and a filthy knitted dread sack from hippies

// effects for +meat bonus
    effect odeToBoozeEffect = ToEffect("Ode to Booze"); //
    effect winklered = ToEffect("Winklered"); // from concert if you helped orcs
    effect sinuses = ToEffect("Sinuses For Miles"); // from Mick's
    effect wasabi = ToEffect("Wasabi Sinuses"); // from Knob Goblin nasal spray
    effect resolve = ToEffect("Greedy Resolve"); // from resolution: be wealthy
    effect alwaysCollecting = ToEffect("Always be Collecting"); // DailyAffirmation: always be collecting
    effect workForHours = ToEffect("Work For Hours a Week"); // DailyAffirmation: Work for hours a week
    effect scamTourist = ToEffect("How to Scam Tourists"); // from How to Avoid Scams
    effect leering = "Disco Leer".ToEffect(); // from Disco Leer (disco bandit skill)
    effect polkad = "Polka of Plenty".ToEffect(); // from Polka (accordion thief)
    effect phatLooted = "Fat Leon's Phat Loot Lyric".ToEffect(); // from Fat Leon's (accordion thief)
    effect meatEnhanced = "meat.enh".ToEffect(); // source terminal, 60%, 3x 100 turns a day
    effect danceTweedle = "Dances with Tweedles".ToEffect(); // from DRINK ME potion, once a day, 40%, 30 turns
    effect merrySmith = "Merry Smithsness".ToEffect(); // from Flaskfull of Hollow
    effect kickedInSinuses = "Kicked in the Sinuses".ToEffect(); // from horseradish
    effect foodConeEffect = "The Dinsey Way".ToEffect(); // from Dinsey Food Cone
    effect seaTruffleEffect = "Trufflin'".ToEffect(); // from the sea truffle
    effect thanksgetting = "Thanksgetting".ToEffect(); // from thanksgetting feast items
    effect synthGreed = "Synthesis: Greed".ToEffect(); // from Sweet Synthesis skill
    effect preternatualGreed = "Preternatural Greed".ToEffect();
    effect eggEffect = "Egg-stortionary Tactics".ToEffect();
    effect gingerWineEffect = "High-Falutin'".ToEffect();
    effect dirtEffect = "Here's Some More Mud in Your Eye".ToEffect();
    effect turkeyEffect = "Turkey-Ambitious".ToEffect();
    effect joyEffect = "Joy".ToEffect();
    effect pinkHeartEffect = "Heart of Pink".ToEffect();
    effect peppermintEffect = "Peppermint Twisted".ToEffect();
    effect sugarEffect = "So You Can Work More...".ToEffect();
    effect kgbMeat = "A View to Some Meat".ToEffect();
    effect kgbItems = "Items Are Forever".ToEffect();
    effect bagOTricksEffect1 = "Badger Underfoot".ToEffect();
    effect bagOTricksEffect2 = "Weasels Underfoot".ToEffect();
    effect bagOTricksEffect3 = "Chihuahua Underfoot".ToEffect();

// effects for pet weight bonus
    effect leashEffect = ToEffect("Leash of Linguini");
    effect empathyEffect = ToEffect("Empathy");
    effect petBuffEffect = ToEffect("Heavy Petting");
    effect kinderEffect = ToEffect("Kindly Resolve");

// skills to activate Bag O' Tricks
    skill BoTspell0 = ToSkill("Stuffed Mortar Shell"); // this one is special because it has a one turn delay
    skill BoTspell1 = ToSkill("Spaghetti Spear"); // low damage
    skill BoTspell2 = ToSkill("Salsaball"); // low damage
    skill BoTspell3 = ToSkill("Saucestorm"); // likely to have skill
    skill BoTnonspell0 = ToSkill("Lunging Thrust-Smack");
    skill BoTnonspell1 = ToSkill("Weapon of the Pastalord");

// between turns skills
    skill summonRes = ToSkill("Summon Resolutions");
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
    item eternalBattery = ToItem("Eternal Car Battery");
    skill discoNap = ToSkill("Disco Nap");
    skill leisure = ToSkill("Adventurer of Leisure");
    skill narcolepsy = ToSkill("Executive Narcolepsy");
    skill turbo = ToSkill("Turbo");
    effect overheated = ToEffect("Overheated");
    item pilgrimHat = ToItem("Giant pilgrim hat");
    item clarasBell = ToItem("Clara's bell");
    item hoboBinder = ToItem("hobo code binder");

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
    monster tourist = ToMonster("garbage tourist");
    effect olfaction = "On the Trail".ToEffect();

// semi-rare
    item nickel = ToItem("hobo nickel");
    item billiardKey = ToItem("Spookyraven billiards room key");

// barf mountain quest
    item lubeShoes = ToItem("lube-shoes");
    static string kioskUrl = "place.php?whichplace=airport_stench&action=airport3_kiosk";

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
    int digitizeCounter = 0;
    int enamorangCounter = 0;
    int fortuneCookieCounter = 0;
    int maxItemUse = funkslinging.have_skill() ? 2 : 1;
    boolean eatWithoutMayo = false;
    int semiRareAttempted = 0; // once we attempt a semi-rare on a turn, don't retry, 
    string buffBotRequest = "";
    int buffBotMeatTotal = 0;

// forward declarations of functions:
    void ChooseDropsFamiliar(boolean isElemental);
    boolean TryEquipFamiliarEquipment(item eqp, float eqpBonus);
    void PrepareFamiliar(boolean forEmbezzler);
    void PrepareEmbezzler();
    boolean TryEat(item food, effect desiredEffect, int providedFullness, int followupFullness, int turnLimit, boolean eatUnique);
    void BeforeSwapOutAsdon();
    void BeforeSwapOutMayo();
    void TryReduceManaCost(skill skll);
    void MaxManaSummons();
    void ChooseEducate(boolean duplicate, boolean digitize);
    void ChooseThrall(boolean forMeat);  //, boolean forItems)


// general utility functions
    boolean UserConfirmDefault(string message, boolean defaultValue)
    {
        if (get_property("LinknoidBarf.AutoConfirm") == "true")
            return defaultValue;
        return user_confirm(message);
    }
    int FindVariableChoice(string page, string match)
    {
        int ix = page.index_of(match);
        if (ix <= 0)
            return -1;

        string searchFor = "<input type=hidden name=option value=";
        ix = page.index_of(searchFor, ix);
        if (ix <= 0)
            return -1;
        ix += searchFor.length();

        string choice = page.substring(ix, ix + 2).replace_string(" ", ""); // allow up to 99 options
        return choice.to_int();
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
    boolean HaveEquipment(item itm)
    {
        return itm.item_amount() > 0 || itm.have_equipped();
    }
    boolean OutfitContains(string outfit, item eq)
    {
        foreach key,value in outfit_pieces(outfit)
            if (value == eq)
                return true;
        return false;
    }
    boolean IsAccordion(item it)
    {
        return it.item_type() == "accordion";
    }

// more specific helper functions

    boolean EmbezzlerPrintScreened()
    {
        return get_property("screencappedMonster") == embezzler.to_string()
            && get_property("_printscreensUsedToday").to_int() < usePrintScreens; // need guard to prevent infinite print screening
    }
    boolean EmbezzlerCameraed()
    {
        return get_property("cameraMonster") == embezzler.to_string()
            && !get_property("_cameraUsed").to_boolean();
    }
    boolean EmbezzlerRainDohed()
    {
        return get_property("rainDohMonster") == embezzler.to_string();
    }
    boolean EmbezzlerPuttied()
    {
        return get_property("spookyPuttyMonster") == embezzler.to_string();
    }
    boolean EmbezzlerEnamoranged()
    {
        return get_property("enamorangMonster") == embezzler.to_string();
    }
    boolean EmbezzlerDigitized()
    {
        return get_property("digitized") == embezzler.to_string();
    }
    boolean EmbezzlerChateaud()
    {
        return get_property("chateauMonster") == embezzler.to_string()
            && get_property("_chateauMonsterFought") == "false";
    }

    boolean CanDistention()
    {
        return distention.item_amount() > 0 && !get_property("_distentionPillUsed").to_boolean();
    }
    void BurnManaSummoning(int keepMana)
    {
        while (summonRes.have_skill() && summonRes.mp_cost() < (my_mp() - keepMana))
        {
            use_skill(1, summonRes);
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
        if (minRestore + soulsauceManaAvailable + my_mp() < summonRes.mp_cost() + keep)
            return false;
        return true;
    }
    void BurnManaAndRestores(int keepMana, boolean burnDailyRestores)
    {
        if (!summonRes.have_skill())
            return;
        BurnManaSummoning(keepMana);
        boolean changed = true;
        while (changed)
        {
            changed = false;

            int soulsauceBonus = my_soulsauce() / 5;
            soulsauceBonus *= 3;
            int cost = summonRes.mp_cost() + keepMana;
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
            while (cost < my_mp())
            {
                changed = true;
                use_skill(1, summonRes);
                cost = summonRes.mp_cost() + keepMana;
            }
        }
    }
    int GetRemainingFreeRunaways()
    {
        int result = (my_familiar().familiar_weight() + weight_adjustment()) / 5;
        result -= get_property("_banderRunaways").to_int();
        return result;
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
            else if (breadFuel.item_amount() > 0)
                cli_execute("asdonmartin fuel 1 " + breadFuel.to_string());
            if (get_fuel() == hadFuel)
            {
                abort("Asdon Martin is out of gas, please refuel manually, or acquire pies or bake soda bread before resuming.");
            }
            hadFuel = get_fuel();
        }
        return true;
    }



    void PrepareStandardFilter()
    {
        if (!canPickpocket)
        {
            canPickpocket = my_class().to_string() == "Disco Bandit" || my_class().to_string() == "Accordion Thief";
            if (my_class().to_string() == "Disco Bandit")
            {
                canRaveNirvana = get_property("raveCombo5") != "";
                canRaveConcentration = get_property("raveCombo3") != "";
                canRaveSteal = get_property("raveCombo4") != "";
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
        }
        int digitizeCount = get_property("_sourceTerminalDigitizeUses").to_int();
        needsDigitize = digitizeCount == 0;
        if (digitizeCount < 3)
        {
            int digitizeRange = get_property("_sourceTerminalDigitizeMonsterCount").to_int();
            if (digitizeRange >= 4)
                needsDigitize = true;
            else if (my_turnCount() == digitizeCounter && digitizeRange == 3)
            {
                needsDigitize = true;
                needBagOTricks = true;
            }
                
        }
        ChooseEducate(false, needsDigitize);
        needsEnamorang = enamorang.item_amount() > 0
            && get_property("enamorangMonster") == "";

        if (usedCamera.item_amount() == 0 && camera.item_amount() > 0)
        {
            needsCamera = true;
        }

        canJokesterGun = get_property("_firedJokestersGun") == "false"
            && jokesterGun.have_equipped();

        if (replicaBatoomerang.item_amount() > 0
            && get_property("_usedReplicaBatoomerang").to_int() < 3)
        {
            canBatoomerang = true;
        }
        if (get_campground() contains asdonMartin
            && get_property("_missileLauncherUsed") == "false"
            && get_fuel() >= 100)
        {
            canMissileLauncher = true;
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
    }
    string Filter_Standard(int round, monster mon, string page)
    {
        if (round == 0)
            print("using Filter_Standard");

        if (mon == embezzler) // capture embezzler
        {
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
                if (enamorangsUsed < useEnamorangs)
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
        if (mon == tourist && olfaction.have_effect() == 0 && my_mp() > 50)
        {
            return "skill Transcendent Olfaction";
        }
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
        if (canAccordionBash)
        {
            canAccordionBash = false;
            return "skill Accordion Bash";
        }
        // rave checks come after embezzler special handling, because we could accidentally kill embezzler too early
        // Only do combos when HP are over 100, don't want to get beat up
        if (canRaveNirvana && my_hp() > 100) // increase meat drops
        {
            static boolean ravedNirvana = false;
            if (!ravedNirvana)
            {
                ravedNirvana = true;
                return "combo rave nirvana";
            }
        }
        if (canRaveConcentration && my_hp() > 100) // increase item drops
        {
            static boolean ravedConcentration = false;
            if (!ravedConcentration)
            {
                ravedConcentration = true;
                return "combo rave nirvana";
            }
        }
        if (canRaveSteal && my_hp() > 100) // sometimes steals an item
        {
            static boolean ravedSteal = false;
            if (!ravedSteal)
            {
                ravedSteal = true;
                return "combo rave steal";
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
        if (canTurbo)
        {
            canTurbo = false;
            return "skill Turbo";
        }
            
        return "";
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
        if (puttyAvailable > 0) // both have 5 individually, combined they get 6 total
            puttyAvailable += 4;
        else
            return 0;
        int puttiesUsed = get_property("spookyPuttyCopiesMade").to_int();
        int raindohsUsed = get_property("_raindohCopiesMade").to_int();
        return puttyAvailable - (puttiesUsed + raindohsUsed);
    }


    boolean CopiedEmbezzlerAvailable()
    {
        int count = 0;
        if (EmbezzlerPrintScreened())
            return true;
        if (EmbezzlerCameraed())
            return true;
        if (EmbezzlerRainDohed())
            return true;
        if (EmbezzlerPuttied())
            return true;
        if (EmbezzlerChateaud())
            return true;
        return false;
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
       
        if (snowSuit.have_equipped() || petSweater.have_equipped() || hookah.have_equipped() || cufflinks.have_equipped())
            famEqp.equip("none".to_item()); // remove the equipment so someone else can wear it
        fam.use_familiar();
    }
    void PrepareFamiliar(boolean forEmbezzler)
    {
        if (my_familiar() != runFamiliar)
            SwitchToFamiliar(runFamiliar);
        if (my_familiar() == orphan)
        {
            // counts as an 80+ pound leprechaun, but just chose some arbitrary number larger
            // than the 20 pound max of snow suit
            TryEquipFamiliarEquipment(pirateCostume, 80);
            return;
        }

        if (HaveEquipment(snowSuit))
            snowSuitWeight = snowSuit.numeric_modifier("Familiar Weight");

        if (TryEquipFamiliarEquipment(petSweater, 10))
            return;
        if (forEmbezzler && TryEquipFamiliarEquipment(sugarShield, 10))
            return;
        if (TryEquipFamiliarEquipment(cufflinks, 6))
            return;
        // slight weight bonus for hookah because it gives buffs (but how does that
        // compare to the +10% item drop from snow suit even at 5 pounds?)
        if (TryEquipFamiliarEquipment(hookah, 5.1))
            return;
        // final fallback, if no other equipment is matching, this should give +5 weight
        TryEquipFamiliarEquipment(filthyLeash, 5);
    }
    void SwapOutSunglasses()
    {
        // replace cheap sunglasses because they only work in barf mountain
        slot matching;
        if (acc1.equipped_item() == sunglasses)
            matching = acc1;
        else if (acc2.equipped_item() == sunglasses)
            matching = acc2;
        else if (acc3.equipped_item() == sunglasses)
            matching = acc3;
        else
            return;
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
        if (bestPercent > 0)
        {
            matching.equip(best);
        }
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
        if (HaveEquipment(scratchSword))
            eq = scratchSword;
        else if (HaveEquipment(scratchXbow))
            eq = scratchXbow;
        else
            eq = scratchSword;
        if (eq.numeric_modifier("Meat Percent") == 0)
        {
            if (scratchUPC.item_amount() < 3)
            {
                print("Buying 3 scratch and sniff stickers");
                buy(3 - scratchUPC.item_amount(), scratchUPC);
            }
            if (scratchUPC.item_amount() >= 3)
                cli_execute("stickers upc, upc, upc");
            else
            {
                print("Couldn't acquire stickers, no scratch 'n' sniff for you");
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
    void PrepareEmbezzler()
    {
        outfit(defaultOutfit);
        SwapOutSunglasses();
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
    }
    void PrepareBarf(boolean RequireOutfit)
    {
        if (!is_wearing_outfit(defaultOutfit))
        {
            if (RequireOutfit)
                outfit(defaultOutfit);
            else
            {
                foreach ix,itm in outfit_pieces(defaultOutfit)
                {
                    if (itm.to_string() != "none" && HaveEquipment(itm) && !itm.have_equipped())
                    {
                        itm.to_slot().equip(itm);
                    }
                }
            }
        }
        ChooseThrall(true);
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
            run_combat(filter);
            return true;
        }
        return false;
    }
    boolean TryRunSnojo(string filter)
    {
        if (get_property("snojoAvailable").to_boolean()
            && get_property("_snojoFreeFights").to_int() < 10
            && get_property("snojoSetting") != "NONE")
        {
            adv1(snojo, -1, filter);
            return true;
        }
        return false;
    }

    boolean ChooseFreeCombat(string filter)
    {
        if (TryRunWitchess(filter))
            return true;
        if (TryRunSnojo(filter))
            return true;
        return false;
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
    }

    boolean CanCast(skill skl)
    {
        if (!skl.have_skill())
            return false;
        return skl.mp_cost() <= my_mp();
    }

    string AvailableSpellForBagOfTricks()
    {
        if (CanCast(BoTspell0))
            return "skill " + BoTspell0.to_string();
        if (CanCast(BoTspell1))
            return "skill " + BoTspell1.to_string();
        if (CanCast(BoTspell2))
            return "skill " + BoTspell2.to_string();
        if (CanCast(BoTspell3))
            return "skill " + BoTspell3.to_string();
        return "";
    }
    string NonSpellWhileWearingBagOfTricks()
    {
        if (CanCast(BoTnonspell0))
            return "skill " + BoTnonspell0.to_string();
        if (CanCast(BoTnonspell1))
            return "skill " + BoTnonspell1.to_string();
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
        item oldOffhand = offhand.equipped_item();
        EquipDropsItems();
        EnsureSingleHandedWeapon();
        offhand.equip(bagOtricks);
        if (!bagOtricks.have_equipped()) // two handed-weapon, how do we deal with this?  don't want to fight empty-handed
            return;
        ChooseFreeCombat("Filter_BagOTricks");
        offhand.equip(oldOffhand);
    }
    boolean TryActivatePantsgivingFullness()
    {
        if (!HaveEquipment(pantsGiving))
            return false;
        if (my_fullness() != fullness_limit())
            return false;
        pants.equip(pantsGiving);
        boolean first = true;
        while (get_property("_pantsgivingFullness").to_int() == 0)
        {
            ChooseDropsFamiliar(false);
            if (first)
            {
                first = false;
                TryActivateBagOTricks();
                continue;
            }
            else
            {
                EquipDropsItems();
                if (!TryRunSnojo(""))
                    return false;
            }
        }
        return my_fullness() == fullness_limit() - 1;
    }

    int ghostShot = 0;
    int stunRound = 0;
    string Filter_TrapGhost(int round, monster mon, string page)
    {
        static boolean cursed = false;
        static boolean extracted = false;
        static boolean bashed = false;
        static boolean bubbled = false;
        static boolean noodled = false;
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



    void UseItem(item itm, effect resultingEffect, int requestedTurns)
    {
        while (resultingEffect.have_effect() < requestedTurns && itm.item_amount() > 0)
        {
            int oldTurns = resultingEffect.have_effect();
            use(1, itm);
            int newTurns = resultingEffect.have_effect();
            if (oldTurns == newTurns)
                break;
        }
    }

    void TryReduceManaCost(skill skll)
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
        if (HaveEquipment(kgb))
        {
            // todo: verify whether this actually has the proper -3 MP bonus on it
            float modifier = kgb.numeric_modifier("Mana Cost");
            print("kgb mana cost modifier = " + modifier);
            acc2.equip(kgb);
        }
        else if (skll.mp_cost() > 2 && skll.mp_cost() < 12 // Too small, no effect. Too big, and insignificant
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

    void CastSkill(skill skll, effect resultingEffect, int requestedTurns)
    {
        if (resultingEffect.have_effect() >= requestedTurns || !skll.have_skill())
            return;
        TryReduceManaCost(skll);
        while (resultingEffect.have_effect() < requestedTurns && skll.have_skill())
        {
            if (skll.mp_cost() > my_mp())
            {
                restore_mp(skll.mp_cost() - my_mp());
            }
            use_skill(1, skll);
        }
    }
    void CastSkillOrBuffBot(skill skll, effect resultingEffect, int requestedTurns, int meatCostPer5Turns)
    {
        CastSkill(skll, resultingEffect, requestedTurns);
        int missingTurns = requestedTurns - resultingEffect.have_effect();
        if (missingTurns > 0)
        {
            buffBotRequest += missingTurns.to_string() + " " + skll.to_string() + "\n";
            buffBotMeatTotal += meatCostPer5Turns * missingTurns / 5;
        }
    }
    void SendBuffRequest()
    {
//        if (buffBotRequest == "")
//            return;
//        if (!user_confirm("Send buffbot request for " + buffBotMeatTotal + " meat of " + buffBotRequest + "?"))
//            return;
//        kmail("Buffy", buffBotRequest, buffBotMeatTotal);
        buffBotRequest = "";
        buffBotMeatTotal = 0;
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
    
    void TrySpleen(item spleenItem, effect desiredEffect, int providedSpleen, int turnLimit)
    {
        if (desiredEffect.have_effect() >= turnLimit)
            return;

        int remainingSpleen = spleen_limit() - my_spleen_use();
        if (remainingSpleen < providedSpleen)
            return;

        chew(1, spleenItem);
    }

    void TryDrink(item booze, effect desiredEffect, int providedDrunk, int turnLimit)
    {
        if (booze.item_amount() < 1)
            return;
        if (desiredEffect.have_effect() >= turnLimit)
            return;
        int remainingDrunk = inebriety_limit() - my_inebriety();
        if (providedDrunk > remainingDrunk)
            return;

        if (odeToBoozeEffect.have_effect() < providedDrunk)
        {
            CastSkillOrBuffBot(odeToBooze, odeToBoozeEffect, providedDrunk, 5);
        }
        if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
            put_closet(swizzler.item_amount(), swizzler);
        
        drink(1, booze);
    }



    void ConsumeMayo(boolean convertToDrunk)
    {
        if (!(get_campground() contains mayoClinic))
        {
            if (mayoClinic.item_amount() > 0 && !eatWithoutMayo)
            {
                if (get_property("_workshedItemUsed") == "false"
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
            cli_execute("buy 1 " + mayo.to_string());
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
    boolean RoomToEat(int size)
    {
        return my_fullness() + size <= fullness_limit();
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
        UseItem(milk, gotmilk, 2);
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
        print("Attempting bonus eating, fullness at " + my_fullness() + " / " + fullness_limit());
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
        UseItem(milk, gotmilk, 2);

        boolean underDrunk = my_inebriety() < inebriety_limit();
        boolean convertToDrunk = underDrunk && !RoomToEat(providedFullness + followupFullness);
        ConsumeMayo(convertToDrunk);
        eat(1, food);
        return true;
    }
    void SweetSynth(int requestedTurns)
    {
        if (sweetSynth.have_skill())
        {
            while (synthGreed.have_effect() < requestedTurns && my_spleen_use() < spleen_limit())
            {
                sweet_synthesis(ww, ww);
            }
        }
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
            if (!UserConfirmDefault("Don't have Robotender booze " + booze.to_string() + " for " + purpose + ", do you wish to continue?", true))
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
            print("Trying to drive observantly, fuel = " + get_fuel().to_string() + ", existing turns = " + observantly.have_effect());
            cli_execute("asdonmartin drive observantly");
            //visit_url("campground.php?pwd="+my_hash()+"&preaction=drive&whichdrive=7");  // apparently this works even while already driving

            if (effectTurns == observantly.have_effect()) // number of effect turns should have increased
            {
                print("drive observantly failed to buff");
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
                print("KGB buff failed, is Ezandora's briefcase script installed?  Are you out of clicks for the day?");
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
            && overheated.have_effect() <= 0
            && (summonRes.have_skill() || my_mp() < 10)
            && my_mp() < 300 // this will reduce by 50% afterwards, so don't use it unless we're way under capacity
            && my_maxmp() > 4000 // don't use if max mp is too low
            && (my_maxmp() / 2) > summonRes.mp_cost();

        boolean doextract = (!doduplicate && !dodigitize) || (!doduplicate && !doturbo) || (!dodigitize && !doturbo);
        CastEducate(doduplicate, dodigitize, doturbo, doextract);
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

        AcquirePrintScreen();
        if (my_fullness() < fullness_limit())
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

        if (get_property("demonSummoned") != "true")
            AdventureEffect(summonGreed, preternatualGreed, turns);
        if (get_property("sidequestArenaCompleted") == "fratboy" && get_property("concertVisited") != "true")
            AdventureEffect(concertWinklered, winklered, turns);
        if (nightBefore)
        {
            turns = 1;
            SweetSynth(1);
            if (expensiveBuffs)
            {
                UseOneTotal(micks, sinuses);
                UseOneTotal(peppermint, peppermintEffect);
                UseOneTotal(sugar, sugarEffect);
                UseOneTotal(pinkHeart, pinkHeartEffect);
                if (needWeightBuffs)
                {
                    UseOneTotal(kinder, kinderEffect);
                    TrySpleen(joy, joyEffect, 1, turns);
                }
                if (egg1.item_amount() > 0)
                {
                    TrySpleen(egg1, eggEffect, 1, turns);
                }
                else if (egg2.item_amount() > 0)
                {
                    TrySpleen(egg2, eggEffect, 1, turns);
                }
                else if (egg3.item_amount() > 0)
                {
                    TrySpleen(egg3, eggEffect, 1, turns);
                }
            }
        }
        if (!get_property("_defectiveTokenUsed").to_boolean()
            && gameToken.item_amount() > 0)
        {
            use(1, gameToken);
        }

        // want to maximize our chances of increasing the limited/expensive effects, rather than the cheaper ones
        if (bagOtricks.item_amount() > 0 && get_property("_bagOTricksUsed") == "false")
        {
            use(1, bagOtricks);
        }
        DriveObservantly(turns, false); // false = only buff if the Asdon Martin is installed
        UseItem(nasalSpray, wasabi, turns);
        UseItem(wealthy, resolve, turns);
        UseItem(avoidScams, scamTourist, turns);
        CastSkill(leer, leering, turns);
        CastSkillOrBuffBot(polka, polkad, turns, 1);
        CastSkillOrBuffBot(phatLoot, phatLooted, turns, 1);
        RentAHorse();

        if (needWeightBuffs)
        {
            CastSkill(leash, leashEffect, turns);
            CastSkillOrBuffBot(empathy, empathyEffect, turns, 2);
            UseItem(petBuff, petBuffEffect, turns);

            if ((get_campground() contains witchess)
                 && !get_property("_witchessBuff").to_boolean())
            {
                cli_execute("witchess");
            }
        }
        SendBuffRequest();

        if (get_property("_sourceTerminalEnhanceUses").to_int() < 3)
            AdventureEffect(meatEnh, meatEnhanced, turns);

        if (get_property("_madTeaParty") == "false")
            AdventureEffect(hatterDreadSack, danceTweedle, 1);

        if (OutfitContains(defaultOutfit, halfPurse))
        {
            UseItem(flaskfull, merrySmith, turns);
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

        SweetSynth(turns);
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
            TryEat(thanks9, thanksgetting, 2, 0, turns, true);
            if (fistTurkey.have_familiar())
            {
                int turkeyturns = turns > 110 ? 110 : turns; // limit to 5 turkeys a day, since that's all that can drop per day
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
            }
            if (CanDistention() // only worth doing a pantsgiving fullness run if we can get a second fullness point from distention pill
                && thanksgetting.have_effect() < turns // only if more turns of the effect were requested
                && my_fullness() == fullness_limit()) // pants can't activate without being completely full
            {
                if (TryActivatePantsgivingFullness())
                {
                    use(1, distention);
                    // eat any that haven't been eaten yet
                }
            }
            TryBonusThanksgetting();
        }

        DriveObservantly(turns, true); // true == request to install the Asdon Martin
        MaxManaSummons();
    }


    string runawayFilter(int round, monster mon, string page)
    {
        return "run away";
    }
    string ReadyRunaway()
    {
        if (stompingBoots.have_familiar())
        {
            SwitchToFamiliar(stompingBoots);
            return "runawayFilter";
        }
        else if (bandersnatch.have_familiar())
        {
            SwitchToFamiliar(stompingBoots);
            CastSkillOrBuffBot(odeToBooze, odeToBoozeEffect, 1, 5);
            return "runawayFilter";
        }
        return "Filter_Standard";
    }
      
    boolean IsPurpleLightAvailable()
    {
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
        head.equip(gingerHead);
        shirt.equip(gingerShirt);
        pants.equip(gingerPants);
        acc1.equip(gingerAcc1);
        acc2.equip(gingerAcc2);
        acc3.equip(gingerAcc3);
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
        if (GetRemainingFreeRunaways() < 3)
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
            if (GetRemainingFreeRunaways() < 1)
            {
                print("Out of free runaways, " + (3 - i) + " adventures left until train candy.");
                return;
            }
            gingerTrain.adv1(-1, filter);
        }
        page = LoadChoiceAdventure(gingerTrain, false);
        run_choice(1); // dig for candy
        if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
            put_closet(swizzler.item_amount(), swizzler);

        if (GetRemainingFReeRunaways() < 9)
        {
            print("Out of free runaways, 9 adventures left until midnight.");
            return;
        }
        if (!HaveGingerbreadBest())
            return;
        for (int i = 0; i < 9; i++) // run away 9 times
        {
            gingerRetail.adv1(-1, filter);
        }
        WearGingerbreadBest();
        page = LoadChoiceAdventure(gingerRetail, false);
        run_choice(2); // enter party
        if (gingerSprinkles.item_amount() >= 300)
            run_choice(2); // buy chocolate sculpture
        else
        {
            print("Out of sprinkles, taking a drink instead of chocolate sculpture.");
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
                run_combat(filter);
                return;
            }
            if (page.contains_text("Gimme Steam")) // goto steampunk
            {
                page = visit_url("choice.php?option=4&pwd=" + my_hash() + "&whichchoice=675", false); // gimme steam
            }
            else if (page.contains_text("End His Suffering")) // fight goth
            {
                page = visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=675", false); // end his suffering
                run_combat(filter);
                return;
            }
            if (page.contains_text("Copper Feel"))
                run_choice(2); // investigate whirligigs, skip adventure
        }
        else
            run_combat(filter);
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
            run_combat(filter);
    }
    void SemiRarePurpleLight()
    {
        string filter = ReadyRunaway(); // should be a non-combat, so runaway if it's not
        //purpleLight.adv1(-1, filter);
        string page = visit_url("adventure.php?snarfblat=172"); // purple light district
        if (page.contains_text("choice.php"))
            run_choice(1);
        else
            run_combat(filter);
    }
    void SemiRareEmbezzler()
    {
        PrepareEmbezzler();
        //treasury.adv1(-1, "Filter_Standard");
        visit_url("adventure.php?snarfblat=260"); // treasury
        run_combat("Filter_Standard");
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
        print("Trying to activate " + copyItem.to_string() + " for embezzler");
        visit_url("inv_use.php?whichitem=" + copyItem.to_int());
        run_combat("Filter_Standard");
        return true;
    }
    boolean EmbezzlerScheduled()
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
    boolean RunCopiedEmbezzler()
    {
        PrepareEmbezzler();
        if (EmbezzlerPuttied())
        {
            print("using spooky putty embezzler");
            needsSpookyPutty = get_property("spookyPuttyCopiesMade").to_int() < 5;
            return ActivateCopyItem(usedSpookyPutty);
        }
        else if (EmbezzlerRainDohed())
        {
            print("using rain doh embezzler");
            needsRainDoh = true;
            return ActivateCopyItem(usedRainDoh);
        }
        else if (EmbezzlerPrintScreened())
        {
            print("using print screen embezzler");
            set_property("_printscreensUsedToday", (get_property("_printscreensUsedToday").to_int() + 1).to_string()); // to avoid using all the print screens in one day

            needsPrintScreen = true;
            return ActivateCopyItem(usedPrintScreen);
        }
        else if (EmbezzlerCameraed())
        {
            print("using camera embezzler");
            needsCamera = true;
            return ActivateCopyItem(usedcamera);
        }
        else if (EmbezzlerChateaud())
        {
            print("using Chateau painting embezzler");
            visit_url("place.php?whichplace=chateau&action=chateau_painting");
            run_combat("Filter_Standard");
            return true;
        }
        print("no embezzler found");
        return false;
    }

    boolean needsLube = false;
    boolean lubeChecked = false;

    void CheckLubeQuest()
    {
        if (lubeChecked)
            return;

        lubeChecked = true;
        if (LoadChoiceAdventure("place.php?whichplace=airport_stench&action=airport3_tunnels", "Maint Misbehavin'", false))
        {
            run_choice(6); // Waste Disposal
        }
        string page = visit_url("questlog.php?which=7");
        if (page.contains_text("rollercoaster in order to lubricate the tracks"))
        {
            needsLube = true;
        }
        if (needsLube)
            return;
        page = visit_url(kioskUrl);
        int choice = FindVariableChoice(page, "Track Maintenance");
        if (choice > 0)
        {
            print("Taking quest Track Maintenance option " + choice.to_string());
            run_choice(choice);
        }
    }
    void RunBarfMountain(boolean requireOutfit)
    {
        if (EmbezzlerScheduled())
        {
            PrepareEmbezzler();
        }
        else
        {
            PrepareBarf(requireOutfit);
        }
        CheckLubeQuest();

        if (needsLube)
        {
            if (LoadChoiceAdventure(barfMountain, true))
            {
                print("Skipping adventure to equip lube-shoes and come back in.");
                run_choice(6);  // skip and come back later
                if (!lubeShoes.have_equipped())
                    acc3.equip(lubeShoes);
                needsLube = false;
                LoadChoiceAdventure(barfMountain, false);
                run_choice(1);  // ride the rollercoaster
                if (LoadChoiceAdventure(kioskUrl, "Employee Assignment Kiosk", false))
                    run_choice(3); // turn in the quest
            }
            else
            {
                run_combat("Filter_Standard");
            }
        }
        else
        {
            barfMountain.adv1(-1, "Filter_Standard");
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
            if (BoTnonspell1.have_skill() && my_mp() > BoTnonspell1.mp_cost())
                return "skill " + BoTnonspell1.to_string();
            if (CanMortar >= 2)
            {
                CanMortar = 1;
                return "skill " + BoTspell0.to_string();
            }
     
            if (BoTspell3.have_skill() && my_mp() > BoTspell3.mp_cost()) // saucestorm
                return "skill " + BoTspell3.to_string();
        }
        else // equivaocator
        {
            if (can_still_steal())
                return "\"pickpocket\"";
            if (CanMortar >= 1)
            {
                CanMortar = 0;
                return "skill " + BoTspell0.to_string();
            }
        }
        if (BoTnonspell0.have_skill() && my_mp() > BoTnonspell0.mp_cost())
            return "skill " + BoTnonspell0.to_string();
        if (BoTspell3.have_skill() && my_mp() > BoTspell3.mp_cost()) // saucestorm
            return "skill " + BoTspell3.to_string();
        return "";
    }
    void PrepareFilterLOV()
    {
        CanMortar = BoTspell0.have_skill() ? 3 : 0;
    }
    
    void RunLOVTunnel()
    {
        if (!summonRes.have_skill())
            return;
    
        if (get_property("loveTunnelAvailable") != "true" || get_property("_loveTunnelUsed") == "true")
            return;
        
        ChooseDropsFamiliar(false); // hmm tradeoff between familiar drops, familiar assist, or non-acting to get elixir...
        print("Running LOV tunnel");
        PrepareFilterLOV();
        restore_hp(my_maxhp() - my_hp());
    
        visit_url("place.php?whichplace=town_wrong");
        if (!LoadChoiceAdventure("place.php?whichplace=town_wrong&action=townwrong_tunnel", "LOV Tunnel", false))
            return;
        run_choice(1); // Enter the tunnel

        // cannot use run_choice() to start the fight, or you won't get a combat filter? 
        visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1223&option=1"); // Fight LOV Enforcer
        run_combat("Filter_LOVTunnel");
        LoadChoiceAdventure("choice.php", "Choose LOV gear", false);
        run_choice(3); // LOV Earrings
    
        visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1225&option=1"); // Fight LOV Engineer
        run_combat("Filter_LOVTunnel");
        LoadChoiceAdventure("choice.php", "Choose LOV buff", false);
        run_choice(2); // open heart surgery
    
        visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1227&option=1"); // Fight LOV Equivocator
        run_combat("Filter_LOVTunnel");
        LoadChoiceAdventure("choice.php", "Choose LOV gift", false);
        run_choice(1); // LOV Enamorang
    }
    void MaxManaSummons()
    {
        if (!summonRes.have_skill())
            return;
        if (!UserConfirmDefault("Do you wish to maximize mana to summon as many resolutions as possible?", true))
            return;
        BurnManaAndRestores(0, true);

        // increase max mana before doing the 100% restores
        if (sweetSynth.have_skill())
        {
            if (synthMP.have_effect() == 0)
                sweet_synthesis(milkStud, seniorMint);
            if (synthMyst.have_effect() == 0)
                sweet_synthesis(milkStud, daffyTaffy);
        }

        if (get_property("telescopeUpgrades").to_int() > 0 && get_property("telescopeLookedHigh") == "false")
            cli_execute("telescope high"); // +stats

        visit_url("place.php?whichplace=spacegate"); // have to visit it to see if we have access
        if (get_property("spacegateVaccine") != "true" && get_property("_spacegateToday") == "true")
            cli_execute("spacegate vaccine 2"); // +stats

        if (muscle.my_basestat() > mysticality.my_basestat())
        {
            BuyAndUseOneTotal(muscleToMyst, muscleToMystEffect, 2000);
        }
        else if (moxie.my_basestat() > mysticality.my_basestat())
        {
            BuyAndUseOneTotal(moxieToMyst, moxieToMystEffect, 2000);
        }
        BuyAndUseOneTotal(hawkings, hawkingsEffect, 1000);
        BuyAndUseOneTotal(occult, occultEffect, 400);
        BuyAndUseOneTotal(tomatoJuice, tomatoJuiceEffect, 400);
        BuyAndUseOneTotal(mascara, mascaraEffect, 30);
        if (circleDrum.item_amount() > 0 && get_property("_circleDrumUsed") != "true")
        {
            UseOneTotal(circleDrum, circleDrumEffect);
        }

        int freeRests = total_free_rests() - get_property("timesRested").to_int();
        while (freeRests > 0)
        {
            if (HaveEquipment(pantsGiving)) // increases rest
                pants.equip(pantsGiving);
            if (get_campground() contains pilgrimHat) // pilgrim hat gives explicit buffs, which may be useful
                visit_url("campground.php?action=rest");
            else
                cli_execute("rest 1");
            freeRests -= 1;
                
            BurnManaAndRestores(20, true);
        }
        if (!HaveEquipment(sphygmayo) && (get_campground() contains mayoClinic))
            cli_execute("buy 1 " + sphygmayo.to_string());
        outfit("Max MP");
        RunLOVTunnel();
        int keep = (licenseChill.item_amount() > 0 && get_property("_licenseToChillUsed") == "false") ? 50 : 0;
        BurnManaAndRestores(keep, true);
        if (keep > 0)
            use(1, licenseChill);
        keep = (yexpressCard.item_amount() > 0 && get_property("expressCardUsed") == "false") ? 50 : 0;
        BurnManaAndRestores(keep, true);
        if (keep > 0)
            use(1, yexpressCard);
        keep = 20;
        if (clarasBell.item_amount() > 0 && get_property("_claraBellUsed") == "false"
            && HaveEquipment(hoboBinder))
        {
            // todo: maybe grab mana restore from hobopolis using clara's bell.
            // Maybe this should go at the beginning before any other buffs have been given,
            // because this will cost a turn.  That means we'd want to pre-buff mana as well
            // before triggering the restore
        }
        BurnManaAndRestores(keep, true);
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
            RunawayGingerbread();
        for (int i = 0; i < turnCount || (turnCount < 0); i++)
        {
            print("LinknoidBarf Turns remaining = " + (turnCount - i));
            BurnManaAndRestores(20, false);
          
            PrepareStandardFilter();
            if (turnCount < 0 && !hasFreeKillRemaining)
                return;
            if (needBagOTricks)
                TryActivateBagOTricks();
            
            SoulSauceToMana();
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
            if (CopiedEmbezzlerAvailable())
            {
                print("Running copied embezzler");
                PrepareFamiliar(true);
                if (RunCopiedEmbezzler())
                    continue;
            }
            PrepareFamiliar(false);
            print("Running barf mountain");
            RunBarfMountain(true);
        }
    }

    void SetRunFamiliar(string familiarName)
    {
        if (familiarName == "" && get_property("_roboDrinks").contains_text(roboMeat.to_string()))
            familiarName = robort.to_string();

        familiar fam = familiarName.to_familiar();
        if (fam.to_int() < 0 && familiarName != "none")
        {
            fam = my_familiar();
        }
        print("Running with familiar " + fam.to_string());
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
        SetRunFamiliar(familiarName);
        
        if (buffTurns > 0 || runTurns > 0)
            EnsureAccess();
        if (buffTurns != 0)
            BuffTurns(buffTurns);
        if (runTurns != 0)
            RunTurns(runTurns);
    }

