import wollok.game.*
import entidades.*
import movimientos.*
import patio.*

class Podadora inherits Entidad (temporizador = new Temporizador(intervalo = 200)) {
	var estado = apagada
	const property daño = 9999

	override method image() = "podadora.png"

	method activar() {
		estado = activada
	}

	override method actuar() {
		estado.actuar(self)
	}

	method arrancarSiHayZoombie() {
		patio.zoombiesEnCasilla(position).take(1).forEach({ zombie =>
			self.activar()
			self.limpiarFilaRecursivo()
		})
	}

	method daniarZoombiesASuPaso() {
		patio.daniarZoombiesEnCasilla(position, self.daño())
	}

	method limpiarFilaRecursivo() {
		self.daniarZoombiesASuPaso()
		if (position.x() < game.width() - 1) {
			self.programarSiguientePaso()
		} else {
			game.schedule(300, { self.desaparecer() })
		}
	}

	method programarSiguientePaso() {
		game.schedule(300, {
			position = derecha.desde(position)
			self.limpiarFilaRecursivo()
		})
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
	method actuar(podadora) {}
}