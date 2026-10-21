import wollok.game.*
import movimientos.*

object gestionarDañoYVida {

    method procesarDaño (victima , atacante) {
         victima.recibirDaño(atacante.dañoQueHace()) 
    }
}

class Visual {

  method esPlanta() = false
  
  method esZoombie() = false
  
  method esSol() = false
  
}

class Proyectil inherits Visual {
  var property position
  const velocidad = 200
  const daño
  var activo = true
  
  method dañoQueHace() = daño
  
  method image() = "guisante.png"
  
  method aparecer() {
    game.addVisual(self)
    game.onTick(velocidad, "dispararse" + self.identity(), { self.avanzar() })
    self.chequeoImpactoInmediato()
  }
  
  method chequeoImpactoInmediato() {
    const zombie = game.getObjectsIn(position).findOrDefault(
      { e => e.esZoombie() },
      null
    )
    if ((zombie != null) and activo) self.impactar(zombie)
  }
  
  method impactar(zombie) {
    if (activo) {
      gestionarDañoYVida.procesarDaño(zombie, self)
      self.detenerse()
    }
  }
  
  method avanzar() {
    if (activo) {
      self.chequeoImpactoInmediato()
      if (activo) {
        if (position.x() >= (game.width() - 2)) {
          self.detenerse()
        } else {
          position = derecha.desde(position)
          self.chequeoImpactoInmediato()
        }
      }
    }
  }
  
  method detenerse() {
    if (activo) {
      activo = false
      game.removeTickEvent("dispararse" + self.identity())
      game.removeVisual(self)
    }
  }
}

class ExplosionCelda inherits Visual{

  var property position
  var frameActual = 1

  method image() = "secuenciaExploion-frame" + frameActual + ".png"

  method avanzarFrame() {
    frameActual += 1
  }

  method estaEnUltimoFrame() = frameActual == 7
}

class ExplosionArea {
  const property centro
  const celdas = []

  method iniciar() {
    self.crearCeldas()
    game.onTick(
      120,
      "animarExplosion" + self.identity(),
      { self.avanzarAnimacion() }
    )
  }

  method crearCeldas() {
    (-1..1).forEach({ desplazamientoX =>
      (-1..1).forEach({ desplazamientoY =>
        const x = centro.x() + desplazamientoX
        const y = centro.y() + desplazamientoY

        if (x.between(0, game.width() - 1) and y.between(0, game.height() - 1)) {
          const celda = new ExplosionCelda(position = game.at(x, y))
          celdas.add(celda)
          game.addVisual(celda)
        }
      })
    })
  }

  method avanzarAnimacion() {
    if (celdas.all({ celda => celda.estaEnUltimoFrame() })) {
      self.finalizar()
    } else {
      celdas.forEach({ celda => celda.avanzarFrame() })
    }
  }

  method finalizar() {
    game.removeTickEvent("animarExplosion" + self.identity())
    celdas.forEach({ celda => game.removeVisual(celda) })
  }
}
