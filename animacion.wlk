import wollok.game.*

class Animacion {
    const frames
    var indice = 0

    method imagenActual() = frames.get(indice)

    method avanzarFrame() { 
        indice = (indice + 1) % frames.size()
    }

    method reiniciar() {
        indice = 0
    }
}