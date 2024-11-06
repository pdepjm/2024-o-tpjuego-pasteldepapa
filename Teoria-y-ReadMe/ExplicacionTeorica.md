# Conceptos de Programación Orientada a Objetos

## Clases y Objetos

En el diseño del juego, las *clases* se utilizan tanto para representar tanto a los personajes como a los elementos interactivos. Por ejemplo, tenemos una clase base `Personaje`, que actúa como plantilla general para los personajes del juego, y clases específicas como `FireBoy` y `WaterGirl` que heredan de `Personaje`. De manera similar, la clase `Diamante` representa a los distintos tipos de diamantes en el juego, con subclases específicas como `DiamanteRojo` y `DiamanteAzul`, que definen características particulares.

El uso de *clases* permite organizar el código en estructuras que reflejan los elementos del juego, haciendo que cada objeto (instancia de una clase) tenga sus propias propiedades y comportamientos, como la posición en el mapa o la manera que reacciona a colisiones. 

Además, gracias a las *clases*, es sencillo crear múltiples instancias de objetos iguales en diferentes lugares del juego. Por ejemplo, en un nivel podemos necesitar varios diamantes dispersos o varios botones de plataforma que el jugador debe activar. Utilizando la misma clase para todos estos elementos, podemos generarlos de manera uniforme y gestionar sus comportamientos de forma centralizada y evitando repetición de lógica.

## Herencia

La *herencia* es utilizada para crear relaciones jerárquicas entre las clases. En nuestro juego, `FireBoy` y `WaterGirl` heredan de la clase base Personaje, compartiendo atributos y métodos comunes, como `moveUp()` y `jump()`. Sin embargo, cada uno puede sobrescribir o extender estos comportamientos para adaptarse a situaciones específicas; por ejemplo, `FireBoy` podría pasar ileso a través de obstáculos de fuego, mientras que `WaterGirl` lo haría con obstáculos de agua. Esto sucede porque las subclases sobrescriben el método `tipo()`. Asimismo, las teclas empleadas para mover los personajes son diferentes, por ende debemos especificar dicho comportamiento en cada subclase particular.

Esta estructura facilita la reutilización de código, ya que los comportamientos comunes se definen en la clase base, y las subclases solo necesitan implementar las diferencias específicas. Esto hace que el sistema sea fácilmente extensible, permitiendo agregar nuevos personajes o tipos de diamantes sin necesidad de cambios drásticos en el código base.

## Polimorfismo

En el código y el contexto del juego, el *polimorfismo* se utiliza para manejar de manera uniforme objetos que comparten una estructura básica, pero responden de forma diferente a ciertos eventos del juego. Un claro ejemplo es la gestión de colisiones: en lugar de diferenciar entre diamantes, plataformas u otros personajes, se utiliza una interfaz común llamada `colision()`. Cada objeto colisionable implementa este método de manera específica, adaptándose a su comportamiento particular. Por ejemplo, mientras que `Caja` se desplaza a la par que el personaje con el que colisionó, un `Diamante` es recolectado por personajes de su mismo tipo. 

Además, utilizamos referencias comunes para varios objetos, como `esAtravesable` y el método `tipo()`. Estas características compartidas permiten tratar distintos elementos del juego de manera consistente.

El *polimorfismo* también se aplica a los objetos del juego, como los diamantes. Al utilizar una clase base llamada `Diamante` y subclases específicas como `DiamanteRojo` y `DiamanteAzul`, se pueden manejar los diamantes de manera genérica en el código. Sin embargo, las diferencias en su comportamiento, como su imagen o tipo, se implementan en cada subclase. Esto facilita la incorporación de nuevos tipos de diamantes sin necesidad de modificar el código central del juego. Ocurre lo mismo con `Personaje`, `Fireboy` y `Watergirl`. 

A partir de esto, apreciamos que el polimorfismo otorga flexibilidad y facilita la reutilización de código, además de tornarlo más extensible y fácil de mantener.

# Diagrama de Clases

El siguiente link los llevará a un documento de LucidChart, cada página en él es un diagrama diferente. Realizamos dos, uno mostrando las relaciones entre las distintas clases con Character y otro mostrando las relaciones con Level. 

[Link a los Diagramas de Clases](https://www.genome.gov/](https://lucid.app/lucidchart/e5a4730b-5a7a-4a26-9742-a7a7002d4637/edit?viewport_loc=-6225%2C-6225%2C13408%2C7723%2C0_0&invitationId=inv_f7be2161-30e6-4d28-b5ac-74f68b785bac)
