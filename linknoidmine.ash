// code adapted from hotmine.ash by Smelltastic: https://svn.code.sf.net/p/smellomafia/svn/hotmine/code/

boolean autoConfirmMine = false;
string printColor = "orange";
int saveSpleen = 0; // how many spleen points to save back
int saveStomach = 0; // how many stomach points to save back
int saveLiver = 0; // how many liver points to save back

void WriteSettings()
{
    string[string] map;
    file_to_map("linknoidfarm_" + my_name() + ".txt", map);
    map["autoConfirmMine"] = autoConfirmMine.to_string();
    map["printColor"] = printColor;
    map["saveSpleen"] = saveSpleen.to_string();
    map["saveStomach"] = saveStomach.to_string();
    map["saveLiver"] = saveLiver.to_string();
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
            case "autoConfirmMine": autoConfirmMine = value == "true"; break;
            case "printColor": printColor = value; break;
            case "saveSpleen": saveSpleen = value.to_int(); break;
            case "saveStomach": saveStomach = value.to_int(); break;
            case "saveLiver": saveLiver = value.to_int(); break;
        }
    }
}


slot head = $slot[hat];
slot back = $slot[back];
slot shirt = $slot[shirt];
slot weapon = $slot[weapon];
slot offhand = $slot[off-hand];
slot pants = $slot[pants];
slot acc1 = $slot[acc1];
slot acc2 = $slot[acc2];
slot acc3 = $slot[acc3];
slot famEqp = $slot[familiar];

item noItem = "none".to_item();

// mining gear
item mask = $item[high-temperature mining mask];
item cloak = $item[Misty Cloak];
item cloak2 = $item[Misty Cape];
item drill = $item[high-temperature mining drill];
item lavaPants = $item[lava-proof pants];
item gloves = $item[heat-resistant gloves];
item necktie = $item[heat-resistant necktie];

item xibPuterCode = $item[Xiblaxian holo-wrist-puter simcode];
item xibPuter = $item[Xiblaxian holo-wrist-puter];

item brokenDrill = $item[broken high-temperature mining drill];
item fixDrill = $item[heat-resistant sheet metal];


// volcoinos and day passes
item dayPass = $item[one-day ticket to That 70s Volcano];
item volcoino = $item[Volcoino];

item velvetHead = $item[smooth velvet hat];
item velvetShirt = $item[smooth velvet shirt];
item velvetPants = $item[smooth velvet pants];
item velvetAcc1 = $item[smooth velvet hanky];
item velvetAcc2 = $item[smooth velvet socks];
item velvetAcc3 = $item[smooth velvet pocket square];
item velvet = $item[unsmoothed velvet];

// eating and drinking and spleening
item borrowedTime = $item[borrowed time];
item swizzler = $item[Swizzler];

item spleen4_1 = $item[powdered gold];
item spleen4_2 = $item[agua de vida];
item spleen4_3 = $item[groose grease];
item spleen4_4 = $item[Unconscious Collective Dream Jar];
item spleen3_1 = $item[carrot juice];
item spleen3_2 = $item[prismatic wad];
item spleen1_1 = $item[nasty snuff];
item spleen1_2 = $item[homeopathic mint tea];
item spleen1_3 = $item[transdermal smoke patch];

item perfect1 = $item[perfect cosmopolitan];
item perfect2 = $item[perfect dark and stormy];
item perfect3 = $item[perfect mimosa];
item perfect4 = $item[perfect negroni];
item perfect5 = $item[perfect old-fashioned];
item perfect6 = $item[perfect paloma];

