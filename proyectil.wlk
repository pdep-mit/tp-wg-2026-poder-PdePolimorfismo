import wollok.game.*
import movimientos.*
import patio.*
import entidades.*

class Proyectil inherits Entidad (temporizador = new Temporizador(intervalo = 300)) {
	const plantaQueLoDispara
	var estado = proyectilEnVuelo

	override method image() = "guisante.png"

	override method actuar() {
		estado.actuar(self)
	}

method moverEImpactar() {
		const objetivosEnCasilla = patio.zoombiesEnCasilla(position)
		if (not objetivosEnCasilla.isEmpty()) {
			self.impactarA(objetivosEnCasilla.first())
		} else {
			self.avanzar()
			self.impactar()
			self.verificarLimiteTablero()
		}
	}

	method impactarA(zombie) {
		zombie.recibirDaño(plantaQueLoDispara.daño())
		self.desaparecer()
	}

	method impactar() {
		patio.zoombiesEnCasilla(position).take(1).forEach({ zombie =>
			self.impactarA(zombie)
		})
	}

	method avanzar() {
		position = derecha.desde(position)
	}

	method verificarLimiteTablero() {
		if (position.x() >= game.width() - 1) {
			self.desaparecer()
		}
	}

	override method desaparecer() {
		estado.desaparecer(self)
	}
method quitarDelJuego() {
		estado = proyectilInactivo
		self.ocultarVisual()
		patio.quitarProyectil(self)
	}
}

object proyectilEnVuelo {
	method actuar(proyectil) {
		proyectil.moverEImpactar()
	}

	method desaparecer(proyectil) {
		proyectil.quitarDelJuego()
	}
}

object proyectilInactivo {
	method actuar(proyectil) {}
	method desaparecer(proyectil) {}
}