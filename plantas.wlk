import wollok.game.*
import soles.*
import zoombie.*
import abstracciones.*

class Planta {
    var property posicion
    var estado
    var property vida 
    const daño 
    const costo 
    var plantada = false
    var ataque = false 

    method costo () = costo

    method estaVivo () = vida > 0

    method recibirDaño (dañoDeZoombie) {
        dañoInflingido.procesarDaño(self, dañoDeZoombie)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
    }

    method estaPlantada () = plantada

// HAY QUE CHEQUEAR ESTA PARTE - Tenemos que corregir los parámetros que va a recibir el method estaEnSuRango

    method estaEnSuRango (zombie) {
        return 0
    }

    method atacar(objetivo) {
        if (objetivo.estaEnSuRango(true)) {
            ataque.ejecutar(self,objetivo)
        }
    }
}

//
