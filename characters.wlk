import config.*

class Character {
    
    // -------------------- Referencias

    var property position
    var property oldPosition

    const unidadMovimiento = 1
    var puntos = 0

    const nivelActual
    var murioPersonaje = false

    var plataformaAdherida = null

    var jumping = false

    // -------------------- Métodos

    // Métodos Sobrescritos en las Subclases

    method image() = "" //
    method tipo() = "" //
    method setupControls() {} //

    // Métodos Propios

    method setPosition (posX, posY){ //
        position = new MutablePosition(x=posX, y=posY)
    }

    method colision(personaje) {}  // // Para que no genere error si colisionan entre personajes

    method esAtravesable () = true // 
    
    // Movimientos

    method moveLeft() {

        self.plataformaDesadherida()
        
        const nuevaPosicion = position.left(unidadMovimiento)

        if(!nivelActual.estaFueraDelMarco(nuevaPosicion))
            position.goLeft(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() + 1, y = self.position().y())
    }

    method moveRight() {

        self.plataformaDesadherida()

        const nuevaPosicion = position.right(unidadMovimiento)

        if (!nivelActual.estaFueraDelMarco(nuevaPosicion))
            position.goRight(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x() - unidadMovimiento, y = self.position().y())
    }

    method moveUp() {
      
        const nuevaPosicion = position.up(unidadMovimiento)
        
        if(!nivelActual.estaFueraDelMarco(nuevaPosicion))
            position.goUp(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x(), y = self.position().y() - unidadMovimiento)
    }

    method moveDown() {

        const nuevaPosicion = position.down(unidadMovimiento)

        if (nivelActual.esZonaProhibida(self, nuevaPosicion)){
            self.die()
        }
        else if(!nivelActual.estaFueraDelMarco(nuevaPosicion) && self.puedeAtravesar(nuevaPosicion)){
            position.goDown(unidadMovimiento)
            oldPosition = new MutablePosition(x = self.position().x(), y = self.position().y() + unidadMovimiento)
        }
        else {
        // SETEAMOS FLAG SALTANDO = FALSE (para evitar doble salto)
            jumping = false
        }
    }

    method jump() {

        self.plataformaDesadherida()

        if (!jumping){
            self.desactivarGravedad()
            jumping = true
            [100, 200, 300, 400].forEach { num => game.schedule(num, { self.moveUp() }) }        
            game.schedule(900, {self.gravedad()})
       }
    }

    //Gravedad

    method eventoGravedad ()

    method gravedad(){
        game.onTick(100, self.eventoGravedad(), {self.moveDown()})
    }

    method desactivarGravedad (){
        game.removeTickEvent(self.eventoGravedad())
    }
    
    //Colisiones

    method setupCollisions() {
        game.onCollideDo(self, {element => element.colision(self)}) 
    }

    method puedeAtravesar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}

    // Puntos y Mecanica del Juego

    method collect () {puntos += 100}

    //Muerte de personaje 

    method murioPersonaje() = murioPersonaje
    
    method die (){ 
        murioPersonaje = true       
        game.sound("S_muerte.mp3").play()
        game.addVisual(muerte)
        game.sound("S_game_over.mp3").play()
        game.schedule(3000,{game.removeVisual(muerte)})
        nivelActual.cleanVisuals() ///
        
        game.schedule(3500, {nivelActual.start()}) // Reiniciamos el nivel 
 
    } 

    method moverALaPar(plataforma) {
        plataformaAdherida = plataforma
    } 

    method plataformaDesadherida() {
        if(plataformaAdherida != null) {
            plataformaAdherida.detachCharacter()
            plataformaAdherida = null
            self.gravedad()
        }
    }   
}

class Fireboy inherits Character {

    method puntaje() = puntos

    override method tipo() = fuego

    override method image() {
        return "P_Fireboy.png" 
    }

    override method eventoGravedad () = "F_Gravedad"

    override method setupControls(){
        keyboard.left().onPressDo   ({ self.moveLeft() })
        keyboard.right().onPressDo  ({ self.moveRight() })
        keyboard.up().onPressDo     ({ self.jump() })
    }
}

class Watergirl inherits Character {

    method puntaje() = puntos 
      
    override method tipo() = agua

    override method image() {
        return "P_Watergirl.png" 
    }

    override method setupControls(){
        keyboard.a().onPressDo  ({ self.moveLeft() })
        keyboard.d().onPressDo  ({ self.moveRight() })
        keyboard.w().onPressDo  ({ self.jump() })
    }
    
    override method eventoGravedad () = "W_Gravedad"
}

object fuego {}

object agua {}

object acido {}