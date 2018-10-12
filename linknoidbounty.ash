
effect beatenUp = $effect[Beaten Up];
familiar nosyNose = $familiar[Nosy Nose];
item bait = $item[Monster Bait];

int mallPriceLimitPerBanish = 5000;
string printColor = "orange";

boolean PromptDebug = false;
boolean IsDebug = false;
void PrintDebug(string text)
{
	if (IsDebug)
		print(text, printColor);
}

void WriteSettings()
{
	string[string] map;
	file_to_map("linknoidfarm_" + my_name() + ".txt", map);
	map["promptDebug"] = PromptDebug.to_string();
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
			case "promptDebug": PromptDebug = value == "true"; break;
		}
	}
}

record Banisher
{
	string Key;
	int UsesPerDayCount;
	string UsedTodayCountProperty;
	int UsesRemain;
	item AsItem;
	skill AsSkill;
	item SkillProvider;
	monster CurrentlyBanished;
	int TurnsBanishedPerUse;
	int UntilTurn;
	int CostPerUse;
};
Banisher emptyBanisher;

record BountyDetails
{
	string key;
	bounty details;
	string difficulty;
	monster source;
	int foundCount;
	int requiredCount;
	Banisher[int] banishes;
	float[int] nonBounty;
	item accessItem;
	effect accessEffect;
	int accessTurns;
	boolean NoAccess;
};
Banisher emptyBounty;

void StringToBanisher(Banisher[string] coll, string SkillName, string ItemName, int UsesPerDay, int TurnsBanished, string UsedTodayCountProperty)
{
	Banisher result;
	string name;
	result.UsesPerDayCount = UsesPerDay;
	if (SkillName != "")
	{
		name = SkillName;
		result.AsSkill = SkillName.to_skill();
		result.SkillProvider = ItemName.to_item();
		if (!result.AsSkill.have_skill() && result.SkillProvider == $item[none])
		{
			result.UsesPerDayCount = 0;
		}
	}
	else if (ItemName != "")
	{
		name = ItemName;
		result.AsItem = ItemName.to_item();
		result.CostPerUse = result.AsItem.mall_price();
	}
	else
		abort("Must specify Skill or Item");
	result.UsedTodayCountProperty = UsedTodayCountProperty;
	result.TurnsBanishedPerUse = TurnsBanished;
	result.Key = name;
	coll[name] = result;
}

Banisher[string] GetAllBanishers()
{
	Banisher[string] result;
	StringToBanisher(result, "Batter Up!",                      "",                                    -1, -1, "");
	StringToBanisher(result, "Snokebomb",                       "",                                     3, 30, "_snokebombUsed");
	StringToBanisher(result, "Show them your ring",             "mafia middle finger ring",             1, 60, "_mafiaMiddleFinderRingUsed");
	StringToBanisher(result, "Breath Out",                      "hot jelly",                           -1, 20, "");
	StringToBanisher(result, "Breath Out",                      "toast with hot jelly",                -1, 20, "");
	StringToBanisher(result, "",                                "crystal skull",                       -1, 20, "");
	StringToBanisher(result, "",                                "Louder Than Bomb",                    -1, 20, "");
	StringToBanisher(result, "",                                "divine champagne popper",             -1,  5, "");
	StringToBanisher(result, "",                                "tennis ball",                         -1, 30, "");
	StringToBanisher(result, "",                                "Daily Affirmation: Be a Mind Master", -1, 80, "");
	StringToBanisher(result, "Unleash Nanites",                 "",                                    -1, -1, "");
	StringToBanisher(result, "Give Your Opponent the Stinkeye", "stinky eye cheese",                    1, 10, "_stinkyCheeseBanisherUsed");
	StringToBanisher(result, "Talk About Politics",             "Pantsgiving",                          5, 30, "_pantsgivingBanish");
	StringToBanisher(result, "KGB tranquilizer dart",           "Kremlin's Greatest Briefcase",         3, 20, "_kgbTranquilizerDartUses");
	StringToBanisher(result, "Spring Loaded Front Bumper",      "Asdon Martin",                        -1, 30, "");
	
	string[int] banishes = get_property("banishedMonsters").split_string(":");
	for (int i = 2; i < banishes.count(); i += 3)
	{
		monster mon = banishes[i - 2].to_monster();
		string src = banishes[i - 1];
		int turnBanished = banishes[i - 0].to_int();
		Banisher ban = result[src];
		ban.UntilTurn = turnBanished + ban.TurnsBanishedPerUse;
		ban.CurrentlyBanished = mon;
		result[src] = ban;
		print("Currently banished for " + (ban.UntilTurn - my_turnCount()) + " more turns = " + mon, printColor);
	}
	
	return result;
}


