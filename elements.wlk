import characters.*

// ------------------ Diamantes

class Diamante {

    const posX
    const posY

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido 
            game.removeVisual(self) 
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) {
        // Sobrescrito en las subclases
        return false
    }

    method image() {
        return "" // Sobrescrito en las subclase
    }
}

class DiamanteRojo inherits Diamante {
    override method image() {
        return "diamante_rojo.png" 
    }

    override method canCollect(personaje) {
        return personaje.isFireboy() // Solo puede ser recogido por Fireboy
    }
}

class DiamanteAzul inherits Diamante {
    override method image() {
        return "diamante_azul.png" 
    }

    override method canCollect(personaje) {
        return !personaje.isFireboy() // Solo puede ser recogido por Watergirl
    }
}

class DiamanteVerde inherits Diamante {
    override method image() {
        return "diamante_verde.png" 
    }

    override method canCollect(character) {
        return true // Puede ser recogido por todos
    }
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

