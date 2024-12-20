import characters.*
import elements.*
import level_1.*
import level_2.*
import visualCarteles.*
import directions.*


////////////////////////////////// CONFIGURACION GENERAL

object settings {

    // ---------------------- Referencias

    const niveles = [level1, level2]
    const cantNiveles = niveles.size()
    var nivelActual = 0 
    var objNivelActual = niveles.get(nivelActual)
    var nivelesInicializados = false //Para saber si hay que hacer start o restart

    const property bordeJuego = [] // Guardamos todos los bordes

    method objNivelActual () = objNivelActual
    // ---------------------- Métodos

    // Inicialización
    method init(title, boardground, height, width, cellSize){
        game.title(title)
        game.boardGround(boardground)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px 
        self.initLimitesJuego()
        game.start()
    }

    method initLimitesJuego (){
        bordeJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 0, yMax = 0   ))
        bordeJuego.add(new Zona (xMin = 0, xMax = 0, yMin = 1, yMax = 27   ))
        bordeJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 28, yMax = 28 ))
        bordeJuego.add(new Zona (xMin = 38, xMax = 38, yMin = 1, yMax = 27 ))
    }

    // Iniciar Juego, Pasar de Nivel, Fin del juego

    method startGame(){
        if(!nivelesInicializados){
            niveles.get(nivelActual).start(bordeJuego)
        } else {
            game.addVisual(niveles.get(nivelActual))
            niveles.get(nivelActual).restart()
        }
    }

    method pasarSgteNivel(){

        niveles.get(nivelActual).cleanVisuals()
        game.sound("S_nivel_pasado.mp3").play()
        nivelActual += 1
        if(nivelActual == cantNiveles){ // Estamos en el ultimo nivel
            self.finDeJuego()
        } else {
            game.addVisual(nivelSuperadoCartel)
            game.schedule(2000,{game.removeVisual(nivelSuperadoCartel)})
            game.schedule(2000,{game.removeVisual(niveles.get(nivelActual - 1))})
            game.schedule(2000, {objNivelActual = niveles.get(nivelActual)})
            game.schedule(2000, {self.startGame()})
        }

    }

    method finDeJuego () {
        nivelesInicializados = true // Con juego finalizado, no se vuelven a crear todos los elems
        game.addVisual(finJuegoCartel)
        game.removeVisual(niveles.get(nivelActual - 1))
        game.schedule(4000, {game.removeVisual(finJuegoCartel)})
        nivelActual = 0 //empezamos los niveles de 0
        objNivelActual = niveles.get(nivelActual)
    }
}

////////////////////////////////// LOGICA DE NIVELES

class Level {

    // ---------------------- Referencias

    const pisosJuego = [] // Zonas de cada nivel
    const property charcos = [] // Lista de charcos de cada nivel
    const diamantes = [] // Diamantes   
    const elementosNivel = [] // Lista de elementos de cada nivel
    const bordeJuego = [] // Bordes del juego

    const movePlatMoviVertical = up
    const moveBackPlatMoviVertical = down
    const movePlatMoviHorizontal = left
    const moveBackPlatMoviHorizontal = right
    const imagePlatVertical = "E_vertical_gate2.png"
    const imagePlatHorizontal = "E_horizontal_gate.png"
    const imagePlatHorizontalLong = "E_horizontal_gate_long.png"

    // Personajes 
    const fireboy = new Fireboy(
        position = self.positionF(), 
        lastMovement = null
    ) 

    const watergirl = new Watergirl(
        position = self.positionW(), 
        lastMovement = null
    ) 

    // ---------------------- Métodos 

    method position() = game.origin()

    // --- Inicialización
    method start(bordesJuego) { // Pasamos la lista de bordes para chequear si esta dentro de los limites o no
        bordesJuego.forEach({zona => bordeJuego.add(zona)})
        game.addVisual(self.nivelActual())
        self.setupMechanicsInit()
        self.setupPisos()
        self.setupDiamonds()
       // self.setupCharacters()
        self.setupCharcos()
        self.setupElements()  // Bloques, palancas, plataformas, etc.
    }
    
    method restart () {
        self.setupCharacters()
        elementosNivel.forEach({element => game.addVisual(element)})
        diamantes.forEach({x => game.addVisual(x)})
    }

    // --- Controles
    
    method estaFueraDelMarco(posicion) = 
        pisosJuego.any({zona => zona.posicionProhibida(posicion)}) 
        || bordeJuego.any({zona => zona.posicionProhibida(posicion)}) 

    method estaDentroDelMarco (nuevaPosicion) = !self.estaFueraDelMarco(nuevaPosicion)

    method esZonaProhibida(personaje, nuevaPosicion) = 
        charcos.any({charco => charco.posicionProhibida(nuevaPosicion) && !charco.mismoTipo(personaje)})

    // --- Mecanica de los Personajes

    method setupCharacters() {
        // Volver a posicion inicial al resetear el nivel
        fireboy.setPosition(self.positionF())
        watergirl.setPosition(self.positionW())    
    }

    method setupMechanicsInit(){
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
    }

    method setupMechanics(personaje){
        personaje.gravedad()
        personaje.setupControls()
        personaje.setupCollisions()
    }

    method todosVivos() = !fireboy.murioPersonaje() && !watergirl.murioPersonaje() // Si uno se murio, es suficiente

    // --- Limpiar Visuales

    method cleanVisuals(){
        diamantes.forEach({x => game.removeVisual(x)})
        elementosNivel.forEach({x=> game.removeVisual(x)})
    }

    // --- Sobrescritos en los Niveles
   
    method setupElements ()  
    method setupDiamonds() 
    method setupCharcos()
    method setupPisos() 
    method positionF()
    method positionW()
    method nivelActual()
    method image()
    method agregarElementosNivel()
}