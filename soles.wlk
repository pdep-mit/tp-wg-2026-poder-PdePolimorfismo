import abstracciones.*
import wollok.game.*
import movimientos.*

class Sol inherits Visual{
    var property posicion = game.at(
    4.randomUpTo(game.width() - 1).truncate(0),
    game.height() - 1
  )
    var recolectado = false
    const valorDelSol = 25
    var cayendo = true
    const tiempoEnPiso = 4000

    method image() = "sol.png"

    method position() = posicion

    override method esSol() = true

    method valor () = valorDelSol

    method aparecerCayendo() {
       game.addVisual(self)
       game.onTick(1500, "crearSol" + self.identity(), { self.descender() })
    }

    method aparecerEnLaCasilla() {
       game.addVisual(self)
       self.esperarYDesaparecer()
    }

    method desaparecer() {
        if (not recolectado) {
           recolectado = true
           cayendo = false
           game.removeTickEvent("crearSol" + self.identity())
           game.removeVisual(self)
        }
    }

    method descender() {
       if (posicion.y() == 0) {
      self.detener()
    } else {
      posicion = abajo.desde(posicion)
    }
    }

    method detener() {
        if (cayendo) {
            cayendo = false
            game.removeTickEvent("crearSol" + self.identity())
            self.esperarYDesaparecer()
        }
    }

    method esperarYDesaparecer() {
    game.schedule(tiempoEnPiso, { self.desaparecer() })
  }

}

object contadorDeSoles inherits Visual {
     var solesActuales = 25
  
     method solesAhora() = solesActuales
  
     method position() = game.at(0, game.height() - 1)
  
     //method image() = "controlador.png"
  
     method acumularSoles(cantidad) {
       solesActuales += cantidad
     }
  
     method gastarSoles(cantidad) {
       solesActuales -= cantidad
     }
}

object generadorDeSoles {

    var property frecuencia = 8000
    var activo = false

    method iniciar() {
       if (not activo) {
      activo = true
      game.onTick(frecuencia, "lluviaDeSoles", { self.generarSol() })
    }
    }

    method generarSol() {
    new Sol().aparecerCayendo()
  }

    method detener() {
    if (activo) {
      activo = false
      game.removeTickEvent("lluviaDeSoles")
    }
  }
}
