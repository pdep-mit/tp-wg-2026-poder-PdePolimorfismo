import wollok.game.*
import zoombie.*
import habilidades.*
import patio.*

class Buitre inherits Zoombie (
	habilidad = comer,  
	daño = 100, 
	vida = 540,
	velocidadDeMovimiento = 3000,
	estado = buitreCaminandoAntesDeVolar
) {

	var plantasSobrevoladas = 0

	override method image() = estado.imagen()

	override method actuar() {
		estado.actuar(self)
	}

	method despegar() {
		self.cambiarVelocidad(1500) 
		self.cambiarEstado(buitreVolando)
	}

	method aterrizar() {
		self.cambiarVelocidad(3000) 
		self.cambiarEstado(buitreTerrestre)
	}

	method registrarPlantaSobrevolada() {
		plantasSobrevoladas += 1
		if (plantasSobrevoladas >= 3) {
			self.aterrizar()
		}
	}
}

object buitreCaminandoAntesDeVolar {
	method imagen() = "buitreCaminando.png"

	method actuar(buitre) {
		if (patio.hayPlantaEnCasillaOEnFrenteDe(buitre)) {
			buitre.despegar()
			buitreVolando.actuar(buitre)
		} else {
			buitre.avanzar()
		}
	}
}

object buitreVolando {
	method imagen() = "buitreVolando.png"

	method actuar(buitre) {
		buitre.avanzar()
    patio.plantasEnCasilla(buitre.position()).size().times({ _ =>
        buitre.registrarPlantaSobrevolada()
    })
	}
}

object buitreTerrestre {
	method imagen() = "buitreCaminando.png"

	method actuar(buitre) {
		comer.ejecutar(buitre)
	}
}