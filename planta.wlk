import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import soles.*
import jugador.*   
import habilidades.*  

class Planta inherits SerVivo{

	override method desaparecer() {
    	super()
    	patio.quitarPlanta(self)
  }

}

class Girasol inherits Planta (
  habilidad = producirSol,  
  danio = 0, 
  vida = 300, 
  position = jugador.position())
{

    override method image() = "girasol.png"
    
const tickId = self.identity().toString()

override method aparecer() {
    super()
    game.onTick(10000, tickId, { self.actuar() })
}

override method desaparecer() {
    game.removeTickEvent(tickId)
    super()
}
}

class Lanzaguisantes inherits Planta (
  habilidad = disparo,  
  danio = 30, 
  vida = 300, 
  position = jugador.position())
{
	
	override method image() = "lanzaguisantes.png"

  const tickId = self.identity().toString()

override method aparecer() {
    super()
    game.onTick(2500, tickId, { self.actuar() })
}

override method desaparecer() {
    game.removeTickEvent(tickId)
    super()
}
	
}

class Nuez inherits Planta (
  habilidad = sinAtaque,  
  danio = 0, 
  vida = 4000, 
  position = jugador.position())
{
  
  override method image() = "nuez.png"
  
}

class BonkChoi inherits Planta (
  habilidad = golpeCuerpoACuerpo,  
  danio = 30, 
  vida = 300, 
  position = jugador.position())
{
	
	override method image() = "bonkChoiFrame1.png"
	
}