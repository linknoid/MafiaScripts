
// This goes in the relay directory to add alt text to the mushroom garden

void main()
{
	string page = visit_url();
	string searchText = "mushgarden.gif";
	int ix = page.index_of(searchText);
//print(" found search text " + ix);
	if (ix > 0)
	{
		ix += searchText.length();
		string first = page.substring(0, ix);
		string second = page.substring(ix);
		int days = get_property("mushroomGardenCropLevel").to_int();
		int fights = get_property("_mushroomGardenFights").to_int();
		boolean visited = get_property("_mushroomGardenVisited").to_boolean();
		string crop;
		switch (days)
		{
			case 0:
			case 1: crop = "free-range mushroom"; break;
			case 2: crop = "plump free-range mushroom"; break;
			case 3: crop = "bulky free-range mushroom"; break;
			case 4: crop = "giant free-range mushroom"; break;
			case 5:
			case 6:
			case 7:
			case 8:
			case 9:
			case 10: crop = "immense free-range mushroom"; break;
			case 11: crop = "colossal free-range mushroom"; break;
			default: crop = "house-sized mushroom";
		}
		string text = "Mushroom fertilize days = " + (days - 1) + ", crop = " + crop + " (fights=" + fights + ", visited=" + visited + ")";
		page = first + " alt=\"" + text + "\" title=\"" + text + "\"" + second;
	}
	write(page);
}
