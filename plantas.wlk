import wollok.game.*
import soles.*
import zoombie.*
import abstracciones.*

class Planta {
    var property posicion
    var property vida 
    var property estaPlantada = true
    var property ataque  // bueno, esto sería un objeto nuevo que tendriamos q definir. O sea, distintos tipos de ataque, les parece?
   
    const rangoDeAtaque = 3 // esto sería para contar la cantidad de casiilleros hacia la derecha. Creo que cuando el zoombie esté a 3 casilleros es una buena distancia para atacar, sino pueden ser 4. 

    method estaVivo () = vida > 0

    method esPlanta() = true // una planta ES una planta

    method enfrentar(zoombie) { zoombie.comer(self) }

    method recibirDaño (dañoDeZoombie) {
         dañoInfligido.procesarDaño(self,dañoDeZoombie)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
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
    const property  coste = 50
    var property vida = 300
    const tiempoDeRecarga = 5
    var property position = game.origin()

    method image() = "girasol.png"
    method esPlanta() = true
    method enfrentar(zoombie) { zoombie.comer(self) }
    method tiempoDeRecarga() = tiempoDeRecarga
    method estaVivo() = vida > 0

    method recibirDaño(cantidad) {
        vida = vida - cantidad
        if (not self.estaVivo()) {
            self.morir()
        }
    }

    method morir() {
        game.removeVisual(self)
    }

}

class LanzaGuisantes {
    const property coste = 100
    const property daño = 20
    var property vida = 300
    const property tiempoDeRecarga = 5
    const property velocidadDeAtaque = 1.5
}

class Nuez {
    const property coste = 50
    var property vida = 5000
    const property tiempoDeRecarga = 20
}


class Cereza {
    const property coste = 150
    const property daño = 1800
    const property tiempoDeRecarga = 50
}

class BonkChoi {
    const property coste = 150
    const property daño = 20
    var property vida = 300
    const property tiempoDeRecarga = 5
    const property velocidadDeAtaque = 0.36
}