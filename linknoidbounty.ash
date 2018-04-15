
effect beatenUp = "Beaten Up".to_effect();
familiar nosyNose = "Nosy Nose".to_familiar();

int mallPriceLimitPerBanish = 5000;
string printColor = "orange";

boolean IsDebug = true;
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
	Banisher[monster] banishes;
	float[monster] nonBounty;
	item accessItem;
	effect accessEffect;
	int accessTurns;
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
	
	
	return result;
}


void StringToBountyDetails(BountyDetails[string] coll, string difficulty, int requiredCount, string itemName)
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
		if (result.source != mon)
			result.nonBounty[mon] = freq;
	}

	coll[result.key] = result;
}
void StringToBountyDetails(BountyDetails[string] coll, string difficulty, int requiredCount, string itemName,
	string accessItem, int accessTurns, string accessEffect)
{
	StringToBountyDetails(coll, difficulty, requiredCount, itemName);
	coll[itemName].accessItem = accessItem.to_item();
	coll[itemName].accessTurns = accessTurns;
	coll[itemName].accessEffect = accessEffect.to_effect();
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
	StringToBountyDetails(result, "Special", 9 , "purple butt"         , "agua de vida bottle",                           10, "");
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

string TryBanish(monster mon)
{
	if (current.NonBounty[mon] < 0.1) // wandering monsters or rare enounters don't matter
	{
		print("Non-standard monster, no banish", printColor);
		return "";
	}
	current.banishes[mon] = emptyBanisher;
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
		current.banishes[mon] = bestBanish;
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
		ResetCombatState();
		string page = visit_url(current.details.location.to_url());
		if (page.contains_text("choice.php"))
			abort("To do, choice.php not yet handled");
		run_combat("Filter_Combat");
	}
}

void main()
{
	// todo: maximize combats (i.e. minimize non-combats)
	TakeAllBounties();
	while (easy.key != "" || hard.key != "" || special.key != "")
	{

		if (easy.key != "")
		{
			DoBounty(easy);
		}
		if (hard.key != "")
		{
			DoBounty(hard);
		}
		if (special.key != "")
		{
			DoBounty(special);
		}
		TakeAllBounties();
	}
}
