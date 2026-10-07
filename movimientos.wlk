import wollok.game.*



// bueno este objeto es para que los zoombies se muevan a la izquierda

object movimientoHaciaLaIzquierda {
  method mover(entidad) {
    if (entidad.posicion().x() > 0) {      
        entidad.posicion(entidad.posicion().left(1))
    } else {
        self.llegoAlObjetivo(entidad)  
    }    
  }

  method llegoAlObjetivo(entidad) { 
  game.removeVisual(entidad)   // como en el method de morir, una vez que llegó al cuidador, chau, desaparece
  }
}



// este sería para las plantas que son las que disparan las cosas
object movimientoHaciaLaDerecha {
  
  method mover(entidad) {
    if (entidad.posicion().x() < game.width() - 1) {
        entidad.posicion(entidad.posicion().right(1))
    } else {
        game.removeVisual(entidad)   //same los demás, desaparecen cuando se salga de la pantalla
    }
  }
}