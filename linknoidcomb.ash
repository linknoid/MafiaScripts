
void CombBeach(int count)
{
	int freeWalksLeft = 11 - get_property("_freeBeachWalksUsed").to_int();
	if (count <= 0)
		count = freeWalksLeft;
	string page;
	page = visit_url("main.php?comb=1", false); // start combing
	if (!page.contains_text("Wandor to a random spot")
		&& !page.contains_text("find a nice stretch of beach"))
	{
//		print("unexpected page: " + page);
//		abort("Can't find comb page, aborting");
	}
	for (int x = 0; x < count; x++)
	{
		page = visit_url("choice.php?whichchoice=1388&option=2");
		if (!page.contains_text("find a nice stretch of beach"))
		{
			print("unexpected page: " + page);
			abort("Can't find beach page, aborting");
		}
		string[int] layout = get_property("_beachLayout").split_string(",");
		int bestValue = 0;
		int row = 0;
		int col = 0;
		string type = "";
		for (int i = 0; i < layout.count(); i++)
		{
			string[] split = layout[i].split_string(":");
			int rowNum = split[0].to_int();
			string line = split[1];
//print("line: " + line + " length " + line.length());
			for (int j = 0; j < line.length(); j++)
			{
				string tileCode = line.substring(j,j+1);
				string curType = "";
				int value = 0;
				switch (tileCode)
				{
					case "W":
						value = 1000;
						curType = "whale";
						break;
					case "t":
						value = 301 + random(100);
						curType = "twinkle";
						break;
					case "r":
						value = 201 + random(100);
						curType = "rough sand";
						break;
					case "c":
						value = 1 + random(100);
						curType = "combed sand";
						break;
					case "C":
						value = 1 + random(100);
						curType = "castle";
						break;
					case "H": // head
						value = -1;
						curType = "head";
						break;
					default:
						abort("Found unknown beach tile type '" + tileCode + "' at " + i + ", " + j);
				}
				if (value > bestValue)
				{
					row = rowNum;
					col = j;
					bestValue = value;
					type = curType;
				}
			}
		}
		print("Combing a " + type + " at " + row + ", " + col);
		string coord = row + "," + ( get_property("_beachMinutes").to_int() * 10 - col);
		string url = "choice.php?whichchoice=1388&option=4&coords=" + coord;
		visit_url(url);
	}
	visit_url("choice.php?whichchoice=1388&option=5"); // stop combing
}

void main(int count)
{
	CombBeach(count);
	
}
