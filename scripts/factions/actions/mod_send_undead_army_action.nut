this.mod_send_undead_army_action <- this.inherit("scripts/factions/faction_action", {
	m = {},
	function create()
	{
		this.m.ID = "mod_send_undead_army_action";
		this.m.Cooldown = this.World.getTime().SecondsPerDay * 4;
		this.m.IsSettlementsRequired = true;
		this.faction_action.create();
	}

	function onUpdate( _faction )
	{
		if (!this.World.Flags.get("activeNecropolis") || !this.World.Flags.get("spawningNecropolis")) return;
		this.m.Score = 100;
	}

	function onClear()
	{
	}

	function onExecute( _faction )
	{
		local necropolis;
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				necropolis = location
				break;
			}
		}
		if (!necropolis) return
		local origin = necropolis
		local myTile = origin.getTile();
		local activeContract = this.World.Contracts.getActiveContract();
		local settlements = clone this.World.EntityManager.getSettlements();
		local best_settlement
		while (settlements.len() > 0 && !best_settlement)
		{
			local rng = this.Math.rand(0, settlements.len()-1)
			local newset = settlements.remove(rng)
			if ((activeContract != null && (activeContract.getHome().getID() == newset.getID() || activeContract.getOrigin().getID() == newset.getID())) || newset.isIsolatedFromLocation(origin)) continue;
			best_settlement = newset
		}	
		if (!best_settlement) return false;

		local nearestUndead = this.getNearestLocationTo(origin, this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).getSettlements());
		for (local x = 0; x < 3; x++)
		{
			local party = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead).spawnEntity(myTile, "Undead", false, this.Const.World.Spawn.UndeadScourge, 700);
			party.getSprite("banner").setBrush(nearestUndead.getBanner());
			party.setDescription("A legion of walking dead, summoned from their eternal slumber by Kemmler, the Mad Necromancer");
			party.setFootprintType(this.Const.World.FootprintsType.Undead);
			party.setMovementSpeed(100)
			party.setSlowerAtNight(false);
			party.setUsingGlobalVision(false);
			party.setLooting(false);
			party.getFlags().set("IsRandomlySpawned", true);
			party.getLoot().ArmorParts = this.Math.rand(30, 50);
			party.getLoot().Money = this.Math.rand(500, 1000);
			party.getLoot().Medicine = this.Math.rand(10, 20);
			
			local c = party.getController();
			c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
			if (x>0) c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);

			local raid = this.new("scripts/ai/world/orders/mod_convert_order");
			raid.setTime(60.0);
			raid.setTargetTile(best_settlement.getTile());
			raid.setTargetID(best_settlement.getID());
			c.addOrder(raid);
		}
		this.World.Flags.set("spawningNecropolisCounter", this.World.Flags.get("spawningNecropolisCounter")+1)
		if (this.World.Flags.get("spawningNecropolisCounter") == 7) this.World.Flags.set("activeNecropolis", false)
		return true;
		
	}

});

