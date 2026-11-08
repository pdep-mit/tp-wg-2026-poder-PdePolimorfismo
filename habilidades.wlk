import wollok.game.*
import patio.*
import movimientos.*
import abstracciones.*


object disparo { 
    method ejecutar(planta) {
        if (patio.hayZoombieDelanteDe(planta)) {
            self.generarProyectil(planta)
        }
    }

    method generarProyectil(planta) {
        const proyectil = new Proyectil(position = derecha.desde(planta.position()),
        plantaQueLoDispara = planta)
        
        patio.agregarProyectil(proyectil)
        proyectil.aparecer()
    }
}   
object golpeCuerpoACuerpo   { method ejecutar(planta) { } }   
object sinAtaque { method ejecutar(planta) { /* no hace nada */ } }

object ataqueLargaDistancia {

    method ejecutar(planta, zoombie) {
        if (planta.estaEnSuRango(zoombie)) {
            zoombie.recibirDaño(planta.dañoQueHace())
    }
}
}

// Solo puede atacar a un zoombie que esté al lado
object ataqueCuerpoACuerpo {

    method ejecutar(planta, zoombie) {
        if (planta.posicion().right(1) == zoombie.posicion())
        zoombie.recibirDaño(planta.dañoQueHace())
    }
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


