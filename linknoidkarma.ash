// This is a script for hardcore community service for my own character to farm karma.
// It probably won't work for any other characters unless you have at least the same
// perms and IotM, so you should probably find a more general script.

// Assumes:
// moonsign = The Vole
// class = Accordion Thief

void InitCharacter()
{
	use_skill(1, $skill[Perfect Freeze]);
	use_skill(1, $skill[Pastamastery]);

	if ($item[gold detective badge].item_amount() == 0)
		visit_url("place.php?whichplace=town_wrong&action=townwrong_precinct");

	if ($item[your cowboy boots].item_amount() == 0)
		visit_url("place.php?whichplace=town_right&action=townright_ltt");

	if ($item[Bastille Battalion control rig].item_amount() == 0)
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
		buy(1, $item[li'l candy corn costume]);
		buy(1, $item[frilly skirt]);
	}

	if ($item[turtle totem].item_amount() == 0
		|| $item[saucepan].item_amount() == 0)
	{
		buy(13, $item[chewing gum on a string]);
		use(13, $item[chewing gum on a string]);
	}


	if ($item[Shakespeare's Sister's Accordion].item_amount() == 0
		&& !$item[Shakespeare's Sister's Accordion].have_equipped())
	{
		use_skill(2, $skill[Summon Smithsness]);
		create(1, $item[Shakespeare's Sister's Accordion]);
	}
	if ($item[Vicar's Tutu].item_amount() == 0
		&& !$item[Vicar's Tutu].have_equipped())
	{
		create(1, $item[Vicar's Tutu]);
	}

	visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9690");
	run_choice(5); // garbage shirt

	//use(1, $item[portable pantogram]);
	// this is broken
	//visit_url("inv_use.php?pwd=" + my_hash() + "&which=3&whichitem=9573");

	//visit_url("choice.php?whichchoice=1270&pwd&option=1&m=1&e=1&s1=-1%2C0&s2=-1%2C0&s3=-1%2C0");

	visit_url("place.php?whichplace=realm_fantasy&action=fr_initcenter");
	visit_url("choice.php?pwd&whichchoice=1280&option=1"); // warrior hat

	$slot[shirt].equip($item[makeshift garbage shirt]);
	$slot[weapon].equip($item[Shakespeare's Sister's Accordion]);
	$slot[offhand].equip($item[KoL Con 13 snowglobe]);
	$slot[acc1].equip($item[Kremlin's Greatest Briefcase]);
	$slot[acc2].equip($item[gold detective badge]);
	$slot[acc3].equip($item[your cowboy boots]);
	$slot[back].equip($item[protonic accelerator pack]);
	$slot[pants].equip($item[pantogram pants]);
	$slot[hat].equip($item[FantasyRealm Warrior's Helm]);

	visit_url("clan_viplounge.php?action=lookingglass&whichfloor=2");

	if (my_mp() < 20)
		visit_url("place.php?whichplace=chateau&action=chateau_restlabelfree");

	use_skill(1, $skill[Advanced Saucecrafting]);
	use_skill(1, $skill[Advanced Cocktailcrafting]);
	use_skill(1, $skill[Acquire Rhinestones]);
	use_skill(1, $skill[Summon Alice's Army Cards]);
	use_skill(1, $skill[Empathy of the Newt]);
	use_skill(1, $skill[Get Big]);
	// add more skills here as they are hardcore permed

	//cli_execute("try; teatree voraci"); // to eat browser cookie 4 times
	cli_execute("terminal educate extract.edu");
	cli_execute("terminal educate duplicate.edu");
	cli_execute("terminal enquiry stats.enq");
//	cli_execute("terminal enhance substats.enh");
	cli_execute("Detective Solver.ash");
	cli_execute("Briefcase.ash drawers");
	cli_execute("Briefcase.ash splendid");
	// dark horse? or pale horse?
}

void FreeFights()
{
	// todo:
	// substats.enh
	// baby sandworm familiar
	// start with LOV tunnel, take the earrings, lovebotamy, chocolate
	// fight snojo (myst) until 10 extracts (1 round with jellyfish for cold jelly, then sandworm)
	// fight ghost
	// extrude 1 browser cookie and eat
	// do 60 adventure quest
	// then 1 witches rook for potion
	// run 3 shattering punches in gingerbread to get candy
	// +50% moxie from sweet synthesis
	// use a ten-percent bonus
	// fax dairy goat, duplicate and maybe yellow ray
	// time spin 3, 1 with mayodiol
	// execute Bastille Battallion with barbershop (moxie), draftsman (+8 adventures) cannon (muscle)
	// BAAAAAM in spacegate
	// god lobster equipment then buff, save 1
	// fight ghost in conservatory
	// robo chateau painting
	// if enough spleen items, switch to machine elf for snojo
	// obtuse angel and digitize witchess bishop
	// fight remaining bishops with machine elf
	// machine elf tunnels
	// god lobster exp

	// wish to be A contender
	// maximize moxie
	// do moxie quest
	
	// disgeist + familiar weight
	//

	// cheerleader
	// item drop quest
}

void main(int DayNum1or2)
{
	if (DayNum1or2 == 1)
	{
		InitCharacter();
	}
	else if (DayNum1or2 == 2)
	{
	}
}
