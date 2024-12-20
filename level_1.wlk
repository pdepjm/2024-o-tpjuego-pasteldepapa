import config.*
import elements.*
import characters.*

// class level1
// objetc nivelActual inherits 

object level1 inherits Level {
    
    // --------------------- Referencias -------------------------

    // Puertas

    const puertaFireboy1 = new Puerta(posX = 32, posY = 23, tipo = fuego)
    const puertaFireboy2 = new Puerta(posX = 33, posY = 23, tipo = fuego)
    const puertaWatergirl1 = new Puerta(posX = 35, posY = 23, tipo = agua)
    const puertaWatergirl2 = new Puerta(posX = 36, posY = 23, tipo = agua)

    // Plataforma Amarilla y Elementos Asociados

    const extensionPlatAmarilla1 = new PlataformaBase(position = new MutablePosition(x=2, y=9))
    const extensionPlatAmarilla2 = new PlataformaBase(position = new MutablePosition(x=3, y=9))

    const plataformaAmarilla = new PlataformaMovible(
        position = new MutablePosition(x=1, y=9),
        posicionMax = 13,
        posicionMin = 9,
        platAsocs = [extensionPlatAmarilla1, extensionPlatAmarilla2],
        image = "E_horizontal_gate.png", 
        dirOriginal = movePlatMoviVertical,
        dirVuelta = moveBackPlatMoviVertical
    )

    const botonAmarilloA = new Boton(posX = 10, posY = 9, plataformaAsoc = plataformaAmarilla) // Boton Abajo
    const botonAmarilloB = new Boton(posX = 13, posY = 14, plataformaAsoc = plataformaAmarilla) // Boton Arriba

    // Plataforma Bordo y Elementos Asociados

    const extensionPlatBordo1 = new PlataformaBase(position = new MutablePosition(x=35, y=13))
    const extensionPlatBordo2 = new PlataformaBase(position = new MutablePosition(x=36, y=13))

    const plataformaBordo = new PlataformaMovible(
        position = new MutablePosition(x=34, y=13),
        posicionMax = 16,
        posicionMin = 13,
        platAsocs = [extensionPlatBordo1, extensionPlatBordo2],
        image = imagePlatHorizontal, 
        dirOriginal = movePlatMoviVertical,
        dirVuelta = moveBackPlatMoviVertical
    )

    const botonBordoA = new Boton(posX = 30, posY = 18, plataformaAsoc = plataformaBordo) // Boton Arriba
    const botonBordoB = new Boton(posX = 29, posY = 13, plataformaAsoc = plataformaBordo) // Boton Abajo
    
    // Caja

    const caja = new Caja(position = new MutablePosition (x=13, y=18))

  
    
    // Lista con Elementos con Colision Especial

    const elemsColisionEspecial = [
        botonAmarilloA, botonAmarilloB,
        botonBordoA, botonBordoB,
        puertaFireboy1, puertaFireboy2,
        puertaWatergirl1, puertaWatergirl2
    ]

    // --------------------- Métodos

    // Basicos

    override method image() = "F_nivel_1.png"
   
    override method positionF() = new MutablePosition (x = 35, y = 23)
    override method positionW() = new MutablePosition (x = 35, y = 23)

    override method nivelActual () = self

    // Diamantes

    override method setupDiamonds() {

        diamantes.add(new DiamanteRojo(posX = 28, posY = 3))
        diamantes.add(new DiamanteRojo(posX = 9, posY = 14))
        diamantes.add(new DiamanteRojo(posX = 10, posY = 25))
        diamantes.add(new DiamanteRojo(posX = 22, posY = 23))
        diamantes.add(new DiamanteAzul(posX = 24, posY = 13))
        diamantes.add(new DiamanteAzul(posX = 20, posY = 3))
        diamantes.add(new DiamanteAzul(posX = 4, posY = 22))
        diamantes.add(new DiamanteAzul(posX = 18, posY = 23))
        diamantes.add(new DiamanteGris(posX = 6, posY = 5))
    }

    // Charcos

