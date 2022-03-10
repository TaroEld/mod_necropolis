this.necropolis_soon_spawning_event <- this.inherit("scripts/events/event", {
	//send out an army to raze a town
	m = {
		News = null,
		Destination = null,
		Startpoint = null
	},
	function create()
	{
		this.m.ID = "event.necropolis_soon_spawning";
		this.m.Title = "Meanwhile...";
		this.m.IsSpecial = true;
		this.m.Cooldown = 99999 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_73.png[/img]As you're taking a nap, the now familiar face of Kemmler the Necromancer fills your vision. %SPEECH_ON% Greetings yet again. You mortals really are a blight. Your scuffed settlements litter the earth like open wounds. I've decided to remove a particularly egregious example, a sorry assembly of dilapidated houses called %townname%. Try to save it if you must, I do not care either way. %SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "What shall we do?",
					function getResult( _event )
					{

						return 0;
					}

				}
			],
			function start( _event )
			{
				local marshall = {
				ID = this.Const.EntityType.ZombieKnight,
				Variant = 1,
				Strength = 30,
				Cost = 24,
				Row = -1,
				Script = "scripts/entity/tactical/enemies/zombie_knight",
				NameList = ["Gawain, Lieutenant of the Undead"],
				TitleList = null
				}
				local undead = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead)
				local party = undead.spawnEntity(_event.m.Startpoint.getTile(), "Undead", false, this.Const.World.Spawn.UndeadScourge, 300 *_event.getScaledDifficultyMult());
				this.Const.World.Common.addTroop(party, {Type = marshall}, false, 100);
				party.getSprite("banner").setBrush(_event.m.Startpoint.getBanner());
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
				party.getLoot().ArmorParts = this.Math.rand(20, 30);
				party.getSprite("selection").Visible = true;
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false)

				local raid = this.new("scripts/ai/world/orders/mod_convert_order");
				raid.setOnce()
				raid.setTime(60.0);
				raid.setTargetTile(_event.m.Destination.getTile());
				raid.setTargetID(_event.m.Destination.getID());
				c.addOrder(raid);
			}

		});
	}

	function getScaledDifficultyMult()
	{
		local s = this.Math.maxf(0.5, 0.6 * this.Math.pow(0.01 * this.World.State.getPlayer().getStrength(), 0.9));
		local d = this.Math.minf(4.0, s + this.Math.minf(1.0, this.World.getTime().Days * 0.01));
		return d * this.Const.Difficulty.EnemyMult[this.World.Assets.getCombatDifficulty()];
	}

	function onPrepare()
	{
		local necropolis;
		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				this.m.Startpoint = location
				break;
			}
		}
		this.m.News = this.World.Statistics.popNews("necropolis_soon_spawning");
		local potentialDestinations = []
		foreach (settlement in this.World.EntityManager.getSettlements())
		{
			if (settlement.getSize() == 1 && !settlement.isMilitary())
			{
				potentialDestinations.push(settlement)
			}
		}
		if (potentialDestinations.len() > 0){
			this.m.Destination = this.WeakTableRef(potentialDestinations[this.Math.rand(0, potentialDestinations.len()-1)])
		}
		else this.m.Destination = this.WeakTableRef(this.World.EntityManager.getSettlements()[this.Math.rand(0, this.World.EntityManager.getSettlements().len()-1)])
	}
	function onUpdateScore()
	{
		if (this.World.Statistics.hasNews("necropolis_soon_spawning"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
		"townname",
		this.m.Destination == null || this.m.Destination.isNull() ? "" : this.m.Destination.getName()
		])
	}

	function onClear()
	{
		this.m.News = null
		this.m.Destination = null
		this.m.Startpoint = null
	}

});

