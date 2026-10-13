import wollok.game.*

object finDelJuego {
	var perdido = false

	method mostrarDerrota() {
		if (not perdido) {
			perdido = true
			game.addVisual(pantallaDerrota)
		}
	}
}

object pantallaDerrota {
	method position() = game.center()
	method image() = "perdiste.png"
}