
void main()
{
	print("Attempting to run plastic vampire fangs masquerade");
	if (get_property("_interviewMasquerade") != "false")
	{
		print("Already done");
		return;
	}
	if ($item[plastic vampire fangs].item_amount() > 0)
	{
		$slot[acc1].equip($item[plastic vampire fangs]);
	}
	if (!$item[plastic vampire fangs].have_equipped())
	{
		print("No fangs");
		return;
	}
	if (!user_confirm("Do you wish to collect your own black heart?"))
		return;
	visit_url("place.php?whichplace=town&action=town_vampout");
	run_choice(3);
	run_choice(3);
	run_choice(1);
	run_choice(2);
	run_choice(4);
	run_choice(1);
	run_choice(4);
	run_choice(1);
	run_choice(2);
	run_choice(1);
	run_choice(1); // Yes
	run_choice(1); // And the result is
}
