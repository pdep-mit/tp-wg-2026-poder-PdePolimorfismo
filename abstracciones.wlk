import wollok.game.*
import movimientos.*
import patio.*
import entidades.*

//hay que renombrar este archivo (puse esto aca para no sobrecargar otros archivos)

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

object musica {

    const musicaFondo = game.sound("musica.wav")

    method iniciarMusica(){
        musicaFondo.shouldLoop(true)
		musicaFondo.volume(0.2)
		musicaFondo.play()
    }

    method detenerMusica() {
        musicaFondo.stop()
    }
}