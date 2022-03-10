this.mod_necropolis_location <- this.inherit("scripts/entity/world/location", {
	m = {
		SettlementSprite = "",
		SettlementName = ""
	},
	function getDescription()
	{
		return "Once a thriving human settlement, this place has been defiled and fallen into ruin, turned into a necropolis of the undead. Waves of walking corpses pour forth to spread terror and fear in the surrounding lands.";
	}

	function setSprite( _s )
	{
		this.m.SettlementSprite = _s;
		this.getSprite("body").setBrush(this.m.SettlementSprite + "_undead");
		this.getSprite("lighting").setBrush(this.m.SettlementSprite + "_undead_lights");
	}
	function setName(_n)
	{
		this.m.SettlementName = _n;
		this.world_entity.setName(_n);
	}

	function create()
	{
		this.location.create();
		this.m.TypeID = "location.mod_necropolis";
		this.m.LocationType = this.Const.World.LocationType.Lair | this.Const.World.LocationType.Unique;
		this.m.CombatLocation.Template[0] = "tactical.ruins";
		this.m.CombatLocation.Fortification = this.Const.Tactical.FortificationType.Walls;
		this.m.CombatLocation.CutDownTrees = false;
		this.m.CombatLocation.ForceLineBattle = true;
		this.m.CombatLocation.AdditionalRadius = 5;
		this.m.IsDespawningDefenders = false;
		this.m.IsShowingDefenders = false;
		this.m.IsShowingBanner = true;
		this.m.Resources = 1000;
		this.m.NamedWeaponsList = this.Const.Items.NamedUndeadWeapons;
		this.m.NamedShieldsList = this.Const.Items.NamedUndeadShields;
		this.m.OnDestroyed = "event.location.necropolis_destroyed";
		this.m.OnEnter = "event.location.necropolis_enter";
		
	}

	function onSpawned()
	{
		this.location.onSpawned();
		

		local boss = 
		{
			ID = this.Const.EntityType.Necromancer,
			Variant = 1,
			Strength = 35,
			Cost = 30,
			Row = 3,
			Script = "scripts/entity/tactical/enemies/mod_boss_necromancer",
			NameList = ["Kemmler, the Mad Necromancer"],
			TitleList = null
		}
		local marshall = {
		ID = this.Const.EntityType.ZombieKnight,
		Variant = 1,
		Strength = 30,
		Cost = 24,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/zombie_knight",
		NameList = ["Mordred, Marshall of the Undead"],
		TitleList = null
		}
		local arthur = {
		ID = this.Const.EntityType.ZombieKnight,
		Variant = 1,
		Strength = 30,
		Cost = 24,
		Row = 1,
		Script = "scripts/entity/tactical/enemies/zombie_knight",
		NameList = ["Arthur, the Fallen King"],
		TitleList = null
		}
		local Troops = 
		[
			{
			Type = this.Const.World.Spawn.Troops.Ghost,
			Num = 3
			},
			{
			Type = this.Const.World.Spawn.Troops.GhoulHIGH,
			Num = 3
			},
			{
			Type = this.Const.World.Spawn.Troops.ZombieYeoman,
			Num = 9
			},
			{
			Type = this.Const.World.Spawn.Troops.Alp,
			Num = 4
			},
			{
			Type = this.Const.World.Spawn.Troops.Vampire,
			Num = 5
			},
			{
			Type = this.Const.World.Spawn.Troops.ZombieKnightBodyguard,
			Num = 2
			}
		]
		foreach(troop in Troops)
		{
			for( local i = 0; i < troop.Num; i = ++i )
			{
				this.Const.World.Common.addTroop(this, {Type = troop.Type}, false);
			}
		}

		this.Const.World.Common.addTroop(this, {Type = boss}, false, 100);
		this.Const.World.Common.addTroop(this, {Type = marshall}, false, 100);
		this.Const.World.Common.addTroop(this, {Type = arthur}, false, 100);
		
	}

	function onDropLootForPlayer( _lootTable )
	{
		this.location.onDropLootForPlayer(_lootTable);
		this.dropMoney(this.Math.rand(500, 1000), _lootTable);
		this.dropTreasure(this.Math.rand(7, 10), [
			"loot/silverware_item",
			"loot/silver_bowl_item",
			"loot/signet_ring_item",
			"loot/white_pearls_item",
			"loot/golden_chalice_item",
			"loot/gemstones_item",
			"loot/ancient_gold_coins_item",
			"loot/jeweled_crown_item",
			"loot/ancient_gold_coins_item",
			"loot/ornate_tome_item"
		], _lootTable);
	}

	function onCombatLost()
	{
		this.World.Flags.set("activeNecropolis", false)
		foreach (unit in this.World.FactionManager.getFaction(this.getFaction()).m.Units)
		{
			if (unit.getDescription() == "A legion of walking dead, summoned from their eternal slumber by Kemmler, the Mad Necromancer"){
				unit.die()
			}
		}
		this.getTile().spawnDetail(this.m.SettlementSprite + "_ruins", this.Const.World.ZLevel.Object - 3, 0, false);
		this.World.EntityManager.onWorldEntityDestroyed(this, true);
		this.location.onCombatLost();
	}

	function onInit()
	{
		this.location.onInit();
		local body = this.addSprite("body");
		local light = this.addSprite("lighting");
		this.setSpriteColorization("lighting", false);
		light.IgnoreAmbientColor = true;
		light.Alpha = 0;
		this.registerThinker();
	}

	function onFinish()
	{
		this.location.onFinish();
		this.unregisterThinker();
	}

	function onUpdate()
	{
		local lighting = this.getSprite("lighting");

		if (lighting.IsFadingDone)
		{
			if (lighting.Alpha == 0 && this.World.getTime().TimeOfDay >= 4 && this.World.getTime().TimeOfDay <= 7)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeIn(5000);
				}
				else
				{
					lighting.Alpha = 255;
				}
			}
			else if (lighting.Alpha != 0 && this.World.getTime().TimeOfDay >= 0 && this.World.getTime().TimeOfDay <= 3)
			{
				local insideScreen = this.World.getCamera().isInsideScreen(this.getPos(), 0);

				if (insideScreen)
				{
					lighting.fadeOut(4000);
				}
				else
				{
					lighting.Alpha = 0;
				}
			}
		}
	}

	function onSerialize( _out )
	{
		this.location.onSerialize(_out);
		_out.writeString(this.m.SettlementName);
		_out.writeString(this.m.SettlementSprite);
	}

	function onDeserialize( _in )
	{
		this.location.onDeserialize(_in);
		this.m.SettlementName = _in.readString();
		this.m.SettlementSprite = _in.readString();
		if (this.getFlags().get("IsMarked")){
			this.getSprite("selection").Visible = true;
		}
	}

});