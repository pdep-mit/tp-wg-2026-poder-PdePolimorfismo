import wollok.game.*
import zoombie.*
import patio.*
import sonidos.*
import nivel.*
import habilidades.*

class PerroSalchicha inherits Zoombie (
  habilidad = comer,
  daño = 150,
  vida = 8000,
  velocidadDeMovimiento = 1500
) {
  var estado = perroEntrando
  const acciones = [perroAullando, perroLadrando, perroRugiendo]
  
  override method initialize() {
    super()
    position = game.at(game.width() - 1, self.filaDelMedio())
  }
  
  method filaDelMedio() = (game.height() - 1).div(2)
  
  override method image() = estado.imagen()
  
  override method actuar() {
    estado.actuar(self)
  }
  
  method cambiarEstado(nuevoEstado) {
    estado = nuevoEstado
  }
  
  method posicionarse() {
    self.volverAPosicionado()
  }
  
  method volverAPosicionado() {
    self.cambiarVelocidad((18000 .. 25000).anyOne())
    // Espera 20 a 25s para la próxima acción
    self.cambiarEstado(perroPosicionado)
  }
  
  method siguienteAccion() {
    self.cambiarVelocidad(2000)
    // Muestra la imagen de la acción durante 2s antes de ejecutarla
    self.cambiarEstado(acciones.anyOne())
  }
  
  method rugir() {
    sonido.sonidoRugido()
    patio.potenciarVelocidadZoombies(0.5, 4000)
    self.volverAPosicionado()
  }
  
  method aullar() {
    const filasDisponibles = (1 .. (game.height() - 2)).asList()
    const primeraFila = filasDisponibles.anyOne()
    filasDisponibles.remove(primeraFila)
    const segundaFila = filasDisponibles.anyOne()
    
    self.invocarMaquinistaEnFila(primeraFila)
    self.invocarMaquinistaEnFila(segundaFila)
    self.volverAPosicionado()
  }
  
  method invocarMaquinistaEnFila(fila) {
    const maquinista = new MonoMaquinista(
      position = game.at(game.width() - 1, fila)
    )
    patio.agregarZoombie(maquinista)
    maquinista.aparecer()
  }
  
  method ladridoEnFila() {
    patio.plantasEnFila(position.y()).forEach({ p => p.recibirDaño(80) })
    8.times(
      { i => generarZoombis.generarZombieAleatorio(
          configuracionDeOleadas.constructoresDeZoombisAleatorios()
        ) }
    )
    self.volverAPosicionado()
  }
  
  override method serDevorado(danioPlanta) {
    self.recibirDaño(30)
  }
  
  override method serAtropellado(danioPodadora) {
    
  }
  
  override method activarPodadora(podadora) {
    
  }
}

object perroEntrando {
  method imagen() = "perroSalchicha.png"
  
  method actuar(boss) {
    if (boss.position().x() > (game.width() - 3)) boss.avanzar()
    else boss.posicionarse()
  }
}

object perroPosicionado {
  method imagen() = "perroSalchicha.png"
  
  method actuar(boss) {
    boss.siguienteAccion()
  }
}

object perroRugiendo {
  method imagen() = "perroSalchichaRugiendo.png"
  
  method actuar(boss) {
    boss.rugir()
  }
}

object perroAullando {
  method imagen() = "perroSalchichaAullando.png"
  
  method actuar(boss) {
    boss.aullar()
  }
}

object perroLadrando {
  method imagen() = "perroSalchichaRugiendo.png"
  
  method actuar(boss) {
    boss.ladridoEnFila()
  }
}