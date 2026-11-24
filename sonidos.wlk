import wollok.game.*

object sinMusica {
	method archivo() = ""
	method detener() {}
}

class PistaEnCurso {
	const property archivo
	const sonido

	method detener() {
		sonido.stop()
	}
}

object sonido {
	var musicaActual = sinMusica
	const sonidosActivos = []
	var estadoMordisco = canalMordiscoLibre

	method reproducirMusica(archivoAudio) {
		if (musicaActual.archivo() != archivoAudio) {
			musicaActual.detener()
			const nuevaMusica = game.sound(archivoAudio)
			nuevaMusica.shouldLoop(true)
			nuevaMusica.volume(0.2)
			nuevaMusica.play()
			musicaActual = new PistaEnCurso(archivo = archivoAudio, sonido = nuevaMusica)
		}
	}

	method detenerMusica() {
		musicaActual.detener()
		musicaActual = sinMusica
	}

	method sonidoMordisco() {
		estadoMordisco.reproducir(self)
	}

	method ejecutarMordisco() {
		const mordisco = game.sound("zoombiComiendo.wav")
		sonidosActivos.add(mordisco)
		mordisco.shouldLoop(true)
		mordisco.volume(0.7)
		mordisco.play()
		game.schedule(6000, { 
			mordisco.stop()
			sonidosActivos.remove(mordisco) 
		})
	}

	method cambiarEstadoMordisco(nuevoEstado) {
		estadoMordisco = nuevoEstado
	}

	method sonidoEmbestida() {
		const embestida = game.sound("embestidaRinoceronte.wav")
		sonidosActivos.add(embestida)
		embestida.volume(0.8)
		embestida.play()
		game.schedule(2000, { sonidosActivos.remove(embestida) })
	}

	method sonidoExplosion() {
		const explosion = game.sound("explosion.wav")
		sonidosActivos.add(explosion)
		explosion.volume(0.8)
		explosion.play()
		game.schedule(2500, { sonidosActivos.remove(explosion) })
	}
}

object canalMordiscoLibre {
	method reproducir(gestor) {
		gestor.ejecutarMordisco()
		gestor.cambiarEstadoMordisco(canalMordiscoOcupado)
		game.schedule(6000, { gestor.cambiarEstadoMordisco(self) })
	}
}

object canalMordiscoOcupado {
	method reproducir(gestor) {}
}