import wollok.game.*
import patio.*
import entidades.*
import movimientos.*
import pala.*
import jugador.*
import soles.*

object cursor{
	
    method image() = "cursor.png"
    
    method position() = jugador.position()
    
    method siguiente() = pala
    
    method puedePlantar(casilla) = not patio.hayPlantaEnCasilla(casilla)
    
	method plantar(planta) {
        if (self.puedePlantar(self.position()) && contadorDeSoles.tieneSuficientesSoles(planta.coste())) {
            contadorDeSoles.quitarSoles(planta.coste())
            planta.position(self.position())
            patio.agregarPlanta(planta)
            planta.aparecer()
        }  
    }

    method intentarRecolectarSol(posicion) {
        if (patio.haySolEnCasilla(posicion)) {
            const sol = patio.solEnCasilla(posicion)
            contadorDeSoles.agregarSoles(sol.valor())
            sol.desaparecer()
        }
    }

    method remover() { }
}