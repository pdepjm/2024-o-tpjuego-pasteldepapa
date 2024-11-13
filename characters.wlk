import config.*
import visualCarteles.*
import directions.*

// -------------------------------- Personajes
// ------------------ Superclase
class Character {
  // -------------------- Referencias

  // Particular para Instancias
  var property position 
  var property lastMovement

  // Generales
  var property murioPersonaje = false
  var property jumping = false
  var plataformaAdherida = null
  const unidadMovimiento = 1
  var property murioPersonajeTest = false 
  
  // -------------------- Métodos
  
  // Métodos Sobrescritos en las Subclases
  method image()
  
  method tipo()
  
  method setupControls()
  
  method eventoGravedad()

  // Generales
  
  method esColisionable() = false 
  
  method esAtravesable() = true
  
  method setPosition(charPos) {
    position = charPos
  }
  
  method colision(personaje) {} // Para que no genere error si colisionan entre personajes
  
  // Movimientos
  method move(direction) {
    self.plataformaDesadherida()
    
    const nuevaPosicion = direction.calcularNuevaPosicion(self)
    
    if (direction.puedeMoverse(self, nuevaPosicion))
      direction.actualizarPosicion(self, nuevaPosicion)
  }
  
  method jump() {
    self.plataformaDesadherida()
    const nuevaPosicion = position.down(unidadMovimiento)
    
    if (self.puedeSaltar(nuevaPosicion)) {
      self.desactivarGravedad()
      jumping = true
      [150, 300, 450, 600].forEach(
        { num => game.schedule(num, { self.move(up) }) }
      )
      game.schedule(800, { self.gravedad() })
    }
  }
  
  method puedeSaltar(nuevaPosicion) = 
    (!jumping) && 
    (settings.objNivelActual().estaFueraDelMarco(nuevaPosicion) || 
    (!self.puedeAtravesar(nuevaPosicion)))
  
  // Gravedad

  method gravedad() {
    game.onTick(250, self.eventoGravedad(), { self.move(downCharacter) })
  }
  
  method desactivarGravedad() {
    game.removeTickEvent(self.eventoGravedad())
  }
  
  // Colisiones
  method setupCollisions() {
    game.onCollideDo(self, { element => element.colision(self) })
  }
  
  // Control movimiento
  method puedeDesplazarse(nuevaPosicion) = 
    self.puedeAtravesar(nuevaPosicion) || self.puedeColisionar(nuevaPosicion)
  
  method puedeAtravesar(nuevaPosicion) = 
    game.getObjectsIn(nuevaPosicion).all({ obj => obj.esAtravesable() }
  )
  
  method puedeColisionar(nuevaPosicion) = 
    game.getObjectsIn(nuevaPosicion).all({ obj => obj.esColisionable() }
  )
  
  method estaDentroDelMarco(nuevaPosicion) = !settings.objNivelActual().estaFueraDelMarco(nuevaPosicion)
  
  // Muerte de personaje
  
  method die() {
    self.murioPersonajeTest(true)
    self.murioPersonaje(true)
    game.sound("S_muerte.mp3").play()
    game.addVisual(muerteCartel)
    settings.objNivelActual().cleanVisuals()
    game.sound("S_game_over.mp3").play()
    game.schedule(3000, { game.removeVisual(muerteCartel) })
    game.schedule(3000, { settings.objNivelActual().restart() }) // Reiniciamos el nivel 
    game.schedule(3000, { self.murioPersonaje(false) })
    // Reiniciamos el flag de muerte
  }
  
  // Mecanica con Plataforma
  
  method moverALaPar(plataforma) {
    plataformaAdherida = plataforma
  }
  
  method plataformaDesadherida() {
    if (plataformaAdherida != null) {
      plataformaAdherida.detachCharacter()
      plataformaAdherida = null
      self.gravedad()
    }
  }
  
  method colisionEspecial(objeto) {
    objeto.colisionEspecial(self)
  }
} // ------------------ Subclases

class Fireboy inherits Character {
  override method tipo() = fuego
  
  override method image() = "P_Fireboy.png"
  
  override method eventoGravedad() = "F_Gravedad"
  
  override method setupControls() {
    keyboard.left().onPressDo({ self.move(left) self.lastMovement(left)})
    keyboard.right().onPressDo({ self.move(right) self.lastMovement(right)})
    keyboard.up().onPressDo({ self.jump() })
  }
}

class Watergirl inherits Character {
  override method tipo() = agua
  
  override method image() = "P_Watergirl.png"
  
  override method setupControls() {
    keyboard.a().onPressDo({ self.move(left) self.lastMovement(left)})
    keyboard.d().onPressDo({ self.move(right) self.lastMovement(right)})
    keyboard.w().onPressDo({ self.jump() })
  }
  
  override method eventoGravedad() = "W_Gravedad"
} 

// -------------------------------- Tipos

object fuego {}

object agua {}

object acido {}