this.undead_hunters_intro_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.undead_hunters_scenario_intro";
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_132.png[/img]{Seems the former residents of this quiet hamlet never had a chance.  All that is left is to stack the eviserated bodies of the half eaten dead and to burn them, in the hope they will remain dead.  Something malevolent is out there, you can feel it, and it seems to be growing in strength.  Yet in a few days you know the Nobles will forget this tragedy, and try to bury its memory as a secret best forgotten.  You and your Company know better, your quest has just begun.}",
			Image = "",
			Banner = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "If there is a city of the undead out there, we will find it, and root out whatever evil lurks there.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Banner = "ui/banners/" + this.World.Assets.getBanner() + "s.png";
			}

		});
	}

	function onUpdateScore()
	{
		return;
	}

	function onPrepare()
	{
		this.m.Title = "Undead Hunters";
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	}

});

