import wollok.game.*

object dañoInfligido {

    method procesarDaño (entidad , daño) {

         const vidaActual = entidad.vida() - daño

         entidad.vida(vidaActual)

         if(not entidad.estaVivo()) {
            entidad.morir()
         }
         
    }
}

