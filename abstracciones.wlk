import wollok.game.*
import movimientos.*
import patio.*
import entidades.*

object rinoCargando {
    method actuar(rino) {
        if(patio.hayPlantaEnCasilla(rino.position())) {
            const planta = patio.plantaEnCasilla(rino.position())
            planta.recibirDanio(9999)
        } else
        rino.avanzar()
    }
}

class Proyectil inherits Entidad {

    var property plantaQueLoDispara

    override method image() = "guisante.png"

    override method actuar() {
        self.impactar()
        self.avanzar()
        self.impactar()
    }

    override method avanzar() {
        position = derecha.desde(position)
        if (position.x() >= game.width() - 1 ) self.desaparecer()
    }

    method impactar() {
	    if (game.hasVisual(self) && patio.hayZoombieEnCasilla(position)) {
		    patio.zoombieEnCasilla(position).recibirDanio(plantaQueLoDispara.danioQueHace())
		    self.desaparecer()
	    }
    }

    override method desaparecer() {
        super()
        patio.quitarProyectil(self)
    }
}