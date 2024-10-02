class Character {
    const position = new MutablePosition(x=0, y=0)
    const unidadCaminar = 1
    const unidadSaltar = 5

    var canTouchFire
    var isFireboy

    method moveLeft() {
        position.goLeft(unidadCaminar)
    }

    method moveRight() {
        position.goRight(unidadCaminar)
    }

    method jump() {
        position.goUp(unidadSaltar) 
        game.schedule(1000, {this.fall()})
    }

    method fall() {
        position.goDown(unidadSaltar)
    }
}

class Fireboy extends Character {
    const imagePath = "Fireboy.png"
    var canTouchFire = true
    var isFireboy = true

    method image() = imagePath
}

class Watergirl extends Character {
    const imagePath = "Watergirl.png"
    var canTouchFire = false
    var isFireboy = false

    method image() = imagePath
}