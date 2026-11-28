import wollok.game.*
import soles.*
import planta.*
import habilidades.*
import entidades.*

class CartaPlanta {
	const costeDeSoles
	const cooldown
	const imagen
	const fila
	const constructorPlanta
	var estado = cartaDisponible

	method image() = imagen

	method position() = game.at(0, fila)

	method coste() = costeDeSoles

	method usar(posicion) = estado.usar(self, posicion)

	method crearPlanta(posicion) = constructorPlanta.apply(posicion)

	method iniciarCooldown() {
		estado = cartaNoDisponible
		game.schedule(cooldown, { estado = cartaDisponible })
	}
}

object mazoDeCartas {
	method todas() = [
		cartaGirasol,
		cartaLanzaguisantes,
		cartaNuez,
		cartaBonkChoi,
		cartaCereza,
		cartaPlantaCarnivora
	]
}

object cartaDisponible {
	method usar(carta, posicion) {
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

const cartaGirasol = new CartaPlanta(
	costeDeSoles = 50,
	cooldown = 8000,
	imagen = "cartaGirasol.png",
	fila = 6,
	constructorPlanta = { pos => new Planta(
		habilidad = producirSol,
		daño = 0,
		vida = 300,
		position = pos,
		temporizador = new Temporizador(intervalo = (10000..18000).anyOne()),
		imagen = "girasol.png"
	) }
)

const cartaLanzaguisantes = new CartaPlanta(
	costeDeSoles = 100,
	cooldown = 8000,
	imagen = "cartaLanzaguisantes.png",
	fila = 5,
	constructorPlanta = { pos => new Planta(
		habilidad = disparo,
		daño = 20,
		vida = 300,
		position = pos,
		temporizador = new Temporizador(intervalo = 1500),
		imagen = "lanzaguisantes.png"
	) }
)

const cartaNuez = new CartaPlanta(
	costeDeSoles = 50,
	cooldown = 20000,
	imagen = "cartaNuez.png",
	fila = 4,
	constructorPlanta = { pos => new Planta(
		habilidad = sinAtaque,
		daño = 0,
		vida = 4000,
		position = pos,
		imagen = "nuez.png"
	) }
)

const cartaBonkChoi = new CartaPlanta(
	costeDeSoles = 150,
	cooldown = 8000,
	imagen = "cartaBonkChoi.png",
	fila = 3,
	constructorPlanta = { pos => new BonkChoi(position = pos) }
)

const cartaCereza = new CartaPlanta(
	costeDeSoles = 150,
	cooldown = 40000,
	imagen = "cartaCereza.png",
	fila = 2,
	constructorPlanta = { pos => new Cereza(position = pos) }
)

const cartaPlantaCarnivora = new CartaPlanta(
	costeDeSoles = 150,
	cooldown = 10000,
	imagen = "cartaPlantaCarnivora.png",
	fila = 1,
	constructorPlanta = { pos => new PlantaCarnivora(position = pos) }
)