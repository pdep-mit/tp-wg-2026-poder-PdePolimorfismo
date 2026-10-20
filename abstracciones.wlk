import wollok.game.*

object gestionarDañoYVida {

    method procesarDaño (victima , atacante) {
         victima.recibirDaño(atacante.dañoQueHace()) 
    }
}

class Visual {

  method esPlanta() = false
  
  method esZoombie() = false
  
  method esSol() = false
  
}

