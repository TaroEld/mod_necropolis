
::mods_registerMod("mod_necropolis", 1.0);
::mods_queue(null, null, function()
{	
	//flags used:
	//spawnedNecropolis : Set when necropolis has been spawned, so that only one can be spawned
	//activeNecropolis  : Set after necropolis has been spawned, set to false when it's destroyed, it has spawned 7 units, or there's only 1 settlement left
	//startingNecropolisDate : Set when necropolis is spawned, date when the announcment event pops
	//startingNecropolisAnnounced: Set after starting news is popped
	//spawningNecropolisDate: Set when necropolis is spawned, deadline, afterwards starts spawning units
	//spawningNecropolis: Set when it starts spawning
	//spawningNecropolisCounter: Counts how many units it's spawned, after 7 sets activeNecropolis to false
	//disabledUntil: set when a town has been converted and non permanent destruction, randoms a date in days when it's going to rebuild based on size
	local withDeadline = false;
	::mods_hookNewObject("states/world/asset_manager", function (o)
	{
		while (!("update" in o)) o = o[o.SuperName];
		local update = o.update;		
		o.update = function(_worldState)
		{	
			update(_worldState)
			if (!this.World.Flags.get("spawnedNecropolis"))
			{
				//spawns the necropolis
				local disallowedTerrain = [this.Const.World.TerrainType.Mountains, this.Const.World.TerrainType.Impassable, this.Const.World.TerrainType.Ocean]
				local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead)
				local tile;
				local camp;
				while (tile == null)
				{
					tile = f.m.Deck[0].getTileToSpawnLocation(this.Const.Factions.BuildCampTries * 100, disallowedTerrain, 30, 1000);
				}
				if (tile != null)
				{
					camp = this.World.spawnLocation("scripts/entity/world/locations/mod_necropolis_location.nut", tile.Coords);
				}

				if (camp != null)
				{
					this.logInfo("Necropolis has been spawned!")
					camp.setName("Necropolis, City of the Undead")
					camp.setSprite("world_stronghold_03")
					camp.setBanner("banner_zombies_06")
					camp.onSpawned();
					f.addSettlement(camp, false);
					this.World.Flags.set("spawnedNecropolis", true)
					if (withDeadline){ 
						this.World.Flags.set("activeNecropolis", true)
						local startingDate = (this.World.getTime().Days < 100) ? (this.Math.rand(100, 110)) : this.World.getTime().Days +1
						local spawningDate = startingDate + this.Math.rand(40, 50)
						this.World.Flags.set("startingNecropolisDate", startingDate)
						this.World.Flags.set("spawningNecropolisDate", spawningDate)
						//start instantly for testing	
						this.World.Flags.set("startingNecropolisDate", this.World.getTime().Days+3)
						this.World.Flags.set("spawningNecropolisDate", this.World.getTime().Days+6)
					}

					
				}
			}
			//set events/news
			if (this.World.Flags.get("activeNecropolis"))
			{
				//announce necropolis
				if (!this.World.Flags.get("startingNecropolisAnnounced") && this.World.getTime().Days > this.World.Flags.get("startingNecropolisDate"))
				{
					this.logInfo("Necropolis now warming up!")
					this.World.Flags.set("startingNecropolisAnnounced", true)
					local event = this.new("scripts/events/mod_necropolis/necropolis_starting_event")
					this.World.Events.m.Events.push(event)
					local news = this.World.Statistics.createNews();
					this.World.Statistics.addNews("necropolis_starting", news);					
				}
				//raze a village
				if (!this.World.Flags.get("soonNecropolis") && this.World.getTime().Days > this.World.Flags.get("spawningNecropolisDate")-21 )
				{
					this.logInfo("Necropolis ramping up!")
					this.World.Flags.set("soonNecropolis", true)
					local event = this.new("scripts/events/mod_necropolis/necropolis_soon_spawning_event")
					this.World.Events.m.Events.push(event)
					local news = this.World.Statistics.createNews();
					this.World.Statistics.addNews("necropolis_soon_spawning", news);
				}
				//announce spawning necropolis, add the faction action to the deck
				if (!this.World.Flags.get("spawningNecropolis") && this.World.getTime().Days > this.World.Flags.get("spawningNecropolisDate") )
				{
					this.logInfo("Necropolis now spawning!")
					this.World.Flags.set("spawningNecropolis", true)
					this.World.Flags.set("spawningNecropolisCounter", 0)
					local event = this.new("scripts/events/mod_necropolis/necropolis_now_spawning_event")
					this.World.Events.m.Events.push(event)
					local news = this.World.Statistics.createNews();
					this.World.Statistics.addNews("necropolis_spawning", news);
					local f = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead)
					local card = this.new("scripts/factions/actions/mod_send_undead_army_action")
					card.setFaction(f);
					f.m.Deck.push(card)
				}
			}
		}
	})

	::mods_hookNewObject("skills/actives/possess_undead_skill", function (o)
	{

		local isUsable = ::mods_getMember(o, "isUsable")
		::mods_override(o, "isUsable", function()
		{
			if (this.getContainer().getActor().getName() == "Kemmler, the Mad Necromancer") return this.skill.isUsable()
			return isUsable()
		});
	})
})