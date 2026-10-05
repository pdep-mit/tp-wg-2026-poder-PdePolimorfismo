import wollok.game.*
import soles.*
import zoombie.*
import abstracciones.*

class Planta {
    var property posicion
    var estado
    var property vida 
    const daño 
    const costo 
    var plantada = false
    var ataque = false 

    method costo () = costo

    method estaVivo () = vida > 0

    method recibirDaño (dañoDeZoombie) {
        dañoInflingido.procesarDaño(self, dañoDeZoombie)
    }

    method morir () {
        estado.morir(self)
    }

    method estaPlantada () = not(plantada)

    method estaEnSuRango (zombie) {
        return 0
    }

    method atacar(objetivo) {
        if (objetivo.estaEnSuRango(true)) {
            ataque.ejecutar(self,objetivo)
        }
    }
}

