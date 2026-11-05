import wollok.game.*
import movimientos.*

object gestionarDañoYVida {

    method procesarDaño (victima , atacante) {
         victima.recibirDaño(atacante.dañoQueHace()) 
    }
}
