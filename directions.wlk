import characters.*
import config.*
import visualCarteles.*


// -------------------------------- Direcciones

class Direction {
  const unidadMovimiento = 1
  
  method puedeMoverse(character, nuevaPosicion) = 
    character.estaDentroDelMarco(nuevaPosicion) && character.puedeDesplazarse(nuevaPosicion)
  
  method calcularNuevaPosicion(personaje)
  
  method actualizarPosicion(personaje, nuevaPosicion)
}

object left inherits Direction {
  override method calcularNuevaPosicion(character) = 
    character.position().left(unidadMovimiento)
  
  override method actualizarPosicion(character, _) {
    character.position().goLeft(unidadMovimiento)
  }
}

object right inherits Direction {
  override method calcularNuevaPosicion(character) = 
    character.position().right(unidadMovimiento)
  
  override method actualizarPosicion(character, _) {
    character.position().goRight(unidadMovimiento)
  }
}

object up inherits Direction {
  override method calcularNuevaPosicion(character) = 
    character.position().up(unidadMovimiento)
  
  override method actualizarPosicion(character, _) {
    character.position().goUp(unidadMovimiento)
  }
}

object downCharacter inherits Direction {
  override method puedeMoverse(character, nuevaPosicion) = true
  
  override method calcularNuevaPosicion(character) = 
    character.position().down(unidadMovimiento)
  
  override method actualizarPosicion(character, nuevaPosicion) {
    
    self.listaCharcos().anyOne().puedeMorirPersonaje(character, nuevaPosicion) //obtenemos un charco random ya que el control de si puede morir o no esta en el charco
      
    if (self.posicionValida(character, nuevaPosicion)) {
        character.position().goDown(unidadMovimiento)
    } else {
        character.jumping(false) // evitar doble salto 
    }

    return
  }
  
  method posicionValida(character, nuevaPosicion) = 
    character.estaDentroDelMarco(nuevaPosicion) && character.puedeAtravesar(nuevaPosicion)

  method listaCharcos() = settings.objNivelActual().charcos()
} 

object down inherits Direction {
    override method puedeMoverse(character, nuevaPosicion) = true
    
    override method calcularNuevaPosicion(character) = 
        character.position().down(unidadMovimiento)

    override method actualizarPosicion(character, _) {
        character.position().goDown(unidadMovimiento)
    }

}


