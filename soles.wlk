import wollok.game.*
import entidades.*
import movimientos.*
//import animaciones.*
import patio.*

object cayendo {
  method actuarSobre(sol) { sol.descender() }
}

object quieto {
  method actuarSobre(sol) { }        
}

class Sol inherits Entidad{
	
	const valor = 25
	var estado = cayendo
	const tiempoEnPiso = 8000
	
	override method image() = "sol.png"
	
	method valor() = valor
	
	override method actuar() { estado.actuarSobre(self) }
	
	method recolectar() {
        contadorDeSoles.agregarSoles(valor) 
        self.desaparecer()
    }
	
	method descender(){
		position = abajo.desde(self.position())
		if(self.position().y() == 1) self.detenerse()
	}
	
	override method detenerse(){
		estado = quieto
		game.schedule(tiempoEnPiso, { self.desaparecer() })
	}
	
	override method desaparecer(){
		super()
		patio.quitarSol(self)
	}
	
}

object generadorDeSoles {

  method generarSolAleatorio() {
    const sol = new Sol(position = game.at((4 .. game.width() - 1).anyOne(), game.height() - 1))
    patio.agregarSol(sol)
    sol.aparecer()
  }
  
  method generarSolEnCasilla(posicion){
    const sol = new Sol(position = posicion.up(1))
    patio.agregarSol(sol)
    sol.aparecer()
    sol.detenerse()
  }
}

object contadorDeSoles {
    var cantidad = 50 

    const property position = game.at(1, game.height() + 1)

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