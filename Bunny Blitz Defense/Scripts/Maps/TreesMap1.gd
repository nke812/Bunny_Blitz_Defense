extends Sprite2D

@export var intensidade: float = 4
@export var suavizacao: float = 5

@onready var posicao_original = position

func _process(delta):
    var centro_tela = get_viewport_rect().size / 2
    var direcao_mouse = (get_global_mouse_position() - centro_tela).normalized()
    
    var alvo = posicao_original + (direcao_mouse * intensidade)
    
    position = position.lerp(alvo, suavizacao * delta)
