import wollok.game.*

object sinMusica {
	method cambiarA(pista) = pista.reproducir()
	
	method detener() {
		
	}
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
		audio.volume(0.8)
		audio.play()
		return new PistaEnCurso(audio = audio)
	}
}

object sonido {
	var musicaActual = sinMusica
	const sonidosActivos = []
	var estadoMordisco = canalMordiscoLibre
	var mordiscoActual = sinMordisco
	var zoombieMordiendo = ningunZoombie
	
	method cambiarMusica(pista) {
		musicaActual = musicaActual.cambiarA(pista)
	}
	
	method detenerMusica() {
		musicaActual.detener()
		musicaActual = sinMusica
	}
	
	method detenerEfectos() {
		(sonidosActivos + []).forEach(
			{ efecto =>
				efecto.stop()
				return sonidosActivos.remove(efecto)
			}
		)
	}

	method reproducirEfecto(archivo, volumen, duracion) {
		const efecto = game.sound(archivo)
		sonidosActivos.add(efecto)
		efecto.volume(volumen)
		efecto.play()
		game.schedule(duracion, { sonidosActivos.remove(efecto) })
	}

	method sonidoGeneracionPinguino() {
		self.reproducirEfecto("monoMaquinistaVoz.wav", 0.8, 1500)
	}

	method sonidoRugido() {
		self.reproducirEfecto("Roar.wav", 0.8, 2500)
	}

	method sonidoEmbestida() {
		self.reproducirEfecto("embestidaRinoceronte.wav", 0.8, 2000)
	}

	method sonidoExplosion() {
		self.reproducirEfecto("explosion.wav", 0.8, 2500)
	}
	
	method sonidoMordisco(zoombie) {
		estadoMordisco.reproducir(self, zoombie)
	}
	
	method ejecutarMordisco(zoombie) {
		const mordisco = game.sound("zoombiComiendo.wav")
		mordiscoActual = mordisco
		zoombieMordiendo = zoombie
		sonidosActivos.add(mordisco)
		mordisco.shouldLoop(true)
		mordisco.volume(0.7)
		mordisco.play()
		game.schedule(6000, { self.finalizarMordisco(mordisco) })
	}

	method detenerMordisco(zoombie) {
		if (zoombieMordiendo == zoombie) self.finalizarMordisco(mordiscoActual)
	}

	method finalizarMordisco(mordisco) {
		if (mordiscoActual == mordisco) {
			mordisco.stop()
			sonidosActivos.remove(mordisco)
			mordiscoActual = sinMordisco
			zoombieMordiendo = ningunZoombie
			self.cambiarEstadoMordisco(canalMordiscoLibre)
		}
	}
	
	method cambiarEstadoMordisco(nuevoEstado) {
		estadoMordisco = nuevoEstado
	}
}

object canalMordiscoLibre {
	method reproducir(gestor, zoombie) {
		gestor.ejecutarMordisco(zoombie)
		gestor.cambiarEstadoMordisco(canalMordiscoOcupado)
	}
}

object canalMordiscoOcupado {
	method reproducir(gestor, zoombie) {
		
	}
}

object sinMordisco {}

object ningunZoombie {}