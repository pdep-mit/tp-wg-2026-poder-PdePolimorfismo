import wollok.game.*
import abstracciones.*

class Zoombie {
    var x
    var y
    var property vida = 500
    const daño = 500
    var estaCaminando = true

    method image() = "pinguino zombie.png"

    // truncate(0) descarta la parte decimal de x para ubicarlo en una celda entera
    method position() = game.at(x.truncate(0), y)

    method estaVivo () = vida > 0

    method avanzar () {
	const planta = self.plantaAdelante()
		if (planta != null) {
			self.comer(planta)
		}
    }

	// Mueve a x de a pasos chicos para que el desplazamiento se vea gradual,
	// y cuando x cruza a una celda entera nueva, dispara avanzar().
    method animar() {
		if (estaCaminando) {
			const xAnterior = x.truncate(0)
			x = x - 0.025

			if (x.truncate(0) < xAnterior) {
				self.avanzar()   
			}

            if (x <= 0) {
                estaCaminando = false
            }
		}
	}
    
    method puedeAvanzar() = estaCaminando && x > 0

    // Busca si hay una planta en la celda inmediatamente a la izquierda
    method plantaAdelante() {
	    const posicionSiguiente = game.at(x.truncate(0) - 1, y)
		return game.getObjectsIn(posicionSiguiente).findOrDefault({ o => o.esPlanta() }, null)
    }

    method recibirDaño (dañoDePlanta) {
        dañoInflingido.procesarDaño(self, dañoDePlanta)
    }

    method dañoQueHace () = daño

    method comer (planta) {
        planta.recibirDaño(daño)
    }

    method morir () {                               
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
    }
}

object sinPlanta {

    method recibirDaño(daño) {} // No hace nada
    method esPlanta() = false
}

// revisar si lo siguiente esta bien implementado

/*const oso = new Zoombie(
    x = 8,
    y = 2,
    vida = 500,
    daño = 50
)

const mono = new Zoombie(
    x = 8,
    y = 4,
    vida = 200,
    daño = 20
)

const jirafa = new Zoombie(
    x = 8,
    y = 6,
    vida = 300,
    daño = 30
)

const pinguino = new Zoombie(
    x = 8,
    y = 8,
    vida = 150,
    daño = 10
)*/