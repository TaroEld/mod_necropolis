this.necropolis_enter_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.necropolis_enter";
		this.m.Title = "Entering the Necropolis";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_119.png[/img]{You creep into the decrepit ruins. In the middle of the courtyard, you find a lonesome human figure, clad in dark robes glowing with dark magic. It turns towards you, and adresses you: %SPEECH_ON% Greetings, mortals. I suggest you leave this place at once, as I am quite busy at the moment. My beasts, please show these gentlemen the door. %SPEECH_OFF% Suddenly, a variety of dark monsters and beasts emerge from the ruins and shamble towards you.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "To arms!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
			}
		});
	}

	function onUpdateScore()
	{
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onDetermineStartScreen()
	{
		return "A"
	}

	function onClear()
	{
	}

});

