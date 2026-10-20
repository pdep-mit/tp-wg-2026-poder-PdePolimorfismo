import wollok.game.*
import soles.*
import abstracciones.*
import ataques.*
import movimientos.*



class Planta inherits Visual{

    var property vida
    const property costeDeSoles
    const property tiempoDeRecarga = 10
    const property daño = 0
    const property velocidadDeAtaque = 0
    var property position = game.at(0, 0)

    override method esPlanta() = true
  
  method coste() = costeDeSoles
  
  method dañoQueHace() = daño
  
  method estaVivo() = vida > 0
  
  method aparecer() {
    game.addVisual(self)
  }
  
  method recibirDaño(cantidad) {
    vida = 0.max(vida - cantidad)
    if (not self.estaVivo()) {
      self.morir()
    }
  }

  method morir() {
    game.removeVisual(self)
  }
}



class PlantaLargaDistancia inherits Planta {
  override method aparecer() {
    super()
    game.onTick(velocidadDeAtaque, "ataque" + self.identity(), { self.intentarDisparar() })
  }

  method intentarDisparar() {
    if (self.hayZoombieEnFila()) {
      self.disparar()
    }
  }

  method disparar() {
    const p = new Proyectil(position = self.position(), daño = self.dañoQueHace())
    p.aparecer()
  }

  method hayZoombieEnFila() {
    return game.allVisuals().any({ visual =>
      visual.esZoombie() &&
      visual.position().y() == self.position().y() &&
      visual.position().x() >= self.position().x()
    })
  }

  override method morir() {
    game.removeTickEvent("ataque" + self.identity())
    super()
  }
}

class PlantaCortaDistancia inherits Planta {
  override method aparecer() {
    super()
    game.onTick(velocidadDeAtaque, "golpe" + self.identity(), { self.golpear() })
  }

  method golpear() {
    const objetivo = game.getObjectsIn(derecha.desde(self.position())).findOrDefault(
      { obj => obj.esZoombie() },
      null
    )
    if (objetivo != null) {
      objetivo.recibirDaño(self.dañoQueHace())
    }
  }

  override method morir() {
    game.removeTickEvent("golpe" + self.identity())
    super()
  }
}



class Girasol inherits Planta (
  vida = 300,
  costeDeSoles = 50,
  tiempoDeRecarga = 10
) {
  method image() = "girasol1.png"
  
  override method aparecer() {
    super()
    self.producirSoles()
  }

  method producirSoles() {
    game.onTick(
      8000,
      "generarSol" + self.identity(),
      { new Sol(position = self.position()).aparecerEnLaCasilla() }
    )
  }

  override method morir() {
    game.removeTickEvent("generarSol" + self.identity())
    super()
  }
}



class LanzaGuisantes inherits PlantaLargaDistancia (
  vida = 300,
  daño = 70,
  costeDeSoles = 100,
  tiempoDeRecarga = 15,
  velocidadDeAtaque = 2000
) {
  method image() = "lanzaGuisantes.png"
}

class Nuez inherits Planta (
  vida = 4800,
  costeDeSoles = 75,
  tiempoDeRecarga = 10
) {
  method image() = "nuez.png"
}

class Cereza inherits Planta (
  vida = 600,
  daño = 1800,
  costeDeSoles = 150,
  tiempoDeRecarga = 30
) {
  method image() = "cereza.png"
}

class BonkChoi inherits PlantaCortaDistancia (
  vida = 300,
  daño = 60,
  costeDeSoles = 175,
  tiempoDeRecarga = 10,
  velocidadDeAtaque = 1500
) {
  method image() = "bonkChoi.png"
}