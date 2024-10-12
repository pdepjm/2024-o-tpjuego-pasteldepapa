import characters.*
import elements.*

object settings {

    // Referencias
    const niveles = [level1] 
    var nivelActual = 0 // Índice del nivel actual

    // Métodos
    method init (background, height, width, cellSize){
        game.title("FireBoyWaterGirlGame")
        game.boardGround(background)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px
    }
    
    method checkLevelCompletion(level) {
        game.schedule(100, {
            if(level.isLevelComplete()) { 
                game.addVisual(puntajes)
                //game.schedule(5000,{game.removeVisual(puntajes)}) puede ser que con el clear ya sea suficiente apra que el visual se borre, asi que pruebo comentarlo
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
            game.addVisual("nivel_pasado.mp3")
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
        self.setupElements()  // Bloques, palancas, plataformas, etc.
        self.setupDiamonds()
        self.setupCharacters()
        self.generarCharcos()
        self.setupBorders()
        self.setupPositions()
        game.start()
    }
    
    // Marco de juego

    const positions = [] // Guardar las coordenadas que no puede atravesar
    
    method setupBorders(){
        (0..38).forEach     { x => positions.add([x, 0])    }
        (0..38).forEach     { x => positions.add([x, 28])   }
        (0..28).forEach     { y => positions.add([0, y])    }
        (0..28).forEach     { y => positions.add([38, y])   }
    }

    method setupPositions(){}

    // Métodos Sobrescritos en los Niveles
    method setupDiamonds() {}
    method setupElements () {}
    method generarCharcos() {}
    method isLevelComplete() {}
    method setupCharacters() {}
}


object level1 inherits Level {
    
    const diamantes = []
    const fireboy = new Fireboy(position = new MutablePosition (x=1, y=1), oldPosition = new MutablePosition (x=1, y=1)) //Depende del nivel
    const watergirl = new Watergirl(position = new MutablePosition (x=3, y=1), oldPosition = new MutablePosition (x=3, y=1)) //Depende del nivel
    const puertaFireboy = new Puerta(posX = 30, posY = 22)
    const puertaWatergirl = new Puerta(posX = 34, posY = 22)
    
    override method setupCharacters() {
        self.setupMechanics(fireboy)
        self.setupMechanics(watergirl)
    }

    method setupMechanics(personaje){
        personaje.gravedad()
        personaje.setupControls()
        personaje.setupCollisions()
        game.addVisual(personaje)
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

        // Pasamos la lista a los personajes para que pueda conocer los limites del mapa
        watergirl.position(positions)
        fireboy.position(positions)
    }

    override method setupElements() {
        game.addVisual(new Caja(position = new MutablePosition (x=13, y=18)))
    }
    
    override method generarCharcos() {
        (18..22).forEach    { x => game.addVisual(new Charco(tipo = agua, posX = x, posY = 0 ))}
        (26..30).forEach    { x => game.addVisual(new Charco(tipo = fuego, posX = x, posY = 0 ))}
        (24..28).forEach    { x => game.addVisual(new Charco(tipo = null, posX = x, posY = 6 ))}
    } 

    override method isLevelComplete() = 
        self.posicionIgual(fireboy, puertaFireboy) and self.posicionIgual(watergirl, puertaWatergirl)
    
    method posicionIgual(e1, e2) = e1.position() == e2.position()
}

object puntajes{
    method position() = game.center()
    method image() = "puntajes.jpeg"
    method text1()  {Fireboy.puntaje()}
    method text2()  {Watergirl.puntaje()}
}

object muerte{
    method position() = game.center()
    method image() = "muertee.gif"
}

object nivelSuperado{
    method position() = game.center()
    method image() = "muertee.gif"
    method text() = "NIVEL SUPERADO"
}