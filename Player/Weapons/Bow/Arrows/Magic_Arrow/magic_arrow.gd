class_name MagicArrow
extends Arrow


const MANA_COST :int= 10
@export var mana_cost :int= MANA_COST



func _on_area_entered(other_area: Area2D) -> void: #detects NPCs
	if other_area is NPC:
		other_area.take_damage(bow.get_bow_damage(charge_level) + (bow.get_magic_damage(charge_level)))
