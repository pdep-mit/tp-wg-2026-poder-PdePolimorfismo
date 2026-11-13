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

    override method avanzar() {
		position = derecha.desde(position)
		if(position.x() == 12) self.detenerse()
	}

    method daniarZoombiesASuPaso() {
        patio.zombiesEnCasilla(position).forEach({ zoombie =>
            zoombie.recibirDanio(self.danioQueHace())
        })
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
            podadora.daniarZoombiesASuPaso()
        }
    }
}

object activada {
    method actuar(podadora) {
        podadora.daniarZoombiesASuPaso()
        podadora.avanzar()
    }
}