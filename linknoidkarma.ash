// This is a script for hardcore community service for my own character to farm karma.
// It probably won't work for any other characters unless you have at least the same
// perms and IotM, so you should probably find a more general script.

// Assumes:
// moonsign = The Vole
// class = Accordion Thief

boolean HaveItem(item i)
{
	return i.item_amount() > 0 || i.have_equipped();
}

void BuyCoinItemForEffect(coinmaster c, item i, effect e)
{
	if (e.have_effect() <= 0)
	{
		if (i.item_amount() == 0)
			buy(c, 1, i);
		use(1, i);
	}
}
void BuyItemForEffect(item i, effect e)
{
	if (e.have_effect() <= 0)
	{
		if (i.item_amount() == 0)
			buy(1, i);
		use(1, i);
	}
}
void UseItemForEffect(item i, effect e)
{
	if (e.have_effect() <= 0 && i.item_amount() > 0)
	{
		use(1, i);
	}
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
		print("No " + source + " available to make " + target);
		return false;
	}
	print("Using still to convert " + source + " to " + target);
	visit_url("shop.php?whichshop=still&action=buyitem&quantity=1&whichrow=" + row + "&pwd=" + my_hash());
	return true;
}
void CraftPotionForEffect(item pot, item ingredient, boolean isHighPotion, effect e)
{
	if (e.have_effect() > 0)
		return;
	if (pot.item_amount() > 0)
	{
		use(1, pot);
		return;
	}
	print ("ingredient amount = " + ingredient.item_amount());
	if (ingredient.item_amount() <= 0)
	{
		if (!UseStill(ingredient))
			return;
		if (ingredient.item_amount() <= 0)
			return;
	}

	item ingredient2;
	if (isHighPotion)
	{
		ingredient2 = $item[scrumdiddlyumptious solution];
		if (ingredient2.item_amount() == 0 && $item[scrumptious reagent].item_amount() > 0)
		{
			if ($item[delectable catalyst].item_amount() == 0 && my_meat() > 1000)
				buy(1, $item[delectable catalyst]);
			use(1, $item[delectable catalyst]);
		}
	}
	else
		ingredient2 = $item[scrumptious reagent];
	if (ingredient2.item_amount() > 0)
	{
		print("Trying to craft " + ingredient + " with " + ingredient2 + " to create " + pot);
		craft("cook", 1, ingredient, ingredient2);
	}
	if (pot.item_amount() > 0)
	{
		use(1, pot);
	}
}
boolean AmDrunk()
{
	int limit = inebriety_limit();
	// stooper can make it temporarily 15, but then we switch to another familiar and end up in a stupor
	if (my_familiar() == $familiar[Stooper])
		limit--;
	return my_inebriety() > limit;
}
void UseSkillForEffect(skill s, effect e)
{
	if (e.have_effect() <= 0)
	{
		use_skill(1, s);
	}
}
void ExecuteForEffect(string cmd, effect e)
{
	if (e.have_effect() <= 0)
	{
		cli_execute(cmd);
	}
}

void ChateauRest(int needMP)
{
	while (my_mp() < needMP && needMP - my_mp() < 50 && $item[psychokinetic energy blob].item_amount() >= 2)
		use(1, $item[psychokinetic energy blob]);

	if (my_mp() < needMP)
	{
		print("Resting in chateau to recover", "orange");
		waitq(5);
		visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
	}
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
		use_skill(1, $skill[The Ode to Booze]);
	}
	if ($effect[Ode to Booze].have_effect() < liverReq)
		return false;
	drink(1, i);
	return true;
}

boolean DrinkForEffect(item i, effect e, int liverReq)
{
	if (e.have_effect() > 0)
		return false;
	if (i.item_amount() == 0 && i == $item[Dinsey whinskey] && $item[FunFunds&trade;].item_amount() >= 2)
	{
		visit_url("place.php?whichplace=airport_stench&intro=1");
		buy(1, $item[Dinsey whinskey]);
	}
	return DrinkForTurns(i, liverReq);
}

boolean[31] completedQuests; // last quest is 30
boolean questStatusValid = false;
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

boolean[item] lowCandy = $items[
Angry Farmer candy,
Bit O' Ectoplasm,
BitterSweetTarts,
Cold Hots candy,
Comet Pop,
Daffy Taffy,
Elvish delight,
Gummi-Gnauga,
Mr. Mediocrebar,
Piddles,
Polka Pop,
Rock Pops,
Senior Mints,
Steal This Candy,
Sugar Cog,
Tasty Fun Good rice candy,
Wint-O-Fresh mint,
Yummy Tummy bean,
alphabet gum,
bazookafish bubble gum,
brown sugar cane,
candied kobold,
candy brain,
candy cane,
candy cigarette,
candy knife,
chocolate filthy lucre,
cotton candy bale,
cotton candy cone,
cotton candy pillow,
cotton candy pinch,
cotton candy plug,
cotton candy skoshe,
cotton candy smidgen,
crazy little Turkish delight,
delicious candy,
explosion-flavored chewing gum,
fudgecule,
green candy heart,
green gummi ingot,
gummi canary,
gummi salamander,
gummi snake,
honey stick,
honey-dipped locust,
jaba&ntilde;ero-flavored chewing gum,
lavender candy heart,
lime-and-chile-flavored chewing gum,
marzipan skull,
neutron lollipop,
orange candy heart,
pack of chewing gum,
pair of candy glasses,
pickle-flavored chewing gum,
pile of candy,
pink candy heart,
pixellated candy heart,
red gummi ingot,
sugar shard,
tamarind-flavored chewing gum,
that gum you like,
white candy heart,
white chocolate chips,
yellow candy heart,
yellow gummi ingot,
];

