extends Control

export var saveslots_dir : = "user://saveslot"

var screenshot : = Image.new()
var dirhandler : = Directory.new()
var filehandler : = File.new()
var overwrite : = true

signal popup_is_closed

func _ready() -> void:
	var yes_button = $PopupPanel/ConfirmOverwrite/HBoxContainer/Yes
	var no_button = $PopupPanel/ConfirmOverwrite/HBoxContainer/No
	yes_button.connect("pressed", self, "close_popup", [true])
	no_button.connect("pressed", self, "close_popup", [false])

func close_popup(anwser):
	$PopupPanel.hide()
	$GridContainer.show()
	overwrite = anwser
	emit_signal("popup_is_closed")
	
func savebox(saveslotsdir : = saveslots_dir + "/") -> void:
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			Ren.debug("slot exist, loading image")
			var img = Image.new()
			img.load(saveslotsdir + x.name + '.png')
			img.flip_y()
			var tex = ImageTexture.new()
			tex.create_from_image(img)

			x.get_node("Button/TextureRect").texture = tex
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "savepress"):
			b.connect("pressed", self, "savepress", [x.name])

	filehandler.close()

func loadbox(saveslotsdir : = saveslots_dir + "/") -> bool:
	for x in $GridContainer.get_children():
		if filehandler.file_exists(saveslotsdir + x.name + '.png'):
			# Ren.debug("slot exist, loading image")
			var img=Image.new()
			img.load(saveslotsdir + x.name + '.png')
			img.flip_y()
			var tex = ImageTexture.new()
			tex.create_from_image(img)

			x.get_node("Button/TextureRect").texture = tex
			
			filehandler.open(saveslotsdir + x.name + '.info', File.READ)
			x.get_node("Label").text = filehandler.get_line()
			filehandler.close()

		else:
			return false
		
		var b = x.get_node("Button")
		if !b.is_connected("pressed", self, "loadpress"):
			b.connect("pressed", self, "loadpress", [x.name])

	filehandler.close()
	return true

func savepress(caller : String) -> bool:
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)
		
	if Ren.is_save_exits(caller):
		$GridContainer.hide()
		$PopupPanel.popup_centered()
		yield(self, "popup_is_closed")
		
	if not overwrite:
		return false

	Ren.debug(caller)
	if screenshot == null:
		return false

	screenshot.save_png(saveslots_dir + "/" + caller + '.png')
	filehandler.open(saveslots_dir + "/" + caller + '.info', File.WRITE)
	var s = Ren.get_datetime_str()
	Ren.debug(s)
	filehandler.store_line(s)
	Ren.debug(["caller:", caller])
	Ren.savefile(caller)

	filehandler.close()
	
	savebox()
	return true
	
func loadpress(caller : String) -> void:
	if !dirhandler.dir_exists(saveslots_dir):
		dirhandler.make_dir(saveslots_dir)

	if Ren.loadfile(caller):
		get_parent().in_game()
		get_parent().hide()
	
