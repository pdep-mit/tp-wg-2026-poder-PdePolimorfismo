import wollok.game.*
import patio.*
import movimientos.*
import abstracciones.*
import soles.*


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
        const posAdelante = derecha.desde(planta.position())
        if (patio.hayZoombieEnCasilla(posAdelante)) {
            const zoombie = patio.zoombieEnCasilla(posAdelante)
            zoombie.recibirDanio(planta.danioQueHace())
        }
    }
}

object producirSol {
	method ejecutar(planta) { generadorDeSoles.generarSolEnCasilla(planta.position()) }
}

object sinAtaque { 
    method ejecutar(planta) { /* no hace nada */ } 
}

object embestir {
    method ejecutar(zoombie) {
        const pos = zoombie.position()
        if (patio.hayPlantaEnCasilla(pos)) {
            const planta = patio.plantaEnCasilla(pos)
            planta.recibirDanio(9000)
        } else {
            zoombie.avanzar()
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
	method ejecutar(zoombie) {
		zoombie.avanzar()
		if(patio.hayPlantaEnCasilla(zoombie.position()))
			zoombie.registrarPlantaSobrevolada()
	} 
}

object ladrar{ method ejecutar(zoombie) { } }

object aullar{ method ejecutar(zoombie) { } }


