import characters.*
import config.*


// ------------------ Diamantes

class Diamante {

    const posX
    const posY
    
    method tipo() = "" 

    method esAtravesable() = true
    method esColisionable () = true

    method position() = game.at(posX,posY)

    // Métodos Sobrescritos en las Subclases

   

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido 
            game.removeVisual(self) 
            game.sound("S_diamante.mp3").play()
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) = personaje.tipo() == self.tipo()
 method image() {
        return "" 
    }
}

class DiamanteRojo inherits Diamante {
    
    override method tipo() = fuego
    override method image() {
        return "E_f_diamond.png" 
    }

}

class DiamanteAzul inherits Diamante {

    override method tipo() = agua
    override method image() {
        return "E_w_diamond.png" 
    }

}

class DiamanteGris inherits Diamante {
    override method image() {
        return "E_g_diamond.png" 
    }

    override method canCollect(character) {
        return true // Puede ser recogido por todos
    }
}

// ------------------ Puerta

class Puerta {
    const posX
    const posY

    method position() = game.at(posX, posY)
    method esAtravesable () = true
    method esColisionable() = false 

}

// ------------------ Caja

class Caja {
    var property position

    method image() = "E_cube.png"

    method esAtravesable() = false
    method esColisionable() = true

    method colision (personaje){
        if(personaje.oldPosition().x() > self.position().x() && position.left(1).x().between(6, 18)){
            position = self.position().left(1)
        }
        else if (personaje.oldPosition().x() < self.position().x() && position.right(1).x().between(6, 18)) {
            position = self.position().right(1)
        }
    }
}

// ------------------ Boton para Plataforma

class BotonInvisible {

    const posX
    const posY
    const botonAsoc

    method esAtravesable() = true
    method esColisionable() = true

    method position() = game.at(posX, posY)

    method colision(personaje) {
        botonAsoc.personajeMovido(personaje)
    }

}


class Boton {

    const posX
    const posY
    const plataformaAsoc


    method esAtravesable() = false
    method esColisionable() = true

    method position() = game.at(posX, posY)

    method colision(personaje){
        if(personaje.position() == self.position()) {
            if(self.hastaMaxAltura()) {
                plataformaAsoc.moveUp()
                game.schedule(100, {self.colision(personaje)})
            }
    }
    }

    method personajeMovido(personaje) {
        
        if(personaje.position() != self.position()) {
            if(self.hastaMinAltura()) {
                plataformaAsoc.moveDown()
                game.schedule(100, {self.personajeMovido(personaje)})
            }
        }
    }
    
    method image() = "E_cube.png"

    method hastaMaxAltura() = plataformaAsoc.position().y() != plataformaAsoc.maxAltura()
    method hastaMinAltura() = plataformaAsoc.position().y() != plataformaAsoc.minAltura()  
}

// ------------------ Plataforma Movible

class PlataformaMovible {

    const posX
    const posY
    const maxAltura
    const minAltura
    const position = new MutablePosition(x=posX, y=posY)
    const unidadMovimiento = 1
    
    method maxAltura() = maxAltura
    method minAltura() = minAltura

    method position() = position

    method colision(personaje) {}

    method esAtravesable() = false
    method esColisionable() = true

    method moveUp() {
        position.goUp(unidadMovimiento)
    }

    method moveDown() {
        position.goDown(unidadMovimiento)
    }

    method image() = "E_horizontal_gate.png"

}

/*

// ------------------ Plataformas 

class Platform {
    var positionX
    var positionY

    constructor(x, y) {
        positionX = x
        positionY = y
    }

    method support(character) {
        // Mantiene al personaje en la plataforma
        if (character.position.y <= positionY) {
            character.position.goTo(positionX, positionY); // Coloca al personaje en la plataforma
        }
    }
}*/

