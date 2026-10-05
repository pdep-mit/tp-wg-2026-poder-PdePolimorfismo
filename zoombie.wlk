import wollok.game.*

class Zoombie {
    var property posicion
    var estado
    var vida 
    const daño 

    method estaVivo () = vida > 0

    method avanzar () {
        estado.avanzar(self)
    }

    method recibirDaño (dañoDePlanta) {
        vida = vida - dañoDePlanta
        if (not(self.estaVivo())) {
           self.morir()
        }
    }

    method dañoInfligido () = daño

    method comer () {
        estado.comer(self)
    }

    method morir () {
        estado.morir(self)
    }
}

