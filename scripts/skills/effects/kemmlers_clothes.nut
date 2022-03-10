this.kemmlers_clothes <- this.inherit("scripts/skills/skill", {
	m = {
		Cooldown = 3
	},
	function create()
	{
		this.m.ID = "effects.kemmlers_clothes";
		this.m.Name = "Draw the Undead";
		this.m.Description = "Undead souls are periodically dragged back to the battlefield to fight on the users side"
		this.m.Icon = "ui/perks/perk_37.png";
		this.m.IconMini = "perk_37_mini";
		this.m.Overlay = "perk_37";
		this.m.SoundOnHit = [
			"sounds/enemies/necromancer_01.wav",
			"sounds/enemies/necromancer_02.wav",
			"sounds/enemies/necromancer_03.wav"
		];
		this.m.SoundVolume = 1.2;
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onNewRound()
	{
		if (--this.m.Cooldown <= 0 && this.reviveCorpse())
		{
			this.m.Cooldown = 2;
		}
	}

	function reviveCorpse()
	{
		local corpses = this.Tactical.Entities.getCorpses();

		if (corpses.len() == 0)
		{
			return false
		}

		local potentialCorpses = [];

		foreach( c in corpses )
		{
			if (!c.IsEmpty)
			{
				continue;
			}

			if (!c.IsCorpseSpawned || !c.Properties.get("Corpse").IsResurrectable)
			{
				continue;
			}
			potentialCorpses.push(c);
		}
		if (potentialCorpses.len() == 0)
		{
			return false
		}
		local corpse = potentialCorpses[this.Math.rand(0, potentialCorpses.len()-1)]
		return this.onUse(this.getContainer().getActor(), corpse)

	}

	function spawnUndead( _user, _tile )
	{
		local p = _tile.Properties.get("Corpse");
		//p.Faction = 2;
		p.Faction = _user.getFaction();
		local e = this.Tactical.Entities.onResurrect(p, true);

		if (e != null)
		{
			e.getSprite("socket").setBrush(_user.getSprite("socket").getBrush().Name);
			local dieAfterCombat = this.new("scripts/skills/effects/dieAfterCombat")
			e.getSkills().add(dieAfterCombat)
		}
		return true;
	}

	function onUse( _user, _targetTile )
	{
		if (_targetTile.IsVisibleForPlayer)
		{
			if (this.Const.Tactical.RaiseUndeadParticles.len() != 0)
			{
				for( local i = 0; i < this.Const.Tactical.RaiseUndeadParticles.len(); i = ++i )
				{
					this.Tactical.spawnParticleEffect(true, this.Const.Tactical.RaiseUndeadParticles[i].Brushes, _targetTile, this.Const.Tactical.RaiseUndeadParticles[i].Delay, this.Const.Tactical.RaiseUndeadParticles[i].Quantity, this.Const.Tactical.RaiseUndeadParticles[i].LifeTimeQuantity, this.Const.Tactical.RaiseUndeadParticles[i].SpawnRate, this.Const.Tactical.RaiseUndeadParticles[i].Stages);
				}
			}

			if (_user.isDiscovered() && (!_user.isHiddenToPlayer() || _targetTile.IsVisibleForPlayer))
			{
				this.Tactical.EventLog.log("The magic of " + this.Const.UI.getColorizedEntityName(_user) + "'s clothes draws the Undead!");

				if (this.m.SoundOnHit.len() != 0)
				{
					this.Sound.play(this.m.SoundOnHit[this.Math.rand(0, this.m.SoundOnHit.len() - 1)], this.Const.Sound.Volume.Skill * 1.2, _user.getPos());
				}
			}
		}

		return this.spawnUndead(_user, _targetTile);
	}

});

