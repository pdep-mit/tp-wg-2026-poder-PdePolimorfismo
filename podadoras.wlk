import wollok.game.*
import entidades.*
import movimientos.*
import patio.*

class Podadora inherits Entidad (temporizador = new Temporizador(intervalo = 500)) {
	var estado = apagada
	const property daño = 9999

	override method image() = "podadora.png"

	method activar() {
		estado = activada
		self.cambiarTemporizador(new Temporizador(intervalo = 300))
	}

	override method actuar() {
		estado.actuar(self)
	}

	method arrancarSiHayZoombie() {
		if (not patio.zoombiesEnCasilla(position).isEmpty()) {
			self.activar()
			self.avanzarYLimpiar()
		}
	}

	method avanzarYLimpiar() {
		patio.daniarZoombiesEnCasilla(position, self.daño())
		if (position.x() < game.width() - 1) {
			position = derecha.desde(position)
			patio.daniarZoombiesEnCasilla(position, self.daño())
		} else {
			self.desaparecer()
		}
	}

	override method desaparecer() {
		super()
		patio.quitarPodadora(self)
	}
}

object apagada {
	method actuar(podadora) {
		podadora.arrancarSiHayZoombie()
	}
}

object activada {
	method actuar(podadora) {
		podadora.avanzarYLimpiar()
	}
}