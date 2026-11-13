import wollok.game.*
import patio.*
import planta.*
import cursor.*
import jugador.*

object pala{
	
	method image() = "pala.png"
	
	method position() = jugador.position()
	
	method siguiente() = cursor
	
	method accionar(posicion) {
        const pos = self.position()
        if (patio.hayPlantaEnCasilla(pos)) {
            const plantaAQuitar = patio.plantas().find({ p => p.position() == pos })
            patio.quitarPlanta(plantaAQuitar)
            plantaAQuitar.desaparecer()
        }
    }

    method plantar(cartaPlanta) { }

}