    override method setupCharcos() {
        charcos.add(new Charco(xMin = 18, xMax = 22, yMin = 0, yMax = 0, tipo = agua))
        charcos.add(new Charco(xMin = 26, xMax = 30, yMin = 0, yMax = 0, tipo = fuego))
        charcos.add(new Charco(xMin = 24, xMax = 28, yMin = 6, yMax = 6, tipo = acido))
    }

    // Marcos
    
    override method setupPisos(){
        pisosJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 1, yMax = 2  ))
        pisosJuego.add(new Zona (xMin = 36, xMax = 37, yMin = 3, yMax = 3  ))
        pisosJuego.add(new Zona (xMin = 1, xMax = 12, yMin = 4, yMax = 4   ))
        pisosJuego.add(new Zona (xMin = 23, xMax = 25, yMin = 5, yMax = 5  ))
        pisosJuego.add(new Zona (xMin = 16, xMax = 32, yMin = 6, yMax = 6  ))
        pisosJuego.add(new Zona (xMin = 15, xMax = 17, yMin = 7, yMax = 7  ))
        pisosJuego.add(new Zona (xMin = 1, xMax = 16, yMin = 8, yMax = 8   ))
        pisosJuego.add(new Zona (xMin = 35, xMax = 37, yMin = 9, yMax = 9  ))
        pisosJuego.add(new Zona (xMin = 34, xMax = 37, yMin = 10, yMax = 10))
        pisosJuego.add(new Zona (xMin = 32, xMax = 37, yMin = 11, yMax = 11))
        pisosJuego.add(new Zona (xMin = 18, xMax = 37, yMin = 12, yMax = 12))
        pisosJuego.add(new Zona (xMin = 5, xMax = 19, yMin = 13, yMax = 13 ))
        pisosJuego.add(new Zona (xMin = 29, xMax = 33, yMin = 16, yMax = 16))
        pisosJuego.add(new Zona (xMin = 1, xMax = 33, yMin = 17, yMax = 17 ))
        pisosJuego.add(new Zona (xMin = 19, xMax = 26, yMin = 18, yMax = 18))
        pisosJuego.add(new Zona (xMin = 19, xMax = 25, yMin = 19, yMax = 19))
        pisosJuego.add(new Zona (xMin = 1, xMax = 5, yMin = 18, yMax = 21  ))
        pisosJuego.add(new Zona (xMin = 11, xMax = 15, yMin = 20, yMax = 21))
        pisosJuego.add(new Zona (xMin = 11, xMax = 37, yMin = 22, yMax = 22))
        pisosJuego.add(new Zona (xMin = 10, xMax = 13, yMin = 23, yMax = 23))
        pisosJuego.add(new Zona (xMin = 27, xMax = 29, yMin = 23, yMax = 23))
        pisosJuego.add(new Zona (xMin = 9, xMax = 11, yMin = 24, yMax = 24 ))
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
        botonAmarilloA.botonAsoc(botonAmarilloB) 
        botonAmarilloB.botonAsoc(botonAmarilloA)
        botonBordoA.botonAsoc(botonBordoB) 
        botonBordoB.botonAsoc(botonBordoA)

        // Elementos con Colision Especial
        elemsColisionEspecial.forEach({x => x.setupCollisions()})
        
        // Agregamos Elementos a la lista de elementos del Nivel
        self.agregarElementosNivel()
        elementosNivel.forEach({element => game.addVisual(element)})
    }
   
    // Lista con Todos los Elementos - Para la limpieza luego

    override method agregarElementosNivel (){
        elementosNivel.addAll([fireboy, watergirl, 
        caja, 
        puertaFireboy1, puertaFireboy2, puertaWatergirl1, puertaWatergirl2, 
        extensionPlatAmarilla1, extensionPlatAmarilla2, 
        plataformaAmarilla, 
        botonAmarilloA, botonAmarilloB, 
        extensionPlatBordo1, extensionPlatBordo2, 
        plataformaBordo, 
        botonBordoA, botonBordoB])
    }
}