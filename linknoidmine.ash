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
effect ToEffect(string s)
{
	effect result = s.to_effect();
	if (result.to_int() < 0)
		abort("Illegal effect " + s);
	return result;
}


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

item noItem = "none".to_item();

// mining gear
item mask = ToItem("high-temperature mining mask");
item cloak = ToItem("Misty Cloak");
item drill = ToItem("high-temperature mining drill");
item lavaPants = ToItem("lava-proof pants");
item gloves = ToItem("heat-resistant gloves");
item necktie = ToItem("heat-resistant necktie");

item xibPuterCode = ToItem("Xiblaxian holo-wrist-puter simcode");
item xibPuter = ToItem("Xiblaxian holo-wrist-puter");

item brokenDrill = ToItem("broken high-temperature mining drill");
item fixDrill = ToItem("heat-resistant sheet metal");


// volcoinos and day passes
item dayPass = ToItem("one-day ticket to That 70s Volcano");
item volcoino = ToItem("Volcoino");

item velvetHead = ToItem("smooth velvet hat");
item velvetShirt = ToItem("smooth velvet shirt");
item velvetPants = ToItem("smooth velvet pants");
item velvetAcc1 = ToItem("smooth velvet hanky");
item velvetAcc2 = ToItem("smooth velvet socks");
item velvetAcc3 = ToItem("smooth velvet pocket square");
item velvet = ToItem("unsmoothed velvet");

// eating and drinking and spleening
item borrowedTime = ToItem("borrowed time");
item swizzler = ToItem("Swizzler");

item spleen4_1 = ToItem("powdered gold");
item spleen4_2 = ToItem("agua de vida");
item spleen4_3 = ToItem("groose grease");
item spleen4_4 = ToItem("Unconscious Collective Dream Jar");
item spleen3_1 = ToItem("carrot juice");
item spleen3_2 = ToItem("prismatic wad");
item spleen1_1 = ToItem("nasty snuff");
item spleen1_2 = ToItem("homeopathic mint tea");
item spleen1_3 = ToItem("transdermal smoke patch");

item perfect1 = ToItem("perfect cosmopolitan");
item perfect2 = ToItem("perfect dark and stormy");
item perfect3 = ToItem("perfect mimosa");
item perfect4 = ToItem("perfect negroni");
item perfect5 = ToItem("perfect old-fashioned");
item perfect6 = ToItem("perfect paloma");

item robodrink1 = ToItem("gunner's daughter");
item robodrink2 = ToItem("Gnollish sangria");
item robodrink3 = ToItem("Elemental caipiroska");
item robodrink4 = ToItem("Bloody Nora");
item robodrink5 = ToItem("Mysterious Island iced tea");
item robodrink6 = ToItem("reverse Tantalus");

item himein1 = ToItem("cold hi mein");
item himein2 = ToItem("hot hi mein");
item himein3 = ToItem("sleazy hi mein");
item himein4 = ToItem("spooky hi mein");
item himein5 = ToItem("stinky hi mein");

item lasagna1 = ToItem("fishy fish lasagna");
item lasagna2 = ToItem("gnat lasagna");
item lasagna3 = ToItem("long pork lasagna");

item burrito1 = ToItem("insanely spicy bean burrito");
item burrito2 = ToItem("insanely spicy jumping bean burrito");
item burrito3 = ToItem("insanely spicy enchanted bean burrito");

item milk = ToItem("milk of magnesium");
effect gotmilk = ToEffect("Got Milk");
item ruby = ToItem("Tuesday's Ruby");
item gar = ToItem("Potion of Field Gar");
effect garEffect = ToEffect("Garish");
skill odeToBooze = ToSkill("The Ode to Booze");
effect odeToBoozeEffect = ToEffect("Ode to Booze");

item Xtattoo = ToItem("temporary X tattoos");
effect straightEdge = ToEffect("Straight-Edgy");
item skeletonX = ToItem("X");

// sleep gear
item weirdness = ToItem("solid shifting time weirdness");
familiar stooper = "Stooper".to_familiar();



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
void BuyItem(item i)
{
	if (!HaveItem(i))
		buy(1, i);
	if (!HaveItem(i))
		abort("Could not acquire " + i.to_string());
}
void BuyAndWear(item i, slot s)
{
	BuyItem(i);
	s.equip(i);
}

