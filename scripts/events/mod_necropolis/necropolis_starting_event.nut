this.necropolis_starting_event <- this.inherit("scripts/events/event", {
	//starts the countdown to the Necropolis spawning units
	m = {
		News = null,
		Destination = null
	},
	function create()
	{
		this.m.ID = "event.necropolis_starting";
		this.m.Title = "During camp...";
		this.m.IsSpecial = true;
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]You lay down for a nap after a hard day of mercaneering. \n Out of the fog of messy dreams emerges a shadowed face, with pale flesh tightly stretched over a gaunt skull. It begins talking to you:%SPEECH_ON% Greetings, mortals. Your world bores me. The years pass, new lords and kingdoms rise and fall, and your incessant squabbles never end. I shall do you a favour, and conclude this endless cycle of suffering. Two fortnights from now, my ritual shall complete, and silence will finally reign the lands. %SPEECH_OFF%\" The figure starts to fade away, and you wake up with a start. You can see other brothers be equally confused, and even frightened. You know: this was no mere dream.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What was that all about?",
					function getResult( _event )
					{

						return "B";
					}

				}
			],
			function start( _event )
			{
			}

			});
					this.m.Screens.push({
				ID = "B",
				Text = "[img]gfx/ui/events/event_73.png[/img]%randombrother% approaches you. He tells you of an old legend: an old town in the %direction%, once a jewel of humanity, lost in the ancient times to dark creatures. Nowadays, only rumors of a Necropolis, City of the Undead and domain of a dark necromancer called Kemmler, remain. This is where we have to venture if we want to stop what's about to happen.",
				Image = "",
				List = [],
				Characters = [],
				Options = [
					{
						Text = "This is dire.",
						function getResult( _event )
						{
							this.World.Flags.set("startingNecropolisAnnounced", true)
							return 0;
						}

					}
				],
				function start( _event )
				{
				}

			});
	}
	
	function onPrepare()
	{
		local necropolis;
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				necropolis = location
				break;
			}
		}
		this.m.News = this.World.Statistics.popNews("necropolis_starting");
		this.m.Destination = this.WeakTableRef(necropolis)
	}
	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("necropolis_starting"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
		"direction",
		this.m.Destination == null || this.m.Destination.isNull() ? "" : this.Const.Strings.Direction8[this.World.State.getPlayer().getTile().getDirection8To(this.m.Destination.getTile())]
		])
	}

	function onClear()
	{
		this.m.News = null
		this.m.Destination = null
	}

});

