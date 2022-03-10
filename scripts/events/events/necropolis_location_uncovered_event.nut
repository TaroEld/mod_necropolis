this.necropolis_location_uncovered_event <- this.inherit("scripts/events/event", {
	m = {
		Location = null,
		Historian = null
	},
	function create()
	{
		this.m.ID = "event.necropolis_location_uncovered";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_45.png[/img]While on the road, you meet a haggard old man. He does not seem to notice your party and is talking to himself. %SPEECH_ON% I have seen evil, oh I have seen it... A fortress, black as the night... The darkness, seeping out of the walls... Chanting in the night... Make it stop! Make me forget! %SPEECH_OFF% Could this old man have found what we are looking for? You order %randombrother% to apprehend the man, and dig out an old map of the lands from your supplies. After a lengthy process, the old man manages to point towards a spot on the map, and promptly crumbles down, dead on the spot. You are convinced that this is where you will find the lair of the Necromancer.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Bury him and move along.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						_event.m.Location.getSprite("selection").Visible = true;
						this.World.getCamera().moveTo(_event.m.Location);
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
			Text = "[img]gfx/ui/events/event_45.png[/img]%historian% approaches you with an old map in his hands. While pointing at a spot on the map, he says: %SPEECH_ON% Sir, I think I have remembered where the Necropolis stands. This is where we have to go if we want to stop what's about to happen.%SPEECH_OFF%.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Good to have someone with your skills with us.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						_event.m.Location.getSprite("selection").Visible = true;
						_event.m.Location.getFlags().set("IsMarked", true)
						this.World.getCamera().moveTo(_event.m.Location);
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
		if (!this.World.Flags.get("activeNecropolis") || !this.World.Flags.get("startingNecropolisAnnounced")) return
		local necropolis=false;
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				necropolis = true
				break;
			}
		}
		if (!necropolis) return
		local timeUntilSpawning = this.World.Flags.get("spawningNecropolisDate") - this.World.getTime().Days

		this.m.Score = 50 - (timeUntilSpawning <= 7? -2000 : timeUntilSpawning) //increase chance of this happening the closer you get to the deadline, make it guaranteed a week before
		foreach( bro in this.World.getPlayerRoster().getAll() )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				this.m.Score += 20
			}
		}
	}

	function onPrepare()
	{
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				this.m.Location = this.WeakTableRef(location)
				break;
			}
		}
		if (this.m.Location == null) return
		if (this.m.Location.isDiscovered()) return
		foreach( bro in this.World.getPlayerRoster().getAll() )
		{
			if (bro.getBackground().getID() == "background.historian")
			{
				this.m.Historian = bro;
				return
			}
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"historian",
			this.m.Historian != null ? this.m.Historian.getNameOnly() : ""
		]);

	}

	function onDetermineStartScreen()
	{
		if(this.m.Historian) return "B"
		return "A"
	}
	function onClear()
	{
		this.m.Location = null;
		this.m.Historian = null;
	}

});

