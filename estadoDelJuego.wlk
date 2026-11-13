import abstracciones.*
import wollok.game.*
import soles.*
import jugador.*
import patio.*
import cartaPlanta.*

object finDelJuego{
	var perdido = false

	method mostrarDerrota() {
		if (not perdido) {
			perdido = true

			patio.entidades().forEach({ entidad => entidad.desaparecer() })
			patio.casillas().forEach({ casilla => game.removeVisual(casilla) })
            game.removeVisual(jugador)
            game.removeVisual(contadorDeSoles)

			game.removeVisual(cartaGirasol)
    		game.removeVisual(cartaLanzaguisantes)
    		game.removeVisual(cartaNuez)
    		game.removeVisual(cartaBonkChoi)

			musica.detenerMusica()
			game.boardGround("gameOver.png")
			game.schedule(1000, { game.stop() })
		}
	}
}