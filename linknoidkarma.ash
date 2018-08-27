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

void ChateauRest(int needMP)
{
	if (my_mp() < needMP)
	{
		print("Resting in chateau to recover", "orange");
		waitq(5);
		visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");
	}
}

void InitCharacter()
{
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
		buy(1, $item[frilly skirt]);
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
	}
	if (!HaveItem($item[Vicar's Tutu]))
	{
		create(1, $item[Vicar's Tutu]);
	}

	if (!HaveItem($item[makeshift garbage shirt]))
	{
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
		run_choice(5); // garbage shirt
	}

	
	if (!HaveItem($item[pantogram pants]))
	{
		//use(1, $item[portable pantogram]);
		// this is broken
		visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9573");
		visit_url("choice.php?whichchoice=1270&pwd&option=1&m=1&e=1&s1=-1,0&s2=-1,0&s3=-1,0");
	}

	if (!HaveItem($item[FantasyRealm Mage's Hat]))
	{
		visit_url("place.php?whichplace=realm_fantasy&action=fr_initcenter");
		visit_url("choice.php?pwd&whichchoice=1280&option=2"); // mage's hat
	}

	$slot[shirt].equip($item[makeshift garbage shirt]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[off-hand].equip($item[KoL Con 13 snowglobe]);
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].equip($item[gold detective badge]);
	$slot[acc3].equip($item[your cowboy boots]);
	$slot[back].equip($item[protonic accelerator pack]);
	$slot[pants].equip($item[pantogram pants]);
	$slot[hat].equip($item[FantasyRealm Mage's Hat]);

	if (get_property("_lookingGlass") != "true")
		visit_url("clan_viplounge.php?action=lookingglass&whichfloor=2"); // grab DRINK ME

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

	ChateauRest(20);

	use_skill(1, $skill[Summon Crimbo Candy]);
	use_skill(1, $skill[Advanced Saucecrafting]);
	use_skill(1, $skill[Advanced Cocktailcrafting]);
	use_skill(1, $skill[Acquire Rhinestones]);
	use_skill(1, $skill[Summon Alice's Army Cards]);
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
	if (get_property("_detectiveCasesCompleted").to_int() < 3)
		cli_execute("Detective Solver.ash");
	if (get_property("_kgbLeftDrawerUsed") != "true" || get_property("_kgbRightDrawerUsed") != "true")
		cli_execute("Briefcase.ash drawers");
	if (get_property("_kgbDispenserUses").to_int() < 3)
		cli_execute("Briefcase.ash splendid");
	if (get_property("_horsery") == "")
		cli_execute("try; horsery dark");
	if (get_property("boomBoxSong") != "Total Eclipse of Your Meat")
		cli_execute("boombox meat");
	if ($item[green mana].item_amount() == 0)
		cli_execute("cheat forest");

	// dark horse? or pale horse?

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
	boolean needHeal = my_hp() < (my_maxhp() / 2)
		|| (force && my_hp() < (my_maxhp() * .95));
	if (needHeal && my_mp() >= 40)
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
		if (freeFights == 0)
		{
			$familiar[Space Jellyfish].use_familiar();
		}
		else
			ChooseFamiliar();

		RecoverHPorMP(false);

		ResetCombatState();
		visit_url($location[The X-32-F Combat Training Snowman].to_url());
		run_combat("Filter_Standard");
	}
}

void FightGhost(location loc)
{
	RecoverHPorMP(true);
	ChooseFamiliar();
	ResetCombatState();
	visit_url(loc.to_url());
	run_combat("Filter_Ghost");
}

void FaxDairyGoat()
{
	if (get_property("_photocopyUsed") != "false")
		return;
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
			if ($item[photocopied monster].item_amount() == 0)
			{
				abort("Fax failed");
				return;
			}
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
		visit_url("campground.php?action=witchess", false);
		run_choice(1); // Examine the shrink ray
		visit_url("choice.php?option=1&pwd=" + my_hash() + "&whichchoice=1182&piece=1938", false);
		run_combat("Filter_Standard");
	}
}

void RunGingerbread()
{
	if (get_property("_gingerbreadCityTurns").to_int() > 10)
		return;

	if (get_property("_gingerbreadCityTurns").to_int() == 0) // already ran turns
	{
        	string page = visit_url($location[Gingerbread Civic Center].to_url(), false);
	        run_choice(1); // clock choice, advance 5 rounds
	}
int turns = get_property("_gingerbreadCityTurns").to_int();
abort("Debug: turns = " + turns);
	while (get_property("_gingerbreadCityTurns").to_int() < 9) // already ran turns
	{
		ChateauRest(40); // need 30 to shattering punch, an extra 10 to be safe
		ResetCombatState();
        	string page = visit_url($location[Gingerbread Upscale Retail District].to_url(), false);
		run_combat("Filter_Gingerbread");
	}
	if (get_property("_gingerbreadCityTurns").to_int() == 9)
	{
        	string page = visit_url($location[Gingerbread Train Station].to_url(), false);
	        run_choice(1); // dig for candy
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
	while (my_fullness() < 8 || (my_turncount() > 60 && my_fullness() < 15))
	{
		if (my_fullness() % 4 == 0 && my_meat() >= 1000)
		{
			buy(1, $item[Mayodiol]);
			use(1, $item[Mayodiol]);
		}
		if ($item[milk of magnesium].item_amount() > 0
			&& $effect[Got Milk].have_effect() < 4)
		{
			if ($item[glass of goat's milk].item_amount() > 0)
			{
				cli_execute("create 1 milk of magnesium");
			}
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

boolean[11] completedQuests;
void DoQuest(int questNum)
{
	if (completedQuests[questNum - 1])
		return;
	string page = visit_url("council.php");
	if (!page.contains_text("community services so far"))
	{
		abort("TODO: need special handling for initial page load: " + page);
	}
	for (int i = 0; i < 11; i++)
	{
		if (!page.contains_text("name=option value=" + i))
			completedQuests[i] = true;
	}
	if (completedQuests[questNum - 1])
	{
		print("Already completed quest " + questNum);
	}
	else
	{
		run_choice(questNum);
	}
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
	if ($item[Draftsman's driving gloves].item_amount() > 0
		|| $item[Nouveau nosering].item_amount() > 0
		|| $item[Brutal brogues].item_amount() > 0)
	{
		return;
	}
	visit_url("inv_use.php?pwd=" + my_hash() + "&which=f0&whichitem=9928");
	SetBastilleBattalionMode(1, target1);
	SetBastilleBattalionMode(2, target2);
	SetBastilleBattalionMode(3, target3);

	visit_url("choice.php?whichchoice=1313&option=5&pwd=" +my_hash());
	for (int i = 0; i < 15; i++)
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

	if (get_property("ghostLocation") == "The Overgrown Lot") // fight the ghost now, because it will vanish with 60 turn quest
		FightGhost($location[The Overgrown Lot]);

	FaxDairyGoat();
	EatBrowserCookie();

	DoQuest(11); // unreducable
// todo: Check for ghost here;
	DoQuest(6); // weapon damage, not many options to improve

	if (get_property("_clanFortuneBuffUsed") == "false")
		cli_execute("fortune buff susie");
	if ($effect[substats.enh].have_effect() <= 0)
		cli_execute("terminal enhance substats.enh");

	FightWitchessRook();
	if ($item[Greek fire].item_amount() > 0)
		use(1, $item[Greek fire]);

	RunGingerbread(); // todo: this is broken, needs debugging

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

	if (get_property("ghostLocation") == "The Haunted Conservatory") // fight the ghost now, because it will vanish with 60 turn quest
		FightGhost($location[The Overgrown Lot]);
	RunSnojo(false);

	// robo chateau painting
	// if enough spleen items, switch to machine elf for snojo
	// obtuse angel and digitize witchess bishop
	// fight remaining bishops with machine elf
	// machine elf tunnels
	// god lobster exp
	// do quest 7 (+spell damage)

	// maybe get a perfume-soaked bandana from Garbage Barges while grabbing stench jelly (if lucky)
	

	// craft burning cape from newspaper for rollover, hot resist
	// rainbow vaccine
	// l'il candy corn uniform
	// sweet synth +9hot resist
	// LOV earrings
	// mayosoak
	// pale horse
	// orphan candy corn
	// do quest 9 (+hot resist)

	// fight garbage tourist for 3 dinsey bucks, spending turns in case of fertilizer drops

	// use remaining rests to summon resolutions
	// end day with time spinner fight after drunk and cast meteor shower, giant grown, and then logout
}

void Day2()
{
	if ($item[li'l candy corn costume].item_amount() == 0 && my_meat() >= 1000)
		buy(1, $item[li'l candy corn costume]);
	// Dark horse
	// equip garbage shirt
	// cheat Rope
	// Bastille battalion: babar (muscle exp), cannon (muscle bonus), brutalist (+8 familiar weight)
	// do familiar weight quest
	// pantogram (same

	// perfect freeze
	// fight witchess knight, and potion up
	// clear snojo
	// fax ninja snowman

	// summon smithness A Light that Never Goes Out
	// summon smithsness craft "Meat Tenderizer is Murder"
	// summon smithness craft Saucepanic

	// FantasyRealm Warrior's Helm
	// gingerbread city candy
	// sweet synth +300% HP, +300% muscle
	// ben-gal cream
	// Get Big
	// flaskfull of hollow
	// cheat muscle buff
	// challenge god lobster x3 experience
	// do quest 1 (bonus HP)
	// do quest 2 (bonus muscle)

	// hairspray
	// rhinestones
	// favored by lyle
	// telescope buff
	// spacegate broad-spectrum vaccine
	// cross the streams
	// sweet synth +300% moxie
	// fight witchess bishop and cast giant growth
	// do quest 4 (bonus moxie)

	// glittery mascara
	// sweet synth +300% myst
	// do quest 5 (bonus myst)
	// do quest 5 (bonus myst)

	// ode to booze
	// beer barrel polka
	// drink 6 astral pilsner (should be level 11)
	// drink 1 sacramento wine
	// buy/drink dinsey whinskey
	// drink 1 splendid martini
	// sweet synth +150% item drop
	// fortune buff hagnk
	// terminal.enh
	// resolution: be happier (if available)
	// steely eyed squint
	// orphan wear ninja costume
	// play pool (3)
	// run LOV tunnel, grab earrings, eye surgery (choice 3), chocolate
	// do quest 7 (item/booze drops)

	// buy/use shoe gum
	// swim sprints
	// sonata of sneakiness
	// pantogram pants
	// do quest 8 (-combat)

}

void main(int DayNum1or2)
{
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
