extends Node

@export var toast: Control
@export var tablet: Control

var quest: Quest = null

func popup(popup: Panel) -> void:
	popup.queue_free()
	$"../Camera2D".scrollable = true
	await get_tree().create_timer(3.0).timeout
	new_quest(ResourceLoader.load("res://Quests/umowy.tres"))

func new_quest(quest_resource: Resource) -> void:
	quest = quest_resource
	tablet.hover_disabled = true
	toast.show_boss_message("Re: " + quest.boss_title, quest.boss_message)
	await get_tree().create_timer(2.0).timeout
	
	tablet.show_tablet()
	await get_tree().create_timer(0.5).timeout
	tablet.player_message(quest.player_message)
	await get_tree().create_timer(2.0 + 2.0 * quest.player_message.length() * 0.01).timeout
	
	tablet.gpt_message(quest.gpt_message, quest.gpt_delay)
	await get_tree().create_timer(1.0 + 2.0 * quest.gpt_message.length() * 0.005 + quest.gpt_delay).timeout
	
	toast.hide_boss_message()
	tablet.hide_tablet()
	tablet.hover_disabled = false
	get_tree().call_group(quest.item_group, "activate", quest.item_group)
