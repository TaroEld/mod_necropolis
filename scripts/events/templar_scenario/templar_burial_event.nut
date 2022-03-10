this.templar_burial_event <- this.inherit("scripts/events/event", {
	m = {
	    Templar = null,
		Location = null
	},
	
	function create()
	{
		this.m.ID = "event.templar_burial";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_88.png[/img]While on the road, you come across some members of your Order marching wearily along the road. They look like they have come from a battlefield, and seem to have been on the losing side. Getting closer, you realize that it\'s a Company led by your old mentor. One of the battered templars shakes his head and seems to recognize you.%SPEECH_ON%We have been looking for you.  Your former Master is dying and he wanted us to deliver something to you.%SPEECH_OFF%You shake your head and start cutting into the crowd, making for the wagon that seems to hold the wounded and the dead. You find your former Master, blood spattered and pale as death, barely breathing and eyes closed to mear slits. He\'s grasping a terrifically sharp and glinting cleaver, a weapon with faintly glowing ruins seeming to pulse ever more slowly with the weakening beat of your Masters heart. %randombrother% joins your side and whispers.%SPEECH_ON%He wanted us to find you, says that you will need his weapon, now your weapon, in the difficult times to come.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Rest easy friend, I shall complete your mission.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 100 ? "B" : "C";
					}

				},
				{
					Text = "Rest in peace.",
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
			Text = "[img]gfx/ui/events/event_36.png[/img]You draw out your sword and fall to your knees, sword point embedded in the ground before you, and the rest of the company does the same. One of the wounded Templars steps forward.%SPEECH_ON%The Master is dead, the weapon is now yours.%SPEECH_OFF%Sheathing your sword, you give him your thanks. The man laughs wryly.%SPEECH_ON%The evil is out there, growing in strength.  They caught us by surprise so now it is your turn, avenge us and put an end to this malevolent being%SPEECH_OFF%You slowly take the cleaver, noting with unease the sudden blaze to the runes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We will complete your mission, and put an end to this evil.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				local item = this.new("scripts/items/weapons/named/named_rusty_warblade");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_36.png[/img]You draw out your sword and fall to your knees, sword point embedded in the ground before you, and the rest of the company does the same. One of the wounded Templars steps forward.%SPEECH_ON%The Master is dead, the weapon is now yours.%SPEECH_OFF%Sheathing your sword, you give him your thanks. The man laughs wryly.%SPEECH_ON%The evil is out there, growing in strength.  They caught us by surprise so now it is your turn, avenge us and put an end to this malevolent being%SPEECH_OFF%You slowly take the cleaver, noting with unease the sudden blaze to the runes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We will complete your mission, and put an end to this evil.",
					function getResult( _event )
					{
						return "D";
					}

				},
				{
					Text = "The crone is right, we shan\'t disturb the burial any further.",
					function getResult( _event )
					{
						return "E";
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-0);
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_36.png[/img]You draw out your sword and fall to your knees, sword point embedded in the ground before you, and the rest of the company does the same. One of the wounded Templars steps forward.%SPEECH_ON%The Master is dead, the weapon is now yours.%SPEECH_OFF%Sheathing your sword, you give him your thanks. The man laughs wryly.%SPEECH_ON%The evil is out there, growing in strength.  They caught us by surprise so now it is your turn, avenge us and put an end to this malevolent being%SPEECH_OFF%You slowly take the cleaver, noting with unease the sudden blaze to the runes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We will complete your mission, and put an end to this evil.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(-0);
				local item = this.new("scripts/items/weapons/named/named_rusty_warblade");
				item.setCondition(27.0);
				this.World.Assets.getStash().add(item);
				this.List.push({
					id = 10,
					icon = "ui/items/" + item.getIcon(),
					text = "You gain " + this.Const.Strings.getArticle(item.getName()) + item.getName()
				});
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_36.png[/img]You draw out your sword and fall to your knees, sword point embedded in the ground before you, and the rest of the company does the same. One of the wounded Templars steps forward.%SPEECH_ON%The Master is dead, the weapon is now yours.%SPEECH_OFF%Sheathing your sword, you give him your thanks. The man laughs wryly.%SPEECH_ON%The evil is out there, growing in strength.  They caught us by surprise so now it is your turn, avenge us and put an end to this malevolent being%SPEECH_OFF%You slowly take the cleaver, noting with unease the sudden blaze to the runes.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "We will complete your mission, and put an end to this evil.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.Assets.addMoralReputation(5);
			}

		});
	}

	function onUpdateScore()
	{
		if (this.World.Assets.getOrigin().getID() != "scenario.undead_hunters")
		{
			return;
		}
		if (!this.World.getTime().IsDaytime)
		{
			return;
		}

		if (this.World.getTime().Days <= 30)
		{
			return;
		}

		local currentTile = this.World.State.getPlayer().getTile();

		if (!currentTile.HasRoad)
		{
			return;
		}

		if (currentTile.Type == this.Const.World.TerrainType.Snow || currentTile.Type == this.Const.World.TerrainType.Forest || currentTile.Type == this.Const.World.TerrainType.LeaveForest || currentTile.Type == this.Const.World.TerrainType.SnowyForest)
		{
			return;
		}

		if (!this.World.Assets.getStash().hasEmptySlot())
		{
			return;
		}

		this.m.Score = 1000;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
	}

	function onClear()
	{
	    this.m.Templar = null;
	    this.m.Location = null;
	}

});

