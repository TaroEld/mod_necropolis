this.necropolis_town_destroyed_event <- this.inherit("scripts/events/event", {
	m = {
		News = null
	},
	function create()
	{
		this.m.ID = "event.crisis.necropolis_town_destroyed";
		this.m.Title = "Along the road...";
		this.m.Cooldown = 7.0 * this.World.getTime().SecondsPerDay;
		this.m.IsSpecial = true;
		this.m.Screens.push({
			ID = "A",
			Text = "[img]gfx/ui/events/event_99.png[/img]A messenger rushes past, and just remembers to toss you a letter. It says that %city% has been razed by undead forces bearing the mark of Kemmler. It will take a while before anything can live there again.",
			Image = "",
			List = [],
			Characters = [],
			Options = [
				{
					Text = "Kemmler must be stopped.",
					function getResult( _event )
					{
						return 0;
					}

				}
			],
			function start( _event )
			{
				if (this.World.Assets.isPermanentDestruction()){
					this.Text = "A messenger rushes past, and just remembers to toss you a letter. It says that %city% has been taken over by undead forces bearing the mark of Kemmler. Dark creatures now roam the countryside."
				}
			}

		});
	}

	function onUpdateScore()
	{

		if (this.World.Statistics.hasNews("necropolis_town_destroyed"))
		{
			this.m.Score = 2000;
		}
	}

	function onPrepare()
	{
		this.m.News = this.World.Statistics.popNews("necropolis_town_destroyed");
	}

	function onPrepareVariables( _vars )
	{
		_vars.push([
			"city",
			this.m.News.get("City")
		]);
	}

	function onClear()
	{
		this.m.News = null;
	}

});

