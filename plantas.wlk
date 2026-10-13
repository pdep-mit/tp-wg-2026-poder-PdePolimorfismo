import wollok.game.*
import soles.*
import zoombie.*
import abstracciones.*

class Planta {
    var property posicion
    var property vida 
    var property estaPlantada = true
    var property ataque = ataqueBasico // bueno, esto sería un objeto nuevo que tendriamos q definir. O sea, distintos tipos de ataque, les parece?
   
    const rangoDeAtaque = 3 // esto sería para contar la cantidad de casiilleros hacia la derecha. Creo que cuando el zoombie esté a 3 casilleros es una buena distancia para atacar, sino pueden ser 4. 

    method estaVivo () = vida > 0

    method recibirDaño (dañoDeZoombie) {
        dañoInflingido.procesarDaño(self, dañoDeZoombie)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pantalla 
    }


    method estaEnSuRango (zoombie) {
        const mismaFila = zoombie.posicion().y() == posicion.y()
        const distanciaEnEjeX = zoombie.posicion().x() - posicion.x()

        return mismaFila && distanciaEnEjeX >= 0 && distanciaEnEjeX <= rangoDeAtaque  // esto nos devolveria true o false directamente (no sé si quedó muy largo y poco expresivo)
    }

    method atacar(zoombie) {
        if (self.estaEnSuRango(zoombie)) {
            ataque.ejecutar(self,zoombie)
        }
    }
}

class Girasol {
    const coste = 50
    var property durabilidad = 300
    const tiempoDeRecarga = 5

}

class LanzaGuisantes {
    const coste = 100
    const daño = 20
    var property durabilidad = 300
    const tiempoDeRecarga = 5
    const velocidadDeAtaque = 1.5
}

class Nuez {
    const coste = 50
    var property durabilidad = 5000
    const tiempoDeRecarga = 20
}


class Cereza {
    const coste = 150
    const daño = 1800
    const tiempoDeRecarga = 50
}

class BonkChoi {
    const coste = 150
    const daño = 20
    var property durabilidad = 300
    const tiempoDeRecarga = 5
    const velocidadDeAtaque = 0.36
}