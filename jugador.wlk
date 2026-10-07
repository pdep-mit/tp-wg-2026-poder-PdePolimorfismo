import wollok.game.*

object cursor {
  var property position = game.center()
  var property seleccionActual = "Girasol"
  //por ahora, por defoult va a venir seleccionado el girasol para plantarse
  
  method moverDerecha() {
    self.mover(position.right(1))
  }
  
  method moverIzquierda() {
    self.mover(position.left(1))
  }
  
  method moverArriba() {
    self.mover(position.up(1))
  }
  
  method moverAbajo() {
    self.mover(position.down(1))
  }
  
  method mover(nuevaPosicion) {
    if (nuevaPosicion.x().between(
      0,
      game.width() - 1
    ) && nuevaPosicion.y().between(0, game.height() - 1)) {
      position = nuevaPosicion
      console.println("Cursor en: " + position)
    }
  }

  method plantar() {// falta desarrollar 

  }
}