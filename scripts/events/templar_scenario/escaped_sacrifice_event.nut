this.escaped_sacrifice_event <- this.inherit("scripts/events/event", {
	m = {
		Dude = null,
		Victim = null
	},
	function create()
	{
		this.m.ID = "event.escaped_sacrifice";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_118.png[/img]{The Company discovers an unconscious man partially hidden in a thicket on the side of the road.  He looks in rough shape, bleeding from several cuts and with multiple deep abrasions.  Most concerning of all is a rune carved into the flesh of his forehead that seems to pulse a soft red below the dried blood crusted over it.  With a start the man awakens as he becomes aware of your presence, he screams something unintelligible and then becomes more composed.  His eyes seem to fade in and out of focus, and you can see the pulse on his neck throb.  Ominously, you also can not fail to notice blood oozing from an oddly shape puncture wound on his neck.%SPEECH_ON%Seems I have escaped!  Give me a weapon, let me join you, I am strong, you will see.%SPEECH_OFF%}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "You look to have a strong arm and seem to be a survivor, if you can fight you can stay.",
					function getResult( _event )
					{
						return this.Math.rand(1, 100) <= 60 ? "B" : "C";
					}

				},
				{
					Text = "We have enough troubles, give him some food and water and send him on his way.",
					function getResult( _event )
					{
						this.World.getTemporaryRoster().clear();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				local party_difficulty = 200
				local nearest_beasts = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead)
				local nearest_spawn = nearest_beasts.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = nearest_beasts.spawnEntity(nearest_spawn.getTile(), "Sacrifice Hunters", false, this.Const.World.Spawn.Direwolves, party_difficulty);
				party.setDescription("Sacrifice Hunters.");
				party.setFootprintType(this.Const.World.FootprintsType.Direwolves);
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.VampireLOW
				}, false, 0);
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.Alp
				}, false, 0);
				party.setAttackableByAI(false);
				local c = party.getController();
				c.getBehavior(this.Const.World.AI.Behavior.ID.Flee).setEnabled(false);
				c.getBehavior(this.Const.World.AI.Behavior.ID.Attack).setEnabled(false);
				local destroy = this.new("scripts/ai/world/orders/intercept_order");
				destroy.setTarget(this.World.State.getPlayer());
				c.addOrder(destroy);
			
				local roster = this.World.getTemporaryRoster();
				_event.m.Dude = roster.create("scripts/entity/tactical/player");
				_event.m.Dude.setStartValuesEx([
					"raider_background"
				]);
				_event.m.Dude.getBackground().m.RawDescription = "Running from some unknown pursuers for some time, %name% was discovered by the company and promptly volunteered, if seemingly only to get a weapon.";
				_event.m.Dude.getBackground().buildDescription(true);
				
				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Mainhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Offhand).removeSelf();
				}

				if (_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head) != null)
				{
					_event.m.Dude.getItems().getItemAtSlot(this.Const.ItemSlot.Head).removeSelf();
				}
				
				this.Characters.push(_event.m.Dude.getImagePath());
				}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_118.png[/img]{It would be easy to abandon this man to his fate, but beneath the grime, blood, and lacerations you see older scars, scars only seen on an experienced warrior.  You give him a weapon and nod your head in approval as you see how he gripped it with an experienced ease. %victim% keeps an eye on them for a time, but he reports that the newcomer seems true to his word and will fight.}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Welcome to the %companyname%!",
					function getResult( _event )
					{
						this.World.getPlayerRoster().add(_event.m.Dude);
						this.World.getTemporaryRoster().clear();
						_event.m.Dude.onHired();
						_event.m.Dude = null;
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Dude.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_05.png[/img]{It would be easy to abandon this man to his fate, but beneath the grime, blood, and lacerations you see older scars, scars only seen on an experienced warrior.  You give him a weapon and nod your head in approval as you see how he gripped it with an experienced ease. %victim% is assigned to keep an eye on him and to help him get acclimated. Except you don\'t see your sellsword for a suspicious length of time. When you go looking, he\'s found knocked out on the ground and the inventory ransacked. The newcomer is nowhere to be seen!}",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "That man is terrified of something, we are better off without him!",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.World.getTemporaryRoster().clear();
				_event.m.Dude = null;
				local injury = _event.m.Victim.addInjury(this.Const.Injury.Concussion);
				this.List.push({
					id = 10,
					icon = injury.getIcon(),
					text = _event.m.Victim.getName() + " suffers " + injury.getNameOnly()
				});
				local r = this.Math.rand(1, 4);

				if (r == 1)
				{
					local food = this.World.Assets.getFoodItems();
					food = food[this.Math.rand(0, food.len() - 1)];
					this.World.Assets.getStash().remove(food);
					this.List.push({
						id = 10,
						icon = "ui/items/" + food.getIcon(),
						text = "You lose " + food.getName()
					});
				}
				else if (r == 2)
				{
					local amount = this.Math.rand(20, 50);
					this.World.Assets.addAmmo(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_ammo.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Ammunition"
					});
				}
				else if (r == 3)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addArmorParts(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_supplies.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Tools and Supplies"
					});
				}
				else if (r == 4)
				{
					local amount = this.Math.rand(5, 10);
					this.World.Assets.addMedicine(-amount);
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_medicine.png",
						text = "You lose [color=" + this.Const.UI.Color.NegativeEventValue + "]-" + amount + "[/color] Medical Supplies"
					});
				}

				this.Characters.push(_event.m.Victim.getImagePath());
			}

		});
	}

	function onUpdateScore()
	{
		if (!this.Const.DLC.Wildmen)
		{
			return;
		}

		if (this.World.Assets.getOrigin().getID() != "scenario.undead_hunters")
		{
			return;
		}

		        
		if (this.World.getTime().Days <= 25)
		{
			return;
		}

		if (this.World.getPlayerRoster().getSize() + 1 >= this.World.Assets.getBrothersMax())
		{
			return;
		}

		local roster = this.World.getPlayerRoster().getAll();
		this.m.Victim = roster[this.Math.rand(0, roster.len() - 1)];
		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"victim",
			this.m.Victim.getName()
		]);
	}

	function onClear()
	{
		this.m.Dude = null;
		this.m.Victim = null;
	}

});

