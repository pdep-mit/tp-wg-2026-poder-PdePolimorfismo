import wollok.game.*
import patio.*
import habilidades.*
import zoombie.*
import sonidos.*

class Rinoceronte inherits Zoombie (
	habilidad = embestir,  
	daño = 150, 
	vida = 1400,
	velocidadDeMovimiento = 3500,
	estado = rinoBuscando
) { 

	override method image() = estado.imagen()
    
	override method actuar() { 
		estado.actuar(self) 
	}

	method prepararEmbestida() {
		self.cambiarEstado(rinoPreparando)
		game.schedule(2500, { self.iniciarEmbestida() })
	}

	method iniciarEmbestida() {
		self.cambiarVelocidad(velocidadDeMovimiento / 4)
		self.cambiarEstado(rinoCargando)
	}
    
	method embestirPlanta(planta) {
		sonido.sonidoEmbestida()
		planta.recibirDaño(9999)
		self.cambiarVelocidad(3500)
		self.cambiarEstado(rinoAturdido)
		game.schedule(2000, { self.volverACaminar() })
	}

	method volverACaminar() {
		self.cambiarEstado(rinoCaminando)
	}
}

object rinoBuscando {
	method imagen() = "rinoCaminando.png"
    
	method actuar(rino) {
		if (patio.hayPlantaEnFilaAdelanteDe(rino)) {
			rino.prepararEmbestida()
		} else {
			rino.avanzar()
		}
	}
}

object rinoCaminando {
	method imagen() = "rinoCaminando.png"
    
	method actuar(rino) {
		comer.ejecutar(rino) 
	}
}

object rinoCargando {
	method imagen() = "rinoCargando.png"
    
	method actuar(rino) {
		embestir.ejecutar(rino)
	}
}

object rinoPreparando {
	method imagen() = "rinoPreparando.png" 
	method actuar(rino) {}
}

object rinoAturdido {
	method imagen() = "rinoAturdido.png"
	method actuar(rino) {}
}