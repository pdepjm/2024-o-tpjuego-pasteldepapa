class Character {
    const position = new MutablePosition(x=1, y=1)
    const unidadMovimiento = 1

    method position() = position

    method image() {
        return "" // Sobrescrito en las subclase
    }

    method moveLeft() {
        position.goLeft(unidadMovimiento)
    }

    method moveRight() {
        position.goRight(unidadMovimiento)
    }

    method jump() {
        position.goUp(unidadMovimiento)
        game.schedule(100, {position.goUp(unidadMovimiento)})
        game.schedule(200, {position.goUp(unidadMovimiento)})
        game.schedule(300, {position.goUp(unidadMovimiento)})
        self.fall()

    }

    method fall() {
        game.schedule(800, {position.goDown(unidadMovimiento)})
        game.schedule(900, {position.goDown(unidadMovimiento)})
        game.schedule(1000, {position.goDown(unidadMovimiento)})
        game.schedule(1100, {position.goDown(unidadMovimiento)})
    }
}

class Fireboy inherits Character {

    method isFireboy() = true

    override method image() {
        return "fireboy.png" 
    }
}

class Watergirl inherits Character {

    method isFireboy() = false

    override method image() {
        return "watergirl.png" 
    } 
}