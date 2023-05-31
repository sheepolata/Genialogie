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
