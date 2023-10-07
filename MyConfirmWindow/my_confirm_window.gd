extends Control

signal button1
signal button2

func set_confirm_box(title, question, button_1_text, button_2_text):
	$BlockerPanel/MainPanel/HeaderLabel.set_text(title)
	$BlockerPanel/MainPanel/QuestionLabel.set_text(question)
	$BlockerPanel/MainPanel/ButtonContainer/Button1.set_text(button_1_text)
	$BlockerPanel/MainPanel/ButtonContainer/Button2.set_text(button_2_text)

func _on_button_1_pressed():
	button1.emit()
	queue_free()

func _on_button_2_pressed():
	button2.emit()
	queue_free()

func _on_close_button_pressed():
	queue_free()
