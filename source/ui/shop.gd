extends CanvasLayer


@onready var buttons_ui = get_tree().get_first_node_in_group("ButtonsUI")
@onready var anim_player = $AnimationPlayer
var shop_active = false
# Called when the node enters the scene tree for the first time.
func _ready():
	buttons_ui.selectedShop.connect(open_shop)


func open_shop():
	get_tree().paused = true
	anim_player.play("TransIn")
	


func _on_close_button_pressed():
	anim_player.play("TransOut")
	get_tree().paused = false
