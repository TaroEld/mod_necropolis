this.necropolis_now_spawning_event <- this.inherit("scripts/events/event", {
	//Necropolis now starts units.
	m = {
		News = null,
		Destination = null
	},
	function create()
	{
		this.m.ID = "event.necropolis_spawning";
		this.m.Title = "Disaster!";
		this.m.IsSpecial = true;
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]The sky has been darkening over the last few days. Out of the sudden, a giant green beam pierces the clouds to the %direction%. The sky feels charged up, and you can almost hear the sounds of a plethora of boots striking the grounds in unison. We are too late! Our only chance is a last, desperate bid to destroy the Necropolis before the world has been overrun.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "And so it begins.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Destination.getTile().Pos, 700.0);
						_event.m.Destination.getFlags().set("IsEventLocation", true);
						_event.m.Destination.setDiscovered(true);
						_event.m.Destination.getSprite("selection").Visible = true;
						this.World.getCamera().moveTo(_event.m.Destination);
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
		this.m.News = this.World.Statistics.popNews("necropolis_spawning");
		this.m.Destination = this.WeakTableRef(necropolis)
	}
	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("necropolis_spawning"))
		{
			this.logInfo("SPAWNING EVENT NOW IN " + this.World.getTime().Days)
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

