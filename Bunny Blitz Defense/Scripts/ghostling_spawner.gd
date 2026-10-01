extends Node2D

@onready var Ghostling = load("res://Scenes/Enemies/Ghostling/ghostling.tscn")
@onready var Ghazt = load("res://Scenes/Enemies/Ghostling/ghazt.tscn")
@onready var Ghoul = load("res://Scenes/Enemies/Ghostling/ghoul.tscn")
@onready var Ghaztling = load("res://Scenes/Enemies/Ghostling/ghaztling.tscn")
@onready var Ghazely = load("res://Scenes/Enemies/Ghostling/ghazely.tscn")

@onready var Enhanced_Ghaztling = load("res://Scenes/Enemies/Ghostling/enhanced_ghaztling.tscn")
@onready var Enhanced_Ghoul = load("res://Scenes/Enemies/Ghostling/enhanced_ghoul.tscn")
@onready var Unholy_Phantasm = load("res://Scenes/Enemies/Ghostling/unholy_phantasm.tscn")
@onready var Brute = load("res://Scenes/Enemies/Ghostling/brute.tscn")

@onready var Leviathan = load("res://Scenes/Enemies/Bosses/Leviathan.tscn")
@onready var Azazel = load("res://Scenes/Enemies/Bosses/Azazel.tscn")
@onready var Belzebu = load("res://Scenes/Enemies/Bosses/Belzebu.tscn")
@onready var Fenrir = load("res://Scenes/Enemies/Bosses/Fenrir.tscn")
@onready var Lucifer = load("res://Scenes/Enemies/Bosses/Lucifer.tscn")

@onready var Undead_Ghostling = load("res://Scenes/Enemies/Ghostling/undead_ghostling.tscn")

var rodada_atual = 1
var inimigos_vivos = 0
var vaga_atual = []
var ronda_a_decorrer = false

var moedas_fim_ronda = 115
var moedas_fim_ronda_bonus = 0
var moedas_fim_ronda_total = moedas_fim_ronda + moedas_fim_ronda_bonus

func _ready() -> void:
    atualizar_contador_rondas()

func _process(_delta):
    var botao_start = get_tree().get_first_node_in_group("start_button")
    if botao_start and has_node("Timer"):
        if inimigos_vivos > 0 or not $Timer.is_stopped():
            botao_start.disabled = true
        else:
            botao_start.disabled = false

