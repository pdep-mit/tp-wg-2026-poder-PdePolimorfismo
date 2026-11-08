import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import soles.*
import jugador.*   
import habilidades.*  

class Planta inherits SerVivo{
	
	const costeDeSoles
	
	const cooldown
	
	method coste() = costeDeSoles

	override method morir() {
    	super()
    	patio.quitarPlanta(self)
    }

}

class Girasol inherits Planta (
  habilidad = sinAtaque, 
  cooldown = 10, 
  costeDeSoles = 50, 
  danio = 0, 
  vida = 300, 
  position = jugador.position())
{
	
	override method image() = "girasol.png"
	
	override method actuar() {
		generadorDeSoles.generarSolEnCasilla(position)
	}
	
}

class Lanzaguisantes inherits Planta (
  habilidad = disparo, 
  cooldown = 10, 
  costeDeSoles = 100, 
  danio = 23, 
  vida = 300, 
  position = jugador.position())
{
	
	override method image() = "lanzaguisantes.png"
	
}

class BonkChoi inherits Planta (
  habilidad = golpeCuerpoACuerpo, 
  cooldown = 12, 
  costeDeSoles = 150, 
  danio = 30, 
  vida = 300, 
  position = jugador.position())
{
	
	override method image() = "bonkChoiFrame1.png"
	
}