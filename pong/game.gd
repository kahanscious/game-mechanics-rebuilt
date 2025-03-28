extends Node2D

@onready var ball: Ball = $Ball
@onready var player_1_score_label: Label = $Score/Player1Score
@onready var player_2_score_label: Label = $Score/Player2Score
@onready var left_goal: Area2D = $LeftGoal
@onready var right_goal: Area2D = $RightGoal

var player_1_score: int = 0
var player_2_score: int = 0


func _on_left_goal_body_entered(body: Node2D) -> void:
	if body == ball:
		player_2_score += 1
		player_2_score_label.text = str(player_2_score)
		ball.reset_ball()


func _on_right_goal_body_entered(body: Node2D) -> void:
	if body == ball:
		player_1_score += 1
		player_1_score_label.text = str(player_1_score)
		ball.reset_ball()
