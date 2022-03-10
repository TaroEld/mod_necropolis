this.necropolis_destroyed_event <- this.inherit("scripts/events/event", {
	m = {},
	function create()
	{
		this.m.ID = "event.location.necropolis_destroyed";
		this.m.Title = "After the battle";
		this.m.Cooldown = 999999.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_119.png[/img]You managed to slay the monsters and beat Kemmler to the ground. Despite his body being broken and mangled, he still talks to you. %SPEECH_ON%Enjoy your phyrric victory. Of course, by now my legions have gathered enough life-force to last me for a hundred deaths. It might take a while, but we will see ea-%SPEECH_OFF% His monologue gets interrupted by the boot of %randombrother% crushing his skull.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Let's move along.",
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
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_119.png[/img]You managed to slay the monsters and beat Kemmler to the ground. Despite his body being broken and mangled, he still talks to you. %SPEECH_ON%You might have broken this vessel, but this won't stop me. I shall return in only a hundred years, and this time I-%SPEECH_OFF% His monologue gets interrupted by the boot of %randombrother% crushing his skull.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Not our problem anymore.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Flags.set("activeNecropolis", false);
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
		if (this.World.Flags.has("spawningNecropolisCounter") && this.World.Flags.get("spawningNecropolisCounter") >1) return "C"
		else return "B"
	}

	function onClear()
	{
	}

});

