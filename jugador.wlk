import abstracciones.*
import wollok.game.*
import plantas.*
import movimientos.*
import soles.*

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

const controlDeGirasol = new ControladorDeCooldown(nombre = "Girasol", fabrica = { posicion_ => new Girasol(position = posicion_) })

object cursor inherits Visual{

  var property position = game.center()
  
  method image() = "cursor.png"

  method mover(direccion) {
        const siguientePosicion = direccion.desde(position)
        if (self.posicionValida(siguientePosicion)) {
      position = siguientePosicion
    }
    }

     method posicionValida(pos) = pos.x().between(4,game.width() - 1) && pos.y().between(0, game.height() - 2)

    // Recolecta un sol únicamente si hay uno en la misma celda que el cursor.
  method recolectarSol() {
         game.getObjectsIn(position).filter({ objeto => objeto.esSol() }).forEach(
      { sol =>
        contadorDeSoles.acumularSoles(sol.valor())
        return sol.desaparecer()
      }
    )
    }

  method plantar(planta) {
        // Consultamos ambos estados de forma limpia con un booleano
        if (self.puedePlantar(planta)) {
            contadorDeSoles.gastarSoles(planta.coste())
            planta.position(position)
            planta.aparecer()
    }
    }

    // Click del mouse: mueve el cursor a la casilla clickeada y planta ahí.
  method puedePlantar(planta) = (not self.hayPlantaEnCasilla()) && (contadorDeSoles.solesAhora() >= planta.coste())
  
    // El cursor comparte casilla con otros objetos, pero no con otra planta.
   method hayPlantaEnCasilla() = game.getObjectsIn(position).any(
    { planta => planta.esPlanta() }
  )
}
