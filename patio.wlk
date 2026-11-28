import wollok.game.*
import estadoDelJuego.*
import movimientos.*
import soles.*

object dia {
	method imagenEscenario() = "escenarioDia.jpg"
	
	method activarEn(unPatio) {
		unPatio.aplicarMomento(self)
		generadorDeSoles.activarGeneracion()
	}
	
	method cambiarA(nuevoMomento, unPatio) {
		nuevoMomento.activarDesdeDia(unPatio)
	}
	
	method activarDesdeDia(unPatio) {
		
	}
	
	method activarDesdeNoche(unPatio) {
		self.activarEn(unPatio)
	}
}

object noche {
	method imagenEscenario() = "escenarioNoche.jpg"
	
	method activarEn(unPatio) {
		unPatio.aplicarMomento(self)
		generadorDeSoles.detenerGeneracion()
	}
	
	method cambiarA(nuevoMomento, unPatio) {
		nuevoMomento.activarDesdeNoche(unPatio)
	}
	
	method activarDesdeNoche(unPatio) {
		
	}
	
	method activarDesdeDia(unPatio) {
		self.activarEn(unPatio)
	}
}

object patio {
	const soles = []
	const zoombies = []
	const plantas = []
	const podadoras = []
	const proyectiles = []
	var momentoDelDia = dia
	
	method momentoDelDia() = momentoDelDia
	
	method cambiarMomentoDelDia(nuevoMomento) {
		momentoDelDia.cambiarA(nuevoMomento, self)
	}
	
	method aplicarMomento(nuevoMomento) {
		momentoDelDia = nuevoMomento
		game.boardGround(momentoDelDia.imagenEscenario())
	}
	
	method agregarSol(sol) {
		soles.add(sol)
	}
	
	method quitarSol(sol) {
		soles.remove(sol)
	}
	
	method agregarZoombie(zombie) {
		zoombies.add(zombie)
	}
	
	method quitarZoombie(zombie) {
		zoombies.remove(zombie)
	}
	
	method agregarPlanta(planta) {
		plantas.add(planta)
	}
	
	method quitarPlanta(planta) {
		plantas.remove(planta)
	}
	
	method agregarPodadora(podadora) {
		podadoras.add(podadora)
	}
	
	method quitarPodadora(podadora) {
		podadoras.remove(podadora)
	}
	
	method agregarProyectil(proyectil) {
		proyectiles.add(proyectil)
	}
	
	method quitarProyectil(proyectil) {
		proyectiles.remove(proyectil)
	}
	
	method entidades() = (((soles + plantas) + zoombies) + podadoras) + proyectiles
	
	method haySolEnCasilla(pos) = soles.any({ sol => sol.position() == pos })
	
	method solEnCasilla(pos) = soles.find({ sol => sol.position() == pos })
	
	method cantidadDeZoombies() = zoombies.size()
	
	method pasarTiempo(ms) {
		finDelJuego.avanzarTiempo(ms, self.entidades())
	}
	
	method limpiarSoles() {
		(soles + []).forEach({ sol => sol.desaparecer() })
	}
	
	method limpiarTablero() {
		(self.entidades() + []).forEach({ entidad => entidad.desaparecer() })
	}
	
	method plantasEnCasilla(pos) = plantas.filter({ pla => pla.position() == pos })
	
	method hayPlantaEnCasilla(pos) = plantas.any({ pla => pla.position() == pos })
	
	method hayPlantaEnCasillaOEnFrenteDe(zoombie) = self.hayPlantaEnCasilla(
		zoombie.position()
	) || self.hayPlantaEnCasilla(izquierda.desde(zoombie.position()))
	
	method plantasEnRangoAdelanteDe(entidad, distanciaMaxima) = plantas.filter(
		{ p =>
			(p.position().y() == entidad.position().y()) && (entidad.position().x() - p.position().x()).between(
				0,
				distanciaMaxima
			) }
	)
	
	method plantasEnFila(fila) = plantas.filter({ p => p.position().y() == fila })
	
	method removerPlantaEn(pos) {
		self.plantasEnCasilla(pos).forEach({ planta => planta.desaparecer() })
	}
	
	method colocarPlanta(planta) {
		self.agregarPlanta(planta)
		planta.aparecer()
	}
	
	method hayZoombieDelanteDe(planta) = zoombies.any(
		{ zoo =>
			(zoo.position().y() == planta.position().y()) && (zoo.position().x() > planta.position().x()) }
	)
	
	method hayPlantaEnFilaAdelanteDe(zoombie) = plantas.any(
		{ p =>
			(p.position().y() == zoombie.position().y()) && (p.position().x() <= zoombie.position().x()) }
	)
	
	method zoombiEnRangoDeExplosion(centro) = zoombies.filter(
		{ zoo => self.estaEnArea3x3(zoo.position(), centro) }
	)
	
	method estaEnArea3x3(
		pos,
		centro
	) = ((pos.x() - centro.x()).abs() <= 1) && ((pos.y() - centro.y()).abs() <= 1)
	
	method daniarZoombiesEnRangoDeExplosion(centro, cantidadDanio) {
		self.zoombiEnRangoDeExplosion(centro).forEach(
			{ zoombie => zoombie.recibirDaño(cantidadDanio) }
		)
	}
	
	method daniarZoombiesEnCasilla(pos, cantidadDanio) {
		self.zoombiesEnCasilla(pos).forEach(
			{ zoombie => zoombie.recibirDaño(cantidadDanio) }
		)
	}
	
	method potenciarVelocidadZoombies(factor, duracionMs) {
		zoombies.forEach({ z => z.acelerarMovimiento(factor, duracionMs) })
	}
	
	method hayZoombiEnCasa(pos) = pos.x() == 1
	
	method recolectarSolEn(pos) {
		soles.filter({ sol => sol.position() == pos }).take(1).forEach(
			{ sol => sol.recolectar() }
		)
	}
	
	method zoombiesEnCasilla(pos) = zoombies.filter({ z => z.position() == pos })
	
	method casillasEnAreaDeExplosion(centro) = ((-1) .. 1).flatMap(
		{ dx => ((-1) .. 1).map({ dy => game.at(centro.x() + dx, centro.y() + dy) }) }
	).filter({ posicion => self.esCasillaDelJardin(posicion) })
	
	method esCasillaDelJardin(posicion) = posicion.x().between(
		2,
		game.width() - 1
	) && posicion.y().between(1, game.height() - 2)
}