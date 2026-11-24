import wollok.game.*

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
