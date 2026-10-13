object sinAtaque {

    method ejecutar(planta, zoombie) {
    }
}


object ataqueLargaDistancia {

    method ejecutar(planta, zoombie) {
        zoombie.recibirDaño(planta.dañoQueHace())
    }
}


object ataqueCuerpoACuerpo {

    method ejecutar(planta, zoombie) {
        zoombie.recibirDaño(planta.dañoQueHace())
    }
}


object ataqueExplosivo {

    method ejecutar(planta, zoombie) {
        zoombie.recibirDaño(zoombie.vida())
    }
}