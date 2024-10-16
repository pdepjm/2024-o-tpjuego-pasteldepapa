import characters.*
import elements.*

object settings {

    // ---------------------- Referencias
    const niveles = [level1, level2] 
    var nivelActual = 0 // Índice del nivel actual
    const fondoNuevo = new BackgroundCover()

    // ---------------------- Métodos

    method init (background, height, width, cellSize){
        game.title("FireBoyWaterGirlGame")
        game.boardGround(background)
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

            
            niveles.get(nivelActual).cleanVisuals()
            game.addVisual(fondoNuevo)

            // CAMBIAR AL FONDO DE NIVEL 2
        //   nivelActual +=1

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
    method setupCharacters() {}
    method cleanVisuals() {}
}


object level1 inherits Level {
    
    // --------------------- Referencias -------------------------
    
    // Personajes 

    const fireboy = new Fireboy(position = new MutablePosition (x=13, y=1), oldPosition = new MutablePosition (x=13, y=1), nivelActual = self, zonasProhibidas = zonasProhibidasFuego, invalidPositions = positions) //Depende del nivel
    const watergirl = new Watergirl(position = new MutablePosition (x=16, y=1), oldPosition  = new MutablePosition (x=16, y=1), nivelActual = self, zonasProhibidas = zonasProhibidasAgua, invalidPositions = positions) //Depende del nivel
    

    // Lista de Posiciones prohibidas y diamantes

    const zonasProhibidasFuego = []
    const zonasProhibidasAgua = []
    const diamantes = []

    // ---------------------- Elementos

    // Puertas Finales
    const puertaFireboy1 = new Puerta(posX = 32, posY = 23, tipo = fuego)
    const puertaFireboy2 = new Puerta(posX = 33, posY = 23, tipo = fuego)
    const puertaWatergirl1 = new Puerta(posX = 35, posY = 23, tipo = agua)
    const puertaWatergirl2 = new Puerta(posX = 36, posY = 23, tipo = agua)

    // Plataforma Amarilla y Elementos Asociados

    const extensionPlatAmarilla1 = new ExtensionPlataformaMovible(posX = 2, posY = 9)
    const extensionPlatAmarilla2 = new ExtensionPlataformaMovible(posX = 3, posY = 9)

    const plataformaAmarilla = new PlataformaMovible(
        posX = 1,
        posY = 9,
        maxAltura = 13,
        minAltura = 9,
        platAsocs = [extensionPlatAmarilla1, extensionPlatAmarilla2]
    )

    const botonAmarilloA = new Boton(posX = 10, posY = 9, plataformaAsoc = plataformaAmarilla) // Boton Abajo
    const botonAmarilloB = new Boton(posX = 13, posY = 14, plataformaAsoc = plataformaAmarilla) // Boton Arriba

    const botonInvAmarilloDer = new BotonInvisible(posX = 11, posY = 9, botonAsoc = botonAmarilloA)
    const botonInvAmarilloIzq = new BotonInvisible(posX = 9, posY = 9, botonAsoc = botonAmarilloA)

    const botonInvBordoADer = new BotonInvisible(posX = 14, posY = 14, botonAsoc = botonAmarilloB)
    const botonInvBordoAIzq = new BotonInvisible(posX = 12, posY = 14, botonAsoc = botonAmarilloB)


    // Plataforma Bordo y Elementos Asociados

    const extensionPlatBordo1 = new ExtensionPlataformaMovible(posX = 35, posY = 13)
    const extensionPlatBordo2 = new ExtensionPlataformaMovible(posX = 36, posY = 13)

    const plataformaBordo = new PlataformaMovible(
        posX = 34,
        posY = 13,
        maxAltura = 16,
        minAltura =13,
        platAsocs = [extensionPlatBordo1, extensionPlatBordo2]
    )


    const botonBordoA = new Boton(posX = 30, posY = 18, plataformaAsoc = plataformaBordo) // Boton Arriba
    const botonBordoB = new Boton(posX = 29, posY = 13, plataformaAsoc = plataformaBordo) // Boton Abajo
    
    const botonInvBordoBDer = new BotonInvisible(posX = 30, posY = 13, botonAsoc = botonBordoB)
    const botonInvBordoBIzq = new BotonInvisible(posX = 28, posY = 13, botonAsoc = botonBordoB)

