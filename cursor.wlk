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

    method plantar(cartaPlanta) {
    cartaPlanta.intentarPlantar(self.position())
}

    method accionar(posicion) {
        if (patio.haySolEnCasilla(posicion)) {
            const sol = patio.solEnCasilla(posicion)
            sol.recolectar()
        }
    }
}