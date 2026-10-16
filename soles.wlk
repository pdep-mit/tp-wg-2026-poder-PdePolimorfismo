import wollok.game.*

class Sol {
    var property position
    var property recolectado = false
    const valorDelSol = 25

    method image() = "sol.png"
    method esSol() = true
    method valor () = valorDelSol

    //method recolectar () = recolectado
    method recolectar() {
        if (not recolectado) {
            recolectado = true
            self.detener()
            contadorDeSoles.sumar(self.valor())
            game.removeVisual(self)
        }
    }
    method aparecer() {
        game.addVisual(self)
        game.onTick(1800, self.nombreDelTick(), { self.desplazarseEnEjeY() })
    }

    method desaparecer() {
        self.detener()
        game.removeVisual(self)
    }

    method desplazarseEnEjeY() {
        if (recolectado) {
            self.detener()
        } else if (position.y() > 0) {
            position = position.down(1)
        } else {
            self.desaparecer()
        }
    }

    method detener() {
        game.removeTickEvent(self.nombreDelTick())
    }

    method nombreDelTick() = "sol" + self.identity()

}

 object contadorDeSoles {
    var cantidad = 0

    method total() = cantidad

    method sumar(valor) {
        cantidad = cantidad + valor
        self.actualizar()
    }

    method actualizar() {
        //// ver como arreglar para que se vea en el contador de la pantalla
        game.title("Plantas vs Zoombies - Soles: " + cantidad)
    }
}

object generadorDeSoles {
    method iniciar() {
        //// Aparece un sol nuevo cada 6 segundos.
        game.onTick(6000, "generadorDeSoles", {self.generar() })
    }

    method generar() {
    
        // Se usa la cantidad de columnas como límite, y truncate(0) para obtener entero.
        const columnaAleatoria = 0.randomUpTo(game.width()).truncate(0)
        // Si randomUpTo devuelve el límite superior, lo ajustamos a la última columna válida.
        var columna = columnaAleatoria

        if (columna >= game.width()) {
            columna = game.width() - 1
        }
        const sol = new Sol(
            position = game.at(columna, game.height() - 1))
        sol.aparecer()
    }
}

