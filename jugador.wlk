import abstracciones.*
import wollok.game.*
import plantas.*
import movimientos.*
import soles.*

class ControladorDeCooldown {
  const fabrica
  var disponible = true

  method puedePlantar() = disponible

  method crearEn(posicion) = fabrica.apply(posicion)

  method iniciar(tiempoDeRecarga) {
    disponible = false
    game.schedule(tiempoDeRecarga, { disponible = true })
  }
}

const controlGirasol = new ControladorDeCooldown(
  fabrica = { posicion_ => new Girasol(position = posicion_) }
)

const controlLanzaGuisantes = new ControladorDeCooldown(
  fabrica = { posicion_ => new LanzaGuisantes(position = posicion_) }
)

const controlNuez = new ControladorDeCooldown(
  fabrica = { posicion_ => new Nuez(position = posicion_) }
)

const controlBonkChoi = new ControladorDeCooldown(
  fabrica = { posicion_ => new BonkChoi(position = posicion_) }
)

const controlCereza = new ControladorDeCooldown(
  fabrica = { posicion_ => new Cereza(position = posicion_) }
)

const controlCarnivora = new ControladorDeCooldown(
  fabrica = { posicion_ => new PlantaCarnivora(position = posicion_) }
)


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
        sol.desaparecer()
      }
    )
    }

method plantar(controlador) {
  if (not controlador.puedePlantar()) {
    game.say(self, "Planta no recargada")
  } else {
    if (not self.hayPlantaEnCasilla()) {
      const planta = controlador.crearEn(position)

      if (contadorDeSoles.solesAhora() >= planta.coste()) {
        contadorDeSoles.gastarSoles(planta.coste())
        planta.aparecer()
        controlador.iniciar(planta.tiempoDeRecarga())
      } else {
        game.say(self, "No hay suficientes soles")
      }
    }
  }
}

    // Click del mouse: mueve el cursor a la casilla clickeada y planta ahí.
  method puedePlantar(planta) = (not self.hayPlantaEnCasilla()) && (contadorDeSoles.solesAhora() >= planta.coste())
  
    // El cursor comparte casilla con otros objetos, pero no con otra planta.
   method hayPlantaEnCasilla() = game.getObjectsIn(position).any(
    { planta => planta.esPlanta() }
  )
}
