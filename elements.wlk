import characters.*
import config.*


// ------------------ Diamantes

class Diamante {

    // ---------------- Referencias

    const posX
    const posY
    var fuiRecolectado = false
    
    // ---------------- Métodos

    // Metodos Sobrescritos en las Subclases

    method tipo() = "" 

    method image() {
        return "" 
    }

    // Métodos Propios

    method esAtravesable() = true

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido
            fuiRecolectado = true 
            game.removeVisual(self) 
            game.sound("S_diamante.mp3").play()
            // efecto visual, sonido, palabritas
        }
    }

    method fuiRecolectado() = fuiRecolectado

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

    method position() = game.at(posX, posY)

    method colision(personaje){
        if(personaje.position() == self.position()) {
            if(self.hastaMaxAltura()) {
                plataformaAsoc.moveUp()
                game.schedule(300, {self.colision(personaje)})
            }
        }
    }

    method personajeMovido(personaje) {
        
        if(personaje.position() != self.position()) {
            if(self.hastaMinAltura()) {
                plataformaAsoc.moveDown()
                game.schedule(300, {self.personajeMovido(personaje)})
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

    var personajeAdherido = null
    
    method maxAltura() = maxAltura
    method minAltura() = minAltura

    method position() = position

    method colision(personaje) {
        personaje.desactivarGravedad()
        personaje.moverALaPar(self)
        personajeAdherido = personaje
    }

    method esAtravesable() = false
    
    method moveUp() {
        position.goUp(unidadMovimiento)
        platAsocs.forEach { x => x.moveUp()}
        self.moverPersonajeAdherido()
    }

    method moveDown() {
        position.goDown(unidadMovimiento)
        platAsocs.forEach { x => x.moveDown()}
        self.moverPersonajeAdherido()
    }

    method image() = "E_horizontal_gate.png"


    method moverPersonajeAdherido() {
        if (personajeAdherido != null) { 
            personajeAdherido.setPosition(personajeAdherido.position().x(), self.position().y() + 1)
        } else {
            self.detachCharacter()  // lo pusimos porque sino causa error
        }
    }
    method detachCharacter() {
        personajeAdherido = null
    }
}


class ExtensionPlataformaMovible {

    const position
    const unidadMovimiento = 1
    var personajeAdherido = null

    method esAtravesable() = false
    method colision(personaje) {
        personaje.desactivarGravedad()
        personaje.moverALaPar(self)
        personajeAdherido = personaje
    }

    method position() = position

    method moveUp() {
        self.position().goUp(unidadMovimiento)
        self.moverPersonajeAdherido()
    }

    method moveDown() {
        self.position().goDown(unidadMovimiento)
        self.moverPersonajeAdherido()
    }

    method moverPersonajeAdherido() {
        if (personajeAdherido != null) { 
            personajeAdherido.setPosition(personajeAdherido.position().x(), self.position().y() + 1)
        } else {
            self.detachCharacter()  // lo pusimos porque sino causa error
        }
    }
    method detachCharacter() {
        personajeAdherido = null
    }
}



// ------------------ Nuevo fondo
class BackgroundCover {
    const posX = 0
    const posY = 0

    method position() = game.at(posX, posY)
    method image() = "nivel_2.png"
}

// ------------------ Plataformas 


