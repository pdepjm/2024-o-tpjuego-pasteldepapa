import characters.*
import elements.*
import level_1.*
import level_2.*

object settings {

    // ---------------------- Referencias
    const niveles = [level1, level2] 
    var property nivelActual = 0 // Índice del nivel actual
    const fondoNuevo = new BackgroundCover()

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

        const proxNivel = nivelActual + 1
        //if (proxNivel < niveles.size()) { // Avanza al siguiente nivel

            game.addVisual(nivelSuperado)
            game.sound("S_nivel_pasado.mp3").play()
            game.schedule(2000,{game.removeVisual(nivelSuperado)})

            game.schedule(2000,{niveles.get(nivelActual).cleanVisuals()})
            game.schedule(2000,{game.addVisual(fondoNuevo)})

        // CAMBIAR AL FONDO DE NIVEL 2
        nivelActual +=1
        //Llamamos al nivel 2 (ahora puesto para testear, dps implementar generico)
        level2.setupMechanicsInit()
        game.schedule(2500,{level2.start()}) 

           // niveles.get(nivelActual).start()
            //self.checkLevelCompletion(niveles.get(nivelActual)) 
        
        //} /*else { // Todos los niveles completados  
            
            // game.showMessage("¡Has completado todos los niveles!")

         //   game.clear()
            
        //}*/
    }
}

class Level {

    // ---------------- JUEGO PRINCIPAL
    method image()
    method position() = game.origin()

    const marcoJuego = []
    const charcos = []
    
    // Personajes 

    //Metodo sobrescrito en cada nivel con sus valores correspondientes

    method positionF()
    method positionW()
    method nivelActual()

    const fireboy = new Fireboy(position = self.positionF(), 
        oldPosition = self.positionF(),
        nivelActual = self.nivelActual()) 

    const watergirl = new Watergirl(
        position = self.positionW(), 
        oldPosition = self.positionW(),
        nivelActual = self.nivelActual()) 



    method start() {
        self.setupMarco()
        self.setupDiamonds()
        self.setupCharacters()
        self.setupCharcos()
        self.setupElements()  // Bloques, palancas, plataformas, etc.
    }
    
    method estaFueraDelMarco(posicion) = marcoJuego.any({zona => zona.posicionProhibida(posicion)}) 

    method esZonaProhibida(personaje, nuevaPosicion) = charcos.any({charco => charco.posicionProhibida(nuevaPosicion) && !charco.mismoTipo(personaje)})


    //Mecánica de Personajes

    method setupCharacters() {
        //Seteamos la posicion para que vuelvan a su posicion inicial después de reiniciar el nivel
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
    
    method setupDiamonds() {}
    method setupElements () {}
    method setupCharcos() {}
    method cleanVisuals() {}
    method setupMarco () {} // Marco de Juego
}




//object level3 inherits Level {} // DEJENLO, NO LO SAQUEN

object puntajes{
    method position() = game.center()
    // method image() = "puntajes.jpeg"
}

object muerte{
    const posX = 6
    const posY = 6

    method position() = game.at(posX, posY)
    method image() = "F_Game_over.png"
}

object nivelSuperado{
    const posX = 6
    const posY = 6

    method position() = game.at(posX, posY)
    method image() = "F_Nivel_Superado.png"
    method text1()  {Fireboy.puntaje()}
    method text2()  {Watergirl.puntaje()}
}

//Fin de juego 

object finJuego{

    method position() = game.origin()

    method image () = "F_Fin_De_Juego.png"
}

//Manejo de Zonas y Charcos
class Zona {

    const xMin
    const xMax
    const yMin
    const yMax

    method posicionProhibida (posicion) = posicion.x().between(xMin, xMax) && posicion.y().between(yMin, yMax)
}

class Charco inherits Zona {
    const tipo

    method mismoTipo (personaje) = personaje.tipo() == tipo
}