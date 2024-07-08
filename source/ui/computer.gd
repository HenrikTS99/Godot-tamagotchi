extends CanvasLayer

@onready var buttons_ui = get_tree().get_first_node_in_group("ButtonsUI")
@onready var anim_player = $AnimationPlayer
var computer_active = false

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons_ui.openComputer.connect(open_computer)


func open_computer():
	get_tree().paused = true
	self.visible = true
	anim_player.play("ZoomIn")

func _on_power_button_pressed():
	anim_player.play("ZoomOut")
	get_tree().paused = false
	await anim_player.animation_finished
	self.visible = false
