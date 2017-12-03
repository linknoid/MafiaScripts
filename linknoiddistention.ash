void main()
{
	while ($Item[ Map to Safety Shelter Grimace Prime ].item_amount() > 0)
	{
		if ($Effect[ Transpondent ].have_effect() == 0)
		{
			use(1, $Item[ transporter transponder ]);
		}
		visit_url("inv_use.php?whichitem=5172"); //use(1, $Item[ Map to Safety Shelter Grimace Prime ]);
                visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1"); // Down the Hatch
                visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1");  // Have a Drink
                visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=2");  // Try That One Door
                visit_url("choice.php?pwd=" + my_hash() + "&whichchoice=536&option=1");  // Follow Captian Smirk
	}
}
