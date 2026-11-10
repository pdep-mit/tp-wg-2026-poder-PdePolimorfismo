import wollok.game.*
import patio.*
import habilidades.*
import zoombie.*


class Rinoceronte inherits Zoombie (
  habilidad = embestir,  
  danio = 150, 
  vida = 1400,
  velocidadDeMovimiento = 3500)
{
	var property estado = rinoBuscando 

    override method image() = estado.imagen()
    
    override method actuar() { 
        estado.actuar(self) 
    }

    method iniciarEmbestida() {
    self.cambiarVelocidad(velocidadDeMovimiento / 4)
    estado = rinoCargando
}
    
    method embestirPlanta(planta) {
        planta.recibirDanio(9999)
        estado = rinoAturdido
    }	
	
}

object rinoBuscando {
    method imagen() = "rinoCaminando.png"
    
    method actuar(rino) {
        if (patio.hayPlantaEnFilaAdelanteDe(rino)) {
            rino.estado(rinoPreparando)

            game.schedule(2500, { rino.iniciarEmbestida() })
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
    
    method actuar(rino) { 
        rino.cambiarVelocidad(rino.velocidadDeMovimiento() * 4)
    }
}