BountyDetails StringToBountyDetails(BountyDetails[string] coll, string difficulty, int requiredCount, string itemName)
{
	BountyDetails result, none;
	result.key = itemName;
	result.difficulty = difficulty;
	result.requiredCount = requiredCount;
	result.details = itemName.to_bounty();
	result.source = result.details.monster;

	if (result.details.number == 0)
		print("Illegal bounty " + itemName, printColor);

	foreach mon,freq in appearance_rates(result.details.location, false)
	{
		PrintDebug("In zone " + result.details + ", monster " + mon.id + " with freq " + freq);
		if (result.source != mon)
			result.nonBounty[mon.id] = freq;
	}
	if (IsDebug)
		waitq(1);

	coll[result.key] = result;
	return result;
}
BountyDetails StringToBountyDetails(BountyDetails[string] coll, string difficulty, int requiredCount, string itemName,
	string accessItem, int accessTurns, string accessEffect)
{
	StringToBountyDetails(coll, difficulty, requiredCount, itemName);
	coll[itemName].accessItem = accessItem.to_item();
	coll[itemName].accessTurns = accessTurns;
	coll[itemName].accessEffect = accessEffect.to_effect();
	return coll[itemName];
}

BountyDetails[string] GetAllBounties()
{
	BountyDetails[string] result;
	StringToBountyDetails(result, "Easy"   , 35, "bean-shaped rock");
	StringToBountyDetails(result, "Easy"   , 8 , "bloodstained briquette");
	StringToBountyDetails(result, "Easy"   , 10, "brightly-colored bottlecap");
	StringToBountyDetails(result, "Easy"   , 13, "broken petri dish");
	StringToBountyDetails(result, "Easy"   , 13, "broken plunger handle");
	StringToBountyDetails(result, "Easy"   , 11, "bundle of receipts");
	StringToBountyDetails(result, "Easy"   , 4 , "callused fingerbone");
	StringToBountyDetails(result, "Easy"   , 10, "cherry stem");
	StringToBountyDetails(result, "Easy"   , 8 , "crumpled pink slip");
	StringToBountyDetails(result, "Easy"   , 8 , "drop of filthy ichor");
	StringToBountyDetails(result, "Easy"   , 7 , "empty greasepaint tube");
	StringToBountyDetails(result, "Easy"   , 13, "half-empty bottle of eyedrops");
	StringToBountyDetails(result, "Easy"   , 7 , "handful of meatberries");
	StringToBountyDetails(result, "Easy"   , 6 , "important bat file");
	StringToBountyDetails(result, "Easy"   , 8 , "paper towel");
	StringToBountyDetails(result, "Easy"   , 13, "pink bat eye");
	StringToBountyDetails(result, "Easy"   , 6 , "triffid bark");
	StringToBountyDetails(result, "Easy"   , 8 , "shredded can label");
	StringToBountyDetails(result, "Easy"   , 10, "sugar button");
	StringToBountyDetails(result, "Easy"   , 13, "suspicious mole");
	StringToBountyDetails(result, "Hard"   , 10, "absence of moss");
	StringToBountyDetails(result, "Hard"   , 4 , "bit of wilted lettuce");
	StringToBountyDetails(result, "Hard"   , 8 , "black eye");
	StringToBountyDetails(result, "Hard"   , 12, "burned-out arcanodiode");
	StringToBountyDetails(result, "Hard"   , 8 , "dirty coal button");
	StringToBountyDetails(result, "Hard"   , 10, "discarded pacifier");
	StringToBountyDetails(result, "Hard"   , 13, "distintegrating cork");
	StringToBountyDetails(result, "Hard"   , 8 , "dusty wing");
	StringToBountyDetails(result, "Hard"   , 8 , "filthy rag");
	StringToBountyDetails(result, "Hard"   , 10, "length of bent pipe");
	StringToBountyDetails(result, "Hard"   , 11, "non-Euclidean hoof");
	StringToBountyDetails(result, "Hard"   , 6 , "sticky stardust");
	StringToBountyDetails(result, "Hard"   , 10, "beard crumbs");
	StringToBountyDetails(result, "Hard"   , 13, "rubber rib");
	StringToBountyDetails(result, "Hard"   , 13, "haunted pullstring");
	StringToBountyDetails(result, "Hard"   , 10, "rusty tap handle");
	StringToBountyDetails(result, "Hard"   , 13, "spare abacus bead");
	StringToBountyDetails(result, "Hard"   , 13, "spent handwarmer");
	StringToBountyDetails(result, "Hard"   , 6 , "warrrrrt");
	StringToBountyDetails(result, "Hard"   , 6 , "worthless piece of yellow glass");
	StringToBountyDetails(result, "Special", 13, "pixellated ashes"      , "jar of psychoses (The Crackpot Mystic)",        -1, "");
	StringToBountyDetails(result, "Special", 10, "empty rum bottle"      , "one-day ticket to Dinseylandfill",              -1, "");
	StringToBountyDetails(result, "Special", 8 , "frozen clipboard"      , "one-day ticket to The Glaciest",                -1, "");
	StringToBountyDetails(result, "Special", 8 , "glittery skate key"    , "tiny bottle of absinthe",                       10, "Absinthe-Minded");
	StringToBountyDetails(result, "Special", 9 , "grizzled stubble"      , "transporter transponder",                       30, "Transpondent");
	StringToBountyDetails(result, "Special", 10, "hardened lava glob"    , "one-day ticket to That 70s Volcano",            -1, "");
	StringToBountyDetails(result, "Special", 6 , "hickory daiquiri"      , "devilish folio",                                30, "Dis Abled");
	StringToBountyDetails(result, "Special", 8 , "greasy string"         , "jar of psychoses (The Meatsmith)",              -1, "");
	StringToBountyDetails(result, "Special", 13, "pickle chip"           , "one-day ticket to Spring Break Beach",          -1, "");
	StringToBountyDetails(result, "Special", 8 , "pile of country guano" , "astral mushroom",                               5, "Half-Astral");
	StringToBountyDetails(result, "Special", 10, "wig powder"            , "\"DRINK ME\" potion",                           20, "Down the Rabbit Hole");
	StringToBountyDetails(result, "Special", 6 , "pop art banana peel"   , "llama lama gong",                               12, "Shape of...Mole!");
	StringToBountyDetails(result, "Special", 9 , "purple butt"           , "empty agua de vida bottle",                           10, "");
	StringToBountyDetails(result, "Special", 13, "unlucky claw"          , "jar of psychoses (The Suspicious-Looking Guy)", -1, "");
	StringToBountyDetails(result, "Special", 10, "vivisected hair"       , "one-day ticket to Conspiracy Island",           -1, "");
	return result;
}

