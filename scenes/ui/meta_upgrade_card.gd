extends PanelContainer

@onready var name_label: Label = $%NameLabel
@onready var description_label: Label = $%DescriptionLabel
@onready var progress_bar = %ProgressBar
@onready var purchase_button = %PurchaseButton
@onready var progress_label = %ProgressLabel
@onready var count_label = %CountLabel

var upgrade: MetaUpgrade

func _ready():
	purchase_button.pressed.connect(on_purchase_pressed)


func select_card():
	$AnimationPlayer.play("selected")


func set_meta_upgrade(upgrade: MetaUpgrade):
	self.upgrade = upgrade
	name_label.text = upgrade.title
	description_label.text = upgrade.description
	update_progress()


func update_progress():
	var current_quantity = 0
	if MetaProgression.save_data["meta_upgrades"].has(upgrade.id):
		current_quantity = MetaProgression.save_data["meta_upgrades"][upgrade.id]["quantity"]
	
	var is_max = current_quantity == upgrade.max_quantity
	var meta_upgrade_currency = MetaProgression.save_data["meta_upgrade_currency"]
	
	var percent = meta_upgrade_currency / upgrade.experience_cost
	percent = min(percent, 1)
	
	progress_bar.value = percent
	purchase_button.disabled = percent < 1 || is_max
	if is_max:
		purchase_button.text = "Max"
	
	progress_label.text = str(meta_upgrade_currency) + "/" + str(upgrade.experience_cost)
	count_label.text = "x%d" % current_quantity


func on_purchase_pressed():
	if upgrade == null:
		return
	
	MetaProgression.add_meta_upgrade(upgrade)
	MetaProgression.save_data["meta_upgrade_currency"] -= upgrade.experience_cost
	MetaProgression.save()
	get_tree().call_group("meta_upgrade_card", "update_progress")
	select_card()
