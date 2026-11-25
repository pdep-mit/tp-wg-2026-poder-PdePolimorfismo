import wollok.game.*
import serVivo.*
import entidades.*
import patio.*
import movimientos.*
import habilidades.*
import estadoDelJuego.*
import nivel.*
import sonidos.*

class Zoombie inherits SerVivo {
	var velocidadDeMovimiento
	const imagen = ""
	
	override method image() = imagen
	
	override method initialize() {
		super()
		self.cambiarVelocidad(velocidadDeMovimiento)
	}
	
	method avanzar() {
		position = izquierda.desde(position)
		if (patio.hayZoombiEnCasa(self.position())) finDelJuego.mostrarDerrota()
	}
	
	override method desaparecer() {
		super()
		patio.quitarZoombie(self)
		directorDeOleadas.revisarProgreso()
	}
	
	method cambiarVelocidad(nuevoIntervalo) {
		velocidadDeMovimiento = nuevoIntervalo
		self.cambiarTemporizador(new Temporizador(intervalo = nuevoIntervalo))
	}
	
	method acelerarMovimiento(factor, duracionMs) {
		const velocidadOriginal = velocidadDeMovimiento
		self.cambiarVelocidad((velocidadOriginal * factor).roundUp())
		game.schedule(
			duracionMs,
			{ if (self.estaVivo()) self.cambiarVelocidad(velocidadOriginal) }
		)
	}
}

object generarZoombis {
	method generarZombieAleatorio(tiposDisponibles) {
		const posicionAparicion = game.at(
			game.width() - 1,
			(1 .. (game.height() - 2)).anyOne()
		)
		const nuevoZombie = tiposDisponibles.anyOne().apply(posicionAparicion)
		patio.agregarZoombie(nuevoZombie)
		nuevoZombie.aparecer()
	}
}

object directorDeOleadas {
	var estado = directorInactivo
	var oleadaActual = configuracionDeOleadas.inicial()
	
	method iniciar() {
		estado.iniciar(self)
	}
	
	method detener() {
		estado = directorDetenido
	}
	
	method activarSpawneo(oleada) {
		oleadaActual = oleada
		estado = spawneandoOleada
		self.programarSiguienteZombie()
	}
	
	method programarSiguienteZombie() {
		if (not oleadaActual.aparecieronTodos()) game.schedule(
				oleadaActual.esperarEntreSpawns(),
				{ estado.ejecutarSpawn(self, oleadaActual) }
			)
	}
	
	method revisarProgreso() {
		estado.revisarProgreso(oleadaActual)
	}
	
	method esperarYArrancar(siguienteOleada) {
		estado = esperandoCambioDeOleada
		game.schedule(5000, { estado.iniciarOleada(siguienteOleada) })
	}
	
	method finalizarVictoria() {
		self.detener()
		finDelJuego.mostrarVictoria()
	}
}

object directorInactivo {
	method iniciar(director) {
		configuracionDeOleadas.inicial().iniciar()
	}
	
	method ejecutarSpawn(director, oleada) {
		
	}
	
	method revisarProgreso(oleada) {
		
	}
	
	method iniciarOleada(oleada) {
		
	}
}

object spawneandoOleada {
	method iniciar(director) {
		
	}
	
	method ejecutarSpawn(director, oleada) {
		generarZoombis.generarZombieAleatorio(oleada.constructoresDeZoombis())
		oleada.registrarAparicion()
		director.revisarProgreso()
		director.programarSiguienteZombie()
	}
	
	method revisarProgreso(oleada) {
		oleada.avanzarSiTermino()
	}
	
	method iniciarOleada(oleada) {
		
	}
}

object esperandoCambioDeOleada {
	method iniciar(director) {
		
	}
	
	method ejecutarSpawn(director, oleada) {
		
	}
	
	method revisarProgreso(oleada) {
		
	}
	
	method iniciarOleada(oleada) {
		oleada.iniciar()
	}
}

object directorDetenido {
	method iniciar(director) {
		
	}
	
	method ejecutarSpawn(director, oleada) {
		
	}
	
	method revisarProgreso(oleada) {
		
	}
	
	method iniciarOleada(oleada) {
		
	}
}

class Mono inherits Zoombie (
	habilidad = comer,
	daño = 40,
	vida = 300,
	velocidadDeMovimiento = 800
) {
	var estado = monoColumpiandoPrimerVez
	
	override method image() = estado.imagen()
	
	override method actuar() {
		estado.actuar(self)
	}
	
	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}
	
	method mitadDelPatio() = (game.width() + 4).div(2)
	
	method volverAlBordeDerecho() {
		position = game.at(game.width() - 1, position.y())
	}
	
	method soltarSoga() {
		self.cambiarVelocidad(3000)
		self.cambiarEstado(monoCaminando)
	}
}

object monoColumpiandoPrimerVez {
	method imagen() = "monoColumpiando.png"
	
	method actuar(mono) {
		mono.avanzar()
		if (mono.position().x() <= mono.mitadDelPatio()) {
			mono.volverAlBordeDerecho()
			mono.cambiarEstado(monoColumpiandoSegundaVez)
		}
	}
}

object monoColumpiandoSegundaVez {
	method imagen() = "monoColumpiando.png"
	
	method actuar(mono) {
		mono.avanzar()
		if (mono.position().x() <= mono.mitadDelPatio()) mono.soltarSoga()
	}
}

object monoCaminando {
	method imagen() = "monoZoombi.png"
	
	method actuar(mono) {
		comer.ejecutar(mono)
	}
}

const invocarPinguinoRobot = new Invocar(
	constructorZoombie = { pos => new Zoombie(
			position = pos,
			habilidad = comer,
			daño = 80,
			vida = 150,
			velocidadDeMovimiento = 3500,
			imagen = "pinguinoRobot.png"
		) }
)

class MonoMaquinista inherits Zoombie (
	habilidad = invocarPinguinoRobot,
	daño = 100,
	vida = 3000,
	velocidadDeMovimiento = 3000
) {
	var estado = maquinistaPosicionandose
	
	override method image() = estado.imagen()
	
	override method actuar() {
		estado.actuar(self)
	}
	
	method cambiarEstado(nuevoEstado) {
		estado = nuevoEstado
	}
	
	method iniciarProduccion() {
		self.cambiarVelocidad(18000)
		self.cambiarEstado(maquinistaGenerando)
	}
	
	override method acelerarMovimiento(factor, duracionMs) {
		
	}
}

object maquinistaPosicionandose {
	method imagen() = "monoMaquinista.png"
	
	method actuar(maquinista) {
		if (maquinista.position().x() > (game.width() - 3)) maquinista.avanzar()
		else maquinista.iniciarProduccion()
	}
}

object maquinistaGenerando {
	method imagen() = "monoMaquinista.png"
	
	method actuar(maquinista) {
		invocarPinguinoRobot.ejecutar(maquinista)
		sonido.sonidoGeneracionPinguino()
	}
}