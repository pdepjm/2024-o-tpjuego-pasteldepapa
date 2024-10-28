import config.*
import elements.*
import characters.*

object level2 inherits Level {

    // --------------------- Referencias -------------------------

    // Diamantes

    const diamantes = []

    // Puertas

    const puertaFireboy1 = new Puerta(posX = 6, posY = 24, tipo = fuego)
    const puertaFireboy2 = new Puerta(posX = 7, posY = 24, tipo = fuego)
    const puertaWatergirl1 = new Puerta(posX = 2, posY = 24, tipo = agua)
    const puertaWatergirl2 = new Puerta(posX = 3, posY = 24, tipo = agua)

    // Lista con Todos los Elementos - Para la limpieza luego

    const elementosNivel2 = [
        fireboy, watergirl, 
        puertaFireboy1, puertaFireboy2, 
        puertaWatergirl1, puertaWatergirl2] 

    // --------------------- Métodos

    // Basicos

    override method image() = "F_nivel_2.png"

    override method positionF() = new MutablePosition (x = 2, y= 15)
    override method positionW() = new MutablePosition (x = 4, y= 15)

    override method nivelActual () = self

    // Diamantes

    override method setupDiamonds() {
        diamantes.add(new DiamanteRojo(posX = 8, posY = 1))
        diamantes.add(new DiamanteRojo(posX = 12, posY = 1))
        diamantes.add(new DiamanteRojo(posX = 24, posY = 4))
        diamantes.add(new DiamanteRojo(posX = 27, posY = 4))
        diamantes.add(new DiamanteRojo(posX = 24, posY = 8))
        diamantes.add(new DiamanteRojo(posX = 15, posY = 8))
        diamantes.add(new DiamanteRojo(posX = 18, posY = 14))
        diamantes.add(new DiamanteRojo(posX = 18, posY = 24))
        diamantes.add(new DiamanteAzul(posX = 8, posY = 4))
        diamantes.add(new DiamanteAzul(posX = 12, posY = 4))
        diamantes.add(new DiamanteAzul(posX = 24, posY = 1))
        diamantes.add(new DiamanteAzul(posX = 27, posY = 1))
        diamantes.add(new DiamanteAzul(posX = 11, posY = 8))
        diamantes.add(new DiamanteAzul(posX = 28, posY = 8))
        diamantes.add(new DiamanteAzul(posX = 20, posY = 14))
        diamantes.add(new DiamanteAzul(posX = 20, posY = 24))
        diamantes.add(new DiamanteGris(posX = 18, posY = 3))
    }

    // Charcos 

    override method setupCharcos() {
        charcos.add(new Charco(xMin = 6, xMax = 14, yMin = 0, yMax = 0, tipo = fuego))
        charcos.add(new Charco(xMin = 22, xMax = 29, yMin = 3, yMax = 3, tipo = fuego))
        charcos.add(new Charco(xMin = 6, xMax = 14, yMin = 3, yMax = 3, tipo = agua))
        charcos.add(new Charco(xMin = 22, xMax = 29, yMin = 0, yMax = 0, tipo = agua))
        charcos.add(new Charco(xMin = 8, xMax = 16, yMin = 12, yMax = 12, tipo = acido))
        charcos.add(new Charco(xMin = 22, xMax = 29, yMin = 12, yMax = 12, tipo = acido))
    }

    // Marcos

    override method setupMarco (){
        // Borde del juego
        marcoJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 0, yMax = 0   ))
        marcoJuego.add(new Zona (xMin = 0, xMax = 0, yMin = 1, yMax = 27   ))
        marcoJuego.add(new Zona (xMin = 0, xMax = 38, yMin = 28, yMax = 28 ))
        marcoJuego.add(new Zona (xMin = 38, xMax = 38, yMin = 1, yMax = 27 ))

        // Zonas intermedias
        marcoJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 1, yMax = 2   ))
        marcoJuego.add(new Zona (xMin = 37, xMax = 37, yMin = 3, yMax = 4   ))
        marcoJuego.add(new Zona (xMin = 1, xMax = 33, yMin = 7, yMax = 7    ))
        marcoJuego.add(new Zona (xMin = 1, xMax = 3, yMin = 8, yMax = 10    ))
        marcoJuego.add(new Zona (xMin = 6, xMax = 16, yMin = 12, yMax = 12  ))
        marcoJuego.add(new Zona (xMin = 17, xMax = 21, yMin = 12, yMax = 13 ))
        marcoJuego.add(new Zona (xMin = 22, xMax = 37, yMin = 12, yMax = 12 ))
        marcoJuego.add(new Zona (xMin = 33, xMax = 37, yMin = 13, yMax = 15 ))
        marcoJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 16, yMax = 18 ))
        marcoJuego.add(new Zona (xMin = 11, xMax = 13, yMin = 15, yMax = 15 ))
        marcoJuego.add(new Zona (xMin = 25, xMax = 26, yMin = 15, yMax = 15 ))
        marcoJuego.add(new Zona (xMin = 30, xMax = 33, yMin = 21, yMax = 21 ))
        marcoJuego.add(new Zona (xMin = 29, xMax = 31, yMin = 22, yMax = 22 ))
        marcoJuego.add(new Zona (xMin = 1, xMax = 16, yMin = 23, yMax = 23  ))
        marcoJuego.add(new Zona (xMin = 22, xMax = 30, yMin = 23, yMax = 23 ))
    }

    // Agregamos Elementos 

    override method setupElements() {
        elementosNivel2.forEach({element => game.addVisual(element)})
        diamantes.forEach({x => game.addVisual(x)})

        // Puertas
        puertaFireboy1.otrasPuertas([puertaWatergirl1, puertaWatergirl2])
        puertaFireboy2.otrasPuertas([puertaWatergirl1, puertaWatergirl2])

        puertaWatergirl1.otrasPuertas([puertaFireboy1, puertaFireboy2])
        puertaWatergirl2.otrasPuertas([puertaFireboy1, puertaFireboy2])
    }

    // Limpieza Final
    
    override method cleanVisuals() {
        elementosNivel2.forEach({element => game.removeVisual(element)})
        diamantes.forEach({x => game.removeVisual(x)})
        charcos.clear()
    }

}