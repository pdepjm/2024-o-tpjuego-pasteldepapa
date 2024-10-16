import characters.*
import config.*


// ------------------ Diamantes

class Diamante {

    // ---------------- Referencias

    const posX
    const posY
    
    // ---------------- Métodos

    // Metodos Sobrescritos en las Subclases

    method tipo() = "" 

    method image() {
        return "" 
    }

    // Métodos Propios

    method esAtravesable() = true
    method esColisionable () = true

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido 
            game.removeVisual(self) 
            game.sound("S_diamante.mp3").play()
            // efecto visual, sonido, palabritas
            
        }
    }

    method canCollect(personaje) = personaje.tipo() == self.tipo()
    
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
    const tipo
    var otrasPuertas = []
    var personaEnPuerta = false

    method position() = game.at(posX, posY)
    method esAtravesable () = true
    method esColisionable() = false 

    method colision(personaje){
        if(self.mismoTipo(personaje)) {
            if(self.mismaPosicion(personaje) and self.otraPuertaOcupada()) {
                settings.pasarSgteNivel()
            } else if(personaje.position() == self.position()) {
                personaEnPuerta = true
                game.schedule(100, {self.colision(personaje)})
            } else {
                personaEnPuerta = false
            }
        }
    }

    method otrasPuertas(puertas) {
        otrasPuertas = puertas
    }

    method otraPuertaOcupada() = otrasPuertas.any { x => x.personaEnPuerta()}

    method mismoTipo(personaje) = personaje.tipo() == tipo

    method mismaPosicion(personaje) = personaje.position() == self.position()

    method personaEnPuerta() = personaEnPuerta
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
                game.schedule(200, {self.colision(personaje)})
            }
        }
    }

    method personajeMovido(personaje) {
        
        if(personaje.position() != self.position()) {
            if(self.hastaMinAltura()) {
                plataformaAsoc.moveDown()
                game.schedule(200, {self.personajeMovido(personaje)})
            }
        }
    }
    
    method image() = "E_buttonn.png"

    method hastaMaxAltura() = plataformaAsoc.position().y() != plataformaAsoc.maxAltura()
    method hastaMinAltura() = plataformaAsoc.position().y() != plataformaAsoc.minAltura()  
}

// ------------------ Plataforma Movible

class PlataformaMovible {

    const maxAltura
    const minAltura
    const position
    const unidadMovimiento = 1
    const platAsocs
    
    method maxAltura() = maxAltura
    method minAltura() = minAltura

    method position() = position

    method colision(personaje) {

    }

    method esAtravesable() = false
    method esColisionable() = true

    method moveUp() {
        position.goUp(unidadMovimiento)
        platAsocs.forEach { x => x.position().goUp(unidadMovimiento)}
    }

    method moveDown() {
        position.goDown(unidadMovimiento)
        platAsocs.forEach { x => x.position().goDown(unidadMovimiento)}
    }

    method image() = "E_horizontal_gate.png"

}


class ExtensionPlataformaMovible {

    const position

    method esAtravesable() = false
    method esColisionable() = true
    method colision(personaje) {}

    method position() = position
}



// ------------------ Nuevo fondo
class BackgroundCover {
    const posX = 0
    const posY = 0

    method position() = game.at(posX, posY)
    method image() = "nivel_2.png"
}

// ------------------ Plataformas 


