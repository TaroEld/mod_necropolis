this.undead_hunters_scenario <- this.inherit("scripts/scenarios/world/starting_scenario", {
	m = {},
	function create()
	{
		this.m.ID = "scenario.undead_hunters";
		this.m.Name = "Undead Hunters";
		this.m.Description = "[p=c][img]gfx/ui/events/event_132.png[/img][/p][p]After years of training, devotion, and honorable service focused on the destruction of the undead menace the Grand Master has assigned you to an important mission.  You are to assemble a Company and see if there is any truth to the rumors of an undead city and the potential brooding evil entity harbored within. With you are two experienced allies who have also seen the face of the undead menace and proven their worth.\n\n[color=#bcad8c]A quick start into the world, with better starting equipment but no other particular advantages or disadvantages.[/color][/p]";
		this.m.Difficulty = 1;
		this.m.Order = 17;
	}

	function onSpawnAssets()
	{
		local roster = this.World.getPlayerRoster();
		local names = [];

		for( local i = 0; i < 3; i = ++i )
		{
			local bro;
			bro = roster.create("scripts/entity/tactical/player");
			bro.m.HireTime = this.Time.getVirtualTimeF();
			bro.improveMood(1.5, "Assigned a holy mission");

			while (names.find(bro.getNameOnly()) != null)
			{
				bro.setName(this.Const.Strings.CharacterNames[this.Math.rand(0, this.Const.Strings.CharacterNames.len() - 1)]);
			}

			names.push(bro.getNameOnly());
		}

		local bros = roster.getAll();
		bros[0].setTitle("The Templar");
		bros[0].getSkills().add(this.new("scripts/skills/traits/hate_undead_trait"))
		bros[0].getSkills().add(this.new("scripts/skills/traits/player_character_trait"));
		bros[0].getFlags().set("IsPlayerCharacter", true);
		bros[0].m.PerkPoints = 0;
		bros[0].m.LevelUps = 0;
		bros[0].m.Level = 1;
		bros[0].setStartValuesEx([
			"templar_background"
		]);
		bros[0].getBackground().m.RawDescription = "{You saved %name%\'s life in a battle against necrosavants, and he returned the favor in a wooded ambush by hexen. Given that hexen are a few levels beneath necrosavants, you often joke with him that he is still a little behind on the \'saving each other\'s asses\' debt.}";
		bros[0].setPlaceInFormation(3);
		bros[1].setStartValuesEx([
			"witchhunter_background"
		]);
		bros[1].getBackground().m.RawDescription = "{Whatever is wrong with %name% you hope he never fixes it. A character with a particular fixation and hatred of the occult.  He has proven relentless and ruthless in his quest to hunt down and eliminate the undead and their allies.  There is rumored to be a dark event in his past, but no one dares ask about it.}";
		bros[1].setPlaceInFormation(4);
		bros[2].setStartValuesEx([
			"graverobber_background"
		]);
		bros[2].getBackground().m.RawDescription = "You crossed paths with %name% a number of times prior to selecting him to join the company. He has made quite a name for himself within the Order by using his professional skills to track down, locate, and put to rest several dangerous foes.  He also seems to have made himself a bit of coin as well.";
		bros[2].setPlaceInFormation(5);
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/supplies/ground_grains_item"));
		this.World.Assets.getStash().add(this.new("scripts/items/tools/holy_water_item"));
		this.World.Assets.m.Money = this.World.Assets.m.Money + 400;
	}

	function onSpawnPlayer()
	{
		local scriptFiles = this.IO.enumerateFiles("scripts/events/templar_scenario/")
		foreach (i, scriptFile in scriptFiles)
		{
			this.World.Events.m.Events.push(this.new(scriptFile))
		}
		local randomVillage;

		for( local i = 0; i != this.World.EntityManager.getSettlements().len(); i = ++i )
		{
			randomVillage = this.World.EntityManager.getSettlements()[i];

			if (!randomVillage.isMilitary() && !randomVillage.isIsolatedFromRoads() && randomVillage.getSize() >= 3 && !randomVillage.isSouthern())
			{
				break;
			}
		}

		local randomVillageTile = randomVillage.getTile();
		local navSettings = this.World.getNavigator().createSettings();
		navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost_Flat;

		do
		{
			local x = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.X - 4), this.Math.min(this.Const.World.Settings.SizeX - 2, randomVillageTile.SquareCoords.X + 4));
			local y = this.Math.rand(this.Math.max(2, randomVillageTile.SquareCoords.Y - 4), this.Math.min(this.Const.World.Settings.SizeY - 2, randomVillageTile.SquareCoords.Y + 4));

			if (!this.World.isValidTileSquare(x, y))
			{
			}
			else
			{
				local tile = this.World.getTileSquare(x, y);

				if (tile.Type == this.Const.World.TerrainType.Ocean || tile.Type == this.Const.World.TerrainType.Shore || tile.IsOccupied)
				{
				}
				else if (tile.getDistanceTo(randomVillageTile) <= 1)
				{
				}
				else
				{
					local path = this.World.getNavigator().findPath(tile, randomVillageTile, navSettings, 0);

					if (!path.isEmpty())
					{
						randomVillageTile = tile;
						break;
					}
				}
			}
		}
		while (1);

		this.World.State.m.Player = this.World.spawnEntity("scripts/entity/world/player_party", randomVillageTile.Coords.X, randomVillageTile.Coords.Y);
		this.World.getCamera().setPos(this.World.State.m.Player.getPos());
		this.Time.scheduleEvent(this.TimeUnit.Real, 1000, function ( _tag )
		{
			this.Music.setTrackList(this.Const.Music.IntroTracks, this.Const.Music.CrossFadeTime);
			this.World.Events.fire("event.undead_hunters_scenario_intro");
		}, null);
	}

});

