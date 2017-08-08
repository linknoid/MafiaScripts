// LINKNOIDBARF.ASH


    string defaultOutfit = "barf";

    int saveDigitizes = 1;
    int savePutties = 0;
    int useCameras = 0;
    int usePrintScreens = 1;
    boolean allowExpensiveBuffs = true;

    // _firedJokestersGun
    // _shatteringPunchUsed
    // _usedReplicaBatoomerang
    // _gingerbreadMobHitUsed

    // _thanksgettingFoodsEaten
    // _timeSpinnerMinutesUsed
    // _witchessFights
    // _witchessBuff
    // _glennGoldenDiceUsed
    // _sourceTerminalDigitizeMonsterCount
    // _sourceTerminalDigitizeUses
    // _sourceTerminalEnhanceUses
    // _sourceTerminalExtrudes

    // _raindohCopiesMade
    // spookyPuttyCopiesMade

    // screencappedMonster
    // spookyPuttyMonster
    // _cameraMonster
    // _sourceTerminalDigitizeMonster

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
    slot shirt = ToSlot("shirt");
    slot weapon = ToSlot("weapon");
    slot offhand = ToSlot("off-hand");
    slot pants = ToSlot("pants");
    slot acc1 = ToSlot("acc1");
    slot acc2 = ToSlot("acc2");
    slot acc3 = ToSlot("acc3");
    slot famEqp = ToSlot("familiar");

    // campground items
    item witchess = ToItem("Witchess Set");
    item terminal = ToItem("Source terminal");


    // items for eating
    item milk = ToItem("milk of magnesium");
    effect gotmilk = "Got Milk".ToEffect();
    item mayoClinic = ToItem("portable Mayo Clinic");
    item mayoFullToDrunk = ToItem("Mayodiol"); // 1 full to drunk
    item mayoIncreaseStats = ToItem("Mayozapine"); // double stats
    item cashew = ToItem("cashew");
    item cornucopia = ToItem("cornucopia");
    item horseradish = ToItem("jumping horseradish");
    item foodCone = "Dinsey food-cone".ToItem();
    item seaTruffle = "sea truffle".ToItem();
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


    //
    item dirt = ToItem("dirt julep"); // booze from plants with robortender
    item gingerWine = ToItem("high-end ginger wine"); // from gingertown
    item turkey = ToItem("Ambitious Turkey"); // from hand turkey

    // spleen items
    item egg1 = ToItem("black paisley oyster egg");
    item egg2 = ToItem("black polka-dot oyster egg");
    item egg3 = ToItem("black striped oyster egg");
    // Sweet Synthesis
    item ww = ToItem("bag of W&Ws");

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

