extends Node2D

@onready var loading = $ProgressBar
@export var ProxCena: String = ""
var progress: Array[float] = []
var proceed = false
        
func _ready():
    if Global.LoadingScene == "grass_lands":
        ProxCena = "res://Scenes/Mapas/Map_1.tscn"
        $Background.texture = load("res://Assets/Others/Map_Assets/Grasslands/GrassLandsLOADING.png")
    
    elif Global.LoadingScene == "glimmer_road":
        ProxCena = "res://Scenes/Mapas/Map_2.tscn"
        $Background.texture = load("res://Assets/Others/Map_Assets/GlimmerRoad/GlimmerRoadsLoading.png")
        
    elif Global.LoadingScene == "sandy_streets":
        ProxCena = "res://Scenes/Mapas/Map_3.tscn"
        $Background.texture = load("res://Assets/Others/Map_Assets/SandyStreets/SandyStreetsLOADING.png")
    
    elif Global.LoadingScene == "menu":
        ProxCena = "res://Scenes/MainMenu.tscn"
        $Background.texture = load("res://Assets/Others/Menu_Assets/menuLOADING.png")
    
    waitMF()
    ResourceLoader.load_threaded_request(ProxCena)

func _process(delta):
    var percentagem = ResourceLoader.load_threaded_get_status(ProxCena, progress)
    
    match percentagem:
        ResourceLoader.THREAD_LOAD_IN_PROGRESS:
            var pct_barra = progress[0] * 100
            loading.value = pct_barra
        ResourceLoader.THREAD_LOAD_LOADED:
            if proceed:
                set_process(false)
                var cena = ResourceLoader.load_threaded_get(ProxCena)
                get_tree().change_scene_to_packed(cena)
            
func waitMF():
    var seconds = randf_range(0.5, 2.0)
    await get_tree().create_timer(seconds).timeout
    proceed = true