BountyDetails[string] AllBounties = GetAllBounties();
Banisher[string] AllBanishers = GetAllBanishers();

BountyDetails easy, hard, special, current;

BountyDetails GetBounty(string name)
{
	int count = 0;
	int ix = name.index_of(":");
	if (ix >= 0)
	{
		count = name.substring(ix + 1).to_int();
		name = name.substring(0, ix);
	}
	BountyDetails result = AllBounties[name];
	result.foundCount = count;
	return result;
}

BountyDetails TakeBounty(string difficulty)
{
	BountyDetails result;
	result = GetBounty(get_property("current" + difficulty + "BountyItem"));
	if (result.key == "")
	{
		result = GetBounty(get_property("_untaken" + difficulty + "BountyItem"));
		if (result.key != "")
		{
			print("Bounty not taken for " + difficulty + ", taking");
			visit_url("bounty.php");
			string url = "bounty.php?pwd=" + my_hash() + "&action=take";
			if (difficulty == "Easy")
				url += "low";
			else if (difficulty == "Hard")
				url += "high";
			else if (difficulty == "Special")
				url += "special";
			PrintDebug(url);
			visit_url(url);
		}
		result = GetBounty(get_property("current" + difficulty + "BountyItem"));
	}
	print(difficulty + " bounty = " + result.key, printColor);
	return result;
}

void TakeAllBounties()
{
	visit_url("bounty.php");
	easy = TakeBounty("Easy");
	hard = TakeBounty("Hard");
	special = TakeBounty("Special");
}

void AbandonBounty(BountyDetails b)
{
	print("Abandoning " + b.difficulty + " quest for " + b.details);
	switch (b.difficulty)
	{
		case "Easy":
			visit_url("bounty.php?pwd=" + my_hash() + "&action=giveup_low");
			break;
		case "Hard":
			visit_url("bounty.php?pwd=" + my_hash() + "&action=giveup_hig");
			break;
		case "Special":
			visit_url("bounty.php?pwd=" + my_hash() + "&action=giveup_spe");
			break;
	}
}

void PrepareBanishers()
{
	foreach key,b in AllBanishers
	{
		int usesRemain = -1;
		if (b.UsedTodayCountProperty != "")
		{
			string usedStr = get_property(b.UsedTodayCountProperty);
			PrintDebug("Banisher " + b.Key + " used = " + usedStr);
			if (b.UsesPerDayCount == 1)
				usesRemain = usedStr.to_boolean() ? 0 : 1;
			else
				usesRemain = b.UsesPerDayCount - usedStr.to_int();
		}
		if (usesRemain > 0 && b.SkillProvider.item_amount() > 0 && b.SkillProvider.can_equip())
		{
			b.SkillProvider.to_slot().equip(b.SkillProvider);
		}
		b.UsesRemain = usesRemain;
	}
}

