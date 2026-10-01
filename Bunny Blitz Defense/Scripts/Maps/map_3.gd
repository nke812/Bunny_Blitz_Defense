extends Node2D

func _ready() -> void:
    if DirAccess.dir_exists_absolute("res://mods/PINK"):
        var pink = load("res://mods/PINK/pink.tscn").instantiate()
        add_child(pink)

func pinkStopMusic():
    $Map3Music.stop()