    const botonInvAmarilloBDer = new BotonInvisible(posX = 31, posY = 18, botonAsoc = botonBordoA)
    const botonInvAmarilloBIzq = new BotonInvisible(posX = 29, posY = 18, botonAsoc = botonBordoA)
    
    // Caja
    const caja = new Caja(position = new MutablePosition (x=13, y=18))

    // --------------------- Métodos

    // Métodos Sobrescritos
    
    override method setupCharacters() {
        /*
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
        */
        game.addVisual(fireboy)
        game.addVisual(watergirl)
        fireboy.setPosition(15,1)
        watergirl.setPosition(23,1) 
    }

    method setupMechanicsInit(){
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
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

        // Caja
        game.addVisual(caja)
        
        // Puertas
        puertaFireboy1.otrasPuertas([puertaWatergirl1, puertaWatergirl2])
        puertaFireboy2.otrasPuertas([puertaWatergirl1, puertaWatergirl2])

        puertaWatergirl1.otrasPuertas([puertaFireboy1, puertaFireboy2])
        puertaWatergirl2.otrasPuertas([puertaFireboy1, puertaFireboy2])

        game.addVisual(puertaFireboy1)
        game.addVisual(puertaFireboy2)
        game.addVisual(puertaWatergirl1)
        game.addVisual(puertaWatergirl2)

        // Botones y Plataformas
        game.addVisual(plataformaAmarilla)

        game.addVisual(extensionPlatAmarilla1)
        game.addVisual(extensionPlatAmarilla2)
        
        game.addVisual(botonAmarilloA)
        game.addVisual(botonAmarilloB)
        
        game.addVisual(botonInvAmarilloDer)
        game.addVisual(botonInvAmarilloIzq)

        game.addVisual(botonInvAmarilloBDer)
        game.addVisual(botonInvAmarilloBIzq)

        game.addVisual(plataformaBordo)

        game.addVisual(extensionPlatBordo1)
        game.addVisual(extensionPlatBordo2)
        
        game.addVisual(botonBordoA)
        game.addVisual(botonBordoB)
        
        game.addVisual(botonInvBordoADer)
        game.addVisual(botonInvBordoAIzq)

        game.addVisual(botonInvBordoBDer)
        game.addVisual(botonInvBordoBIzq)

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

    override method cleanVisuals() {
        
        // Caja
        game.removeVisual(caja)
        
        // Puertas

        game.removeVisual(puertaFireboy1)
        game.removeVisual(puertaFireboy2)
        game.removeVisual(puertaWatergirl1)
        game.removeVisual(puertaWatergirl2)

        // Botones y Plataformas
        game.removeVisual(plataformaAmarilla)
        
        game.removeVisual(botonAmarilloA)
        game.removeVisual(botonAmarilloB)
        
        game.removeVisual(botonInvAmarilloDer)
        game.removeVisual(botonInvAmarilloIzq)
        game.removeVisual(botonInvAmarilloBDer)
        game.removeVisual(botonInvAmarilloBIzq)

        game.removeVisual(plataformaBordo)
        
        game.removeVisual(botonBordoA)
        game.removeVisual(botonBordoB)

        
        game.removeVisual(botonInvBordoADer)
        game.removeVisual(botonInvBordoAIzq)
        game.removeVisual(botonInvBordoBDer)
        game.removeVisual(botonInvBordoBIzq)

        game.removeVisual(extensionPlatAmarilla1)
        game.removeVisual(extensionPlatAmarilla2)

        game.removeVisual(extensionPlatBordo1)
        game.removeVisual(extensionPlatBordo2)

        // Diamantes

        diamantes.forEach { diamante => game.removeVisual(diamante) }

        // Personajes

        game.removeVisual(fireboy)
        game.removeVisual(watergirl)

        // Charcos

        zonasProhibidasAgua.clear()
        zonasProhibidasFuego.clear()

        // Pisos

        positions.clear()
    }

    // Métodos Propios

    method setupMechanics(personaje){
        personaje.gravedad()
        personaje.setupControls()
        personaje.setupCollisions()
        //game.addVisual(personaje)
    }
}

object level2 inherits Level {} // DEJENLO, NO LO SAQUEN
object level3 inherits Level {} // DEJENLO, NO LO SAQUEN
object level4 inherits Level {} // DEJENLO, NO LO SAQUEN

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