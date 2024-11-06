import config.*
import elements.*
import characters.*

object level2 inherits Level {

    // --------------------- Referencias -------------------------

    // Puertas

    const puertaFireboy1 = new Puerta(posX = 6, posY = 24, tipo = fuego)
    const puertaFireboy2 = new Puerta(posX = 7, posY = 24, tipo = fuego)
    const puertaWatergirl1 = new Puerta(posX = 2, posY = 24, tipo = agua)
    const puertaWatergirl2 = new Puerta(posX = 3, posY = 24, tipo = agua)

    // Plataforma Violeta y Elementos Asociados

    const extensionPlatVioleta1 = new PlataformaBase(position = new MutablePosition(x=23, y=23))
    const extensionPlatVioleta2 = new PlataformaBase(position = new MutablePosition(x=24, y=23))
    const extensionPlatVioleta3 = new PlataformaBase(position = new MutablePosition(x=25, y=23))
    const extensionPlatVioleta4 = new PlataformaBase(position = new MutablePosition(x=26, y=23))

    const plataformaVioleta = new PlataformaMoviHorizontal(
        position = new MutablePosition(x=22, y=23),
        maxDistancia = 17,
        minDistancia = 22,
        platAsocs = [extensionPlatVioleta1, extensionPlatVioleta2,extensionPlatVioleta3,extensionPlatVioleta4]
    )

    const botonVioletaA = new Boton(posX = 12, posY = 24, plataformaAsoc = plataformaVioleta) // Boton izquierda
    const botonVioletaB = new Boton(posX = 28, posY = 24, plataformaAsoc = plataformaVioleta) // Boton derecha

    // Plataforma Amarilla y Elementos Asociados

    const extensionPlatAmarilla1 = new PlataformaBase(position = new MutablePosition(x=19, y=9))
    const extensionPlatAmarilla2 = new PlataformaBase(position = new MutablePosition(x=19, y=10))
    const extensionPlatAmarilla3 = new PlataformaBase(position = new MutablePosition(x=19, y=11))

    const plataformaAmarilla = new PlataformaMoviVertical(
        position = new MutablePosition(x=19, y=8),
        maxAltura = 12,
        minAltura = 8,
        platAsocs = [extensionPlatAmarilla1, extensionPlatAmarilla2],
        image = "E_vertical_gate2.png"
    )

    const botonAmarilloA = new Boton(posX = 8, posY = 8, plataformaAsoc = plataformaAmarilla) // Boton izquierda
    const botonAmarilloB = new Boton(posX = 31, posY = 8, plataformaAsoc = plataformaAmarilla) // Boton derecha

    // Lista con Todos los Elementos Especiales 

    const elemsColisionEspecial = [
        puertaFireboy1, puertaFireboy2,
        puertaWatergirl1, puertaWatergirl2,
        botonVioletaA, botonVioletaB,
        botonAmarilloA,botonAmarilloB
    ]

    // --------------------- Métodos

    // Basicos

    override method image() = "F_nivel_2.png"

    override method positionF() = new MutablePosition (x = 5, y= 24)
    override method positionW() = new MutablePosition (x = 5, y= 24)

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

    // Pisos intermedios

    override method setupPisos (){
        pisosJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 1, yMax = 2   ))
        pisosJuego.add(new Zona (xMin = 6, xMax = 14, yMin = 3, yMax = 3    ))
        pisosJuego.add(new Zona (xMin = 22, xMax = 29, yMin = 3, yMax = 3   ))
        pisosJuego.add(new Zona (xMin = 37, xMax = 37, yMin = 3, yMax = 4   ))
        pisosJuego.add(new Zona (xMin = 1, xMax = 33, yMin = 7, yMax = 7    ))
        pisosJuego.add(new Zona (xMin = 1, xMax = 3, yMin = 8, yMax = 10    ))
        pisosJuego.add(new Zona (xMin = 6, xMax = 16, yMin = 12, yMax = 12  ))
        pisosJuego.add(new Zona (xMin = 17, xMax = 21, yMin = 12, yMax = 13 ))
        pisosJuego.add(new Zona (xMin = 22, xMax = 37, yMin = 12, yMax = 12 ))
        pisosJuego.add(new Zona (xMin = 33, xMax = 37, yMin = 13, yMax = 15 ))
        pisosJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 16, yMax = 18 ))
        pisosJuego.add(new Zona (xMin = 11, xMax = 13, yMin = 15, yMax = 15 ))
        pisosJuego.add(new Zona (xMin = 25, xMax = 26, yMin = 15, yMax = 15 ))
        pisosJuego.add(new Zona (xMin = 30, xMax = 33, yMin = 21, yMax = 21 ))
        pisosJuego.add(new Zona (xMin = 29, xMax = 31, yMin = 22, yMax = 22 ))
        pisosJuego.add(new Zona (xMin = 1, xMax = 16, yMin = 23, yMax = 23  ))
        pisosJuego.add(new Zona (xMin = 22, xMax = 30, yMin = 23, yMax = 23 ))
    }

    // Agregamos Elementos 

    override method setupElements() {

        // Diamantes
        diamantes.forEach({x => game.addVisual(x)})

        // Puertas
        puertaFireboy1.otrasPuertas([puertaWatergirl1, puertaWatergirl2])
        puertaFireboy2.otrasPuertas([puertaWatergirl1, puertaWatergirl2])

        puertaWatergirl1.otrasPuertas([puertaFireboy1, puertaFireboy2])
        puertaWatergirl2.otrasPuertas([puertaFireboy1, puertaFireboy2])

        // Botones
        botonVioletaA.botonAsoc(botonVioletaB) 
        botonVioletaB.botonAsoc(botonVioletaA)
        botonAmarilloA.botonAsoc(botonAmarilloB) 
        botonAmarilloB.botonAsoc(botonAmarilloA)

        // Elementos con Colision Especial
        elemsColisionEspecial.forEach({x => x.setupCollisions()})
        
        // Agregamos Elementos a la lista de elementos del Nivel
        self.agregarElementosNivel()
        elementosNivel.forEach({element => game.addVisual(element)})
    }

    // Agregamos los elementos del nivel

    override method agregarElementosNivel (){
        [fireboy, watergirl, 
        puertaFireboy1, puertaFireboy2, puertaWatergirl1, puertaWatergirl2, 
        extensionPlatVioleta1, extensionPlatVioleta2,
        extensionPlatVioleta3,extensionPlatVioleta4, 
        plataformaVioleta,
        botonVioletaA, botonVioletaB,
        extensionPlatAmarilla1,extensionPlatAmarilla2,extensionPlatAmarilla3,
        plataformaAmarilla,
        botonAmarilloA,botonAmarilloB].forEach({x => elementosNivel.add(x)})
    }
}