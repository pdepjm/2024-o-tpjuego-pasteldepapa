import characters.*

// ------------------ Diamantes

class Diamond {
    var isCollected = false

    const posX
    const posY

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje) && !isCollected) { // Personaje puede recogerlo y todavia no fue recogido 
            isCollected = true
            game.removeVisual(self) 
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(character) {
        // Sobrescrito en las subclases
        return false
    }

    method image() {
        return "" // Sobrescrito en las subclase
    }
}

class RedDiamond inherits Diamond {
    override method image() {
        return "diamante_rojo.png" 
    }

    override method canCollect(character) {
        return character.isFireboy() // Solo puede ser recogido por Fireboy
    }
}

class BlueDiamond inherits Diamond {
    override method image() {
        return "diamante_azul.png" 
    }

    override method canCollect(character) {
        return !character.isFireboy() // Solo puede ser recogido por Fireboy
    }
}

class GreenDiamond inherits Diamond {
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

