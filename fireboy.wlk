object fireboy{
  const position = new MutablePosition(x=0, y=0)

  method image() = "a.png"
  method position() = position

  method avanzar(pasos) {
    position.goRight(pasos)
  }
  
  method retroceder(pasos) {
    position.goLeft(pasos)
  }

  method saltar(unidad) {
    position.goUp(unidad) 
    game.schedule(1000, {position.goDown(unidad)})  
  }

  method canCollectDiamanteRojo() = true
  method canCollectDiamanteCeleste() = false
}

