import abstracciones.*
import wollok.game.*
import zoombie.*
import movimientos.*

class Podadora inherits Visual {
  var property position
  const daño = 99999
  
  method dañoQueHace() = daño
  
  method image() = "podadora.png"
  
  method hazTuMagia() {
    game.onCollideDo(
      self,
      { entidad => if (entidad.esZoombie()) {
          self.activar()
          gestionarDañoYVida.procesarDaño(entidad, self)
        } }
    )
  }
  
  method activar() {
    game.onTick(600, "destruirTodo" + self.identity(), { self.avanzar() })
  }
  
  method avanzar() {
    if (position.x() >= 12) {
      self.detenerse()
    } else {
      position = derecha.desde(position)
    }
  }
  
  method detenerse() {
    game.removeTickEvent("destruirTodo" + self.identity())
    game.removeVisual(self)
  }
}