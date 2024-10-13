import config.*

class Character {
    
    // Referencias

    const property position
    var property oldPosition

    const unidadMovimiento = 1

    var positions = []
    
    var property enPuerta = false

    var puntos = 0
    method position(invalidPositions) {
        positions = invalidPositions
    }

    // Métodos Sobrescritos en las Subclases

    method image() = "" 
    method tipo() = "" 

    method colision(personaje) {}  // Para que no genere error si colisionan entre personajes

    method esColisionable () = true // Para los bordes y pisos
    
    // ------------ Movimientos

    method esAtravesable () = true
    
    method moveLeft() {
        const nuevaPosicion = [position.left(unidadMovimiento).x(), position.y()]   
        
        if(!positions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion))
            position.goLeft(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() + 1, y = self.position().y())
    }

    method moveRight() {
        const nuevaPosicion = [position.right(unidadMovimiento).x(), position.y()]

        if (!positions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion))
            position.goRight(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() - unidadMovimiento, y = self.position().y())
    }

    method moveUp() {
        const nuevaPosicion = [position.x(), position.up(unidadMovimiento).y()]
        const posicionAtravesable = position.up(unidadMovimiento)
        
        if(!positions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion) && self.puedeAtravesar(nuevaPosicion))
            position.goUp(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x(), y = self.position().y() - unidadMovimiento)
    }

    method moveDown() {
        const nuevaPosicion = [position.x(), position.down(unidadMovimiento).y()]
        const posicionAtravesable = position.down(unidadMovimiento)

        if (self.esZonaProhibida(nuevaPosicion)){
            self.die()
        }
        else if(!positions.contains(nuevaPosicion) && self.puedeColisionar(posicionAtravesable) && self.puedeAtravesar(posicionAtravesable)){
            position.goDown(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x(), y = self.position().y() + unidadMovimiento)
        }

    }

    method jump() {
        game.removeTickEvent("Gravedad")
        [100, 200, 300, 400].forEach { num => game.schedule(num, { self.moveUp() }) }        
        game.schedule(900, {game.onTick(100, "Gravedad", {self.moveDown()} )})
    }
    
    method gravedad(){
        game.onTick(100, "Gravedad", {self.moveDown()})
    }

    method setupControls() {}
    
    method setupCollisions() {
        game.onCollideDo(self, {element => element.colision(self)}) 
    }
    
    //Definimos zonas de charcos

    var zonasProhibidas = []
    
    method zonasProhibidas (charcos){
        zonasProhibidas = charcos
    }

    method esZonaProhibida (posicion) = zonasProhibidas.contains(posicion)

    method puedeColisionar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esColisionable()}

    method puedeAtravesar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}

    // Puntos y Mecanica del Juego

    method collect () {puntos += 100}
    
    method die (){
        game.removeVisual(self.image())
        game.sound("muerte.mp3").play()
        game.addVisual(muerte)
        game.sound("sonido_de_fin_de_juego.mp3").play()
        game.schedule(5000,{game.removeVisual(muerte)})
        // RESTART LEVEL1
    }
    
    
}

class Fireboy inherits Character {

    override method tipo() = fuego

    override method image() {
        return "Fireboy.png" 
    }

    method puntaje() = puntos

    override method setupControls(){
        keyboard.left().onPressDo   ({ self.moveLeft() })
        keyboard.right().onPressDo  ({ self.moveRight() })
        keyboard.up().onPressDo     ({ self.jump() })
    }
}

class Watergirl inherits Character {

    override method tipo() = agua

    override method image() {
        return "Watergirl.png" 
    }

    override method setupControls(){
        keyboard.a().onPressDo  ({ self.moveLeft() })
        keyboard.d().onPressDo  ({ self.moveRight() })
        keyboard.w().onPressDo  ({ self.jump() })
    }

    method puntaje() = puntos 
}

object fuego {}

object agua {}