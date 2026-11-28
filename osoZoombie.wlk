import wollok.game.*
import patio.*
import habilidades.*
import zoombie.*
import sonidos.*
import movimientos.*

class Oso inherits Zoombie (
	habilidad = comer,
	daño = 9999,
	vida = 4000,
	velocidadDeMovimiento = 8000,
	estado = osoCaminando
) { 
	
	override method image() = estado.imagen()
	
	override method actuar() {
		estado.actuar(self)
	}
	
	method prepararAplastar() {
		self.cambiarEstado(osoPreparandoAplastar)
		game.schedule(2500, { self.ejecutarAplastar() })
	}
	
	method ejecutarAplastar() {
		if (self.estaVivo()) {
			self.cambiarEstado(osoAplastando)
			self.aplastarPlantaObjetivo()
			game.schedule(1000, { self.volverACaminar() })
		}
	}
	
	method volverACaminar() {
		if (self.estaVivo()) self.cambiarEstado(osoCaminando)
	}

	method aplastarPlantaObjetivo() {
		const objetivos = patio.plantasEnCasilla(position) + patio.plantasEnCasilla(
			izquierda.desde(position)
		)
		objetivos.take(1).forEach({ planta => planta.recibirDaño(daño) })
	}
	
	override method serDevorado(danioPlanta) {
		self.recibirDaño(30)
	}
}

object osoCaminando {
	method imagen() = "osoCaminando.png"

	method actuar(oso) {
		if (patio.hayPlantaEnCasillaOEnFrenteDe(oso)) {
			oso.prepararAplastar()
		} else {
			oso.avanzar()
		}
	}
}

object osoPreparandoAplastar {
	method imagen() = "osoPreparado.png"
	method actuar(oso) {}
}

object osoAplastando {
	method imagen() = "osoAplastando.png"
	method actuar(oso) {}
}