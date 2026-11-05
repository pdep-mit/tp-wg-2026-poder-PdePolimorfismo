import wollok.game.*

class Entidad{

	var property position
	
	method image()
	
	method aparecer(){
		game.addVisual(self)
	}
	
	method avanzar() {}
	
	method actuar()
	
	method desaparecer() {
		if(game.hasVisual(self)) 
			game.removeVisual(self)
	}
	
	method detenerse() {}

}