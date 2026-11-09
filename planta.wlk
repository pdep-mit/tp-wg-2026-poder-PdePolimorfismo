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

	override method desaparecer() {
    	super()
    	patio.quitarPlanta(self)
    }

}

class Girasol inherits Planta (
  habilidad = producirSol, 
  cooldown = 10, 
  costeDeSoles = 50, 
  danio = 0, 
  vida = 300, 
  position = jugador.position())
{
	
	var ticksAcumulados = 0
    const ticksParaGenerar = 4 // 4 pulsos de 2 segundos = 8 segundos

    override method image() = "girasol.png"
    
    override method actuar() {
        ticksAcumulados += 1
        
        // Cuando llega a 4, ejecuta la habilidad de producir sol
        if (ticksAcumulados >= ticksParaGenerar) {
            habilidad.ejecutar(self) 
            ticksAcumulados = 0 // Reinicia la cuenta para el próximo sol
        }
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