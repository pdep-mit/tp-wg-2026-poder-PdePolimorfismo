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
  
  method zombieEn(posicion) {
    return game.getObjectsIn(posicion).findOrDefault(
      { objeto => objeto.esZoombie() },
      null
    )
  }

  method primerZombieEnRango(distancia, distanciaMaxima) {
    if (distancia > distanciaMaxima) {
      return null
    }

    const zombie = self.zombieEn(self.position().right(distancia))
    if (zombie != null) {
      return zombie
    }

    return self.primerZombieEnRango(distancia + 1, distanciaMaxima)
  }

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
    return (self.position().x() .. (game.width() - 1)).any({ x =>
      game.getObjectsIn(game.at(x, self.position().y()))
        .any({ objeto => objeto.esZoombie() })
    })
  }

  override method morir() {
    game.removeTickEvent("ataque" + self.identity())
    super()
  }
}

class PlantaCortaDistancia inherits Planta {
  method alcanceDeAtaque() = 1

  method objetivoDeAtaque() = self.primerZombieEnRango(1, self.alcanceDeAtaque())

  override method aparecer() {
    super()
    game.onTick(velocidadDeAtaque, "golpe" + self.identity(), { self.golpear() })
  }

  method golpear() {
    const objetivo = self.objetivoDeAtaque()
    if (objetivo != null) {
      gestionarDañoYVida.procesarDaño(objetivo, self)
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
  method image() = "girasol.png"
  
  override method aparecer() {
    super()
    self.producirSoles()
  }

  method producirSoles() {
    game.onTick(
      8000,
      "generarSol" + self.identity(),
      { new Sol(posicion = self.position()).aparecerEnLaCasilla() }
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
  method image() = "lanzaguisantes.png"
}

class Nuez inherits Planta (
  vida = 4800,
  costeDeSoles = 50,
  tiempoDeRecarga = 10
) {
  method image() = "nuez1.png"
}

class Cereza inherits Planta (
  vida = 600,
  daño = 1800,
  costeDeSoles = 150,
  tiempoDeRecarga = 30
) {
  method image() = "cereza1.png"

  override method aparecer() {
    super()
    game.schedule(1000, { self.explotar() })
  }

  method explotar() {
  if (self.estaVivo()) {
    self.zombiesEnElArea().forEach({ zombie =>
      gestionarDañoYVida.procesarDaño(zombie, self)
    })

    new ExplosionArea(centro = self.position()).iniciar()

    vida = 0
    self.morir()
  }
}

  method zombiesEnElArea() {
    return game.allVisuals().filter({ visual =>
      visual.esZoombie() &&
      visual.position().x().between(self.position().x() - 1, self.position().x() + 1) &&
      visual.position().y().between(self.position().y() - 1, self.position().y() + 1)
    })
  }
}

class PlantaCarnivora inherits Planta (
  vida = 300,
  costeDeSoles = 200,
  tiempoDeRecarga = 10
) {
  const tiempoDeMasticacion = 2500
  var objetivoMasticando = null

  method image() = "plantaCarnivora1.png"

  override method aparecer() {
    super()
    game.onTick(250, "buscarPresa" + self.identity(), { self.buscarPresa() })
  }

  method buscarPresa() {
    if (objetivoMasticando != null && not objetivoMasticando.estaVivo()) {
      objetivoMasticando = null
    }

    if (self.estaVivo() && objetivoMasticando == null) {
      const presa = self.primeraPresaAlAlcance()
      if (presa != null) {
        objetivoMasticando = presa
        presa.detenerse()
        game.schedule(tiempoDeMasticacion, { self.tragar(presa) })
      }
    }
  }

  method primeraPresaAlAlcance() {
    return self.primerZombieEnRango(0, 1)
  }

  method tragar(presa) {
    if (self.estaVivo() && objetivoMasticando == presa) {
      if (presa.estaVivo()) {
        presa.morir()
      }
      objetivoMasticando = null
    }
  }

  override method morir() {
    game.removeTickEvent("buscarPresa" + self.identity())
    if (objetivoMasticando != null && objetivoMasticando.estaVivo()) {
      objetivoMasticando.reanudar()
      objetivoMasticando = null
    }
    super()
  }
}

class BonkChoi inherits PlantaCortaDistancia (
  vida = 300,
  daño = 80,
  costeDeSoles = 100,
  tiempoDeRecarga = 10,
  velocidadDeAtaque = 1000
) {
  var frameActual = 0

  method image() {
    if (frameActual == 0) {
      return "bonkChoiFrame1.png"
    }
    return "bonkChoiFrame" + frameActual + ".png"
  }

  override method alcanceDeAtaque() = 2

  override method aparecer() {
    super()
    game.onTick(
      50,
      "animarBonkChoi" + self.identity(),
      { self.actualizarAnimacion() }
    )
  }

  method actualizarAnimacion() {
    if (self.objetivoDeAtaque() == null) {
      frameActual = 0
    } else {
      self.avanzarFrame()
    }
  }

  method avanzarFrame() {
    if (frameActual >= 8) {
      frameActual = 1
    } else {
      frameActual += 1
    }
  }

  override method morir() {
    game.removeTickEvent("animarBonkChoi" + self.identity())
    super()
  }

}