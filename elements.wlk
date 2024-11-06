import characters.*
import config.*
import level_1.*
import level_2.*
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

    method position() = game.at(posX,posY)

    method colision(personaje) {
        
        if (self.canCollect(personaje)) { // Personaje puede recogerlo y todavia no fue recogido
            game.removeVisual(self) 
            game.sound("S_diamante.mp3").play()
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
    var personaParaPuerta = null

    method position() = game.at(posX, posY)
    method esAtravesable () = true

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

    method otrasPuertas(puertas) {
        otrasPuertas = puertas
    }

    method otraPuertaOcupada() = otrasPuertas.any { x => x.personaEnPuerta()}

    method personaEnPuerta() = personaEnPuerta && self.mismaPosicion(personaParaPuerta)

    method mismoTipo(personaje) = personaje.tipo() == tipo

    method mismaPosicion(personaje) = personaje.position() == self.position()

    method colision(x) {}
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

class Boton {

    const posX
    const posY
    const plataformaAsoc
    var botonAsoc = null
    var presionado = false


    method esAtravesable() = false

    method position() = game.at(posX, posY)

    method setupCollisions() {
        game.whenCollideDo(self, {x => x.colisionEspecial(self)}) 
    }

    method colisionEspecial(personaje) {
        if(plataformaAsoc.hastaMaxPosicion()) {
            plataformaAsoc.move()
        }

        presionado = true
        self.personajeMovido(personaje)
    }

    method personajeMovido(personaje) {
        if(!self.mismaPosicion(personaje)) {
            
            presionado = false

            if(!botonAsoc.presionado()) {
                if(plataformaAsoc.hastaMinPosicion()) {
                plataformaAsoc.moveBack()
                game.schedule(300, {self.personajeMovido(personaje)})
                } 
            }

        } else 
            game.schedule(300, {self.personajeMovido(personaje)})
    }

    method mismaPosicion(obj) = obj.position() == self.position()
    
    method image() = "E_buttonn.png"

    method presionado() = presionado

    method botonAsoc(nuevoBoton) {
        botonAsoc = nuevoBoton
    }

    method colision(obj) {} 
}

// ------------------ Plataforma Movible

class PlataformaBase {

    const position
    const unidadMovimiento = 1
    var personajeAdherido = null

    // ---------------------- Metodos

    // Basicos
    
    method esAtravesable() = false
    method position() = position

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

    // Los dejo así porque la clase no tiene que ser abstracta

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

    override method moveUp() {
        super()
        platAsocs.forEach { x => x.moveUp()} 
    }

    override method moveDown() {
        super()
        platAsocs.forEach { x => x.moveDown()} 
    }

    override method move() {self.moveUp()}
    override method moveBack() {self.moveDown()}

}

class PlataformaMoviHorizontal inherits PlataformaBase {

    const maxDistancia
    const minDistancia
    const platAsocs

    override method hastaMinPosicion() = self.position().x() != minDistancia
    override method hastaMaxPosicion() = self.position().x() != maxDistancia 

    override method moveRight() {
        super()
        platAsocs.forEach { x => x.moveRight()} 
    }

    override method moveLeft() {
        super()
        platAsocs.forEach { x => x.moveLeft()} 
    }

    method image() = "E_horizontal_gate_long.png"

    override method move() {self.moveLeft()}
    override method moveBack() {self.moveRight()}

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

    method posicionProhibida (posicion) = posicion.x().between(xMin, xMax) && posicion.y().between(yMin, yMax)
}

// ------------------ Charco

class Charco inherits Zona {
    const tipo

    method mismoTipo (personaje) = personaje.tipo() == tipo
}



















//////////////////////////// ELIN

/*


//////////// ELIN SIN MODIFICAR


















//////////// CHICOS MODIFICADO


// ------------------ Boton para Plataforma

class Boton {

    const posX
    const posY
    const plataformaAsoc
    var botonAsoc = null
    var presionado = false


    const movimiento
    const vuelta

    method esAtravesable() = true

    method position() = game.at(posX, posY)

    method setupCollisions() {
        game.whenCollideDo(self, {x => x.colisionEspecial(self)}) 
    }

    method colisionEspecial(personaje) {
        if(self.hastaMaxPosicion()) {
            plataformaAsoc.move(movimiento)
    }

        presionado = true
        self.personajeMovido(personaje)
    }

    method personajeMovido(personaje) {
        if(!self.mismaPosicion(personaje)) {
            
            presionado = false

            if(!botonAsoc.presionado()) {
                if(self.hastaMinPosicion()) {
                plataformaAsoc.moveBack(vuelta)
                game.schedule(300, {self.personajeMovido(personaje)})
                } 
            }

        } else 
            game.schedule(300, {self.personajeMovido(personaje)})
    }

    method mismaPosicion(obj) = obj.position() == self.position()
    
    method image() = "E_buttonn.png"

    method presionado() = presionado

    method botonAsoc(nuevoBoton) {
        botonAsoc = nuevoBoton
    }

    method hastaMaxPosicion() = plataformaAsoc.position().y() != plataformaAsoc.maxPosicion()
    method hastaMinPosicion() = plataformaAsoc.position().y() != plataformaAsoc.minPosicion() 

    method colision(obj) {} 
}

// ------------------ Plataforma Movible

class PlataformaBase {

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

    method move(movimiento) {
        if(movimiento == "up"){
        self.position().goUp(unidadMovimiento)}
        else{
           self.position().goLeft(unidadMovimiento)}
        self.moverPersonajeAdherido()
    }

    method moveBack(vuelta) {
        if(vuelta == "down"){
        self.position().goDown(unidadMovimiento)}
        else{
        self.position().goRight(unidadMovimiento)}
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

class PlataformaMovimientoVertical inherits PlataformaBase{
    const maxPosicion
    const minPosicion

    method maxPosicion() = maxPosicion
    method minPosicion() = minPosicion

    const platAsocs

    override method move(movimiento) {
        super(movimiento)
        platAsocs.forEach { x => x.move("up")} 
    }

    override method moveBack(movimiento) {
        super(movimiento)
        platAsocs.forEach { x => x.moveBack("down")} 
    }

    method image() = "E_horizontal_gate.png"
}

class PuertaMovimientoVertical inherits PlataformaMovimientoVertical{override method image() = "E_vertical_gate2.png"} //pueden agregarse mas en otros niveles

class PlataformaMovimientoHorizontal inherits PlataformaBase{
    const maxPosicion
    const minPosicion

    method maxPosicion() = maxPosicion
    method minPosicion() = minPosicion

    const platAsocs

    override method move(movimiento) {
        super(movimiento)
        platAsocs.forEach { x => x.move("Left")}
    }

    override method moveBack(movimiento) {
        super(movimiento)
        platAsocs.forEach { x => x.moveBack("Right")} 
    }

    method image() = "E_horizontal_gate_long.png"
}

*/