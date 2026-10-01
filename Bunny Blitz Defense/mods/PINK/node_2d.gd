extends CharacterBody2D

var CanMove = false
@export var SPEED: float = 300.0

func _physics_process(_delta: float) -> void:
    
    if CanMove:
        var input_direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    
        if input_direction != Vector2.ZERO:
            velocity = input_direction * SPEED
            $PINK/AnimationPlayer.play("new_animation")
        else:
            velocity = velocity.move_toward(Vector2.ZERO, SPEED)
            $PINK/AnimationPlayer.stop()
        move_and_slide()
