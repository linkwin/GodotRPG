extends Node

onready var func_lib = get_node("/root/FuncLib")
onready var health_gauge = $HBoxContainer/Bars/HealthGauge
onready var magic_gauge = $HBoxContainer/Bars/MagicGauge

func _ready():
	GlobalSignals.connect("player_health_changed", self, "_on_player_health_changed")
	GlobalSignals.connect("player_magic_changed", self, "_on_player_magic_changed")

func _on_player_health_changed(health):
	health_gauge.value = health
	
func _on_player_magic_changed(magic):
	magic_gauge.value = magic

