import characters.*
import elements.*

object settings {

    // ---------------------- Referencias
    const niveles = [level1, level2] 
    var nivelActual = 0 // Índice del nivel actual

    // ---------------------- Métodos

    method init (background, height, width, cellSize){
        game.title("FireBoyWaterGirlGame")
        game.boardGround(background)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px
        game.start()
    }
    
    method checkLevelCompletion(level) { 
        game.schedule(100, {
            if(level.isLevelComplete()) { 
                //game.addVisual(nivelSuperado)
                //game.schedule(5000,{game.removeVisual(nivelSuperado)})
                game.schedule(5000,{self.pasarSgteNivel()}) // Pasa de nivel despues de mostrar puntajes
            } else {
                self.checkLevelCompletion(level) // Verifica hasta que el nivel se termine
            }
        })
    }



    method pasarSgteNivel(){
        nivelActual += 1
        if (nivelActual < niveles.size()) { // Avanza al siguiente nivel

            game.clear()  // Eliminar elementos visuales del nivel actual  
            game.addVisual(nivelSuperado)
            game.addVisual("S_nivel_pasado.mp3")
            game.schedule(5000,{game.removeVisual(nivelSuperado)})

            niveles.get(nivelActual).start()
            self.checkLevelCompletion(niveles.get(nivelActual)) 
        
        } /*else { // Todos los niveles completados  
            
            // game.showMessage("¡Has completado todos los niveles!")

            game.clear()
            
        }*/
    }
}

class Level {

    // ---------------- JUEGO PRINCIPAL

    method start() {
        //game.clear()
        self.setupElements()  // Bloques, palancas, plataformas, etc.
        self.setupDiamonds()
        self.setupCharacters()
        self.setupCharcos()
        self.setupBorders()
        self.setupPositions()
        //game.start()
    }
    
    // Marco de juego

    const positions = [] // Guardar las coordenadas que no puede atravesar
    
    method setupBorders(){
        (0..38).forEach     { x => positions.add([x, 0])    }
        (0..38).forEach     { x => positions.add([x, 28])   }
        (0..28).forEach     { y => positions.add([0, y])    }
        (0..28).forEach     { y => positions.add([38, y])   }
    }

    // Métodos Sobrescritos en los Niveles
    
    method setupPositions(){}
    method setupDiamonds() {}
    method setupElements () {}
    method setupCharcos() {}
    method isLevelComplete() {}
    method setupCharacters() {}
}


object level1 inherits Level {
    
    // --------------------- Referencias
    
    // Personajes 

    const fireboy = new Fireboy(position = new MutablePosition (x=16, y=18), oldPosition = new MutablePosition (x=16, y=18), nivelActual = self, zonasProhibidas = zonasProhibidasFuego, invalidPositions = positions) //Depende del nivel
    const watergirl = new Watergirl(position = new MutablePosition (x=24, y=1), oldPosition  = new MutablePosition (x=24, y=1), nivelActual = self, zonasProhibidas = zonasProhibidasAgua, invalidPositions = positions) //Depende del nivel
    
    // Lista de Posiciones prohibidas y diamantes

    const zonasProhibidasFuego = []
    const zonasProhibidasAgua = []
    const diamantes = []

    // Elementos
    const puertaFireboy = new Puerta(posX = 30, posY = 22)
    const puertaWatergirl = new Puerta(posX = 34, posY = 22)

    const plataformaAmarilla = new PlataformaMovible(posX = 1, posY = 9, maxAltura = 13, minAltura = 9)
    const botonAmarillo = new Boton(posX = 10, posY = 9, plataformaAsoc = plataformaAmarilla)

    const botonInvAmarillo1 = new BotonInvisible(posX = 11, posY = 9, botonAsoc = botonAmarillo)
    const botonInvAmarillo2 = new BotonInvisible(posX = 9, posY = 9, botonAsoc = botonAmarillo)


    const plataformaBordo = new PlataformaMovible(posX = 34, posY = 13, maxAltura = 16, minAltura = 13)
    const botonBordoA = new Boton(posX = 13, posY = 14, plataformaAsoc = plataformaBordo)
    const botonBordoB = new Boton(posX = 30, posY = 18, plataformaAsoc = plataformaBordo)

    const botonInvBordoA1 = new BotonInvisible(posX = 14, posY = 14, botonAsoc = botonBordoA)
    const botonInvBordoA2 = new BotonInvisible(posX = 12, posY = 14, botonAsoc = botonBordoA)
    const botonInvBordoB1 = new BotonInvisible(posX = 31, posY = 18, botonAsoc = botonBordoB)
    const botonInvBordoB2 = new BotonInvisible(posX = 29, posY = 18, botonAsoc = botonBordoB)

    // --------------------- Métodos

    // Métodos Sobrescritos
    
    override method setupCharacters() {
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
        fireboy.setPosition(16,18)
        watergirl.setPosition(24,1) 
    }

