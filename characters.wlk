class Character {
    
    const positionX
    const positionY
  
    var property position = new MutablePosition (x=positionX, y=positionY)

    method esAtravesable () = true
    
    const unidadMovimiento = 1

    method colision(personaje) {}

    method image() {
        return "" // Sobrescrito en las subclase
    }

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

    method jump() {
        [100, 200, 300].forEach { num => game.schedule(num, { self.moveUp() }) }        
        game.schedule(800, {game.onTick(100, "Fall", {self.moveDown()})})
        
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
        else 
            game.removeTickEvent("Fall")
    }

    method puedeAtravesar(nuevaPosicion) =  game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}


}

class Fireboy inherits Character {

    method isFireboy() = true

    override method image() {
        return "fireboy.png" 
    }
}

class Watergirl inherits Character {

    method isFireboy() = false

    override method image() {
        return "watergirl.png" 
    } 
}