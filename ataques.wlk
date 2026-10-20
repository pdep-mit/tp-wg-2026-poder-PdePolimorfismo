

object sinAtaque {

    method ejecutar(planta, zoombie) {
        // no hace nada
    }
}


object ataqueLargaDistancia {

    method ejecutar(planta, zoombie) {
        if (planta.estaEnSuRango(zoombie)) {
            zoombie.recibirDaño(planta.dañoQueHace())
    }
}
}

// Solo puede atacar a un zoombie que esté al lado
object ataqueCuerpoACuerpo {

    method ejecutar(planta, zoombie) {
        if (planta.posicion().right(1) == zoombie.posicion())
        zoombie.recibirDaño(planta.dañoQueHace())
    }
}


object ataqueExplosivo {

    method ejecutar(planta, zoombie) {
        zoombie.forEach({zombie => 
            if (planta.estaEnSuRango(zoombie)) {
                zoombie.morir()
            }
        })
        
    }
}