boolean[item] highCandy = $items[
8-bit banana,
Angry Farmer's Wife Candy,
Atomic Pop,
BOOterfinger,
Big Punk,
Bit O' Quail Spleen,
Blood 'n' Plenty,
Boss Drops,
CRIMBCOIDS mints,
Comet Drop,
Crimbo candied pecan,
Crimbo fudge,
Crimbo peppermint bark,
Drizzlers&trade; Black Licorice,
Everlasting Deckswabber,
Fudgie Roll,
Glo-Pop,
Good 'n' Slimy,
Gummi-DNA,
Gummy Brains,
Hersey&trade; SMOOCH,
Hot 'n' Scarys,
Lobos Mints,
Milk Studs,
Moonds,
Necbro wafers,
Now and Earlier,
Nuclear Blastball,
PEEZ dispenser,
Pain Dip,
PlexiPips,
Rattlin' Chains,
Shrubble Bubble,
Spechunky bar,
Sweet Sword,
Swizzler,
Take Eleven Bar,
Tallowcreme Halloween Pumpkin,
Wax Flask,
Whenchamacallit bar,
abandoned candy,
bag of W&Ws,
bag of many confections,
banana supersucker,
bananagate,
bananarama bangle,
black candy heart,
bone bons,
box of Dweebs,
breath mint,
candied bolts,
candied nuts,
candy UFOs,
candy cane candygram,
candy crayons,
candy kneecapping stick,
candy knuckles,
candy skeleton,
candy stake,
candycaine powder,
cane-mail pants,
cane-mail shirt,
children of the candy corn,
chocolate-covered caviar,
chocolate stolen accordion,
chocolate disco ball,
chocolate seal-clubbing club,
chocolate turtle totem,
chocolate pasta spoon,
chocolate saucepan,
delicious comfit?,
double-ice gum,
dubious peppermint,
elderly jawbreaker,
frostbite-flavored Hob-O,
fruitfilm,
fry-oil-flavored Hob-O,
fudge bunny,
fudge spork,
garbage-juice-flavored Hob-O,
giant candy cane,
giant green gummi bear,
giant green gummi ingot,
giant red gummi bear,
giant red gummi ingot,
giant yellow gummi bear,
giant yellow gummi ingot,
green drunki-bear,
gummi ammonite,
gummi belemnite,
gummi trilobite,
hoarded candy wad,
holly-flavored Hob-O,
irradiated candy cane,
jawbruiser,
kumquartz,
kumquartz ring,
kumquat supersucker,
licorice boa,
licorice garrote,
licorice root,
lime supersucker,
lump of Saccharine Maple sap,
nanite-infested candy cane,
nasty gum,
orange and black Crimboween candy,
pair of pearidot earrings,
peanut brittle shield,
pear supersucker,
pearidot,
peppermint crook,
peppermint parasol,
peppermint patty,
peppermint sprout,
peppermint twist,
piece of after eight,
powdered candy sushi set,
radio button candy,
red drunki-bear,
ribbon candy,
spiritual candy cane,
spooky sap,
sterno-flavored Hob-O,
stick of &quot;gum&quot;,
strawberry supersucker,
strawberry-flavored Hob-O,
strawberyl,
strawberyl necklace,
sugar chapeau,
sugar shank,
sugar sheet,
sugar shield,
sugar shillelagh,
sugar shirt,
sugar shorts,
sugar shotgun,
sugar sphere,
sugar-coated pine cone,
tourmalime,
tourmalime tourniquet,
violent pastilles,
vitachoconutriment capsule,
worst candy,
yam candy,
yellow drunki-bear,
];

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
	candyQuests[quest].buff = buff;
	candyQuests[quest].total = total;
	candyQuests[quest].quality = quality;
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
		foreach it2,count2 in candyCounts2
		{
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
	foreach it1,count1 in get_inventory()
	{
		if (highCandy contains it1)
			highCandyCount[it1] = it1.item_amount();
		else if (lowCandy contains it1)
			lowCandyCount[it1] = it1.item_amount();
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
	if (user_confirm("Do you wish to sweet synthesize " + plan.buff + " using candies "
		+ plan.candy1 + " (" + plan.candy1.item_amount() + ") / "
		+ plan.candy2 + " (" + plan.candy2.item_amount() + ") for price " + plan.price + "?"))
	{
		sweet_synthesis(plan.candy1, plan.candy2);
	}
	if (plan.buff.have_effect() <= 0)
		abort("Please cast sweet synthesis " + plan.buff + " and then resume execution");
}



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
	ghostShot = 0;

	if (get_property("_discoKnife") == "false")
	{
		int baseMuscle = my_basestat($stat[Muscle]);
		if (baseMuscle >= 40 && baseMuscle <= 59)
		{
			item candy = $item[candy knife];
			if (candy.item_amount() > 0)
				put_closet(candy.item_amount(), candy);
			use_skill($skill[That's Not a Knife]);
			if (candy.closet_amount() > 0)
				take_closet(candy.closet_amount(), candy);
		}
	}
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
	abort("Unexpected fight, expecting ghost");
	return "";
}

string Filter_DairyGoat(int round, monster mon, string page)
{
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
string Filter_Garbage(int round, monster mon, string page)
{
	if (mon != $monster[garbage tourist])
	{
		if (canExtract)
		{
			canExtract = false;
			return "skill " + $skill[Extract];
		}
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
	return "skill " + $skill[Disintegrate];
}

string Filter_Standard(int round, monster mon, string page)
{
	if (round > 20)
		abort("combat failed, please take over");
	if (my_hp() < my_maxhp() / 4)
		abort("combat failed, please take over");
	if (canCurse)
	{
		canCurse = false;
		return "skill " + $skill[Curse of Weaksauce];
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
	if ($item[cold jelly].item_amount() == 0
		&& my_familiar() == $familiar[Space Jellyfish])
	{
		return "skill " + $skill[Extract Jelly];
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
	return "attack";
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

string Filter_MeteorAndExit(int round, monster mon, string page)
{
	if ($skill[Meteor Shower].have_skill())
		return "skill " + $skill[Meteor Shower];
	abort("Meteor shower buff cast, please exit while in combat to preserve this buff until tomorrow (even free runaways clear this buff).");
	return "";
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
	if (mon.to_string().contains_text("Black Crayon"))
		return Filter_Standard(round, mon, page);
	if (my_familiar() == $familiar[Pair of Stomping Boots])
		return "run away";
	if (get_property("_kgbTranquilizerDartUses").to_int() < 3)
                return "skill " + $skill[KGB tranquilizer dart];
	if (get_property("_snokebombUsed").to_int() < 3 && my_mp() >= 50)
		return "skill " + $skill[Snokebomb];
	abort("Could not determine best way to escape combat.  We shouldn't run out like this.");
	return ""; // never get here
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
	if (get_property("_aguaDrops").to_int() < 3)
	{
		$familiar[Baby Sandworm].use_familiar();
	}
	else if (get_property("garbageFireProgress").to_int() >= 25)
	{
		$familiar[Garbage Fire].use_familiar();
	}
	else
	{
		$familiar[XO Skeleton].use_familiar();
	}
	//else if (get_property("optimisticCandleProgress").to_int() >= 25)
	//{
	//	$familiar[Optimistic Candle].use_familiar();
	//}
}

void SmashBarrels()
{
	string page = visit_url("barrel.php");
	matcher m = "\\<div\\s+class=\"?ex\"?(.*?)\\<a\\s+class=\"?spot\"? href=\"?choice.php\\?whichchoice=1099&[^>]*slot=(\\d*)\"?\\s*\\>.*?title=\"(.*?)\"".create_matcher(page);
	string[int] barrels;
	while (m.find())
	{
		boolean isMimic = m.group(1).contains_text("class=\"mimic\"");
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
			visit_url("choice.php?whichchoice=1099&pwd=" + my_hash() + "&option=1&slot=" + key);
		}
	}
}

void GearForCombat()
{
	$slot[hat].equip($item[FantasyRealm Mage's Hat]);
	$slot[back].equip($item[protonic accelerator pack]);
	if ($item[makeshift garbage shirt].HaveItem())
		$slot[shirt].equip($item[makeshift garbage shirt]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]); // for bashing
	$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	$slot[pants].equip($item[pantogram pants]); // make sure we're wearing pants first
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]); // for escaping
	$slot[acc2].equip($item[gold detective badge]);
	if ($item[LOV earrings].HaveItem())
		$slot[acc3].equip($item[LOV earrings]);
	else
		$slot[acc3].equip($item[your cowboy boots]);
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
			run_choice(1);
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
		// forest should now be unlocked, talk to untinker
		visit_url("place.php?whichplace=forestvillage&action=fv_untinker_quest");
		visit_url("place.php?whichplace=forestvillage&preaction=screwquest&action=fv_untinker_quest"); // accept quest
		visit_url("place.php?whichplace=knoll_friendly&action=dk_innabox"); // get screwdriver
		visit_url("place.php?whichplace=forestvillage&action=fv_untinker"); // turn in screwdriver
	}
}

void RunLOVTunnel()
{
	if (AmDrunk())
		return;
	if (get_property("loveTunnelAvailable") != "true" || get_property("_loveTunnelUsed") == "true")
		return;
	GearForCombat();
	ChooseFamiliar();
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


void RecoverHPorMP(boolean force)
{
	if ($effect[Beaten Up].have_effect() > 0) // should never get beaten up
		abort("Got beaten up, please debug");
	ChateauRest(20);
	boolean needHeal = my_hp() < (my_maxhp() / 2)
		|| (force && my_hp() < (my_maxhp() * .95));
	if (needHeal && my_mp() >= 20)
	{
		use_skill(1, $skill[Cannelloni Cocoon]);
		needHeal = false;
	}
	if (needHeal || my_mp() < 20)
	{
		ChateauRest(20);
	}
}

void FightTentacle()
{
	if (get_property("_eldritchTentacleFought") != "false")
		return;

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
		run_combat("Filter_Standard");
	}
	else
	{
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
			
		GearForCombat();
		RecoverHPorMP(false);
		ResetCombatState();
		string page = visit_url(loc.to_url());
		if (page.contains_text("choice.php"))
		{
			if (page.contains_text("Sure, I'll help"))
				run_choice(1);
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
		run_choice(2); // Use the hair gel
	}
}

void RunSnojo(boolean stopAfterSourceEssence)
{
	if (AmDrunk())
		return;
	while (true)
	{
		int freeFights = get_property("_snojoFreeFights").to_int();
		if (freeFights >= 10)
		{
			if ($effect[Hypnotized].have_effect() > 0)
				visit_url("clan_viplounge.php?action=hottub");
			return;
		}
		if (stopAfterSourceEssence) // haven't done first quest yet
		{
			// only run snojo until we have enough for our first extrude
			if ($item[browser cookie].item_amount() > 0
				|| my_fullness() > 4
				|| $item[source essence].item_amount() >= 10)
			{
				return;
			}
		}
		if (get_property("snojoSetting") == "NONE")
		{
			visit_url("place.php?whichplace=snojo&action=snojo_controller");
			run_choice(2); // myst, for +booze and resist hat
		}
		if (freeFights == 0 && stopAfterSourceEssence)
		{
			$familiar[Space Jellyfish].use_familiar();
		}
		else
		{
			ChooseFamiliar();
		}

		RecoverHPorMP(false);
		GearForCombat();

		ResetCombatState();
		visit_url($location[The X-32-F Combat Training Snowman].to_url());
		run_combat("Filter_Standard");
	}
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

void FaxDairyGoat()
{
	if (get_property("_photocopyUsed") != "false")
		return;
	GearForCombat();
	while (my_mp() < 160)
	{
		if (my_maxmp() < 160)
			abort("Not enough MP to duplicate/disintegrate");
		ChateauRest(160);
	}
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

	ResetCombatState();
	visit_url("inv_use.php?whichitem=" + $item[photocopied monster].to_int());
	run_combat("Filter_DairyGoat");
}

void YellowRayGarbage()
{
	if (AmDrunk())
		return;
	if ($effect[Everything Looks Yellow].have_effect() > 0)
	{
		print("Can't yellow ray while everything is still yellow");
		return;
	}
	if (my_maxmp() < 160)
		abort("Not enough MP to disintegrate");
	while (my_mp() < 160)
	{
		if ($item[psychokinetic energy blob].item_amount() > 0 && my_mp() > 60)
			use(1, $item[psychokinetic energy blob]);
		else
			ChateauRest(160);
	}
	GearForCombat();
	ResetCombatState();
	visit_url($location[Barf Mountain].to_url()); // first time in, need to skip past intro text
	string page = visit_url($location[Barf Mountain].to_url());
	if (page.contains_text("You're fighting"))
		run_combat("Filter_Garbage");
	if ($item[bag of park garbage].item_amount() > 0)
	{
		visit_url("place.php?whichplace=airport_stench&action=airport3_tunnels");
		run_choice(6);
	}
}

void FightWitchessRook()
{
	if (get_property("_witchessFights").to_int() != 0)
		return;

	GearForCombat();
	RecoverHPorMP(false);
	ResetCombatState();
	visit_url("campground.php?action=witchess", false);
	run_choice(1); // Examine the shrink ray
	visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1938", false);
	run_combat("Filter_Standard");
	if ($item[Greek fire].item_amount() > 0)
		use(1, $item[Greek fire]);
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
		use(1, $item[Greek fire]);

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
	if (GingerbreadTurns() > 10)
		return;

	if (GingerbreadTurns() == 0) // already ran turns
	{
        	string page = visit_url($location[Gingerbread Civic Center].to_url(), false);
	        run_choice(1); // clock choice, advance 5 rounds
	}
	while (GingerbreadTurns() < 9) // already ran turns
	{
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
		buy(1, $item[anti-anti-antidote]);
		use(1, $item[anti-anti-antidote]);
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
	while (my_fullness() <= 11)
	{
		if (my_fullness() % 4 == 0 && my_meat() >= 1000)
		{
			buy(1, $item[Mayodiol]);
			use(1, $item[Mayodiol]);
		}
		if ($effect[Got Milk].have_effect() < 4)
		{
			if ($item[glass of goat's milk].item_amount() > 0)
				cli_execute("create 1 milk of magnesium");

			if ($item[milk of magnesium].item_amount() > 0)
				use(1, $item[milk of magnesium]);
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
		print("Quest " + questNum + " will take " + turns + " turns");
		if (turns > maxTurns)
			abort("Could not complete quest " + questNum + " in " + maxTurns + " turns");
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
	for (int i = 0; i < 20; i++)
		run_choice(3); // Always take the 3rd option, the last time #3 should be "I'm done for now"
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
	string page = visit_url("place.php?whichplace=chateau&action=chateau_painting");
	if (page.contains_text("You're fighting"))
	{
		page = run_combat("Filter_Standard");
	}
}

void FightWanderers()
{
	boolean hasWanderer = true;
	while (hasWanderer)
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
		if (!hasWanderer)
			return;

		ChooseFamiliar();

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

void MakeStenchJelly()
{
	if (get_property("_spaceJellyfishDrops") > 1 && get_property("_macrometeoriteUses").to_int() >= 10)
		return;
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

void DoSleep()
{
	ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);

	cli_execute("Briefcase enchantment adventures");
	for (int i = 0; i < 3; i++)
	{
		if (get_property("_kgbClicksUsed").to_int() < 3)
			cli_execute("Briefcase identify");
	}
	if (get_property("_witchessBuff") != "true")
		cli_execute("witchess");
	$familiar[Stooper].use_familiar();
	while (my_inebriety() < 15)
	{
		if ($item[splendid martini].item_amount() > 0)
			DrinkForTurns($item[splendid martini], 1);
		else if ($item[Sacramento wine].item_amount() > 0)
			DrinkForTurns($item[Sacramento wine], 1);
	}
	if (my_inebriety() == 15)
	{
		if ($effect[Ode to Booze].have_effect() < 10)
			use_skill(1, $skill[The Ode to Booze]);
	
		drink(1, $item[bucket of wine]);
	}
        while (get_property("timesRested").to_int() < total_free_rests())
	{
		cli_execute("cast * summon resolutions");
		ChateauRest(my_maxmp());
	}
	cli_execute("cast * summon resolutions");
	$slot[hat].equip($item[Hairpiece On Fire]);
	if ($item[shoe ad T-shirt].HaveItem())
		$slot[shirt].equip($item[shoe ad T-shirt]);
	$slot[back].equip($item[burning cape]);
	$slot[acc2].equip($item[tiny plastic golden gundam]);
	$slot[acc3].equip($item[Draftsman's driving gloves]);
	$familiar[Trick-or-Treating Tot].use_familiar();
	$slot[familiar].equip($item[li'l unicorn costume]);
	if (!user_confirm("Are you ready for final combat of the day? (this will log out off in the middle of combat)"))
		return;
	if (get_property("_clanFortuneConsultUses").to_int() < 3)
		if (!user_confirm("Do you want to sleep without consulting the fortune teller?"))
			return;
	if ($item[makeshift garbage shirt].HaveItem())
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
		run_choice(1); // put away garbage shirt so it starts fresh tomorrow
	}

	// end day with time spinner fight after drunk and cast meteor shower, and then logout
        string pageText = visit_url("inv_use.php?whichitem=9104");
	pageText = visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=1195&option=3");
	if (pageText.contains_text("You're fighting"))
	{
		run_combat("Filter_MeteorAndExit");
	}

}

void DoQuest1()
{
	if (!completedQuests[1])
	{
		BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);

		if ($item[LOV Elixir #3].item_amount() > 0)
			use(1, $item[LOV Elixir #3]);

		if ($effect[Strongly Motivated].have_effect() == 0)
			cli_execute("cheat Strength");


		SweetSynthesisEffect(2); // muscle
		SweetSynthesisEffect(1); // HP
		ChallengeGodLobster(1, 3);
		ChallengeGodLobster(2, 3);
		ChallengeGodLobster(3, 3);

		$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
		$slot[back].equip($item[protonic accelerator pack]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[pantogram pants]);
		$slot[acc3].equip($item[Brutal Brogues]);
		CurePoison();
		DoQuest(1); // Bonus HP

	}
}
void DoQuest2()
{
	if (!completedQuests[2])
	{
		BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
		BuyItemForEffect($item[blood of the Wereseal], $effect[Temporary Lycanthropy]);
		UseItemForEffect($item[Flaskfull of Hollow], $effect[Merry Smithsness]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);

		$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		if ($item[shoe ad T-shirt].HaveItem())
			$slot[shirt].equip($item[shoe ad T-shirt]);
		if ($item[cosmetic football].HaveItem())
			$slot[off-hand].equip($item[cosmetic football]);
		$slot[pants].equip($item[pantogram pants]);
		$slot[acc3].equip($item[Brutal Brogues]);
		if ($item[abstraction: action].item_amount() > 0 && $effect[Action].have_effect() <= 0)
			chew(1, $item[abstraction: action]);
		if ($item[Mer-kin strongjuice].item_amount() > 0 && $effect[Juiced Out].have_effect() <= 0)
			use(1, $item[Mer-kin strongjuice]);

		CraftPotionForEffect($item[Ferrigno's Elixir of Power], $item[kiwi], true, $effect[Incredibly Hulking]);
		CraftPotionForEffect($item[philter of phorce], $item[lemon], false, $effect[Phorcefullness]);

		CastGiantGrowth(true);
		if ($effect[Slippery Oiliness].have_effect() <= 0)
		{
			// This one wish can save at least 23 turns for muscle quest, and at least 14 turns
			//  from myst quest.  A 37 turn saving is worth 1 wish.
			cli_execute("genie wish to be Slippery Oiliness");
		}
		CurePoison();
		DoQuest(2, 10); // Bonus Muscle
	}
}
void DoQuest3()
{
	if (!completedQuests[3])
	{
		BuyItemForEffect($item[glittery mascara], $effect[Glittering Eyelashes]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);
		UseSkillForEffect($skill[Quiet Judgement], $effect[Quiet Judgement]);

		if ($effect[Thought].have_effect() == 0 && $item[abstraction: thought].item_amount() > 0)
			chew(1, $item[abstraction: thought]);

		$slot[hat].equip($item[FantasyRealm Mage's Hat]);
		$slot[pants].equip($item[Vicar's Tutu]);
		if ($item[dorky glasses].item_amount() > 0)
			$slot[acc2].equip($item[dorky glasses]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		if ($item[training legwarmers].item_amount() > 0)
			$slot[acc3].equip($item[training legwarmers]);
		SweetSynthesisEffect(3); // myst

		CraftPotionForEffect($item[Hawking's Elixir of Brilliance], $item[tangerine], true, $effect[On the Shoulders of Giants]);
		CraftPotionForEffect($item[ointment of the occult], $item[grapefruit], false, $effect[Mystically Oiled]);

		CastGiantGrowth(false);
		CurePoison();
		DoQuest(3, 17); // Bonus Myst
	}
}

void DoQuest4()
{
	if (!completedQuests[4])
	{
		BuyItemForEffect($item[hair spray], $effect[Butt-Rock Hair]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);
		UseSkillForEffect($skill[Quiet Desperation], $effect[Quiet Desperation]);

		if ($effect[Sensation].have_effect() == 0 && $item[abstraction: sensation].item_amount() > 0)
			chew(1, $item[abstraction: sensation]);

		UseItemForEffect($item[runproof mascara], $effect[Unrunnable Face]);

		use($item[rhinestone].item_amount(), $item[rhinestone]);

		if (get_property("_lyleFavored") != "true")
			visit_url("place.php?whichplace=monorail&action=monorail_lyle"); // favored by lyle
		if (get_property("telescopeLookedHigh") != "true")
			cli_execute("telescope high");
		if (get_property("_spacegateVaccine") != "true")
		{
			visit_url("place.php?whichplace=spacegate&action=sg_vaccinator");
			run_choice(2); // spacegate broad-spectrum vaccine
		}

		visit_url("showplayer.php?who=2807390");
		visit_url("showplayer.php?action=crossthestreams&pwd=" + my_hash() + "&who=2807390"); // cross the streams

		SweetSynthesisEffect(4); // moxie
		$slot[hat].equip($item[Hairpiece on Fire]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[Vicar's Tutu]);
		if ($item[noticeable pumps].HaveItem())
			$slot[acc2].equip($item[noticeable pumps]);
		$slot[acc3].equip($item[your cowboy boots]);

		CraftPotionForEffect($item[Connery's Elixir of Audacity], $item[cocktail onion], true, $effect[Cock of the Walk]);
		CraftPotionForEffect($item[serum of sarcasm], $item[olive], false, $effect[Superhuman Sarcasm]);

		CastGiantGrowth(true);
		CurePoison();
		if ($effect[A Contender].have_effect() <= 0)
		{
//			abort("check for A Contender");
			cli_execute("genie wish to be A Contender");
		}
		DoQuest(4, 3); // Bonus Moxie
	}
}
void DoQuest5()
{
	if (!completedQuests[5])
	{
		$slot[weapon].equip($item[rope]);
		$slot[acc3].equip($item[Brutal brogues]);

		UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);
		UseSkillForEffect($skill[Leash of Linguini], $effect[Leash of Linguini]);
		ExecuteForEffect("pool 1", $effect[Billiards Belligerence]);

		if ($effect[Puzzle Champ].have_effect() == 0
			 && !get_property("_witchessBuff").to_boolean())
		{
			cli_execute("witchess");
		}
		$familiar[Baby Sandworm].use_familiar(); // should be the heaviest familiar at this point
		$slot[familiar].equip($item[amulet coin]); // add 10 pounds
		DoQuest(5, 41); // familiar weight
		ChooseFamiliar();
	}
}
void DoQuest6()
{
	if (!completedQuests[6])
	{
		FightGhost();

		//BuyCoinItemForEffect($coinmaster[Game Shoppe], $item[wasabi marble soda], $effect[Wasabi With You]);
		//BuyItemForEffect($item[wasabi marble soda], $effect[Wasabi With You]);
		if ($effect[Wasabi With You].have_effect() <= 0)
		{
			if ($item[wasabi marble soda].item_amount() == 0 && $item[Ye Wizard's Shack snack voucher].item_amount() > 0)
			{
				visit_url("gamestore.php?action=buysnack&whichsnack=5019");
			}
			cli_execute("cast * summon resolutions");
			use(1, $item[wasabi marble soda]);
		}

		DoQuest(6, 57); // weapon damage, not many options to improve
	}
}
void DoQuest7()
{
	if (!completedQuests[7])
	{
		FightGhost();
		UseItemForEffect($item[LOV Elixir #6], $effect[The Magic of LOV]);
		DoQuest(7, 58); // (+spell damage)
	}
}
void DoQuest8()
{
	if (!completedQuests[8])
	{
		BuyCoinItemForEffect($coinmaster[Precinct Materiel Division], $item[shoe gum], $effect[Gummed Shoes]);
		UseSkillForEffect($skill[The Sonata of Sneakiness], $effect[The Sonata of Sneakiness]);
		UseSkillForEffect($skill[Smooth Movement], $effect[Smooth Movements]);
		
		ExecuteForEffect("swim sprints", $effect[Silent Running]);

		$slot[back].equip($item[protonic accelerator pack]);
		$slot[pants].equip($item[pantogram pants]);

		// try to intergnat "Rational Thought"
		DoQuest(8, 39); // (-combat)
	}
}
void DoQuest9()
{
	if (!completedQuests[9])
	{
		if ($item[Dinsey whinskey].item_amount() == 0
			&& $item[FunFunds&trade;].item_amount() >= 2
			&& $effect[The Dinsey Spirit].have_effect() == 0)
		{
			buy($coinmaster[The Dinsey Company Store], 1, $item[Dinsey whinskey]);
		}
		DrinkForEffect($item[sacramento wine], $effect[Sacr&eacute; Mental], 1);
		DrinkForEffect($item[Dinsey whinskey], $effect[The Dinsey Spirit], 2);
		BuyItemForEffect($item[pair of candy glasses], $effect[Sucrose-Colored Glasses]);

		if (get_property("_clanFortuneBuffUsed") == "false")
			cli_execute("fortune buff hagnk");
		ExecuteForEffect("terminal enhance items.enh", $effect[items.enh]);
		UseItemForEffect($item[resolution: be happier], $effect[Joyful Resolve]);
		ExecuteForEffect("pool 3", $effect[Hustlin']);
		UseSkillForEffect($skill[Fat Leon's Phat Loot Lyric], $effect[Fat Leon's Phat Loot Lyric]);

		$familiar[trick-or-treating tot].use_familiar();
		$slot[hat].equip($item[Hairpiece On Fire]);
		$slot[familiar].equip($item[li'l ninja costume]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		if ($item[fancy party pants].HaveItem())
			$slot[pants].equip($item[fancy party pants]);
		else
			$slot[pants].equip($item[Vicar's Tutu]);
		$slot[acc2].equip($item[gold detective badge]);
		$slot[acc3].equip($item[your cowboy boots]);
		SweetSynthesisEffect(9); // item drop
		// todo: run LOV tunnel, grab earrings, eye surgery (choice 3), chocolate
		if (get_property("_steelyEyedSquintUsed") != "true")
		{
			ChateauRest(100);
			use_skill(1, $skill[Steely-Eyed Squint]);
		}
		DoQuest(9, 14); // (item/booze drops)
	}
}
void DoQuest10()
{
	if (!completedQuests[10])
	{
		$familiar[Trick-or-Treating Tot].use_familiar();
		if (!HaveItem($item[li'l candy corn costume]) && my_meat() >= 1000)
			buy(1, $item[li'l candy corn costume]);
		if ($item[li'l candy corn costume].item_amount() > 0)
			$slot[familiar].equip($item[li'l candy corn costume]);
		if (get_property("spacegateVaccine") != "true")
			cli_execute("spacegate vaccine 1"); // +resist
		$slot[acc3].equip($item[LOV earrings]);
		if ($item[burning newspaper].item_amount() > 0 && !$item[burning cape].HaveItem())
			cli_execute("create burning cape");
		$slot[back].equip($item[burning cape]);

		if (get_property("_mayoTankSoaked") != "true")
			visit_url("shop.php?action=bacta&whichshop=mayoclinic");
		UseSkillForEffect($skill[Elemental Saucesphere], $effect[Elemental Saucesphere]);
		UseSkillForEffect($skill[Astral Shell], $effect[Astral Shell]);
		cli_execute("Briefcase enchantment hot");
		$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
		// pale horse?  500 meat to switch
		SweetSynthesisEffect(10); // hot resist
		DoQuest(10, 20); // (+hot resist)
	}
}
void DoQuest11()
{
	if (!completedQuests[11])
	{
		DoQuest(11, 60); // unreducable
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

void InitCharacter()
{
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
	if ($item[astral six-pack].item_amount() > 0)
		use(1, $item[astral six-pack]);

	while (get_property("_genieWishesUsed").to_int() < 3)
		cli_execute("genie wish for more wishes");

	visit_url("place.php?whichplace=chateau&action=chateau_desk2");

	if (my_meat() == 0)
	{
		cli_execute("numberology 14");
		cli_execute("numberology 14");
		cli_execute("numberology 14");
		autosell(3 * 14, $item[moxie weed]);
		buy(1, $item[li'l unicorn costume]);
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

	if (!HaveItem($item[Shakespeare's Sister's Accordion]))
	{
		use_skill(2, $skill[Summon Smithsness]);
		visit_url("campground.php?action=bookshelf&preaction=combinecliparts&clip1=04&clip2=04&clip3=04&pwd");
		create(1, $item[Shakespeare's Sister's Accordion]);
		if ($item[maiden wig].item_amount() == 0)
			buy(1, $item[maiden wig]);
		create(1, $item[Hairpiece on Fire]);
	}

	if (!HaveItem($item[makeshift garbage shirt]))
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
		run_choice(5); // garbage shirt
	}

	
	if (!HaveItem($item[pantogram pants]))
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9573");
		visit_url("choice.php?whichchoice=1270&pwd&option=1&m=1&e=1&s1=-1,0&s2=-1,0&s3=-1,0");
	}

	if (!HaveItem($item[FantasyRealm Mage's Hat]))
	{
		visit_url("place.php?whichplace=realm_fantasy&action=fr_initcenter");
		visit_url("choice.php?pwd&whichchoice=1280&option=2"); // mage's hat
	}

	$slot[hat].equip($item[FantasyRealm Mage's Hat]);
	$slot[shirt].equip($item[makeshift garbage shirt]);
	$slot[back].equip($item[protonic accelerator pack]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	$slot[pants].equip($item[pantogram pants]);
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].equip($item[gold detective badge]);
	$slot[acc3].equip($item[your cowboy boots]);


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

	if ($effect[Big].have_effect() == 0)
		use_skill(1, $skill[Get Big]);
	// add more skills here as they are hardcore permed

	if (get_property("_pottedTeaTreeUsed") != "true")
		cli_execute("teatree royal");
	ChooseEducates("extract", "duplicate");
	if (get_property("sourceTerminalEnquiry") != "stats.enq")
		cli_execute("terminal enquiry stats.enq");
	if ($effect[substats.enh].have_effect() <= 0)
		cli_execute("terminal enhance substats.enh");
	if (get_property("_horsery") == "")
		cli_execute("horsery dark");
	if (get_property("boomBoxSong") != "Total Eclipse of Your Meat")
		cli_execute("boombox meat");
	if ($item[green mana].item_amount() == 0)
	{
		MakeGreenMana();
		MakeGreenMana();
	}
}

void Day1()
{
	UnlockGuildAndForest();
	RunLOVTunnel();

	RunSnojo(true);

	if ($item[Source essence].item_amount() >= 10 && get_property("_sourceTerminalExtrudes").to_int() == 0)
		cli_execute("terminal extrude food");

	FightGhost();

	FaxDairyGoat();
	EatBrowserCookie();

	DoQuest11();
	DoQuest6();

	ExecuteForEffect("terminal enhance substats.enh", $effect[substats.enh]);
	UseItemForEffect($item[resolution: be smarter], $effect[Brilliant Resolve]);
	UseItemForEffect($item[resolution: be sexier], $effect[Irresistible Resolve]);
	UseItemForEffect($item[resolution: be stronger], $effect[Strong Resolve]);
	UseSkillForEffect($skill[Inscrutable Gaze], $effect[Inscrutable Gaze]);
	FightWitchessRook();

	RunGingerbread();
	if ($item[a ten-percent Bonus].item_amount() > 0)
	{
		SweetSynthesisEffect(11); // bonus moxie exp
		GetNeverendingPartyBuff();
		use(1, $item[a ten-percent Bonus]);
		cli_execute("cheat lovers");
	}

	ExecuteBastilleBattalion("BARBERSHOP", "DRAFTSMAN", "CANNON"); // moxie stats, +8 adventures, muscle buff

	SpacegateMoxieStats(); // gain 1850 moxie stats
	ChallengeGodLobster(1, 1);
	if ($item[God Lobster's Scepter].item_amount() > 0)
		$slot[familiar].equip($item[God Lobster's Scepter]);
	ChallengeGodLobster(2, 2);

	RunNeverendingParty(10);

	RunSnojo(false);
	FightChateauPainting();

	FightWitchessBishop(1, true);
	FightGhost();
	FightWitchessBishop(2, false);
	FightWitchessBishop(3, false);
	FightWitchessBishop(4, false);
	FightMachineTunnels();
	ChallengeGodLobster(3, 3);
	FightTentacle();
	YellowRayGarbage();
	// any other fights to handle before burning buffs to quest 7?

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
			ChateauRest(50);
			use_skill(1, $skill[The Ode to Booze]);
		}
		if ($item[cold jelly].item_amount() > 0)
			chew(1, $item[cold jelly]);
		drink(1, $item[hacked gibson]); // for some reason, doesn't drink the second one with drink(2), maybe the cold jelly caused issues?
		drink(1, $item[hacked gibson]);
		drink(2, $item[Sacramento wine]);
	}
	while (my_spleen_use() < 10 && $item[agua de vida].item_amount() > 0)
		chew(1, $item[agua de vida]);

	DoQuest7();
	

	UseSkillForEffect($skill[Inscrutable Gaze], $effect[Inscrutable Gaze]);
	FightWanderers();
	FightGhost();

	DoQuest10();

	UseSkillForEffect($skill[Inscrutable Gaze], $effect[Inscrutable Gaze]);
	// fight garbage tourist for 3 dinsey bucks, spending turns in case of fertilizer drops
	FightWanderers();

	if (get_property("_clanFortuneBuffUsed") == "false")
		cli_execute("fortune buff susie");

	if (my_inebriety() <= 11)
	{
		item perfect = CraftPerfectDrink();
		if (perfect != $item[none])
			DrinkForTurns(perfect, 3);
	}
	while (my_inebriety() < 14)
	{
		if ($item[Sacramento wine].item_amount() > 0)
			DrinkForTurns($item[Sacramento wine], 1);
	}

	while (my_spleen_use() < 12 && $item[agua de vida].item_amount() > 0)
		chew(1, $item[agua de vida]);
	DoQuest8();

	FightWanderers();
	FightGhost();
	MakeStenchJelly(); // this should trigger creating the last Poke fertilizer


	DoSleep();
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
	if (!HaveItem($item[Vicar's Tutu]))
	{
		use_skill(1, $skill[Summon Smithsness]);
		if ($item[frilly skirt].item_amount() == 0)
			buy(1, $item[frilly skirt]);
		create(1, $item[Vicar's Tutu]);
	}
	if (get_property("tomeSummons").to_int() == 2)
	{
		visit_url("campground.php?action=bookshelf&preaction=combinecliparts&clip1=03&clip2=03&clip3=03&pwd");
		$familiar[Cornbeefadon].use_familiar();
		use(1, $item[box of Familiar Jacks]);
	}
	if (!HaveItem($item[makeshift garbage shirt]))
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
		run_choice(5); // garbage shirt
	}
	if (!HaveItem($item[rope]))
	{
		cli_execute("cheat rope");
	}
	ExecuteBastilleBattalion("BABAR", "BRUTALIST", "CANNON"); // muscle stats, +8 familiar weight, muscle buff


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

	DoQuest5();

	$slot[hat].equip($item[FantasyRealm Mage's Hat]);
	$slot[shirt].equip($item[makeshift garbage shirt]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].equip($item[gold detective badge]);
	$slot[acc3].equip($item[your cowboy boots]);
	$slot[back].equip($item[protonic accelerator pack]);
	$slot[pants].equip($item[pantogram pants]);

	DailySummons();
	FightWitchessRook();
	FightWitchessBishop(1, true);
	RunSnojo(false);
	RunGingerbread();
	FaxNinja();
	FightWitchessBishop(2, false);
	FightWitchessBishop(3, false);



	DoQuest1(); // HP
	DoQuest4(); // Mox
	DoQuest2(); // Str
	DoQuest3(); // Myst

	//Day2DrinkForTurns(); // with recent changes, day 2 drinking no longer needed

	DoQuest9(); // Items

	DoQuest(30); // (Final Service)
}


void main(int DayNum1or2)
{
	if (my_daycount() != DayNum1or2)
	{
		if (!user_confirm("You entered day " + DayNum1or2 + " but actual day is " + my_daycount() + ".  Are you sure you wish to proceed?"))
			return;
	}
	UpdateQuestStatus();
	if (DayNum1or2 == 1)
	{
		InitCharacter();
		Day1();
	}
	else if (DayNum1or2 == 2)
	{
		Day2();
	}
}
