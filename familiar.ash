// Put this in the relay folder to make it show more information on the
// familiar page


string Format(string page, string fam, string title, string prop, int max)
{
	string replacement = fam + " ";
	if (fam != "Comma Chameleon" && get_property("commaFamiliar") == fam)
	{
		page = Format(page, "Comma Chameleon", title, prop, max);
	}
	string current = get_property(prop);
	if (max > 0 && current.to_int() < max)
		current = "<font color=red>" + current + "</font>";
	replacement += "<b>(" + title + "=" + current;
	if (max > 0)
		replacement += "/" + max;
	replacement += ")</b> ";
	return page.replace_string(fam + " ", replacement);
}

void main()
{
	string page = visit_url();
	page = Format(page, "Pocket Professor", "lectures", "_pocketProfessorLectures", 0);
	page = Format(page, "Cat Burglar", "heists", "catBurglarBankHeists", 0);
	page = Format(page, "Baby Sandworm", "agua", "_aguaDrops", 5);
	page = Format(page, "Machine Elf", "tunnels", "_machineTunnelsAdv", 5);
	page = Format(page, "Mini-Hipster", "fights", "_hipsterAdv", 7);
	page = Format(page, "Artistic Goth Kid", "fights", "_hipsterAdv", 7);
	page = Format(page, "Llama Lama", "gongs", "_gongDrops", 5);
	page = Format(page, "Fist Turkey", "booze", "_turkeyBooze", 5);
	page = Format(page, "Stomping Boots", "stomps", "_bootStomps", 7);
	page = Format(page, "Li'l Xenomorph", "transponder", "_transponderDrops", 5);
	page = Format(page, "Obtuse Angel", "copies", "_badlyRomanticArrows", 1);
	page = Format(page, "Trick-or-Treating Tot", "candy", "_hoardedCandyDropsCrown", 3);
	page = Format(page, "Optimistic Candle", "wax", "_optimisticCandleDropsCrown", 3);
	page = Format(page, "Garbage Fire", "newspapers", "_garbageFireDropsCrown", 3);
	page = Format(page, "Grimstone Golem", "bjorn", "_grimstoneMaskDropsCrown", 1);
	page = Format(page, "Grimstone Golem", "adv", "_grimstoneMaskDrops", 1);
	page = Format(page, "God Lobster", "fights", "_godLobsterFights", 3);
	page = Format(page, "Space Jellyfish", "extracts", "_spaceJellyfishDrops", 0);
	page = Format(page, "Gelatinous Cubeling", "drops", "cubelingProgress", 3);
	page = Format(page, "Puck Man", "pills", "_powerPillDrops", 0);
	page = Format(page, "Steam-Powered Cheerleader", "steam", "_cheerleaderSteam", 200);
	page = Format(page, "Nanorhino", "charge", "_nanorhinoCharge", 100);
	page = Format(page, "Reagnimated Gnome", "adventures", "_gnomeAdv", 0);
	page = Format(page, "Rockin' Robin", "egg", "rockinRobinProgress", 30);
	page = Format(page, "Red-Nosed Snapper", get_property("redSnapperPhylum"), "redSnapperProgress", 11);
	page = Format(page, "Happy Medium", "siphons", "_mediumSiphons", 0);
	page = Format(page, "Nosy Nose", "sniff", "nosyNoseMonster", 0);
	page = page.replace_string("Comma Chameleon", "Comma Chameleon, " + get_property("commaFamiliar") + " ");
	write(page);
}