// to prevent "can't equip duplicate item" errors
void ClearAccessorySlots()
{
	acc1.equip("none".to_item());
	acc2.equip("none".to_item());
	acc3.equip("none".to_item());
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
		print("Don't forget to nightcap");
	}
}

void WearMiningGear()
{
	while (!HaveItem(drill))
	{
		print("No high-temperature mining drill found, attempting to get one..");
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
	BuyAndWear(cloak, back); // mana regen
	BuyAndWear(drill, weapon); // heat resist
	BuyAndWear(lavaPants, pants); // heat resist
	ClearAccessorySlots();
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
item bunker1 = ToItem("New Age healing crystal");
item bunker2 = ToItem("superduperheated metal");
item bunker3 = ToItem("gooey lava globs");
item bunker4 = ToItem("Mr. Cheeng's 'stache");
item bunker5 = ToItem("Lavalos core");
item bunker6 = ToItem("Saturday Night thermometer");
item bunker7 = ToItem("glass ceiling fragments");
item bunker8 = ToItem("SMOOCH bracers");
item bunker9 = ToItem("SMOOCH bottlecap");
item bunker10 = ToItem("Mr. Choch's bone");
item bunker11 = ToItem("smooth velvet bra");
item bunker12 = ToItem("The One Mood Ring");
item bunker13 = ToItem("fused fuse");
item bunker14 = ToItem("half-melted hula girl");
item bunker15 = ToItem("Pener's crisps");
item bunker16 = ToItem("signed deuce");
item bunker17 = ToItem("the tongue of Smimmons");
item bunker18 = ToItem("Raul's guitar pick");
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
	if (	   !CheckForBunkerTurnin(page, bunker1, 5)
		&& !CheckForBunkerTurnin(page, bunker2, 1)
		&& !CheckForBunkerTurnin(page, bunker3, 5)
		&& !CheckForBunkerTurnin(page, bunker4, 1)
		&& !CheckForBunkerTurnin(page, bunker5, 1)
		&& !CheckForBunkerTurnin(page, bunker6, 1)
		&& !CheckForBunkerTurnin(page, bunker7, 1)
		&& !CheckForBunkerTurnin(page, bunker8, 3)
		&& !CheckForBunkerTurnin(page, bunker9, 1)
		&& !CheckForBunkerTurnin(page, bunker10, 1)
		&& !CheckForBunkerTurnin(page, bunker11, 3)
		&& !CheckForBunkerTurnin(page, bunker12, 1)
		&& !CheckForBunkerTurnin(page, bunker13, 1)
		&& !CheckForBunkerTurnin(page, bunker14, 1)
		&& !CheckForBunkerTurnin(page, bunker15, 1)
		&& !CheckForBunkerTurnin(page, bunker16, 1)
		&& !CheckForBunkerTurnin(page, bunker17, 1)
		&& !CheckForBunkerTurnin(page, bunker18, 1))
	{
		if (!UserConfirmDefault("Cannot acquire WLF bunker quest items.\r\n\r\nSkip getting that volcoino and start mining?", true))
		{
			abort(availableItemPrompt);
		}
	}
}

void DoVolcoino()
{
	DoVelvet();
	DoBunker();
	if (volcoino.item_amount() >= 3)
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
	print("Mining X: " + x + " Y: " + y);
	turnsSpentMining++;
	int idx = x + 8 * y;
	return visit_url("mining.php?mine=6&which=" + idx + "&pwd=" + my_hash());
}

void DoMining(int advToSpend)
{
	print("Spending " + advToSpend + " mining.");

	int crystalsThisRun = 0;
	int velvetThisRun = 0;
	int goldThisRun = 0;
	int rem_adv = my_adventures() - advToSpend;
	matcher spot;
	

	int badMines = 0;
	int totalMines = 0;
	
	
	string searchPattern = "Promising Chunk of Wall \\((\\d+),([56])\\)"; // only rows 5 and 6

	string page = visit_url("mining.php?mine=6&intro=1");
	while (my_adventures() > rem_adv)
	{
		totalMines++;
		
		if (!page.contains_text("value='Find New Cavern'") && !page.contains_text("Promising Chunk of Wall"))
		{
			// We cannot find a new cavern unless we've dug once, so if there are no sparklies, dig once
			print("No shinies, digging X: 4 Y: 6");
			page = Dig(4,6);
		}
		
		boolean gotgold = false;
		boolean reset = true;
		
		spot = searchPattern.create_matcher(page);
		if (!spot.find())
			badMines++;
		while (spot.find() && !gotgold)
		{
			if(my_adventures()<=rem_adv)
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
			print("next mine");
			page = ResetMine();
		}
	}
	
	int totalMeat = goldThisRun * 19700;
	float mpa = totalMeat;
	if (turnsSpentMining > 0)
		mpa = mpa / turnsSpentMining;
		
	print("Total spoils: ");
	print("Spent " + turnsSpentMining + " adventures in " + totalMines + " mines.");
	print("Mines without gold: " + badMines);
	print("Gold: " + goldThisRun + ", worth " + totalMeat + " meat, with " + mpa + " MPA","green");
	print("Crystals: " + crystalsThisRun);
	print("Velvet: " + velvetThisRun);
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
                print("Requesting Ode to Booze buff from Buffy the buff bot");
                cli_execute("/msg buffy ode");
                for (int i = 0; i < 5; i++)
                {
                    waitq(2);
                    refresh_status();
                    if (odeToBoozeEffect.have_effect() >= size)
                    {
                        print("Got ode to booze from buffy, sending 2000 meat as thanks");
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
	while (gotMilk.have_effect() < size)
	{
		BuyItem(milk);
		if (milk.item_amount() == 0)
			return;
		use(1, milk);
	}
}

int FillSpleen(int remainingSpleen)
{
	if (remainingSpleen >= 4)
	{
		item bestSpleen = ChooseCheapest(15000, spleen4_1, spleen4_2, spleen4_3, spleen4_4); // expect 5 turns at 3000 mpa
		print("cheapest spleen = " + bestSpleen.to_string());
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
		print("cheapest spleen = " + bestSpleen.to_string());
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
		print("cheapest spleen = " + bestSpleen.to_string());
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

	while (remainingSpleen >= 3)
	{
		int newSpleen = FillSpleen(remainingSpleen);
		if (newSpleen == remainingSpleen)
			break;
		remainingSpleen = newSpleen;
	}

	if (!user_confirm("Do you wish to automatically eat hi mein/lasagna/drink perfect/spleen?"))
		return;

        if (ruby.numeric_modifier("Muscle Percent") == 0) // can't use field gar on Monday
        {
		while (remainingFull >= 3)
		{
			item bestFood = ChooseCheapest(7500, lasagna1, lasagna2, lasagna3, noItem);
			print("cheapest food = " + bestFood.to_string());
			if (bestFood == noItem)
				break;
			BuyItem(bestFood);
			BuyItem(gar);
			PrepareEat(3);
			if (garEffect.have_effect() <= 0)
				use(1, gar);
			eat(1, bestFood);
			remainingFull -= 3;
		}
        }
	if (my_level() >= 13) // must be 13 to eat hi-mein
	{
		while (remainingFull >= 5)
		{
			item bestFood = ChooseCheapest(10000, himein1, himein2, himein3, himein4, himein5, noItem);
			print("cheapest food = " + bestFood.to_string());
			if (bestFood == noItem)
				break;
			BuyItem(bestFood);
			PrepareEat(5);
			eat(1, bestFood);
			remainingFull -= 5;
		}
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
	while (remainingDrunk >= 3)
	{
		item bestDrink = ChooseCheapest(5000, perfect1, perfect2, perfect3, perfect4, perfect5, perfect6);
		print("cheapest drink = " + bestDrink.to_string());
		if (bestDrink == noItem)
			break;
		OdeUp(3);
		BuyItem(bestDrink);
		drink(1, bestDrink);
		remainingDrunk -= 3;
	}
	while (remainingDrunk >= 1) // drunk available is not divisible by 3, so we'll have some leftovers to fill
	{
		item bestDrink = ChooseCheapest(3000, robodrink1, robodrink2, robodrink3, robodrink4, robodrink5, robodrink6);
		print("cheapest drink = " + bestDrink.to_string());
		if (bestDrink == noItem)
			break;
		OdeUp(1);
		BuyItem(bestDrink);
		drink(1, bestDrink);
		remainingDrunk -= 1;
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
	int overnightAdventureGain = get_property("extraRolloverAdventures").to_int() + 40;
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
		else if (burrito2.item_amount() > 0)
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

