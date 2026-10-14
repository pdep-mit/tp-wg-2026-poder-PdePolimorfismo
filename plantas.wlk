import wollok.game.*
import soles.*
import abstracciones.*
import ataques.*


class Planta {

    var property position
    var property vida

    const costeDeSoles
    const tiempoDeRecarga
    const tipoDeAtaque
    const daño
    const rangoDeAtaque

    method estaVivo() = vida > 0

    method esPlanta() = true

    method dañoQueHace() = daño

    method enfrentar(zoombie) {
        zoombie.comer(self)
    }

    method recibirDaño(dañoDeZoombie) {
        dañoInfligido.procesarDaño(self, dañoDeZoombie)
    }

    method morir() {
        game.removeVisual(self)
    }

    method estaEnSuRango(zoombie) {
        const mismaFila = zoombie.position().y() == position.y()
        const distancia = zoombie.position().x() - position.x()

        return mismaFila &&
            distancia >= 0 &&
            distancia <= rangoDeAtaque
    }

    // POLIMORFISMO: la planta no sabe cómo ataca, se lo pide a su tipo de ataque.

    method atacar(zoombie) {
        if (zoombie.estaVivo()) {
            tipoDeAtaque.ejecutar(self, zoombie)
        }
    }

    // method atacar(zoombie) {
    //     if (self.estaEnSuRango(zoombie)) {
    //         tipoDeAtaque.ejecutar(self, zoombie)
    //     }
    // }
}


class Girasol inherits Planta(
    vida = 300,
    costeDeSoles = 50,
    tiempoDeRecarga = 5,
    tipoDeAtaque = sinAtaque,
    daño = 0,
    rangoDeAtaque = 0
) 
{

  method image() = "girasol.png"
}


class LanzaGuisantes inherits Planta(
    vida = 300,
    costeDeSoles = 100,
    tiempoDeRecarga = 5,
    tipoDeAtaque = ataqueLargaDistancia,
    daño = 50,
    rangoDeAtaque = 3)
{

     method image() = "lanzaguisantes.png"
}


class BonkChoi inherits Planta(
    vida = 400,
    costeDeSoles = 150,
    tiempoDeRecarga = 5,
    tipoDeAtaque = ataqueCuerpoACuerpo,
    daño = 100,
    rangoDeAtaque = 1
) {

    method image() = "bonkChoi.png"
}


class Nuez inherits Planta(
    vida = 800,
    costeDeSoles = 50,
    tiempoDeRecarga = 10,
    tipoDeAtaque = sinAtaque,
    daño = 0,
    rangoDeAtaque = 0
) {

     method image() = "nuez.png"
}


class Cereza inherits Planta(
    vida = 100,
    costeDeSoles = 150,
    tiempoDeRecarga = 40,
    tipoDeAtaque = ataqueExplosivo,
    daño = 0,
    rangoDeAtaque = 1
) {

     method image() = "cereza.png"
}