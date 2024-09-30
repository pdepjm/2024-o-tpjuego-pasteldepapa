object fireboy{
  const position = new MutablePosition(x=1, y=0)

  method image() = "descarga.jpeg"
  method position() = position

  method avanzar(pasos) {
    position.goRight(pasos)
  }
  method retroceder(pasos) {
    position.goLeft(pasos)
  }
  
}

