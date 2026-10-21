import wollok.game.*
import abstracciones.*
import estadoDelJuego.*
import movimientos.*
class Zoombie inherits Visual{
  var property vida
  const daño
  var property position = game.at(game.width() - 1, (0 .. (game.height() - 2)).anyOne())
  const property tipoDeAtaque
  var activo = true
  
  override method esZoombie() = true
  
  method dañoQueHace() = daño
  
  method estaVivo() = vida > 0
  
  method aparecer() {
    game.addVisual(self)
    game.onTick(3000, "movimientoZoombie" + self.identity(), { self.actuar() })
  }

  method actuar() {
    const planta = self.plantaQuePuedeAtacar()
    if (planta != null) {
      self.comer(planta)
    } else {
      self.avanzar()
    }
  }
  method plantaQuePuedeAtacar() {
  const plantaEnMiCasilla = game.getObjectsIn(position).findOrDefault(
    { objeto => objeto.esPlanta() },
    null
  )

  if (plantaEnMiCasilla != null) {
    return plantaEnMiCasilla
  }

  const casillaAdelante = izquierda.desde(position)
  return game.getObjectsIn(casillaAdelante).findOrDefault(
    { objeto => objeto.esPlanta() },
    null
  )
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

  method reanudar() {
    if (self.estaVivo() && not activo) {
      activo = true
      game.onTick(3000, "movimientoZoombie" + self.identity(), { self.actuar() })
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
  method image() = "pinguinoZoombie.png"
}

class Buitre inherits Zoombie (
  vida = 300,
  daño = 80,
  tipoDeAtaque = "normal"
) {
  method image() = "buitreZoombie.png"
}

class Oso inherits Zoombie (
  vida = 3600,
  daño = 300,
  tipoDeAtaque = "especial"
) {
  method image() = "osoZoombie.png"
}

class Jirafa inherits Zoombie (
  vida = 1000,
  daño = 80,
  tipoDeAtaque = "especial"
) {var frameActual = 0

  method image() {
    if (frameActual == 0) {
      return "jirafa_frame_1.png"
    }
    return "jirafa_frame_" + frameActual + ".png"
  }

  override method actuar() {
    if (self.plantaQuePuedeAtacar() == null) {
      self.iniciarAnimacion()
    } else {
      self.detenerAnimacion()
    }
    super()
  }

  method iniciarAnimacion() {
    if (frameActual == 0) {
      frameActual = 1
      game.onTick(
        350,
        "animarJirafa" + self.identity(),
        { self.cambiarFrame() }
      )
    }
  }

  method cambiarFrame() {
    if (frameActual == 5) {
      frameActual = 1
    } else {
      frameActual += 1
    }
  }

  method detenerAnimacion() {
    if (frameActual != 0) {
      game.removeTickEvent("animarJirafa" + self.identity())
      frameActual = 0
    }
  }

  override method detenerse() {
    self.detenerAnimacion()
    super()
  }
}

class Rinoceronte inherits Zoombie (
  vida = 1300,
  daño = 80,
  tipoDeAtaque = "especial"
) {
  method image() = "rinoZoombie.png"
}

class Mono inherits Zoombie (vida = 560, daño = 80, tipoDeAtaque = "normal") {var frameActual = 1

  var animacionActiva = false

  method image() = "monoframe_" + frameActual + ".png"

  override method actuar() {
  if (self.plantaQuePuedeAtacar() == null) {
    self.iniciarAnimacion()
  } else {
    self.detenerAnimacion()
  }
  super()
}

method iniciarAnimacion() {
    if (not animacionActiva) {
      animacionActiva = true
      game.onTick(
        350,
        "animarMono" + self.identity(),
        { self.cambiarFrame() }
      )
    }
  }

  method cambiarFrame() {
    if (frameActual == 8) {
      frameActual = 1
    } else {
      frameActual += 1
    }
  }

  method detenerAnimacion() {
    if (animacionActiva) {
      animacionActiva = false
      game.removeTickEvent("animarMono" + self.identity())
      frameActual = 1
    }
  }

  override method detenerse() {
    self.detenerAnimacion()
    super()
  }
}

class PerroSalchicha inherits Zoombie (
  vida = 10000,
  daño = 9999,
  tipoDeAtaque = "???"   // tenemos q definirlo 
) {
  method image() = "perroSalchichaZoombie.png"
}