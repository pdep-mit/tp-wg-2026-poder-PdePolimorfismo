import wollok.game.*

object sinAnimacion {
	method iniciar() {}
	method detener() {}
	method imagenActual() = ""
}

class Animacion {
	const frames
	const intervalo
	var indiceActual = 0
	var estado = animacionDetenida

	method nombreTick() = "animacion_" + self.identity().toString()

	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}

	method iniciar() {
		estado.iniciar(self)
	}

	method detener() {
		estado.detener(self)
	}

	method arrancarTick() {
		indiceActual = 0
		game.onTick(intervalo, self.nombreTick(), {
			indiceActual = (indiceActual + 1) % frames.size()
		})
	}

	method frenarTick() {
		game.removeTickEvent(self.nombreTick())
		indiceActual = 0
	}

	method imagenActual() = frames.get(indiceActual)
}

object animacionDetenida {
	method iniciar(animacion) {
		animacion.arrancarTick()
		animacion.cambiarEstado(animacionActiva)
	}

	method detener(animacion) {}
}

object animacionActiva {
	method iniciar(animacion) {}

	method detener(animacion) {
		animacion.frenarTick()
		animacion.cambiarEstado(animacionDetenida)
	}
}