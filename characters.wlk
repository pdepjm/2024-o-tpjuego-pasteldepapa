import config.*
import visualCarteles.*


// -------------------------------- Personajes

// ------------------ Superclase

class Character {
    
    // -------------------- Referencias

    // Particular para Instancias

    var property position
    var property oldPosition
    const property nivelActual

    // Generales

    var property murioPersonaje = false
    var property jumping = false
    var plataformaAdherida = null
    const unidadMovimiento = 1

    var property murioPersonajeTest = false 

    // -------------------- Métodos

    // Métodos Sobrescritos en las Subclases

    method image()
    method tipo()
    method setupControls() 
    method eventoGravedad ()
    method esColisionable() = false

    // Generales

    method esAtravesable () = true 

    method setPosition (posX, posY){ 
        position = new MutablePosition(x=posX, y=posY)
    }

    method colision(personaje) {} // Para que no genere error si colisionan entre personajes

    // Movimientos

    method move (direction){

        self.plataformaDesadherida()
    
        const nuevaPosicion = direction.calcularNuevaPosicion(self)

        if(direction.puedeMoverse(self, nuevaPosicion))
            direction.actualizarPosicion(self, nuevaPosicion)
    }
   
    method jump() {

        self.plataformaDesadherida()
        const nuevaPosicion = position.down(unidadMovimiento)
        
        if (self.puedeSaltar(nuevaPosicion)){
            self.desactivarGravedad()
            jumping = true
            [150, 300, 450, 600].forEach { num => game.schedule(num, { self.move(up) }) }        
            game.schedule(800, {self.gravedad()})
        }
    }

    method puedeSaltar(nuevaPosicion) = 
        !jumping && (self.nivelActual().estaFueraDelMarco(nuevaPosicion) || !self.puedeAtravesar(nuevaPosicion))


    // Gravedad

    method gravedad(){
        game.onTick(250, self.eventoGravedad(), {self.move(down)})
    }

    method desactivarGravedad (){
        game.removeTickEvent(self.eventoGravedad())
    }
    
    // Colisiones

    method setupCollisions() {
        game.onCollideDo(self, {element => element.colision(self)}) 
    }

    // Control movimiento

    method puedeDesplazarse(nuevaPosicion) = self.puedeAtravesar(nuevaPosicion) || self.puedeColisionar(nuevaPosicion)
    
    method puedeAtravesar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}
 
    method puedeColisionar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esColisionable()}
    
    method estaDentroDelMarco(nuevaPosicion) = !self.nivelActual().estaFueraDelMarco(nuevaPosicion)

    // Muerte de personaje 
    
    method die (){ 
        self.murioPersonajeTest(true)
        self.murioPersonaje(true)       
        game.sound("S_muerte.mp3").play()
        game.addVisual(muerteCartel)
        nivelActual.cleanVisuals()
        game.sound("S_game_over.mp3").play()
        game.schedule(3000,{game.removeVisual(muerteCartel)})
        game.schedule(3000, {nivelActual.restart()}) // Reiniciamos el nivel 
        game.schedule(3000, {self.murioPersonaje(false)}) // Reiniciamos el flag de muerte
    } 

    // Mecanica con Plataforma

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

    method colisionEspecial(objeto) {   // SI HAY ALGO MEJOR, CAMBIAR
        objeto.colisionEspecial(self)
    }   
}

// ------------------ Subclases

class Fireboy inherits Character {

    override method tipo() = fuego

    override method image() = "P_Fireboy.png" 

    override method eventoGravedad () = "F_Gravedad"

    override method setupControls(){
        keyboard.left().onPressDo   ({ self.move(left) })
        keyboard.right().onPressDo  ({ self.move(right) })
        keyboard.up().onPressDo     ({ self.jump() })
    }
}

class Watergirl inherits Character {
      
    override method tipo() = agua

    override method image() = "P_Watergirl.png" 

    override method setupControls(){
        keyboard.a().onPressDo  ({ self.move(left) })
        keyboard.d().onPressDo  ({ self.move(right) })
        keyboard.w().onPressDo  ({ self.jump() })
    }
    
    override method eventoGravedad () = "W_Gravedad"
}

// -------------------------------- Direcciones

class Direction {
    const unidadMovimiento = 1

    method puedeMoverse(character, nuevaPosicion) = 
        character.estaDentroDelMarco(nuevaPosicion) && character.puedeDesplazarse(nuevaPosicion)

    method actualizarOldPosition(incrementoX, incrementoY, personaje) {
        personaje.oldPosition(new MutablePosition(x = personaje.position().x() + incrementoX, y = personaje.position().y() + incrementoY))
    }

    method calcularNuevaPosicion(personaje)
    method actualizarPosicion(personaje, nuevaPosicion)
}

object left inherits Direction {

    override method calcularNuevaPosicion(character) = character.position().left(unidadMovimiento)

    override method actualizarPosicion(character, nuevaPosicion){
        character.position().goLeft(1)
        self.actualizarOldPosition(unidadMovimiento, 0, character)
    }
}

object right inherits Direction{
    
    override method calcularNuevaPosicion(character) = character.position().right(1)

    override method actualizarPosicion(character, nuevaPosicion){
        character.position().goRight(1)
        self.actualizarOldPosition(-unidadMovimiento, 0, character)
    }
}

object up inherits Direction{
    
    override method calcularNuevaPosicion(character) = character.position().up(1)

    override method actualizarPosicion(character, nuevaPosicion){
        character.position().goUp(1)
        self.actualizarOldPosition(0, -unidadMovimiento, character)
    }
}

object down inherits Direction {
    
    override method puedeMoverse(character, nuevaPosicion) = true

    override method calcularNuevaPosicion(character) = character.position().down(1)
    
    override method actualizarPosicion(character, nuevaPosicion) {

        if (self.pisaZonaProhibida(character, nuevaPosicion) && self.personajesVivos(character)) {
          
            character.die()
        }
        else if(self.posicionValida(character, nuevaPosicion)){
       
            character.position().goDown(1)
            self.actualizarOldPosition(0, unidadMovimiento, character)
        }
        else
            character.jumping(false) // evitar doble salto 
        
    }

    method pisaZonaProhibida(character, nuevaPosicion) = character.nivelActual().esZonaProhibida(character, nuevaPosicion)
    
    method personajesVivos(character) = character.nivelActual().todosVivos()
    
    method posicionValida(character, nuevaPosicion) = 
        character.estaDentroDelMarco(nuevaPosicion) && character.puedeAtravesar(nuevaPosicion)
}

// -------------------------------- Tipos

object fuego {}

object agua {}

object acido {}