import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import jugador.*
import habilidades.*
import movimientos.*
import animacion.*
import explocion.*

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
	daño = 15,
	vida = 300,
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
	vida = 9999
) {
	override method image() = "cereza.png"
	
	override method aparecer() {
		super()
		game.schedule(1000, { self.explotar() })
	}
	
	// Primero daña (habilidad) y después muestra el efecto
	method explotar() {
		self.actuar()
		new EfectoDeExplosion(centro = position).reproducir()
		self.desaparecer()
	}
}

class PlantaCarnivora inherits Planta (
	habilidad = sinAtaque,
	daño = 9999,
	vida = 300,
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
		if (not self.objetivosCerca().isEmpty()) self.cambiarEstado(
				carnivoraAbriendoBoca,
				500
			)
	}
	
	method devorar() {
		const objetivos = self.objetivosCerca()
		if (objetivos.isEmpty()) self.cambiarEstado(carnivoraLista, 500)
		else objetivos.take(1).forEach(
				{ zoombie =>
					zoombie.serDevorado(daño)
					if (zoombie.estaVivo()) self.cambiarEstado(
							carnivoraLista,
							500
						)
					else self.cambiarEstado(carnivoraMasticando, 30000)
				}
			)
	}
	
	method objetivosCerca() = patio.zoombiesEnCasilla(
		position
	) + patio.zoombiesEnCasilla(derecha.desde(position))
}

object carnivoraLista {
	method imagen() = "plantaCarnivora.png"
	
	method actuar(planta) {
		planta.intentarDevorar()
	}
}

object carnivoraAbriendoBoca {
	method imagen() = "plantaCarnivoraAbriendoBoca.png"
	
	method actuar(planta) {
		planta.devorar()
	}
}

object carnivoraMasticando {
	method imagen() = "plantaCarnivoraMasticando.png"
	
	method actuar(planta) {
		planta.cambiarEstado(carnivoraLista, 500)
	}
}