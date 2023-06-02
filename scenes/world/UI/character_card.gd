extends Control

@onready var CharacterName = $Name
@onready var Level = $Level
@onready var HPBar = $HealthBar
@onready var HPLabel = $HP
@onready var STR = $Stats/STRValue
@onready var DEX = $Stats/DEXValue
@onready var CON = $Stats/CONValue
@onready var SPD = $Stats/SPDValue
@onready var STRMod = $Stats/STRMod
@onready var DEXMod = $Stats/DEXMod
@onready var CONMod = $Stats/CONMod
@onready var SPDMod = $Stats/SPDMod
@onready var STRGr = $Stats/STRGr
@onready var DEXGr = $Stats/DEXGr
@onready var CONGr = $Stats/CONGr
@onready var SPDGr = $Stats/SPDGr
@onready var ClassName = $Class/ClassName
@onready var AttackScore = $Class/GridContainer/AttackScore
@onready var DamageScore = $Class/GridContainer/DamageScore
@onready var DefenceScore = $Class/GridContainer/DefenceScore
@onready var WeaponLabel = $Equipment/HBoxContainer/Weapon
@onready var ArmorLabel = $Equipment/HBoxContainer/Armor
@onready var AccessoryLabel = $Equipment/HBoxContainer/Accessory
@onready var WeaponCard = $Equipment/ItemsCards/weapon_card
@onready var ArmorCard = $Equipment/ItemsCards/armor_card
@onready var AccessoryCard = $Equipment/ItemsCards/accessory_card

var AssociatedCharacter

func _process(delta):
	CharacterName.text = AssociatedCharacter.character_name
	Level.text = "%d years old" % [10 + AssociatedCharacter._stats.LEVEL]
	
	HPBar.value = (AssociatedCharacter.current_hp / AssociatedCharacter.max_hp()) * 100
	HPLabel.text = "%d/%d" % [AssociatedCharacter.current_hp, AssociatedCharacter.max_hp()]
	
	STR.text = str(AssociatedCharacter.strength())
	DEX.text = str(AssociatedCharacter.dexterity())
	CON.text = str(AssociatedCharacter.constitution())
	SPD.text = str(AssociatedCharacter.speed())
	
	var mod = AssociatedCharacter.ability_score(MyGlobals.ABILITY.STRENGTH)
	STRMod.text = str(mod) if mod < 0 else "+" + str(mod)
	mod = AssociatedCharacter.ability_score(MyGlobals.ABILITY.DEXTERITY)
	DEXMod.text = str(mod) if mod < 0 else "+" + str(mod)
	mod = AssociatedCharacter.ability_score(MyGlobals.ABILITY.CONSTITUTION)
	CONMod.text = str(mod) if mod < 0 else "+" + str(mod)
	mod = AssociatedCharacter.ability_score(MyGlobals.ABILITY.SPEED)
	SPDMod.text = str(mod) if mod < 0 else "+" + str(mod)
	
	STRGr.text = "%d%%" % [round(100*AssociatedCharacter.strength_growth())]
	DEXGr.text = "%d%%" % [round(100*AssociatedCharacter.dexterity_growth())]
	CONGr.text = "%d%%" % [round(100*AssociatedCharacter.constitution_growth())]
	SPDGr.text = "%d%%" % [round(100*AssociatedCharacter.speed_growth())]
	
	ClassName.text = AssociatedCharacter._class.class_name_
	AttackScore.text = str(AssociatedCharacter.attack_score())
	DamageScore.text = str(AssociatedCharacter.damage_score())
	DefenceScore.text = str(AssociatedCharacter.defence_score())
	
