import wollok.game.*
import entidades.*
import movimientos.*
import patio.*

object cayendo {
	method actuarSobre(sol) { sol.descender() }
}

object quieto {
	method actuarSobre(sol) {}        
}

class Sol inherits Entidad (temporizador = new Temporizador(intervalo = 2000)) {
	const valor = 25
	var estado = cayendo
	const tiempoEnPiso = 8000

	override method image() = "sol.png"
	
	override method actuar() { estado.actuarSobre(self) }
	
	method recolectar() {
		contadorDeSoles.agregarSoles(valor) 
		self.desaparecer()
	}
	
	method descender() {
		position = abajo.desde(self.position())
		if (self.position().y() == 1) {
			self.detenerse()
		}
	}
	
	method detenerse() {
		estado = quieto
		game.schedule(tiempoEnPiso, { self.desaparecer() })
	}
	
	override method desaparecer() {
		super()
		patio.quitarSol(self)
	}
}

object generadorDeSoles {
	var estado = generacionActiva

	method detenerGeneracion() {
		estado = generacionInactiva
	}

	method activarGeneracion() {
		estado.activar(self)
	}

	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}

	method generarSolAleatorio() {
		const sol = new Sol(position = game.at((3 .. game.width() - 2).anyOne(), game.height()))
		patio.agregarSol(sol)
		sol.aparecer()
	}
	
	method generarSolEnCasilla(posicion) {
		const sol = new Sol(position = posicion)
		patio.agregarSol(sol)
		sol.aparecer()
		sol.detenerse()
	}

	method programarLluviaDeSoles() {
		estado.programarLluviaDeSoles(self)
	}

	method intentarGenerarSolDeLluvia() {
		estado.ejecutarLluvia(self)
	}
}

object generacionActiva {
	method activar(generador) {}

	method programarLluviaDeSoles(generador) {
		game.schedule((8000 .. 18000).anyOne(), {
			generador.intentarGenerarSolDeLluvia()
		})
	}

	method ejecutarLluvia(generador) {
		generador.generarSolAleatorio()
		self.programarLluviaDeSoles(generador)
	}
}

object generacionInactiva {
	method activar(generador) {
		generador.cambiarEstado(generacionActiva)
		generacionActiva.programarLluviaDeSoles(generador)
	}

	method programarLluviaDeSoles(generador) {}
	method ejecutarLluvia(generador) {}
}

object contadorDeSoles {
	var cantidad = 50 
	const property position = game.at(2, game.height() + 1)

	method cantidad() = cantidad

	method agregarSoles(monto) {
		cantidad += monto
	}

	method quitarSoles(monto) {
		if (cantidad < monto) {
			self.error("No tienes suficientes soles") 
		}
		cantidad -= monto
	}

	method tieneSuficientesSoles(monto) = cantidad >= monto

	method image() = "bloqueBlanco.png"
	method textColor() = "000000FF"
	method text() = "\n\n\n\n Soles: " + cantidad.toString() + " "
}