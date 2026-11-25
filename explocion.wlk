import wollok.game.*
import entidades.*
import animacion.*
import patio.*

class EfectoDeExplosion {
  const centro
  const duracionPorCuadro = 100
  
  method reproducir() {
    const animacion = new Animacion(
      frames = self.cuadros(),
      temporizador = sinTemporizador
    )
    const casillas = patio.casillasEnAreaDeExplosion(centro).map(
      { posicion => new CasillaEnLlamas(
          position = posicion,
          animacion = animacion
        ) }
    )
    
    casillas.forEach({ casilla => casilla.aparecer() })
    animacion.iniciar()
    self.programarCuadros(animacion)
    game.schedule(
      self.duracion(),
      { casillas.forEach({ casilla => casilla.desaparecer() }) }
    )
  }
  
  method programarCuadros(animacion) {
    (1 .. (self.cuadros().size() - 1)).forEach(
      { cuadro => game.schedule(
          cuadro * duracionPorCuadro,
          { animacion.actuar() }
        ) }
    )
  }
  
  method duracion() = self.cuadros().size() * duracionPorCuadro
  
  method cuadros() = [
    "secuenciaExplocion-frame1.png",
    "secuenciaExplocion-frame2.png",
    "secuenciaExplocion-frame3.png",
    "secuenciaExplocion-frame4.png",
    "secuenciaExplocion-frame5.png",
    "secuenciaExplocion-frame6.png",
    "secuenciaExplocion-frame7.png"
  ]
}

class CasillaEnLlamas inherits Entidad {
  override method actuar() {
    
  }
}