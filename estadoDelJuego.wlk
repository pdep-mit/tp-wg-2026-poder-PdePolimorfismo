import abstracciones.*
import wollok.game.*
import soles.*

object finDelJuego{
	var perdido = false

	method mostrarDerrota() {
		if (not perdido) {
			perdido = true
			game.removeTickEvent("crearZoombie")
			//generadorDeSoles.detener()
			//game.addVisual(pantallaDerrota)
		}
	}
}