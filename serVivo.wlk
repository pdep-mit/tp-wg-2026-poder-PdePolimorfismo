import wollok.game.*
import entidades.*
import patio.*

class SerVivo inherits Entidad{
	
	var property habilidad
	var vida
	const danio
	
	method estaVivo() = vida > 0
	
    method danioQueHace() = danio
    
    override method actuar(){
    	habilidad.ejecutar(self)
    }
    
    method recibirDanio(cantidad){
    	vida = 0.max(vida - cantidad)
    	if(not self.estaVivo()) self.desaparecer()
    }

}
