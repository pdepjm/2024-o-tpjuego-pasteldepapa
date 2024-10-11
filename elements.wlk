import characters.*

//Bordes (Objeto Invisible)

class Border {
    
    const posX
    const posY

    method esAtravesable() = false 

    method position() = game.at(posX,posY)
}

// ------------------ Diamantes

class Diamante {

    const posX
    const posY

    method tipo() = "" // redefinido en las subclases

    method esAtravesable() = true

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido 
            game.removeVisual(self) 
            game.sound("diamante.mp3").play()
            game.addVisual(puntajes) // Agrega el objeto puntajes al juego para que se muestre en pantalla
            game.schedule(5000,{game.removeVisual(puntajes)})
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) = personaje.tipo() == self.tipo()

    method image() {
        return "" // Sobrescrito en las subclase
    }
}

object puntajes{
    method position() = game.center()
    method image() = "puntajes.jpeg"
    method text() = "hola"
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

/*
class DiamanteVerde inherits Diamante {
    override method image() {
        return "diamante_verde.png" 
    }

    override method canCollect(character) {
        return true // Puede ser recogido por todos
    }
}
*/



// ------------------- Puerta

class Puerta {
    const posX
    const posY
    const image
    const tipo
    
    method position() = game.at(posX, posY)

    method esAtravesable() = true  

    method image() = image

    method tipo() = tipo

    method colision() {

        /*
        game.showMessage("¡Nivel completado! Pasando al siguiente nivel...")
        game.wait(2)  // Esperar 2 segundos antes de pasar al siguiente nivel

        */
    }
}

//Caja

class Caja {

    const positionX
    const positionY
  
    var property position = new MutablePosition (x=positionX, y=positionY)

    const unidadMovimiento = 1

    method image() = "cube.png"
    
    method esAtravesable () = false

    method esColisionable() = true

    method colision (personaje){
        if(personaje.oldPositionX() > self.position().x()){
            position = self.position().left(1)
        }
        if (personaje.oldPositionX() <= self.position().x()) {
            position = self.position().right(1)
        }
    }

    method moveLeft() {
        const nuevaPosicion = position.left(unidadMovimiento)   
        if (self.puedeAtravesar(nuevaPosicion))
          position = position.goLeft(unidadMovimiento)
    }

    method moveRight() {
        const nuevaPosicion = position.right(unidadMovimiento)
        if (self.puedeAtravesar(nuevaPosicion))
            position.goRight(unidadMovimiento)
    }

    method puedeAtravesar(nuevaPosicion) =  game.getObjectsIn(nuevaPosicion).all{obj => obj.esAtravesable()}
}

/*

// ------------------ Obstaculos 

class Obstacle {
    var isFire = false
    var isWater = false
    var positionX
    var positionY

    constructor(x, y) {
        positionX = x
        positionY = y
    }

    method interact(character) {
        if (isFire && character.canTouchFire) {
            // El personaje puede atravesar el obstáculo de fuego
            return true; // Permite el paso
        } else if (isWater && character.canTouchWater) {
            // El personaje puede atravesar el obstáculo de agua
            return true; // Permite el paso
        } else {
            // El personaje pierde o sufre un efecto negativo
            character.position.goDown(2); // Ejemplo: hacer que el personaje caiga
            return false; // No permite el paso
        }
    }
}

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

