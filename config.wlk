import invisible_objects.*
object settings {

    method init (){
    game.title("FireBoyWaterGirlGame")
    game.boardGround("nivel_1.png")
    game.height(29)
    game.width(39)
    game.cellSize(36) // 1404x1044 / 39x29 = 36px
    }
    
    method generarMarco(){
    (0..38).forEach { x => game.addVisual(new Border(posX = x, posY = 0))}
    (0..38).forEach { x => game.addVisual(new Border(posX = x, posY = 28))}
    (0..28).forEach{ y => game.addVisual(new Border(posX = 0, posY = y))}
    (0..28).forEach{ y => game.addVisual(new Border(posX = 38, posY = y))}
    }
}