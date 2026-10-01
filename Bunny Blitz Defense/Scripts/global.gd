extends Node

var title_screen: bool = false

func _ready() -> void :
    SaveManager.carregar_dados()
    
    process_mode = Node.PROCESS_MODE_ALWAYS

var cursor_point = load("res://Assets/Others/Others/CursorPoint.png")
var cursor_pressed = load("res://Assets/Others/Others/CursorPressed.png")

var LoadingScene = "menu"

func _input(event):
    if event.is_action_pressed("fullscreen_key"):
        if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    if event is InputEventMouseButton:
        if event.button_index == MOUSE_BUTTON_LEFT:
            if event.pressed:

                Input.set_custom_mouse_cursor(cursor_pressed)
            else:

                Input.set_custom_mouse_cursor(cursor_point)
