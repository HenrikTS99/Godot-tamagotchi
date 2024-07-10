extends Control

@onready var statsLabels: Array = $StatsTextContainer.get_children()
@onready var anim_player = $AnimationPlayer

var label: Label
# Called when the node enters the scene tree for the first time.
func _ready():
	set_stats()

func update():
	hide_text()
	set_stats()
	animate_text()
	
func set_stats():
	statsLabels[0].text = 'Total Coins Earned: ' + str(Global.totalCoinsEarned)
	statsLabels[1].text = 'Total Coins Spent: ' + str(Global.totalCoinsSpent)
	statsLabels[2].text = 'Total Visitors: ' + str(Global.totalVisitors)
	statsLabels[3].text = 'Visitors: ' + str(Global.visitors)
	statsLabels[4].text = 'Total Unique Pets Visited: ' + str(Global.totalUniqueVisitors)

func hide_text():
	for statsLabel in statsLabels:
		statsLabel.visible_characters = 0
		
func animate_text():
	for statsLabel in statsLabels:
		for i in range(statsLabel.get_total_character_count()):
			statsLabel.visible_characters += 1
			await get_tree().create_timer(0.01).timeout
		await get_tree().create_timer(0.05).timeout
		
