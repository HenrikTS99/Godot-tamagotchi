extends Resource

class_name Item

@export var name: String = ""
@export var texture: Texture2D
@export var price: int

enum ItemType { Item, Food, Test }
@export var type: ItemType
