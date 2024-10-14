import characters.*
import config.*


// ------------------ Diamantes

class Diamante {

    const posX
    const posY

    method tipo() = "" // redefinido en las subclases

    method esAtravesable() = true
    method esColisionable () = true

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido 
            game.removeVisual(self) 
            game.sound("diamante.mp3").play()
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) = personaje.tipo() == self.tipo()

    // Métodos Sobrescritos en las Subclases

    // method tipo() = "" 

    method image() {
        return "" 
    }
}

class DiamanteRojo inherits Diamante {
    
    override method tipo() = fuego
    override method image() {
        return "f_diamond.png" 
    }

}

class DiamanteAzul inherits Diamante {

    override method tipo() = agua
    override method image() {
        return "w_diamond.png" 
    }

}

class DiamanteGris inherits Diamante {
    override method image() {
        return "g_diamond.png" 
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

    method image() = "cube.png"

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

/*
class Boton {

    const posX
    const posY
    const plataformaAsoc
    const unidadMovimiento = 1

    method position() = game.at(posX, posY)

    method colision(personaje){
        if(self.hastaMaxAltura()) 
            plataformaAsoc.goUp(unidadMovimiento)    
    }

    method image() = "button.png"

    method hastaMaxAltura() = plataforma.position().y() != plataforma.maxAltura()

}

*/

// ------------------ Plataforma Movible

/*

class PlataformaMovible {

    const posX
    const posY
    const maxAltura

    method maxAltura() = maxAltura

    method position() = game.at(posX, posY)

    method colision(personaje) {}

    method esAtravesable() = false

    method image() = "horizontal_gate.png"



  



}


*/

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

