this.templar_character_offered_map_event <- this.inherit("scripts/events/event", {
	m = {
		Templar = null,
		Thief = null,
		Peddler = null,
		Cost = 0,
		PricePaid = 0,
		Location = null
	},
	function create()
	{
		this.m.ID = "event.templar_character_offered_map";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 9999.0 * this.World.getTime().SecondsPerDay;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_41.png[/img]While marching along, a lone merchant with his packhorse emerges onto your path. He has his arms out and his hands visible, he looks exhausted.%SPEECH_ON%Evening, travelers. Might I camp with you tonight?  I will give you a discount on my wares?%SPEECH_OFF%He details a story of woe, how the caravan he was traveling with was attacked the previous night by some unkown force and how he barely escaped with his life.  He is obviously petrified, and is looking for protection.  He lists off a number of things the %companyname% could possibly have no use for, but then he mentions a map. He notes your interest and lowers his voice to a whisper.%SPEECH_ON%Interested in a map are ya? This here map is supposed to show the location of a once great city, now rumored to have fallen to the undead.  I have been assured that it is full of treasure, and the undead legend is just rumor to scare off adventurers! This here paper tells you the exact location of the famous \'%location%\'. Resting place of some this world\'s finest arms! And all it\'ll cost you is a meager %mapcost% crowns!  Truth be told I want to be rid of the cursed thing.%SPEECH_OFF%He eyes dart around, as if looking for ghosts, he seems on the verge of a breakdown.%SPEECH_ON%So, will you take it off my hands for a small fee?%SPEECH_OFF%",
			Image = "",
			List = [],
			Options = [
				{
					Text = "I\'m intrigued, we\'ll buy the map.",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost);
						_event.m.PricePaid = _event.m.Cost;

						if (_event.m.Templar != null)
						{
							return "B";
						}
						else {
							return "C"
						}
					}

				},
				{
					Text = "Not interested.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{

				local party_difficulty = 200
				local nearest_zombie = this.World.FactionManager.getFactionOfType(this.Const.FactionType.Undead)
				local nearest_spawn = nearest_zombie.getNearestSettlement(this.World.State.getPlayer().getTile());
				local party = nearest_zombie.spawnEntity(nearest_spawn.getTile(), "Map Hunters", false, this.Const.World.Spawn.ZombiesAndGhosts, party_difficulty);
				party.setDescription("Undead Map Hunters.");
				party.setFootprintType(this.Const.World.FootprintsType.Undead);
				this.Const.World.Common.addTroop(party, {
					Type = this.Const.World.Spawn.Troops.ZombieKnight
				}, true, 100);
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
				if (_event.m.Peddler != null)
				{
					this.Options.push({
						Text = "%peddler%, you used to be a peddler. Get us a better deal!",
						function getResult( _event )
						{
							return "E";
						}

					});
				}

				if (_event.m.Thief != null)
				{
					this.Options.push({
						Text = "%thief%, you used to be a thief. Get us that map!",
						function getResult( _event )
						{
							return "F";
						}

					});
				}
			}

		});
		this.m.Screens.push({
			ID = "B",
			Text = "[img]gfx/ui/events/event_45.png[/img]Having acquired the map, you take a good long look at it. You take out your own map and start looking between the two. There\'s nothing on the purchased map that can be cross-referenced. In fact, the map you bought has strange runes scribbled at the edges. It\'s either a recent fake, or it originated in a time when the common tongue was not your own. The map was cleverly drawn so that the only way to decipher it is to know how to read the ruins, otherwise it would be totally unusable.\n\n As you roll the map out flat to get a better look you notice blood on the corners, and it is now smeared on your hands.  As you look at the runes it begins to make sense, you run your fingers along the edges before drawing them further inward, amongst the map\'s poorly drawn mountains and rivers and forests.%SPEECH_ON%Hmmm... Oh... Ah yes, I\'ve read of this place before. And I know these runes, though I dare not speak them aloud.%SPEECH_OFF%You take the company map and use three quill pens pinched between your fingers to slowly triangulate and translate the directions. Once finished you nod gravely and whack the back of your hand against the company map.%SPEECH_ON%There you are, we will be coming for you.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "The peddler is afraid, and the blood on the map is an ominous sign.",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Templar.getImagePath());

				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Crowns"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "C",
			Text = "[img]gfx/ui/events/event_45.png[/img]You take the map and give it a good read. You can identify some of the locations and, in time, translate its contents onto your own map. The %companyname% is murmuring with excitement over what might be there.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "Let\'s claim it for the company!",
					function getResult( _event )
					{
						this.World.uncoverFogOfWar(_event.m.Location.getTile().Pos, 700.0);
						_event.m.Location.getFlags().set("IsEventLocation", true);
						_event.m.Location.setDiscovered(true);
						this.World.getCamera().moveTo(_event.m.Location);
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Crowns"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "D",
			Text = "[img]gfx/ui/events/event_45.png[/img]You look at the map, you stare at it, you practically interrogate it with a long, long gaze. But you\'re just not seeing it. %randombrother% takes a look then shakes his head.%SPEECH_ON%I don\'t recognize a bit of it, sir.%SPEECH_OFF%It\'s a fake or a map to a land you do not recognize as your own - either way, it\'s completely useless.",
			Image = "",
			List = [],
			Options = [
				{
					Text = "We\'ve been had.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (_event.m.PricePaid != 0)
				{
					this.List.push({
						id = 10,
						icon = "ui/icons/asset_money.png",
						text = "You spend [color=" + this.Const.UI.Color.NegativeEventValue + "]" + _event.m.PricePaid + "[/color] Crowns"
					});
				}
			}

		});
		this.m.Screens.push({
			ID = "E",
			Text = "[img]gfx/ui/events/event_41.png[/img]%peddler% the peddler steps forward, his hands out just like the traveling merchant\'s had been. Apparently this is a common tactic amongst honest thieves.%SPEECH_ON%Sir, sir, please. Come on. That price is outrageous.%SPEECH_OFF%The merchant\'s face sours.%SPEECH_ON%There is nothing outrageous about it, I promise you.%SPEECH_OFF%But your peddler persists.%SPEECH_ON%Clearly there is something outrageous, because I just said so, did I not?%SPEECH_OFF%The merchant nods. The peddler continues.%SPEECH_ON%So we\'ve decided to not purchase it at your original asking price. That much is clear. So, friend, I think we will purchase it for %newcost%. That is fair to all parties involved, and surely a fine businessman such as yourself can see a deal! We\'re hardly businessmen ourselves, but we know that\'s a good deal!%SPEECH_OFF%The merchant scratches his chin, then nods.%SPEECH_ON%Alright, that price is fair.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "A better bargain!",
					function getResult( _event )
					{
						this.World.Assets.addMoney(-_event.m.Cost / 2);
						_event.m.PricePaid = _event.m.Cost / 2;

						if (_event.m.Templar != null)
						{
							return "B";
						}
						else {
							return "C"
						}
					}

				},
				{
					Text = "Still not worth it.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Peddler.getImagePath());
			}

		});
		this.m.Screens.push({
			ID = "F",
			Text = "[img]gfx/ui/events/event_41.png[/img]While you\'re talking to the merchant, %thief% the thief sidles up next to you, appearing rather interested in the conversation. He glances at you. You do a double take. He grins and nods. You quickly eye the salesman then glance back at the thief and nod. The merchant is in the middle of his sales pitch and sees none of this. He keeps talking, but you hear little of it. You just know to keep nodding for a merchant such as he only tells you things you want to hear anyway.\n\n The thief slips around the back and drops a weapon into the mud.%SPEECH_ON%Clumsy me.%SPEECH_OFF%He bends down, pauses, there\'s a motion you can hardly detect, and then he\'s upright again. He gives you a wink. You tell the merchant you appreciate the offer, but you\'ll have to pass. When he\'s gone, %thief% presents you with the map and grins.%SPEECH_ON%They say the best things in life are free.%SPEECH_OFF%",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Now that\'s what I call a discount.",
					function getResult( _event )
					{
						if (_event.m.Templar != null)
						{
							return "B";
						}
						else {
							return "C"
						}
					}

				}
			],
			function start( _event )
			{
				this.Characters.push(_event.m.Thief.getImagePath());
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

		if (this.World.getTime().Days < 50)
		{
			return;
		}

		if (this.World.Assets.getMoney() <= 1000)
		{
			return;
		}

		if (this.World.State.getEscortedEntity() != null)
		{
			return;
		}

		foreach (location in this.World.EntityManager.getLocations()){
			if (location.getTypeID() == "location.mod_necropolis"){
				this.m.Location = this.WeakTableRef(location)
				break;
			}
		}
		if (this.m.Location == null) return
		if (this.m.Location.isDiscovered()) return 

		local brothers = this.World.getPlayerRoster().getAll();
		local candidates_peddler = [];
		local candidates_thief = [];
		local candidates_templar = [];

		foreach( bro in brothers )
		{
			if (bro.getBackground().getID() == "background.templar")
			{
				candidates_templar.push(bro);
			}
			else if (bro.getBackground().getID() == "background.thief")
			{
				candidates_thief.push(bro);
			}
			else if (bro.getBackground().getID() == "background.peddler")
			{
				candidates_peddler.push(bro);
			}
		}

		if (candidates_templar.len() != 0)
		{
			this.m.Templar = candidates_templar[this.Math.rand(0, candidates_templar.len() - 1)];
		}

		if (candidates_thief.len() != 0)
		{
			this.m.Thief = candidates_thief[this.Math.rand(0, candidates_thief.len() - 1)];
		}

		if (candidates_peddler.len() != 0)
		{
			this.m.Peddler = candidates_peddler[this.Math.rand(0, candidates_peddler.len() - 1)];
		}

		this.m.Cost = this.Math.rand(6, 14) * 10;
		this.m.Score = 500;
	}

	function onPrepare()
	{
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"templar",
			this.m.Templar != null ? this.m.Templar.getNameOnly() : ""
		]);
		_vars.push([
			"peddler",
			this.m.Peddler != null ? this.m.Peddler.getNameOnly() : ""
		]);
		_vars.push([
			"thief",
			this.m.Thief != null ? this.m.Thief.getNameOnly() : ""
		]);
		_vars.push([
			"location",
			this.m.Location.getName()
		]);
		_vars.push([
			"mapcost",
			this.m.Cost
		]);
		_vars.push([
			"newcost",
			this.m.Cost / 2
		]);
	}

	function onClear()
	{
		this.m.Templar = null;
		this.m.Thief = null;
		this.m.Peddler = null;
		this.m.Location = null;
	}

});

