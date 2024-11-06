import config.*
import visualCarteles.*

class Character {
    
    // -------------------- Referencias

    var property position
    var property oldPosition

    const property nivelActual
    var property murioPersonaje = false

    var plataformaAdherida = null

    var property jumping = false

    const unidadMovimiento = 1

    // -------------------- Métodos

    // Métodos Sobrescritos en las Subclases

    method image()
    method tipo()
    method setupControls() 

    // Métodos Propios

    method setPosition (posX, posY){ 
        position = new MutablePosition(x=posX, y=posY)
    }

    method colision(personaje) {} // Para que no genere error si colisionan entre personajes

    method esAtravesable () = true  
    
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
        
        if (!jumping && (self.nivelActual().estaFueraDelMarco(nuevaPosicion) || !self.puedeAtravesar(nuevaPosicion))){
            self.desactivarGravedad()
            jumping = true
            [150, 300, 450, 600].forEach { num => game.schedule(num, { self.move(up) }) }        
            game.schedule(800, {self.gravedad()})
        }
    }

    // Gravedad

    method eventoGravedad ()

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

    //Control movimiento

    method puedeDesplazarse(nuevaPosicion) = self.puedeAtravesar(nuevaPosicion) || self.puedeColisionar(nuevaPosicion)
    
    method puedeAtravesar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}
 
    method puedeColisionar(nuevaPosicion) = game.getObjectsIn(nuevaPosicion).all{obj => obj.esColisionable()}
    
    method estaDentroDelMarco (nuevaPosicion) = !self.nivelActual().estaFueraDelMarco(nuevaPosicion)

    // Puntos y Mecanica del Juego

    // Muerte de personaje 
    
    method die (){ 
        self.murioPersonaje(true)       
        game.sound("S_muerte.mp3").play()
        game.addVisual(muerteCartel)
        nivelActual.cleanVisuals()
        game.sound("S_game_over.mp3").play()
        game.schedule(3000,{game.removeVisual(muerteCartel)})
        game.schedule(3000, {nivelActual.restart()}) // Reiniciamos el nivel 
        game.schedule(3000, {self.murioPersonaje(false)}) // Reiniciamos el flag de muerte
    } 


    // Con Elementos

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

object fuego {}

object agua {}

object acido {}

object left {
    
    method calcularNuevaPosicion(character) = character.position().left(1)
    
    method puedeMoverse(character, nuevaPosicion)= character.estaDentroDelMarco(nuevaPosicion) && character.puedeDesplazarse(nuevaPosicion)

    method actualizarPosicion(character, nuevaPosicion){
        character.position().goLeft(1)
        character.oldPosition(new MutablePosition(x = character.position().x() + 1, y = character.position().y()))
    }
}

object right {
    
    method calcularNuevaPosicion(character) = character.position().right(1)

    method puedeMoverse(character, nuevaPosicion)= character.estaDentroDelMarco(nuevaPosicion) && character.puedeDesplazarse(nuevaPosicion)

    method actualizarPosicion(character, nuevaPosicion){
        character.position().goRight(1)
        character.oldPosition(new MutablePosition(x = character.position().x() - 1, y = character.position().y()))
    }
}

object up {
    
    method calcularNuevaPosicion(character) = character.position().up(1)

    method puedeMoverse(character, nuevaPosicion)= character.estaDentroDelMarco(nuevaPosicion) && character.puedeDesplazarse(nuevaPosicion)

    method actualizarPosicion(character, nuevaPosicion){
        character.position().goUp(1)
        character.oldPosition(new MutablePosition(x = character.position().x(), y = character.position().y() - 1))
    }
}

object down {
    
    method puedeMoverse(character, nuevaPosicion) = true

    method calcularNuevaPosicion(character) = character.position().down(1)
    
    method actualizarPosicion(character, nuevaPosicion) {

        if (character.nivelActual().esZonaProhibida(self, nuevaPosicion) && character.nivelActual().todosVivos()) {
          
            character.die()
        }
        else if(character.estaDentroDelMarco(nuevaPosicion) && character.puedeAtravesar(nuevaPosicion)){
       
            character.position().goDown(1)
            character.oldPosition(new MutablePosition(x = character.position().x(), y = character.position().y() + 1))
        }
        else{

        // SETEAMOS FLAG SALTANDO = FALSE (para evitar doble salto)
            character.jumping(false)
        }


    }

}