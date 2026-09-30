extends Node2D

func _ready() -> void:
    var bus_idx = AudioServer.get_bus_index("SFX")
    # Ativa o primeiro efeito da lista do bus SFX (o teu Reverb/Delay)
    AudioServer.set_bus_effect_enabled(bus_idx, 0, true)

func _exit_tree() -> void:
    var bus_idx = AudioServer.get_bus_index("SFX")
    # Desativa o efeito para quando voltares ao Mapa 1 ou Menus
    AudioServer.set_bus_effect_enabled(bus_idx, 0, false)
