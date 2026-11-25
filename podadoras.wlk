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
		patio.zoombiesEnCasilla(position).forEach(
			{ zoombie => zoombie.activarPodadora(self) }
		)
		estado.avanzarSiCorresponde(self)
	}

	method atropellarZoombiesEnCasilla(posicion) {
		patio.zoombiesEnCasilla(posicion).forEach(
			{ zoombie => zoombie.serAtropellado(self.daño()) }
		)
	}

	method avanzarYLimpiar() {
		self.atropellarZoombiesEnCasilla(position)
		if (position.x() < game.width() - 1) {
			position = derecha.desde(position)
			self.atropellarZoombiesEnCasilla(position)
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

	method avanzarSiCorresponde(podadora) {}
}

object activada {
	method actuar(podadora) {
		podadora.avanzarYLimpiar()
	}

	method avanzarSiCorresponde(podadora) {
		podadora.avanzarYLimpiar()
	}
}