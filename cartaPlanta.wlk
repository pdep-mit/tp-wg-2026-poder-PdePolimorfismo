import wollok.game.*
import cursor.*
import soles.*
import patio.*
import planta.*

class CartaPlanta {
    const costeDeSoles
    const cooldown
    var estado = cartaDisponible

    method image()
    method position()

    method coste() = costeDeSoles

    method intentarPlantar(posicion) {
        estado.intentarPlantar(self, posicion)
    }

    method crearPlanta(posicion)

    method iniciarCooldown() {
        estado = cartaNoDisponible
        game.schedule(cooldown, { estado = cartaDisponible })
    }

}

object cartaDisponible {
    
    method intentarPlantar(carta, posicion) {
    if (not patio.hayPlantaEnCasilla(posicion) &&
        contadorDeSoles.tieneSuficientesSoles(carta.coste())) {
        contadorDeSoles.quitarSoles(carta.coste())

        const nuevaPlanta = carta.crearPlanta(posicion)
        patio.agregarPlanta(nuevaPlanta)
        nuevaPlanta.aparecer()

        carta.iniciarCooldown()
    }
}
}

object cartaNoDisponible {
    method intentarPlantar(carta, posicion) {}
}

object cartaGirasol inherits CartaPlanta(costeDeSoles = 50, cooldown = 8000) {
    override method crearPlanta(posicion) = new Girasol(position = posicion)
    override method image() = "cartaGirasol.png"
    override method position() = game.at(0, 1)
}

object cartaLanzaguisantes inherits CartaPlanta(costeDeSoles = 100, cooldown = 8000) {
    override method crearPlanta(posicion) = new Lanzaguisantes(position = posicion)
    override method image() = "lanzaguisantes.png"
    override method position() = game.at(0, 2)  
}  

object cartaNuez inherits CartaPlanta(costeDeSoles = 50, cooldown = 16000) {
    override method crearPlanta(posicion) = new Nuez(position = posicion)
    override method image() = "nuez.png"
    override method position() = game.at(0, 3)  
}

object cartaBonkChoi inherits CartaPlanta(costeDeSoles = 150, cooldown = 8000) {
    override method crearPlanta(posicion) = new BonkChoi(position = posicion)
    override method image() = "bonkchoi.png"
    override method position() = game.at(0, 4)  
}