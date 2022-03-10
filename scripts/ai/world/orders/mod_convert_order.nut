this.mod_convert_order <- this.inherit("scripts/ai/world/world_behavior", {
	m = {
		IsBurning = false,
		IsSafetyOverride = false,
		TargetTile = null,
		TargetID = 0,
		Time = 0.0,
		Start = 0.0,
		Once = false //can be called a single time
	},
	function setTargetTile( _t )
	{
		this.m.TargetTile = _t;
	}

	function setTargetID( _id )
	{
		this.m.TargetID = _id;
	}

	function setTime( _t )
	{
		this.m.Time = _t;
	}

	function setSafetyOverride( _s )
	{
		this.m.IsSafetyOverride = _s;
	}

	function create()
	{
		this.world_behavior.create();
		this.m.ID = this.Const.World.AI.Behavior.ID.Convert;
	}
	function setOnce()
	{
		this.m.Once = true
	}

	function onSerialize( _out )
	{
		this.world_behavior.onSerialize(_out);
		_out.writeI16(this.m.TargetTile.Coords.X);
		_out.writeI16(this.m.TargetTile.Coords.Y);
		_out.writeU32(this.m.TargetID);
		_out.writeBool(this.m.IsSafetyOverride);
		_out.writeF32(this.m.Time);
		_out.writeF32(this.m.Start);
		_out.writeBool(this.m.Once);
	}

	function onDeserialize( _in )
	{
		this.world_behavior.onDeserialize(_in);
		local x = _in.readI16();
		local y = _in.readI16();
		this.m.TargetTile = this.World.getTile(x, y);
		this.m.TargetID = _in.readU32();
		this.m.IsSafetyOverride = _in.readBool();
		this.m.Time = _in.readF32();
		this.m.Start = _in.readF32();
		this.m.Once = _in.readBool();
	}

	function onExecute( _entity, _hasChanged )
	{
		local stopThis = false;
		if (this.World.Assets.isPermanentDestruction() && this.World.EntityManager.getSettlements().len() < 3)
		{
			stopThis = true;
		}
		else{
			local activeCount = 0
			foreach (settlement in this.World.EntityManager.getSettlements())
			{
				if (!settlement.hasSituation("situation.raided")) activeCount++
			}
			if (activeCount <3) stopThis = true;
		}

		if (stopThis){
			this.World.Flags.set("activeNecropolis", false)
			local order = this.new("scripts/ai/world/orders/despawn_order")
			local c = this.getController()
			c.clearOrders()
			c.addOrder(order)
			return true
		}


		local myTile = _entity.getTile();
		if (!this.m.IsSafetyOverride)
		{
			local activeContract = this.World.Contracts.getActiveContract();

			if (activeContract != null && activeContract.isTileUsed(myTile))
			{
				this.getController().popOrder();
				return true;
			}
		}

		if (this.m.TargetTile != null && myTile.ID != this.m.TargetTile.ID)
		{
			local move = this.new("scripts/ai/world/orders/move_order");
			move.setDestination(this.m.TargetTile);
			this.getController().addOrderInFront(move);
			return true;
		}

		_entity.setOrders("Converting");

		if (this.m.Start == 0.0)
		{
			this.m.Start = this.Time.getVirtualTimeF();
		}
		else if (this.Time.getVirtualTimeF() - this.m.Start >= this.m.Time)
		{
			local entities = this.World.getAllEntitiesAndOneLocationAtPos(_entity.getPos(), 1.0);
			foreach( e in entities )
			{
				if (e.isAlive() && e.getID() == this.m.TargetID)
				{
					foreach (attachedLocation in e.getAttachedLocations())
					{
						attachedLocation.setActive(false);
					}
					if (!this.World.Assets.isPermanentDestruction())
					{
						if (!e.hasSituation("situation.raided"))
						{
							local news = this.World.Statistics.createNews();
							news.set("City", e.getName());
							this.World.Statistics.addNews("necropolis_town_destroyed", news);
							e.addSituation(this.new("scripts/entity/world/settlements/situations/raided_situation"), e.getSize() * 14);
						}
					}
					else
					{
						local tile = e.getTile();
						local name = e.getName();
						local sprite = e.m.Sprite;
						e.fadeOutAndDie();
						local n = this.World.spawnLocation("scripts/entity/world/locations/undead_necropolis_location", tile.Coords);
						n.setName(name);
						n.setSprite(sprite);
						n.onSpawned();
						n.setBanner(_entity.getBanner());
						this.World.FactionManager.getFaction(_entity.getFaction()).addSettlement(n, false);
						local news = this.World.Statistics.createNews();
						news.set("City", e.getName());
						this.World.Statistics.addNews("necropolis_town_destroyed", news);
					}
					break;
				}
			}

			if (this.m.Once)
			{
				local order = this.new("scripts/ai/world/orders/despawn_order");
				local c = this.getController()
				c.clearOrders()
				c.addOrder(order)
				return true;
			}

			local bestDist = 9999
			local tile =_entity.getTile()
			local chosen;
			foreach (settlement in this.World.EntityManager.getSettlements())
			{
				if (!settlement.hasSituation("situation.raided"))
				{
					local d = settlement.getTile().getDistanceTo(tile);
					if (d < bestDist){
						bestDist = d
						chosen = settlement
					}
				}
			}

			local entities = this.World.getAllEntitiesAtPos(_entity.getPos(), 3.0);
			foreach (entity in entities)
			{
				if (entity.getDescription() ==_entity.getDescription())
				{
					local order;
					if (chosen)
					{
						order = this.new("scripts/ai/world/orders/mod_convert_order");
						order.setTime(60.0);
						order.setTargetTile(chosen.getTile());
						order.setTargetID(chosen.getID());
					}
					else {
					    order = this.new("scripts/ai/world/orders/despawn_order");
					}	
					local c = entity.getController()
					c.clearOrders()
					c.addOrder(order)
				}
			}

		}
		return true;
	}

});

