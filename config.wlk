import characters.*
import elements.*
import level_1.*
import level_2.*
import visualCarteles.*

object settings {

    // ---------------------- Métodos

    method init(title, boardground, height, width, cellSize){
        game.title(title)
        game.boardGround(boardground)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px
        game.start()
    }

    method pasarSgteNivel(){
        game.addVisual(nivelSuperadoCartel)
        game.sound("S_nivel_pasado.mp3").play()
        game.schedule(2000,{game.removeVisual(nivelSuperadoCartel)})
        game.schedule(2000,{level1.cleanVisuals()})
        game.schedule(3000,{level2.setupMechanicsInit()})
        game.schedule(3500,{level2.start()}) 
    }
}

class Level {

    // ---------------------- Referencias

    const marcoJuego = []
    const charcos = []

    // Personajes 

    const fireboy = new Fireboy(position = self.positionF(), 
        oldPosition = self.positionF(),
        nivelActual = self.nivelActual()) 

    const watergirl = new Watergirl(
        position = self.positionW(), 
        oldPosition = self.positionW(),
        nivelActual = self.nivelActual()) 

    // ---------------------- Métodos 

    // Inicialización

    method start() {
        self.setupMarco()
        self.setupDiamonds()
        self.setupCharacters()
        self.setupCharcos()
        self.setupElements()  // Bloques, palancas, plataformas, etc.
    }

    method position() = game.origin()

    // Marco y Charco

    method estaFueraDelMarco(posicion) = marcoJuego.any({zona => zona.posicionProhibida(posicion)}) 

    method esZonaProhibida(personaje, nuevaPosicion) = charcos.any({charco => charco.posicionProhibida(nuevaPosicion) && !charco.mismoTipo(personaje)})

    // Mecanica de los Personajes

    method setupCharacters() {
        // Volver a posicion inicial al resetear el nivel
        fireboy.setPosition(self.positionF().x(),self.positionF().y())
        watergirl.setPosition(self.positionW().x(),self.positionW().y())    
    }

    method setupMechanicsInit(){
        game.addVisual(self.nivelActual())
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
    }

    method setupMechanics(personaje){
        personaje.gravedad()
        personaje.setupControls()
        personaje.setupCollisions()
    }

    // Métodos Sobrescritos en los Niveles
    
    method setupDiamonds() 
    method setupElements ()
    method setupCharcos()
    method cleanVisuals()
    method setupMarco () 
    method positionF()
    method positionW()
    method nivelActual()
    method image()

}