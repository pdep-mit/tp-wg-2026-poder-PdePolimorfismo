import wollok.game.*
import movimientos.*
import patio.*

object gestionarDañoYVida {

    method procesarDaño (victima , atacante) {
         victima.recibirDaño(atacante.dañoQueHace()) 
    }
}

object rinoCargando {
    method actuar(rino) {
        if(patio.hayPlantaEnCasilla(rino.position())) {
            const planta = patio.plantaEnCasilla(rino.position())
            planta.recibirDanio(9999)
        } else
        rino.avanzar()
    }
}