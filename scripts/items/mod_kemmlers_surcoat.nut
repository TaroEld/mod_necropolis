this.mod_kemmlers_surcoat <- this.inherit("scripts/items/armor/named/named_armor", {
	m = {},
	function create()
	{
		this.named_armor.create();
		this.m.ID = "armor.body.mod_kemmlers_surcoat";
		this.m.Name = "Kemmler's Surcoat";
		this.m.Description = "A dark padded leather mantle, previously owned by Kemmler. Magic has been woven into the fiber.";
		this.m.IsDroppedAsLoot = true;
		this.m.ShowOnCharacter = true;
		this.m.Variant = 61;
		this.updateVariant();
		this.m.ImpactSound = this.Const.Sound.ArmorLeatherImpact;
		this.m.InventorySound = this.Const.Sound.ClothEquip;
		this.m.Value = 5500;
		this.m.Condition = 160;
		this.m.ConditionMax = 160;
		this.m.StaminaModifier = -15;
		this.randomizeValues();
	}
	function updateVariant()
	{
		local variant = this.m.Variant > 9 ? this.m.Variant : "0" + this.m.Variant;
		this.m.Sprite = "bust_" + this.m.VariantString + "_" + variant;
		this.m.SpriteDamaged = "bust_" + this.m.VariantString + "_" + variant + "_damaged";
		this.m.SpriteCorpse = "bust_" + this.m.VariantString + "_" + variant + "_dead";
		this.m.IconLarge = "armor/inventory_" + this.m.VariantString + "_armor_" + "615" + ".png";
		this.m.Icon = "armor/icon_" + this.m.VariantString + "_armor_" + "615" + ".png";
	}

	function onEquip()
	{
		this.named_armor.onEquip();
		local body = this.getContainer().getItemAtSlot(this.Const.ItemSlot.Head)
		if(body != null && body.m.ID == "armor.head.mod_kemmlers_cowl")
		{
			local skillToAdd = this.new("scripts/skills/effects/kemmlers_clothes");
			this.addSkill(skillToAdd);
		}		
	}
});

