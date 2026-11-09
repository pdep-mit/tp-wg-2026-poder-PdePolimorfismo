import wollok.game.*
import soles.*

object patio{
	 const property soles = []
     const property zoombies = []
     const property plantas = []
     const property podadoras = []
     const property proyectiles = []
 
	 method agregarSol(sol)           { soles.add(sol) }
     method quitarSol(sol)            { soles.remove(sol) }
     method agregarZoombie(zombie)     { zoombies.add(zombie) }
     method quitarZoombie(zombie)      { zoombies.remove(zombie) }
     method agregarPlanta(planta)     { plantas.add(planta) }
     method quitarPlanta(planta)      { plantas.remove(planta) }
     method agregarPodadora(podadora) { podadoras.add(podadora) }
 	 method quitarPodadora(podadora)  { podadoras.remove(podadora) }
 	 method agregarProyectil(proyectil) {proyectiles.add(proyectil)}
 	 method quitarProyectil(proyectil) {proyectiles.remove(proyectil)}
 	 
 	 method entidades() = soles + plantas + zoombies + podadoras + proyectiles 
 	 
 	 method hayPlantaEnCasilla(pos) = plantas.any({pla => 
 	 		pla.position() == pos
 	 })
 	 
 	 method plantaEnCasilla(pos) = plantas.find({pla => 
 	 		pla.position() == pos
 	 })
 	 
 	 method hayZoombieDelanteDe(planta) = zoombies.any({zoo => 
 	 		zoo.position().y() == planta.position().y() &&
 	 		zoo.position().x() > planta.position().x()
 	 })

	 method zoombieDelanteDe(planta) = zoombies.find({ zoo => 
        zoo.position().y() == planta.position().y() &&
        zoo.position().x() >= planta.position().x()
    })

    method hayZoombieEnCasilla(pos) = zoombies.any({zoo => 
 	 	    zoo.position() == pos
     })

     method zoombieEnCasilla(pos) = zoombies.find({zoo => 
 	 		zoo.position() == pos
     })
 	 
 	 method haySolEnCasilla(pos) = soles.any({sol => 
 	 		sol.position() == pos
 	 })

     method solEnCasilla(pos) = soles.find({sol => 
 	 		sol.position() == pos
     })
}
