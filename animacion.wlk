import entidades.*

object sinAnimacion {
	method iniciar() {}
	method detener() {}
	method pasarTiempo(ms) {}
	method imagenActual() = ""
}

class Animacion {
	const frames
	const temporizador
	var indiceActual = 0
	var estado = animacionDetenida

	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}

	method iniciar() {
		estado.iniciar(self)
	}

	method detener() {
		estado.detener(self)
	}

	method pasarTiempo(ms) {
		estado.pasarTiempo(ms, self)
	}

	method avanzar() {
		temporizador.avanzar(self.pasoPorTick(), self)
	}

	method pasoPorTick() = temporizador.intervalo()

	method actuar() {
		indiceActual = (indiceActual + 1) % frames.size()
	}

	method reiniciarCiclo() {
		temporizador.reiniciar()
		indiceActual = 0
	}

	method imagenActual() = frames.get(indiceActual)
}

object animacionDetenida {
	method iniciar(animacion) {
		animacion.reiniciarCiclo()
		animacion.cambiarEstado(animacionActiva)
	}

	method detener(animacion) {}
	method pasarTiempo(ms, animacion) {}
}

object animacionActiva {
	method iniciar(animacion) {}

	method detener(animacion) {
		animacion.reiniciarCiclo()
		animacion.cambiarEstado(animacionDetenida)
	}

	method pasarTiempo(ms, animacion) {
		animacion.avanzar()
	}
}