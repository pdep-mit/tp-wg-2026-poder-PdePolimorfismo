import wollok.game.*

object sinMusica {
    method cambiarA(pista) = pista.reproducir()
    method detener() {}
}

class PistaEnCurso {
    const audio

    method cambiarA(pista) {
        self.detener()
        return pista.reproducir()
    }

    method detener() {
        audio.stop()
    }
}

class PistaMusical {
    const archivo

    method reproducir() {
        const audio = game.sound(archivo)
        audio.shouldLoop(true)
        audio.volume(0.2)
        audio.play()
        return new PistaEnCurso(audio = audio)
    }
}
object sonido {
	var musicaActual = sinMusica
	const sonidosActivos = []
	var estadoMordisco = canalMordiscoLibre

	method cambiarMusica(pista) {
		musicaActual = musicaActual.cambiarA(pista)
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