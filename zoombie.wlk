import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import movimientos.*
import habilidades.*

class Zoombie inherits SerVivo{
	
	override method avanzar() {
		position = izquierda.desde(position)
		if(position.x() == 12) self.detenerse()
	}
	
	override method morir(){
		super()
  		patio.quitarZoombie(self)
  }
}

class Pinguino inherits Zoombie{
	
	override method image() = "pinguino.png"
	
}

class Buitre inherits Zoombie{
	
	var plantasSobrevoladas = 0
	
	method registrarPlantaSobrevolada(){
		plantasSobrevoladas += 1
		
		if(plantasSobrevoladas >= 2) habilidad = comer
	}
	
	override method image() = "buitre.png"
	
}

class Rinoceronte inherits Zoombie {
	
	
	
}