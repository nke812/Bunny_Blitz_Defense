extends Control

@onready var escolha = get_tree().get_first_node_in_group("escolha de mapa")
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options

@onready var botao_continuar = $MainMenu_Left/Buttons/Continue

var MapSel = null
var map1 = "res://Scenes/Mapas/Map_1.tscn"
var map2 = "res://Scenes/Mapas/Map_2.tscn"

var ResetOptionMenu = false

func _ready() -> void:
    SaveManager.carregar_dados()
    $BunnyCoins/Price.text = str(SaveManager.BunnyCoins)
    $ColorRect.color = Color(0.0, 0.0, 0.0, 1.0)
    
    if Global.title_screen == true:
        $TitleScreenStart.disabled = true
        $"Bunny???".position = Vector2(-505, -40)
        $Camera2D.offset = Vector2(-2057, 27)
        $ColorRect/FadeIn.play_backwards("FadeIn")
    else:
        $ColorRect/FadeIn.play_backwards("FadeIn")
        

func _on_title_screen_start_pressed() -> void:
    Global.title_screen = true
    $TitleScreenStart.disabled = true
    $TitleScreenSound.play()
    $Logo/LabelStart.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
    $TitleScreenStart/TitleScreenStartAnim.stop()
    $TitleScreenStart/TitleScreenStartAnimBlink.play("TitleScreenStartAnimBlink")
    $Camera2D/MenuGoLeft.play("MenuGoLeft")
    
    await $Camera2D/MenuGoLeft.animation_finished
    $"Bunny???/SlenderBunnyQuit".play("anim")
    
func _on_title_screen_start_button_down() -> void:
    $TitleScreenStart/TitleScreenStartAnim.stop()
    $Logo/LabelStart.add_theme_color_override("font_color", Color(0.553, 0.553, 0.553, 1.0))


func _on_start_pressed() -> void :
    $"Select Map/SelMapsMenu".play("SelMapsAnim")
    

func _on_settings_pressed() -> void :
    $Options/SettingsAnim.play("settings")


func _on_voltar_pressed() -> void :
    $Camera2D/MenuGoLeft.play_backwards("MenuGoLeft")
    
    
func _on_exit_menu_map_pressed() -> void:
    $"Select Map/SelMapsMenu".play_backwards("SelMapsAnim")


func _on_easter_egg_pressed() -> void :
    $Rookienho/A_COISA_MAIS_FODA.disabled = true
    $Rookienho/Squeaky.play()
    $Rookienho.texture = load("res://Assets/Others/Menu_Assets/Buttons/RookienhoHappy.png")

    $Rookienho/A_COISA_MAIS_FODA2.play("Anim")
    await $Rookienho/A_COISA_MAIS_FODA2.animation_finished

    $Rookienho/A_COISA_MAIS_FODA.disabled = false
    $Rookienho.texture = load("res://Assets/Others/Menu_Assets/Buttons/Rookienho.png")



#MENU DE MAPAS
func _on_grass_lands_pressed() -> void:
    Global.LoadingScene = "grass_lands"
    get_tree().change_scene_to_file("res://Scenes/loading.tscn")
func _on_glimmer_road_pressed() -> void:
    Global.LoadingScene = "glimmer_road"
    get_tree().change_scene_to_file("res://Scenes/loading.tscn")
func _on_sandy_streets_pressed() -> void:
    Global.LoadingScene = "sandy_streets"
    get_tree().change_scene_to_file("res://Scenes/loading.tscn")

func _on_grass_lands_mouse_entered() -> void:
    $"Select Map/GrassLands".modulate = Color(1.211, 1.211, 1.211)
func _on_grass_lands_mouse_exited() -> void:
    $"Select Map/GrassLands".modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_glimmer_road_mouse_entered() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(1.211, 1.211, 1.211)
func _on_glimmer_road_mouse_exited() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(1.0, 1.0, 1.0, 1.0)
func _on_sandy_streets_mouse_entered() -> void:
    $"Select Map/Sandy Streets".modulate = Color(1.211, 1.211, 1.211)
func _on_sandy_streets_mouse_exited() -> void:
    $"Select Map/Sandy Streets".modulate = Color(1.0, 1.0, 1.0, 1.0)


func _on_glimmer_road_button_down() -> void:
    $"Select Map/GlimmerRoad".modulate = Color(0.632, 0.632, 0.632, 1.0)
func _on_grass_lands_button_down() -> void:
    $"Select Map/GrassLands".modulate = Color(0.632, 0.632, 0.632, 1.0)
func _on_sandy_streets_button_down() -> void:
    $"Select Map/Sandy Streets".modulate = Color(0.632, 0.632, 0.632, 1.0)




func _on_music_icon_pressed() -> void:
    var slider_sfx = $Options/MusicControl
    var icon = $Options/MusicControl/MusicIcon.texture_normal.resource_path
    
    $Options/MusicControl/Click_AnimMusic.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Music.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/MusicMute.png":
            slider_sfx.value = 100
    
func _on_sfx_icon_pressed() -> void:
    var slider_sfx = $Options/SFXControl
    var icon = $Options/SFXControl/SFXIcon.texture_normal.resource_path
    
    $Options/SFXControl/Click_AnimSFX.play("click")
    match icon:
        "res://Assets/Others/UI_Assets/Audio.png":
            slider_sfx.value = 0
        "res://Assets/Others/UI_Assets/AudioMute.png":
            slider_sfx.value = 100     

