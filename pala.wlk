import wollok.game.*
import patio.*
import cursor.*
import jugador.*

object pala {
	method image() = "pala.png"
	method position() = jugador.position()
	
	method accionar(posicion) {
		patio.removerPlantaEn(self.position())
	}
}