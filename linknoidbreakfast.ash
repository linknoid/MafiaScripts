

if (get_property("_internetPrintScreenButtonBought") == "false"
	&& $item[BACON].item_amount() > 400)
{
	cli_execute("coinmaster buy bacon print screen button");
}
string consult1 = get_property("clanFortuneConsulter1");
string consult2 = get_property("clanFortuneConsulter2");
string consult3 = get_property("clanFortuneConsulter3");
if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult1 != "")
{
	cli_execute("fortune " + consult1);
	if (consult1 == consult2)
		waitq(2);
}
if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult2 != "")
{
	cli_execute("fortune " + consult2);
	if (consult2 == consult3)
		waitq(2);
}
if (get_property("_clanFortuneConsultUses").to_int() < 3 && consult3 != "")
{
	cli_execute("fortune " + consult3);
}
