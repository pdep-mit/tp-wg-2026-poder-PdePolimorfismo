import abstracciones.*
import wollok.game.*
import soles.*
import jugador.*



object finDelJuego{
	var perdido = false

	method mostrarDerrota() {
		if (not perdido) {
			perdido = true
			game.say(jugador, "¡Perdiste!")
			game.schedule(1000, { game.stop() })
		}
	}
}