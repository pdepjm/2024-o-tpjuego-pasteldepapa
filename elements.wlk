import characters.*
import config.*
import visualCarteles.*


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
    method esColisionable() = false
    var property fuiRecolectado = false // para tests
    method position() = game.at(posX,posY) 
   
    method colision(personaje) {
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido
            game.removeVisual(self) 
            game.sound("S_diamante.mp3").play()
            self.fuiRecolectado(true) // para tests
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
    
    // ---------------- Referencias
    const posX
    const posY
    const tipo

    var otrasPuertas = []
    var personaEnPuerta = false
    var personaParaPuerta = null

    // ---------------- Metodos

    // Basicos

    method position() = game.at(posX, posY)
    method esAtravesable () = true
    method esColisionable() = false

    method otrasPuertas(puertas) {
        otrasPuertas = puertas
    }

    // Colisiones

    method setupCollisions() {
        game.whenCollideDo(self, {x => x.colisionEspecial(self)}) 
    }

    method colisionEspecial(personaje) {
        if(self.mismoTipo(personaje)) {
            
            personaEnPuerta = true
            personaParaPuerta = personaje

            if(self.otraPuertaOcupada())
                settings.pasarSgteNivel()
        }
    }

    // Auxiliares

    method otraPuertaOcupada() = otrasPuertas.any { x => x.personaEnPuerta()}

    method personaEnPuerta() = personaEnPuerta && self.mismaPosicion(personaParaPuerta)

    method mismoTipo(personaje) = personaje.tipo() == tipo

    method mismaPosicion(personaje) = personaje.position() == self.position()

    method colision(x) {} // para no generar error
}

// ------------------ Caja

class Caja {
    var property position
    const unidadMovimiento = 1

    method image() = "E_cube.png"

    method esAtravesable() = false
    method esColisionable() = true
    
    method colision (personaje){

        if(self.personajeADer(personaje)) {
            if(self.posicionValida(position.left(unidadMovimiento)))
                position = self.position().left(1)
        } else {
            if(self.posicionValida(position.right(unidadMovimiento)))
                position = self.position().right(1)
        }
    }

    method personajeADer(personaje) = personaje.oldPosition().x() > self.position().x()
    method posicionValida(posicion) = posicion.x().between(6, 18)
}

// ------------------ Boton para Plataforma

class Boton {

    // ---------------- Referencias
    const posX
    const posY
    const plataformaAsoc

    var botonAsoc = null
    var presionado = false

    // ---------------- Metodos

    // Basicos
    method esAtravesable() = true
    method esColisionable() = false
    
    method position() = game.at(posX, posY)
    method image() = "E_buttonn.png"

    // Accesors

    method presionado() = presionado

    method botonAsoc(nuevoBoton) {
        botonAsoc = nuevoBoton
    }

    // Colisiones
    method setupCollisions() {
        game.whenCollideDo(self, {x => x.colisionEspecial(self)}) 
    }

    method colisionEspecial(personaje) {
        if(plataformaAsoc.hastaMaxPosicion()) {
            plataformaAsoc.move()
        }

        presionado = true
        game.schedule(300, {self.personajeMovido(personaje)})
    }

    // Personaje ya no está en el boton

    method personajeMovido(personaje) {
        if(!self.mismaPosicion(personaje)) {
            
            presionado = false

            if(!botonAsoc.presionado()) {
                if(plataformaAsoc.hastaMinPosicion()) {
                plataformaAsoc.moveBack()
                game.schedule(300, {self.personajeMovido(personaje)})
                } 
            }

        } 
    }

    // Auxiliares

    method mismaPosicion(obj) = obj.position() == self.position()
    method colision(obj) {}  // Para que no cause error
}

// ------------------ Plataforma Movible

class PlataformaBase {

    const position
    const unidadMovimiento = 1
    var personajeAdherido = null

    // ---------------------- Metodos

    // Basicos
    
    method esAtravesable() = false
    method esColisionable() = false 
    method position() = position
    
    method personajeAdherido () = personajeAdherido

    // Colision
    
    method colision(personaje) {
        personaje.desactivarGravedad()
        personaje.moverALaPar(self)
        personajeAdherido = personaje
    }

    // Movimientos

    method moveUp() {
        self.position().goUp(unidadMovimiento)
        self.moverPersonajeAdherido()
    }

    method moveDown() {
        self.position().goDown(unidadMovimiento)
        self.moverPersonajeAdherido()
    }

    method moveRight() {
        self.position().goRight(unidadMovimiento)
        // agregar mover personaje adherido?
    }

    method moveLeft() {
        self.position().goLeft(unidadMovimiento)
    }

    // Personaje
    
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

    // Sobrescritos en las Subclases
    // (Los dejo con {}, porque no debe ser abstracta)

    method hastaMinPosicion() {}
    method hastaMaxPosicion() {}
    method move() {}
    method moveBack() {}
}

class PlataformaMoviVertical inherits PlataformaBase {

    const maxAltura
    const minAltura
    const platAsocs
    const image

    method image() = image

    override method hastaMinPosicion() = self.position().y() != minAltura 
    override method hastaMaxPosicion() = self.position().y() != maxAltura

    override method move() {self.moveUp()}
    override method moveBack() {self.moveDown()}   

    override method moveUp() {
        super()
        platAsocs.forEach { x => x.moveUp()} 
    }

    override method moveDown() {
        super()
        platAsocs.forEach { x => x.moveDown()} 
    }
}

class PlataformaMoviHorizontal inherits PlataformaBase {

    const maxDistancia
    const minDistancia
    const platAsocs

    method image() = "E_horizontal_gate_long.png"

    override method hastaMinPosicion() = self.position().x() != minDistancia
    override method hastaMaxPosicion() = self.position().x() != maxDistancia 

    override method move() {self.moveLeft()}
    override method moveBack() {self.moveRight()}

    override method moveRight() {
        super()
        platAsocs.forEach { x => x.moveRight()} 
    }

    override method moveLeft() {
        super()
        platAsocs.forEach { x => x.moveLeft()} 
    }
}

// ------------------ Nuevo fondo
class BackgroundCover {
    const posX = 0
    const posY = 0

    method position() = game.at(posX, posY)
    method image() = "nivel_2.png"
}

// ------------------ Zona
class Zona {

    const xMin
    const xMax
    const yMin
    const yMax

    method posicionProhibida (posicion) = 
        posicion.x().between(xMin, xMax) && posicion.y().between(yMin, yMax)
}

// ------------------ Charco

class Charco inherits Zona {
    const tipo
    method mismoTipo (personaje) = personaje.tipo() == tipo
}