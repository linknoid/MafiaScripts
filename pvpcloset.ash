// adapted from http://kolmafia.us/showthread.php?10059-Save-items-from-pvp-theft

void main(string Outfit)
{
	if (!user_confirm("Place all pvp items from inventory to closet?"))
		return;
	int[item] inv = get_inventory();
        batch_open();
        foreach itm,quant in inv
        {
		if (itm.tradeable && itm.discardable && !itm.gift && !itm.quest)
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
				take_closet(piece.closet_amount(), piece);
			}
		}
		outfit(Outfit);
		inv = get_inventory();
		foreach itm,quant in inv
		{
			if (itm.tradeable && itm.discardable && !itm.gift && !itm.quest)
			{
				put_closet(itm.item_amount(), itm);
			}
		}
	}
}
