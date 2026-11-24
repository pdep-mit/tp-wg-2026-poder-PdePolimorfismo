import wollok.game.*
import cursor.*
import movimientos.*

object jugador {
	var property position = game.center()
	var herramientaActiva = cursor
	
	method equipar(herramienta) {
		herramientaActiva = herramienta
	}
	
	method image() = herramientaActiva.image()

	method posicionValida(pos) = pos.x().between(3, game.width() - 2) &&
		pos.y().between(1, game.height() - 2) 
	
	method moverse(direccion) {
		const siguientePosicion = direccion.desde(position)
		if (self.posicionValida(siguientePosicion)) {
			position = siguientePosicion
		}
	}

	method plantar(cartaPlanta) { 
		self.equipar(cursor)
		herramientaActiva.plantar(cartaPlanta) 
	}

	method accionar() {
		herramientaActiva.accionar(position)
	}
}