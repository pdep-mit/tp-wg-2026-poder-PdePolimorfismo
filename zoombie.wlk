import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import movimientos.*
import habilidades.*
import estadoDelJuego.*

class Zoombie inherits SerVivo{
	
	override method avanzar() {
		position = izquierda.desde(position)
		if(position.x() == 1) finDelJuego.mostrarDerrota()
	}
	
	override method desaparecer(){
		super()
  		patio.quitarZoombie(self)
  }
}

class Pinguino inherits Zoombie (
  habilidad = comer,  
  danio = 23, 
  vida = 300)
{
	
	override method image() = "pinguinoZoombie.png"
	
}

class Buitre inherits Zoombie (
  habilidad = volar,  
  danio = 23, 
  vida = 300)
{
	
	var plantasSobrevoladas = 0
	
	method registrarPlantaSobrevolada(){
		plantasSobrevoladas += 1
		
		if(plantasSobrevoladas >= 2) habilidad = comer
	}
	
	override method image() = "buitreZoombie.png"
	
}

class Rinoceronte inherits Zoombie (
  habilidad = embestir,  
  danio = 23, 
  vida = 300)
{
	override method image() = "rinoZoombie.png"	
	
}

object generarZoombis {
	const tipos = [
        { pos => new Pinguino(position = pos) },
        { pos => new Rinoceronte(position = pos) },
        { pos => new Buitre(position = pos) }
    ]

	method generarZombieAleatorio() {
        
        const filaAleatoria = (1 .. game.height() - 2).anyOne()
        const posicionAparicion = game.at(game.width() - 1, filaAleatoria)
        const nuevoZombie = tipos.anyOne().apply(posicionAparicion)

        patio.agregarZoombie(nuevoZombie)
        nuevoZombie.aparecer()
    }
  
  method programarAparicion() {
    game.schedule((8000 .. 14000).anyOne(), {
      self.generarZombieAleatorio()
      self.programarAparicion()
    })
  }
}