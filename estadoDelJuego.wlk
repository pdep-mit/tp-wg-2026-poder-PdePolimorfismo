import sonidos.*
import wollok.game.*
import soles.*
import jugador.*
import patio.*
import cartaPlanta.*
import cursor.*
import zoombie.*
import nivel.*

object finDelJuego {
	var estado = partidaEnCurso
	const cartas = [
		cartaGirasol,
		cartaLanzaguisantes,
		cartaNuez,
		cartaBonkChoi,
		cartaCereza,
		cartaPlantaCarnivora
	]

	method avanzarTiempo(ms, entidades) {
		estado.avanzarTiempo(ms, entidades)
	}

	method plantar(carta) {
		estado.plantar(carta)
	}

	method equipar(herramienta) {
		estado.equipar(herramienta)
	}

	method mostrarDerrota() {
		estado.finalizarCon(derrota)
	}

	method mostrarVictoria() {
		estado.finalizarCon(victoria)
	}

	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
		estado.activar()
	}

	method limpiarPantalla() {
		patio.limpiarTablero()
		game.removeVisual(jugador)
		game.removeVisual(contadorDeSoles)
		game.removeVisual(indicadorDeOleada)
		cartas.forEach({ carta => game.removeVisual(carta) })
	}
}

object partidaEnCurso {
	method avanzarTiempo(ms, entidades) {
		entidades.forEach({ entidad => entidad.pasarTiempo(ms) })
	}

	method plantar(carta) { jugador.plantar(carta) }
	method equipar(herramienta) { jugador.equipar(herramienta) }
	method finalizarCon(nuevoEstado) { finDelJuego.cambiarEstado(nuevoEstado) }
	method activar() {}
}

object trofeo {
	const property position = game.at(6, 4)
	var estado = trofeoDisponible

	method image() = "trofeo.png"
	method textColor() = "000000FF"
	method text() = estado.texto()

	method recolectarSiEstaEn(posicion) {
		if (game.hasVisual(self) && position == posicion) {
			estado.recolectar(self)
		}
	}

	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}
}

object trofeoDisponible {
	method texto() = "VICTORIA"

	method recolectar(unTrofeo) {
		unTrofeo.cambiarEstado(trofeoRecolectado)
		finDelJuego.limpiarPantalla()
		game.removeVisual(unTrofeo)
		game.boardGround("victoria.jpg")
		sonido.cambiarMusica(new PistaMusical(archivo = "victoria.wav"))
		game.schedule(4000, { game.stop() })
	}
}

object trofeoRecolectado {
	method texto() = "¡GANASTE!"
	method recolectar(unTrofeo) {}
}

object victoria {
	method avanzarTiempo(ms, entidades) { game.removeTickEvent("relojJuego") }
	method plantar(carta) {}
	method equipar(herramienta) {}
	method finalizarCon(nuevoEstado) {}

	method activar() {
		game.removeTickEvent("relojJuego")
		patio.limpiarSoles()
		generadorDeSoles.detenerGeneracion()
		sonido.detenerMusica()
		jugador.equipar(cursor)
		game.addVisual(trofeo)
	}
}

object derrota {
	method avanzarTiempo(ms, entidades) { game.removeTickEvent("relojJuego") }
	method plantar(carta) {}
	method equipar(herramienta) {}
	method finalizarCon(nuevoEstado) {}

	method activar() {
		game.removeTickEvent("relojJuego")
		directorDeOleadas.detener()
		generadorDeSoles.detenerGeneracion()
		sonido.detenerMusica()
		sonido.detenerEfectos()

		finDelJuego.limpiarPantalla()

		game.boardGround("gameOver.png")
		game.schedule(4000, { game.stop() })
	}
}