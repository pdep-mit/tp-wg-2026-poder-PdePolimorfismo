import wollok.game.*
import animacion.*

class Entidad {
	var property position
	var temporizador = sinTemporizador
	var animacion = sinAnimacion

	method image() = animacion.imagenActual()

	method aparecer() {
		game.addVisual(self)
	}

	method actuar()

	method cambiarAnimacion(nuevaAnimacion) {
		animacion = nuevaAnimacion
	}

	method pasarTiempo(ms) {
		temporizador.avanzar(ms, self)
		animacion.pasarTiempo(ms)
	}

	method reiniciarTemporizador() {
		temporizador.reiniciar()
	}

	method ocultarVisual() {
		animacion.detener()
		game.removeVisual(self)
	}

	method desaparecer() {
		self.ocultarVisual()
	}
}

object sinTemporizador {
	method avanzar(ms, entidad) {}
	method reiniciar() {}
}

class Temporizador {
	const property intervalo = 1000
	var tiempoAcumulado = 0

	method avanzar(ms, entidad) {
		tiempoAcumulado += ms
		if (tiempoAcumulado >= intervalo) {
			tiempoAcumulado -= intervalo
			entidad.actuar()
		}
	}

	method reiniciar() {
		tiempoAcumulado = 0
	}
}