    override method setupDiamonds() {
        diamantes.add(new DiamanteRojo(posX = 28, posY = 3))
        diamantes.add(new DiamanteRojo(posX = 9, posY = 14))
        diamantes.add(new DiamanteRojo(posX = 10, posY = 25))
        diamantes.add(new DiamanteRojo(posX = 22, posY = 23))
        diamantes.add(new DiamanteAzul(posX = 24, posY = 13))
        diamantes.add(new DiamanteAzul(posX = 20, posY = 3))
        diamantes.add(new DiamanteAzul(posX = 4, posY = 22))
        diamantes.add(new DiamanteAzul(posX = 18, posY = 23))
        diamantes.add(new DiamanteGris(posX = 6, posY = 5))

        diamantes.forEach { diamante => game.addVisual(diamante) }
    }

    override method setupElements() {
        game.addVisual(new Caja(position = new MutablePosition (x=13, y=18)))
        
        game.addVisual(puertaFireboy)
        game.addVisual(puertaWatergirl)

        game.addVisual(plataformaAmarilla)
        
        game.addVisual(botonAmarillo)
        
        game.addVisual(botonInvAmarillo1)
        game.addVisual(botonInvAmarillo2)

        game.addVisual(plataformaBordo)
        
        game.addVisual(botonBordoA)
        game.addVisual(botonBordoB)
        
        game.addVisual(botonInvBordoA1)
        game.addVisual(botonInvBordoA2)
        game.addVisual(botonInvBordoB1)
        game.addVisual(botonInvBordoB2)
    }

    override method setupCharcos() {
        (18..22).forEach { x => zonasProhibidasFuego.add([x, 0])} // charco de agua
        (24..28).forEach { x => zonasProhibidasFuego.add([x, 6])} // charco de acido
        (26..30).forEach { x => zonasProhibidasAgua.add([x, 0])} // charco de fuego 
        (24..28).forEach { x => zonasProhibidasAgua.add([x, 6]) } // charco de acido                                                  
    }
    // Marco de juego

    override method setupPositions (){
        
        (35..37).forEach    { x => positions.add([x, 1])    }
        (35..37).forEach    { x => positions.add([x, 2])    }
        (36..37).forEach    { x => positions.add([x, 3])    }
        (1..12).forEach     { x => positions.add([x, 4])    }
        (23..25).forEach    { x => positions.add([x, 5])    }
        (16..32).forEach    { x => positions.add([x, 6])    }
        (15..17).forEach    { x => positions.add([x, 7])    }
        (1..16).forEach     { x => positions.add([x, 8])    }
        (35..37).forEach    { x => positions.add([x, 9])    }
        (34..37).forEach    { x => positions.add([x, 10])   }
        (32..37).forEach    { x => positions.add([x, 11])   }
        (18..37).forEach    { x => positions.add([x, 12])   }
        (5..19).forEach     { x => positions.add([x, 13])   }
        (29..33).forEach    { x => positions.add([x, 16])   }
        (1..33).forEach     { x => positions.add([x, 17])   }
        (1..5).forEach      { x => positions.add([x, 18])   }
        (1..5).forEach      { x => positions.add([x, 19])   }
        (1..5).forEach      { x => positions.add([x, 20])   }
        (1..5).forEach      { x => positions.add([x, 21])   }
        (19..26).forEach    { x => positions.add([x, 18])   }
        (19..25).forEach    { x => positions.add([x, 19])   }
        (11..15).forEach    { x => positions.add([x, 20])   }
        (11..15).forEach    { x => positions.add([x, 21])   }
        (11..37).forEach    { x => positions.add([x, 22])   }
        (10..13).forEach    { x => positions.add([x, 23])   }
        (27..29).forEach    { x => positions.add([x, 23])   }
        (9..11).forEach     { x => positions.add([x, 24])   }
    }

    override method isLevelComplete() = 
        self.posicionIgual(fireboy, puertaFireboy) and self.posicionIgual(watergirl, puertaWatergirl) 


    // Métodos Propios

    method setupMechanics(personaje){
        personaje.gravedad()
        personaje.setupControls()
        personaje.setupCollisions()
        game.addVisual(personaje)
    }

    method posicionIgual(e1, e2) = e1.position() == e2.position()
}

object level2 inherits Level {} // DEJENLO, NO LO SAQUEN
object level3 inherits Level {} // DEJENLO, NO LO SAQUEN
object level4 inherits Level {} // DEJENLO, NO LO SAQUEN

object puntajes{
    method position() = game.center()
    // method image() = "puntajes.jpeg"
}

object muerte{
    method position() = game.center()
    method image() = "C_game_over.png"
}

object nivelSuperado{
    method position() = game.center()
    method image() = "F_Nivel_Superado.png"
   // method text1()  {Fireboy.puntaje()}
   // method text2()  {Watergirl.puntaje()}
}