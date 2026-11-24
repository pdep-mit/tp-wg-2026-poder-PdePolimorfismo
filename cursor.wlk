import wollok.game.*
import patio.*
import jugador.*
import estadoDelJuego.*

object cursor {
	method image() = "cursor.png"
	method position() = jugador.position()

	method plantar(cartaPlanta) {
		if (patio.hayPlantaEnCasilla(self.position())) {
			self.error("Ya hay una planta en esta casilla")
		}
		const nuevaPlanta = cartaPlanta.usar(self.position())
		patio.colocarPlanta(nuevaPlanta)
	}

	method accionar(posicion) {
		patio.recolectarSolEn(posicion)
		trofeo.recolectarSiEstaEn(posicion)
	}
}