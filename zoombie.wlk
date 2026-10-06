import movimientos.*
import wollok.game.*
import abstracciones.*

class Zoombie {
    var property posicion
    var property vida 
    const daño 

    method estaVivo () = vida > 0

    method avanzar () {
        movimientoHaciaLaIzquierda.mover(self)
    }

    method recibirDaño (dañoDePlanta) {
        dañoInflingido.procesarDaño(self, dañoDePlanta)
    }

    method dañoInfligido () = daño

    method comer (planta) {
        planta.recibirDaño(daño)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
    }
}

