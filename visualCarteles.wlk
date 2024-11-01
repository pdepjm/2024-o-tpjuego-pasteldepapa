import characters.*
import elements.*
import level_1.*
import level_2.*

object puntajesCartel{  // HACER O SACAR
    method position() = game.center()
    method esAtravesable () = true
    // method image() = "puntajes.jpeg"
}

object muerteCartel{
    const posX = 6
    const posY = 6

    method position() = game.at(posX, posY)
    method image() = "F_Game_over.png"
    method esAtravesable () = true
}

object nivelSuperadoCartel{
    const posX = 6
    const posY = 6

    method esAtravesable () = true
    method position() = game.at(posX, posY)
    method image() = "F_Nivel_Superado.png"
    method text1()  {Fireboy.puntaje()}
    method text2()  {Watergirl.puntaje()}
}

object finJuegoCartel{

    method position() = game.origin()

    method esAtravesable () = true
    
    method image () = "F_Fin_De_Juego2.png"
}