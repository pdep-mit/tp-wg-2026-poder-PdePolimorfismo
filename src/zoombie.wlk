import wollok.game.*
import abstracciones.*

class Zoombie {
    var property position
    var property vida
    const daño
    const intervaloMs = 2500 

    method image() = "pinguino zombie.png"

    method esPlanta() = false

    method estaVivo () = vida > 0 //el zoombie tiene la vida completa

    method aparecer() {
        game.addVisual(self) //aparece en el escenario
        game.onTick(intervaloMs, self.nombreDelTick(), { self.actuar() }) //cada 1 seg se va a repetir la acción actuar
    }

    method actuar() {self.loQueHayAdelante().enfrentar(self)}
    //el zoombie se hace presente a lo que sea que tenga en frente 
    //y  le pide que haga lo que tenga qu ehacer con él

    method loQueHayAdelante() = game.getObjectsIn(position.left(1)).findOrDefault({ objeto => objeto.esPlanta() }, caminoLibre)
    //se identifican a todas las entidades que se encuentren a la izquierda de la posicion actual del zoombie
    //y me devuelve un listado de dichos objetos. Se recorre la lista y de identifica al primero que matchee 
    //con la consulta objeto.esPlanta(), si no hay plantas, el camino esta libre


    method avanzar () {
	if (position.x() == 0) { self.detener() }       // llegó a la casa (a definir que pasa luego) 
        else { position = position.left(1) }        //si no llegó, que siga caminando
    }

    method recibirDaño(cantidad) {dañoInfligido.procesarDaño(self, cantidad)} //delego el deber de procesar el daño recibido a otro objeto

    method dañoQueHace () = daño

    method comer(planta) { planta.recibirDaño(daño)}//empieza a dañar a una planta

    method morir() {  
        self.detener()                           
        game.removeVisual(self)    // este method lo definimos así para que cuando, muera un personaje, desaparezca de la pamtalla 
    }

    method detener() { game.removeTickEvent(self.nombreDelTick()) }//mato el ciclo de vida del z0ombie

    method nombreDelTick() = "zoombie" + self.identity()// identificador para cada zoombie 
}
//no hay plantas en frente del zoombie, sigue su camino
object caminoLibre {
    method enfrentar(zoombie) {
        zoombie.avanzar()
    }
}