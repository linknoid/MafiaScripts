// code adapted from hotmine.ash by Smelltastic: https://svn.code.sf.net/p/smellomafia/svn/hotmine/code/

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

item spleen1 = ToItem("powdered gold");
item spleen2 = ToItem("agua de vida");

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

item milk = ToItem("milk of magnesium");
effect gotmilk = ToEffect("Got Milk");
skill odeToBooze = ToSkill("The Ode to Booze");
effect odeToBoozeEffect = ToEffect("Ode to Booze");

// sleep gear
item weirdness = ToItem("solid shifting time weirdness");


boolean HaveItem(item i)
{
	return i.item_amount() > 0 || i.equipped_amount() > 0;
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

	if (!user_confirm("No access to 70s Volcano, use a day pass?"))
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

	if (!user_confirm("Equip velvet and get volcoinos?"))
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
		if (user_confirm("Cannot turn in any quest item in WLF bunker, do you wish to abort so you can run one of these quests manually?"))
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
			if ((turnsSpentMining % 3) == 0)
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

void HandleEatDrinkSpleen()
{
	// Non-optimal algorithm for lazy eating and drinking that won't break
	// the bank.  You can almost certainly do better manually.
	int remainingFull = fullness_limit() - my_fullness();
	int remainingDrunk = inebriety_limit() - my_inebriety();
	int remainingSpleen = spleen_limit() - my_spleen_use();
	boolean timeBorrowed = get_property("_borrowedTimeUsed") != "false";
	if (remainingFull < 5 && remainingDrunk < 3 && remainingSpleen < 4)
		return;
	if (!timeBorrowed && user_confirm("Do you wish to borrow 20 turns from tommorrow?"))
	{
		BuyItem(borrowedTime);
		use(1, borrowedTime);
	}

	if (!user_confirm("Do you wish to automatically eat hi mein/drink perfect/spleen?"))
		return;

	while (remainingSpleen >= 4)
	{
		item bestSpleen = ChooseCheapest(15000, spleen1, spleen2); // expect 5 turns at 3000 mpa
		print("cheapest spleen = " + bestSpleen.to_string());
		if (bestSpleen == noItem)
			break;
		BuyItem(bestSpleen);
		chew(1, bestSpleen);
		remainingSpleen -= 4;
	}
	while (remainingFull >= 5)
	{
		item bestFood = ChooseCheapest(10000, himein1, himein2, himein3, himein4, himein5, noItem);
		print("cheapest food = " + bestFood.to_string());
		if (bestFood == noItem)
			break;
		BuyItem(milk);
		BuyItem(bestFood);
		if (gotMilk.have_effect() < 5)
			use(1, milk);
		eat(1, bestFood);
		remainingFull -= 5;
	}
	while (remainingDrunk >= 3)
	{
		item bestDrink = ChooseCheapest(5000, perfect1, perfect2, perfect3, perfect4, perfect5, perfect6);
		print("cheapest drink = " + bestDrink.to_string());
		if (bestDrink == noItem)
			break;
		if (odeToBoozeEffect.have_effect() < 3)
		{
			use_skill(1, odeToBooze);
			if (odeToBoozeEffect.have_effect() < 3)
			{
				print("Need to acquire OdeToBooze before drinking");
			}
		}
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
		if (odeToBoozeEffect.have_effect() < 1)
		{
			use_skill(1, odeToBooze);
			if (odeToBoozeEffect.have_effect() < 1)
			{
				print("Need to acquire OdeToBooze before drinking");
			}
		}
		BuyItem(bestDrink);
		drink(1, bestDrink);
		remainingDrunk -= 3;
	}
}

void main(int miningTurns)
{
	if (my_inebriety() > inebriety_limit())
		abort("You are too drunk to continue.");

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

