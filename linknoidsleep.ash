familiar stooper = $familiar[Stooper];
familiar orphan = $familiar[Trick-or-Treating Tot];
item sleepCostume = $item[li'l unicorn costume];
skill odeToBooze = $skill[The Ode to Booze];
effect odeToBoozeEffect = $effect[Ode to Booze];
item elemCaip = $item[Elemental caipiroska];
item wineBucket = $item[Bucket of wine];
item pinkyRing = $item[mafia pinky ring];
item oven = $item[warbear induction oven];
item thanks7 = $item[baked stuffing];
item thanks8 = $item[thanksgiving turkey];
item thanks9 = $item[warm gravy];
item cashew = $item[cashew];
item cornucopia = $item[cornucopia];

string printColor = "orange";

void OdeUp(int size)
{
	if (odeToBoozeEffect.have_effect() >= size)
		return;
	if (odeToBooze.have_skill())
	{
		use_skill(1, odeToBooze);
		if (odeToBoozeEffect.have_effect() < size)
		{
			abort("Need to acquire OdeToBooze before drinking");
		}
	}
}

// todo:
// check free kills first
// lynyrd snares

void main()
{
	if (!user_confirm("Ready for overdrinking?"))
		return;
	if (stooper.have_familiar() && my_familiar() != stooper)
	{
		stooper.use_familiar();
	}
	int remainingDrunk = inebriety_limit() - my_inebriety();
	if (get_property("barrelShrineUnlocked") == "true"
		&& my_class().to_string() == "Accordion Thief"
		&& get_property("_barrelPrayer") != "true") 
	{
		cli_execute("barrelprayer buff");
	}
	OdeUp(remainingDrunk + 10);
	while (inebriety_limit() > my_inebriety())
	{
		drink(1, elemCaip);
	}
	if (pinkyRing.item_amount() > 0 && !pinkyRing.have_equipped())
	{
		pinkyRing.to_slot().equip(pinkyRing);
	}
	drink(1, wineBucket);
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
	while (get_property("_chocolatesUsed").to_int() < 2)
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
	if (get_property("_sourceTerminalExtrudes").to_int() < 3)
	{
		cli_execute("terminal extrude food.ext");
		cli_execute("terminal extrude booze.ext");
		cli_execute("terminal extrude booze.ext");
	}
	if ($item[raffle ticket].item_amount() == 0)
	{
		cli_execute("raffle 1");
	}
	if (get_property("hasDetectiveSchool") == "true"
		&& get_property("_detectiveCasesCompleted").to_int() < 3)
	{
		cli_execute("Detective Solver.ash");
	}
}

