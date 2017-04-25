## This is Ren'GD API ##
## Ren'GD is Ren'Py for Godot ##
## version: 0.6 ##
## License MIT ##

extends Node

## import ren_statement
const REN_STA = preload("ren_statement.gd")
var ren_sta
var statements = []
var can_roll = true

## import ren_def
const REN_DEF = preload("ren_def.gd")
var ren_def
var keywords = { "version":{"type":"text", "value":"0.6"} }

## import ren_text
const REN_TXT = preload("ren_text.gd")
var ren_txt

## import ren_say 
const REN_SAY = preload("ren_say.gd")
var ren_say
var vbc = "VBoxContainer"
## paths to nodes to use with special kinds of charcters
var adv_path = "Adv/" + vbc
var cen_path = "Center/" + vbc
var fs_path = "FullScreen" + vbc
var nvl_path = "Nvl"
var nvl_scroll_path = "Nvl/" + vbc

onready var say_screen = get_node(adv_path)

onready var say_scene = preload("res://scenes/gui/Say.tscn")

## import ren_tools
const REN_TLS = preload("ren_tools.gd")
var ren_tls

## this script stuff
onready var input_screen = get_node(adv_path + "/Input")
onready var choice_screen = get_node("Choice")
onready var label_manager = get_node("LabelManager")

signal statement_changed

func _ready():

    # setup ren_def
    ren_def = new REN_DEF()
    ren_def.keywords = keywords

    # setup ren_text
    ren_txt = new REN_TXT()
    ren_txt.keywords = keywords

    # setup ren_say
    ren_say = new REN_SAY()

    ren_say.adv_path = adv_path
    ren_say.cen_path = cen_path
    ren_say.fs_path = fs_path
    
    ren_say.say_screen = say_screen
    ren_say.nvl_scroll = get_node(nvl_path)
    ren_say.nvl_screen = get_node(nvl_scroll_path)
    ren_say.input_screen = input_screen
    ren_say.say_scene = say_scene

    # setup ren_statement
    ren_sta = new REN_STA()

    ren_sta.ren_say = ren_say
    ren_sta.choice_screen = choice_screen
    ren_sta.input_screen = input_screen
    ren_sta.connect("statement_changed", self, "on_statement_changed")

    # setup ren_tools
    ren_tls = new REN_TLS()


func on_statement_changed():
    emit_signal("statement_changed")


func update_statements():
    ren_sta.statements = statements


func _input(event):
    ren_sta.can_roll = can_roll
    ren_sta._input(event)


func define(key_name, key_value = null):
    ## add global var that ren will see
    ren_def.define(key_name, key_value)


func start_ren():
    ## This must be at end of code using ren api
	## this start ren "magic" ;) 
    update_statements()
    use_statement(0)


func text_passer(text):
    ren_txt.keywords = ren_def.keywords


func say_statement(how, what):
    ## return input statement
    return say_screen.statement(how, what)


func append_say(how, what):
    ## append say statement 
    var s = say_statement(how, what)
    statements.append(s)


func make_say(statement):
    ## "run" say statement
    ren_say.say(statement)


func input_statement(ivar, what, temp = ""):
    ## return input statement
    return input_screen.statement(ivar, what, temp)


func append_input(ivar, what, temp = ""):
    ## append input statement
    var s = input_statement(ivar, what, temp)
    statements.append(s)


func make_input(statement):
   ## "run" input statement
   input_screen.use(statement)


func array_slice(array, from = 0, to = 0):
 	return ren_tls.array_slice(array, from, to)
    

func before_menu():
    ## must be on begin of menu custom func
    choice_screen.before_menu()


func after_menu():
	## must be on end of menu custom func
    choice_screen.after_menu()


func menu_statement(choices, title, node, func_name):
	## return custom menu statement
	## made to use menu statement easy to use with gdscript
    return choice_screen.statement_func(choices, title, node, func_name)


func append_menu(choices, title, node, func_name):
    ## append menu_func statement
    var s = menu_statement(choices, title, node, func_name)
    statements.append(s)


func make_menu(statement):
    ## "run" menu_func statement
    choice_screen.use(statement)


func label(label_name, scene_path, node_path = null, func_name = null):
    ## this declare new label
    ## that make ren see label and can jump to it
    label_manager.label(label_name, scene_path, node_path, func_name)


func jump(label_name, args = []):
    ## go to other declared label
    label_manager.jump(label_name, args)


func godot_line(fun, args = []):
    return ren_sta.godot_line(fun, args)


func append_godot_line(fun, args = []):
    ## return g statement
    ## use it to execute godot func in rengd
    var s = godot_line(fun, args)
    statements.append(s) 