// fist turkey
    familiar fistTurkey = ToFamiliar("Fist Turkey");

    // Skills and items for extending buffs
    item bagOtricks = ToItem("Bag O' Tricks");
    item jokesterGun = ToItem("Jokester's Gun");
    item replicaBatommerang = ToItem("Replica Bat-oomerang");
    skill shatteringPunch = ToSkill("Shattering Punch");
    skill gingerbreadMobHit = ToSkill("Gingerbread Mob Hit");

    skill meteorShower = ToSkill("Meteor Shower");

    // Skills for consumption
    skill odeToBooze = ToSkill("The Ode to Booze");

    // skills for +meat bonus
    skill leer = ToSkill("Disco Leer");
    skill polka = ToSkill("The Polka of Plenty");
    skill sweetSynth = ToSkill("Sweet Synthesis");
    // skiils for pet bonus
    skill leash = ToSkill("Leash of Linguini");
    skill empathy = ToSkill("Empathy of the Newt");
    item petBuff = ToItem("Knob Goblin pet-buffing spray");
    item kinder = ToItem("resolution: be kinder");
    item joy = ToItem("abstraction: joy");

    // items for +meat bonus
    item blBackpack = ToItem("Bakelite Backpack"); // with accordion bash
    item halfPurse = ToItem("Half a Purse"); // requires Smithsness to be effective
    item sunglasses = ToItem("cheap sunglasses"); // only relevant for barf mountain
    item nasalSpray = ToItem("Knob Goblin nasal spray"); // bought from knob goblin dispensary
    item wealthy = ToItem("resolution: be wealthier"); // from machine elf
    item avoidScams = ToItem("How to Avoid Scams"); // only relevant for barf mountain
    item flaskfull = ToItem("Flaskfull of Hollow"); // + smithness for Half a Purse
    item dice = ToItem("Glenn's golden dice"); // once a day random buffs
    item pantsGiving = ToItem("Pantsgiving"); // wear for combat skills, fullnes reduction

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
    effect odeToBoozeEffect = "Ode to Booze".ToEffect(); //
    effect winklered = "Winklered".ToEffect(); // from concert if you helped orcs
    effect sinuses = "Sinuses For Miles".ToEffect(); // from Mick's
    effect wasabi = "Wasabi Sinuses".ToEffect(); // from Knob Goblin nasal spray
    effect resolve = "Greedy Resolve".ToEffect(); // from resolution: be wealthy
    effect scamTourist = "How to Scam Tourists".ToEffect(); // from How to Avoid Scams
    effect leering = "Disco Leer".ToEffect(); // from Disco Leer (disco bandit skill)
    effect polkad = "Polka of Plenty".ToEffect(); // from Polka (accordion thief)
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

    // effects for pet weight bonus
    effect leashEffect = ToEffect("Leash of Linguini");
    effect empathyEffect = ToEffect("Empathy");
    effect petBuffEffect = ToEffect("Heavy Petting");
    effect kinderEffect = ToEffect("Kindly Resolve");

    // skills to activate Bag O' Tricks
    skill spell1 = ToSkill("Stream of Sauce");
    skill spell2 = ToSkill("Saucestorm");
    skill spell3 = ToSkill("Wave of Sauce");
    skill spell4 = ToSkill("Spaghetti Spear");
    skill spell5 = ToSkill("Cannelloni Cannon");

    // between turns skills
    skill summonRes = ToSkill("Summon Resolutions");
    // reducing mana costs

    // locations for adventuring
    location garbagePirates = ToLocation("Pirates of the Garbage Barges"); // for orphan costume
    location covePirates = ToLocation("The Obligatory Pirate's Cove"); // alternate for orphan costume... wait a second, we should always have main pirates location
    location castleTopFloor = ToLocation("The Castle in the Clouds in the Sky (Top Floor)"); // semi-rare
    location treasury = ToLocation("Cobb's Knob Treasury"); // semi-rare
    location barfMountain = ToLocation("Barf Mountain"); // main adventure location


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

    monster embezzler = "Knob Goblin Embezzler".to_monster();
    monster tourist = "garbage tourist".to_monster();
    effect olfaction = "On the Trail".ToEffect();



    boolean pendingPrintScreen = false;
    boolean pendingCamera = false;

    boolean EmbezzlerPrintScreened()
    {
        return get_property("screencappedMonster") == embezzler.to_string();
    }
    boolean EmbezzlerCameraed()
    {
        return get_property("cameraMonster") == embezzler.to_string();
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

    boolean IsAccordion(item it)
    {
        return it.item_type() == "accordion";
    }


boolean canPickpocket = false;
boolean canPocketCrumb = false;
boolean canAccordionBash = false;
string bagOTricksSkill = "";
boolean needsSpookyPutty = false;
boolean needsRainDoh = false;
boolean needsDigitize = false;
boolean needsPrintScreen = false;
boolean needsCamera = false;
boolean needsEnamorang = false;
    void prepareStandardFilter()
    {
        if (!canPickpocket)
        {
            canPickpocket = my_class().to_string() == "Disco Bandit" || my_class().to_string() == "Accordion Thief";
        }
        canPocketCrumb = pantsGiving.item_amount() > 0;
        //canAccordionBash = ???;
        if (!needsSpookyPutty)
        {
            needsSpookyPutty = spookyPutty.item_amount() > 0 && get_property("spookyPuttyCopiesMade").to_int() < 5;
        }
        int digitizeCount = get_property("_sourceTerminalDigitizeUses").to_int();
        needsDigitize = digitizeCount == 0
            || (digitizeCount < 3
            && get_property("_sourceTerminalDigitizeMonsterCount").to_int() >= 4);
        //needsEnamorang = enamorang.item_amount() > 0
        //    && get_property("enamorangMonster") != embezzler.to_string();
    }
    string standardFilter(int round, monster mon, string page)
    {
        static boolean pocketCrumbed = false;
        static boolean accordionBashed = false;
        static boolean bagOTricksOpened = false;
        static boolean digitized = false;
        static boolean meteorShowered = false;

        if (round == 0) print("using standardFilter");

        if (canPickpocket && can_still_steal())
        {
            return "\"pickpocket\"";
        }
        if (canPocketCrumb && !pocketCrumbed)
        {
            pocketCrumbed = true;
            return "skill Pocket Crumbs";
        }
        if (mon == tourist && olfaction.have_effect() == 0)
        {
            return "skill Transcendent Olfaction";
        }
        if (canAccordionBash)
        {
            return "skill Accordion Bash";
        }
        if (mon == embezzler) // capture embezzler
        {
            if (needsDigitize && !digitized)
            {
                digitized = true;
                return "skill Digitize";
            }
            string s = "";
            int itemCount = 0;
            if (needsSpookyPutty)
            {
                s += spookyPutty.to_string();
                needsSpookyPutty = false;
                itemCount++;
            }
            if (needsPrintScreen)
            {
                if (itemCount == 1)
                    s += ",";
                s += printScreen.to_string();
                needsPrintScreen = false;
                itemCount++;
            }
            if (needsCamera && itemCount < 2)
            {
                if (itemCount == 1)
                    s += ",";
                s += camera.to_string();
                needsCamera = false;
                itemCount++;
            }
            if (needsRainDoh && itemCount < 2)
            {
                if (itemCount == 1)
                    s += ",";
                s += rainDoh.to_string();
                needsRainDoh = false;
                itemCount++;
            }
            if (needsEnamorang && itemCount < 2)
            {
                if (itemCount == 1)
                    s += ",";
                s += enamorang.to_string();
                needsEnamorang = false;
                itemCount++;
            }
            if (itemCount > 0)
            {
                if (itemCount == 1)
                    s += ",none";
                return "item " + s;
            }
            if (jokesterGun.item_amount() > 0
                && !get_property("_firedJokestersGun").to_boolean())
            {
                if (weapon.equip(jokesterGun))
                    return "skill Fire Jokster's Gun";
            }
            if (replicaBatommerang.item_amount() > 0
                && get_property("_usedReplicaBatoomerang").to_int() < 3)
            {
                return "item Replica Bat-oomerang";
            }
            if (shatteringPunch.have_skill()
                && get_property("_shatteringPunchUsed").to_int() < 3)
            {
                return "skill Shattering Punch";
            }
            if (gingerbreadMobHit.have_skill()
                && !get_property("_gingerbreadMobHitUsed").to_boolean())
            {
                return "skill Gingerbread Mob Hit";
            }
            if (meteorShower.have_skill() && !meteorShowered)
            {
                meteorShowered = true;
                return "skill Meteor Shower";
            }
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
        return puttyAvailable - (puttiesUsed + raindohsUsed + savePutties);
    }

    // always make sure we have one copy of the embezzler left
    string BuildCopyEmbezzler()
    {
        pendingPrintScreen = false;
        pendingCamera = false;

        int existingCopyCount = 0;
        boolean screenCapped = EmbezzlerPrintScreened();
        boolean cameraed = EmbezzlerCameraed();
        boolean dohed = EmbezzlerRainDohed();
        boolean puttied = EmbezzlerPuttied();
        boolean digitized = EmbezzlerDigitized();
        if (screenCapped)
            existingCopyCount++;
        if (cameraed)
            existingCopyCount++;
        if (dohed)
            existingCopyCount++;
        if (puttied)
            existingCopyCount++;

        string digitize = "";
        string copy = "";

        int digitizes = get_property("_sourceTerminalDigitizeUses").to_int();
        if (digitizes + saveDigitizes < 3)
        {
            if (!digitized)
            {
                // todo: space the digitizes out for optimal number
                digitize = "skill Digitize\r\n";
            }
        }

        if (existingCopyCount == 0)
        {
            int puttyRemaining = PuttyCopiesRemaining();
            if (puttyRemaining > 0)
            {
                if (spookyPutty.item_amount() > 0)
                    copy = "item " + spookyPutty.to_string() + "\r\n";
                else if (rainDoh.item_amount() > 0)
                    copy = "item " + rainDoh.to_string() + "\r\n";
            }
            if (copy == "")
            {
                if (get_property("printscreensUsedToday").to_int() < usePrintScreens
                    && (printScreen.item_amount() > 0 || BACON.item_amount() >= 111))
                {
                    pendingPrintScreen = true;
                    copy = "item " + printScreen.to_string() + "\r\n";
                }
                else if (get_property("camerasUsedToday").to_int() < useCameras && camera.item_amount() > 0)
                {
                    pendingCamera = true;
                    copy = "item " + rainDoh.to_string() + "\r\n";
                }
            }
        }
        return digitize + copy;
    }

    boolean CopiedEmbezzlerAvailable()
    {
        if (PuttyCopiesRemaining() > 0)
            return true;
        if (EmbezzlerDigitized())
        {
            return PuttyCopiesRemaining() > 1;
        }
        int count = 0;
        if (EmbezzlerPrintScreened())
            count++;
        if (EmbezzlerCameraed())
            count++;
        if (EmbezzlerRainDohed())
            count++;
        if (EmbezzlerPuttied())
            count++;
        return count > 0;
    }


    void PrepareEmbezzler()
    {
        outfit(defaultOutfit);
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
    void PrepareBarf()
    {
        if (!is_wearing_outfit(defaultOutfit))
            outfit(defaultOutfit);
    }
    string AvailableSpellForBagOfTricks()
    {
        if (spell1.have_skill())
            return spell1.to_string();
        if (spell2.have_skill())
            return spell2.to_string();
        if (spell3.have_skill())
            return spell3.to_string();
        if (spell4.have_skill())
            return spell4.to_string();
        if (spell5.have_skill())
            return spell5.to_string();
        return "";
    }
    string PrepareUseBagOfTricks()
    {
        if (bagOtricks.item_amount() < 1)
            return "";
        {
            string s = AvailableSpellForBagOfTricks();
            if (s == "")
                return "";
            return AvailableSpellForBagOfTricks();
        }
    }
    void CheckBagOfTricksUsage()
    {
    }
    void PreparePirates()
    {
    }

    boolean IsAccordion(item weapon)
    {
        if (weapon.to_string() == "Accord ion")
            return true;
        return false;
    }


    string BuildCombatString(boolean isEmbezzler, string specialSkill)
    {
        int pickpocketCount = 0;
        string startCombat = "";
        string initialSkills = "";
        string maybeFinisher = "";
        string finisher = "attack with weapon";

        if (isEmbezzler)
            startCombat = BuildCopyEmbezzler();
        if (blBackpack.have_equipped()
            && "Accordion Bash".to_skill().have_skill()
            && IsAccordion(weapon.equipped_item())
            )
        {
            initialSkills = "skill Accordion Bash\r\n";
        }
        switch (my_class().to_string())
        {
            case "Seal Clubber":
                finisher = "skill Lunge Smack";
                break;
            case "Turtle Tamer":
                finisher = "skill Headbutt";
                break;
            case "Pastamancer":
                finisher = "skill Cannelloni Cannon";
                break;
            case "Sauceror":
                finisher = "skill Saucestorm";
                break;
            case "Accordion Thief":
                pickpocketCount = 1;
                break;
            case "Disco Bandit":
                pickpocketCount = 1;
                if ("Bling of the New Wave".to_item().have_equipped())
                    pickpocketCount = 2;
                initialSkills += "combo rave nirvana\r\ncombo rave concentration";
                maybeFinisher = "skill Disco Dance of Doom\r\nskill Disco Dance II: Electric Boogaloo\r\nskill Knife in the Dark";
                break;
        }
        buffer result;
        for (int i = 0; i < pickpocketCount; i++)
            result.append("pickpocket\r\n");

        if (startCombat != "")
            result.append(startCombat).append("\r\n");

        if (initialSkills != "")
            result.append(initialSkills).append("\r\n");

        if (specialSkill != "")
            result.append(specialSkill).append("\r\n");

        if (maybeFinisher != "")
            result.append(maybeFinisher).append("\r\n");

        for (int i = 0; i < 5; i++)
            result.append(finisher).append("\r\n");

        return result.to_string();
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

    item oscusWeapon = ToItem("Wand of Oscus");
    item oscusPants = ToItem("Oscus's dumpster waders");
    item oscusAccessory = ToItem("Oscus's pelt");
    item brimstoneBracelet = ToItem("Brimstone Bracelet");
    item rubber = ToItem("orcish rubber");
    effect rubberEffect = ToEffect("Using Protection");
    void TryReduceManaCost(skill skll)
    {
        if (mysticality.my_basestat() >= 200
            && oscusWeapon.item_amount() > 0
            && oscusPants.item_amount() > 0
            && oscusAccessory.item_amount() > 0)
        {
            weapon.equip(oscusWeapon);
            pants.equip(oscusPants);
            acc1.equip(oscusAccessory);
        }
        if (mysticality.my_basestat() >= 30
            && brimstoneBracelet.item_amount() > 0)
        {
            acc2.equip(brimstoneBracelet);
        }
        if (skll.mp_cost() > 2 && skll.mp_cost() < 12 // Too small, no effect. Too big, and insignificant
            && rubberEffect.have_effect() <= 0
            && rubber.item_amount() > 0)
        {
            use(1, rubber);
        }
    }

    void CastSkill(skill skll, effect resultingEffect, int requestedTurns)
    {
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
            CastSkill(odeToBooze, odeToBoozeEffect, providedDrunk);
        }
        
        drink(1, booze);
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

    boolean HaveEaten(item food)
    {
        string eatenList = get_property("_timeSpinnerFoodAvailable");
        string itemID = food.to_int().to_string();
        return InList(itemID, eatenList, ",");
    }

    void TryEat(item food, effect desiredEffect, int providedFullness, int followupFullness, int turnLimit, boolean eatUnique)
    {
        if (desiredEffect.have_effect() >= turnLimit)
            return;

        if (eatUnique && HaveEaten(food))
            return;


        UseItem(milk, gotmilk, 2);

        int remainingFullness = fullness_limit() - my_fullness();
        if (providedFullness > remainingFullness)
            return;
        boolean remainingDrunk = my_inebriety() < inebriety_limit();
        boolean convertToDrunk = remainingDrunk
            && (followupFullness > remainingFullness);
        item mayo;
        if (convertToDrunk)
        {
            mayo = mayoFullToDrunk;
        }
        else
        {
            mayo = mayoIncreaseStats;
        }
        if (!use(1, mayo))
        {
            if (mayoClinic.item_amount() > 0)
            {
                use(1, mayoClinic);
            }
            if (mayo.item_amount() > 0 || buy_using_storage(1, mayo))
            {
                use(1, mayo);
            }
        }
        eat(1, food);
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
                if (pirateCostume.item_amount() >= 1)
                {
                    break;
                }
                PreparePirates();
                if (!pirates.adv1(0, BuildCombatString(false, PrepareUseBagOfTricks())))
                {
                    pirates = covePirates;
                }
            }
        }
    }
    void ValidateRobortender(item booze, string drinkList)
    {
        if (InList(booze.to_string(), drinkList, ","))
            return;
        if (booze.item_amount() <= 0)
        {
            if (!user_confirm("Don't have any " + booze.to_string() + " for Robortender, do you wish to continue?"))
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

        ValidateRobortender(roboMeat, drinkList);
        ValidateRobortender(roboItems, drinkList);
        ValidateRobortender(roboMana, drinkList);
        ValidateRobortender(roboHobo, drinkList);
        ValidateRobortender(roboCandy, drinkList);
        if (get_property("_roboDrinks") == "")
        {
            robort.use_familiar();
            FeedRobortender(roboMeat, drinkList);
            FeedRobortender(roboItems, drinkList);
            FeedRobortender(roboMana, drinkList);
            FeedRobortender(roboHobo, drinkList);
            FeedRobortender(roboCandy, drinkList);
        }
    }

    void UseOne(item itm, effect efct)
    {
        if (itm.item_amount() > 0 && efct.have_effect() == 0)
        {
            use(1, itm);
        }
    }
    void BuffTurns(int turns, familiar fam)
    {
        boolean needWeightBuffs = true;
        boolean nightBefore = turns < 0;
        boolean expensiveBuffs =
            nightBefore
            && allowExpensiveBuffs
            && (PuttyCopiesRemaining() >= 5);

        if (fam == orphan)
        {
            needWeightBuffs = false;
            GetPirateCostume();
        }
        else if (fam.name == "none")
        {
            needWeightBuffs = false;
        }
        else if (fam == robort)
        {
            if (!nightBefore)
                FeedRobotender();
        }


        AdventureEffect(summonGreed, preternatualGreed, 1);
        AdventureEffect(concertWinklered, winklered, 1);

        if (nightBefore)
        {
            turns = 1;
            SweetSynth(1);
            if (expensiveBuffs)
            {
                UseOne(micks, sinuses);
                UseOne(peppermint, peppermintEffect);
                UseOne(sugar, sugarEffect);
                UseOne(pinkHeart, pinkHeartEffect);
                if (needWeightBuffs)
                {
                    UseOne(kinder, kinderEffect);
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

        if (bagOtricks.item_amount() > 0) // want to maximize our chances of increasing the limited/expensive effects, rather than the cheaper ones
        {
            use(1, bagOtricks);
        }


        UseItem(nasalSpray, wasabi, turns);

        UseItem(wealthy, resolve, turns);

        UseItem(avoidScams, scamTourist, turns);

        CastSkill(leer, leering, turns);

        CastSkill(polka, polkad, turns);

        if (needWeightBuffs)
        {
            CastSkill(leash, leashEffect, turns);
            CastSkill(empathy, empathyEffect, turns);
            UseItem(petBuff, petBuffEffect, turns);

            if ((get_campground() contains witchess)
                 && !get_property("_witchessBuff").to_boolean())
            {
                cli_execute("witchess");
            }
        }

        AdventureEffect(meatEnh, meatEnhanced, turns);

        AdventureEffect(hatterDreadSack, danceTweedle, 1);

        boolean needSmithness = false;
        foreach key,value in outfit_pieces(defaultOutfit)
            if (value.to_string() == halfPurse.to_string())
                needSmithness = true;

        if (needSmithness)
        {
            UseItem(flaskfull, merrySmith, turns);
        }

        if (!get_property("_glennGoldenDiceUsed").to_boolean()
            && dice.item_amount() > 0)
        {
            use(1, dice);
        }

        TryDrink(dirt, dirtEffect, 1, turns);
        if (nightBefore)
        {
            TryEat(horseradish, kickedInSinuses, 1, 0, turns, false);
            TryEat(foodCone, foodConeEffect, 2, 0, turns, false);
            if (expensiveBuffs || fistTurkey.have_familiar())
            {
                TryDrink(turkey, turkeyEffect, 1, turns);
            }
            if (expensiveBuffs)
            {
                TryDrink(gingerWine, gingerWineEffect, 2, turns);
            }
            item bestThanks = ChooseCheapest(thanks1, thanks2);
            bestThanks = ChooseCheapest(bestThanks, thanks3);
            bestThanks = ChooseCheapest(bestThanks, thanks4);
            bestThanks = ChooseCheapest(bestThanks, thanks5);
            bestThanks = ChooseCheapest(bestThanks, thanks6);
            bestThanks = ChooseCheapest(bestThanks, thanks7);
            bestThanks = ChooseCheapest(bestThanks, thanks8);
            bestThanks = ChooseCheapest(bestThanks, thanks9);
            TryEat(bestThanks, thanksgetting, 2, 0, turns, false);
        }
        else
        {
            TryEat(horseradish, kickedInSinuses, 1, 27, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 26, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 25, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 24, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 23, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 22, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 21, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 20, turns, false);
            TryEat(horseradish, kickedInSinuses, 1, 19, turns, false);
            TryEat(thanks1, thanksgetting, 2, 18, turns, true);
            if (distention.item_amount() > 0 && !get_property("_distentionPillUsed").to_boolean()
                && pantsGiving.item_amount() == 0)
            {
                use(1, distention);
            }
            TryEat(thanks2, thanksgetting, 2, 16, turns, true);
            TryEat(thanks3, thanksgetting, 2, 14, turns, true);
            TryEat(thanks4, thanksgetting, 2, 12, turns, true);
            TryEat(thanks5, thanksgetting, 2, 10, turns, true);
            TryEat(thanks6, thanksgetting, 2, 8, turns, true);
            TryEat(thanks7, thanksgetting, 2, 6, turns, true);
            TryEat(thanks8, thanksgetting, 2, 4, turns, true);
            TryEat(thanks9, thanksgetting, 2, 2, turns, true);
            if (fistTurkey.have_familiar())
            {
                int turkeyturns = turns > 125 ? 125 : turns;
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
                TryDrink(turkey, turkeyEffect, 1, turkeyturns);
            }
        }

        SweetSynth(turns);
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

    void RunSemiRare()
    {
        string lastLocation = get_property("semirareLocation");
        if (lastLocation == treasury.to_string())
        {
            castleTopFloor.adv1(0, "standardFilter");
        }
        else
        {
            PrepareEmbezzler();
            treasury.adv1(1, "standardFilter");
       }
    }

    boolean ActivateCopyItem(item copyItem)
    {
	visit_url("inv_use.php?whichitem=" + copyItem.to_int());
        run_combat("standardFilter");
        return true;
    }
    boolean RunCopiedEmbezzler()
    {
        PrepareEmbezzler();
        if (EmbezzlerPuttied())
            return ActivateCopyItem(usedSpookyPutty);
        else if (EmbezzlerRainDohed())
            return ActivateCopyItem(usedRainDoh);
        else if (EmbezzlerPrintScreened())
            return ActivateCopyItem(usedPrintScreen);
        else if (EmbezzlerCameraed() && !get_property("_cameraUsed").to_boolean())
            return ActivateCopyItem(usedcamera);
        return false;
    }


    //location chooseFreeCombat()
    //{
    //}

    //void ActivateBagOfTricksBuff()
    //{
    //    int usedCount = get_property("LB.BagOTricks").to_int();
    //}

    void RunBarfMountain()
    {
        PrepareBarf();

        barfMountain.adv1(-1, "standardFilter");
    }

    void RunTurns(int turnCount, familiar fam)
    {
        for (int i = 0; i < turnCount; i++)
        {
            print("Turns remaining = " + (turnCount - i));
            while (summonRes.have_skill() && summonRes.mp_cost() < (my_mp() - 20))
            {
                use_skill(1, summonRes);
            }
          
            prepareStandardFilter();
            if (get_property("semirareCounter").to_int() == 0)
            {
                print("Running semi-rare");
                RunSemiRare();
                continue;
            }
            else if (CopiedEmbezzlerAvailable())
            {
                print("Running copied embezzler");
                if (RunCopiedEmbezzler())
                    continue;
            }
            print("Running barf mountain");
            RunBarfMountain();
        }
    }

// pass -1 for buffTurns if you're doing "night before" buffing
    void main(int buffTurns, int runTurns, string familiarName)
    {
        familiar fam = familiarName.to_familiar();
        if (fam.to_string() < 0 && familiarName != "none")
        {
            fam = my_familiar();
        }
        print("Running with familiar " + fam.to_string());
        
        AcquireFullFeast();
        if (buffTurns != 0)
            BuffTurns(buffTurns, fam);
        if (runTurns > 0)
            RunTurns(runTurns, fam);
    }
