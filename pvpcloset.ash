// adapted from http://kolmafia.us/showthread.php?10059-Save-items-from-pvp-theft

boolean Closetable(item itm)
{
	return itm.tradeable && itm.discardable && !itm.gift && !itm.quest && itm != $item[toast];
}

void main(string Outfit)
{
	if (Outfit == "all")
	{
		if (!user_confirm("Remove all pvp-able items from closet back into inventory?"))
			return;

	        batch_open();
		foreach itm,quant in get_closet()
		{
			if (itm.tradeable && itm.discardable && !itm.gift && !itm.quest)
				take_closet(quant, itm);
		}
	        batch_close();
	}
	else
	{
		if (!user_confirm("Place all pvp-able items from inventory to closet?"))
			return;
		int[item] inv = get_inventory();
	        batch_open();
	        foreach itm,quant in inv
	        {
			if (Closetable(itm))
			{
				put_closet(itm.item_amount(), itm);
			}
	        }
	        batch_close();
		if (Outfit != "")
		{
			foreach quant,piece in outfit_pieces(Outfit)
			{
				if (piece.item_amount() == 0 && !piece.have_equipped() && piece.closet_amount() > 0)
				{
					take_closet(1, piece);
				}
			}
			outfit(Outfit);
			inv = get_inventory();
			foreach itm,quant in inv
			{
				if (Closetable(itm))
				{
					put_closet(itm.item_amount(), itm);
				}
			}
		}
	}
}
