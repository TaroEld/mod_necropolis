this.mod_kemmlers_cowl <- this.inherit("scripts/items/helmets/named/named_helmet", {
	m = {},
	function create()
	{
		this.named_helmet.create()
		this.m.ID = "armor.head.mod_kemmlers_cowl";
		this.m.Name = "Kemmler's Cowl";
		this.m.Description = "A hat and cowl, previously owned by Kemmler. Magic has been woven into the fiber.";
		this.m.ShowOnCharacter = true;
		this.m.HideHair = true;
		this.m.HideBeard = false;
		this.m.ReplaceSprite = true;
		this.m.Variant = 62;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 2000;
		this.m.Condition = 140;
		this.m.ConditionMax = 140;
		this.m.StaminaModifier = -8;
		this.randomizeValues();
	}
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_" + this.m.VariantString + "_" + variant;
		this.m.SpriteDamaged = "bust_" + this.m.VariantString + "_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_" + this.m.VariantString + "_" + variant + "_dead";
		this.m.IconLarge = "";
		this.m.Icon = "helmets/inventory_" + this.m.VariantString + "_" + "615" + ".png";
	}

	function onEquip()
	{
		this.named_helmet.onEquip();
		local body = this.getContainer().getItemAtSlot(this.Const.ItemSlot.Body)
		if(body != null && body.m.ID == "armor.body.mod_kemmlers_surcoat")
		{
			local skillToAdd = this.new("scripts/skills/effects/kemmlers_clothes");
			this.addSkill(skillToAdd);
		}		
	}

});

