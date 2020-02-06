
import <linknoidcomb.ash>
import <linknoidmine.ash>

//familiar stooper = $familiar[Stooper];
familiar orphan = $familiar[Trick-or-Treating Tot];
item sleepCostume = $item[li'l unicorn costume];
item sleepCostumeGeneral = $item[solid shifting time weirdness];
//skill odeToBooze = $skill[The Ode to Booze];
//effect odeToBoozeEffect = $effect[Ode to Booze];
item elemCaip = $item[Elemental caipiroska];
item wineBucket = $item[Bucket of wine];
item pinkyRing = $item[mafia pinky ring];
item oven = $item[warbear induction oven];
item thanks7 = $item[baked stuffing];
item thanks8 = $item[thanksgiving turkey];
item thanks9 = $item[warm gravy];
item cashew = $item[cashew];
item cornucopia = $item[cornucopia];
item pokeGarden = $item[packet of tall grass seeds];
item fertilizer = $item[Pok&eacute;-Gro fertilizer];
item thanksGarden = $item[packet of thanksgarden seeds];
//item Xtattoo = $item[temporary X tattoos];
//effect straightEdge = $effect[Straight-Edgy];
//item skeletonX = $item[X];

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
string PushChoiceAdventureButton(string buttonText, string page)
{
	int ix = FindVariableChoice(page, buttonText, true);
	if (ix < 0)
	{
print("Could not find " + buttonText + " in " + page);
abort();
		return "";
	}
	return run_choice(ix);
}



//string printColor = "orange";

//void OdeUp(int size)
//{
//	if (odeToBoozeEffect.have_effect() >= size)
//		return;
//	if (odeToBooze.have_skill())
//	{
//		use_skill(1, odeToBooze);
//		if (odeToBoozeEffect.have_effect() < size)
//		{
//			abort("Need to acquire OdeToBooze before drinking");
//		}
//	}
//}
int GetOvernightAdventures()
{
	int GetAdventureGain(slot sl)
	{
		return sl.equipped_item().numeric_modifier("adventures").to_int();
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
	return overnightAdventureGain;
}
void SwitchToThanksgarden()
{
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
void UseReplicator()
{
	if ($item[time-spinner].item_amount() > 0
		&& get_property("_timeSpinnerMinutesUsed").to_int() <= 8
		&& get_property("_timeSpinnerReplicatorUsed") == "false")
	{
		string page = visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9104");
		//use(1, $item[time-spinner]);
		page = run_choice(4); // visit the future
		page = run_choice(1); // random choice
		page = PushChoiceAdventureButton("Use the Replicator", page);
		page = PushChoiceAdventureButton("Gin, Kardashian, Shot", page);
		page = PushChoiceAdventureButton("Go to sleep", page);
		page = PushChoiceAdventureButton("I'm sure, I want to sleep away the future", page);
	}
}

void MakeMagicalSausages()
{
	if (my_meat() < 200)
		return;
		
	int maxMakeAmount = $item[magical sausage casing].item_amount();
	if (maxMakeAmount > 23) // most you can eat in a day
		maxMakeAmount = 23;
	if (my_meat() < 100000 && maxMakeAmount > 5) // in case we're really poor at the moment
		maxMakeAmount = 5;
	if (my_meat() < 5000 && maxMakeAmount > 1) // in case we're in run with no meat
		maxMakeAmount = 1;
	int makeAmount = maxMakeAmount - get_property("_sausagesMade").to_int();
	if (makeAmount <= 0)
		return;
	cli_execute("create " + makeAmount + " magical sausage");
}

void SleepOutfit()
{
	outfit("sleep");
	if (orphan.have_familiar())
	{
		orphan.use_familiar();
		if (sleepCostume.item_amount() > 0
			&& !sleepCostume.have_equipped())
		{
			sleepCostume.to_slot().equip(sleepCostume);
		}
	}
	else if (sleepCostumeGeneral.item_amount() > 0
		&& !sleepCostumeGeneral.have_equipped())
	{
		sleepCostumeGeneral.to_slot().equip(sleepCostumeGeneral);
	}
}

void TryOvenCrafting()
{
	if ($effect[Driving Observantly].have_effect() > 1000
		&& oven.item_amount() > 0
		&& !(get_campground() contains oven)
		&& get_property("_workshedItemUsed") == "false")
	{
		boolean crafted = false;
		item cookItem;
		if (user_confirm("Switch to warbear oven and craft?"))
		{
			use(1, oven);
			if (thanks8.item_amount() <= thanks7.item_amount()
				&& thanks8.item_amount() <= thanks9.item_amount())
			{
				cookItem = thanks8;
			}
			else if (thanks7.item_amount() <= thanks9.item_amount())
			{
				cookItem = thanks7;
			}
			else
				cookItem = thanks9;

			item cashewIngredient;
			item foodIngredient;
			foreach ingr in cookItem.get_ingredients()
			{
				if (ingr.fullness > 0)
					foodIngredient = ingr;
				else
					cashewIngredient = ingr;
			}
			while (cashew.item_amount() < 3)
			{
				if (cornucopia.item_amount() <= 0)
					break;
				use(1, cornucopia);
			}
			if (cashew.item_amount() >= 3)
				cashewIngredient.seller.buy(1, cashewIngredient);
			if (foodIngredient.item_amount() > 0 && cashewIngredient.item_amount() > 0)
			{
				crafted = craft("cook", 1, cashewIngredient, foodIngredient) > 0;
			}
		}
		if (crafted)
			print("Crafted " + cookItem, printColor);
		else
			print("No warbear oven crafting", printColor);
	}
}

void CheckDaycare()
{
	if (get_property("daycareOpen") == "true")
	{
		if (get_property("_daycareGymScavenges").to_int() == 0)
		{
			// todo scavenge
		}
		if (get_property("_daycareRecruits").to_int() == 0)
		{
		}
	}
}

void DoVolcanoMining()
{
	if (get_property("_hotAirportToday") == "true" || get_property("hotAirportAlways") == "true")
	{
		DoVolcoino();
		WearMiningGear();
		DoMining(0);
	}
}

// todo:
// check free kills first
// lynyrd snares

void main()
{
	DoVolcanoMining();
	string emptyOrgan;
	if (my_spleen_use() < spleen_limit())
		emptyOrgan = "spleen";
	if (my_fullness() < fullness_limit())
		emptyOrgan += "/stomach";
	if (emptyOrgan != "" && !user_confirm("Your " + emptyOrgan + " is not full, do you wish to stop to fill it?"))
		return;
	CheckDaycare();
	if (!user_confirm("Ready for overdrinking?"))
		return;
	SleepOutfit();
	int advGain = GetOvernightAdventures();
	if (stooper.have_familiar() && my_familiar() != stooper)
	{
		stooper.use_familiar();
	}
	int remainingDrunk = inebriety_limit() - my_inebriety();
	if (advGain + my_adventures() + remainingDrunk * 4.5 > 200)
	{
		if (straightEdge.have_effect() == 0)
		{
			if (Xtattoo.item_amount() == 0)
			{
				if (skeletonX.item_amount() < 2)
					buy(2, skeletonX);
				// make our own
				string page = visit_url("shop.php?whichshop=xo");
				visit_url("shop.php?whichshop=xo&action=buyitem&quantity=1&whichrow=957&pwd=" + my_hash());
			}
			if (Xtattoo.item_amount() > 0)
			{
				use(1, Xtattoo);
			}
		}
	}
	else
	{
		if (get_property("barrelShrineUnlocked") == "true"
			&& my_class().to_string() == "Accordion Thief"
			&& get_property("_barrelPrayer") != "true") 
		{
			cli_execute("barrelprayer buff");
		}
		while (inebriety_limit() > my_inebriety())
		{
			OdeUp(1);
			drink(1, elemCaip);
		}
		if (pinkyRing.item_amount() > 0 && !pinkyRing.have_equipped())
		{
			pinkyRing.to_slot().equip(pinkyRing);
		}
		OdeUp(10);
		drink(1, wineBucket);
	}
	SleepOutfit();
	UseReplicator();

	if ($skill[That's Not a Knife].have_skill())
	{
		if ($item[soap knife].item_amount() > 0)
			put_closet($item[soap knife].item_amount(), $item[soap knife]);
		use_skill(1, $skill[That's Not a Knife]);
	}
	while (get_property("_chocolatesUsed").to_int() < 2 && advGain + my_adventures() < 197)
	{
		item choc;
		switch (my_class())
		{
			case $class[Seal Clubber]   : choc = $item[chocolate seal-clubbing club]; break;
			case $class[Turtle Tamer]   : choc = $item[chocolate turtle totem];       break;
			case $class[Sauceror]       : choc = $item[chocolate saucepan];           break;
			case $class[Pastamancer]    : choc = $item[chocolate pasta spoon];        break;
			case $class[Disco Bandit]   : choc = $item[chocolate disco ball];         break;
			case $class[Accordion Thief]: choc = $item[chocolate stolen accordion];   break;
		}
		if (choc.item_amount() <= 0)
			break;
		use(1, choc);
	}

	SwitchToThanksgarden();
	TryOvenCrafting();

	if (get_property("_sourceTerminalExtrudes").to_int() < 3)
	{
		cli_execute("terminal extrude food.ext");
		cli_execute("terminal extrude booze.ext");
		cli_execute("terminal extrude booze.ext");
	}
	if (get_property("_pottedTeaTreeUsed") == "false" && get_campground() contains $item[Potted Tea Tree])
	{
		cli_execute("teatree royal");
	}
	if ($item[raffle ticket].item_amount() == 0)
	{
		cli_execute("raffle 1");
	}
	CombBeach(0);
	MakeMagicalSausages();
	if (get_property("hasDetectiveSchool") == "true"
		&& get_property("_detectiveCasesCompleted").to_int() < 3)
	{
		cli_execute("Detective Solver.ash");
	}
}

