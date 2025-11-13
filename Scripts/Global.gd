extends Node

var cont = 3

func next_event():
	Dialogic.start("evento" + str(cont))
	cont+=1
