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
void UseSkillForEffect(skill s, effect e)
{
	if (e.have_effect() <= 0)
	{
		use_skill(1, s);
	}
}

void ChateauRest(int needMP)
{
	if (my_mp() < needMP)
	{
		print("Resting in chateau to recover", "orange");
		waitq(5);
		visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
	}
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

	DailySummons();

	if ($effect[Empathy].have_effect() == 0)
		use_skill(1, $skill[Empathy of the Newt]);
	if ($effect[Big].have_effect() == 0)
		use_skill(1, $skill[Get Big]);
	// add more skills here as they are hardcore permed

	//cli_execute("try; teatree voraci"); // to eat browser cookie 4 times
	string educates = get_property("sourceTerminalEducate1") + get_property("sourceTerminalEducate2");
	if (!educates.contains_text("extract") || !educates.contains_text("duplicate"))
	{
		cli_execute("terminal educate extract.edu");
		cli_execute("terminal educate duplicate.edu");
	}
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

boolean canCurse;
boolean canMortar;
boolean canBash;
boolean canSingAlong;
boolean canExtract;
boolean canTimeSpinner;
boolean canMicroMeteorite;
boolean canLoveGnats;
boolean canDuplicate;
int ghostShot;

void ResetCombatState()
{
	canCurse = true;
	canMortar = false;
	canBash = true;
	canSingAlong = true;
	canExtract = true;
	canTimeSpinner = true;
	canMicroMeteorite = true;
	canLoveGnats = true;
	canDuplicate = true;
	ghostShot = 0;
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
	return "skill Disintegrate";
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


string Filter_GiantGrowth(int round, monster mon, string page)
{
	if ($effect[Giant Growth].have_effect() == 0 && $item[green mana].item_amount() > 0)
		return "skill " + $skill[Giant Growth];
	if (mon == $monster[The Icewoman])
		return Filter_Ghost(round, mon, page);
	if (mon.to_string().contains_text("itchess"))
		return Filter_Standard(round, mon, page);
	return "skill " + $skill[KGB tranquilizer dart];
}
void RunLOVTunnel()
{
	if (get_property("loveTunnelAvailable") != "true" || get_property("_loveTunnelUsed") == "true")
		return;
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
	else if (get_property("optimisticCandleProgress").to_int() >= 25)
	{
		$familiar[Optimistic Candle].use_familiar();
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
		use_skill(1, $skill[Cannelloni Cocoon]);
		needHeal = false;
	}
	if (needHeal || my_mp() < 20)
	{
		ChateauRest(20);
	}
}

void RunSnojo(boolean stopAfterSourceEssence)
{
	while (true)
	{
		int freeFights = get_property("_snojoFreeFights").to_int();
		if (freeFights >= 10)
			return;
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

		ResetCombatState();
		visit_url($location[The X-32-F Combat Training Snowman].to_url());
		run_combat("Filter_Standard");
	}
}

void FightGhost(location loc)
{
	if (get_property("ghostLocation") != loc.to_string())
		return;
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
	$slot[acc3].equip($item[your cowboy boots]);
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

void FightWitchessRook()
{
	if (get_property("_witchessFights").to_int() == 0)
	{
		RecoverHPorMP(false);
		ResetCombatState();
		visit_url("campground.php?action=witchess", false);
		run_choice(1); // Examine the shrink ray
		visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1938", false);
		run_combat("Filter_Standard");
		if ($item[Greek fire].item_amount() > 0)
			use(1, $item[Greek fire]);
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
	if (GingerbreadTurns() > 10)
		return;

	if (GingerbreadTurns() == 0) // already ran turns
	{
        	string page = visit_url($location[Gingerbread Civic Center].to_url(), false);
	        run_choice(1); // clock choice, advance 5 rounds
	}
	while (GingerbreadTurns() < 9) // already ran turns
	{
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

void CastGiantGrowth() // can only be cast in combat, with free kill or runaway
{
	if ($item[green mana].item_amount() == 0)
	{
		MakeGreenMana();
		if ($item[green mana].item_amount() == 0)
			return;
	}
	if ($effect[Giant Growth].have_effect() > 0)
		return;
	
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]); // for bashing
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]); // for escaping
	RecoverHPorMP(false);
	ResetCombatState();

	visit_url($location[The Haunted Kitchen].to_url());
	run_combat("Filter_GiantGrowth");
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

boolean[31] completedQuests; // last quest is 30
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
	return page;
}
void DoQuest(int questNum)
{
	print("Requesting to do quest " + questNum);
	if (completedQuests[questNum])
		return;
	UpdateQuestStatus(visit_url("council.php"));
	if (completedQuests[questNum])
	{
		print("Already completed quest " + questNum);
	}
	else
	{
		run_choice(questNum);
		UpdateQuestStatus(visit_url("council.php"));
		if (!completedQuests[questNum])
			abort("Failed to complete quest " + questNum);
	}
	waitq(2);
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
	if (get_property("_WorkedOnYourTan") == "true" || get_property("_spacegateTurnsLeft") < 15)
		return;
	string page = visit_url("place.php?whichplace=spacegate&action=sg_Terminal");
	if (page.contains_text("(a valid set of coordinates is 7 letters)"))
	{
		page = visit_url("choice.php?whichchoice=1235&pwd=" + my_hash() + "&option=2&text=BAAAAAM");
		if (page.contains_text("high gravity"))
		{
			page = visit_url("place.php?whichplace=spacegate&action=sg_requisition");
			if (page.contains_text("exo-servo leg braces"))
				run_choice(2);
		}
	}
	try
	{
		if ($item[exo-servo leg braces].item_amount() > 0)
			$slot[pants].equip($item[exo-servo leg braces]);
		if ($item[geological sample kit].item_amount() == 0
			&& !$item[geological sample kit].have_equipped())
		{
			page = visit_url("place.php?whichplace=spacegate&action=sg_requisition");
			run_choice(6);
		}
		if ($item[geological sample kit].item_amount() > 0)
			$slot[pants].equip($item[geological sample kit]);

		for (int i = 0; i < 5; i++) // I think this should always be in the first 5 turns
		{
			page = visit_url("adventure.php?snarfblat=494");
			if (page.contains_text("Paradise Under a Strange Sun"))
			{
				run_choice(1); // Work on your tan
				set_property("_WorkedOnYourTan", "true");
				return;
			}
			else
				abort("Todo: fix spacegate run for this page: " + page);
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
	string page = visit_url("main.php?fightgodlobster=1");
	ResetCombatState();
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
}

void Day1()
{
	RunLOVTunnel();
	$slot[acc3].equip($item[LOV earrings]);

	RunSnojo(true);

	if ($item[Source essence].item_amount() >= 10 && get_property("_sourceTerminalExtrudes").to_int() == 0)
		cli_execute("terminal extrude food");

	FightGhost($location[The Overgrown Lot]);

	FaxDairyGoat();
	EatBrowserCookie();

	if (!completedQuests[11])
	{
		DoQuest(11); // unreducable
	}
	if (!completedQuests[6])
	{
		FightGhost($location[The Haunted Conservatory]);
		DoQuest(6); // weapon damage, not many options to improve
	}

	if ($effect[substats.enh].have_effect() <= 0)
		cli_execute("terminal enhance substats.enh");

	FightWitchessRook();

	RunGingerbread();

	// todo:
	// +50% moxie from sweet synthesis

	if ($effect[Synthesis: Style].have_effect() == 0 && $item[a ten-percent Bonus].item_amount() > 0)
		abort("Please manually cast Synthesis: Style (+50 moxie gains) then run againg to continue");
	if ($item[a ten-percent Bonus].item_amount() > 0)
		use(1, $item[a ten-percent Bonus]);

	ExecuteBastilleBattalion("BARBERSHOP", "DRAFTSMAN", "CANNON"); // moxie stats, +8 adventures, muscle buff

	SpacegateMoxieStats(); // gain 1850 moxie stats
	ChallengeGodLobster(1, 1);
	if ($item[God Lobster's Scepter].item_amount() > 0)
		$slot[familiar].equip($item[God Lobster's Scepter]);
	ChallengeGodLobster(2, 2);

	RunSnojo(false);
	FightGhost($location[Madness Bakery]);

	// robo chateau painting
	// if enough spleen items, switch to machine elf for snojo
	// obtuse angel and digitize witchess bishop
	// fight remaining bishops with machine elf
	// machine elf tunnels
	// god lobster exp

	//if (!completedQuests[7])
	//{
	//	if ($item[LOV Elixir #6].item_amount() > 0 && $effect[The Magic of LOV].have_effect() == 0)
	//		use(1, $item[LOV Elixir #6]);
	//	DoQuest(7); // (+spell damage)
	//}

	// maybe get a perfume-soaked bandana from Garbage Barges while grabbing stench jelly (if lucky)
	

	if (!HaveItem($item[li'l candy corn costume]) && my_meat() >= 1000)
		buy(1, $item[li'l candy corn costume]);
	// craft burning cape from newspaper for rollover, hot resist
	// rainbow vaccine
	// l'il candy corn uniform
	// sweet synth +9hot resist
	// LOV earrings
	// mayosoak
	// pale horse
	// orphan candy corn
	// do quest 9 (+hot resist)
	//if (get_property("_clanFortuneBuffUsed") == "false")
	//	cli_execute("fortune buff ???");

	// fight garbage tourist for 3 dinsey bucks, spending turns in case of fertilizer drops

	// use remaining rests to summon resolutions
	// end day with time spinner fight after drunk and cast meteor shower, giant grown, and then logout
}

void Day2()
{
	if (get_property("_horsery") == "")
		cli_execute("try; horsery dark");
	if (!HaveItem($item[A Light that Never Goes Out]))
	{
		if ($item[third-hand lantern].item_amount() == 0)
		{
			buy(1, $item[third-hand lantern]);
		}
		use_skill(3, $skill[Summon Smithsness]);
		create(1, $item[A Light that Never Goes Out]);
		if ($item[frilly skirt].item_amount() == 0)
			buy(1, $item[frilly skirt]);
		create(1, $item[Vicar's Tutu]);
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

	if (!completedQuests[5])
	{
		$slot[weapon].equip($item[rope]);
		$slot[acc3].equip($item[Brutal brogues]);

		UseSkillForEffect($skill[Empathy of the Newt], $effect[Empathy]);

		if ($effect[Puzzle Champ].have_effect() == 0
			 && !get_property("_witchessBuff").to_boolean())
		{
			cli_execute("witchess");
		}
		$familiar[Baby Sandworm].use_familiar(); // should be the heaviest familiar at this point
			
		DoQuest(5); // familiar weight
		ChooseFamiliar();
	}

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
	RunSnojo(false);
	RunGingerbread();
	FaxNinja();



	if (!completedQuests[1] || !completedQuests[2])
	{
		BuyItemForEffect($item[Ben-Gal&trade; Balm], $effect[Go Get 'Em, Tiger!]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);

	}
	if (!completedQuests[1])
	{

		if ($item[LOV Elixir #3].item_amount() > 0)
			use(1, $item[LOV Elixir #3]);

		if ($effect[Strongly Motivated].have_effect() == 0)
			cli_execute("cheat Strength");


		if ($effect[Synthesis: Hardy].have_effect() == 0
			|| $effect[Synthesis: Strong].have_effect() == 0)
		{
			abort("Please manually cast Synthesis: Hardy/Strong and then resume execution");
		}
		ChallengeGodLobster(1, 3);
		ChallengeGodLobster(2, 3);
		ChallengeGodLobster(3, 3);

		$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
		$slot[back].equip($item[protonic accelerator pack]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[pantogram pants]);
		$slot[acc3].equip($item[Brutal Brogues]);
		DoQuest(1); // Bonus HP

	}
	if (!completedQuests[2])
	{
		CastGiantGrowth();
		$slot[hat].equip($item[FantasyRealm Warrior's Helm]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[Vicar's Tutu]);
		$slot[acc3].equip($item[Brutal Brogues]);
	// flaskfull of hollow
		DoQuest(2); // Bonus Muscle
	}

	if (!completedQuests[4])
	{
		BuyItemForEffect($item[hair spray], $effect[Butt-Rock Hair]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);

		if ($effect[Sensation].have_effect() == 0 && $item[abstraction: sensation].item_amount() > 0)
			chew(1, $item[abstraction: sensation]);

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

		if ($effect[Synthesis: Cool].have_effect() == 0)
		{
			abort("Please manually cast Synthesis: Cool and then resume execution");
		}
		$slot[hat].equip($item[Hairpiece on Fire]);
		$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[Vicar's Tutu]);
		$slot[acc3].equip($item[your cowboy boots]);
		CastGiantGrowth();
abort("Checkpoint"); // todo: check enough adventures available
		DoQuest(4); // Bonus Moxie
	}

	if (!completedQuests[3])
	{
		BuyItemForEffect($item[glittery mascara], $effect[Glittering Eyelashes]);
		UseSkillForEffect($skill[Get Big], $effect[Big]);
		if ($effect[Thought].have_effect() == 0 && $item[abstraction: thought].item_amount() > 0)
			chew(1, $item[abstraction: thought]);

		$slot[hat].equip($item[FantasyRealm Mage's Hat]);
		$slot[pants].equip($item[Vicar's Tutu]);
		if ($item[training legwarmers].item_amount() > 0)
			$slot[acc3].equip($item[training legwarmers]);
		if ($effect[Synthesis: Smart].have_effect() == 0)
		{
			abort("Please manually cast Synthesis: Smart and then resume execution");
		}
		CastGiantGrowth();
abort("Checkbpoint");
		DoQuest(3); // Bonus Myst
	}

	if (!completedQuests[9])
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
			drink($item[astral pilsner].item_amount(), $item[astral pilsner]);
			drink(1, $item[sacramento wine]);
			if ($item[Dinsey whinskey].item_amount() == 0 && $item[Fun Funds].item_amount() >= 2)
				buy(1, $item[Dinsey whinskey]);
			if ($item[Dinsey whinskey].item_amount() > 0)
				drink(1, $item[Dinsey whinskey]);
			while (my_inebriety() < 10) // use up remaining barrel prayer buff
				drink(1, $item[splendid martini]);
		}
		if (get_property("_clanFortuneBuffUsed") == "false")
			cli_execute("fortune buff hagnk");
		if ($effect[items.enh].have_effect() <= 0)
			cli_execute("terminal enhance items.enh");
		if ($effect[Joyful Resolve].have_effect() <= 0 && $item[resolution: be happier].item_amount() > 0)
			use(1, $item[resolution: be happier]);
		if ($effect[Hustlin'].have_effect() <= 0)
			cli_execute("pool 3");

		$familiar[trick-or-treating tot].use_familiar();
		$slot[familiar].equip($item[li'l ninja costume]);
		$slot[off-hand].equip($item[A Light that Never Goes Out]);
		$slot[pants].equip($item[Vicar's Tutu]);
		if ($effect[Synthesis: Collection].have_effect() == 0)
		{
			abort("Please manually cast Synthesis: Collection (+150% item) and then resume execution");
		}
		// todo: run LOV tunnel, grab earrings, eye surgery (choice 3), chocolate
		if (get_property("_steelyEyedSquintUsed") != "true")
		{
			ChateauRest(100);
			use_skill(1, $skill[Steely-Eyed Squint]);
		}
abort("Checkbpoint");
		DoQuest(9); // (item/booze drops)
	}

	if (!completedQuests[8])
	{
		BuyCoinItemForEffect($coinmaster[precinct], $item[shoe gum], $effect[Gummed Shoes]);
		UseSkillForEffect($skill[The Sonata of Sneakiness], $effect[The Sonata of Sneakiness]);
		UseSkillForEffect($skill[Smooth Movement], $effect[Smooth Movements]);
		
		if ($effect[Silent Running].have_effect() <= 0)
			cli_execute("swim sprints");

		$slot[pants].equip($item[pantogram pants]);

		// try to intergnat "Rational Thought"
abort("Checkbpoint");
		DoQuest(8); // (-combat)
	}
abort("Checkbpoint");
	DoQuest(30); // (Final Service)
}


void main(int DayNum1or2)
{
	if (my_daycount() != DayNum1or2)
	{
		if (!user_confirm("You entered day " + DayNum1or2 + " but actual day is " + my_daycount() + ".  Are you sure you wish to proceed?"))
			return;
	}
	string page = visit_url("council.php");
	UpdateQuestStatus(page);
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
