import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import movimientos.*
import habilidades.*
import estadoDelJuego.*
import rinoZoombie.*

object generarZoombis {
    const tipos = [
        { pos => new Pinguino(position = pos) },
        { pos => new Rinoceronte(position = pos) },
        { pos => new Buitre(position = pos) },
        { pos => new Jirafa(position = pos) },
        { pos => new Mono(position = pos) }
    ]
    const tickId = "generarZoombis"

	method generarZombieAleatorio() {
        
        const filaAleatoria = (1 .. game.height() - 2).anyOne()
        const posicionAparicion = game.at(game.width() - 1 , filaAleatoria)
        const nuevoZombie = tipos.anyOne().apply(posicionAparicion)

        patio.agregarZoombie(nuevoZombie)
        nuevoZombie.aparecer()
    }
  
  method programarAparicion() {
    game.removeTickEvent(tickId)
    game.onTick((10000 .. 16000).anyOne(), tickId, {
      self.generarZombieAleatorio()
      self.programarAparicion()
    })
  }
}

class Zoombie inherits SerVivo {

    var property velocidadDeMovimiento

    const tickId = self.identity().toString()

    override method aparecer() {
        super()
        game.onTick(velocidadDeMovimiento,tickId,{ self.actuar() })
    }

    override method avanzar() {
        position = izquierda.desde(position)
        if (position.x() == 1) finDelJuego.mostrarDerrota()
    }

    override method desaparecer() {
        game.removeTickEvent(tickId)
        super()
        patio.quitarZoombie(self)
    }

    method cambiarVelocidad(nuevoIntervalo) {
        velocidadDeMovimiento = nuevoIntervalo
        game.removeTickEvent(tickId)
        game.onTick(velocidadDeMovimiento, tickId, { self.actuar() })
    }
}

class Pinguino inherits Zoombie (
  habilidad = comer,  
  danio = 100, 
  vida = 200,
  velocidadDeMovimiento = 2000)
{
	
	override method image() = "pinguinoZoombie.png"
	
}

class Buitre inherits Zoombie (
  habilidad = volar,  
  danio = 100, 
  vida = 540,
  velocidadDeMovimiento = 2000)
{
	
	var plantasSobrevoladas = 0

    method vuela() {
        if(patio.hayPlantaEnCasilla(position)) {
            self.registrarPlantaSobrevolada()
        }
    }
	
	method registrarPlantaSobrevolada(){
		plantasSobrevoladas += 1
		
		if(plantasSobrevoladas >= 2) habilidad = comer
	}
	
	override method image() = "buitreVolando.png"
	
}

class Jirafa inherits Zoombie (
  habilidad = comer,  
  danio = 100, 
  vida = 540,
  velocidadDeMovimiento = 2000)
{
    
    override method image() = "jirafaZoombi.png"
    
}

class Mono inherits Zoombie (
  habilidad = comer,  
  danio = 100, 
  vida = 300,
  velocidadDeMovimiento = 2000)
{
    
    override method image() = "monoZoombi.png"
    
}

/*class PerroSalchicha inherits Zoombie (
  habilidad = ???,  
  danio = 150, 
  vida = 10000,
  velocidadDeMovimiento = 900)
{
    
    override method image() = "perroSalchichaZoombie.png"
    
}
Perro salchicha gordo bachicha

1-revisar todos los ticks, arreglarlos o buscarles la vuelta para evitar el lag

2-llamar a podadora en caso recursivo que elimine los zoombies de la casilla actual.

3-objects y clases en general delegarles más comportamientos.

4-Revisar los forEach y delegar algunos existentes

5-Bonkchoi tiene que pegar para adelante y para detras, aún manteniendose en si misma casilla, inclyendo al zoombie que la ocupe.

6-Por favor, hacerlo.
*/