boolean BanisherUsed(Banisher b)
{
	foreach mon, ban in current.banishes
	{
		if (ban == b && my_turnCount() < b.UntilTurn)
			return true;
	}
	return false;
}

void PopulateZoneBanishes()
{
	foreach ignore1,bnty in AllBounties
	{
		foreach monId,rate in bnty.nonBounty
		{
			monster mon = monId.to_monster();
			foreach ignore2,ban in AllBanishers
			{
				if (ban.CurrentlyBanished == $monster[none])
					continue;
				if (ban.CurrentlyBanished == mon)
				{
					bnty.Banishes[monId] = ban;
					print("Marking zone banished " + mon + " for bounty " + bnty);
				}
			}
		}
	}
}

//monster MapDynamicMonster(monster mon)
//{
//	// this doesn't work, you need to have unlocked dungeons of doom with + sign before
//	// you can do the bounty, since it requires a kobold, not an uppercase K
//	switch (mon)
//	{
//		case $monster[lowercase B]: return $monster[acid blob];
//		case $monster[lowercase K]: return $monster[large kobold];
//		case $monster[lowercase H]: return $monster[mind flayer];
//		case $monster[Uppercase Q]: return $monster[Quantum Mechanic];
//		case $monster[swarm of lowercase As]: return $monster[swarm of killer bees];
//		default: return mon;
//	}
//}

string TryBanish(monster mon)
{
	//mon = MapDynamicMonster(mon);
	print("Fighting monster " + mon + " with id=" + mon.id);
	if (current.nonBounty[mon.id] < 0.1) // wandering monsters or rare enounters don't matter
	{
		print("Non-standard monster, no banish = " + mon, printColor);
		return "";
	}
	current.banishes[mon.id] = emptyBanisher;
	Banisher bestBanish;
	foreach key,ban in AllBanishers
	{
		PrintDebug("Evaluating banisher " + ban.Key);
		if (ban.UsesRemain <= bestBanish.UsesRemain)
		{
			PrintDebug("0 or fewer uses remain");
			continue;
		}
		if (BanisherUsed(ban))
		{
			PrintDebug("Banisher already in use in this zone");
			continue;
		}
		if (ban.AsItem != $item[none])
		{
			if (ban.AsItem.item_amount() == 0)
			{
				PrintDebug("not enough items");
				continue;
			}
			if (ban.AsItem.to_slot() != $slot[none]
				&& !ban.AsItem.have_equipped())
			{
				PrintDebug("banisher item not equipped");
				continue;
			}
		}
		else if (ban.AsSkill != $skill[none])
		{
			if (ban.SkillProvider != "none".to_item())
			{
				if (!ban.SkillProvider.have_equipped())
				{
					PrintDebug("Don't have " + ban.SkillProvider + " equipped");
					continue;
				}
			}
			else if (!ban.AsSkill.have_skill())
			{
				PrintDebug("Don't have skill " + ban.AsSkill);
				continue;
			}
			else if (ban.AsSkill.mp_cost() > my_mp())
			{
				PrintDebug("Don't have enough MP");
				continue;
			}
			else if (ban.AsSkill == $skill[Batter Up!] && my_fury() < 5)
			{
				PrintDebug("Don't have enough fury");
				continue;
			}
		}
		bestBanish = ban;
	}
	string result = "";
	if (bestBanish.AsSkill != "none".to_skill())
		result = "skill " + bestBanish.AsSkill;
	else if (bestBanish.AsItem != "none".to_item())
		result = "item " + bestBanish.AsItem;
	if (result != "")
	{
		current.banishes[mon.id] = bestBanish;
		print("Banishing for " + bestBanish.TurnsBanishedPerUse + " turns", printColor);
		bestBanish.UntilTurn = my_turnCount() + bestBanish.TurnsBanishedPerUse;
	}
	else
	{
		print("No banisher found ", printColor);
	}
	if (IsDebug)
		waitq(5);
	return result;
}

boolean whiffed = false;
monster matingCalled;

void ResetCombatState()
{
	whiffed = false;
}

