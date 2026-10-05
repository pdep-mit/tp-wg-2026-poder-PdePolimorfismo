import wollok.game.*

object dañoInflingido {

    method procesarDaño (entidad , daño) {

         const vidaActual = entidad.vida() - daño

         entidad.vida(vidaActual)

         if(not(entidad.estaVivo())) {
            entidad.morir()
         }
         
    }
}

