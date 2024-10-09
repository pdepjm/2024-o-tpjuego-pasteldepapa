class Border {
    
    var posX
    var posY

    method esAtravesable() = false 

    method position(positionX, positionY) {
        posX = positionX
        posY = positionY
    }

    var property position = new MutablePosition (x=posX, y=posY)

    
}

