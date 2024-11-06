import characters.*
import elements.*
import level_1.*
import level_2.*
import visualCarteles.*

object settings {

    // ---------------------- Métodos

    const cantNiveles = 2
    const niveles = [level1, level2]

    const property bordeJuego = [] //Guardamos todos los bordes

    var nivelActual = 0 

    var nivelesInicializados = false //Para saber si hay que hacer start o restart

    method init(title, boardground, height, width, cellSize){
        game.title(title)
        game.boardGround(boardground)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px 
        self.initLimitesJuego()
        game.start()
    }

    //Inicializamos los limites del juego al principio
    
    method initLimitesJuego (){
        bordeJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 0, yMax = 0   ))
        bordeJuego.add(new Zona (xMin = 0, xMax = 0, yMin = 1, yMax = 27   ))
        bordeJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 28, yMax = 28 ))
        bordeJuego.add(new Zona (xMin = 38, xMax = 38, yMin = 1, yMax = 27 ))
    }

    method pasarSgteNivel(){

        niveles.get(nivelActual).cleanVisuals()
        game.sound("S_nivel_pasado.mp3").play()
        nivelActual += 1
        if(nivelActual == cantNiveles){ //Si estamos en el ultimo nivel finalizamos el juego y volvemos al inicio
            self.finDeJuego()
        } else {
            game.addVisual(nivelSuperadoCartel)
            game.schedule(2000,{game.removeVisual(nivelSuperadoCartel)})
            game.schedule(2000,{game.removeVisual(niveles.get(nivelActual - 1))})
            game.schedule(2000, {self.startGame()})
        }
    }

    method finDeJuego () {
        nivelesInicializados = true //Una vez que finalizamos el juego, ya no hay que volver a crear todos los elementos, solo hacemos addVisual y removeVisual
        game.addVisual(finJuegoCartel)
        game.removeVisual(niveles.get(nivelActual - 1))
        game.schedule(4000, {game.removeVisual(finJuegoCartel)})
        nivelActual = 0 //empezamos los niveles de 0
    }

    method startGame(){
        if(!nivelesInicializados){
            niveles.get(nivelActual).start(bordeJuego)
        } else {
            game.addVisual(niveles.get(nivelActual))
            niveles.get(nivelActual).restart()
        }
    }
}


class Level {

    // ---------------------- Referencias

    const pisosJuego = [] // Zonas de cada nivel
    const charcos = [] // Lista de charcos de cada nivel
    const diamantes = [] // Diamantes   
    const elementosNivel = [] // Lista de elementos de cada nivel
    const bordeJuego = [] // Bordes del juego

    // Personajes 
    const fireboy = new Fireboy(position = self.positionF(), 
        oldPosition = self.positionF(),
        nivelActual = self.nivelActual()
    ) 

    const watergirl = new Watergirl(
        position = self.positionW(), 
        oldPosition = self.positionW(),
        nivelActual = self.nivelActual()
    ) 

    // ---------------------- Métodos 

    // Inicialización
    method start(bordesJuego) { //Pasamos la lista de bordes para chequear si esta dentro de los limites o no
        bordesJuego.forEach({zona => bordeJuego.add(zona)})
        game.addVisual(self.nivelActual())
        self.setupMechanicsInit()
        self.setupPisos()
        self.setupDiamonds()
        self.setupCharacters()
        self.setupCharcos()
        self.setupElements()  // Bloques, palancas, plataformas, etc.
    }
    
    method restart () {
        self.setupCharacters()
        elementosNivel.forEach({element => game.addVisual(element)})
        diamantes.forEach({x => game.addVisual(x)})
    }

    method position() = game.origin()

    // Control de si esta dentro del marco de juego

    method estaFueraDelMarco(posicion) = pisosJuego.any({zona => zona.posicionProhibida(posicion)}) || bordeJuego.any({zona => zona.posicionProhibida(posicion)}) 

    //Control de si esta en una zona prohibida

    method esZonaProhibida(personaje, nuevaPosicion) = charcos.any({charco => charco.posicionProhibida(nuevaPosicion) && !charco.mismoTipo(personaje)})

    method estaDentroDelMarco (nuevaPosicion) = !self.estaFueraDelMarco(nuevaPosicion)

    // Mecanica de los Personajes

    method setupCharacters() {
        // Volver a posicion inicial al resetear el nivel
        fireboy.setPosition(self.positionF().x(),self.positionF().y())
        watergirl.setPosition(self.positionW().x(),self.positionW().y())    
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

    method cleanVisuals(){
        diamantes.forEach({x => game.removeVisual(x)})
        elementosNivel.forEach({x=> game.removeVisual(x)})
    }

    //Para que no se pueda morir el otro personaje cuando ya se murio uno
    method todosVivos() = !fireboy.murioPersonaje() && !watergirl.murioPersonaje()
    
    // Métodos Sobrescritos en los Niveles
   
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