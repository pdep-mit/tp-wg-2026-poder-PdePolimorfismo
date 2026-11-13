import wollok.game.*
import cursor.*
import pala.*
import patio.*

object jugador{
	
	var property position = game.center()
	var herramientaActiva = cursor
	
	method equipar(herramienta) {
        herramientaActiva = herramienta
    }
	
	method image() = herramientaActiva.image()

	
	method posicionValida(pos) = pos.x().between(4,game.width() - 1) &&
    	pos.y().between(1,game.height() - 2) 
	
	method moverse(direccion){
    	const siguientePosicion = direccion.desde(position)
    	if(self.posicionValida(siguientePosicion)) position = siguientePosicion
    	
    }
	method plantar(cartaPlanta) { 
        herramientaActiva.plantar(cartaPlanta) 
    }

	method accionar() {
		herramientaActiva.accionar(position)
	}
}