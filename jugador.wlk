import wollok.game.*

class Nave {
	var property position
	var property vida
	var property danioBase
	
	method estaViva() = vida > 0 
	
	method recibirDanio(cantidad){
		 vida = (vida - cantidad).max(0)
		 if (!self.estaViva()){
		 	self.morir()
		 }
	}
	
	method morir(){
	//Lógica de Muerte independiente de cada Jugador
	}
	
	method distanciaManhattanA(otraNave){
		return (position.x() - otraNave.position().x()).abs() + (position.y() - otraNave.position().y()).abs()
	}
	
}

class NaveJugador inherits Nave (vida = 100, danioBase = 25){
	
	var property escudo = 20
	
    method image() = "nave.png"
    
override method recibirDanio(cantidad) {
    if (cantidad <= escudo) {
        escudo -= cantidad
    } else {
        const diferencia = cantidad - escudo
        escudo = 0
        super(diferencia)
    }
}

method moverIzquierda(arena) {
    if (position.x() > 0) {
        position = position.left(1)
    }
}

method moverDerecha(arena) {
    if (position.x() < arena.ancho() - 1) {
        position = position.right(1)
    }
}

method disparar(enemigos) {
    const objetivo = enemigos.filter({ e => e.position().x() == position.x() && e.position().y() > position.y() })
                             .minOrDefault({ e => e.position().y() }, null)
    if (objetivo != null) {
        objetivo.recibirDanio(danioBase)
    }
}

}


class EnemigoInvasor inherits Nave (vida = 30, danioBase = 15){
	
	method actuarTurno(jugadores, arena){
		
		const jugadorCercano = jugadores.min({ j => self.distanciaManhattanA(j) })
		
		if (self.distanciaManhattanA(jugadorCercano) == 1){
			jugadorCercano.recibirDanio(danioBase)
		} 
		else{
			position = position.down(1)
		}
	}
}


class EnemigoDefensivo inherits Nave (vida = 50, danioBase = 10){
	
	var property blindaje = 5

override method recibirDanio(cantidad) {
    const danioEfectivo = (cantidad - blindaje).max(1)
    super(danioEfectivo)
}
	
	method actuarTurno(jugadores, arena) {
    const objetivo = jugadores.findOrDefault(
        { j => j.estaViva() && j.position().x() == position.x() }, 
        null
    )

    if (objetivo != null) {
        objetivo.recibirDanio(danioBase)
    }
}
}













