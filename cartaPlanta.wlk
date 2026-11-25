import wollok.game.*
import soles.*
import planta.*
import habilidades.*
import entidades.*

class CartaPlanta {
	const costeDeSoles
	const cooldown
	var estado = cartaDisponible
	
	method image()
	
	method position()
	
	method coste() = costeDeSoles
	
	method usar(posicion) = estado.usar(self, posicion)
	
	method crearPlanta(posicion)
	
	method iniciarCooldown() {
		estado = cartaNoDisponible
		game.schedule(cooldown, { estado = cartaDisponible })
	}
}

object cartaDisponible {
	method usar(carta, posicion) {
		if (not contadorDeSoles.tieneSuficientesSoles(carta.coste())) self.error(
				"No hay suficientes soles"
			)
		contadorDeSoles.quitarSoles(carta.coste())
		carta.iniciarCooldown()
		return carta.crearPlanta(posicion)
	}
}

object cartaNoDisponible {
	method usar(carta, posicion) {
		self.error("La carta está en enfriamiento")
	}
}

object cartaGirasol inherits CartaPlanta (costeDeSoles = 50, cooldown = 8000) {
	override method crearPlanta(posicion) = new Planta(
		habilidad = producirSol,
		daño = 0,
		vida = 300,
		position = posicion,
		temporizador = new Temporizador(intervalo = 15000),
		imagen = "girasol.png"
	)
	
	override method image() = "cartaGirasol.png"
	
	override method position() = game.at(0, 6)
}

object cartaLanzaguisantes inherits CartaPlanta (
	costeDeSoles = 100,
	cooldown = 8000
) {
	override method crearPlanta(posicion) = new Planta(
		habilidad = disparo,
		daño = 20,
		vida = 300,
		position = posicion,
		temporizador = new Temporizador(intervalo = 1500),
		imagen = "lanzaguisantes.png"
	)
	
	override method image() = "cartaLanzaguisantes.png"
	
	override method position() = game.at(0, 5)
}

object cartaNuez inherits CartaPlanta (costeDeSoles = 50, cooldown = 16000) {
	override method crearPlanta(posicion) = new Planta(
		habilidad = sinAtaque,
		daño = 0,
		vida = 4000,
		position = posicion,
		imagen = "nuez.png"
	)
	
	override method image() = "cartaNuez.png"
	
	override method position() = game.at(0, 4)
}

object cartaBonkChoi inherits CartaPlanta (
	costeDeSoles = 150,
	cooldown = 8000
) {
	override method crearPlanta(posicion) = new BonkChoi(position = posicion)
	
	override method image() = "cartaBonkChoi.png"
	
	override method position() = game.at(0, 3)
}

object cartaCereza inherits CartaPlanta (costeDeSoles = 150, cooldown = 8000) {
	override method crearPlanta(posicion) = new Cereza(position = posicion)
	
	override method image() = "cartaCereza.png"
	
	override method position() = game.at(0, 2)
}

object cartaPlantaCarnivora inherits CartaPlanta (
	costeDeSoles = 150,
	cooldown = 8000
) {
	override method crearPlanta(posicion) = new PlantaCarnivora(
		position = posicion
	)
	
	override method image() = "cartaPlantaCarnivora.png"
	
	override method position() = game.at(0, 1)
}