import wollok.game.*
import patio.*
import movimientos.*


object disparo { method ejecutar(planta) { } }   
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
		const casillaAdelante = izquierda.desde(zoombie.position())
		const objetivo = patio.hayPlantaEnCasilla(casillaAdelante)
		
		if(patio.hayPlantaEnCasilla(casillaAdelante)) 
			objetivo.recibirDanio(9999)
			zoombie.avanzar()	
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


