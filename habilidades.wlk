import wollok.game.*
import patio.*
import proyectil.*
import soles.*
import sonidos.*
import animacion.*
import movimientos.*

object disparo { 
	method ejecutar(planta) {
		if (patio.hayZoombieDelanteDe(planta)) {
			self.generarProyectil(planta)
		}
	}

	method generarProyectil(planta) {
		const proyectil = new Proyectil(
			position = planta.position(),
			plantaQueLoDispara = planta
		)
		patio.agregarProyectil(proyectil)
		proyectil.aparecer()
	}
}  

object explosion {
	method ejecutar(planta) {
		sonido.sonidoExplosion()
		patio.daniarZoombiesEnRangoDeExplosion(planta.position(), planta.daño())
	}
}

object golpeCuerpoACuerpo { 
	method ejecutar(planta) {
		const objetivos = patio.zoombiesEnCasilla(planta.position()) + patio.zoombiesEnCasilla(derecha.desde(planta.position()))
		objetivos.take(1).forEach({ zoombie =>
			zoombie.recibirDaño(planta.daño())
		})
	}
}

object producirSol {
	method ejecutar(planta) { 
		generadorDeSoles.generarSolEnCasilla(planta.position()) 
	}
}

object sinAtaque { 
	method ejecutar(planta) {} 
}

object embestir {
	method ejecutar(rino) {
		rino.avanzar()
		patio.plantasEnCasilla(rino.position()).take(1).forEach({ planta =>
			rino.embestirPlanta(planta)
		})
	}
}

object comer { 
	method ejecutar(zoombie) {
		patio.plantasEnCasilla(zoombie.position()).take(1).findOrElse(
			{ planta => 
				planta.recibirDaño(zoombie.daño()) 
				sonido.sonidoMordisco()
				return true
			},
			{ zoombie.avanzar() }
		)
	}
}

class Invocar {
	const constructorZoombie

	method ejecutar(invocador) {
		const nuevoZoombie = constructorZoombie.apply(invocador.position())
		patio.agregarZoombie(nuevoZoombie)
		nuevoZoombie.aparecer()
	}
}
