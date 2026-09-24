
class Arena {
	const property ancho
	const property alto
	
	method verificarLimites(posicion){
		return posicion.x().between(0, ancho -1) &&
		posicion.y().between(0, alto -1)
	}
}