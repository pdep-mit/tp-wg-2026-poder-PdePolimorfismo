import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import jugador.*   
import habilidades.*  
import movimientos.*
import animacion.*

class Planta inherits SerVivo {
	override method desaparecer() {
		super()
		patio.quitarPlanta(self)
	}
}

class Girasol inherits Planta (
	habilidad = producirSol,  
	daño = 0, 
	vida = 300, 
	position = jugador.position(),
	temporizador = new Temporizador(intervalo = 18000)
) {
	override method image() = "girasol.png"
}

class Lanzaguisantes inherits Planta (
	habilidad = disparo,  
	daño = 30, 
	vida = 300, 
	position = jugador.position(),
	temporizador = new Temporizador(intervalo = 1500)
) {
	override method image() = "lanzaguisantes.png"
}

class Nuez inherits Planta (
	habilidad = sinAtaque,  
	daño = 0, 
	vida = 4000, 
	position = jugador.position()
) {
	override method image() = "nuez.png"
}

class BonkChoi inherits Planta (
	habilidad = golpeCuerpoACuerpo,  
	daño = 30, 
	vida = 300, 
	position = jugador.position(),
	temporizador = new Temporizador(intervalo = 500)
) {
	const animacionReposo = new Animacion(frames = ["bonkChoi.png"], intervalo = 1000)
	const animacionAtaque = new Animacion(
		frames = [
			"bonkChoiFrame2.png",
			"bonkChoiFrame3.png",
			"bonkChoiFrame4.png",
			"bonkChoiFrame5.png",
			"bonkChoiFrame6.png"
		],
		intervalo = 120
	)

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

	method hayObjetivoCerca() =
		not patio.zoombiesEnCasilla(position).isEmpty() ||
		not patio.zoombiesEnCasilla(derecha.desde(position)).isEmpty()
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
		game.schedule(1000, {
			self.actuar()
			self.desaparecer()
		})
	}
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
		temporizador = new Temporizador(intervalo = nuevoIntervalo)
	}

	method intentarDevorar() {
		const objetivos = patio.zoombiesEnCasilla(position) + patio.zoombiesEnCasilla(derecha.desde(position))
		objetivos.take(1).forEach({ zoombie =>
			zoombie.recibirDaño(daño)
			self.cambiarEstado(carnivoraMasticando, 12000)
		})
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