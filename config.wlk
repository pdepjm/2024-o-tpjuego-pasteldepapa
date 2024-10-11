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
        (0..28).forEach { y => game.addVisual(new Border(posX = 0, posY = y))}
        (0..28).forEach { y => game.addVisual(new Border(posX = 38, posY = y))}
    }
}

class Level {

    // ---------------- REFERENCIAS
    const fireboy = new Fireboy(positionX = 3, positionY = 1) //Depende del nivel
    const watergirl = new Watergirl(positionX = 1, positionY = 1) //Depende del nivel
    const puertaFireboy = new Puerta(posX = 30, posY = 22, image = "f_door.png", tipo = fuego) //Depende del nivel
    const puertaWatergirl = new Puerta(posX = 34, posY = 22, image = "w_door.png", tipo = agua) //Depende del nivel
    

    // ---------------- JUEGO PRINCIPAL

    method start() {
        self.setupCharacters()
        self.setupFloors()
        self.setupControls()
        self.setupCollisions()
        self.setupDoors()
        self.setupDiamonds()
        self.gravedad()

        game.start()
    }
    
    method gravedad(){
        game.onTick(100, "Gravedad", {fireboy.moveDown()})
        game.onTick(100, "Gravedad", {watergirl.moveDown()})
    }

    method setupCharacters() {
        game.addVisual(fireboy)
        game.addVisual(watergirl)
    }

    method setupFloors(){}       

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

    method setupDiamonds() {}
}


object level1 inherits Level {
    
    const diamantes = []
    
    override method setupDiamonds() {

        diamantes.clear()

        diamantes.add(new DiamanteRojo(posX = 28, posY = 3))
        diamantes.add(new DiamanteRojo(posX = 9, posY = 14))
        diamantes.add(new DiamanteRojo(posX = 10, posY = 25))
        diamantes.add(new DiamanteRojo(posX = 22, posY = 23))
        diamantes.add(new DiamanteAzul(posX = 24, posY = 13))
        diamantes.add(new DiamanteAzul(posX = 20, posY = 3))
        diamantes.add(new DiamanteAzul(posX = 4, posY = 22))
        diamantes.add(new DiamanteAzul(posX = 18, posY = 23))

        diamantes.forEach { diamante => game.addVisual(diamante) }
    }

    override method setupFloors (){
        (35..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 1  ))} 
        (35..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 2  ))} 
        (36..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 3  ))} 
        (1..12).forEach     { x => game.addVisual(new Border(posX = x, posY = 4  ))} 
        (23..25).forEach    { x => game.addVisual(new Border(posX = x, posY = 5  ))} 
        (16..32).forEach    { x => game.addVisual(new Border(posX = x, posY = 6  ))} 
        (15..17).forEach    { x => game.addVisual(new Border(posX = x, posY = 7  ))} 
        (1..16).forEach     { x => game.addVisual(new Border(posX = x, posY = 8  ))} 
        (35..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 9  ))} 
        (34..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 10 ))}
        (32..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 11 ))}
        (18..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 12 ))}
        (5..19).forEach     { x => game.addVisual(new Border(posX = x, posY = 13 ))}
        (29..33).forEach    { x => game.addVisual(new Border(posX = x, posY = 16 ))}
        (1..33).forEach     { x => game.addVisual(new Border(posX = x, posY = 17 ))}
        (1..5).forEach      { x => game.addVisual(new Border(posX = x, posY = 18 ))}
        (1..5).forEach      { x => game.addVisual(new Border(posX = x, posY = 19 ))}
        (1..5).forEach      { x => game.addVisual(new Border(posX = x, posY = 20 ))}
        (1..5).forEach      { x => game.addVisual(new Border(posX = x, posY = 21 ))}
        (19..26).forEach    { x => game.addVisual(new Border(posX = x, posY = 18 ))}
        (19..25).forEach    { x => game.addVisual(new Border(posX = x, posY = 19 ))}
        (11..15).forEach    { x => game.addVisual(new Border(posX = x, posY = 20 ))}
        (11..15).forEach    { x => game.addVisual(new Border(posX = x, posY = 21 ))}
        (11..37).forEach    { x => game.addVisual(new Border(posX = x, posY = 22 ))}
        (10..13).forEach    { x => game.addVisual(new Border(posX = x, posY = 23 ))}
        (27..29).forEach    { x => game.addVisual(new Border(posX = x, posY = 23 ))}
        (9..11).forEach      { x => game.addVisual(new Border(posX = x, posY = 24 ))}
    }

}