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
	
	method recolectarSol() { 
        herramientaActiva.intentarRecolectarSol(position)
    }
	
	method posicionValida(pos) = pos.x().between(4,game.width() - 1) &&
    	pos.y().between(1,game.height() - 2) 
	
	method moverse(direccion){
    	const siguientePosicion = direccion.desde(position)
    	if(self.posicionValida(siguientePosicion)) position = siguientePosicion
    	
    }
	method plantar(planta) { 
        herramientaActiva.plantar(planta) 
    }

  method remover() {
      herramientaActiva.quitar()
  }
}