import wollok.game.*
import patio.*
import zoombie.*
import rinoZoombie.*
import jirafaZoombie.*
import buitreZoombie.*
import osoZoombie.*
import perroSalchichaZoombie.*
import habilidades.*
import sonidos.*


class Oleada {
	const numeroDeOleada
	const cantidadDeZoombis
	const property constructoresDeZoombis
	const property intervaloMinimo
	const property intervaloMaximo
	const siguienteOleada = ultimaOleada
	const momentoDelDia = dia
	const property soundtrack = new PistaMusical(archivo = "oleada1.wav")
	var pendientes = 0

    method iniciar() {
        pendientes = cantidadDeZoombis
        patio.cambiarMomentoDelDia(momentoDelDia)
        sonido.cambiarMusica(soundtrack)
        indicadorDeOleada.mostrar(numeroDeOleada)
        directorDeOleadas.activarSpawneo(self)
    }

    method registrarAparicion() {
        pendientes -= 1
    }

    method aparecieronTodos() = pendientes == 0

    method esperarEntreSpawns() = (intervaloMinimo .. intervaloMaximo).anyOne()

    method avanzarSiTermino() {
        if (self.aparecieronTodos() && patio.cantidadDeZoombies() == 0) {
            siguienteOleada.prepararTransicion()
        }
    }

    method prepararTransicion() {
        directorDeOleadas.esperarYArrancar(self)
    }
}

object ultimaOleada {
    method prepararTransicion() {
        directorDeOleadas.finalizarVictoria()
    }
}

object indicadorDeOleada {
    var numeroActual = 0
    const property position = game.at(6, game.height() + 1)

    method mostrar(numero) {
        numeroActual = numero
    }

    method image() = "bloqueBlanco.png"
    method textColor() = "000000FF"
    method text() = "\n\n\n\n Oleada " + numeroActual.toString() + " / 5"
}

object configuracionDeOleadas {

    method constructoresDeZoombisAleatorios() = oleada4.constructoresDeZoombis()

    method crearPinguino(pos) = new Zoombie(
		position = pos,
		habilidad = comer,
		daño = 100,
		vida = 200,
		velocidadDeMovimiento = 3000,
        estado = pinguinoCaminando,
		imagen = "pinguinoZoombie.png"
	)

    const oleada5 = new Oleada(
        numeroDeOleada = 5,
        cantidadDeZoombis = 1,
        intervaloMinimo = 2500,
        intervaloMaximo = 3500,
        soundtrack = new PistaMusical(archivo = "oleada5.wav"),
        constructoresDeZoombis = [
            { pos => new PerroSalchicha(position = pos) }]
    )
    const oleada4 = new Oleada(
        numeroDeOleada = 4,
        cantidadDeZoombis = 20,
        intervaloMinimo = (4500 .. 6000).anyOne(),
        intervaloMaximo = (7500 .. 10000).anyOne(),
        siguienteOleada = oleada5,
        momentoDelDia = noche,
        soundtrack = new PistaMusical(archivo = "oleada3y4.wav"),
        constructoresDeZoombis = [
            { pos => new Rinoceronte(position = pos) },
            { pos => new Oso(position = pos) },
            { pos => new Buitre(position = pos) },
            { pos => new Jirafa(position = pos) },
            { pos => self.crearPinguino(pos) },
            { pos => new Mono(position = pos) }
        ]
    )
    const oleada3 = new Oleada(
        numeroDeOleada = 3,
        cantidadDeZoombis = 15,
        intervaloMinimo = (7000 .. 8500).anyOne(),
        intervaloMaximo = (9000 .. 12000).anyOne(),
        siguienteOleada = oleada4,
        momentoDelDia = noche,
        soundtrack = new PistaMusical(archivo = "oleada3y4.wav"),
        constructoresDeZoombis = [
            { pos => new Buitre(position = pos) },
            { pos => new Jirafa(position = pos) },
            { pos => self.crearPinguino(pos) },
            { pos => new Mono(position = pos) },
            { pos => new Rinoceronte(position = pos) }
        ]
    )
    const oleada2 = new Oleada(
        numeroDeOleada = 2,
        cantidadDeZoombis = 10,
        intervaloMinimo = (8000 .. 10000).anyOne(),
        intervaloMaximo = (12000 .. 16000).anyOne(),
        siguienteOleada = oleada3,
        soundtrack = new PistaMusical(archivo = "oleada2.wav"),
        constructoresDeZoombis = [
            { pos => new Jirafa(position = pos) },
            { pos => self.crearPinguino(pos) },
            { pos => new Mono(position = pos) },
            { pos => new Buitre(position = pos)}
        ]
    )
    const property inicial = new Oleada(
        numeroDeOleada = 1,
        cantidadDeZoombis = 5,
        intervaloMinimo = (15000 .. 18000).anyOne(),
        intervaloMaximo = (20000 .. 25000).anyOne(),
        siguienteOleada = oleada2,
        soundtrack = new PistaMusical(archivo = "oleada1.wav"),
        constructoresDeZoombis = [
            { pos => new Mono(position = pos)},
            { pos => self.crearPinguino(pos)}
        ]
    )
}