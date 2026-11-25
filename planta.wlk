import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import jugador.*
import habilidades.*
import movimientos.*
import animacion.*

class Planta inherits SerVivo {
	const imagen = ""
	
	override method image() = imagen
	
	override method desaparecer() {
		super()
		patio.quitarPlanta(self)
	}
}

class BonkChoi inherits Planta (
	habilidad = golpeCuerpoACuerpo,
	daño = 30,
	vida = 300,
	position = jugador.position(),
	temporizador = new Temporizador(intervalo = 500)
) {
	const animacionReposo = new Animacion(
		frames = ["bonkChoi.png"],
		temporizador = new Temporizador(intervalo = 1000)
	)
	const animacionAtaque = new Animacion(
		frames = [
			"bonkChoiFrame2.png",
			"bonkChoiFrame3.png",
			"bonkChoiFrame4.png",
			"bonkChoiFrame5.png",
			"bonkChoiFrame6.png"
		],
		temporizador = new Temporizador(intervalo = 400)
	)
	
	override method image() = animacion.imagenActual()

	override method initialize() {
		super()
		animacion = animacionReposo
	}
	
	override method actuar() {
		if (self.hayObjetivoCerca()) {
			self.cambiarAnimacion(animacionAtaque)
			animacionAtaque.iniciar()
			super()
		} else {
			animacionAtaque.detener()
			self.cambiarAnimacion(animacionReposo)
		}
	}
	
	method hayObjetivoCerca() = (not patio.zoombiesEnCasilla(
		position
	).isEmpty()) || (not patio.zoombiesEnCasilla(
		derecha.desde(position)
	).isEmpty())
}

class Cereza inherits Planta (
	habilidad = explosion,
	daño = 1800,
	vida = 9999,
	position = jugador.position()
) {
	override method image() = "cereza.png"
	
	override method aparecer() {
		super()
		game.schedule(1000, { self.explotar() })
	}

	method explotar() {
		self.actuar()
		self.generarExplosiones3x3()
		self.desaparecer()
	}

	method generarExplosiones3x3() {
		const animacionExplosion = new Animacion(
			frames = [
				"secuenciaExplocion-frame1.png",
				"secuenciaExplocion-frame2.png",
				"secuenciaExplocion-frame3.png",
				"secuenciaExplocion-frame4.png",
				"secuenciaExplocion-frame5.png",
				"secuenciaExplocion-frame6.png",
				"secuenciaExplocion-frame7.png"
			],
			temporizador = sinTemporizador
		)
		const explosiones = []
		(-1 .. 1).forEach({ dx =>
			(-1 .. 1).forEach({ dy =>
				const pos = game.at(position.x() + dx, position.y() + dy)
				if (pos.x().between(2, game.width() - 1) && pos.y().between(1, game.height() - 2)) {
					const nuevaExplosion = new Explosion(position = pos, animacion = animacionExplosion)
					explosiones.add(nuevaExplosion)
					nuevaExplosion.aparecer()
				}
			})
		})
		animacionExplosion.iniciar()
		(1 .. 6).forEach({ paso =>
			game.schedule(paso * 100, { animacionExplosion.actuar() })
		})
		game.schedule(700, {
			explosiones.forEach({ e => e.desaparecer() })
		})
	}
}

class Explosion inherits Entidad {
	override method actuar() {}
}

class PlantaCarnivora inherits Planta (
	habilidad = sinAtaque,
	daño = 9999,
	vida = 300,
	position = jugador.position(),
	temporizador = new Temporizador(intervalo = 500)
) {
	var estado = carnivoraLista
	
	override method image() = estado.imagen()
	
	override method actuar() {
		estado.actuar(self)
	}
	
	method cambiarEstado(nuevoEstado, nuevoIntervalo) {
		estado = nuevoEstado
		self.cambiarTemporizador(new Temporizador(intervalo = nuevoIntervalo))
	}
	
	method intentarDevorar() {
		const objetivos = patio.zoombiesEnCasilla(position) + patio.zoombiesEnCasilla(
			derecha.desde(position)
		)
		objetivos.take(1).forEach(
			{ zoombie =>
				zoombie.recibirDaño(daño)
				return self.cambiarEstado(carnivoraMasticando, 12000)
			}
		)
	}
}

object carnivoraLista {
	method imagen() = "plantaCarnivora.png"
	
	method actuar(planta) {
		planta.intentarDevorar()
	}
}

object carnivoraMasticando {
	method imagen() = "plantaCarnivoraMasticando.png"
	
	method actuar(planta) {
		planta.cambiarEstado(carnivoraLista, 500)
	}
}