string Filter_Combat(int round, monster mon, string page)
{
	if ($monsters[ticking time bomb, frustrating knight, rage flame] contains mon)
	{
		// can't do anything but attack here
		return "attack";
	}
	if (mon == current.source)
	{
		if (!whiffed && my_mp() > 40 && $skill[Transcendent Olfaction].have_skill()
			&& $effect[On the Trail].have_effect() <= 0)
		{
			whiffed = true;
			return "skill " + $skill[Transcendent Olfaction];
		}
		if (!whiffed && my_familiar() == nosyNose)
		{
			whiffed = true;
			return "skill " + $skill[Get a Good Whiff of This Guy];
		}
		if (matingCalled != mon && my_mp() > 25 && $skill[Gallapagosian Mating Call].have_skill())
		{
			matingCalled = mon;
			return "skill " + $skill[Gallapagosian Mating Call];
		}
	}
	else
	{
		string result = TryBanish(mon);
		if (result != "")
		{
			print("Banishing with " + result, printColor);
			return result;
		}
	}
	return "";
}

boolean PromptToUnlock()
{
	int price = current.accessItem.mall_price();
	if (!user_confirm("It will cost " + price + " meat to buy " + current.accessItem + " to unlock zone " + current.details.location + "."
		+ "\r\n\r\nSpend " + price + " meat to unlock?"))
	{
		if (user_confirm("Do you want to abandon bounty in zone " + current.details.location + "?"))
			AbandonBounty(current);
		return false;
	}
	if (current.accessItem.item_amount() == 0)
		buy(1, current.accessItem);
	if (current.accessItem.item_amount() == 0)
		return false;
	if (current.accessItem == $item[llama lama gong])
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f-1&whichitem=3353"); // this item breaks out of the script, so use visit_url instead
	else
		use(1, current.accessItem);
	return true;
}

boolean UnlockGuild()
{
	return false;
	// todo
}