func iniciar_vaga():
    var hud = get_tree().get_first_node_in_group("HUD")
    ronda_a_decorrer = true
    
    match rodada_atual:
        1: 
            vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
            if has_node("../StarRound"):
                $"../StarRound".play()
            
        2: vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghazt, Ghazt, Ghostling, Ghostling, Ghazt, Ghazt]
        3: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt, Ghazt]
        4: vaga_atual = [Ghostling, Ghoul, Ghostling, Ghoul, Ghostling, Ghoul, Ghostling, Ghoul]
        5: vaga_atual = [Ghazt, Ghazt, Ghoul, Ghostling, Ghostling, Ghoul, Ghazt, Ghazt]
        6: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt, Ghazt, Ghaztling]
        7: vaga_atual = [Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling, Ghostling]
        8: vaga_atual = [Ghaztling, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt, Ghaztling, Ghazt, Ghazt]
        9: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghostling, Ghostling, Ghostling, Ghostling, Ghoul, Ghoul]
        10: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]

        11: vaga_atual = [Ghostling, Ghazt, Ghostling, Ghazt, Ghoul]
        12: vaga_atual = [Ghazt, Ghazt, Ghaztling, Ghaztling, Ghazt]
        13: vaga_atual = [Ghoul, Ghoul, Ghostling, Ghostling, Ghaztling, Ghaztling]
        14: vaga_atual = [Ghazt, Ghoul, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        15: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling, Ghaztling]
        16: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghazt, Ghazt, Ghostling]
        17: vaga_atual = [Ghostling, Ghaztling, Ghostling, Ghaztling, Ghoul, Ghoul]
        18: vaga_atual = [Ghazt, Ghazt, Ghazt, Ghoul, Ghoul, Ghaztling, Ghaztling]
        19: vaga_atual = [Ghaztling, Ghaztling, Ghoul, Ghoul, Ghoul, Ghoul]
        20: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul, Ghoul]

        21: vaga_atual = [Ghoul, Ghoul, Ghazely]
        22: vaga_atual = [Ghazt, Ghazt, Ghazely, Ghostling, Ghostling]
        23: vaga_atual = [Ghaztling, Ghaztling, Ghazely, Ghazely]
        24: vaga_atual = [Ghoul, Ghoul, Ghoul, Ghazely, Ghazt]
        25: vaga_atual = [Ghazely, Ghazely, Ghazely, Ghazely]
        26: vaga_atual = [Ghazt, Ghazt, Ghoul, Ghoul, Ghazely, Ghaztling]
        27: vaga_atual = [Ghaztling, Ghaztling, Ghaztling, Ghazely, Ghazely, Ghazely]
        28: vaga_atual = [Ghoul, Ghoul, Ghazely, Ghazely, Ghoul, Ghoul]
        29: vaga_atual = [Ghazt, Ghazely, Ghazely, Ghazely, Ghazt, Ghaztling]
        30: vaga_atual = [Ghazely, Ghazely, Ghazely, Ghazely, Ghazely, Ghazely, Ghazely, Ghazely]

        31: vaga_atual = [Ghazely, Ghazely, Enhanced_Ghaztling]
        32: vaga_atual = [Ghoul, Ghoul, Enhanced_Ghaztling, Enhanced_Ghaztling]
        33: vaga_atual = [Ghaztling, Ghaztling, Enhanced_Ghaztling, Ghazely, Ghazely]
        34: vaga_atual = [Enhanced_Ghoul, Ghoul, Ghoul, Ghoul]
        35: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghaztling, Enhanced_Ghaztling]
        36: vaga_atual = [Ghazely, Ghazely, Enhanced_Ghoul, Ghazely, Ghazely]
        37: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
        38: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Ghoul, Ghoul]
        39: vaga_atual = [Ghazely, Enhanced_Ghaztling, Enhanced_Ghoul, Ghazely]
        40: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]

        41: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghoul, Enhanced_Ghoul]
        42: vaga_atual = [Ghazely, Ghazely, Ghazely, Enhanced_Ghoul, Enhanced_Ghoul]
        43: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghoul, Enhanced_Ghoul]
        44: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]
        45: 
            vaga_atual = [Ghazely, Ghazely, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
            if hud and hud.has_node("HUD_Shop/EventSign/Placa"):
                hud.get_node("HUD_Shop/EventSign/Placa").play("Placa")
                await hud.get_node("HUD_Shop/EventSign/Placa").animation_finished
                hud.get_node("HUD_Shop/EventSign/Placa").play_backwards("Placa")
            
        46: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghaztling, Enhanced_Ghaztling]
        47: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul]
        48: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]
        49: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling]

        50: vaga_atual = [Leviathan]

        51: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul]
        52: vaga_atual = [Brute, Enhanced_Ghaztling, Enhanced_Ghaztling]
        53: vaga_atual = [Brute, Enhanced_Ghoul, Enhanced_Ghoul]
        54: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Leviathan, Enhanced_Ghaztling, Enhanced_Ghaztling]
        55: vaga_atual = [Brute, Brute]
        56: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Brute, Enhanced_Ghoul]
        57: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Brute, Brute, Brute]
        58: vaga_atual = [Brute, Enhanced_Ghaztling, Enhanced_Ghaztling, Brute]
        59: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Brute, Unholy_Phantasm]
        60: vaga_atual = [Brute, Brute, Brute, Brute]

        61: vaga_atual = [Brute, Brute, Leviathan]
        62: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Brute, Brute]
        63: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Enhanced_Ghoul, Brute, Brute]
        64: vaga_atual = [Leviathan, Brute, Leviathan]
        65: 
            vaga_atual = [Brute, Brute, Brute, Enhanced_Ghaztling, Enhanced_Ghaztling]
            if hud and hud.has_node("HUD_Shop/EventSign/Placa"):
                hud.get_node("HUD_Shop/EventSign/Sprite2D").texture = load("res://Assets/Enemies/Bosses/Azazel.png")
                hud.get_node("HUD_Shop/EventSign/Label").text = "Ronda 70:"
                hud.get_node("HUD_Shop/EventSign/Placa").play("Placa")
                await hud.get_node("HUD_Shop/EventSign/Placa").animation_finished
                hud.get_node("HUD_Shop/EventSign/Placa").play_backwards("Placa")
            
        66: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Brute, Brute, Brute]
        67: vaga_atual = [Leviathan, Leviathan, Brute]
        68: vaga_atual = [Brute, Brute, Brute, Brute, Brute]
        69: vaga_atual = [Brute, Brute, Leviathan, Leviathan, Enhanced_Ghoul]

        70: vaga_atual = [Azazel]

        71: vaga_atual = [Brute, Brute, Azazel]
        72: vaga_atual = [Leviathan, Leviathan, Azazel]
        73: vaga_atual = [Brute, Brute, Brute, Leviathan, Leviathan]
        74: vaga_atual = [Enhanced_Ghoul, Enhanced_Ghoul, Azazel, Enhanced_Ghoul, Enhanced_Ghoul]
        75: vaga_atual = [Brute, Brute, Brute, Brute, Azazel]
        76: vaga_atual = [Leviathan, Azazel, Leviathan]
        77: vaga_atual = [Enhanced_Ghaztling, Enhanced_Ghaztling, Enhanced_Ghaztling, Azazel, Brute, Brute]
        78: vaga_atual = [Azazel, Azazel]
        79: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Leviathan]
        80: 
            vaga_atual = [Azazel, Brute, Brute, Leviathan, Enhanced_Ghoul]
            if hud and hud.has_node("HUD_Shop/EventSign/Placa"):
                hud.get_node("HUD_Shop/EventSign/Sprite2D").texture = load("res://Assets/Enemies/Bosses/Belzebu.png")
                hud.get_node("HUD_Shop/EventSign/Label").text = "Ronda 85:"
                hud.get_node("HUD_Shop/EventSign/Placa").play("Placa")
                await hud.get_node("HUD_Shop/EventSign/Placa").animation_finished
                hud.get_node("HUD_Shop/EventSign/Placa").play_backwards("Placa")
            
        81: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        82: vaga_atual = [Azazel, Leviathan, Azazel]
        83: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        84: vaga_atual = [Azazel, Azazel, Brute, Brute]

        85: vaga_atual = [Belzebu]

        86: vaga_atual = [Brute, Brute, Unholy_Phantasm]
        87: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm]
        88: vaga_atual = [Belzebu, Unholy_Phantasm]
        89: vaga_atual = [Brute, Brute, Brute, Unholy_Phantasm, Unholy_Phantasm]
        90: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        91: vaga_atual = [Azazel, Belzebu]
        92: vaga_atual = [Unholy_Phantasm, Brute, Brute, Unholy_Phantasm]
        93: vaga_atual = [Belzebu, Leviathan, Leviathan]
        94: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Brute, Brute]
        95: vaga_atual = [Belzebu, Belzebu]
        96: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        97: vaga_atual = [Brute, Brute, Brute, Brute, Belzebu]
        98: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Belzebu, Unholy_Phantasm, Unholy_Phantasm]
        99: vaga_atual = [Belzebu, Azazel, Leviathan]

        100: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        101: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Belzebu]
        102: vaga_atual = [Belzebu, Belzebu, Brute, Brute]
        103: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        104: vaga_atual = [Azazel, Azazel, Belzebu]
        105: 
            vaga_atual = [Brute, Brute, Brute, Brute, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
            if hud and hud.has_node("HUD_Shop/EventSign/Placa"):
                hud.get_node("HUD_Shop/EventSign/Sprite2D").texture = load("res://Assets/Enemies/Bosses/Fenrir.png")
                hud.get_node("HUD_Shop/EventSign/Label").text = "Ronda 110:"
                hud.get_node("HUD_Shop/EventSign/Placa").play("Placa")
                await hud.get_node("HUD_Shop/EventSign/Placa").animation_finished
                hud.get_node("HUD_Shop/EventSign/Placa").play_backwards("Placa")
            
        106: vaga_atual = [Belzebu, Belzebu, Belzebu]
        107: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        108: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Belzebu, Belzebu]
        109: vaga_atual = [Belzebu, Azazel, Belzebu, Azazel]

        110: vaga_atual = [Fenrir, Fenrir, Fenrir]

        111: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Fenrir, Fenrir, Fenrir]
        112: vaga_atual = [Brute, Brute, Fenrir, Fenrir, Fenrir, Fenrir]
        113: vaga_atual = [Belzebu, Fenrir, Fenrir, Fenrir]
        114: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        115: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Fenrir, Fenrir, Fenrir]
        116: vaga_atual = [Belzebu, Belzebu, Fenrir, Fenrir, Fenrir]
        117: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        118: vaga_atual = [Brute, Brute, Brute, Brute, Fenrir, Fenrir, Fenrir]
        119: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        120: vaga_atual = [Azazel, Azazel, Fenrir, Fenrir, Fenrir, Fenrir]
        121: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        122: vaga_atual = [Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        123: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        124: vaga_atual = [Brute, Brute, Brute, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        125: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]

        126: vaga_atual = [Leviathan, Azazel, Belzebu]
        127: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Fenrir, Fenrir, Fenrir]
        128: vaga_atual = [Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir]
        129: vaga_atual = [Azazel, Belzebu, Fenrir, Fenrir, Fenrir]
        130: vaga_atual = [Leviathan, Leviathan, Leviathan, Leviathan, Leviathan]
        131: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        132: vaga_atual = [Azazel, Azazel, Azazel]
        133: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        134: vaga_atual = [Belzebu, Belzebu, Belzebu, Belzebu]
        135: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        136: vaga_atual = [Leviathan, Azazel, Belzebu, Fenrir, Fenrir, Fenrir]
        137: vaga_atual = [Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        138: vaga_atual = [Azazel, Azazel, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir]
        139: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]

        140: vaga_atual = [Belzebu, Belzebu, Belzebu, Belzebu, Belzebu]
        141: vaga_atual = [Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        142: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm]
        143: vaga_atual = [Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute, Brute]
        144: vaga_atual = [Azazel, Azazel, Azazel, Azazel, Azazel]
        145: 
            vaga_atual = [Belzebu, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
            if hud and hud.has_node("HUD_Shop/EventSign/Placa"):
                hud.get_node("HUD_Shop/EventSign/Sprite2D").texture = load("res://Assets/Enemies/Bosses/Lucifer.png")
                hud.get_node("HUD_Shop/EventSign/Label").text = "Ronda 150:"
                hud.get_node("HUD_Shop/EventSign/Placa").play("Placa")
                await hud.get_node("HUD_Shop/EventSign/Placa").animation_finished
                hud.get_node("HUD_Shop/EventSign/Placa").play_backwards("Placa")
        146: vaga_atual = [Leviathan, Leviathan, Azazel, Azazel, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir]
        147: vaga_atual = [Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Unholy_Phantasm, Brute, Brute, Brute, Brute, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        148: vaga_atual = [Belzebu, Belzebu, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]
        149: vaga_atual = [Azazel, Azazel, Belzebu, Belzebu, Belzebu, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir, Fenrir]

        150: vaga_atual = [Lucifer]

    if has_node("Timer"):
        $Timer.start()

func _on_timer_timeout():
    if vaga_atual.size() > 0:
        var cena_do_inimigo = vaga_atual.pop_front()
        var novo_fantasma = cena_do_inimigo.instantiate()
        var path = get_node_or_null("../Path2D")
        if path:
            path.add_child(novo_fantasma)
            inimigos_vivos += 1
    else:
        $Timer.stop()

func inimigo_morreu():
    var hud = get_tree().get_first_node_in_group("HUD")
    
    var gacha = randi_range(1, 15)
    var AmountCoins = randi_range(25, 70)
    
    if gacha == 1:
        hud.EarnBunnyCoins(AmountCoins)
        
    
    inimigos_vivos -= 1
    if inimigos_vivos < 0:
        inimigos_vivos = 0

    if vaga_atual.size() == 0 and inimigos_vivos == 0 and ronda_a_decorrer:
        ronda_a_decorrer = false
        
        if rodada_atual == 150:
            if hud and hud.has_method("victory"):
                hud.victory()
            return
        
        var moedas_no = get_tree().current_scene.find_child("Moedas")
        if moedas_no:
            moedas_no.text = str(int(moedas_no.text) + int(rodada_atual * 10) + moedas_fim_ronda_total)
        
        rodada_atual += 1
        atualizar_contador_rondas()
        
        if typeof(SaveManager) != TYPE_NIL and "autoplay" in SaveManager and SaveManager.autoplay == true:
            iniciar_vaga()

func atualizar_contador_rondas() -> void:
    var contador_no = get_tree().get_first_node_in_group("Round_Counter")
    if contador_no:
        contador_no.text = str(rodada_atual)

func atualizar_moedas_buff() -> void:
    moedas_fim_ronda_total = moedas_fim_ronda + moedas_fim_ronda_bonus
