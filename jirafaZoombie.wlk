import wollok.game.*
import patio.*
import habilidades.*
import zoombie.*
import sonidos.*

class Jirafa inherits Zoombie (
	habilidad = comer,  
	daño = 100, 
	vida = 540,
	velocidadDeMovimiento = 3500
) {
	var estado = jirafaBuscando

	override method image() = estado.imagen()

	override method actuar() {
		estado.actuar(self)
	}

	method prepararAtaqueEspecial() {
		estado = jirafaPreparandoAtaque
		game.schedule(2500, { self.ejecutarAtaqueEspecial() })
	}

	method ejecutarAtaqueEspecial() {
		if (self.estaVivo()) {
			const objetivos = self.plantasEnRangoDeAtaque()
				.sortedBy({ p1, p2 => p1.position().x() > p2.position().x() })
				.take(2)
			objetivos.forEach({ planta => planta.recibirDaño(9999) })
			estado = jirafaBuscando
		}
	}
	
	method plantasEnRangoDeAtaque() = patio.plantasEnRangoAdelanteDe(self, 2)

	method detectaDosPlantasEnRango() = self.plantasEnRangoDeAtaque().size() >= 2

}

object jirafaBuscando {
	method imagen() = "jirafaZoombi.png"

	method actuar(jirafa) {
		if (jirafa.detectaDosPlantasEnRango()) { 
			jirafa.prepararAtaqueEspecial()
		} else {
			comer.ejecutar(jirafa)
		}
	}
}

object jirafaPreparandoAtaque {
	method imagen() = "jirafaPreparada.png" 

	method actuar(jirafa) {}
}