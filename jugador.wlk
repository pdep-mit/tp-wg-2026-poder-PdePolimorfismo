import wollok.game.*
import plantas.*
import movimientos.*

class ControladorDeCooldown {
    const property nombre
    const fabrica          // bloque: posicion -> planta nueva
    var lista = true

    method puedePlantar() = lista

    method plantarEn(posicion) {
        if (lista){
        const planta = fabrica.apply(posicion)
        game.addVisual(planta)
        lista = false
        // Cada planta sabe cuánto tarda en recargarse.
        game.schedule(planta.tiempoDeRecarga() * 1000, { lista = true })
        }
    }
}

const controlDeGirasol = new ControladorDeCooldown(nombre = "Girasol", fabrica = { posicion => new Girasol(position = posicion) })

object cursor {
  var property position = game.center()
  var property seleccionActual = controlDeGirasol
  //por ahora, por defoult va a venir seleccionado el girasol para plantarse
  
  method image() = "cursor.png"

  method esPlanta() = false
  method esSol() = false

  method seleccionar(controlador) {
        seleccionActual = controlador
    }

  method mover(direccion) {
        const siguiente = direccion.desde(position)
        if (tablero.contiene(siguiente)) {
            position = siguiente
        }
    }

    // Recolecta un sol únicamente si hay uno en la misma celda que el cursor.
  method recolectarSol() {
        const sol = game.getObjectsIn(position).findOrDefault({ objeto => objeto.esSol() }, sinSol)
        
        if (sol != sinSol) {
        sol.recolectar()
    }
    }

  method plantar() {
        // Consultamos ambos estados de forma limpia con un booleano
        if (self.estaCasillaLibre() && seleccionActual.puedePlantar()) {
            seleccionActual.plantarEn(position)
        } else {
            game.say(self, "¡Planta no recargada!")
        }
    }

    // Click del mouse: mueve el cursor a la casilla clickeada y planta ahí.
  method irYPlantar(posicion) {
        if (tablero.contiene(posicion)) {
            position = posicion
            self.plantar()
        }
    }

    // El cursor comparte casilla con otros objetos, pero no con otra planta.
  method estaCasillaLibre() {
        return not game.getObjectsIn(position).any({ objeto => objeto.esPlanta() })
    }
}

object sinSol {
    method recolectar() {}
}

object visualContadorDeSoles {

    var solesActuales = 50
    
    method position() = game.at(0,game.height()-1.2)

    method image() = "controlador.png"

}