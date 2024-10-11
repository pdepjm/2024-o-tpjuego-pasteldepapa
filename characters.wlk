class Character {
    
    // Referencias

    const positionX
    const positionY
  
    var property position = new MutablePosition (x=positionX, y=positionY)

    const unidadMovimiento = 1


    // Métodos Sobrescritos en las Subclases

    method image() = "" 
    method tipo() = "" 

    // -------------------- Métodos

    method colision(personaje) {}  // Para que no genere error si colisionan entre personajes

    method esAtravesable () = true // Para los bordes y pisos
    
    // ------------ Movimientos

    method moveLeft() {
        const nuevaPosicion = position.left(unidadMovimiento)   
        if (self.puedeAtravesar(nuevaPosicion))
            position.goLeft(unidadMovimiento)
    }

    method moveRight() {
        const nuevaPosicion = position.right(unidadMovimiento)
        if (self.puedeAtravesar(nuevaPosicion))
            position.goRight(unidadMovimiento)
    }

    method moveUp() {
        const nuevaPosicion = position.up(unidadMovimiento)
        if (self.puedeAtravesar(nuevaPosicion))
            position.goUp(unidadMovimiento)
    }

    method moveDown() {
        const nuevaPosicion = position.down(unidadMovimiento)
        if (self.puedeAtravesar(nuevaPosicion)){
            position.goDown(unidadMovimiento)
        }
    }

    method jump() {
        game.removeTickEvent("Gravedad")
        [100, 200, 300, 400].forEach { num => game.schedule(num, { self.moveUp() }) }        
        game.schedule(900, {game.onTick(100, "Gravedad", {self.moveDown()} )})
    }

    method puedeAtravesar(nuevaPosicion) =  game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}

}

class Fireboy inherits Character {

    override method tipo() = fuego

    override method image() {
        return "Fireboy.png" 
    }
}

class Watergirl inherits Character {

    override method tipo() = agua

    override method image() {
        return "Watergirl.png" 
    } 
}


object fuego {}

object agua {}