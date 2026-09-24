import wollok.game.*
import jugador.*
import arena.*

object partida {
	const property arena = new Arena(ancho = 11, alto = 11)
    const property jugadores = [new NaveJugador(position = game.at(5, 1))]
    const property enemigos = []
	
	//Purgas
	method finalizarTurnoEnemigos(){
		enemigos.removeAllSuchThat({e => !e.estaViva()})
	}
	
	method finalizarTurnoAliado(){
		jugadores.removeAllSuchThat({j => !j.estaViva()})
	}
	
	
	//Condiciones de Corte
	method victoria() = enemigos.isEmpty() && jugadores.any({j => j.estaViva()})
	
	method derrota() = jugadores.isEmpty()
	
	method cierreDeCombate() = self.victoria() || self.derrota()
	
	method partidaContinua() = !self.cierreDeCombate()	
	
	
	//Flujo del turno 
    method finalizarTurno() {
        self.finalizarTurnoEnemigos()

        if (self.partidaContinua()) {
            enemigos.forEach({ e => e.actuarTurno(jugadores, arena) })
        }

        self.finalizarTurnoAliado()
    }
}