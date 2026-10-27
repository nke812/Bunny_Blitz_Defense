extends Panel

func _ready() -> void:
    PlayerAchievements.carregar_dados()
    VerificarAchievements()
    
func VerificarAchievements():
    # --- 1. Calendar (DailyBudy) ---
    if PlayerAchievements.DailyBudy in [1, 2]:
        $ScrollContainer/Achievements/Calendar.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/Calendar/GridContainer/Reward1.disabled = true
        if PlayerAchievements.DailyBudy == 1:
            $ScrollContainer/Achievements/Calendar/GridContainer/Reward1.disabled = false
    else:
        $ScrollContainer/Achievements/Calendar.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/Calendar/GridContainer/Reward1.disabled = true

    # --- 2. FirstSkin (FancyBunnies) ---
    if PlayerAchievements.FancyBunnies in [1, 2]:
        $ScrollContainer/Achievements/FirstSkin.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/FirstSkin/GridContainer/Reward2.disabled = true
        if PlayerAchievements.FancyBunnies == 1:
            $ScrollContainer/Achievements/FirstSkin/GridContainer/Reward2.disabled = false
    else:
        $ScrollContainer/Achievements/FirstSkin.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/FirstSkin/GridContainer/Reward2.disabled = true

    # --- 3. ItensShop (IWantThatOne) ---
    if PlayerAchievements.IWantThatOne in [1, 2]:
        $ScrollContainer/Achievements/ItensShop.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/ItensShop/GridContainer/Reward3.disabled = true
        if PlayerAchievements.IWantThatOne == 1:
            $ScrollContainer/Achievements/ItensShop/GridContainer/Reward3.disabled = false
    else:
        $ScrollContainer/Achievements/ItensShop.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/ItensShop/GridContainer/Reward3.disabled = true

    # --- 4. 9999Coins (IAmRichAsBunny) ---
    if PlayerAchievements.IAmRichAsBunny in [1, 2]:
        $"ScrollContainer/Achievements/9999Coins".modulate = Color("#ffffff")
        $"ScrollContainer/Achievements/9999Coins/GridContainer/Reward4".disabled = true
        if PlayerAchievements.IAmRichAsBunny == 1:
            $"ScrollContainer/Achievements/9999Coins/GridContainer/Reward4".disabled = false
    else:
        $"ScrollContainer/Achievements/9999Coins".modulate = Color("ffffff78")
        $"ScrollContainer/Achievements/9999Coins/GridContainer/Reward4".disabled = true

    # --- 5. Rookienho (ALittleTinyBunny) ---
    if PlayerAchievements.ALittleTinyBunny in [1, 2]:
        $ScrollContainer/Achievements/Rookienho.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/Rookienho/GridContainer/Reward5.disabled = true
        if PlayerAchievements.ALittleTinyBunny == 1:
            $ScrollContainer/Achievements/Rookienho/GridContainer/Reward5.disabled = false
    else:
        $ScrollContainer/Achievements/Rookienho.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/Rookienho/GridContainer/Reward5.disabled = true

    # --- 6. 1000Kills (KillThemAll) ---
    if PlayerAchievements.KillThemAll in [1, 2]:
        $"ScrollContainer/Achievements/1000Kills".modulate = Color("#ffffff")
        $"ScrollContainer/Achievements/1000Kills/GridContainer/Reward6".disabled = true
        if PlayerAchievements.KillThemAll == 1:
            $"ScrollContainer/Achievements/1000Kills/GridContainer/Reward6".disabled = false
    else:
        $"ScrollContainer/Achievements/1000Kills".modulate = Color("ffffff78")
        $"ScrollContainer/Achievements/1000Kills/GridContainer/Reward6".disabled = true

    # --- 7. WinGrassLands ---
    if PlayerAchievements.WinGrassLands in [1, 2]:
        $ScrollContainer/Achievements/WinGrassLands.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/WinGrassLands/GridContainer/Reward7.disabled = true
        if PlayerAchievements.WinGrassLands == 1:
            $ScrollContainer/Achievements/WinGrassLands/GridContainer/Reward7.disabled = false
    else:
        $ScrollContainer/Achievements/WinGrassLands.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/WinGrassLands/GridContainer/Reward7.disabled = true

    # --- 8. WinShimmerRoads ---
    if PlayerAchievements.WinShimmerRoads in [1, 2]:
        $ScrollContainer/Achievements/WinShimmerRoads.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/WinShimmerRoads/GridContainer/Reward8.disabled = true
        if PlayerAchievements.WinShimmerRoads == 1:
            $ScrollContainer/Achievements/WinShimmerRoads/GridContainer/Reward8.disabled = false
    else:
        $ScrollContainer/Achievements/WinShimmerRoads.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/WinShimmerRoads/GridContainer/Reward8.disabled = true

    # --- 9. WinSandStreets ---
    if PlayerAchievements.WinSandStreets in [1, 2]:
        $ScrollContainer/Achievements/WinSandStreets.modulate = Color("#ffffff")
        $ScrollContainer/Achievements/WinSandStreets/GridContainer/Reward9.disabled = true
        if PlayerAchievements.WinSandStreets == 1:
            $ScrollContainer/Achievements/WinSandStreets/GridContainer/Reward9.disabled = false
    else:
        $ScrollContainer/Achievements/WinSandStreets.modulate = Color("ffffff78")
        $ScrollContainer/Achievements/WinSandStreets/GridContainer/Reward9.disabled = true

