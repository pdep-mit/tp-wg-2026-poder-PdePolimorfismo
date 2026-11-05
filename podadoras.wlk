import wollok.game.*
import entidades.*
import movimientos.*
import patio.*


class Podadora inherits Entidad {
    var estado = apagada
    const danio = 9999

    method danioQueHace() = danio
    override method image() = "podadora.png"

    method activar() {
        estado = activada
    }

    override method actuar() {
        estado.actuar(self)
    }

    method daniarZoombiesASuPaso() {
        if (patio.hayZoombieEnCasilla(position)) {
            const zoombie = patio.zoombieEnCasilla(position)
            zoombie.recibirDanio(self.danioQueHace())
        }
    }

    override method detenerse() {
        if (position.x() >= 12) self.desaparecer()
    }

    override method desaparecer() {
        super()
        patio.quitarPodadora(self)
    }
}

object apagada {
    method actuar(podadora) {
        if (patio.hayZoombieEnCasilla(podadora.position())) {
            podadora.activar()
        }
    }
}

object activada {
    method actuar(podadora) {
        podadora.daniarZoombiesASuPaso()
        podadora.avanzar()
        podadora.detenerse()
    }
}