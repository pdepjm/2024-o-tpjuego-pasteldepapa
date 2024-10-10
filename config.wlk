import invisible_objects.*
import characters.*
import elements.*

object settings {
    method init (background, height, width, cellSize){
        game.title("FireBoyWaterGirlGame")
        game.boardGround(background)
        game.height(height)
        game.width(width)
        game.cellSize(cellSize) // 1404x1044 // 39x29 = 36px
    }
    method generarMarco(){
        (0..38).forEach { x => game.addVisual(new Border(posX = x, posY = 0))}
        (0..38).forEach { x => game.addVisual(new Border(posX = x, posY = 28))}
        (0..28).forEach{ y => game.addVisual(new Border(posX = 0, posY = y))}
        (0..28).forEach{ y => game.addVisual(new Border(posX = 38, posY = y))}
    }
}

class Level {

    // ---------------- REFERENCIAS
    const fireboy = new Fireboy(positionX = 3, positionY = 1)
    const watergirl = new Watergirl(positionX = 1, positionY = 1)
    const puertaFireboy = new Puerta(posX = 30, posY = 22, image = "f_door.png", tipo = fuego) 
    const puertaWatergirl = new Puerta(posX = 34, posY = 22, image = "w_door.png", tipo = agua)  
    const diamantes = []

    // ---------------- JUEGO PRINCIPAL

    method start(nroNivel) {
        self.setupCharacters()
        self.setupControls()
        self.setupCollisions()
        self.setupDoors()
        self.setupDiamonds(nroNivel) 

        game.start()
    }
    method setupCharacters() {
        game.addVisual(fireboy)
        game.addVisual(watergirl)
    }

    method setupControls() {
        // Controles para Watergirl
        keyboard.a().onPressDo({ watergirl.moveLeft() })
        keyboard.d().onPressDo({ watergirl.moveRight() })
        keyboard.w().onPressDo({ watergirl.jump() })

        // Controles para Fireboy
        keyboard.left().onPressDo({ fireboy.moveLeft() })
        keyboard.right().onPressDo({ fireboy.moveRight() })
        keyboard.up().onPressDo({ fireboy.jump() })
    }
    method setupCollisions() {
        game.onCollideDo(fireboy, {element => element.colision(fireboy)}) 
        game.onCollideDo(watergirl, {element => element.colision(watergirl)})
    }

    method setupDoors() {
        game.addVisual(puertaFireboy) 
        game.addVisual(puertaWatergirl) 
    }
    method setupDiamonds(nroNivel) {

        diamantes.clear()

        if (nroNivel == 1) {
            diamantes.add(new DiamanteRojo(posX = 28, posY = 3))
            diamantes.add(new DiamanteRojo(posX = 9, posY = 14))
            diamantes.add(new DiamanteRojo(posX = 10, posY = 25))
            diamantes.add(new DiamanteRojo(posX = 22, posY = 23))
            diamantes.add(new DiamanteAzul(posX = 24, posY = 13))
            diamantes.add(new DiamanteAzul(posX = 20, posY = 3))
            diamantes.add(new DiamanteAzul(posX = 4, posY = 22))
            diamantes.add(new DiamanteAzul(posX = 18, posY = 23))
        } else if (nroNivel == 2) {
            diamantes.add(new DiamanteRojo(posX = 28, posY = 3))
            // agregar mas, lo puse solo para que no saltara error

        }

        diamantes.forEach { diamante => game.addVisual(diamante) }
    }
}

