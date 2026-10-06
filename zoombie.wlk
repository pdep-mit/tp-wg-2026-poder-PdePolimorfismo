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

// revisar si lo siguiente esta bien implementado

const oso = new Zoombie(
    posicion = game.at(8, 2),
    vida = 500,
    daño = 50
)

const mono = new Zoombie(
    posicion = game.at(8, 4),
    vida = 200,
    daño = 20
)

const jirafa = new Zoombie(
    posicion = game.at(8, 6),
    vida = 300,
    daño = 30
)

const pinguino = new Zoombie(
    posicion = game.at(8, 8),
    vida = 150,
    daño = 10
)