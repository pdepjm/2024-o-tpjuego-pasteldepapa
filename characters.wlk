class Character {
    
    // Referencias

    const positionX
    const positionY

    var property position = new MutablePosition (x=positionX, y=positionY)
    var property oldPositionX = new MutablePosition (x=positionX, y=positionY)

    const unidadMovimiento = 1


    // Métodos Sobrescritos en las Subclases

    method image() = "" 
    method tipo() = "" 

    // -------------------- Métodos

    method colision(personaje) {}  // Para que no genere error si colisionan entre personajes

    method esAtravesable () = true // Para los bordes y pisos
    
    // ------------ Movimientos

    method moveLeft() {
        oldPositionX = self.position().x()
        const nuevaPosicion = position.left(unidadMovimiento)   
        if (self.puedeAtravesar(nuevaPosicion) || self.puedeColisionar(nuevaPosicion))
            position.goLeft(unidadMovimiento)
    }

    method moveRight() {
        oldPositionX = self.position().x()
        const nuevaPosicion = position.right(unidadMovimiento)
        if (self.puedeAtravesar(nuevaPosicion) || self.puedeColisionar(nuevaPosicion))
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


    method puedeColisionar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esColisionable()}

    method die (){
        game.removeVisual(self.image())
        // SONIDO MUERTE
        // IMAGEN GAME_OVER
        // RESTART LEVEL1
    }

    

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

class Charco {
    
    const tipo
    const posX
    const posY

    method position() = game.at(posX, posY)

    method esAtravesable () = false
    
    method colision(personaje){
        if(tipo.personaje() != tipo){
            personaje.die()
        }
    }
}