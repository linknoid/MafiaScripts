// This is a script for hardcore community service for my own character to farm karma.
// It probably won't work for any other characters unless you have at least the same
// perms and IotM, so you should probably find a more general script.

// Assumes:
// moonsign = The Vole
// class = Accordion Thief
// astral six-pack

// quest state
boolean[31] completedQuests; // last quest is 30
boolean questStatusValid = false;
int dayNumber;

// combat states
boolean canCurse;
boolean canMortar;
boolean canBash;
boolean canSingAlong;
boolean canExtract;
boolean canExtractJelly;
boolean canTimeSpinner;
boolean canMicroMeteorite;
boolean canLoveGnats;
boolean canDuplicate;
boolean canDigitize;
boolean canRomanticArrow;
boolean canTranq;
boolean canSnokebomb;
boolean canSteal;
boolean canDNA;
boolean canDisintegrate;
boolean canPortscan;
boolean usedForce;
int portscanCounter;
int ghostShot;

void ResetCombatState()
{
	canCurse = true;
	canMortar = false;
	canBash = true;
	canSingAlong = true;
	canExtract = true;
	canExtractJelly = my_familiar() == $familiar[Space Jellyfish];
	canTimeSpinner = true;
	canMicroMeteorite = true;
	canLoveGnats = true;
	canDuplicate = true;
	canSteal = false;
	canDNA = false;
	ghostShot = 0;

	if (get_property("_discoKnife") == "false")
	{
		int baseMuscle = my_basestat($stat[Muscle]);
		if (baseMuscle >= 40 && baseMuscle <= 59)
		{
			item candy = $item[candy knife];
			if (candy.item_amount() > 0)
				put_closet(candy.item_amount(), candy);
			$skill[That's Not a Knife].use_skill();
			if (candy.closet_amount() > 0)
				take_closet(candy.closet_amount(), candy);
		}
	}
}

void CheckCounters()
{
	string countersString = get_property("relayCounters");
	string[int] counters = countersString.split_string(":");
	portscanCounter = my_turnCount() + 9999;
	for (int i = 2; i < counters.count(); i += 3)
	{
		int turns = counters[i - 2].to_int();
		string type = counters[i - 1];
		if (type.index_of("Portscan Monster") >= 0)
			portscanCounter = turns;
	}
}

boolean HaveItem(item i)
{
	if (i.item_amount() > 0 || i.have_equipped())
		return true;
	if (i.to_slot() == $slot[familiar])
		foreach fam in $familiars[]
			if (fam.familiar_equipped_equipment() == i)
				return true;
	return false;
}

item HaveSize10FamEqp()
{
	foreach it in $items[ razor fang, amulet coin, luck incense, muscle band, shell bell, smoke ball ]
		if (it.HaveItem())
			return it;
	return $item[none];
}

void FoldGarbage(item i, slot s)
{
	if (!i.HaveItem())
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
		switch (i)
		{
			case $item[deceased crimbo tree]: run_choice(1); break;
			case $item[broken champagne bottle]: run_choice(2); break;
			case $item[tinsel tights]: run_choice(3); break;
			case $item[wad of used tape]: run_choice(4); break;
			case $item[makeshift garbage shirt]: run_choice(5); break;
		}
	}
	if (s != $slot[none])
		s.equip(i);
}

void BuyCoinItemForEffect(coinmaster c, item i, effect e)
{
	if (e.have_effect() <= 0)
	{
		if (i.item_amount() == 0)
			buy(c, 1, i);
		i.use(1);
	}
}
void BuyItemForEffect(item i, effect e)
{
	if (e.have_effect() <= 0)
	{
		if (i.item_amount() == 0)
			buy(1, i);
		i.use(1);
	}
}
void UseItemForEffect(item i, effect e)
{
	if (e.have_effect() <= 0 && i.item_amount() > 0)
	{
		i.use(1);
	}
}

void DoDrink(item i, int count)
{
	if ($item[Swizzler].item_amount() > 0) // don't waste it stats while drinking, save it for sweet synth
		put_closet($item[Swizzler].item_amount(), $item[Swizzler]);
	drink(count, i);
}

void ChateauRest(int needMP)
{
	if (my_level() >= 4 && my_level() < 9) // before level 4, we need the exp more, so use the chateau then, 
		while (my_mp() < needMP && needMP - my_mp() < 50 && $item[psychokinetic energy blob].item_amount() >= 2)
			$item[psychokinetic energy blob].use(1);

	if (my_mp() < needMP)
	{
		print("Resting in chateau to recover", "orange");
		waitq(1);
		visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
	}
}

void RecoverHPorMP(boolean force)
{
	if ($effect[Beaten Up].have_effect() > 0) // should never get beaten up
		abort("Got beaten up, please debug");
	ChateauRest(20);
	boolean needHeal = my_hp() < (my_maxhp() / 2)
		|| (force && my_hp() < (my_maxhp() * .95));
	if (needHeal && my_mp() >= 20)
	{
		$skill[Cannelloni Cocoon].use_skill(1);
		needHeal = false;
	}
	if (needHeal || my_mp() < 20)
	{
		ChateauRest(20);
	}
}

void EnsureMP(int needMP)
{
	if (needMP > my_maxmp())
		abort("Can't achieve " + needMP + " MP");

	while (my_mp() < needMP)
	{
		int curMP = my_mp();
		ChateauRest(needMP);
		if (my_mp() <= curMP)
		{
			if ($item[psychokinetic energy blob].item_amount() > 0)
				$item[psychokinetic energy blob].use(1);
			else
				abort("Could not restore MP");
		}
	}
}

void OpenToys()
{
	foreach i in $items[ Gathered Meat-Clip,
		normal barrel, moist barrel, weathered barrel, rotting barrel, little firkin, dusty barrel,
		unremarkable duffel bag, van key ]
	{
		while (i.item_amount() > 0)
			i.use(1); // some items are not multi-usable
	}
}

boolean NeedGeneTonic(string type, int questNum)
{
	// lava lamprey        = fish               = +10 familiar weight = intrinsic = 2 turn saving, free with banish?
	// crayon elf          = elf                = +100 spell damage   = day 1 = 2 turn saving, free fight
	// elemental           = barf mountain      = +3 resist all       = day 1 = 3 turn saving, before yellow ray
	// Basaltamander       = beast              = +30 weapon damage   = day 1 = 1.2 turn saving, free with banish?
	// snojo               = construct          = +5 familiar weight  = day 1 = 1 turn saving, capture end of day 1
	// machine elf tunnels = weird              = +4 stat gain        = day 1 = 0 turn saving
	// pirate              = garbage barges     = +50% booze drops    = day 2 = 3.33 turn saving
	//                     = humanoid           = +10 all stats       = day 2 = 

	if ($item[DNA extraction syringe].item_amount() <= 0)
		return false;
	if (completedQuests[questNum]) // past needing it
		return false;
	if (get_property("_dnaPotionsMade").to_int() >= 3)
		return false;

	item target = ("Gene Tonic: " + type).to_item();
	if (target == $item[none])
		abort("Illegal tonic type");

	if (target.item_amount() > 0)
		return false;
	if (type == "Weird")
		type = "Weird Thing"; // the other effect follow the same pattern except Weird and Construct
	else if (type == "Construct")
		type = "Machine";

	effect e = ("Human-" + type + " Hybrid").to_effect();
	if (e == $effect[none])
		abort("Illegal effect type");
	if (e.have_effect() > 0)
		return false;
	return true;
}

void MakeGeneTonic(string type, int questNum)
{
	if (!NeedGeneTonic(type, questNum))
		return;
	if (get_property("dnaSyringe") != type.to_lower_case())
		return;

	visit_url("campground.php?action=dnapotion");
}

boolean FuelAsdonMartin(int amount)
{
	if (!(get_campground() contains $item[Asdon Martin keyfob]))
		return false;
	if (get_fuel() >= amount)
		return true;
	print("Attempting to fuel Asdon Martin up to " + amount);
	OpenToys();
	//string page = visit_url("campground.php?action=fuelconverter", true);
	//print (page);
	foreach i in $items[ elven hardtack, elven squeeze, Mad Train wine, Middle of the Road&trade; brand whiskey,
		PB&J with the crusts cut off, shot of orange schnapps, shot of grapefruit schnapps, black forest cake,
		bean burrito, jumping bean burrito, enchanted bean burrito,
		spicy bean burrito, spicy jumping bean burrito, spicy enchanted bean burrito,
		insanely spicy bean burrito, insanely spicy jumping bean burrito, insanely spicy enchanted bean burrito,
		bat wing kabob, bilge wine, strawberry daiquiri,
		tequila sunrise, vodka martini, fine wine, ice-cold Sir Schlitz, margarita, martini, skewered cat appendix,
		mineapple, extra-flat panini, barrel cracker, goat cheese taco, P.B.L.T., giant heirloom grape tomato,
		carob chunks, premium malt liquor, roll in the hay, pink pony, overcookie, 
		slap and tickle, extra-spicy bloody mary, open sauce, vodka and cranberry, snifter of thoroughly aged brandy,
		smelted roe, philosopher's scone, tofu casserole, monkey wrench, moonberry wine cooler, salty dog, screwdriver,
		tomato daiquiri, a little sump'm sump'm, Mon Tiki, dusty bottle of Port, plain old beer, whiskey and soda,
		antique packet of ketchup, dusty bottle of Muscat, shot of tomato schnapps, slip 'n' slide, electric snakebite,
		dusty bottle of Zinfandel, mini-martini, bear claw, fruitcake, calle de miel, pr0n cocktail, bag of GORP,
		Trollhouse cookies, stuffed spooky mushroom, Gold Velvet&trade; whiskey, water purification pills,
		bottle of Amontillado, pigeon egg, rockin' wagon, white lightning, CSA scoutmaster's &quot;water&quot;, asbestos thermos ]
	{
		if (get_fuel() >= amount)
			return true;
		if (i.item_amount() == 0)
			continue;

		//string url = "campground.php?action=fuelconverter&pwd=" + my_hash() + "&qty=" + i.item_amount() + "&iid=" + i.to_int();
		//print("visitingUrl = " + url);
		//visit_url(url);
		cli_execute("asdonmartin fuel " + i.item_amount() + " " + i);
	}
	return false;
}

static effect[9] asdonEffects = // by index
{
	$effect[Driving Obnoxiously],
	$effect[Driving Stealthily],
	$effect[Driving Wastefully],
	$effect[Driving Safely],
	$effect[Driving Recklessly],
	$effect[Driving Quickly],
	$effect[Driving Intimidatingly],
	$effect[Driving Observantly],
	$effect[Driving Waterproofly],
};

void AsdonMartin(effect e)
{
	if (!(get_campground() contains $item[Asdon Martin keyfob]))
	{
		print("No Asdon Martin");
		return;
	}
	if (e.have_effect() > 0)
	{
		print("already have effect" + e);
		return;
	}
	FuelAsdonMartin(37);
	int option = -1;
	boolean currentlyDriving = false;
	for (int i = 0; i < 9; i++)
	{
		if (e == asdonEffects[i])
			option = i;
		else if (asdonEffects[i].have_effect() > 0)
			currentlyDriving = true;
	}
	if (option >= 0)
	{
		if (currentlyDriving)
			cli_execute("asdonmartin drive clear");
		visit_url("campground.php?pwd=" + my_hash() + "&preaction=drive&whichdrive=" + option);
	}
	if (e.have_effect() <= 0)
		abort("Failed to acquire asdon martin effect " + e);
}


boolean UseStill(item target)
{
	item source;
	int row;
	switch (target)
	{
		case $item[cocktail onion]: source = $item[olive]; row = 277; break;
		case $item[kiwi]:           source = $item[lemon]; row = 276; break;
		case $item[kumquat]:        source = $item[orange]; row = 278; break;
		case $item[raspberry]:      source = $item[strawberry]; row = 280; break;
		case $item[tangerine]:      source = $item[grapefruit]; row = 275; break;
		case $item[tonic water]:    source = $item[soda water]; row = 279; break;
		default: return false;
	}
	if (source.item_amount() == 0)
	{
		outfit("Filthy Hippy Disguise");
		source.buy(1);
	}
	if (source.item_amount() == 0)
	{
		print("No " + source + " available to make " + target);
		return false;
	}
	print("Using still to convert " + source + " to " + target);
	visit_url("shop.php?whichshop=still&action=buyitem&quantity=1&whichrow=" + row + "&pwd=" + my_hash());
	return true;
}
void UseStillIfNeeded(item target)
{
	if (target.item_amount() > 0)
		return;
	UseStill(target);
}
void CraftPotionIfNeeded(item pot, item ingredient, boolean isHighPotion, boolean purchasable)
{
	if (pot.item_amount() > 0)
		return;
	print ("ingredient amount = " + ingredient.item_amount());
	if (ingredient.item_amount() <= 0 && purchasable)
	{
		$slot[hat].equip($item[filthy knitted dread sack]);
		$slot[pants].equip($item[filthy corduroys]);
		if (isHighPotion)
		{
			UseStill(ingredient);
		}
		else
		{
			ingredient.buy(1);
		}
	}
	if (ingredient.item_amount() <= 0)
	{
		print("missing potion ingredient = " + ingredient);
		return;
	}

	item ingredient2;
	if (isHighPotion)
	{
		ingredient2 = $item[scrumdiddlyumptious solution];
		if (ingredient2.item_amount() == 0 && $item[scrumptious reagent].item_amount() > 0)
		{
			if ($item[delectable catalyst].item_amount() == 0 && my_meat() > 1000)
				$item[delectable catalyst].buy(1);
			$item[delectable catalyst].use(1);
		}
	}
	else
		ingredient2 = $item[scrumptious reagent];
	if (ingredient2.item_amount() > 0)
	{
		print("Trying to craft " + ingredient + " with " + ingredient2 + " to create " + pot);
		craft("cook", 1, ingredient, ingredient2);
	}
}
void CraftPotionForEffect(item pot, item ingredient, boolean isHighPotion, effect e, boolean purchasable)
{
	if (e.have_effect() > 0)
		return;
	if (ingredient.item_amount() == 0 && !purchasable)
		return;
	CraftPotionIfNeeded(pot, ingredient, isHighPotion, purchasable);
	if (pot.item_amount() > 0)
		pot.use(1);
}
void UseSkillForEffect(skill s, effect e)
{
	if (e.have_effect() <= 0)
	{
		s.use_skill(1);
	}
}
void ExecuteForEffect(string cmd, effect e)
{
	if (e.have_effect() <= 0)
	{
		cli_execute(cmd);
	}
}

int NonStooperDrunkLimit()
{
	int limit = inebriety_limit();
	// stooper can make it temporarily 15, but then we switch to another familiar and end up in a stupor
	if (my_familiar() == $familiar[Stooper])
		limit--;
	return limit;
}

boolean AmDrunk()
{
	return my_inebriety() > NonStooperDrunkLimit();
}