item robodrink1 = $item[gunner's daughter];
item robodrink2 = $item[Gnollish sangria];
item robodrink3 = $item[Elemental caipiroska];
item robodrink4 = $item[Bloody Nora];
item robodrink5 = $item[Mysterious Island iced tea];
item robodrink6 = $item[reverse Tantalus];

item himein1 = $item[cold hi mein];
item himein2 = $item[hot hi mein];
item himein3 = $item[sleazy hi mein];
item himein4 = $item[spooky hi mein];
item himein5 = $item[stinky hi mein];

item lasagna1 = $item[fishy fish lasagna];
item lasagna2 = $item[gnat lasagna];
item lasagna3 = $item[long pork lasagna];

item burrito1 = $item[insanely spicy bean burrito];
item burrito2 = $item[insanely spicy jumping bean burrito];
item burrito3 = $item[insanely spicy enchanted bean burrito];

item milk = $item[milk of magnesium];
effect gotmilk = $effect[Got Milk];
item ruby = $item[Tuesday's Ruby];
item gar = $item[Potion of the Field Gar];
effect garEffect = $effect[Gar-ish];
skill odeToBooze = $skill[The Ode to Booze];
effect odeToBoozeEffect = $effect[Ode to Booze];
item shotglass = $item[mime army shotglass];

item Xtattoo = $item[temporary X tattoos];
effect straightEdge = $effect[Straight-Edgy];
item skeletonX = $item[X];

// sleep gear
item weirdness = $item[solid shifting time weirdness];
familiar stooper = $familiar[Stooper];



boolean UserConfirmDefault(string message, boolean defaultValue)
{
	if (autoConfirmMine)
		return defaultValue;
	return user_confirm(message);
}
boolean HaveItem(item i)
{
	if ( i.item_amount() > 0 || i.equipped_amount() > 0)
		return true;

	if (i.to_slot() == famEqp)
	{
		foreach fam in $familiars[]
		{
			if (fam.have_familiar() && fam.familiar_equipped_equipment() == i)
			{
				return true;
			}
		}
	}
	return false;
}
void BuyItem(item i, int count)
{
	if (!HaveItem(i))
		buy(count, i);
	if (!HaveItem(i))
		abort("Could not acquire " + i.to_string());
}
void BuyItem(item i)
{
	BuyItem(i, 1);
}
void BuyAndWear(item i, slot s)
{
	BuyItem(i);
	s.equip(i);
}

// to prevent "can't equip duplicate item" errors
void ClearAccessorySlots()
{
	acc1.equip($item[none]);
	acc2.equip($item[none]);
	acc3.equip($item[none]);
}
void WearSleepGear()
{
	if (stooper.have_familiar() && my_familiar() != stooper)
	{
		stooper.use_familiar();
	}
	if (my_familiar().to_string() != "none" && HaveItem(weirdness))
	{
		fameqp.equip(weirdness);
	}
	if (have_outfit("Sleep"))
	{
		outfit("Sleep");
		print("Don't forget to nightcap", printColor);
	}
}

void WearMiningGear()
{
	if (my_inebriety() > inebriety_limit())
	{
		print("You are too drunk to continue.");
		return;
	}
	while (!HaveItem(drill))
	{
		print("No high-temperature mining drill found, attempting to get one..", printColor);
		BuyItem(brokenDrill);
		BuyItem(fixDrill);
		use(1, fixDrill);
	}
	if (!HaveItem(xibPuter))
	{
		if (xibPuterCode.item_amount() == 0)
			BuyItem(xibPuterCode);
		use(1, xibPuterCode);
	}
	BuyAndWear(mask, head); // heat resist
	if (cloak.can_equip())
		BuyAndWear(cloak, back); // hp regen
	else if (cloak2.can_equip())
		BuyAndWear(cloak2, back); // hp regen
	BuyAndWear(drill, weapon); // heat resist
	BuyAndWear(lavaPants, pants); // heat resist
	//ClearAccessorySlots();
	if (acc1.equipped_item() == necktie || acc1.equipped_item() == xibPuter)
		acc1.equip($item[none]);
	if (acc2.equipped_item() == xibPuter || acc2.equipped_item() == gloves)
		acc2.equip($item[none]);
	if (acc3.equipped_item() == gloves || acc3.equipped_item() == necktie)
		acc3.equip($item[none]);
	BuyAndWear(gloves, acc1); // heat resist
	BuyAndWear(necktie, acc2); // heat resist
	BuyAndWear(xibPuter, acc3); // mining bonus
	
}

void WearVelvetGear(item i, slot s, int velvetCount)
{
	if (!HaveItem(i))
	{
		if (velvet.item_amount() < velvetCount)
			buy(velvetCount - velvet.item_amount(), velvet);
		if (velvet.item_amount() < velvetCount)
			abort("Could not acquire enough velvet to make " + i.to_string());
		use(velvetCount, velvet);
	}
	s.equip(i);
	if (!i.have_equipped())
		abort("Could not wear " + i.to_string());
}
void WearVelvetGear()
{
	ClearAccessorySlots();
	WearVelvetGear(velvetShirt, shirt, 8); // shirt first in case of torso awareness
	WearVelvetGear(velvetPants, pants, 10); // then most expensive to least
	if (acc1.equipped_item() == velvetAcc2 || acc1.equipped_item() == velvetAcc3)
		acc1.equip($item[none]);
	if (acc1.equipped_item() == velvetAcc1 || acc1.equipped_item() == velvetAcc3)
		acc2.equip($item[none]);
	if (acc1.equipped_item() == velvetAcc1 || acc1.equipped_item() == velvetAcc2)
		acc3.equip($item[none]);
	WearVelvetGear(velvetAcc1, acc1, 9); // hanky
	WearVelvetGear(velvetHead, head, 7); // hat
	WearVelvetGear(velvetAcc2, acc2, 6); // socks
	WearVelvetGear(velvetAcc3, acc3, 5); // pocket square
}

boolean HasAccess()
{
	string page = visit_url("place.php?whichplace=airport");
	return page.contains_text("airport_plane_70s.gif");
}

void EnsureAccess()
{
	if (HasAccess())
		return;

	if (!UserConfirmDefault("No access to 70s Volcano, use a day pass?", true))
		abort("No access to 70s Volcano");

	if (dayPass.item_amount() == 0)
		BuyItem(dayPass);
	if (dayPass.item_amount() == 0)
		abort("Could not acquire " + dayPass.to_string());
	use(1, dayPass);
}

string discoUrl = "place.php?whichplace=airport_hot&action=airport4_zone1";
void DoVelvet()
{
	string page = visit_url(discoUrl);
	if (!page.contains_text("Go to the sixth floor"))
		return;

	if (!UserConfirmDefault("Equip velvet and get volcoinos?", true))
		return;

	WearVelvetGear();

	visit_url(discoUrl);
	run_choice(7); // Go to the sixth floor, Get a Volcoino

}
int[item] bunkerItems =
{
	$item[New Age healing crystal] : 5 , // from mining
	$item[SMOOCH bottlecap] : 1 ,        // from SMOOCH HQ
	$item[gooey lava globs] : 5 ,        // from golem in factory
	$item[SMOOCH bracers] : 3 ,          // craft from superheated metal
	$item[fused fuse] : 1 ,              // easy to get from non-combat
	$item[smooth velvet bra] : 3 ,       // craft from velvet
	$item[Lavalos core] : 1 ,
	$item[Mr. Cheeng's 'stache] : 1 ,
	$item[Saturday Night thermometer] : 1 ,
	$item[glass ceiling fragments] : 1 ,
	$item[Mr. Choch's bone] : 1 ,
	$item[The One Mood Ring] : 1 ,
	$item[half-melted hula girl] : 1 ,
	$item[Pener's crisps] : 1 ,
	$item[signed deuce] : 1 ,
	$item[the tongue of Smimmons] : 1 ,
	$item[Raul's guitar pick] : 1 ,
	$item[superduperheated metal] : 1  // this tends to be really expensive, so check it last
};
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


string availableItemPrompt;
boolean CheckForBunkerTurnin(string page, item i, int count)
{
	int opt = FindVariableChoice(page, i.to_string());
	if (opt < 0)
	{
		if (page.contains_text(i.to_string()))
			availableItemPrompt += i.to_string() + "\r\n";
		return false;
	}
	if (i == $item[SMOOCH bracers])
	{
		count = 15 - (i.item_amount() * 5);
		if (count > 0)
			i = $item[superheated metal];
	}
	if (i.item_amount() < count)
	{
		if (i.is_tradeable())
		{
			int price = i.mall_price();
			if (price * count < 100000) // 1 one day ticket = 3 volcoinos, so each volcoino is about 100,000 meat
			{
				buy(count - i.item_amount(), i);
			}
		}
		else
		{
			availableItemPrompt += i.to_string() + "\r\n";
			return false;
		}
	}
	if (i == $item[superheated metal])
	{
		i = $item[SMOOCH bracers];
		count = 3;
		while (i.item_amount() < count)
		{
			if (!create(1, i))
				break;
		}
	}
	if (i.item_amount() >= count)
	{
		page = visit_url("place.php?whichplace=airport_hot&action=airport4_questhub");
		run_choice(opt);
		return true;
	}
	return false;
}
void DoBunker()
{
	string page = visit_url("place.php?whichplace=airport_hot&action=airport4_questhub");
	if (page.contains_text("You've already done your day's work"))
		return;
	foreach target, count in bunkerItems
	{
		if (CheckForBunkerTurnin(page, target, count))
			return;
	}

	if (!UserConfirmDefault("Cannot acquire WLF bunker quest items.\r\n\r\nSkip getting that volcoino and start mining?", true))
	{
		abort(availableItemPrompt);
	}
}

void DoVolcoino()
{
	DoVelvet();
	DoBunker();
	if (get_property("hotAirportAlways") != "true" && volcoino.item_amount() >= 3)
	{
		cli_execute("coinmaster buy disco " + dayPass.to_string());
	}
}

string ResetMine()
{
	return visit_url("mining.php?reset=1&mine=6&submit=1&pwd=" + my_hash(), true);
}

int turnsSpentMining = 0;
string Dig(int x, int y)
{
	if( my_hp() <= 0 )
		cli_execute("restore hp");
	if( my_hp() <= 0 )
		abort("Could not heal up!");
	print("Mining X: " + x + " Y: " + y, printColor);
	turnsSpentMining++;
	int idx = x + 8 * y;
	return visit_url("mining.php?mine=6&which=" + idx + "&pwd=" + my_hash());
}

boolean HasFreeTurns(string page)
{
	return !page.contains_text("Mining a chunk of the cavern wall takes one Adventure");
}

void DoMining(int advToSpend)
{
	if (my_inebriety() > inebriety_limit())
	{
		print("You are too drunk to continue.");
		return;
	}
	print("Spending " + advToSpend + " mining.", printColor);

	int crystalsThisRun = 0;
	int velvetThisRun = 0;
	int goldThisRun = 0;
	int rem_adv = my_adventures() - advToSpend;
	matcher spot;
	

	int badMines = 0;
	int totalMines = 0;
	
	
	string searchPattern = "Promising Chunk of Wall \\((\\d+),([56])\\)"; // only rows 5 and 6

	string page = visit_url("mining.php?mine=6&intro=1");
	while (my_adventures() >= rem_adv)
	{
		if (my_adventures() == rem_adv && !HasFreeTurns(page))
		{
			break;
		}
		totalMines++;
		
		if (!page.contains_text("value='Find New Cavern'") && !page.contains_text("Promising Chunk of Wall"))
		{
			// We cannot find a new cavern unless we've dug once, so if there are no sparklies, dig once
			print("No shinies, digging X: 4 Y: 6", printColor);
			page = Dig(4,6);
		}
		
		boolean gotgold = false;
		boolean reset = true;
		
		spot = searchPattern.create_matcher(page);
		if (!spot.find())
			badMines++;
		while (spot.find() && !gotgold)
		{
			if (my_adventures() <= rem_adv && !HasFreeTurns(page))
			{
				reset = false;
				break;
			}
			int x = spot.group(1).to_int();
			int y = spot.group(2).to_int();
			page = Dig(x, y);
			if (page.contains_text("disco gold"))
			{
				gotgold = true;
				goldThisRun++;
			}
			else if (page.contains_text("shimmering crystal"))
				crystalsThisRun++;
			else if (page.contains_text("fine velvet")) // shouldn't find any velvet with this script
				velvetThisRun++;
			spot = searchPattern.create_matcher(page);
			if ((turnsSpentMining % 10) == 0)
				waitq(1); // delay every third turn to reduce server load
		}
		if (reset)
		{
			print("next mine", printColor);
			page = ResetMine();
		}
	}
	
	int totalMeat = goldThisRun * 19700;
	float mpa = totalMeat;
	if (turnsSpentMining > 0)
		mpa = mpa / turnsSpentMining;
		
	print("Total spoils: ", printColor);
	print("Spent " + turnsSpentMining + " adventures in " + totalMines + " mines.", printColor);
	print("Mines without gold: " + badMines, printColor);
	print("Gold: " + goldThisRun + ", worth " + totalMeat + " meat, with " + mpa + " MPA","green");
	print("Crystals: " + crystalsThisRun, printColor);
	print("Velvet: " + velvetThisRun, printColor);
}

item ChooseCheapest(int limit, item i1, item i2)
{
	if (i1 == noItem)
	{
		if (i2 == noItem)
			return noItem;
		else if (i2.mall_price() <= limit)
			return i2;
	}
	else if (i2 == noItem)
	{
		if (i1.mall_price() <= limit)
			return i1;
		else
			return noItem;
	}
	if (i1.item_amount() > 0)
		return i1;
	if (i2.item_amount() > 0)
		return i2;
	int mall1 = i1.mall_price();
	int mall2 = i2.mall_price();
	if (mall1 > limit && mall2 > limit)
		return noItem;
	if (i1.mall_price() < i2.mall_price())
		return i1;
	else
		return i2;
}
item ChooseCheapest(int limit, item i1, item i2, item i3, item i4)
{
	item best1 = ChooseCheapest(limit, i1, i2);
	item best2 = ChooseCheapest(limit, i3, i4);
	return ChooseCheapest(limit, best1, best2);
}
item ChooseCheapest(int limit, item i1, item i2, item i3, item i4, item i5, item i6)
{
	item best1 = ChooseCheapest(limit, i1, i2, i3, i4);
	item best2 = ChooseCheapest(limit, i5, i6);
	return ChooseCheapest(limit, best1, best2);
}

boolean ignoreOde = false;
void OdeUp(int size)
{
	if (odeToBoozeEffect.have_effect() >= size)
		return;
	if (odeToBooze.have_skill())
	{
		use_skill(1, odeToBooze);
		if (odeToBoozeEffect.have_effect() < size)
		{
			abort("Need to acquire OdeToBooze before drinking");
		}
	}
	else if (!ignoreOde)
	{
                print("Requesting Ode to Booze buff from Buffy the buff bot", printColor);
                cli_execute("/msg buffy ode");
                for (int i = 0; i < 5; i++)
                {
                    waitq(2);
                    refresh_status();
                    if (odeToBoozeEffect.have_effect() >= size)
                    {
                        print("Got ode to booze from buffy, sending 2000 meat as thanks", printColor);
                        cli_execute("csend 2000 meat to buffy");
                        break;
                    }
                }
		if (!ignoreOde
			&& odeToBoozeEffect.have_effect() < size)
		{
			if (UserConfirmDefault("Could not get Ode to Booze, do you want to abort before drinking?", false))
				abort("Aborting before drink because no Ode to Booze");
			else
				ignoreOde = true;
		}
	}
}

void PrepareEat(int size)
{
	int remainingFull = fullness_limit() - saveStomach - my_fullness();
	if (get_property("barrelShrineUnlocked") == "true"
		&& my_class().to_string() == "Turtle Tamer"
		&& get_property("_barrelPrayer") != "true"
		&& remainingFull >= 5)
	{
		cli_execute("barrelprayer buff");
	}
        if (get_property("_milkOfMagnesiumUsed") != "true")
        {
            if (milk.item_amount() <= 0)
                BuyItem(milk);
            if (milk.item_amount() > 0)
                use(1, milk);
        }
}

int FillSpleen(int remainingSpleen)
{
	if (remainingSpleen >= 4)
	{
		item bestSpleen = ChooseCheapest(15000, spleen4_1, spleen4_2, spleen4_3, spleen4_4); // expect 5 turns at 3000 mpa
		print("cheapest spleen = " + bestSpleen.to_string(), printColor);
		if (bestSpleen != noItem)
		{
			BuyItem(bestSpleen);
			chew(1, bestSpleen);
			return remainingSpleen - 4;
		}
	}
	if (remainingSpleen >= 3)
	{
		item bestSpleen = ChooseCheapest(9000, spleen3_1, spleen3_2); // expect 3 turns at 3000 mpa
		print("cheapest spleen = " + bestSpleen.to_string(), printColor);
		if (bestSpleen != noItem)
		{
			BuyItem(bestSpleen);
			chew(1, bestSpleen);
			return remainingSpleen - 3;
		}
	}
	if (remainingSpleen >= 1)
	{
		item bestSpleen = ChooseCheapest(3000, spleen1_1, spleen1_2, spleen1_3, noItem); // expect 1.5 turns at 3000 mpa
		print("cheapest spleen = " + bestSpleen.to_string(), printColor);
		if (bestSpleen != noItem)
		{
			BuyItem(bestSpleen);
			chew(1, bestSpleen);
			return remainingSpleen - 1;
		}
	}
	return remainingSpleen;
}

void HandleEatDrinkSpleen()
{
	// Non-optimal algorithm for lazy eating and drinking that won't break
	// the bank.  You can almost certainly do better manually.
	int remainingFull = fullness_limit() - saveStomach - my_fullness();
	int remainingDrunk = inebriety_limit() - saveLiver - my_inebriety();
	int remainingSpleen = spleen_limit() - saveSpleen - my_spleen_use();
	boolean timeBorrowed = get_property("_borrowedTimeUsed") != "false";
	if (remainingFull < 5 && remainingDrunk < 1 && remainingSpleen < 3)
		return;
	if (!timeBorrowed && user_confirm("Do you wish to borrow 20 turns from tommorrow?"))
	{
		BuyItem(borrowedTime);
		use(1, borrowedTime);
	}

	if (!user_confirm("Do you wish to automatically eat hi mein/lasagna/drink perfect/spleen?"))
		return;
	while (remainingSpleen >= 3)
	{
		int newSpleen = FillSpleen(remainingSpleen);
		if (newSpleen == remainingSpleen)
			break;
		remainingSpleen = newSpleen;
	}


        if (ruby.numeric_modifier("Muscle Percent") == 0) // can't use field gar on Monday
        {
		while (remainingFull >= 3)
		{
			item bestFood = ChooseCheapest(7500, lasagna1, lasagna2, lasagna3, noItem);
			print("cheapest food = " + bestFood.to_string(), printColor);
			if (bestFood == noItem)
				break;
			BuyItem(bestFood, (remainingFull + 2) / 3);
			BuyItem(gar, 3);
			PrepareEat(3);
			if (garEffect.have_effect() <= 0)
				use(1, gar);
			eat(1, bestFood);
			remainingFull -= 3;
		}
        }
	if (my_level() >= 12) // must be 12 to eat hi-mein
	{
		while (remainingFull >= 5)
		{
			item bestFood = ChooseCheapest(10000, himein1, himein2, himein3, himein4, himein5, noItem);
			print("cheapest food = " + bestFood.to_string(), printColor);
			if (bestFood == noItem)
				break;
			BuyItem(bestFood, (remainingFull + 4) / 5);
			PrepareEat(5);
			eat(1, bestFood);
			remainingFull -= 5;
		}
	}
	else if (remainingFull >= 5)
	{
		print("Cannot eat lasagna because it's monday, and not high enough level for hi-meins, you need to find an alternative to eat.", printColor);
	}
	if (remainingDrunk >= 10) // if there's not enough liver left to benefit, wait for nightcap
	{
		if (get_property("barrelShrineUnlocked") == "true"
			&& my_class().to_string() == "Accordion Thief"
			&& get_property("_barrelPrayer") != "true") 
		{
			cli_execute("barrelprayer buff");
		}
	}
	if (swizzler.item_amount() > 0) // don't want to accidentally use swizzler while drinking
		put_closet(swizzler.item_amount(), swizzler);
        item bestRoboDrink;
	if (get_property("_mimeArmyShotglassUsed") == "false" && shotglass.item_amount() > 0)
	{
		bestRoboDrink = ChooseCheapest(3000, robodrink1, robodrink2, robodrink3, robodrink4, robodrink5, robodrink6);
		if (bestRoboDrink != noItem)
		{
			print("Drinking for shotglass", printColor);
			OdeUp(1);
			BuyItem(bestRoboDrink, 3);
			drink(1, bestRoboDrink);
		}
	}
	while (remainingDrunk >= 3)
	{
		item bestDrink = ChooseCheapest(5000, perfect1, perfect2, perfect3, perfect4, perfect5, perfect6);
		print("cheapest drink = " + bestDrink.to_string(), printColor);
		if (bestDrink == noItem)
			break;
		OdeUp(3);
		BuyItem(bestDrink, (remainingDrunk + 2) / 3);
		drink(1, bestDrink);
		remainingDrunk -= 3;
	}
	while (remainingDrunk >= 1) // drunk available is not divisible by 3, so we'll have some leftovers to fill
	{
		if (bestRoboDrink == noItem)
			bestRoboDrink = ChooseCheapest(3000, robodrink1, robodrink2, robodrink3, robodrink4, robodrink5, robodrink6);
		print("cheapest drink = " + bestRoboDrink.to_string(), printColor);
		if (bestRoboDrink == noItem)
			break;
		OdeUp(1);
		BuyItem(bestRoboDrink, remainingDrunk);
		drink(1, bestRoboDrink);
		// need a full recalculate because the mime shot glass might cause inebriety to not increment
		remainingDrunk = inebriety_limit() - saveLiver - my_inebriety();
	}
}

int GetAdventureGain(slot sl)
{
	return sl.equipped_item().numeric_modifier("adventures").to_int();
}

void PrepTomorrow()
{
	int remainingDrunk = inebriety_limit() - saveLiver - my_inebriety();
	WearSleepGear();
	int overnightAdventureGain = get_property("extraRolloverAdventures").to_int() + 40; // 40 basic regen for all characters
	if (get_property("_borrowedTimeUsed") == "true")
		overnightAdventureGain -= 20;
	overnightAdventureGain += GetAdventureGain(head);
	overnightAdventureGain += GetAdventureGain(back);
	overnightAdventureGain += GetAdventureGain(shirt);
	overnightAdventureGain += GetAdventureGain(weapon);
	overnightAdventureGain += GetAdventureGain(offhand);
	overnightAdventureGain += GetAdventureGain(pants);
	overnightAdventureGain += GetAdventureGain(acc1);
	overnightAdventureGain += GetAdventureGain(acc2);
	overnightAdventureGain += GetAdventureGain(acc3);
	overnightAdventureGain += GetAdventureGain(famEqp);

        while (my_adventures() + overnightAdventureGain < 200
		&& fullness_limit() - saveStomach - my_fullness() >= 3)
	{
		PrepareEat(3);
		if (burrito1.item_amount() > 0)
		{
			eat(1, burrito1);
		}
		else if (burrito2.item_amount() > 0)
		{
			eat(1, burrito2);
		}
		else if (burrito3.item_amount() > 0)
		{
			eat(1, burrito3);
		}
		else
		{
			item cheapestBurrito = ChooseCheapest(1000, burrito1, burrito2, burrito3, burrito3);
			if (cheapestBurrito.to_string() == "none")
			{
				print("burrito prices are too high, find your own food", "red");
				break;
			}
			BuyItem(cheapestBurrito, 5);
		}
	}
	int remainingSpleen = spleen_limit() - saveSpleen - my_spleen_use();
        while (my_adventures() + overnightAdventureGain < 200
		&& remainingSpleen >= 3)
	{
		int newSpleen = FillSpleen(remainingSpleen);
		if (newSpleen == remainingSpleen)
			break;
		remainingSpleen = newSpleen;
	}
	if (remainingDrunk >= 5 // hmm, what should this limit be?
		&& straightEdge.have_effect() == 0)
	{
		if (Xtattoo.item_amount() == 0)
		{
			if (skeletonX.mall_price() * 2 < Xtattoo.mall_price())
			{
				if (skeletonX.item_amount() < 2)
					buy(2, skeletonX);
				// make our own
				string page = visit_url("shop.php?whichshop=xo");
				visit_url("shop.php?whichshop=xo&action=buyitem&quantity=1&whichrow=957&pwd=" + my_hash());
			}
			else
			{
				BuyItem(Xtattoo);
			}
		}
		if (Xtattoo.item_amount() > 0)
			use(1, XTattoo);
		else
			print("Could not acquire " + XTattoo, "red");
	}
}

void main(int miningTurns)
{
	ReadSettings();
	WriteSettings();
	if (stooper.have_familiar() && my_familiar() != stooper)
	{
		stooper.use_familiar();
	}
	if (my_inebriety() > inebriety_limit())
		abort("You are too drunk to continue.");

	if (miningTurns == 0)
	{
		if (user_confirm("You requested 0 turns, do you want to prep for max adventures tomorrow?"))
		{
			PrepTomorrow();
			return;
		}
	}

	boolean volcoinosChecked = false;
	if (miningTurns == -2)
		miningTurns = 0;
	else
	{
		if (miningTurns < 0)
		{
			HandleEatDrinkSpleen();
			if (HasAccess())
			{
				DoVolcoino();
				volcoinosChecked = true;
			}
		}

		if (miningTurns > my_adventures() || miningTurns < 0)
			miningTurns = my_adventures();

		if (miningTurns <= 0)
			abort("No turns to spend");
	}
	EnsureAccess();
	if (!volcoinosChecked)
		DoVolcoino();
	WearMiningGear();

	DoMining(miningTurns);

// I'm lazy and sometimes just log my secondary characters after the script finishes without changing gear.
// You can always change back to something else after if you want
	if (my_adventures() <= 0)
		WearSleepGear();
}

