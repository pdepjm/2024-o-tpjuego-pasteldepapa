import characters.*
import config.*


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
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) = personaje.tipo() == self.tipo()

    method image() {
        return "" // Sobrescrito en las subclase
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
    method esColisionable() = false //??

}

// ------------------ Caja

class Caja {
    var property position

    method image() = "cube.png"

    method esAtravesable() = false
    method esColisionable() = true

    method colision (personaje){
        console.println("Anterior X (CAJA): " + personaje.oldPosition().x())
        console.println("Actual X (CAJA): " + self.position().x())
        console.println("Anterior Y (CAJA): " + personaje.oldPosition().y())
        console.println("Actual Y (CAJA): " + self.position().y())
        //if (personaje.oldPosition().y() > self.position().y()) { return }
        
        if(personaje.oldPosition().x() > self.position().x() && position.left(1).x().between(6, 18)){
            position = self.position().left(1)
        }
        else if (personaje.oldPosition().x() < self.position().x() && position.right(1).x().between(6, 18)) {
            position = self.position().right(1)
        }
    }
}

// ------------------ Charco

class Charco {
    
    const tipo
    const posX
    const posY

    method position() = game.at(posX, posY)

    method esAtravesable () = false
    
    method colision(personaje){
        if(tipo.personaje() != tipo){
            personaje.die()
        }
    }
}

// ------------------ Boton para Plataforma

/*
class Boton {

    const posX
    const posY
    const plataforma

    method position() = game.at(posX, posY)

    method colision(personaje){
        while(self.posicionIgual(personaje) and self.hastaMaxAltura()) {
            plataforma.goUp(1)
        }
        
    }

    method posicionIgual(x) = x.position() == self.position()

    method hastaMaxAltura() = plataforma.position() != plataforma.maxAltura()

}

*/

// ------------------ Plataforma Movible

/*

class PlataformaMovible {

    const posX
    const posY

    method position() = game.at(posX, posY)

    method colision(personaje) {}

    method esAtravesable() = false



  
    position.goUp(unidadMovimiento)
    position.goDown(unidadMovimiento)

    game.schedule(1000, {self.fall()})
    game.schedule(500, {self.fall()})

    method jump() {
        game.removeTickEvent("Gravedad")
        [100, 200, 300, 400].forEach { num => game.schedule(num, { self.moveUp() }) }        
        game.schedule(400, {game.onTick(100, "Gravedad", {self.moveDown()} )})
    }



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

