import config.*

class Character {
    
    // Referencias

    var property position
    var property oldPosition

    const unidadMovimiento = 1
    var puntos = 0

    const invalidPositions = [] // Lista de posiciones invalidas (se la pasamos al incio)
    const zonasProhibidas = [] // Lista de charcos de distinto tipo (se la pasamos al incio)
    
    var property enPuerta = false

    const nivelActual

    // Métodos Sobrescritos en las Subclases

    method image() = "" 
    method tipo() = "" 

    method setPosition (posX, posY){
        position = new MutablePosition(x=posX, y=posY)
    }

    method colision(personaje) {}  // Para que no genere error si colisionan entre personajes

    method esColisionable () = true // Para los bordes y pisos
    
    // ------------ Movimientos

    method esAtravesable () = true
    
    method moveLeft() {
        const nuevaPosicion = [position.left(unidadMovimiento).x(), position.y()]   
        
        if(!invalidPositions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion))
            position.goLeft(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() + 1, y = self.position().y())
    }

    method moveRight() {
        const nuevaPosicion = [position.right(unidadMovimiento).x(), position.y()]

        if (!invalidPositions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion))
            position.goRight(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() - unidadMovimiento, y = self.position().y())
    }

    method moveUp() {
        const nuevaPosicion = [position.x(), position.up(unidadMovimiento).y()]
        const posicionAtravesable = position.up(unidadMovimiento)
        
        if(!invalidPositions.contains(nuevaPosicion) && self.puedeColisionar(nuevaPosicion) && self.puedeAtravesar(nuevaPosicion))
            position.goUp(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x(), y = self.position().y() - unidadMovimiento)
    }

    method moveDown() {
        const nuevaPosicion = [position.x(), position.down(unidadMovimiento).y()]
        const posicionAtravesable = position.down(unidadMovimiento)

        if (self.esZonaProhibida(nuevaPosicion)){
            self.die()
        }
        else if(!invalidPositions.contains(nuevaPosicion) && self.puedeColisionar(posicionAtravesable) && self.puedeAtravesar(posicionAtravesable)){
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

    method esZonaProhibida (posicion) = zonasProhibidas.contains(posicion)

    method puedeColisionar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esColisionable()}

    method puedeAtravesar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}

    // Puntos y Mecanica del Juego

    method collect () {puntos += 100}
    
    method die (){        
        //game.sound("S_muerte.mp3").play()
        //game.addVisual(muerte)
        //game.sound("S_game_over.mp3").play()
        //game.schedule(3000,{game.removeVisual(muerte)})
        game.schedule(3000, {nivelActual.start()}) // Reiniciamos el nivel 
        // RESTART LEVEL1
    }    



}

class Fireboy inherits Character {

    override method tipo() = fuego

    override method image() {
        return "P_Fireboy.png" 
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
        return "P_Watergirl.png" 
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