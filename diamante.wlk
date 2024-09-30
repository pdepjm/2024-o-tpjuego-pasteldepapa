import fireboy.*
import watergirl.*

object diamanteRojo{
    method position() = game.at(20,0)
    method image() = "diamante.png"
    method recoger(personaje) {
        if (personaje.canCollectDiamanteRojo()) {
            game.removeVisual(self)
        }
    }
}

object diamanteCeleste{
    method position() = game.at(40,0)
    method image() = "dia.png"
   method recoger(personaje) {
        if (personaje.canCollectDiamanteCeleste()) {
            game.removeVisual(self)
        }
    }
}