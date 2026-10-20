import wollok.game.*
import abstracciones.*
import estadoDelJuego.*
import movimientos.*
class Zoombie inherits Visual{
  var property vida
  const daño
  var property position = game.at(game.width() - 1, (0 .. (game.height() - 2)).anyOne())
  const tipoDeAtaque
  var activo = true
  
  override method esZoombie() = true
  
  method dañoQueHace() = daño
  
  method estaVivo() = vida > 0
  
  method aparecer() {
    game.addVisual(self)
    game.onTick(3000, "movimientoZoombie" + self.identity(), { self.actuar() })
  }

  method actuar() {
    const planta = self.plantaEnMiCasilla()
    if (planta != null) {
      self.comer(planta)
    } else {
      self.avanzar()
    }
  }

  method plantaEnMiCasilla() {
    return game.getObjectsIn(position).findOrDefault({ elemento => elemento.esPlanta() }, null)
  }
  
  method comer(planta) {
    planta.recibirDaño(daño)
  }

  method recibirDaño(cantidad) {
    vida = 0.max(vida - cantidad)
    if (not self.estaVivo()) {
      self.morir()
    }
  }
  
  method avanzar() {
    if (position.x() <= 2) {
      self.detenerse()
      game.removeVisual(self)
      finDelJuego.mostrarDerrota()
    } else {
      position = izquierda.desde(position)
    }
  }
  
  method detenerse() {
    if (activo) {
      activo = false
      game.removeTickEvent("movimientoZoombie" + self.identity())
    }
  }
  
  method morir() {
    self.detenerse()
    game.removeVisual(self)
  }
}


//no hay plantas en frente del zoombie, sigue su camino
object caminoLibre {
    method enfrentar(zoombie) {
        zoombie.avanzar()
    }
}

class Pinguino inherits Zoombie (
  vida = 200,
  daño = 80,
  tipoDeAtaque = "normal"
) {
  method image() = "pinguino.png"
}

class Oso inherits Zoombie (
  vida = 3600,
  daño = 5000,
  tipoDeAtaque = "especial"
) {
  method image() = "oso.png"
}

class Jirafa inherits Zoombie (
  vida = 1000,
  daño = 80,
  tipoDeAtaque = "especial"
) {
  method image() = "jirafaZoombie.png"
}

class Rinoceronte inherits Zoombie (
  vida = 1300,
  daño = 80,
  tipoDeAtaque = "especial"
) {
  method image() = "rinoZoombie.png"
}

class Mono inherits Zoombie (vida = 560, daño = 80, tipoDeAtaque = "normal") {
  method image() = "monoZoombie.png"
}

class PerroSalchicha inherits Zoombie (
  vida = 10000,
  daño = 9999,
  tipoDeAtaque = "???"
) {
  method image() = "perroSalchichaZoombie.png"
}