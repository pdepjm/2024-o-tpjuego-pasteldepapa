object watergirl{
  const position = new MutablePosition(x=3, y=0)

  method image() = "b.png"
  method position() = position

  method avanzar(pasos) {
    position.goRight(pasos)
  }
  method retroceder(pasos) {
    position.goLeft(pasos)
  }
  
   method saltar(unidad) {
    position.goUp(unidad) 
    game.schedule(10, {position.goDown(unidad)})  
  }

  method canCollectDiamanteRojo() = false
  method canCollectDiamanteCeleste() = true

}