#	WeaponLabel.text = AssociatedCharacter._weapon._name if AssociatedCharacter._weapon != null else "None"
#	ArmorLabel.text = AssociatedCharacter._armor._name if AssociatedCharacter._armor != null else "None"
#	AccessoryLabel.text = AssociatedCharacter._accessory._name if AssociatedCharacter._accessory != null else "None"

	if AssociatedCharacter._weapon != null:
		WeaponLabel.visible = true
		var item = AssociatedCharacter._weapon
		WeaponCard.ItemName.text = item._name
		WeaponCard.Level.text = "Level %d" % [item.level]
		WeaponCard.HP.text = "+" + str(item.max_hp())
		WeaponCard.STR.text = "+" + str(item.strength())
		WeaponCard.DEX.text = "+" + str(item.dexterity())
		WeaponCard.CON.text = "+" + str(item.constitution())
		WeaponCard.SPD.text = "+" + str(item.speed())
		WeaponCard.STRGr.text = "%.2f%%" % [snappedf(100*item.strength_growth(), 0.01)]
		WeaponCard.DEXGr.text = "%.2f%%" % [snappedf(100*item.dexterity_growth(), 0.01)]
		WeaponCard.CONGr.text = "%.2f%%" % [snappedf(100*item.constitution_growth(), 0.01)]
		WeaponCard.SPDGr.text = "%.2f%%" % [snappedf(100*item.speed_growth(), 0.01)]
		
		WeaponCard.AttackScore.text = "+" + str(item.attack_bonus())
		WeaponCard.DamageScore.text = "+" + str(item.damage_bonus())

		WeaponCard.AttackStat.text = "with " + MyGlobals.ABILITY_STR_SHORT[item.ATTACK_STAT]
		WeaponCard.DamageStat.text = "with " + MyGlobals.ABILITY_STR_SHORT[item.DAMAGE_STAT]
	else:
		WeaponLabel.visible = false
		
	if AssociatedCharacter._armor != null:
		ArmorLabel.visible = true
		var item = AssociatedCharacter._armor
		ArmorCard.ItemName.text = item._name
		ArmorCard.Level.text = "Level %d" % [item.level]
		ArmorCard.HP.text = "+" + str(item.max_hp())
		ArmorCard.STR.text = "+" + str(item.strength())
		ArmorCard.DEX.text = "+" + str(item.dexterity())
		ArmorCard.CON.text = "+" + str(item.constitution())
		ArmorCard.SPD.text = "+" + str(item.speed())
		ArmorCard.STRGr.text = "%.2f%%" % [snappedf(100*item.strength_growth(), 0.01)]
		ArmorCard.DEXGr.text = "%.2f%%" % [snappedf(100*item.dexterity_growth(), 0.01)]
		ArmorCard.CONGr.text = "%.2f%%" % [snappedf(100*item.constitution_growth(), 0.01)]
		ArmorCard.SPDGr.text = "%.2f%%" % [snappedf(100*item.speed_growth(), 0.01)]
		
		ArmorCard.DefenceValue.text = "+" + str(item.defence_bonus())
	else:
		ArmorLabel.visible = false
		
	if AssociatedCharacter._accessory != null:
		AccessoryLabel.visible = true
		var item = AssociatedCharacter._accessory
		AccessoryCard.ItemName.text = item._name
		AccessoryCard.Level.text = "Level %d" % [item.level]
		AccessoryCard.HP.text = "+" + str(item.max_hp())
		AccessoryCard.STR.text = "+" + str(item.strength())
		AccessoryCard.DEX.text = "+" + str(item.dexterity())
		AccessoryCard.CON.text = "+" + str(item.constitution())
		AccessoryCard.SPD.text = "+" + str(item.speed())
		AccessoryCard.STRGr.text = "%.2f%%" % [snappedf(100*item.strength_growth(), 0.01)]
		AccessoryCard.DEXGr.text = "%.2f%%" % [snappedf(100*item.dexterity_growth(), 0.01)]
		AccessoryCard.CONGr.text = "%.2f%%" % [snappedf(100*item.constitution_growth(), 0.01)]
		AccessoryCard.SPDGr.text = "%.2f%%" % [snappedf(100*item.speed_growth(), 0.01)]
	else:
		AccessoryLabel.visible = false

func _on_weapon_mouse_entered():
	$Equipment/ItemsCards/weapon_card.visible = true

func _on_weapon_mouse_exited():
	$Equipment/ItemsCards/weapon_card.visible = false

func _on_armor_mouse_entered():
	$Equipment/ItemsCards/armor_card.visible = true

func _on_armor_mouse_exited():
	$Equipment/ItemsCards/armor_card.visible = false

func _on_accessory_mouse_entered():
	$Equipment/ItemsCards/accessory_card.visible = true

func _on_accessory_mouse_exited():
	$Equipment/ItemsCards/accessory_card.visible = false