func _on_music_control_value_changed(value: float) -> void: 
    if $Options/MusicControl.value >= 0.01:
        $Options/MusicControl/MusicIcon.texture_normal = load("res://Assets/Others/UI_Assets/Music.png")
    else:
        $Options/MusicControl/MusicIcon.texture_normal = load("res://Assets/Others/UI_Assets/MusicMute.png")
        
func _on_sfx_control_value_changed(value: float) -> void:
    if $Options/SFXControl.value >= 0.01:
        $Options/SFXControl/SFXIcon.texture_normal = load("res://Assets/Others/UI_Assets/Audio.png")
    else:
        $Options/SFXControl/SFXIcon.texture_normal = load("res://Assets/Others/UI_Assets/AudioMute.png")



# Brilhos nos botões do Menu
func _on_start_mouse_entered() -> void:
    $SunSetEuGostoMuito.texture = load("res://Assets/Others/Menu_Assets/Buttons/Start_SunSelected.png")
    $SunSetEuGostoMuito/AnimCursorHoverSun.play("AnimCursorHoverSun")
    
    await $SunSetEuGostoMuito/AnimCursorHoverSun.animation_finished
    
    
func _on_start_mouse_exited() -> void:
    $SunSetEuGostoMuito.texture = load("res://Assets/Others/Menu_Assets/Buttons/Start_Sun.png")
    $SunSetEuGostoMuito/AnimCursorHoverSun.play_backwards("AnimCursorHoverSun")

    await $SunSetEuGostoMuito/AnimCursorHoverSun.animation_finished


func _on_extras_mouse_entered() -> void:
    $Extras.texture = load("res://Assets/Others/Menu_Assets/Buttons/ExtrasSelected.png")

func _on_extras_mouse_exited() -> void:
    $Extras.texture = load("res://Assets/Others/Menu_Assets/Buttons/Extras.png")



func _on_shop_mouse_entered() -> void:
    $Shop.texture = load("res://Assets/Others/Menu_Assets/Buttons/Shop_Selected.png")
    $Shop/ShopEye/AnimShopEye.play("ShopEye")

func _on_shop_mouse_exited() -> void:
    $Shop.texture = load("res://Assets/Others/Menu_Assets/Buttons/Shop.png")
    $Shop/ShopEye/AnimShopEye.play_backwards("ShopEye")



func _on_settings_mouse_entered() -> void:
    $Settings.texture = load("res://Assets/Others/Menu_Assets/Buttons/Settings_Selected.png")

func _on_settings_mouse_exited() -> void:
    $Settings.texture = load("res://Assets/Others/Menu_Assets/Buttons/Settings.png")



func _on_achievements_mouse_entered() -> void:
    $Achievements.texture = load("res://Assets/Others/Menu_Assets/Buttons/Achievements_Selected.png")

func _on_achievements_mouse_exited() -> void:
    $Achievements.texture = load("res://Assets/Others/Menu_Assets/Buttons/Achievements.png")



func _on_news_mouse_entered() -> void:
    $News.texture = load("res://Assets/Others/Menu_Assets/Buttons/News_Selected.png")

func _on_news_mouse_exited() -> void:
    $News.texture = load("res://Assets/Others/Menu_Assets/Buttons/News.png")

@onready var daily_reward: Control = $NewsScreen/DailyReward
func _on_news_btn_pressed() -> void:
    $NewsScreen/NewsAnim.play("Anim")
    daily_reward._ready()

func _on_exit_pressed() -> void:
    $NewsScreen/NewsAnim.play_backwards("Anim")


func _on_exit_settings_pressed() -> void:
    if ResetOptionMenu:
        $Options/MusicControl.visible = true
        $Options/SFXControl.visible = true
        $Options/Fullscreen_CB.visible = true
        $Options/ResetSaveBTN.visible = true
        ResetOptionMenu = false
        
    else:
        $Options/SettingsAnim.play_backwards("settings")
        await $Options/SettingsAnim.animation_finished

func _on_exit_menu_pressed() -> void:
    $"Select Map/SelMapsMenu".play_backwards("SelMapsAnim")
    await $"Select Map/SelMapsMenu".animation_finished


func _on_shop_btn_pressed() -> void:
    $ColorRect/FadeIn.play("FadeIn")
    await $ColorRect/FadeIn.animation_finished
    
    get_tree().change_scene_to_file("res://Scenes/shop.tscn")


func _on_texture_button_pressed() -> void:
    $Options/Panel.visible = true
    
func _on_button_2_pressed() -> void:
    $Options/Panel.visible = false



func _on_reset_save_toggled(toggled_on: bool) -> void:
    $Options/MusicControl.visible = toggled_on
    $Options/SFXControl.visible = toggled_on
    $Options/Fullscreen_CB.visible = toggled_on
    $Options/ResetSaveBTN.visible = toggled_on
    
    $Options/ResetSave.visible = !toggled_on
    
    ResetOptionMenu = true
    
    


func _on_confirm_reset_pressed() -> void:
    $Options.visible = false
    Global.title_screen = false
    Global.LoadingScene = "menu"
    
    SaveManager.reset_save()
    
    get_tree().change_scene_to_file("res://Scenes/intro.tscn")
