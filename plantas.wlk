import wollok.game.*
import soles.*
import zoombie.*
import abstracciones.*



class Planta {
    var property position
    var property vida 
    var property costeDeSoles  
    var property estaPlantada = true
    var property tipoDeAtaque // bueno, esto sería un objeto nuevo que tendriamos q definir. O sea, distintos tipos de ataque
    var property tiempoDeRecarga  
    const daño
   
    const rangoDeAtaque = 3 // esto sería para contar la cantidad de casiilleros hacia la derecha. Creo que cuando el zoombie esté a 3 casilleros es una buena distancia para atacar, sino pueden ser 4. 

    method estaVivo () = vida > 0

    method image() {}

    method esPlanta() = true // una planta ES una planta

    method enfrentar(zoombie) { zoombie.comer(self) }

    method recibirDaño (dañoDeZoombie) {
         dañoInfligido.procesarDaño(self,dañoDeZoombie)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
    }


    method estaEnSuRango (zoombie) {
        const mismaFila = zoombie.posicion().y() == position.y()
        const distanciaEnEjeX = zoombie.posicion().x() - position.x()

        return mismaFila && distanciaEnEjeX >= 0 && distanciaEnEjeX <= rangoDeAtaque  // esto nos devolveria true o false directamente (no sé si quedó muy largo y poco expresivo)
    }

    method atacar(zoombie) {
        if (self.estaEnSuRango(zoombie)) {
            tipoDeAtaque.ejecutar(self,zoombie)
        }
    }
}

class Girasol inherits Planta(vida = 300,costeDeSoles = 50,tiempoDeRecarga = 5,tipoDeAtaque = "sinAtaque",daño = 0) {

    override method image() = "girasol.png"

}

class LanzaGuisantes inherits Planta(vida = 300,costeDeSoles = 50,tiempoDeRecarga = 5,tipoDeAtaque = "larga distancia",daño = 0) {
  
    override method image() = "lanzaguisantes.png"
}

class Nuez inherits Planta(vida = 300,costeDeSoles = 50,tiempoDeRecarga = 5,tipoDeAtaque = "sinAtaque",daño = 0) {

    override  method image() = "nuez.png"
    
}


class Cereza inherits Planta(vida = 500,costeDeSoles = 150,tiempoDeRecarga = 40,tipoDeAtaque = "instakill",daño = 0) {

    override method image() = "cereza.png"
   
}

class BonkChoi inherits Planta(vida = 300,costeDeSoles = 150,tiempoDeRecarga = 5,tipoDeAtaque = "corta/media distancia",daño = 0) {

    override method image() = "bonkChoi.png"
    
}

