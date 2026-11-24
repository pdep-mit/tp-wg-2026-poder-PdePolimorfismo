import wollok.game.*
import entidades.*

class SerVivo inherits Entidad {
	var property habilidad
	var vida
	const property daño
	
	method estaVivo() = vida > 0
    
	override method actuar() {
		habilidad.ejecutar(self)
	}
    
	method recibirDaño(cantidad) {
		vida = 0.max(vida - cantidad)
		if (not self.estaVivo()) {
			self.desaparecer()
		}
	}
}