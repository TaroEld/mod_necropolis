this.dieAfterCombat <- this.inherit("scripts/skills/skill", {
	m = {
	},
	function create()
	{
		this.m.ID = "effects.dieAfterCombat";
		this.m.Name = "Die after Combat";
		this.m.Description = "Undead souls are periodically dragged back to the battlefield to fight on the users side"
		this.m.Icon = "ui/perks/perk_37.png";
		this.m.Overlay = "perk_37";
		this.m.Type = this.Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
	}

	function onCombatFinished()
	{
		local actor = this.getContainer().getActor()
		if (actor != null && actor.isAlive())
		{
			actor.killSilently()
		}
		this.skill.onCombatFinished()
	}

});