func _mudar_texto_label(valor: float) -> void:
    $"../BunnyCoins/Price".text = str(int(valor))

func reward() -> void:
    PlayerAchievements.guardar_dados()

    $"../BunnyCoinsNode/AmountLabel".text = str("+ 100")
    $"../BunnyCoinsNode/EarnCoinsAnim".play("EarnCoinsAnim")
    
    var tween = create_tween()
    var saldo_antigo = SaveManager.BunnyCoins
    var saldo_novo = SaveManager.BunnyCoins + 100
    
    SaveManager.BunnyCoins = SaveManager.BunnyCoins + 100

    tween.tween_method(
        _mudar_texto_label, 
        saldo_antigo, 
        saldo_novo, 
        1.0
    ).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    
    SaveManager.guardar_dados()


func _on_reward_1_pressed() -> void:
    $ScrollContainer/Achievements/Calendar/GridContainer/Reward1.disabled = true
    PlayerAchievements.DailyBudy = 2
    reward()

func _on_reward_2_pressed() -> void:
    $ScrollContainer/Achievements/FirstSkin/GridContainer/Reward2.disabled = true
    PlayerAchievements.FancyBunnies = 2
    reward()

func _on_reward_3_pressed() -> void:
    $ScrollContainer/Achievements/ItensShop/GridContainer/Reward3.disabled = true
    PlayerAchievements.IWantThatOne = 2
    reward()

func _on_reward_4_pressed() -> void:
    $"ScrollContainer/Achievements/9999Coins/GridContainer/Reward4".disabled = true
    PlayerAchievements.IAmRichAsBunny = 2
    reward()

func _on_reward_5_pressed() -> void:
    $ScrollContainer/Achievements/Rookienho/GridContainer/Reward5.disabled = true
    PlayerAchievements.ALittleTinyBunny = 2
    reward()


func _on_reward_6_pressed() -> void:
    $"ScrollContainer/Achievements/1000Kills/GridContainer/Reward6".disabled = true
    PlayerAchievements.KillThemAll = 2
    reward()


func _on_reward_7_pressed() -> void:
    $ScrollContainer/Achievements/WinGrassLands/GridContainer/Reward7.disabled = true
    PlayerAchievements.WinGrassLands = 2
    reward()


func _on_reward_8_pressed() -> void:
    $ScrollContainer/Achievements/WinShimmerRoads/GridContainer/Reward8.disabled = true
    PlayerAchievements.WinShimmerRoads = 2
    reward()


func _on_reward_9_pressed() -> void:
    $ScrollContainer/Achievements/WinSandStreets/GridContainer/Reward9.disabled = true
    PlayerAchievements.WinSandStreets = 2
    reward()
