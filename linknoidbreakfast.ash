

if (get_property("_internetPrintScreenButtonBought") == "false"
	&& $item[BACON].item_amount() > 400)
{
	cli_execute("coinmaster buy bacon print screen button");
}
cli_execute("fortune odebot");
cli_execute("fortune heartbot");
