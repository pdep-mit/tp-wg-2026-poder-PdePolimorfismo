import wollok.game.*
import movimientos.*
import patio.*
import entidades.*

object gestionarDañoYVida {

    method procesarDaño (victima , atacante) {
         victima.recibirDaño(atacante.dañoQueHace()) 
    }
}

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

    override method image() = "proyectil.png"

    override method actuar() {
        self.avanzar()
        self.impactar()
    }

    override method avanzar() {
        position = derecha.desde(position)
        if (position.x() >= game.width() - 1 ) self.desaparecer()
    }

    method impactar() {
        if(patio.hayZoombieEnCasilla(position)) {
            const zoombie = patio.zoombieEnCasilla(position)
            zoombie.recibirDanio(23)
            self.desaparecer()
        }         
    }

    override method desaparecer() {
        super()
        patio.quitarProyectil(self)
    }
}