void MaxCombatItemDrop()
{
	FoldGarbage($item[broken champagne bottle], $slot[weapon]);
	$slot[acc3].equip($item[your cowboy boots]);
	if (get_property("_sourceTerminalEnhanceUses").to_int() < 3)
		ExecuteForEffect("terminal enhance items.enh", $effect[items.enh]);
	UseSkillForEffect($skill[Fat Leon's Phat Loot Lyric], $effect[Fat Leon's Phat Loot Lyric]);
	if ($item[li'l ninja costume].HaveItem())
	{
		$familiar[trick-or-treating tot].use_familiar();
		$slot[familiar].equip($item[li'l ninja costume]);
	}
	else
	{
		$familiar[XO Skeleton].use_familiar();
		UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);
		UseSkillForEffect($skill[Leash of Linguini], $effect[Leash of Linguini]);
	}
	ResetCombatState();
	canSteal = true;

	// don't use steely eyed squint here, it's only once a day, need to save it for the right time
}

item CraftPerfectDrink()
{
	static boolean[item] perfectDrinks = $items[
		perfect cosmopolitan,
		perfect dark and stormy,
		perfect mimosa,
		perfect negroni,
		perfect old-fashioned,
		perfect paloma];
	static boolean[item] baseBoozes = $items[
		bottle of vodka,
		boxed wine,
		bottle of whiskey,
		bottle of rum,
		bottle of gin,
		bottle of tequila];

	foreach i in perfectDrinks
		if (i.item_amount() > 0)
			return i;
	if ($item[perfect ice cube].item_amount() == 0)
		return $item[none];
	foreach i,count in baseBoozes
	{
		if (i.item_amount() > 0)
		{
			craft("cocktail", 1, $item[perfect ice cube], i);
			break;
		}
	}
	foreach i in perfectDrinks
		if (i.item_amount() > 0)
			return i;
	return $item[none];
}

boolean DrinkForTurns(item i, int liverReq)
{
	if (i.item_amount() == 0)
		return false;
	if (liverReq > inebriety_limit() - my_inebriety())
		return false;
	if ($effect[Ode to Booze].have_effect() < liverReq)
	{
		ChateauRest(50);
		$skill[The Ode to Booze].use_skill(1);
	}
	if ($effect[Ode to Booze].have_effect() < liverReq)
		return false;
	i.DoDrink(1);
	return true;
}

boolean DrinkForEffect(item i, effect e, int liverReq)
{
	if (e.have_effect() > 0)
		return false;
	return DrinkForTurns(i, liverReq);
}
boolean ChewForEffect(item i, effect e)
{
	if (e.have_effect() > 0 || i.item_amount() == 0)
		return false;
	chew(1, i);
	return true;
}

void GeneralBuffStats()
{
	if (get_property("_lyleFavored") != "true")
		visit_url("place.php?whichplace=monorail&action=monorail_lyle"); // favored by lyle
	if (get_property("telescopeLookedHigh") != "true")
		cli_execute("telescope high");
	if (get_property("_streamsCrossed") != "true")
	{
		$slot[back].equip($item[protonic accelerator pack]);
		visit_url("showplayer.php?who=2807390");
		visit_url("showplayer.php?action=crossthestreams&pwd=" + my_hash() + "&who=2807390"); // cross the streams
	}
	UseSkillForEffect($skill[Get Big], $effect[Big]);
	UseSkillForEffect($skill[Stevedave's Shanty of Superiority], $effect[Stevedave's Shanty of Superiority]);
	BuyItemForEffect($item[hair spray], $effect[Butt-Rock Hair]);
	BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
	BuyItemForEffect($item[glittery mascara], $effect[Glittering Eyelashes]);
}

string UpdateQuestStatus(string councilPhpText)
{
	string page = councilPhpText;
	if (page.contains_text("The door to the Council of Loathing building is locked"))
	{
		page = visit_url("council.php"); // first time in, it has intro text, need to skip past that
	}
	if (!page.contains_text("community services so far."))
		abort("Unexpected council text");
	for (int i = 1; i <= 11; i++)
	{
		string text = "name=option value=" + i; // not sure if it's followed by " " or " >", so check both
		if (!page.contains_text(text + " ") && !page.contains_text(text + ">"))
		{
			completedQuests[i] = true;
			print("Quest already complete: " + i);
		}		
	}
	questStatusValid = true;
	return page;
}
void UpdateQuestStatus()
{
	if (questStatusValid)
		return;
	UpdateQuestStatus(visit_url("council.php"));
}

void DailySummons()
{
	ChateauRest(20);

	use_skill(1, $skill[Perfect Freeze]);
	use_skill(1, $skill[Pastamastery]);
	use_skill(1, $skill[Summon Crimbo Candy]);
	use_skill(1, $skill[Advanced Saucecrafting]);
	use_skill(1, $skill[Advanced Cocktailcrafting]);
	use_skill(1, $skill[Acquire Rhinestones]);
	use_skill(1, $skill[Summon Alice's Army Cards]);
	use_skill(1, $skill[Summon Carrot]);
	use_skill(1, $skill[Lunch Break]);
	use_skill(1, $skill[Summon Geeky Gifts]);
	use_skill(1, $skill[Summon Tasteful Items]);
	use_skill(1, $skill[Grab a Cold One]);
	if ($item[sack lunch].item_amount() > 0)
		$item[sack lunch].use(1);
	if (get_property("_preventScurvy") == "false")
	{
		ChateauRest(50);
		$skill[Prevent Scurvy and Sobriety].use_skill(1);
	}
	if (get_property("_aprilShower") != "true")
		cli_execute("shower cold");
	if (get_property("_kgbLeftDrawerUsed") != "true" || get_property("_kgbRightDrawerUsed") != "true")
		cli_execute("Briefcase.ash drawers");
	if (get_property("_kgbDispenserUses").to_int() < 3)
		cli_execute("Briefcase.ash splendid");
	if (get_property("_lookingGlass") != "true")
		visit_url("clan_viplounge.php?action=lookingglass&whichfloor=2"); // grab DRINK ME
	if (get_property("_detectiveCasesCompleted").to_int() < 3)
		cli_execute("Detective Solver.ash");
}
void MakeGreenMana()
{
	if (get_property("_deckCardsDrawn").to_int() > 10)
		return;
	string seen = get_property("_deckCardsSeen");
	if (!seen.contains_text("Giant Growth"))
		cli_execute("cheat Giant Growth");
	else if (!seen.contains_text("Forest"))
		cli_execute("cheat Forest");
}

void ChooseEducates(string educate1, string educate2)
{
	string educates = get_property("sourceTerminalEducate1") + get_property("sourceTerminalEducate2");
	if (!educates.contains_text(educate1) || !educates.contains_text(educate2))
	{
		cli_execute("terminal educate " + educate1 + ".edu");
		cli_execute("terminal educate " + educate2 + ".edu");
	}
}
void ChooseEducate(string educate1)
{
	string educates = get_property("sourceTerminalEducate1") + get_property("sourceTerminalEducate2");
	if (!educates.contains_text(educate1))
	{
		cli_execute("terminal educate " + educate1 + ".edu");
	}
}


record candyplan
{
	// fixed fields:
	effect buff;
	int total;
	int quality;
	int day;

	// calculated dynamically:
	item candy1;
	item candy2;
	int price;
};
static candyplan[12] candyQuests;
void SetCandyPlan(int quest, int quality, int total, int day, effect buff)
{
	candyQuests[quest].total = total;
	candyQuests[quest].quality = quality;
	candyQuests[quest].day = day;
	candyQuests[quest].buff = buff;
}
boolean FutureNeedsSynthEffect(int futureQuestNum, int currentQuestNum)
{
	if (futureQuestNum == currentQuestNum)
		return false;
	UpdateQuestStatus();
	if (completedQuests[futureQuestNum])
		return false;
	candyplan plan = candyQuests[futureQuestNum];
	if (plan.day == 0)
		return false;
	if (plan.buff.have_effect() > 0)
		return false;
	if (plan.day != candyQuests[currentQuestNum].day) // only worry about the current day
		return false;
	return true;
}

candyplan CalculateCandyPlan(candyplan plan, int[item] lowCandyCount, int[item] highCandyCount)
{
	int[item] candyCounts1 = plan.quality <= 1 ? lowCandyCount : highCandyCount;
	int[item] candyCounts2 = plan.quality < 1 ? lowCandyCount : highCandyCount;
	plan.price = 999999999;
	plan.candy1 = $item[none];
	plan.candy2 = $item[none];
	foreach it1,count1 in candyCounts1
	{
		if (count1 < 1)
			continue;
		foreach it2,count2 in candyCounts2
		{
			if (count2 < 1)
				continue;
			if (it1 == it2 && count1 < 2)
				continue;

			if (((it1.to_int() + it2.to_int()) % 5) != plan.total)
				continue;

			int price = it1.historical_price() + it2.historical_price();
			if (price < plan.price)
			{
				plan.candy1 = it1;
				plan.candy2 = it2;
				plan.price = price;
			}

			print("SweetSynth option = " + it1 + " / " + it2 + " price = " + price);
		}
	}
	if (plan.candy1 != $item[none])
		candyCounts1[plan.candy1]--;
	if (plan.candy2 != $item[none])
		candyCounts2[plan.candy2]--;
	return plan;
}
item[5] gnoMartCandy =
{
	$item[lime-and-chile-flavored chewing gum],
	$item[jaba&ntilde;ero-flavored chewing gum],
	$item[tamarind-flavored chewing gum],
	$item[pickle-flavored chewing gum],
	$item[marzipan skull]
};
candyplan CreateCandyPlan(int questNum)
{
	// Cheapest isn't always best.  Candy supply is very limited, and we have to make sure we
	// don't use up candy we need later
	static boolean created = false;
	if (!created)
	{
		created = true;
		SetCandyPlan(1, 1, 3, 2, $effect[Synthesis: Hardy]); // HP
		SetCandyPlan(2, 1, 0, 2, $effect[Synthesis: Strong]); // muscle
		SetCandyPlan(3, 1, 1, 2, $effect[Synthesis: Smart]); // myst
		SetCandyPlan(4, 1, 2, 2, $effect[Synthesis: Cool]); // moxie
		SetCandyPlan(9, 2, 1, 2, $effect[Synthesis: Collection]); // item drop
		SetCandyPlan(10, 0, 0, 1, $effect[Synthesis: Hot]); // hot resist
		SetCandyPlan(11, 2, 4, 1, $effect[Synthesis: Style]); // bonus moxie gain
	}

	int[item] lowCandyCount;
	int[item] highCandyCount;
	foreach key, value in candy_for_tier(1) // low candy
	{
		if (value.item_amount() > 0)
			lowCandyCount[value] = value.item_amount() + value.closet_amount();
	}
	// this assumes we can buy candy from Gno-Mart, if we haven't tuned moon yet, this will not be valid
	for (int i = 0; i < 5; i++)
		lowCandyCount[gnoMartCandy[i]] += 5;
	foreach key, value in candy_for_tier(3) // high candy
	{
		if (value == $item[Ultra Mega Sour Ball]) // never use this for sweet synthesis
			continue;
		if (value.item_amount() > 0)
			highCandyCount[value] = value.item_amount() + value.closet_amount();
	}

	for (int i = 11; i > 0; i--)
	{
		if (FutureNeedsSynthEffect(i, questNum))
			candyQuests[i] = CalculateCandyPlan(candyQuests[i], lowCandyCount, highCandyCount);
	}

	candyplan result = CalculateCandyPlan(candyQuests[questNum], lowCandyCount, highCandyCount);
	candyQuests[questNum] = result;
	return result;
}

void TakeAllCloset(item i)
{
	if (i.closet_amount() > 0)
		take_closet(i.closet_amount(), i);
}
void ExecuteCandyPlan(candyplan plan)
{
	TakeAllCloset(plan.candy1);
	TakeAllCloset(plan.candy2);
	for (int i = 0; i < 5; i++)
	{
		if (plan.candy1 == gnoMartCandy[i] && plan.candy1.item_amount() == 0)
			plan.candy1.buy(1);
		if (plan.candy2 == gnoMartCandy[i] && plan.candy2.item_amount() == 0)
			plan.candy2.buy(1);
	}
	sweet_synthesis(plan.candy1, plan.candy2);
}

void SweetSynthesisEffect(int questNum)
{
	candyplan plan = CreateCandyPlan(questNum);
	if (plan.day == 0)
		return;
	if (plan.buff.have_effect() > 0)
		return;
	if (plan.candy1 == $item[none])
	{
		if (user_confirm("No candy could be found to synthesize " + plan.buff + ", do you wish to continue without it?"))
			return;
		abort("Sweet synthesis failed " + plan.buff);
	}
	if (plan.price < 10000) // don't bother asking about cheap ones, only if it's using really expensive candy
	{
		ExecuteCandyPlan(plan);
	}
	else if (user_confirm("Do you wish to sweet synthesize " + plan.buff + " using candies "
		+ plan.candy1 + " (" + plan.candy1.item_amount() + ") / "
		+ plan.candy2 + " (" + plan.candy2.item_amount() + ") for price " + plan.price + "?"))
	{
		ExecuteCandyPlan(plan);
	}
	if (plan.buff.have_effect() <= 0)
		abort("Please cast sweet synthesis " + plan.buff + " and then resume execution");
}


string AbortFilter(string message)
{
	print(message, "red");
	return "abort";
}


string Filter_LOVTunnel(int round, monster mon, string page)
{
	string repeatAction = "";
	if (mon == $monster[LOV Enforcer])
	{
		repeatAction = "attack";
	}
	else if (mon == $monster[LOV Engineer])
	{
		if ($skill[Weapon of the Pastalord].have_skill() && my_mp() > $skill[Weapon of the Pastalord].mp_cost())
		{
			repeatAction = "skill Weapon of the Pastalord";
		}
		else
		{
			if (canMortar && my_mp() < $skill[Stuffed Mortar Shell].mp_cost())
			{
				canMortar = false;
				return "skill " + $skill[Stuffed Mortar Shell];
			}
 
			if ($skill[Saucestorm].have_skill() && my_mp() > $skill[Saucestorm].mp_cost()) // saucestorm
				return "skill " + $skill[Saucestorm].to_string();
		}
	}
	else // equivaocator
	{
		if (can_still_steal())
			return "\"pickpocket\"";

		if (canBash)
		{
			canBash = false;
			return "skill " + $skill[Accordion Bash];
		}
		if (canExtract)
		{
			canExtract = false;
			return "skill " + $skill[Extract];
		}
		if (canSingAlong)
		{
			canSingAlong = false;
			return "skill " + $skill[Sing Along];
		}
		if (canMortar && my_mp() < $skill[Stuffed Mortar Shell].mp_cost() && canMortar)
		{
			canMortar = false;
			return "skill " + $skill[Stuffed Mortar Shell].to_string();
		}
	}
	if (repeatAction == "" && $skill[Saucestorm].have_skill() && my_mp() > $skill[Saucestorm].mp_cost())
		repeatAction = "skill " + $skill[Saucestorm].to_string();
	if (repeatAction != "")
	{
		string result = "";
		for (int i = 0; i < 24; i++)
		{
			result += "; " + repeatAction;
		}
		result = result.substring(2);
		print("Running combat macro: " + result, "orange");
		return result;
	}
	return "";
}

string Filter_Ninja(int round, monster mon, string page)
{
	print("Fighting a " + mon);
	if (can_still_steal())
		return "\"pickpocket\"";
	if (mon == $monster[ancient insane monk])
	{
		return "skill " + $skill[Reflex Hammer]; // doctor bag banish
	}
	else if (mon == $monster[Ferocious bugbear])
	{
		return "item " + $item[Louder Than Bomb]; // smithness banish
	}
	else if (mon == $monster[gelatinous cube])
	{
		return "skill " + $skill[Snokebomb];
	}
	else if (mon == $monster[Knob Goblin poseur])
	{
		return "skill " + $skill[KGB tranquilizer dart];
	}
	else if (mon == $monster[amateur ninja])
	{
		return "skill " + $skill[Chest X-Ray]; // doctor bag free kill
	}
	print("Unexpected combat in haiku dungeon: " + mon, "red");
	return "abort";
}
string Filter_Ghost(int round, monster mon, string page)
{
	if (canExtract)
	{
		canExtract = false;
		return "skill " + $skill[Extract];
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill " + $skill[Sing Along];
	}
	if (canBash)
	{
		canBash = false;
		return "skill " + $skill[Accordion Bash];
	}
	if ($skill[Shoot Ghost].have_skill() && ghostShot < 3)
	{
		ghostShot++;
		return "skill " + $skill[Shoot Ghost];
	}
	if ($skill[Trap Ghost].have_skill() && ghostShot == 3)
	{
		return "skill " + $skill[Trap Ghost];
	}
	return AbortFilter("Unexpected fight, expecting ghost");
}

string Filter_Duplicate(int round, monster mon, string page)
{
	if ($monsters[alielf, cat-alien, dog-alien] contains mon)
	{
		if (canTranq)
		{
			canTranq = false;
			return "skill " + $skill[KGB tranquilizer dart];
		}
		if (canSnokebomb)
		{
			canSnokebomb = false;
			return "skill " + $skill[Snokebomb];
		}
		if (get_property("_macrometeoriteUses").to_int() < 10)
		{
			return "skill " + $skill[Macrometeorite];
		}
	}
	if (canBash)
	{
		canBash = false;
		return "skill " + $skill[Accordion Bash];
	}
	if (canDuplicate)
	{
		canDuplicate = false;
		return "skill " + $skill[Duplicate];
	}
	return "skill " + $skill[Disintegrate];
}

string Filter_CloakeBatForm(int round, monster mon, string page)
{
	if ($effect[Bat-Adjacent Form].have_effect() == 0)
		return "skill " + $skill[Become a Bat];
	if (get_property("_latteDrinkUsed") == "false")
		return "skill " + $skill[Gulp Latte];
	return "skill " + $skill[Throw Latte on Opponent];
}
string Filter_CloakeMistForm(int round, monster mon, string page)
{
	if ($effect[Misty Form].have_effect() == 0)
		return "skill " + $skill[Become a Cloud of Mist];
	if (get_property("_latteDrinkUsed") == "false")
		return "skill " + $skill[Gulp Latte];
	return "skill " + $skill[Throw Latte on Opponent];
}
string Filter_Standard(int round, monster mon, string page)
{
	if (round > 20)
		return AbortFilter("combat failed, please take over");
	if (my_hp() < my_maxhp() / 4)
		return AbortFilter("combat failed, please take over");
	if (canSteal && can_still_steal())
	{
		return "\"pickpocket\"";
	}
	if (canDNA)
	{
		canDNA = false;
		return "item " + $item[DNA extraction syringe];
	}
	if (canPortscan)
	{
		canPortscan = false;
		portscanCounter = my_turnCount();
		return "skill " + $skill[portscan];
	}
	if (canDisintegrate)
	{
		canDisintegrate = false;
		return "skill " + $skill[Disintegrate];
	}
	if (canCurse)
	{
		canCurse = false;
		return "skill " + $skill[Curse of Weaksauce];
	}
	if (canSteal)
	{
		canSteal = false;
		return "skill " + $skill[Hugs and Kisses!];
	}
	if (canDigitize)
	{
		canDigitize = false;
		return "skill " + $skill[Digitize];
	}
	if (canTimeSpinner)
	{
		canTimeSpinner = false;
		return "item " + $item[Time-spinner];
	}
	if (canMicroMeteorite)
	{
		canMicroMeteorite = false;
		return "skill " + $skill[Micrometeorite];
	}
	if (canLoveGnats)
	{
		canLoveGnats = false;
		return "skill " + $skill[Summon Love Gnats];
	}
	if (canBash)
	{
		canBash = false;
		return "skill " + $skill[Accordion Bash];
	}
	if (canRomanticArrow
		&& my_familiar() == $familiar[Obtuse Angel])
	{
		canRomanticArrow = false;
		return "skill " + $skill[Fire a badly romantic arrow];
	}
	//if ($item[cold jelly].item_amount() == 0
	//	&& my_familiar() == $familiar[Space Jellyfish])
	//{
	//	return "skill " + $skill[Extract Jelly];
	//}
	if (canExtract)
	{
		canExtract = false;
		return "skill " + $skill[Extract];
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill " + $skill[Sing Along];
	}
	return "attack";
}

string Filter_Garbage(int round, monster mon, string page)
{
	if (can_still_steal())
		return "\"pickpocket\"";

	if (canExtract)
	{
		canExtract = false;
		return "skill " + $skill[Extract];
	}
	if (mon == $monster[garbage tourist])
	{
		if ($effect[On the Trail].have_effect() == 0 && my_mp() > 50) // in case we fail the first time
		{
			return "skill " + $skill[Transcendent Olfaction];
		}
		if (canDNA)
		{
			canDNA = false;
			return "item " + $item[DNA extraction syringe];
		}
	}
	else
	{
		if (get_property("_macrometeoriteUses").to_int() < 10)
		{
			canExtract = true;
			return "skill " + $skill[Macrometeorite];
		}
	}
	if (canSingAlong)
	{
		canSingAlong = false;
		return "skill " + $skill[Sing Along];
	}
	return Filter_Standard(round, mon, page);
}

string Filter_StenchJelly(int round, monster mon, string page)
{
	if (canExtractJelly)
	{
		canExtractJelly = false;
		return "skill " + $skill[Extract Jelly];
	}
	if (get_property("_macrometeoriteUses").to_int() < 10)
	{
		canExtractJelly = true;
		return "skill " + $skill[Macrometeorite];
	}
	return "skill " + $skill[Saucestorm];
}

boolean NeedsVolcanoFactoryItem()
{
	return !$item[lava-proof pants].HaveItem()
		|| (!$item[heat-resistant gloves].HaveItem() && !$item[heat-resistant necktie].HaveItem());
}
boolean NeedsVolcanoMineItem()
{
	return !$item[high-temperature mining mask].HaveItem();
//		|| !$item[fireproof megaphone].HaveItem(); // no longer useful with may 4 saber
}
string Filter_Volcano(int round, monster mon, string page)
{
	if (can_still_steal())
		return "\"pickpocket\"";
	string monName = mon.to_string().to_lower_case();
	if (monName.contains_text("golem"))
	{
		print("Trying to banish the golem", "orange");
		if (my_mp() > 50 && get_property("_snokebombUsed").to_int() < 3)
			return "skill " + $skill[Snokebomb];
		if (get_property("_kgbTranquilizerDartUses").to_int() < 3)
			return "skill " + $skill[KGB tranquilizer dart];
	}
	if (canSteal)
	{
		if (monName.contains_text("mine "))
		{
			if (NeedsVolcanoMineItem())
			{
				canSteal = false;
			}
		}
		else if (monName.contains_text("factory "))
		{
			if (NeedsVolcanoFactoryItem())
			{
				canSteal = false;
			}
		}
		else if (!monName.contains_text("golem"))
		{
			return AbortFilter("Unknown monster name");
		}
		if (!canSteal)
		{
			return "skill " + $skill[Hugs and Kisses!];
		}
	}
	if (!canSteal && get_property("_macrometeoriteUses").to_int() < 10
		&& get_property("_xoHugsUsed").to_int() < 11
		&& my_familiar() == $familiar[XO Skeleton])
	{
		canSteal = true;
		return "skill " + $skill[Macrometeorite];
	}
	if (canCurse)
	{
		canCurse = false;
		return "skill " + $skill[Curse of Weaksauce];
	}
	return "attack";
	
}

string Filter_Hippy(int round, monster mon, string page)
{
	if (!usedForce && $item[Fourth of May Cosplay Saber].have_equipped())
	{
		usedForce = visit_url("fight.php?action=skill&whichskill=7311").contains_text("You will drop your things and walk away.");
		//return "skill Use the Force, " + my_name() + "!";
	}
	if (usedForce)
	{
		visit_url("choice.php?whichchoice=1387&option=3"); // "You will drop your things and walk away."
		visit_url("fight.php"); // make KoLMafia recognize that we're no longer in a fight
		return "";
	}
	if (get_property("_missileLauncherUsed") == "false"
		&& get_fuel() >= 100) 
	{
		return "skill " + $skill[Asdon Martin: Missile Launcher];
	}
	if (canDisintegrate)
	{
		canDisintegrate = false;
		return "skill " + $skill[Disintegrate];
	}
	return AbortFilter("Could not missile launch at hippies");
}

string Filter_Tentacle(int round, monster mon, string page)
{
	if (canExtractJelly)
	{
		canExtractJelly = false;
		return "skill " + $skill[Extract Jelly];
	}
	return "skill " + $skill[Saucestorm];
}

string Filter_MeteorAndExit(int round, monster mon, string page)
{
	if ($skill[Meteor Shower].have_skill())
		return "skill " + $skill[Meteor Shower];
	return AbortFilter("Meteor shower buff cast, please exit while in combat to preserve this buff until tomorrow (even free runaways clear this buff).");
}

string Filter_Gingerbread(int round, monster mon, string page)
{
	if (my_mp() >= 30 && get_property("_shatteringPunchUsed").to_int() < 3)
	{
		if (canBash)
		{
			canBash = false;
			return "skill " + $skill[Accordion Bash];
		}
		if (canExtract)
		{
			canExtract = false;
			return "skill " + $skill[Extract];
		}
		if (canSingAlong)
		{
			canSingAlong = false;
			return "skill " + $skill[Sing Along];
		}

		return "skill " + $skill[Shattering Punch];
	}
	return Filter_Standard(round, mon, page);
}

string Filter_EscapeCombat(int round, monster mon, string page)
{
	if (canExtract)
	{
		canExtract = false;
		return "skill " + $skill[Extract];
	}
	if (canDNA)
	{
		canDNA = false;
		return "item " + $item[DNA extraction syringe];
	}
	if (mon.to_string().contains_text("Black Crayon"))
		return Filter_Standard(round, mon, page);
	if (my_familiar() == $familiar[Pair of Stomping Boots])
		return "run away";
	if (get_property("_kgbTranquilizerDartUses").to_int() < 3)
		return "skill " + $skill[KGB tranquilizer dart];
	if (get_property("_snokebombUsed").to_int() < 3 && my_mp() >= 50)
		return "skill " + $skill[Snokebomb];
	return AbortFilter("Could not determine best way to escape combat.  We shouldn't run out like this.");
}


string Filter_GiantGrowth(int round, monster mon, string page)
{
	if ($skill[Mighty Shout].have_skill() && $effect[Mighty Shout].have_effect() == 0)
		return "skill " + $skill[Mighty Shout];
	if ($effect[Giant Growth].have_effect() == 0 && $item[green mana].item_amount() > 0)
		return "skill " + $skill[Giant Growth];
	if (mon == $monster[The Icewoman])
		return Filter_Ghost(round, mon, page);
	if (mon.to_string().contains_text("itchess"))
		return Filter_Standard(round, mon, page);
	return "skill " + $skill[KGB tranquilizer dart];
}

void PrepareRunaway()
{
	ChateauRest(50);
	if (get_property("_banderRunaways").to_int() < 4)
	{
		$familiar[Pair of Stomping Boots].use_familiar();
		UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);
		UseSkillForEffect($skill[Leash of Linguini], $effect[Leash of Linguini]);
		ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);
	}
	else
		$familiar[Artistic Goth Kid].use_familiar();
}

void ChooseFamiliar()
{
	if (get_property("_transponderDrops").to_int() == 0 && dayNumber == 1)
	{
		$familiar[Li'l Xenomorph].use_familiar();
	}
	//else if (get_property("_gongDrops").to_int() == 0 && dayNumber == 1)
	//{
	//	$familiar[Llama Lama].use_familiar();
	//}
	else if (get_property("garbageFireProgress").to_int() >= 25)
	{
		$familiar[Garbage Fire].use_familiar();
	}
	else if (get_property("_aguaDrops").to_int() < 3 && dayNumber == 1)
	{
		$familiar[Baby Sandworm].use_familiar();
	}
	//else if ($item[Pick-O-Matic lockpicks].item_amount() == 0)
	//{
	//	$familiar[Gelatinous Cubeling].use_familiar();
	//}
	else if ($item[O].item_amount() < 2
		&& $item[pair of candy glasses].item_amount() < 1
		&& $effect[Sucrose-Colored Glasses].have_effect() == 0)
	{
		$familiar[XO Skeleton].use_familiar();
	}
	//else if (get_property("camelSpit").to_int() < 100 && dayNumber == 1)
	//{
	//	$familiar[Melodramedary].use_familiar();
	//}
	//else if (get_property("optimisticCandleProgress").to_int() >= 25)
	//{
	//	$familiar[Optimistic Candle].use_familiar();
	//}
	else
	{
		$familiar[Ms. Puck Man].use_familiar();
	}
}

void SmashBarrels()
{
	string page = visit_url("barrel.php");
	matcher m = "\\<div\\s+class=\"?ex\"?(.*?)\\<a\\s+class=\"?spot\"? href=\"?choice.php\\?whichchoice=1099&[^>]*slot=(\\d*)\"?\\s*\\>.*?title=\"(.*?)\"".create_matcher(page);
	string[int] barrels;
	while (m.find())
	{
		boolean isMimic = m.group(1).contains_text("class=\"mimic\"");
		if (m.group(2).length() < 2) // extraneous slot=0
			continue;
		int pos = m.group(2).to_int();
		string type = m.group(3);
		print("slot " + pos + " mimic = " + isMimic + " (" + type + ")");
		if (isMimic)
			barrels[pos] = "mimic";
		else
			barrels[pos] = type;
	}
	foreach key,value in barrels
	{
		if (value == "A barrel")
		{
			string keyStr = key.to_string();
			if (key < 10)
				keyStr = "0" + keyStr;
			string url = "choice.php?whichchoice=1099&pwd=" + my_hash() + "&option=1&slot=" + keyStr;
			visit_url(url);
		}
	}
}


void GearForCombat()
{
	$slot[hat].equip($item[FantasyRealm Mage's Hat]);
	$slot[back].equip($item[protonic accelerator pack]);
	if (my_level() >= 4 && (get_property("garbageShirtCharge").to_int() > 0 || get_property("garbageShirtCharge") == ""))
		FoldGarbage($item[makeshift garbage shirt], $slot[shirt]);
	else if ($item[denim jacket].HaveItem())
		$slot[shirt].equip($item[denim jacket]);
	else
		$slot[shirt].equip($item[none]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]); // for bashing
	//$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	$slot[off-hand].equip($item[latte lovers member's mug]);
	$slot[pants].equip($item[pantogram pants]); // make sure we're wearing pants first
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]); // for escaping
	$slot[acc2].equip($item[gold detective badge]);
	if ($item[LOV earrings].HaveItem())
		$slot[acc3].equip($item[LOV earrings]);
	else
		$slot[acc3].equip($item[your cowboy boots]);
	BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
	BuyItemForEffect($item[glittery mascara], $effect[Glittering Eyelashes]);
	BuyItemForEffect($item[hair spray], $effect[Butt-Rock Hair]);
	UseSkillForEffect($skill[Get Big], $effect[Big]);
	UseSkillForEffect($skill[Astral Shell], $effect[Astral Shell]);
	UseSkillForEffect($skill[Inscrutable Gaze], $effect[Inscrutable Gaze]);
	UseSkillForEffect($skill[Aloysius' Antiphon of Aptitude], $effect[Aloysius' Antiphon of Aptitude]);
	UseSkillForEffect($skill[Ruthless Efficiency], $effect[Ruthlessly Efficient]);
}

void BuffTripleSized()
{
	if ($effect[Triple-Sized].have_effect() == 0)
	{
		$slot[acc3].equip($item[Powerful Glove]);
		UseSkillForEffect($skill[CHEAT CODE: Triple Size], $effect[Triple-Sized]);
	}
}
void BuffStatGain()
{
	if (get_property("_sourceTerminalEnhanceUses").to_int() == 0)
		ExecuteForEffect("terminal enhance substats.enh", $effect[substats.enh]);
	UseItemForEffect($item[resolution: be smarter], $effect[Brilliant Resolve]);
	UseItemForEffect($item[resolution: be sexier], $effect[Irresistible Resolve]);
	UseItemForEffect($item[resolution: be stronger], $effect[Strong Resolve]);
	UseItemForEffect($item[pressurized potion of proficiency], $effect[Proficient Pressure]);
	UseSkillForEffect($skill[Carol of the Thrills], $effect[Carol of the Thrills]);
	BuffTripleSized();
	cli_execute("beach head exp");
}
void GetCowrruption()
{
	string page = visit_url("place.php?whichplace=town_right&action=townright_ltt");
	if ($item[cow poker].item_amount() == 0)
	{
		if (page.contains_text("Missing: Fancy Man"))
		{
		}
		else if (page.contains_text("Help! Desperados!"))
		{
		}
		else if (page.contains_text("Big Gambling Tournament Announced"))
		{
		}
		else if (page.contains_text("Sheriff Wanted"))
		{
		}
		else if (page.contains_text("Madness at the Mine"))
		{
		}
	}
}

void UnlockGuildAndForest()
{
	if (AmDrunk())
		return;
	string state = get_property("questG08Moxie");
	if (state == "unstarted")
	{
		visit_url("guild.php?place=challenge");
		state = get_property("questG08Moxie");
	}
	while (state == "started")
	{
		UseSkillForEffect($skill[Musk of the Moose], $effect[Musk of the Moose]);
		GearForCombat();
		PrepareRunaway();
		$slot[pants].equip($item[pantogram pants]); // make sure we're wearing pants first
		ResetCombatState();
		string page = visit_url($location[The Sleazy Back Alley].to_url());
		if (page.contains_text("You're fighting"))
		{
			run_combat("Filter_EscapeCombat");
		}
		else if (page.contains_text("Now's Your Pants!"))
		{
			run_choice(1);
			$slot[pants].equip($item[pantogram pants]);
		}
		else if (page.contains_text("Aww, Craps"))
		{
			run_choice(4); // Walk Away
		}
		else if (page.contains_text("Dumpster Diving"))
		{
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=109&option=1");
			//run_choice(1); // using visit_url because run_choice doesn't make it to the combat script
			run_combat("Filter_EscapeCombat");
		}
		else if (page.contains_text("The Entertainer"))
		{
			run_choice(4); // Introduce them to avant-garde
		}
		else if (page.contains_text("Please, Hammer"))
		{
			run_choice(2); // Sorry, no time
		}
		else if (page.contains_text("Under the Knife"))
		{
			run_choice(2); // Umm, no thanks. Seriously.
		}
		else if (page.contains_text("Bree-Yark!")
			|| page.contains_text("Spirit of the Slug Lord")
			|| page.contains_text("They Tried and Pailed"))
		{
			continue; // non-combat, non-choice adventure, can't do anything except continue
		}
		else
		{
			print(page);
			abort("Unexpected adventure");
		}


		state = get_property("questG08Moxie");
	}
	if (state == "step1")
	{
		visit_url("guild.php?place=challenge");
		state = get_property("questG08Moxie");
	}
	if (get_property("questG01Meatcar") != "finished")
	{
		visit_url("guild.php?place=paco");
		if (my_meat() > 550 && $item[bitchin' meatcar].item_amount() == 0)
		{
			cli_execute("create bitch");
			visit_url("place.php?whichplace=desertbeach&action=db_nukehouse");
			visit_url("guild.php?place=paco"); // turn in desert car quest
		}
	}

	if (get_property("questG02Whitecastle") == "unstarted")
	{
		string page = visit_url("guild.php?place=paco"); // take next quest to unlock forest
		if (page.contains_text("Another Errand I Mean Quest"))
		{
			run_choice(1); // Yeah, okay
		}
		visit_url("woods.php");
		visit_url("forestvillage.php");
		// forest should now be unlocked, talk to untinker
		visit_url("place.php?whichplace=forestvillage&action=fv_untinker_quest");
		visit_url("place.php?whichplace=forestvillage&preaction=screwquest&action=fv_untinker_quest"); // accept quest
		visit_url("place.php?whichplace=knoll_friendly&action=dk_innabox"); // get screwdriver
		visit_url("place.php?whichplace=forestvillage&action=fv_untinker"); // turn in screwdriver
	}
}

void UnlockIsland()
{
	static item scrip = $item[Shore Inc. Ship Trip Scrip];

	if ($item[dingy dinghy].item_amount() > 0)
		return;

	if ($item[dingy planks].item_amount() < 1)
		buy(1, $item[dingy planks]);
	while ($item[dinghy plans].item_amount() < 1 && scrip.item_amount() < 3)
	{
		visit_url("adventure.php?snarfblat=355");
		run_choice(3);
	}
	if (scrip.item_amount() == 3)
	{
		visit_url("adventure.php?snarfblat=355");
		visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=793&option=4");
		visit_url("shop.php?whichshop=shore&action=buyitem&quantity=1&whichrow=176&pwd=" + my_hash());
	}
	$item[dinghy plans].use(1);

	if ($item[dingy dinghy].item_amount() == 0)
		abort("Failed at creating dingy dinghy");
}

void FightGhost()
{
	if (AmDrunk())
		return;
	location loc = get_property("ghostLocation").to_location();
	if (loc == $location[none])
		return;
	GearForCombat();
	RecoverHPorMP(true);
	ChooseFamiliar();
	ResetCombatState();
	visit_url(loc.to_url());
	run_combat("Filter_Ghost");
}

void FightWanderers(boolean withBuffs)
{
	if (AmDrunk())
		return;
	FightGhost();
	boolean hasWanderer = true;
	while (hasWanderer && my_turnCount() < portscanCounter)
	{
		hasWanderer = false;
		string[int] counters = get_property("relayCounters").split_string(":");
		for (int i = 2 ; i < counters.count(); i += 3)
		{
			int turns = counters[i - 2].to_int();
			string type = counters[i - 1];
			if (type.contains_text("Digitize Monster") || type.contains_text("Romantic Monster window end"))
			{
				if (turns < my_turncount())
					hasWanderer = true;
			}
		}
print ("here 2");
		if (!hasWanderer)
		{
			FightGhost();
			return;
		}
		if (withBuffs)
		{
			UseSkillForEffect($skill[Inscrutable Gaze], $effect[Inscrutable Gaze]);
			UseSkillForEffect($skill[Springy Fusilli], $effect[Springy Fusilli]);
			UseSkillForEffect($skill[Blood Bubble], $effect[Blood Bubble]);
			UseSkillForEffect($skill[Astral Shell], $effect[Astral Shell]);
			GeneralBuffStats();
		}
print ("here 1");
		ChooseFamiliar();
		GearForCombat();

		int turnsBefore = my_adventures();

		ResetCombatState();
		string page = visit_url($location[The Haunted Kitchen].to_url());
		if (page.contains_text($monster[The Icewoman].to_string()))
			run_combat("Filter_Ghost");
		else
			run_combat("Filter_Standard");

		if (turnsBefore != my_adventures())
			return;
	}
}

void UnlockHippyStore()
{
	for (int i = 0; i < 5; i++)
	{
		FightWanderers(false);
		if ($item[filthy knitted dread sack].HaveItem() && $item[filthy corduroys].HaveItem())
			break;
		if (get_property("_missileLauncherUsed") == "false" && get_campground() contains $item[Asdon Martin keyfob])
		{
			FuelAsdonMartin(100);
		}
		FoldGarbage($item[wad of used tape], $slot[hat]);
		$slot[acc2].equip($item[gold detective badge]);
		$slot[acc3].equip($item[your cowboy boots]);
		$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
		ChooseFamiliar();
		ResetCombatState();
		canDisintegrate = $effect[Everything Looks Yellow].have_effect() <= 0;
		if (canDisintegrate)
			EnsureMP(160);
		try
		{
			string page = visit_url($location[Hippy Camp].to_url());
			if (page.contains_text("You're fighting"))
			{
				usedForce = false;
				run_combat("Filter_Hippy");
				if (my_turnCount() >= portscanCounter)
					break;
			}
			else if (page.contains_text("Peace Wants Love"))
			{
				if ($item[filthy corduroys].item_amount() == 0)
					run_choice(1);
				else
					run_choice(2);
			}
		}
		finally
		{
			canDisintegrate = false;
		}
	}

	UseStillIfNeeded($item[cocktail onion]);
	UseStillIfNeeded($item[kiwi]);
	UseStillIfNeeded($item[tangerine]);
	CraftPotionIfNeeded($item[philter of phorce], $item[lemon], false, true);
	CraftPotionIfNeeded($item[serum of sarcasm], $item[olive], false, true);
	CraftPotionIfNeeded($item[ointment of the occult], $item[grapefruit], false, true);
}

void RunLOVTunnel(int day)
{
	if (AmDrunk())
		return;
	if (get_property("loveTunnelAvailable") != "true" || get_property("_loveTunnelUsed") == "true")
		return;
	if (day == 1) // we'll want to save the buffs for quests on day 2
		GeneralBuffStats();
	GearForCombat();
	$familiar[Baby Sandworm].use_familiar();
	visit_url("place.php?whichplace=town_wrong");
	if (!visit_url("place.php?whichplace=town_wrong&action=townwrong_tunnel").contains_text("choice.php"))
		return;

	run_choice(1); // Enter the tunnel
	// cannot use run_choice() to start the fight, or you won't get a combat filter? 
	ResetCombatState();
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1223&option=1"); // Fight LOV Enforcer
	run_combat("Filter_LOVTunnel");
	visit_url("choice.php");
	run_choice(3); // LOV Earrings, +50% meat

	ResetCombatState();
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1225&option=1"); // Fight LOV Engineer
	run_combat("Filter_LOVTunnel");
	visit_url("choice.php");
	run_choice(1); // Lovebotomy, 10 stats per fight
	
	ResetCombatState();
	visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1227&option=1"); // Fight LOV Equivocator
	run_combat("Filter_LOVTunnel");
	visit_url("choice.php");
	run_choice(3); // LOV Extraterrestial Chocolate
}


void FightTentacle()
{
	if (get_property("_eldritchTentacleFought") != "false")
		return;

	$familiar[Space Jellyfish].use_familiar();
	GearForCombat();
	RecoverHPorMP(false);
	ResetCombatState();
	string page = visit_url("place.php?whichplace=forestvillage&action=fv_scientist");
	string[int] choices = available_choice_options();

	int choiceId = 0;
	foreach key,value in choices
	{
		print("choice " + value + " = " + key);
		if (value == "Can I fight that tentacle you saved for science?")
		{
			choiceId = key;
		}
	}
	if (choiceId > 0)
	{
		run_choice(choiceId, false);
		run_combat("Filter_Tentacle");
	}
	else
	{
		print(page);
		abort("Tentacle choice not found");
	}
}

void RunNeverendingParty(int freeTurnCount)
{
	if (AmDrunk())
		return;
	location loc = $location[The Neverending Party];

	while (true)
	{
		string prop = get_property("_neverendingPartyFreeTurns");
		int usedTurns = prop.to_int();
		if (usedTurns >= freeTurnCount)
			break;
		if (usedTurns == 0 && prop != "0")
			abort("Missing KoLMafia property _neverendingPartyFreeTurns");

		ChooseFamiliar();
		UseSkillForEffect($skill[The Polka of Plenty], $effect[Polka of Plenty]);
		UseSkillForEffect($skill[Fat Leon's Phat Loot Lyric], $effect[Fat Leon's Phat Loot Lyric]);
		GearForCombat();
		RecoverHPorMP(false);
		ResetCombatState();
		string page = visit_url(loc.to_url());
		if (page.contains_text("choice.php"))
		{
			if (page.contains_text("Sure, I'll help"))
				run_choice(1);
			else if (page.contains_text("It Hasn't Ended, It's Just Paused"))
			{
				run_choice(4);
				run_choice(2);
			}
			else
				abort("Please run The Neverending Party and buff in the basement to continue");
		}
		else
		{
			run_combat("Filter_Standard");
			if (get_property("_neverendingPartyFreeTurns") == prop)
			{
				print("No longer using free fights");
				break; 
			}
		}
	}
}
void GetNeverendingPartyBuff()
{
	if ($effect[The Best Hair You've Ever Had].have_effect() > 0)
		return;
	RunNeverendingParty(7);
	if (get_property("_neverendingPartyFreeTurns").to_int() == 7)
	{
		location loc = $location[The Neverending Party];
		string page = visit_url(loc.to_url());
		if (!page.contains_text("It Hasn't Ended, It's Just Paused"))
		{
			print(page, "red");
			abort("Expected party non-combat, got this page instead");
		}
		run_choice(4); // head down to the basement
		//run_choice(2); // Use the hair gel
		run_choice(3); // grab the chainsaw
	}
}

boolean NeedSnojoForEating()
{
	if (get_property("_transponderDrops").to_int() == 0) // haven't done first quest yet
	{
		return true;
	}
	// only run snojo until we have enough for our first extrude
	if ($item[browser cookie].item_amount() == 0
		&& my_fullness() < 4
		&& $item[source essence].item_amount() < 10)
	{
		return true;
	}
	return false;
}

boolean RunSnojo()
{
	if (AmDrunk())
		return false;
	int freeFights = get_property("_snojoFreeFights").to_int();
	if (freeFights >= 10)
	{
		if ($effect[Hypnotized].have_effect() > 0)
			visit_url("clan_viplounge.php?action=hottub");
		return false;
	}
	if (get_property("snojoSetting") == "NONE")
	{
		visit_url("place.php?whichplace=snojo&action=snojo_controller");
		run_choice(2); // myst, for +booze and resist hat
	}
	//if (freeFights == 0 && dayNumber == 1) // no longer relevant, now that we can summon rum
	//{
	//	$familiar[Space Jellyfish].use_familiar();
	//}
	//else
	{
		ChooseFamiliar();
	}

	RecoverHPorMP(false);
	GearForCombat();
	ResetCombatState();
	visit_url($location[The X-32-F Combat Training Snowman].to_url());
	run_combat("Filter_Standard");
	return true;
}


void GrabPirateDNA()
{
	if (NeedGeneTonic("Pirate", 9))
	{
		GearForCombat();
		RecoverHPorMP(false);
		ResetCombatState();
		canDNA = true;
		$familiar[Pair of Stomping Boots].use_familiar();
		string page = visit_url($location[Pirates of the Garbage Barges].to_url());
		if (page.contains_text("Dead Men Smell No Tales"))
			page = visit_url($location[Pirates of the Garbage Barges].to_url());
		run_combat("Filter_EscapeCombat");
		MakeGeneTonic("Pirate", 9);
	}
}

void FaxNinja()
{
	if (get_property("_photocopyUsed") != "false")
		return;
	GearForCombat();
	RecoverHPorMP(false);
	if ($item[photocopied monster].item_amount() == 0)
	{
		cli_execute("chat"); // apparently chat has to be open to receive a fax
		waitq(5); // 5 seconds for chat to open
		if (faxbot($monster[Ninja Snowman Janitor]))
		{
		}
		if ($item[photocopied monster].item_amount() == 0)
		{
			abort("Fax failed");
			return;
		}
	}

	ResetCombatState();
	visit_url("inv_use.php?whichitem=" + $item[photocopied monster].to_int());
	run_combat("Filter_Standard");
}
void PrepareBanish()
{
	if ($item[Louder Than Bomb].item_amount() == 0 && $item[handful of Smithereens].item_amount() > 1)
	{
		if ($item[meat paste].item_amount() == 0)
			cli_execute("create 10 meat paste");
		buy(1, $item[Ben-Gal&trade; Balm]);
		craft("combine", 1, $item[Ben-Gal&trade; Balm], $item[handful of Smithereens]);
	}
	$slot[off-hand].equip($item[Latte lovers member's mug]);
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].equip($item[Lil' Doctor&trade; bag]);
}
void FreeKillNinja()
{
	if ($item[li'l ninja costume].HaveItem())
		return;
	PrepareBanish();
	RecoverHPorMP(false);
	ChateauRest(50);
	
	for (int i = 0; i < 10; i++) // if we haven't found it in 10, we have a problem
	{
		ChooseFamiliar();
		if ($item[li'l ninja costume].HaveItem())
			return;
		string page = visit_url($location[The Haiku Dungeon].to_url());
		if (page.contains_text("Gravy Fairy Ring"))
		{
			run_choice(3); // Leave the ring alone
		}
		else if (page.contains_text("fight.php"))
		{
			run_combat("Filter_Ninja");
		}
		else
		{
			print(page);
			abort("Unexpected haiku adventure");
		}
	}
}

void PrepForDuplicateYellowRay()
{
	ChooseEducates("extract", "duplicate");
	GearForCombat();
	EnsureMP(160);
	ResetCombatState();
}

boolean NeedDistention()
{
	return get_property("_distentionPillUsed") != "true"
		&& $item[distention pill].item_amount() == 0;
}
boolean NeedDogHair()
{
	return get_property("_syntheticDogHairPillUsed") != "true"
		&& $item[synthetic dog hair pill].item_amount() == 0;
}

void DogHairDistentionPills()
{
	static item map = $item[Map to Safety Shelter Grimace Prime];
	if (NeedDistention() || NeedDogHair())
	{
		UseItemForEffect($item[transporter transponder], $effect[Transpondent]);
		canTranq = get_property("_kgbTranquilizerDartUses").to_int() < 3;
		canSnokebomb = get_property("_snokebombUsed").to_int() < 3;
		while (map.item_amount() == 0)
		{
			PrepForDuplicateYellowRay();
			string page = visit_url($location[Domed City of Grimacia].to_url());
			if (!page.contains_text("You're fighting"))
			{
				print(page);
				abort("Expected combat");
			}
			run_combat("Filter_Duplicate");
		}
	}
	while (map.item_amount() > 0 && $effect[Transpondent].have_effect() > 0)
	{
		if (NeedDistention())
		{
			print("Getting distention pill");
			visit_url("inv_use.php?whichitem=5172"); //use(1, $Item[ Map to Safety Shelter Grimace Prime ]);
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1"); // Down the Hatch
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1");  // Have a Drink
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=2");  // Try That One Door
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1");  // Follow Captian Smirk
		}
		else if (NeedDogHair())
		{
			print("Getting dog hair pill");
			visit_url("inv_use.php?whichitem=5172"); //use(1, $Item[ Map to Safety Shelter Grimace Prime ]);
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1"); // Down the Hatch
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1");  // Have a Drink
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=2");  // Try That One Door
			visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=2");  // Follow the Green Girl
		}
		else
			break;
	}
	if (get_property("_distentionPillUsed") != "true" && $item[distention pill].item_amount() > 0)
		$item[distention pill].use(1);
}

void FaxDairyGoat()
{
	if (get_property("_photocopyUsed") != "false")
		return;
	// fax dairy goat, duplicate and maybe yellow ray
	if ($item[photocopied monster].item_amount() == 0)
	{
		cli_execute("chat"); // apparently chat has to be open to receive a fax
		waitq(5); // 5 seconds for chat to open
		if (faxbot($monster[Dairy Goat]))
		{
		}
		if ($item[photocopied monster].item_amount() == 0)
		{
			abort("Fax failed");
			return;
		}
	}
	MaxCombatItemDrop();
	visit_url("inv_use.php?whichitem=" + $item[photocopied monster].to_int());
	run_combat("Filter_Standard");
}

void GetBarfGarbage()
{
	if (AmDrunk())
		return;
	//if ($effect[Everything Looks Yellow].have_effect() > 0)
	//{
	//	print("Can't yellow ray while everything is still yellow");
	//	return;
	//}
	if (get_property("_dinseyGarbageDisposed") == "true")
		return;
	if ($item[bag of park garbage].item_amount() <= 0)
	{
		EnsureMP(50);
		GearForCombat();
		MaxCombatItemDrop();
		ResetCombatState();
		canDNA = NeedGeneTonic("Elemental", 10);
		visit_url($location[Barf Mountain].to_url()); // first time in, need to skip past intro text
		string page = visit_url($location[Barf Mountain].to_url());
		if (page.contains_text("You're fighting"))
			run_combat("Filter_Garbage");
	}
	MakeGeneTonic("Elemental", 10);
	if ($item[bag of park garbage].item_amount() > 0)
	{
		visit_url("place.php?whichplace=airport_stench&action=airport3_tunnels");
		run_choice(6); // put garbage in bin
	}
}

void FightWitchessRook()
{
	if (get_property("_witchessFights").to_int() != 0)
		return;

	ChooseFamiliar();
	GearForCombat();
	RecoverHPorMP(false);
	ResetCombatState();
	visit_url("campground.php?action=witchess", false);
	run_choice(1); // Examine the shrink ray
	visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1938", false);
	run_combat("Filter_Standard");
	if ($item[Greek fire].item_amount() > 0)
		$item[Greek fire].use(1);
}

void FightWitchessBishop(int fightNum, boolean makeCopies)
{
	// obtuse angel and digitize witchess bishop

	if (get_property("_witchessFights").to_int() != fightNum)
		return;

	if (makeCopies)
	{
		$familiar[Obtuse Angel].use_familiar();
		canRomanticArrow = true;
		ChooseEducates("extract", "digitize");
		canDigitize = true;
	}
	else
		ChooseFamiliar();

	GearForCombat();
	RecoverHPorMP(false);
	ResetCombatState();
	visit_url("campground.php?action=witchess", false);
	run_choice(1); // Examine the shrink ray
	visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1942", false);
	run_combat("Filter_Standard");
	if ($item[Greek fire].item_amount() > 0)
		$item[Greek fire].use(1);

}

void FightMachineTunnels()
{
	if (AmDrunk())
		return;
	while (get_property("_machineTunnelsAdv").to_int() < 5)
	{
		$familiar[Machine Elf].use_familiar();
		GearForCombat();
		RecoverHPorMP(false);
		ResetCombatState();
		string page = visit_url("adventure.php?snarfblat=458");
		if (!page.contains_text("You're fighting"))
			abort("Unexpected page while trying to fight in Deep Machine Tunnels");
		run_combat("Filter_Standard");
	}
}

int GingerbreadTurns()
{
	int turns = get_property("_gingerbreadCityTurns").to_int();
	if (get_property("_gingerbreadClockAdvanced") == "true")
		turns += 5;
	print("Gingerbread turns = " + turns);
	return turns;
}

void RunGingerbread()
{
	if (AmDrunk())
		return;
	if (GingerbreadTurns() >= 10)
		return;

	if (GingerbreadTurns() == 0)
	{
		string page = visit_url($location[Gingerbread Civic Center].to_url(), false);
		run_choice(1); // clock choice, advance 5 rounds
	}
	while (GingerbreadTurns() < 9) // already ran turns
	{
		ChooseFamiliar();
		GearForCombat();
		ChateauRest(40); // need 30 to shattering punch, an extra 10 to be safe
		ResetCombatState();
		string page = visit_url($location[Gingerbread Upscale Retail District].to_url(), false);
		run_combat("Filter_Gingerbread");
	}
	if (GingerbreadTurns() == 9)
	{
		string page = visit_url($location[Gingerbread Train Station].to_url(), false);
		run_choice(1); // dig for candy
	}
}


void CurePoison()
{
	if ($effect[Hardly Poisoned at All].have_effect() > 0
		|| $effect[A Little Bit Poisoned].have_effect() > 0
		|| $effect[Somewhat Poisoned].have_effect() > 0
		|| $effect[Really Quite Poisoned].have_effect() > 0
		|| $effect[Majorly Poisoned].have_effect() > 0)
	{
		$item[anti-anti-antidote].buy(1);
		$item[anti-anti-antidote].use(1);
	}
}

void CastGiantGrowth(boolean WithMightyShout) // can only be cast in combat, with free kill or runaway
{
	if (AmDrunk())
		return;
	if ($item[green mana].item_amount() == 0)
	{
		MakeGreenMana();
		if ($item[green mana].item_amount() == 0)
			return;
	}
	if ($effect[Giant Growth].have_effect() > 0)
		return;
	
	GearForCombat();
	RecoverHPorMP(false);
	ResetCombatState();

	location loc = $location[The Haunted Kitchen];
	if (WithMightyShout)
		loc = $location[The Jungles of Ancient Loathing];
	ChooseFamiliar();

	while (true)
	{
		string page = visit_url(loc.to_url());
		if (page.contains_text("The Story So Far"))
			continue; // intro text, retry
		if (page.contains_text("Entrance to the Forgotten City"))
		{
			run_choice(2); // Leave
			continue;
		}
		else if (page.contains_text("Cavern Entrance"))
		{
			run_choice(2); // Leave
			continue;
		}
		run_combat("Filter_GiantGrowth");
		break;
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

void EatBrowserCookie()
{
	while (my_fullness() + 4 <= fullness_limit())
	{
		if (my_fullness() % 4 == 0 && my_meat() >= 1000 && fullness_limit() < 16
			&& get_campground() contains $item[portable Mayo Clinic])
		{
			$item[Mayodiol].buy(1);
			$item[Mayodiol].use(1);
		}
		if ($effect[Got Milk].have_effect() < 4)
		{
			if ($item[glass of goat's milk].item_amount() > 0)
				cli_execute("create 1 milk of magnesium");

			if ($item[milk of magnesium].item_amount() > 0)
				$item[milk of magnesium].use(1);
		}
		// eat browser cookie, time spin 3, 1 with mayodiol
		if ($item[Browser Cookie].item_amount() > 0)
		{
			eat(1, $item[Browser Cookie]);
		}
		else if (get_property("_timeSpinnerMinutesUsed").to_int() < 9)
		{
			TimeSpinnerEat($item[Browser Cookie]);
		}
	}
}

string QuestGoal(int questNum)
{
	switch (questNum)
	{
		case 1: return "bonus HP";
		case 2: return "bonus Muscle";
		case 3: return "bonus Myst";
		case 4: return "bonus Moxie";
		case 5: return "familiar weight";
		case 6: return "weapon damage";
		case 7: return "spell damage";
		case 8: return "-combat";
		case 9: return "item drop";
		case 10: return "hot resist";
		case 11: return "no goal";
	}
	return "";
}

int TurnSavings(int questNum)
{
	switch (questNum)
	{
		case 1: // bonus HP
			return 0;
		case 2: // bonus Muscle
			return  ($stat[muscle].my_buffedstat() - $stat[muscle].my_basestat() ) / 30;
		case 3: // bonus Myst
			return  ($stat[mysticality].my_buffedstat() - $stat[mysticality].my_basestat() ) / 30;
		case 4: // bonus Moxie
			return  ($stat[moxie].my_buffedstat() - $stat[moxie].my_basestat() ) / 30;
		case 5: // familiar weight
			return  ( my_familiar().familiar_weight() + weight_adjustment() ) / 5; // modifier_eval("W")
		case 6: // weapon damage
			int multiplier = 1;
			if ($effect[Bow-Legged Swagger].have_effect() > 0)
				multiplier = 2;
			return numeric_modifier("Weapon Damage").to_int() * multiplier / 50
				+ numeric_modifier("Weapon Damage Percent").to_int() * multiplier / 50;
		case 7: // spell damage
			return numeric_modifier("Spell Damage").to_int() / 50
				+ numeric_modifier("Spell Damage Percent").to_int() / 50;
		case 8: // -combat
			int rate = numeric_modifier("Combat Rate").to_int();
			if (rate < -25)
				return (5 + (-rate - 25));
			else
				return -rate * 3 / 5;
		case 9: // item drop
			return numeric_modifier("Item Drop").to_int() / 30 + numeric_modifier("Booze Drop").to_int() / 15;
		case 10: // hot resist
			return numeric_modifier("Hot Resistance").to_int();
	}
	return 0;
}
int TurnsExpected(int questNum)
{
	int savings = TurnSavings(questNum);
	if (savings >= 60)
		return 1;
	if (savings < 0)
		return 60;
	return 60 - savings;
}

void DoQuest(int questNum, int maxTurns)
{
	print("Requesting to do quest " + questNum);
	if (completedQuests[questNum])
		return;
	string page = UpdateQuestStatus(visit_url("council.php"));
	if (completedQuests[questNum])
	{
		print("Already completed quest " + questNum);
	}
	else
	{
		int turns = 0;
		if (questNum < 30)
		{
			string matchString = "name=option\\s*value=" + questNum + "\\s*\\>.+?<input\\s*type=submit\\s*class=button\\s*value=\"Perform Service \\((\\d*) Adventures";
			//string matchString = "name=option\\s*value=" + questNum + "\\s*\\>.*<input";
			matcher m = matchString.create_matcher(page);
			if (!m.find())
				abort("Could not find service button for quest " + questNum);
			turns = m.group(1).to_int();
			if (turns < 1 || turns > 60)
				abort("Illegal number of turns for quest " + questNum + " = " + turns);
		}
		print("Quest " + questNum + " for " + QuestGoal(questNum) + " will take " + turns + " turns");
		print("Calculated turns = " + TurnsExpected(questNum) + " and total savings = " + TurnSavings(questNum));
		if (turns > maxTurns)
		{
			string message = "Could not complete quest " + questNum + " for " + QuestGoal(questNum) + " in " + maxTurns + " turns.";
			if (!user_confirm(message + "  Do you want to complete it with " + turns + " instead?"))
				abort(message);
		}
		if (turns > 40)
		{
			cli_execute("cast * summon resolutions");
			page = visit_url("council.php");
		}
//abort("Quest " + questNum + " in " + turns + " turns, max = " + maxTurns);
		run_choice(questNum);
		questStatusValid = false;
		UpdateQuestStatus();
		if (!completedQuests[questNum])
			abort("Failed to complete quest " + questNum);
	}
	waitq(2);
}
void DoQuest(int questNum) // passthrough until I can determine how many it should have
{
	DoQuest(questNum, 1);
}

void SetBastilleBattalionMode(int option, string target)
{
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
	if ($item[Draftsman's driving gloves].HaveItem()
		|| $item[Nouveau nosering].HaveItem()
		|| $item[Brutal brogues].HaveItem())
	{
		return;
	}
	visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9928");
	SetBastilleBattalionMode(1, target1);
	SetBastilleBattalionMode(2, target2);
	SetBastilleBattalionMode(3, target3);

	visit_url("choice.php?whichchoice=1313&option=5&pwd=" +my_hash());
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

void SpacegateMoxieStats()
{
	if (get_property("_WorkedOnYourTan") == "true")
		return;
	int turnsLeft = get_property("_spacegateTurnsLeft").to_int();
	if (turnsLeft > 0 && turnsLeft < 15) // initially 0 at the start of the day, jumps to 20 when you unlock, and should get this quest within 5 turns
		return;
	if (!HaveItem($item[geological sample kit]))
	{
		visit_url("place.php?whichplace=spacegate&action=sg_requisition");
		run_choice(6);
	}
	if (!HaveItem($item[exo-servo leg braces]))
	{
		visit_url("place.php?whichplace=spacegate&action=sg_requisition");
		run_choice(2);
	}
	string page = visit_url("place.php?whichplace=spacegate&action=sg_Terminal");
	if (page.contains_text("(a valid set of coordinates is 7 letters)"))
	{
		page = visit_url("choice.php?whichchoice=1235&pwd=" + my_hash() + "&option=2&word=BAAAAAM");
	}
	try
	{
		$slot[off-hand].equip($item[geological sample kit]);
		$slot[pants].equip($item[exo-servo leg braces]);

		for (int i = 0; i < 6; i++) // I think this should always be in the first 6 turns
		{
			page = visit_url("adventure.php?snarfblat=494");
			if (page.contains_text("Paradise Under a Strange Sun"))
			{
				run_choice(2); // Work on your tan
				set_property("_WorkedOnYourTan", "true");
				return;
			}
			else if (page.contains_text("A Whole New World")) // initial intro screen
				continue;
			else if (page.contains_text("Space Cave"))
				run_choice(6); // Just leave
			else if (page.contains_text("Cool Space Rocks"))
				run_choice(2); // Take a core sample
			else if (page.contains_text("Wide Open Spaces"))
				run_choice(2); // Take a core sample
			else
			{
				print(page);
				abort("Todo: fix spacegate run for this page");
			}
		}
	
	}
	finally
	{
		$slot[pants].equip($item[pantogram pants]);
		$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	}
}

void ChallengeGodLobster(int fightNum, int postCombatChoice)
{
	if (get_property("_godLobsterFights").to_int() != (fightNum - 1))
		return;

	$familiar[God Lobster].use_familiar();
	if ($item[God Lobster's Scepter].item_amount() > 0)
		$slot[familiar].equip($item[God Lobster's Scepter]);
	RecoverHPorMP(false);
	ResetCombatState();
	string page = visit_url("main.php?fightgodlobster=1");
	if (page.contains_text("You're fighting"))
	{
		page = run_combat("Filter_Standard");
		if (page.contains_text("I am victorious!"))
		{
			visit_url("choice.php");
			run_choice(postCombatChoice);
		}
		else
			abort("God lobster fight failed " + page);
	}
}

void FightChateauPainting()
{
	if (get_property("_chateauMonsterFought") != "false")
		return;

	$familiar[Robortender].use_familiar();
	RecoverHPorMP(false);
	ResetCombatState();
	canDNA = NeedGeneTonic("Elf", 7);
	string page = visit_url("place.php?whichplace=chateau&action=chateau_painting");
	if (page.contains_text("You're fighting"))
	{
		page = run_combat("Filter_Standard");
	}
	MakeGeneTonic("Elf", 7);
}



void MakeGovernmentCheese()
{
	if ($item[government cheese].item_amount() > 0
		|| $item[government].item_amount() > 0
		|| get_property("_sourceTerminalPortscanUses").to_int() >= 3)
	{
		return;
	}
	if (my_turnCount() < portscanCounter)
	{
		ChooseEducates("portscan", "extract");
		canPortscan = true;
		return;
	}
	if ($item[spooky jelly].item_amount() > 0)
	{
		$item[spooky jelly].chew(1);
	}
	else
	{
		MaxCombatItemDrop();
		if (get_property("_steelyEyedSquintUsed") != "true")
		{
			ChateauRest(100);
			$skill[Steely-Eyed Squint].use_skill(1);
		}
	}
	if (my_turnCount() > portscanCounter)
	{
		canPortscan = false;
		visit_url($location[The Haunted Kitchen].to_url());
		run_combat("Filter_Standard");
	}
}


void StealVolcanoGear()
{
	while (get_property("_macrometeoriteUses").to_int() < 10
		&& get_property("_xoHugsUsed").to_int() < 11)
	{
		string url;
		if (NeedsVolcanoFactoryItem())
		{
			url = $location[LavaCo&trade; Lamp Factory].to_url();
		}
		else if (NeedsVolcanoMineItem())
		{
			url = "adventure.php?snarfblat=449"; // $location[The Velvet/Gold Mine];
		}
		else
			break;

		GearForCombat();
		UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);
		UseSkillForEffect($skill[Leash of Linguini], $effect[Leash of Linguini]);

		$familiar[XO Skeleton].use_familiar();
		canSteal = true;
		string page = visit_url(url);
		if (page.contains_text("You're fighting"))
		{
			run_combat("Filter_Volcano");
		}
	}
}

boolean banished;
boolean turboed;
string Filter_Saber(int round, monster mon, string page)
{
	if (can_still_steal())
		return "\"pickpocket\"";
	string monName = mon.to_string().to_lower_case();
	if (monName.contains_text("golem"))
	{
		print("Trying to banish the golem", "orange");
		if (my_mp() > 50 && get_property("_snokebombUsed").to_int() < 3)
		{
			banished = true;
			return "skill " + $skill[Snokebomb];
		}
		if (get_property("_kgbTranquilizerDartUses").to_int() < 3)
		{
			banished = true;
			return "skill " + $skill[KGB tranquilizer dart];
		}
	}
        boolean validMonster = false;
	if (monName.contains_text("mine "))
	{
		if (NeedsVolcanoMineItem())
		{
			validMonster = true;
		}
	}
	else if (monName.contains_text("factory "))
	{
		if (NeedsVolcanoFactoryItem())
		{
			validMonster = true;
		}
	}
	else if (!monName.contains_text("golem"))
	{
		validMonster = true;
	}
	if (!validMonster && get_property("_macrometeoriteUses").to_int() < 10)
	{
		return "skill " + $skill[Macrometeorite];
	}

	if (!turboed && $effect[Turbocharged].have_effect() == 0)
	{
		turboed = true;
		return "skill Turbo";
	}

	if ($effect[Meteor Showered].have_effect() == 0 && get_property("_meteorShowerUses").to_int() < 5)
		return "skill Meteor Shower";
	if (!usedForce)
	{
		usedForce = visit_url("fight.php?action=skill&whichskill=7311").contains_text("You will drop your things and walk away.");
		//return "skill Use the Force, " + my_name() + "!";
	}
	if (usedForce)
	{
		visit_url("choice.php?whichchoice=1387&option=3"); // "You will drop your things and walk away."
		visit_url("fight.php"); // make KoLMafia recognize that we're no longer in a fight
		return "";
	}
	print("Use the force failed, please debug");
	return "abort";
}

void SaberBuff()
{
	if ($effect[Meteor Showered].have_effect() > 0)
		return;
	print("SaberBuff");
	banished = true; // fake it so we can get into the loop
	while (get_property("_meteorShowerUses").to_int() < 5 && banished)
	{
		banished = false;
		string url;
		if (NeedsVolcanoFactoryItem())
		{
			url = $location[LavaCo&trade; Lamp Factory].to_url();
		}
		else if (NeedsVolcanoMineItem())
		{
			url = "adventure.php?snarfblat=449"; // $location[The Velvet/Gold Mine];
		}
		else
			url = $location[The Haunted Kitchen].to_url();
		
		cli_execute("terminal educate turbo.edu");
		$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
		string page = visit_url(url);
		if (page.contains_text("You're fighting"))
		{
			try
			{
				usedForce = false;
				turboed = false;
				run_combat("Filter_Saber");
			}
			finally
			{
				visit_url("fight.php");
			}
		}
		else
		{
			banished = true;
			print("Found intro non-combat, try again");
		}
	}
}

void MakeStenchJelly()
{
	if (AmDrunk())
		return;
	if (get_property("_spaceJellyfishDrops") > 1
		&& get_property("_macrometeoriteUses").to_int() >= 10
		&& $item[Pok&eacute;-Gro fertilizer].item_amount() >= 3)
	{
		return;
	}
	$familiar[Space Jellyfish].use_familiar();
	RecoverHPorMP(false);
	ResetCombatState();
	visit_url($location[Pirates of the Garbage Barges].to_url());
	string page = visit_url($location[Pirates of the Garbage Barges].to_url()); // first visit has intro page
	if (page.contains_text("You're fighting"))
	{
		run_combat("Filter_StenchJelly");
	}
}

void HarvestGrass()
{
	foreach it, count in get_campground()
	{
		if (it == $item[packet of tall grass seeds] && count > 1)
		{
			visit_url("campground.php?action=garden&pwd=" + my_hash());
			break;
		}
	}
}
void EqualizeStats()
{
	CraftPotionForEffect($item[oil of slipperiness], $item[jumbo olive], false, $effect[Slippery Oiliness], true);

	if ($effect[Slippery Oiliness].have_effect() <= 0)
	{
		// This one wish can save at least 23 turns for muscle quest, and at least 14 turns
		//  from myst quest.  A 37 turn saving is worth 1 wish.
		cli_execute("genie wish to be Slippery Oiliness");
	}
}

void DoSleep()
{
	ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);

	if (get_property("_freePillKeeperUsed") == "false")
		cli_execute("pillkeeper free familiar");
	cli_execute("beach head familiar");
	cli_execute("Briefcase enchantment adventures");
	for (int i = 0; i < 3; i++)
	{
		if (get_property("_kgbClicksUsed").to_int() < 3)
			cli_execute("Briefcase identify");
	}
	if (get_property("_witchessBuff") != "true")
		cli_execute("witchess");
	$familiar[Stooper].use_familiar();
	while (my_inebriety() < inebriety_limit())
	{
		if ($item[Sacramento wine].item_amount() > 0)
			DrinkForTurns($item[Sacramento wine], 1);
		else if ($item[splendid martini].item_amount() > 0)
			DrinkForTurns($item[splendid martini], 1);
		else
			abort("Cannot top off liver before overdrinking");
	}
	if (my_inebriety() == inebriety_limit())
	{
		if ($effect[Ode to Booze].have_effect() < 10)
			$skill[The Ode to Booze].use_skill(1);
	
		$item[bucket of wine].DoDrink(1);
	}
	while (get_property("_sourceTerminalEnhanceUses").to_int() < 3)
		cli_execute("terminal enhance items.enh");
	while (get_property("timesRested").to_int() < total_free_rests())
	{
		cli_execute("cast * summon resolutions");
		ChateauRest(my_maxmp());
	}
	cli_execute("cast * summon resolutions");
	if ($item[Hairpiece On Fire].item_amount() > 0)
		$slot[hat].equip($item[Hairpiece On Fire]);
	if ($item[shoe ad T-shirt].HaveItem())
		$slot[shirt].equip($item[shoe ad T-shirt]);
	if ($item[burning cape].HaveItem())
		$slot[back].equip($item[burning cape]);
	else
		$slot[back].equip($item[vampyric cloake]);
	$slot[acc2].equip($item[tiny plastic golden gundam]);
	$slot[acc3].equip($item[Draftsman's driving gloves]);
	$familiar[Trick-or-Treating Tot].use_familiar();
	if (!$item[li'l unicorn costume].HaveItem())
		buy(1, $item[li'l unicorn costume]);
	$slot[familiar].equip($item[li'l unicorn costume]);
	//if (!user_confirm("Are you ready for final combat of the day? (this will log out off in the middle of combat)"))
	//	return;
	//if (get_property("_clanFortuneConsultUses").to_int() < 3)
	//	if (!user_confirm("Do you want to sleep without consulting the fortune teller?"))
	//		return;
	FoldGarbage($item[deceased crimbo tree], $slot[none]); // put away garbage shirt so it starts fresh tomorrow

	// end day with time spinner fight after drunk and cast meteor shower, and then logout
	//string pageText = visit_url("inv_use.php?whichitem=9104");
	//pageText = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1195&option=3");
	//if (pageText.contains_text("You're fighting"))
	//{
	//	run_combat("Filter_MeteorAndExit");
	//}

}


void DoQuest1()
{
	if (completedQuests[1])
		return;

	BuffTripleSized();
	BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
	UseSkillForEffect($skill[Get Big], $effect[Big]);
	UseSkillForEffect($skill[Quiet Determination], $effect[Quiet Determination]);

	SweetSynthesisEffect(2); // muscle
	ChallengeGodLobster(1, 3);
	ChallengeGodLobster(2, 3);
	ChallengeGodLobster(3, 3);

	$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
	$slot[back].equip($item[protonic accelerator pack]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].equip($item[A Light that Never Goes Out]);
	$slot[pants].equip($item[Cargo Cultist Shorts]);
	$slot[acc3].equip($item[Brutal Brogues]);
	$familiar[Disembodied Hand].use_familiar();
	$slot[familiar].equip($item[Fourth of May Cosplay Saber]);
	CurePoison();
	if (TurnSavings(1) < 59)
		SweetSynthesisEffect(1); // HP
	if (TurnSavings(1) < 59)
		if ($effect[Strongly Motivated].have_effect() == 0)
			cli_execute("cheat Strength");
	DoQuest(1, 1); // Bonus HP
}
void DoQuest2()
{
	if (completedQuests[2])
		return;

	BuffTripleSized();
	cli_execute("beach head muscle");
	GeneralBuffStats();
	BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
	BuyItemForEffect($item[blood of the Wereseal], $effect[Temporary Lycanthropy]);
	UseItemForEffect($item[Flaskfull of Hollow], $effect[Merry Smithsness]);
	UseSkillForEffect($skill[Quiet Determination], $effect[Quiet Determination]);
	UseSkillForEffect($skill[Get Big], $effect[Big]);

	$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	if ($item[shoe ad T-shirt].HaveItem())
		$slot[shirt].equip($item[shoe ad T-shirt]);
	if ($item[cosmetic football].HaveItem())
		$slot[off-hand].equip($item[cosmetic football]);
	$slot[pants].equip($item[pantogram pants]);
	$slot[acc3].equip($item[Brutal Brogues]);
	if ($item[Mer-kin strongjuice].item_amount() > 0 && $effect[Juiced Out].have_effect() <= 0)
		$item[Mer-kin strongjuice].use(1);

	CraftPotionForEffect($item[Ferrigno's Elixir of Power], $item[kiwi], true, $effect[Incredibly Hulking], true);
	CraftPotionForEffect($item[philter of phorce], $item[lemon], false, $effect[Phorcefullness], true);

	CurePoison();
	if (TurnSavings(2) < 59)
		EqualizeStats();
	if (TurnSavings(2) < 59)
		CastGiantGrowth(true);
	CurePoison();
	$familiar[Disembodied Hand].use_familiar();
	$slot[familiar].equip($item[Fourth of May Cosplay Saber]);
	if (TurnSavings(2) < 59)
		if ($effect[Strongly Motivated].have_effect() == 0)
			cli_execute("cheat Strength");
	if (TurnSavings(2) < 59)
		if ($item[abstraction: action].item_amount() > 0 && $effect[Action].have_effect() <= 0)
			chew(1, $item[abstraction: action]);
	DoQuest(2, 1); // Bonus Muscle
}
void DoQuest3()
{
	if (completedQuests[3])
		return;

	BuffTripleSized();
	cli_execute("beach head mysticality");
	GeneralBuffStats();
	UseItemForEffect($item[Flaskfull of Hollow], $effect[Merry Smithsness]);
	UseSkillForEffect($skill[Get Big], $effect[Big]);
	UseSkillForEffect($skill[Quiet Judgement], $effect[Quiet Judgement]);


	CraftPotionForEffect($item[Hawking's Elixir of Brilliance], $item[tangerine], true, $effect[On the Shoulders of Giants], true);
	CraftPotionForEffect($item[ointment of the occult], $item[grapefruit], false, $effect[Mystically Oiled], true);
	CraftPotionForEffect($item[tomato juice of powerful power], $item[tomato], false, $effect[Tomato Power], true);

	if (get_property("_daycareSpa") == "false")
		cli_execute("daycare mysticality");

	CurePoison();
	if (TurnSavings(3) < 59)
		EqualizeStats();
	if (TurnSavings(3) < 59)
		CastGiantGrowth(false);
	CurePoison();
	if (TurnSavings(3) < 59)
		SweetSynthesisEffect(3); // myst

	$slot[hat].equip($item[FantasyRealm Mage's Hat]);
	if ($item[denim jacket].item_amount() > 0)
		$slot[shirt].equip($item[denim jacket]);
	$slot[pants].equip($item[Vicar's Tutu]);
	if ($item[dorky glasses].item_amount() > 0)
		$slot[acc2].equip($item[dorky glasses]);
	$slot[off-hand].equip($item[A Light that Never Goes Out]);
	if ($item[training legwarmers].HaveItem())
		$slot[acc3].equip($item[training legwarmers]);

	$familiar[Disembodied Hand].use_familiar();
	$slot[familiar].equip($item[Fourth of May Cosplay Saber]);

	if (TurnSavings(3) < 59)
		if ($effect[Thought].have_effect() == 0 && $item[abstraction: thought].item_amount() > 0)
			chew(1, $item[abstraction: thought]);

	DoQuest(3, 1); // Bonus Myst
}


void DoQuest4()
{
	if (completedQuests[4])
		return;

	BuffTripleSized();
	cli_execute("beach head moxie");
	UseItemForEffect($item[Flaskfull of Hollow], $effect[Merry Smithsness]);
	GeneralBuffStats();
	UseSkillForEffect($skill[Quiet Desperation], $effect[Quiet Desperation]);


	UseItemForEffect($item[runproof mascara], $effect[Unrunnable Face]);
	UseSkillForEffect($skill[Get Big], $effect[Big]);

	use($item[rhinestone].item_amount(), $item[rhinestone]);

	if (get_property("_spacegateVaccine") != "true")
	{
		visit_url("place.php?whichplace=spacegate&action=sg_vaccinator");
		run_choice(2); // spacegate broad-spectrum vaccine
	}



	CraftPotionForEffect($item[Connery's Elixir of Audacity], $item[cocktail onion], true, $effect[Cock of the Walk], true);
	CraftPotionForEffect($item[serum of sarcasm], $item[olive], false, $effect[Superhuman Sarcasm], true);

	if (TurnSavings(4) < 59)
		SweetSynthesisEffect(4); // moxie
	CurePoison();
	if (TurnSavings(4) < 59)
		CastGiantGrowth(true);
	CurePoison();
	if ($effect[A Contender].have_effect() <= 0)
	{
//		abort("check for A Contender");
//		cli_execute("genie wish to be A Contender");
	}
	if ($item[Hairpiece On Fire].item_amount() > 0)
		$slot[hat].equip($item[Hairpiece on Fire]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].equip($item[A Light that Never Goes Out]);
	$slot[pants].equip($item[Vicar's Tutu]);
	if ($item[noticeable pumps].HaveItem())
		$slot[acc2].equip($item[noticeable pumps]);
	$slot[acc3].equip($item[your cowboy boots]);
	$familiar[Disembodied Hand].use_familiar();
	$slot[familiar].equip($item[Fourth of May Cosplay Saber]);
	if (TurnSavings(4) < 59)
		if ($effect[Sensation].have_effect() == 0 && $item[abstraction: sensation].item_amount() > 0)
			chew(1, $item[abstraction: sensation]);
	DoQuest(4, 1); // Bonus Moxie
}
void DoQuest5()
{
	if (completedQuests[5])
		return;

	cli_execute("beach head familiar");
	HarvestGrass();
	if (get_property("tomeSummons").to_int() < 3)
	{
		if (HaveSize10FamEqp() == $item[none])
		{
			visit_url("campground.php?action=bookshelf&preaction=combinecliparts&clip1=03&clip2=03&clip3=03&pwd");
			//$familiar[Cornbeefadon].use_familiar(); // for amulet coin
			$familiar[Mu].use_familiar(); // for luck incense
			$item[box of Familiar Jacks].use(1);
		}
	}
	//if ($effect[Meteor Showered].have_effect() <= 0) // we can re-get Meteor Showered now, no need to preserve from rollover
	{
		// to get ghostly reins, but don't want to waste meteor showered, which always disappears at end of combat
		FightGhost();
	}
	$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
	string page = visit_url("main.php?action=may4");
	if (page.contains_text("Empathy Chip"))
		visit_url("choice.php?whichchoice=1386&option=4"); // +10 familiar weight
	if (HaveItem($item[ghostly reins]))
		$slot[off-hand].equip($item[ghostly reins]);
	else
	{
		if (!HaveItem($item[rope]) && get_property("_deckCardsDrawn").to_int() <= 10)
			cli_execute("cheat rope");
		if (HaveItem($item[rope]))
			$slot[off-hand].equip($item[rope]);
	}
	$slot[acc1].equip($item[Beach Comb]);
	$slot[acc2].equip($item[hewn moon-rune spoon]);
	if ($item[Brutal brogues].item_amount() > 0)
		$slot[acc3].equip($item[Brutal brogues]);

	UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);
	UseSkillForEffect($skill[Leash of Linguini], $effect[Leash of Linguini]);
	UseSkillForEffect($skill[Blood Bond], $effect[Blood Bond]);
	UseItemForEffect($item[Gene Tonic: Fish], $effect[Human-Fish Hybrid]);
	UseItemForEffect($item[Gene Tonic: Construct], $effect[Human-Machine Hybrid]);
	ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);

	if ($effect[Puzzle Champ].have_effect() == 0
		&& !get_property("_witchessBuff").to_boolean())
	{
		cli_execute("witchess");
	}
	$familiar[XO Skeleton].use_familiar(); // should be the heaviest familiar at this point
	if ($effect[Fidoxene].have_effect() == 0)
		while ($item[Ghost Dog Chow].item_amount() > 0)
			$item[Ghost Dog Chow].use(1);
	$slot[familiar].equip(HaveSize10FamEqp()); // add 10 pounds
	if (get_property("_freePillKeeperUsed") == "false" && $effect[Fidoxene].have_effect() == 0)
		cli_execute("pillkeeper free familiar");
	SaberBuff();
	DoQuest(5, 31); // familiar weight
	ChooseFamiliar();
}
void DoQuest6()
{
	if (completedQuests[6])
		return;

	cli_execute("beach head muscle");
	//BuyCoinItemForEffect($coinmaster[Game Shoppe], $item[wasabi marble soda], $effect[Wasabi With You]);
	//BuyItemForEffect($item[wasabi marble soda], $effect[Wasabi With You]);
	if ($effect[Wasabi With You].have_effect() <= 0)
	{
		if ($item[wasabi marble soda].item_amount() == 0 && $item[Ye Wizard's Shack snack voucher].item_amount() > 0)
		{
			visit_url("gamestore.php?action=buysnack&whichsnack=5019");
		}
		//cli_execute("cast * summon resolutions");
		$item[wasabi marble soda].use(1);
	}
	ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);
	UseSkillForEffect($skill[Carol of the Bulls], $effect[Carol of the Bulls]);
	UseSkillForEffect($skill[Blood Frenzy], $effect[Frenzied, Bloody]);
	UseItemForEffect($item[LOV Elixir #3], $effect[The Power of LOV]);
	UseItemForEffect($item[Gene Tonic: Beast], $effect[Human-Beast Hybrid]);
	UseItemForEffect($item[resolution: be feistier], $effect[Destructive Resolve]);

	if (get_property("camelSpit").to_int() == 100)
	{
		abort("Get camel spit buff");
	}
	SaberBuff();
	$slot[acc2].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc3].equip($item[Powerful Glove]);
	if ($item[intimidating chainsaw].HaveItem())
		$slot[weapon].equip($item[intimidating chainsaw]);
	$familiar[Disembodied Hand].use_familiar();
	FoldGarbage($item[broken champagne bottle], $slot[familiar]);

	if ($effect[Song of the North].have_effect() == 0)
	{
		EnsureMP(100);
		UseSkillForEffect($skill[Song of the North], $effect[Song of the North]);
	}
	if ($effect[Bow-Legged Swagger].have_effect() == 0)
	{
		EnsureMP(100);
		UseSkillForEffect($skill[Bow-Legged Swagger], $effect[Bow-Legged Swagger]);
	}
	DoQuest(6, 22); // weapon damage
	$slot[familiar].equip($item[none]);
}
void DoQuest7()
{
	if (completedQuests[7])
		return;

	cli_execute("beach head mysticality");
	UseItemForEffect($item[LOV Elixir #6], $effect[The Magic of LOV]);
	UseItemForEffect($item[Gene Tonic: Elf], $effect[Human-Elf Hybrid]);
	$slot[acc1].equip($item[hewn moon-rune spoon]);
	$slot[acc2].equip($item[Draftsman's driving gloves]);
	$slot[acc3].equip($item[Powerful Glove]);
	ExecuteForEffect("pool 2", $effect[Mental A-cue-ity]);
	UseSkillForEffect($skill[Spirit of Garlic], $effect[Spirit of Garlic]);
	UseSkillForEffect($skill[Simmer], $effect[Simmering]);
//abort("Drink Sockdollager");
	EnsureMP(30);
	UseSkillForEffect($skill[Carol of the Hells], $effect[Carol of the Hells]);
	EnsureMP(100);
	UseSkillForEffect($skill[Song of Sauce], $effect[Song of Sauce]);
	EnsureMP(100);
	UseSkillForEffect($skill[Bend Hell], $effect[Bendin' Hell]);
	SaberBuff();
	if (!$item[weeping willow wand].HaveItem() && $item[flimsy hardwood scraps].item_amount() > 0)
		$coinmaster[Your SpinMaster&trade; lathe].buy(1, $item[weeping willow wand]);
	if ($item[weeping willow wand].item_amount() > 0)
		$slot[weapon].equip($item[weeping willow wand]);
	DoQuest(7, 43); // (+spell damage)
}
void DoQuest8()
{
	if (completedQuests[8])
		return;

	BuyCoinItemForEffect($coinmaster[Precinct Materiel Division], $item[shoe gum], $effect[Gummed Shoes]);
	UseSkillForEffect($skill[The Sonata of Sneakiness], $effect[The Sonata of Sneakiness]);
	UseSkillForEffect($skill[Smooth Movement], $effect[Smooth Movements]);
	
	if ($effect[Invisible Avatar].have_effect() == 0)
	{
		$slot[acc3].equip($item[Powerful Glove]);
		UseSkillForEffect($skill[CHEAT CODE: Invisible Avatar], $effect[Invisible Avatar]);
	}

	ExecuteForEffect("swim sprints", $effect[Silent Running]);

	$slot[back].equip($item[protonic accelerator pack]);
	$slot[pants].equip($item[pantogram pants]);

	int expectedTurns = 21;
	if (get_campground() contains $item[Asdon Martin keyfob])
	{
		AsdonMartin($effect[Driving Stealthily]);
		expectedTurns -= 6;
	}

	// try to intergnat "Rational Thought"

	$item[squeaky toy rose].use(1);

	DoQuest(8, expectedTurns); // (-combat)
}
void DoQuest9()
{
	// todo: maybe kgb buff hunting
	if (completedQuests[9])
		return;

	DrinkForEffect($item[sacramento wine], $effect[Sacr&eacute; Mental], 1);
	BuyItemForEffect($item[pair of candy glasses], $effect[Sucrose-Colored Glasses]);

	if (get_property("_clanFortuneBuffUsed") == "false")
		cli_execute("fortune buff hagnk");
	ExecuteForEffect("terminal enhance items.enh", $effect[items.enh]);
	UseItemForEffect($item[resolution: be happier], $effect[Joyful Resolve]);
	if ($item[government cheese].item_amount() > 0 && $item[anticheese].item_amount() > 0)
		craft("combine", 1, $item[government cheese], $item[anticheese]);
	UseItemForEffect($item[government], $effect[I See Everything Thrice!]);
	ExecuteForEffect("pool 3", $effect[Hustlin']);
	UseSkillForEffect($skill[Fat Leon's Phat Loot Lyric], $effect[Fat Leon's Phat Loot Lyric]);
	UseSkillForEffect($skill[Singer's Faithful Ocelot], $effect[Singer's Faithful Ocelot]);
	UseItemForEffect($item[Gene Tonic: Pirate], $effect[Human-Pirate Hybrid]);

	if ($effect[Bat-Adjacent Form].have_effect() == 0)
	{
		FightWanderers(false); // clear out wanderers before using the latte banish on some random encounter
		$slot[back].equip($item[vampyric cloake]);
		$slot[weapon].equip($item[Fourth of may Cosplay Saber]);
		$slot[off-hand].equip($item[latte lovers member's mug]);
		$familiar[Ms. Puck Man].use_familiar();
		string page = visit_url($location[The Haunted Kitchen].to_url());
		run_combat("Filter_CloakeBatForm");
	}
	FoldGarbage($item[wad of used tape], $slot[hat]);
	if ($item[li'l ninja costume].HaveItem())
	{
		$familiar[trick-or-treating tot].use_familiar();
		$slot[familiar].equip($item[li'l ninja costume]);
	}
	else if ($item[luck incense].HaveItem())
	{
		$slot[familiar].equip($item[luck incense]);
	}
	$slot[off-hand].equip($item[A Light that Never Goes Out]);
	if ($item[fancy party pants].HaveItem())
		$slot[pants].equip($item[fancy party pants]);
	else
		$slot[pants].equip($item[Vicar's Tutu]);
	if ($item[Source essence].item_amount() > 100 && !$item[Source shades].HaveItem()
		&& get_property("_sourceTerminalExtrudes").to_int() < 3)
	{
		cli_execute("terminal extrude goggles");
	}
	if ($item[Source shades].item_amount() > 0)
		$slot[acc1].equip($item[Source shades]);
	$slot[acc2].equip($item[gold detective badge]);
	$slot[acc3].equip($item[your cowboy boots]);
	SweetSynthesisEffect(9); // item drop
	// todo: run LOV tunnel, grab earrings, eye surgery (choice 3), chocolate
	if (get_property("_barrelPrayer") != "true")
		cli_execute("barrelprayer buff");
	AsdonMartin($effect[Driving Observantly]);
	if (get_property("_steelyEyedSquintUsed") != "true")
	{
		EnsureMP(100);
		use_skill(1, $skill[Steely-Eyed Squint]);
	}
	if (TurnSavings(9) < 59)
		ChewForEffect($item[stench jelly], $effect[Stench Jellied]);

	if (TurnSavings(9) < 59)
	{
		if ($item[Dinsey whinskey].item_amount() == 0
			&& $item[FunFunds&trade;].item_amount() >= 2
			&& $effect[The Dinsey Spirit].have_effect() == 0)
		{
			visit_url("place.php?whichplace=airport_stench&intro=1");
			buy($coinmaster[The Dinsey Company Store], 1, $item[Dinsey whinskey]);
		}
		DrinkForEffect($item[Dinsey whinskey], $effect[The Dinsey Spirit], 2);
	}
	DoQuest(9, 1); // (item/booze drops)
}
void DoQuest10()
{
	if (completedQuests[10])
		return;

	cli_execute("beach head hot");
	string page;
	if (get_property("spacegateVaccine") != "true")
		cli_execute("spacegate vaccine 1"); // +resist
	$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
	if ($effect[Misty Form].have_effect() == 0)
	{
		FightWanderers(false); // clear out wanderers before using the latte banish on some random encounter
		$slot[back].equip($item[vampyric cloake]);
		$slot[off-hand].equip($item[latte lovers member's mug]);
		$familiar[Ms. Puck Man].use_familiar();
		page = visit_url($location[The Haunted Kitchen].to_url());
		run_combat("Filter_CloakeMistForm");
	}
	$slot[off-hand].equip($item[latte lovers member's mug]);
	cli_execute("latte refill chili pumpkin cinnamon");

	boolean lavaproof = false;
	if ($item[lava-proof pants].HaveItem())
	{
		$slot[pants].equip($item[lava-proof pants]);
		lavaproof = true;
	}
	else if ($item[pantogram pants].HaveItem())
		$slot[pants].equip($item[pantogram pants]);
	if ($item[high-temperature mining mask].HaveItem())
	{
		$slot[hat].equip($item[high-temperature mining mask]);
		lavaproof = true;
	}

	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	//if ($item[fireproof megaphone].HaveItem())
	//	$slot[off-hand].equip($item[fireproof megaphone]);
	boolean slot2used = false;
	boolean slot3used = false;
	if ($item[heat-resistant necktie].HaveItem())
	{
		$slot[acc2].equip($item[heat-resistant necktie]);
		slot2used = true;
		lavaproof = true;
	}
	if ($item[heat-resistant gloves].HaveItem())
	{
		lavaproof = true;
		if (slot2used)
		{
			$slot[acc3].equip($item[heat-resistant gloves]);
			slot3used = true;
		}
		else
		{
			$slot[acc2].equip($item[heat-resistant gloves]);
			slot2used = true;
		}
	}
	if (!slot3used)
		$slot[acc3].equip($item[LOV earrings]);
	if ($item[burning newspaper].item_amount() > 0 && !$item[burning cape].HaveItem())
		cli_execute("create burning cape");
	$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
	if (get_property("latteUnlocks").contains_text("chili") && !get_property("latteModifier").contains_text("Hot Resistance"))
	{
		cli_execute("latte refill chili pumpkin cinnamon");
	}
	$slot[back].equip($item[burning cape]);
	page = visit_url("main.php?action=may4");
	if (page.contains_text("Force Resistance Multiplier"))
		visit_url("choice.php?whichchoice=1386&option=3"); // +3 resist
	$familiar[Trick-or-Treating Tot].use_familiar();
	if (!HaveItem($item[li'l candy corn costume]) && my_meat() >= 1000)
		buy(1, $item[li'l candy corn costume]);
	if ($item[li'l candy corn costume].item_amount() > 0)
		$slot[familiar].equip($item[li'l candy corn costume]);

	if (get_property("_mayoTankSoaked") != "true" && get_campground() contains $item[portable Mayo Clinic])
		visit_url("shop.php?action=bacta&whichshop=mayoclinic");
	UseSkillForEffect($skill[Elemental Saucesphere], $effect[Elemental Saucesphere]);
	UseSkillForEffect($skill[Astral Shell], $effect[Astral Shell]);
	UseItemForEffect($item[hot powder], $effect[Flame-Retardant Trousers]);
	CraftPotionForEffect($item[lotion of stench], $item[stench powder], false, $effect[Stinky Hands], false);
	CraftPotionForEffect($item[lotion of sleaziness], $item[sleaze powder], false, $effect[Sleazy Hands], false);
	UseItemForEffect($item[Gene Tonic: Elemental], $effect[Human-Elemental Hybrid]);
	cli_execute("Briefcase enchantment hot");
	// pale horse?  500 meat to switch
	if (my_sign() == "Vole")
	{
		if ($item[bugbear beanie].item_amount() == 0)
			buy(1, $item[bugbear beanie]);
		if ($item[bugbear bungguard].item_amount() == 0)
			buy(1, $item[bugbear bungguard]);
		if ($item[frilly skirt].item_amount() == 0 && $item[Vicar's Tutu].item_amount() == 0)
			buy(1, $item[frilly skirt]);
		//use(1, $item[hewn moon-rune spoon);
		visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=8");
	}
	if ($item[jaba&ntilde;ero-flavored chewing gum].item_amount() < 2)
		buy(2, $item[jaba&ntilde;ero-flavored chewing gum]);
	SweetSynthesisEffect(10); // hot resist
	DoQuest(10, 1); // (+hot resist)
}
void DoQuest11()
{
	if (!completedQuests[11])
	{
		DoQuest(11, 60); // unreducible
	}
}

void Day1DrinkAndSpleen(boolean maxOut)
{
	if (my_inebriety() < 2) // should have 1 drunk already from mayo conversion
	{
		if (get_property("_sourceTerminalExtrudes").to_int() == 1 && $item[Source essence].item_amount() >= 10)
			cli_execute("terminal extrude booze");
		if (get_property("_sourceTerminalExtrudes").to_int() == 2 && $item[Source essence].item_amount() >= 10)
			cli_execute("terminal extrude booze");
		if (get_property("_barrelPrayer") != "true")
			cli_execute("barrelprayer buff");
		if ($effect[Ode to Booze].have_effect() < 10)
		{
			if ($effect[Polka of Plenty].have_effect() > 0)
				cli_execute("shrug " + $effect[Polka of Plenty]);
			ChateauRest(50);
			use_skill(1, $skill[The Ode to Booze]);
		}
		// drink a size 4 with cold jelly for the base booze:
		//if ($item[cold jelly].item_amount() > 0)
		//	chew(1, $item[cold jelly]);
		$item[hacked gibson].DoDrink(1); // for some reason, doesn't drink the second one with drink(2), maybe the cold jelly caused issues?
		// now use up the rest of the prayerbarrel buff:
		if (my_level() >= 11)
		{
			$item[astral pilsner].DoDrink($item[astral pilsner].item_amount());
		}
		else
		{
			$item[hacked gibson].DoDrink(1);
			$item[Sacramento wine].DoDrink(2);
		}
	}
	while (my_spleen_use() < 10 && $item[agua de vida].item_amount() > 0)
		chew(1, $item[agua de vida]);

	// If we're already level 11, might as well finish drinking, but if lower level,
	// wait until later for the maxOut flag to be set.
	if (my_level() >= 11 || maxOut)
	{
		if ($item[synthetic dog hair pill].item_amount() > 0
			&& get_property("_syntheticDogHairPillUsed") != "true"
			&& my_inebriety() <= inebriety_limit()) // don't use if overdrunk
		{
			use(1, $item[synthetic dog hair pill]);
		}
		if (my_inebriety() <= NonStooperDrunkLimit() - 3)
		{
			item perfect = CraftPerfectDrink();
			if (perfect != $item[none])
				DrinkForTurns(perfect, 3);
		}
		while (my_inebriety() < NonStooperDrunkLimit())
		{
			if (my_level() >= 11 && $item[astral pilsner].item_amount() > 0)
				DrinkForTurns($item[astral pilsner], 1);
			else if ($item[Sacramento wine].item_amount() > 0)
				DrinkForTurns($item[Sacramento wine], 1);
		}

		while (my_spleen_use() < 12 && $item[agua de vida].item_amount() > 0)
			chew(1, $item[agua de vida]);
	}
}

void Day2DrinkForTurns()
{
	if (my_inebriety() <= 5) // don't want to overdrink, expect to drink at least 9
	{
		if (get_property("_barrelPrayer") != "true")
			cli_execute("barrelprayer buff");
		if ($effect[Ode to Booze].have_effect() < 10)
		{
			ChateauRest(50);
			use_skill(1, $skill[The Ode to Booze]);
		}
		while ($item[astral pilsner].item_amount() > 0)
			if (!DrinkForTurns($item[astral pilsner], 1))
				break;

		while ($effect[Beer Barrel Polka].have_effect() >= 5 && my_inebriety() < 14) // use up remaining barrel prayer buff
		{
			if ($item[sacramento wine].item_amount() > 1)
				DrinkForTurns($item[sacramento wine], 1);
			if ($item[splendid martini].item_amount() > 0)
				DrinkForTurns($item[splendid martini], 1);
		}
	}
}

void EquipEmpty(slot s, item i)
{
	if (s.equipped_item() == $item[none] && i.item_amount() > 0)
		s.equip(i);
}

void InitCharacter()
{
	string consult1 = get_property("clanFortuneConsulter1");
	if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult1 != "")
	{
		cli_execute("fortune " + consult1);
	}
	FoldGarbage($item[makeshift garbage shirt], $slot[shirt]);

	EquipEmpty($slot[hat], $item[Iunion Crown]);
	EquipEmpty($slot[shirt], $item[makeshift garbage shirt]);
	EquipEmpty($slot[back], $item[protonic accelerator pack]);
	$slot[weapon].equip($item[Fourth of May Cosplay Saber]);
	EquipEmpty($slot[off-hand], $item[latte lovers member's mug]);
	EquipEmpty($slot[pants], $item[Cargo Cultist Shorts]);
	EquipEmpty($slot[acc1], $item[Retrospecs]);
	EquipEmpty($slot[acc2], $item[Eight Days a Week Pill Keeper]);
	EquipEmpty($slot[acc3], $item[Kremlin's Greatest Briefcase]);
		
	// burn initial MP
	use_skill(1, $skill[Perfect Freeze]);
	use_skill(1, $skill[Pastamastery]);

	if (!HaveItem($item[gold detective badge]))
		visit_url("place.php?whichplace=town_wrong&action=townwrong_precinct");

	if (!HaveItem($item[your cowboy boots]))
		visit_url("place.php?whichplace=town_right&action=townright_ltt");

	if (!HaveItem($item[Bastille Battalion control rig]))
		take_storage(1, $item[Bastille Battalion control rig]);

	if ($item[porquoise].item_amount() == 0
		&& $item[hamethyst].item_amount() == 0
		&& $item[baconstone].item_amount() == 0)
	{
		visit_url("tutorial.php?action=toot");
		use(1, $item[letter from King Ralph XI]);
		use(1, $item[pork elf goodies sack]);
	}
	if ($item[telegram from Lady Spookyraven].item_amount() > 0)
	{
		use(1, $item[telegram from Lady Spookyraven]); // normally done by mafia automatically on ascensions, but it's possible for that to fail
	}
	if ($item[astral six-pack].item_amount() > 0)
		use(1, $item[astral six-pack]);

	while (get_property("_genieWishesUsed").to_int() < 3)
		cli_execute("genie wish for more wishes");

	visit_url("place.php?whichplace=chateau&action=chateau_desk2");
	if (get_property("_campAwayCloudBuffs").to_int() == 0)
	{
		visit_url("place.php?whichplace=campaway&action=campaway_sky");
		visit_url("place.php?whichplace=campaway&action=campaway_sky");
		visit_url("place.php?whichplace=campaway&action=campaway_sky");
		visit_url("place.php?whichplace=campaway&action=campaway_sky");
	}


	if (my_meat() == 0)
	{
		cli_execute("numberology 14");
		cli_execute("numberology 14");
		cli_execute("numberology 14");
		cli_execute("numberology 89");
		autosell(3 * 14, $item[moxie weed]);
	}
	string consult2 = get_property("clanFortuneConsulter2");
	if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult2 != "")
	{
		cli_execute("fortune " + consult2);
	}

	if (get_property("_daycareNap") == "false")
		cli_execute("daycare item");
	if (get_property("_daycareGymScavenges") == "0")
	{
		string page = visit_url("place.php?whichplace=town_wrong&action=townwrong_boxingdaycare");
		if (!page.contains_text("Visit the Boxing Day Spa"))
			abort("unexpected boxing daycare adventure");
		page = visit_url("choice.php?whichchoice=1334&option=3");
		if (!page.contains_text("Scavenge for gym equipment"))
			abort("unexpected boxing daycare adventure");
		page = visit_url("choice.php?whichchoice=1336&option=2");
	}

	if (!HaveItem($item[turtle totem]))
	{
		buy(13, $item[chewing gum on a string]);
		use(13, $item[chewing gum on a string]);
		cli_execute("hermit * clover");
	}
	if (!(get_campground() contains $item[Dramatic&trade; range]))
	{
		buy(1, $item[Dramatic&trade; range]);
		use(1, $item[Dramatic&trade; range]);
	}

	if (!$item[continuum transfunctioner].HaveItem())
	{
		visit_url("place.php?whichplace=forestvillage&action=fv_mystic");
		run_choice(1); // Sure, old man.  Tell me all about it.
		run_choice(1); // Against my better judgement, yes.
		run_choice(1); // Er, sure, I guess so...
	}

	if (!$item[Shakespeare's Sister's Accordion].HaveItem())
	{
		use_skill(2, $skill[Summon Smithsness]);
		visit_url("campground.php?action=bookshelf&preaction=combinecliparts&clip1=04&clip2=04&clip3=04&pwd"); // bucket of wine
		create(1, $item[Shakespeare's Sister's Accordion]);
		if ($item[maiden wig].item_amount() == 0)
			buy(1, $item[maiden wig]);
		if ($item[lump of Brituminous coal].item_amount() > 0)
			create(1, $item[Hairpiece on Fire]);
	}

	
	if (!$item[pantogram pants].HaveItem())
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9573");
		visit_url("choice.php?whichchoice=1270&pwd&option=1&m=1&e=1&s1=-1,0&s2=-1,0&s3=-1,0");
	}

	if (!$item[FantasyRealm Mage's Hat].HaveItem())
	{
		visit_url("place.php?whichplace=realm_fantasy&action=fr_initcenter");
		run_choice(2); // mage's hat
	}

	$slot[hat].EquipEmpty($item[FantasyRealm Mage's Hat]);
	//$slot[shirt].EquipEmpty($item[makeshift garbage shirt]);
	$slot[back].EquipEmpty($item[protonic accelerator pack]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].EquipEmpty($item[KoL Con 13 snowglobe]);
	$slot[pants].EquipEmpty($item[pantogram pants]);
	$slot[acc1].EquipEmpty($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].EquipEmpty($item[gold detective badge]);
	$slot[acc3].EquipEmpty($item[your cowboy boots]);


	if (visit_url("shop.php?whichshop=doc").contains_text("Problem?"))
	{
		visit_url("shop.php?whichshop=doc&action=talk");
		run_choice(1); // go pick some flowers
	}
	if (visit_url("shop.php?whichshop=armory").contains_text("The sign says there's a sale?"))
	{
		visit_url("shop.php?whichshop=armory&action=talk");
		run_choice(1); // I'll get your pie
	}
	if (visit_url("shop.php?whichshop=meatsmith").contains_text("What do you need?"))
	{
		visit_url("shop.php?whichshop=meatsmith&action=talk");
		run_choice(1); // open skeleton shop
	}
	SmashBarrels();

	DailySummons();

	UseSkillForEffect($skill[Get Big], $effect[Big]);
	// add more skills here as they are hardcore permed

	if (get_property("_pottedTeaTreeUsed") != "true")
		cli_execute("teatree royal");
	ChooseEducate("extract");
	if (get_property("sourceTerminalEnquiry") != "stats.enq")
		cli_execute("terminal enquiry stats.enq");
	if (get_property("_horsery") == "")
		cli_execute("horsery dark");
	if (get_property("boomBoxSong") != "Total Eclipse of Your Meat")
		cli_execute("boombox meat");
	if ($item[green mana].item_amount() == 0)
	{
		MakeGreenMana();
		MakeGreenMana();
	}
	use(1, $item[Bird-a-Day calendar]);

	visit_url("shop.php?whichshop=lathe"); // get hardwood scraps

	string consult3 = get_property("clanFortuneConsulter3");
	if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult3 != "")
	{
		cli_execute("fortune " + consult3);
	}
}


void Day1()
{
	InitCharacter();
	UnlockGuildAndForest();
//abort("Manually here");
	while (NeedSnojoForEating() || my_level() < 4)
		if (!RunSnojo())
			break;

	if ($item[Source essence].item_amount() >= 10 && get_property("_sourceTerminalExtrudes").to_int() == 0)
		cli_execute("terminal extrude food");

	FightGhost();

	DogHairDistentionPills();
	FaxDairyGoat();
	EatBrowserCookie();
	DoQuest11(); // 60 turns

	BuffStatGain();
	RunLOVTunnel(1);
	FightWitchessRook();

	RunGingerbread();
	if ($item[a ten-percent Bonus].item_amount() > 0)
	{
		SweetSynthesisEffect(11); // +50% moxie gains
		//GetNeverendingPartyBuff();
		use(1, $item[a ten-percent Bonus]);
		cli_execute("cheat lovers");
		//BuyItemForEffect($item[blood of the Wereseal], $effect[Temporary Lycanthropy]); // for scaling fights, but can I afford this now?
	}

	ExecuteBastilleBattalion("BARBERSHOP", "DRAFTSMAN", "CANNON"); // moxie stats, +8 adventures, muscle buff

	if (get_property("_daycareSpa") == "false")
		cli_execute("daycare moxie");

	SpacegateMoxieStats(); // gain 1850 moxie stats
	ChallengeGodLobster(1, 1);
	ChallengeGodLobster(2, 2);

	GetNeverendingPartyBuff();
	while ( RunSnojo() )
	{
		//MakeGovernmentCheese(); // doesn't seem to be necessary anymore
	}
	RunNeverendingParty(10);

	FightChateauPainting();

	FightWitchessBishop(1, true);
	FightGhost();
	FightWitchessBishop(2, false);
	FightWitchessBishop(3, false);
	FightWitchessBishop(4, false);
	FightMachineTunnels();
	ChallengeGodLobster(3, 3);
	FightTentacle();
	GetBarfGarbage();
	FightWanderers(true);
	//StealVolcanoGear(); // replaced by "Use the force"
	// any other fights to handle before burning buffs to quest 7?
	Day1DrinkAndSpleen(false);
	DoQuest7(); // spell damage
	FightWanderers(true);
	DoQuest6(); // weapon damage


	FightWanderers(true);
	DoQuest10(); // fire resist

	FightWanderers(true);

	OpenToys();
	UnlockIsland();
	FightWanderers(true);
	if (get_property("_clanFortuneBuffUsed") == "false")
		cli_execute("fortune buff susie");
	Day1DrinkAndSpleen(true);

	UnlockHippyStore();

	DoQuest5(); // familiar weight

	MakeStenchJelly(); // this should trigger creating the last Poke fertilizer

	DoQuest8(); // -combat frequency

}

void TryForJumboOlive()
{
	if ($effect[Slippery Oiliness].have_effect() > 0
		|| (completedQuests[2] && completedQuests[4]))
	{
		return;
	}
	try
	{
		while ($item[jumbo olive].item_amount() == 0
			&& $item[oil of slipperiness].item_amount() == 0
			&& $item[disassembled clover].item_amount() + $item[ten-leaf clover].item_amount() > 0)
		{
			$slot[hat].equip($item[filthy knitted dread sack]);
			$slot[pants].equip($item[filthy corduroys]);
			if ($item[ten-leaf clover].item_amount() == 0)
				use(1, $item[disassembled clover]);
			visit_url($location[Hippy Camp].to_url());
			if ($item[fruit basket].item_amount() == 0)
				abort("Failed to retrieve fruit basket");
			use(1, $item[fruit basket]);
		}
	}
	finally
	{
		if ($item[ten-leaf clover].item_amount() > 0)
			use($item[ten-leaf clover].item_amount(), $item[ten-leaf clover]);
	}
}


void Day2()
{
	if (get_property("_horsery") == "")
		cli_execute("horsery dark");
	if (!HaveItem($item[A Light that Never Goes Out]))
	{
		use_skill(1, $skill[Summon Smithsness]);
		if ($item[third-hand lantern].item_amount() == 0)
			buy(1, $item[third-hand lantern]);
		create(1, $item[A Light that Never Goes Out]);
	}
	if (!HaveItem($item[Vicar's Tutu])) // todo
	{
		use_skill(1, $skill[Summon Smithsness]);
		if ($item[frilly skirt].item_amount() == 0)
			buy(1, $item[frilly skirt]);
		create(1, $item[Vicar's Tutu]);
	}
	//ExecuteBastilleBattalion("BABAR", "BRUTALIST", "CANNON"); // muscle stats, +8 familiar weight, muscle buff
	ExecuteBastilleBattalion("BARBERSHOP", "BRUTALIST", "CANNON"); // moxie stats, +8 familiar weight, muscle buff


	if (!HaveItem($item[pantogram pants]))
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9573");
		visit_url("choice.php?whichchoice=1270&pwd&option=1&m=1&e=1&s1=-1,0&s2=-1,0&s3=-1,0");
	}

	if (!HaveItem($item[FantasyRealm Warrior's Helm]))
	{
		visit_url("place.php?whichplace=realm_fantasy&action=fr_initcenter");
		visit_url("choice.php?pwd&whichchoice=1280&option=1"); // warrior's helm
	}

	DoQuest5(); // familiar weight

	TryForJumboOlive();

	GearForCombat();

	DailySummons();
	FightWitchessRook();
	FightWitchessBishop(1, true);
	while ( RunSnojo() ) { }
	RunGingerbread();
	GrabPirateDNA();
	FreeKillNinja();
	//FaxNinja();
	//FightWitchessBishop(2, false);
	//FightWitchessBishop(3, false);


	FightWanderers(false);
	DoQuest1(); // HP
	DoQuest4(); // Mox
	DoQuest2(); // Str
	DoQuest3(); // Myst

	//Day2DrinkForTurns(); // with recent changes, day 2 drinking no longer needed

	FightWanderers(false);
	DoQuest9(); // Items

	try
	{
		DoQuest(30); // (Final Service)
	}
	finally
	{
		visit_url("place.php?whichplace=sea_oldman&action=oldman_oldman");
	}
}


void main(int DayNum1or2)
{
	if (DayNum1or2 == 0)
	{
		for (int i = 1; i < 11; i++)
		{
			print("Expected turn savings for quest " + QuestGoal(i) + " = " + TurnSavings(i));
		}
		return;
	}
	if (my_daycount() != DayNum1or2)
	{
		if (!user_confirm("You entered day " + DayNum1or2 + " but actual day is " + my_daycount() + ".  Are you sure you wish to proceed?"))
			return;
	}
	CheckCounters();
	dayNumber = DayNum1or2;
	UpdateQuestStatus();
	if (DayNum1or2 == 1)
	{
		Day1();
		DoSleep();
	}
	else if (DayNum1or2 == 2)
	{
		Day2();
	}
}

