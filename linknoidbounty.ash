
effect beatenUp = $effect[Beaten Up];
familiar nosyNose = $familiar[Nosy Nose];
item bait = $item[Monster Bait];

int mallPriceLimitPerBanish = 5000;
string printColor = "orange";

boolean IsDebug = false;
void PrintDebug(string text)
{
	if (IsDebug)
		print(text, printColor);
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
	if (SkillName != "")
	{
		name = SkillName;
		result.AsSkill = SkillName.to_skill();
		result.SkillProvider = ItemName.to_item();
	}
	else if (ItemName != "")
	{
		name = ItemName;
		result.AsItem = ItemName.to_item();
		result.CostPerUse = result.AsItem.mall_price();
	}
	else
		abort("Must specify Skill or Item");
	result.UsesPerDayCount = UsesPerDay;
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
	for (int i = 0; i < banishes.count(); i += 3)
	{
		monster mon = banishes[i].to_monster();
		string src = banishes[i + 1];
		int turnBanished = banishes[i + 2].to_int();
		Banisher ban = result[src];
		ban.UntilTurn = turnBanished + ban.TurnsBanishedPerUse;
		ban.CurrentlyBanished = mon;
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
	StringToBountyDetails(result, "Easy"   , 7 , "important bat file");
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
	StringToBountyDetails(result, "Special", 13, "pixellated ashes"    , "jar of psychoses (The Crackpot Mystic)",        -1, "");
	StringToBountyDetails(result, "Special", 10, "empty rum bottle"    , "one-day ticket to Dinseylandfill",              -1, "");
	StringToBountyDetails(result, "Special", 8 , "frozen clipboard"    , "one-day ticket to The Glaciest",                -1, "");
	StringToBountyDetails(result, "Special", 8 , "glittery skate key"  , "tiny bottle of absinthe",                       10, "Absinthe-Minded");
	StringToBountyDetails(result, "Special", 9 , "grizzled stubble"    , "transporter transponder",                       30, "Transpondent");
	StringToBountyDetails(result, "Special", 10, "hardened lava glob"  , "one-day ticket to That 70s Volcano",            -1, "");
	StringToBountyDetails(result, "Special", 6 , "hickory daiquiri"    , "devilish folio",                                30, "Dis Abled");
	StringToBountyDetails(result, "Special", 8 , "greasy string"       , "jar of psychoses (The Meatsmith)",              -1, "");
	StringToBountyDetails(result, "Special", 13, "pickle chip"         , "one-day ticket to Spring Break Beach",          -1, "");
	StringToBountyDetails(result, "Special", 8 , "country guano"       , "astral mushroom",                               5, "Half-Astral");
	StringToBountyDetails(result, "Special", 10, "wig powder"          , "\"DRINK ME\" potion",                           20, "Down the Rabbit Hole");
	StringToBountyDetails(result, "Special", 6 , "pop art banana peel" , "llama lama gong",                               12, "Shape of...Mole!");
	StringToBountyDetails(result, "Special", 9 , "purple butt"         , "empty agua de vida bottle",                           10, "");
	StringToBountyDetails(result, "Special", 13, "unlucky claw"        , "jar of psychoses (The Suspicious-Looking Guy)", -1, "");
	StringToBountyDetails(result, "Special", 10, "vivisected hair"     , "one-day ticket to Conspiracy Island",           -1, "");
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

void PrepareBanishers()
{
	foreach key,b in AllBanishers
	{
		int usesRemain = -1;
		if (b.UsedTodayCountProperty != "")
		{
			if (b.UsesPerDayCount == 1)
				usesRemain = get_property(b.UsedTodayCountProperty).to_boolean() ? 0 : 1;
			else
				usesRemain = b.UsesPerDayCount - get_property(b.UsedTodayCountProperty).to_int();
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
		if (ban.AsItem != "none".to_item())
		{
			if (ban.AsItem.item_amount() == 0)
			{
				PrintDebug("not enough items");
				continue;
			}
		}
		else if (ban.AsSkill != "none".to_skill())
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
		}
		if (BanisherUsed(ban))
		{
			PrintDebug("Banisher already in use in this zone");
			continue;
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

void ResetCombatState()
{
	whiffed = false;
}

string Filter_Combat(int round, monster mon, string page)
{
	if (mon != current.source)
	{
		string result = TryBanish(mon);
		if (result != "")
		{
			print("Banishing with " + result, printColor);
			return result;
		}
	}
	else
	{
		if (!whiffed && my_familiar() == nosyNose)
		{
			whiffed = true;
			return "skill Get a Good Whiff of This Guy";
		}
	}
	return "";
}

void DoBounty(BountyDetails b)
{
	print("Attempting bounty at " + b.details.location, printColor);
	current = b;
        string propertyName = ("current" + b.difficulty + "BountyItem");
	while (GetBounty(get_property(propertyName)).foundCount < b.requiredCount)
	{
		if (my_adventures() == 0)
			abort("Out of adventures");
		if (beatenUp.have_effect() > 0)
			abort("Got beaten up, please correct before continuing.");
		if (nosyNose.have_familiar() && my_familiar() != nosyNose)
			nosyNose.use_familiar();
		PrepareBanishers();
		if (bait.item_amount() > 0 && !bait.have_equipped())
			"acc3".to_slot().equip(bait);
		ResetCombatState();
		string page = visit_url(current.details.location.to_url());
		if (page.contains_text("choice.php"))
		{
			if (page.contains_text("Typographical Clutter"))
			{
				run_choice(3);
			}
			else if (page.contains_text("Lights Out in the Wine Cellar"))
			{
				run_choice(1);
				run_choice(1);
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
		else if (page.contains_text("That isn't a place you can go.")
			|| page.contains_text("You shouldn't be here.")
			|| page.contains_text("Whuzzat now?"))
		{
			print("Cannot visit " + current.details.location + ", skipping bounty", printColor);
			current.NoAccess = true;
			return;
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
		else
		{
			print(page);
			abort("Unexpected non-combat");
		}
	}
}

void main()
{
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

