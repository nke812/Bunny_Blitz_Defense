extends Control

@onready var label_timer: Label = $TimerDaily
@onready var btn_recompensa: TextureButton = $BtnDaily

const COOLDOWN_12H: int = 12 * 3600 # 43200 segundos

# Duas APIs alternativas para garantir que pelo menos uma responde
const API_PRIMARY: String = "https://worldtimeapi.org/api/timezone/Europe/Lisbon"
const API_FALLBACK: String = "https://timeapi.io/api/time/current/zone?timeZone=Europe/Lisbon"

var tempo_online_unix: int = 0
var ticks_inicio_sessao: int = 0
var tem_conexao: bool = false
var a_usar_fallback: bool = false

func _ready() -> void:
    $HTTPRequest.request_completed.connect(_on_request_completed)
    
    # Permite clicar na Label para recarregar se falhar
    label_timer.gui_input.connect(_on_label_gui_input)
    label_timer.mouse_filter = Control.MOUSE_FILTER_STOP
    
    btn_recompensa.disabled = true
    $LabelInfoDaily.text = "Loading..."
    label_timer.text = "XX:XX:XX"
    
    obter_tempo_online()

func obter_tempo_online() -> void:
    $HTTPRequest.timeout = 5.0 # Cancela se demorar mais de 5 segundos
    
    var url = API_FALLBACK if a_usar_fallback else API_PRIMARY
    var headers = ["User-Agent: Mozilla/5.0"]
    
    var err = $HTTPRequest.request(url, headers)
    if err != OK:
        tentar_fallback_ou_falhar()

func _on_request_completed(result, response_code, headers, body):
    if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
        tentar_fallback_ou_falhar()
        return

    var json = JSON.parse_string(body.get_string_from_utf8())
    
    if json and json is Dictionary:
        # Suporte para WorldTimeAPI (unixtime) e TimeAPI (dateTime ISO)
        if json.has("unixtime"):
            aplicar_tempo_online(int(json["unixtime"]))
        elif json.has("dateTime"):
            var dt_str: String = str(json["dateTime"]).left(19)
            var unix_calc = int(Time.get_unix_time_from_datetime_string(dt_str))
            aplicar_tempo_online(unix_calc)
        else:
            tentar_fallback_ou_falhar()
    else:
        tentar_fallback_ou_falhar()

func aplicar_tempo_online(unix_time: int) -> void:
    tem_conexao = true
    tempo_online_unix = unix_time
    ticks_inicio_sessao = Time.get_ticks_msec()
    
    # Reseta valores corrompidos do save se existirem
    if SaveManager.LastDaily > tempo_online_unix + COOLDOWN_12H + 86400:
        SaveManager.LastDaily = 0
        SaveManager.guardar_dados()

func tentar_fallback_ou_falhar() -> void:
    if not a_usar_fallback:
        a_usar_fallback = true
        obter_tempo_online()
    else:
        definir_sem_conexao()

func definir_sem_conexao() -> void:
    tem_conexao = false
    a_usar_fallback = false
    btn_recompensa.disabled = true
    $LabelInfoDaily.text = "No conection (Click here to try again)"
    label_timer.text = "XX:XX:XX"
    

func _on_label_gui_input(event: InputEvent) -> void:
    # Se clicar na Label quando está sem ligação, tenta reconectar
    if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        if not tem_conexao:
            $LabelInfoDaily.text = "Loading..."
            label_timer.text = "XX:XX:XX"
            a_usar_fallback = false
            obter_tempo_online()

func _process(_delta: float) -> void:
    if not tem_conexao or tempo_online_unix == 0:
        return
        
    var segundos_decorridos = int((Time.get_ticks_msec() - ticks_inicio_sessao) / 1000.0)
    var tempo_online_atual = tempo_online_unix + segundos_decorridos
    
    if SaveManager.LastDaily == 0:
        btn_recompensa.disabled = false
        $LabelInfoDaily.text = ""
        label_timer.text = ""
        return
        
    var proxima_recompensa = SaveManager.LastDaily + COOLDOWN_12H
    var tempo_restante = proxima_recompensa - tempo_online_atual
    
    if tempo_restante <= 0:
        btn_recompensa.disabled = false
        label_timer.text = ""
        $LabelInfoDaily.text = ""
    else:
        btn_recompensa.disabled = true
        label_timer.text = formatar_tempo(tempo_restante)

func _on_pressed() -> void:
    if not tem_conexao or tempo_online_unix == 0:
        label_timer.text = "Loading..."
        obter_tempo_online()
        return
    
    $"../BunnyCoinsNode/EarnCoinsAnim".play("EarnCoinsAnim")
    
    var segundos_decorridos = int((Time.get_ticks_msec() - ticks_inicio_sessao) / 1000.0)
    var tempo_resgate_online = tempo_online_unix + segundos_decorridos
    var tween = create_tween()
    var saldo_antigo = SaveManager.BunnyCoins
    var saldo_novo = SaveManager.BunnyCoins + 500
    
    SaveManager.LastDaily = tempo_resgate_online
    SaveManager.BunnyCoins = SaveManager.BunnyCoins + 500

    tween.tween_method(
        _mudar_texto_label, 
        saldo_antigo, 
        saldo_novo, 
        1.0
    ).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    
    SaveManager.guardar_dados()
    
func _mudar_texto_label(valor: int) -> void:
    $"../../BunnyCoins/Price".text = str(valor)

func formatar_tempo(segundos_totais: int) -> String:
    $LabelInfoDaily.text = ""
    if segundos_totais < 0:
        return "00:00:00"
        
    var horas = segundos_totais / 3600
    var minutos = (segundos_totais % 3600) / 60
    var segundos = segundos_totais % 60
    return "%02d:%02d:%02d" % [horas, minutos, segundos]