boolean UnlockFunHouse() // nemesis quest
{
	location guildZone;
	string guildName;
	int ghostChoice;
	item requiredITem;
	switch (my_class().to_string())
	{
		case "Seal Clubber":
			guildName = "f";
			guildZone = $location[The Outskirts of Cobb's Knob];
			requiredItem = $item[seal-clubbing club];
			break;
		case "Turtle Tamer":
			guildName = "f";
			guildZone = $location[The Outskirts of Cobb's Knob];
			requiredItem = $item[turtle totem];
			break;
		case "Sauceror":
			guildName = "m";
			guildZone = $location[The Haunted Pantry];
			requiredItem = $item[saucepan];
			break;
		case "Pastamancer":
			guildName = "m";
			guildZone = $location[The Haunted Pantry];
			requiredItem = $item[pasta spoon];
			break;
		case "Disco Bandit":
			guildName = "t";
			guildZone = $location[The Sleazy Back Alley];
			requiredItem = $item[disco ball];
			break;
		case "Accordion Thief":
			guildName = "t";
			guildZone = $location[The Sleazy Back Alley];
			requiredItem = $item[stolen accordion];
			break;
		default:
			print("Unlocking guild for class " + my_class() + " not yet supported");
			return false;
			
	}
print("Unlocking fun house is not fully implemented yet", printColor);
return false;
	string page = visit_url("guild.php?guild=" + guildName);
	if (page.contains_text("todo: blah blah"))
	{
		if (!UnlockGuild())
			return false;
	}
	
	page = visit_url("guild.php?place=scg");
	visit_url("guild.php?place=scg"); // multiple visits to unlock

	while (requiredItem.item_amount() == 0)
	{
		buy(1, $item[chewing gum on a string]);
		use(1, $item[chewing gum on a string]);
	}
	while (true)
	{
		page = visit_url($location[The Unquiet Garves].to_url());
		if (page.contains_text("You're fighting"))
		{
			run_combat();
			continue;
		}
		if (page.contains_text("Todo: blah blah"))
		{
			run_choice(ghostChoice);
			visit_url("choice.php"); // is this right?
			run_combat();
			// do swap items
			break;
		}
	}
}


void DoBounty(BountyDetails b)
{
	if ((b.details.location == $location[The Degrassi Knoll Restroom]
		|| b.details.location == $location[The Degrassi Knoll Gym])
		&& (my_sign() == "Mongoose" || my_sign() == "Wallaby" || my_sign() == "Vole"))
	{
		print("Can't do Degrassi bounty under Degrassi moonsign:", printColor);
		AbandonBounty(b);
		b.NoAccess = true;
		return;
	}
	print("Attempting bounty at " + b.details.location, printColor);
	current = b;
        string propertyName = ("current" + b.difficulty + "BountyItem");
	boolean slot3Avail = true;
	while (GetBounty(get_property(propertyName)).foundCount < b.requiredCount)
	{
		if (my_adventures() == 0)
			abort("Out of adventures");
		if (beatenUp.have_effect() > 0)
			abort("Got beaten up, please correct before continuing.");
		if (nosyNose.have_familiar() && my_familiar() != nosyNose)
			nosyNose.use_familiar();
		PrepareBanishers();
		if (bait.item_amount() > 0 && !bait.have_equipped() && slot3Avail
			&& b.details.location != $location[Lair of the Ninja Snowmen]) // +combat means you only get assassins eventually
		{
			$slot[acc3].equip(bait);
		}
		if (current.details.location == $location[The Poop Deck])
		{
			item fledges = $item[pirate fledges];
			if (fledges.item_amount() > 0)
				$slot[acc2].equip($item[pirate fledges]);
			if (!fledges.have_equipped())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (current.details.location == $location[Inside the Palindome])
		{
			item talisman = $item[talisman o' namsilat];
			if (talisman.item_amount() > 0)
				$slot[acc2].equip(talisman);
			if (!talisman.have_equipped())
			{
				b.NoAccess = true;
				return;
			}
		}
		ResetCombatState();
		string page = visit_url(current.details.location.to_url());
		if (page.contains_text("choice.php"))
		{
			if (page.contains_text("Typographical Clutter"))
			{
				if ($item[plus sign].item_amount() == 0)
					run_choice(3); // The big apostrophe
				else
					run_choice(5); // teleportitis
			}
			else if (page.contains_text("The Oracle Will See You Now"))
			{
				run_choice(3);
				use(1, $item[plus sign]);
			}
			else if (page.contains_text("Lights Out in the Nursery"))
			{
				run_choice(1);
				run_choice(2);
				run_choice(2);
				run_choice(1);
				run_choice(1);
			}
			else if (page.contains_text("Lights Out in the Conservatory"))
			{
				run_choice(1); // make a torch
				run_choice(2); // examine the graves
				run_choice(2); // examine crumbles
			}
			else if (page.contains_text("Lights Out in the Wine Cellar"))
			{
				run_choice(1);
				run_choice(1);
			}
			else if (page.contains_text("Lights Out in the Kitchen"))
			{
				run_choice(1);
			}
			else if (page.contains_text("Lights Out in the Bathroom"))
			{
				run_choice(2);
			}
			else if (page.contains_text("Off the Rack"))
			{
				run_choice(1);
			}
			else if (page.contains_text("The Fast and the Furry-ous"))
			{
				run_choice(1);
			}
			else if (page.contains_text("All Over the Map"))
			{
				run_choice(3); // Be Mine
				run_choice(1); // black gold
			}
			else if (page.contains_text("Arboreal Respite"))
			{
				run_choice(2); // explore the stream
				run_choice(2); // skip adventure
			}
			else if (page.contains_text("A Sietch in Time"))
			{
				run_choice(1);
			}
			else if (page.contains_text("Cavern Entrance") || page.contains_text("Entrance to the Forgotten City"))
			{
				run_choice(2);
			}
			else if (page.contains_text("Having a Medicine Ball"))
			{
				run_choice(2);
				run_choice(4);
			}
			else if (page.contains_text("Heart of Madness"))
			{
				if ($item[strawberry].item_amount() > 0
					&& $item[wad of dough].item_amount() > 0
					&& $item[glob of enchanted icing].item_amount() > 0
					&& ($item[popular part].item_amount() > 0 || get_property("popularTartUnlocked") == "true"))
				{
					run_choice(3); // popular machine
					run_choice(1);
				}
				else if (page.contains_text("option=1"))
				{
					run_choice(1);
					run_combat("Filter_Combat");
				}
				else
				{
					run_choice(4);
				}
			}
			else if (page.contains_text("Out in the Open Source"))
			{
				run_choice(1);
			}
			else if (page.contains_text("You Don't Mess Around with Gym"))
			{
				run_choice(4);
			}
			else if (page.contains_text("Temporarily Out of Skeletons"))
			{
				run_choice(1);
			}
			else if (page.contains_text("Lots of Options"))
			{
				run_choice(1);
				run_choice(5);
				run_choice(2);
			}
			else if (page.contains_text("O Cap'm, My Cap'm"))
			{
				run_choice(1);
				visit_url("ocean.php?lon=59+lat=10");
			}
			else if (page.contains_text("Yeah, You're for Me, Punk Rock Giant"))
			{
				run_choice(3);
				run_choice(2);
			}
			else if (page.contains_text("Melon Collie and the Infinite Lameness"))
			{
				run_choice(4);
				run_choice(2);
			}
			else if (page.contains_text("Flavor of a Raver"))
			{
				run_choice(4);
				run_choice(3);
				run_choice(2);
			}
			else if (page.contains_text("Copper Feel"))
			{
				run_choice(2);
			}
			else if (page.contains_text("Welcome to the Copperhead Club"))
			{
				run_choice(1);
			}
			else if (page.contains_text("Shen Copperhead, Nightclub Owner"))
			{
				run_choice(1);
			}
                	else if (page.contains_text("The Singing Tree"))
			{
				run_choice(4);
			}
                	else if (page.contains_text("Oh No, Hobo"))
			{
				run_choice(3);
			}
                	else if (page.contains_text("The Baker's Dilemma"))
			{
				run_choice(2);
			}
                	else if (page.contains_text("you discover a Knob Goblin Assistant Chef rummaging through the shelves"))
			{
				run_choice(3);
			}
                	else if (page.contains_text("Duffel on the Double"))
			{
				run_choice(3);
			}
                	else if (page.contains_text("Saint Beernard"))
			{
				run_choice(1);
			}
                	else if (page.contains_text("Yeti Nother Hippy"))
			{
				run_choice(1);
			}
                	else if (page.contains_text("Generic Teen Comedy Snowboarding Adventure"))
			{
				run_choice(1);
			}
                	else if (page.contains_text("Malice in Chains"))
			{
				run_choice(2);
				run_combat("Filter_Combat");
			}
                	else if (page.contains_text("Knob Goblin BBQ"))
			{
				run_choice(2);
				run_combat("Filter_Combat");
			}
                	else if (page.contains_text("Welcome Back!"))
			{
				run_choice(1);
				return;
			}
                	else if (page.contains_text("The Gong Has Been Bung"))
			{
				run_choice(2);
				return;
			}
                	else if (page.contains_text("Working Holiday"))
			{
				run_choice(3);
				return;
			}
                	else if (page.contains_text("Lights Out in the Laboratory"))
			{
				run_choice(2);
				return;
			}
                	else if (page.contains_text("Set an Open Course for the Virgin Booty"))
			{
				visit_url("ocean.php?lon=59+lat=10");
				return;
			}
                	else if (page.contains_text("Denim Axes Examined"))
			{
				run_choice(2); // No thanks
				return;
			}
                	else if (page.contains_text("Sun at Noon, Tan Us"))
			{
				run_choice(1);
				return;
			}
                	else if (page.contains_text("A Pre-War Dresser Drawer, Pa!"))
			{
				run_choice(2); // ignawer the drawer
				return;
			}
                	else if (page.contains_text("No sir, away!  A papaya war is on!"))
			{
				visit_url("choice.php?whichchoice=127&option=1");
				//run_choice(1);
				return;
			}
			else if (page.contains_text("Foreshadowing Demon!"))
			{
				run_choice(2); // Get out on the double
				return;
			}
			else if (page.contains_text("Adventurer, $1.99"))
			{
				run_choice(2); // Let sleeping doors lie
				return;
			}
			else if (page.contains_text("When Rocks Attack"))
			{
				run_choice(2); // Sorry, gotta run
				return;
			}
			else if (page.contains_text("All They Got Inside is Vacancy (and Ice)"))
			{
				run_choice(5); // Raid some guest rooms
				return;
			}
			else if (page.contains_text("Finger-Lickin'... Death."))
			{
				run_choice(3); // Walk away in disgust
				return;
			}
                	else if (page.contains_text("Random Lack of an Encounter"))
			{
				run_choice(1);
				return;
			}
                	else if (page.contains_text("Ouch!  You bump into a door!"))
			{
				run_choice(2); // fight a mimic
				run_combat("Filter_Combat");
				return;
			}
                	else if (page.contains_text("Stupid Pipes."))
			{
				run_choice(3);
				return;
			}
			else if (page.contains_text("The Gong Has Been Bung"))
			{
				run_choice(2); // Soul of the mole
				return;
			}
			else if (page.contains_text("Take the Bad Trip"))
			{
				run_choice(1); // Bad Trip
				return;
			}
			else if (page.contains_text("Violet Fog"))
			{
				run_choice(4); // Escape
				return;
			}
			else if (page.contains_text("Down by the Riverside"))
			{
				run_choice(3); // Play some volleyball
				return;
			}
			else if (page.contains_text("Beyond Any Measure"))
			{
				run_choice(4); // Measure the caverns
				return;
			}
			else if (page.contains_text("Death is a Boat"))
			{
				run_choice(3); // Check out the helm
				return;
			}
			else if (page.contains_text("The Floor Is Yours"))
			{
				if ($item[fused fuse].item_amount() == 0)
				{
					run_choice(7); // Sabotage the machine
					return;
				}
				if ($item[empty lava bottle].item_amount() > 0 && $item[full lava bottle].item_amount() == 0)
				{
					run_choice(3); // Use the kiln
					return;
				}
				if ($item[New Age healing crystal].item_amount() > 0 && $item[empty lava bottle].item_amount() == 0)
				{
					run_choice(2); // Use the kiln
					return;
				}
				if ($item[1,970 carat gold].item_amount() > 0 && $item[thin gold wire].item_amount() == 0)
				{
					run_choice(1); // Use the kiln
					return;
				}
				if ($item[glowing New Age crystal].item_amount() > 0 && $item[crystalline light bulb].item_amount() == 0)
				{
					run_choice(5); // Use the bulber
					return;
				}
				if ($item[viscous lava globs].item_amount() > 0)
				{
					if ($item[red lava globs].item_amount() == 0)
					{
						run_choice(6);
						run_choice(1);
					}
					else if ($item[blue lava globs].item_amount() == 0)
					{
						run_choice(6);
						run_choice(2);
					}
					else if ($item[green lava globs].item_amount() == 0)
					{
						run_choice(6);
						run_choice(3);
					}
				}
				run_choice(8); // leave the machine alone
				return;
			}
			else
			{
				print(page);
				abort("To do, choice.php not yet handled");
			}
		}
		else if (page.contains_text("You're fighting <span id='"))
		{
			run_combat("Filter_Combat");
		}
		else if (page.contains_text("You find yourself strangely drawn to Mt. Molehill"))
		{
			visit_url($location[Mt. Molehill].to_url());
			run_combat("Filter_Combat");
			//abort("Can't adventure anywhere else while in Shape of...Mole!");
		}
		else if (page.contains_text("You're going to need some sort of stench protection if you want to adventure here."))
		{
			if ($item[ghost of a necklace].item_amount() > 0)
			{
				$slot[acc3].equip($item[ghost of a necklace]);
			}
			if ($item[Pine-Fresh air freshener].item_amount() > 0)
			{
				$slot[acc3].equip($item[Pine-Fresh air freshener]);
			}
			slot3Avail = false;
		}
		else if (page.contains_text("You don't know where that place is."))
		{
			if ($item[&quot;DRINK ME&quot; potion].item_amount() == 0)
			{
				buy(1, $item[&quot;DRINK ME&quot; potion]);
			}
			use(1,  $item[&quot;DRINK ME&quot; potion]);
		}
		else if (page.contains_text("You can't get there anymore, because you don't know the transporter frequency."))
		{
			if ($item[transporter transponder].item_amount() == 0)
			{
				buy(1, $item[transporter transponder]);
			}
			use(1, $item[transporter transponder]);
		}
		else if (page.contains_text("You shouldn't be here.")
			&& (current.details.location == $location[Anger Man's Level]
			|| current.details.location == $location[Mt. Molehill]))
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("That isn't a place.")
			&& (current.details.location == $location[The "Fun" House]))
		{
			if (!UnlockFunHouse())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("That isn't a place you can go.")
			&& ((current.details.location == $location[The Secret Government Laboratory])
			|| (current.details.location == $location[LavaCo&trade; Lamp Factory])
			|| (current.details.location == $location[The Ice Hotel]))
			)
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("You don't know where that place is."))
		{
			print("Cannot visit " + current.details.location + ", skipping bounty", printColor);
			current.NoAccess = true;
			return;
		}
		else if (page.contains_text("You're in the regular dimension now, and don't remember how to get back there."))
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
			if (available_choice_options()[1] == "Take the Bad Trip")
				run_choice(1);
		}
		else if (page.contains_text("For some reason, you can't find your way back there."))
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("adventure.php?snarfblat=") && page.contains_text("Adventure Again"))
		{
			print("Non-combat, no choice", printColor);
			continue;
		}
		else if (page.contains_text("You break the bottle on the ground, and stomp it to powder"))
		{
			print("Agua de vida bottle ran out");
			return;
		}
		else if (page.contains_text("Remember that devilish folio you read?"))
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("Whuzzat now?")
			&& current.details.location == $location[The Nightmare Meatrealm])
		{
			if (!PromptToUnlock())
			{
				b.NoAccess = true;
				return;
			}
		}
		else if (page.contains_text("Set an Open Course for the Virgin Booty"))
		{
			visit_url("ocean.php?lon=59+lat=10");
			return;
		}
		else
		{
			print(page);
			abort("Unexpected non-combat");
		}
	}
}

void main()
{
        ReadSettings();
        WriteSettings(); // in case there are new properties

	if (PromptDebug && user_confirm("Do you want to run in debug mode?"))
		IsDebug = true;

	PopulateZoneBanishes();
	// todo: maximize combats (i.e. minimize non-combats)
	while (true)
	{
		TakeAllBounties();
		if (easy.key != "" && !easy.NoAccess)
		{
			DoBounty(easy);
		}
		else if (hard.key != "" && !hard.NoAccess)
		{
			DoBounty(hard);
		}
		else if (special.key != "" && !special.NoAccess)
		{
			DoBounty(special);
		}
		else
			break;
	}
}

