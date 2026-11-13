import wollok.game.*
import patio.*
import movimientos.*
import abstracciones.*
import soles.*
import zoombie.*
import rinoZoombie.*


object disparo { 
    method ejecutar(planta) {
        if (patio.hayZoombieDelanteDe(planta)) {
            self.generarProyectil(planta)
        }
    }

    method generarProyectil(planta) {
        const proyectil = new Proyectil(position = planta.position(),
        plantaQueLoDispara = planta)

        patio.agregarProyectil(proyectil)
        proyectil.aparecer()
    }
}  

object golpeCuerpoACuerpo   { 
    method ejecutar(planta) {
        const posicionesAfectadas = [
            planta.position(),
            izquierda.desde(planta.position()),
            derecha.desde(planta.position())
        ]

        posicionesAfectadas.forEach({ posicion =>
            if (patio.hayZoombieEnCasilla(posicion)) {
                patio.zoombieEnCasilla(posicion).recibirDanio(planta.danioQueHace())
            }
        })
    }
}

object producirSol {
	method ejecutar(planta) { generadorDeSoles.generarSolEnCasilla(planta.position()) }
}

object sinAtaque { 
    method ejecutar(planta) { /* no hace nada */ } 
}


object embestir {
    method ejecutar(rino) {
        rino.avanzar()

        if (patio.hayPlantaEnCasilla(rino.position())) {
            const planta = patio.plantaEnCasilla(rino.position())
            rino.embestirPlanta(planta)
            game.schedule(2000, { rino.estado(rinoCaminando) })
        }
    }
}

object aplastar  { 
	method ejecutar(zoombie) {
		
	}
}   

object comer { 
	method ejecutar(zoombie) {
		if(patio.hayPlantaEnCasilla(zoombie.position())) {
			const planta = patio.plantaEnCasilla(zoombie.position())
			planta.recibirDanio(zoombie.danioQueHace())
		} else {
			zoombie.avanzar()
		}
	}
 } 
 
object volar { 

    method image() = "buitreVolando.png"

	method ejecutar(zoombie) {
		zoombie.avanzar()
		if(patio.hayPlantaEnCasilla(zoombie.position()))
			zoombie.registrarPlantaSobrevolada()
	} 
}

object ladrar{ method ejecutar(zoombie) { } }

object aullar{ method ejecutar(zoombie) { } }


