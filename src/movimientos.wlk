import wollok.game.*

// bueno este objeto es para que los zoombies se muevan a la izquierda
object izquierda {
    method desde(posicion) = posicion.left(1)
}

object derecha {
    method desde(posicion) = posicion.right(1)
}

object arriba {
    method desde(posicion) = posicion.up(1)
}

object abajo {
    method desde(posicion) = posicion.down(1)
}

// Los límites del tablero en un solo lugar (antes cada uno comparaba por su cuenta).
object tablero {
    method contiene(posicion) = posicion.x().between(0, game.width() - 1) && posicion.y().between(0, game.height() - 1)
}