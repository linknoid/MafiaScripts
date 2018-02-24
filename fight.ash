// put this in the relay folder to help with the unusual construct fight

void main()
{
	string page = visit_url();
	int ix = page.index_of("The construct says ");
	if (ix > 0)
	{
		ix += length("The construct says ");
		string first = page.substring(0, ix);
		string second = page.substring(ix);
		int firstspace = second.index_of(" ");
		int secondspace = second.index_of(" ", firstspace + 1);
		string word = second.substring(firstspace + 1, secondspace);
		switch (word)
		{
			case "BE":         word = "green";  break;
			case "BELA":       word = "blue";   break;
			case "BU":         word = "blue";   break;
			case "BULAZAK":    word = "blue";   break;
			case "BUPABU":     word = "black";  break;
			case "CHAKRO":     word = "red";    break;
			case "CHO":        word = "yellow"; break;
			case "FUFUGAKRO":  word = "blue";   break;
			case "FUNI":       word = "yellow"; break;
			case "NIPA":       word = "white";  break;
			case "PACHA":      word = "white";  break;
			case "PATA":       word = "black";  break;
			case "SOM":        word = "black";  break;
			case "SOMPAPA":    word = "white";  break;
			case "TAZAK":      word = "yellow"; break;
			case "ZAKSOM":     word = "green";  break;
			case "ZEVE":       word = "red";    break;
			case "ZEVEBENI":   word = "green";  break;
			case "ZEVESTANO":  word = "red";    break;

			case "JADE":       word = "green";  break;
			case "COBALT":     word = "blue";   break;
//			case "":           word = "blue";   break;
			case "SAPPHIRE":   word = "blue";   break;
			case "OBSIDIAN":   word = "black";  break;
			case "CRIMSON":    word = "red";    break;
			case "GOLD":       word = "yellow"; break;
			case "ULTRAMARINE":word = "blue";   break;
			case "CITRINE":    word = "yellow"; break;
			case "IVORY":      word = "white";  break;
			case "PEARL":      word = "white";  break;
			case "EBONY":      word = "black";  break;
			case "JET":        word = "black";  break;
			case "ALABASTER":  word = "white";  break;
			case "CANARY":     word = "yellow"; break;
			case "EMERALD":    word = "green";  break;
			case "RUBY":       word = "red";    break;
			case "VERDIGRIS":  word = "green";  break;
			case "VERMILLION": word = "red";    break;
		}
		page = first + " (" + word + ") " + second;
	}
	write(page);
}

