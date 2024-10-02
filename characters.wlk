class Character {
    const position = new MutablePosition(x=1, y=0)
    const unidadCaminar = 1
    const unidadSaltar = 5

    method position() = position
    
    method image() {
        return "" // Sobrescrito en las subclase
    }

    method moveLeft() {
        position.goLeft(unidadCaminar)
    }

    method moveRight() {
        position.goRight(unidadCaminar)
    }

    method jump() {
        position.goUp(unidadSaltar) 
        game.schedule(1000, {self.fall()})
    }

    method fall() {
        position.goDown(unidadSaltar)
    }
}

class Fireboy inherits Character {

    const isFireboy = true

    override method image() {
        return "Fireboy.png" 
    }
}

class Watergirl inherits Character {

    const isFireboy = false

    override method image() {
        return "Watergirl.png" 
    } 
}