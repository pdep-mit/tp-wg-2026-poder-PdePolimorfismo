# Explicaciones teóricas

## Encapsulamiento: 

Se aplica mediante la definición de clases y objetos que agrupan información y comportamientos.

Por ejemplo: la clase Zoombie contiene propiedades como posición, vida y daño, además de métodos como avanzar(), recibirDaño(), comer() y morir(). De esta manera, los comportamientos relacionados con los zoombies se encuentran definidos y otros objetos pueden interactuar con ellos enviándoles mensajes, sin necesidad de conocer todos los detalles de su implementación.

## Delegación:

La delegación se utiliza cuando un objeto le encarga a otro la responsabilidad de realizar una tarea.

Por ejemplo: el método avanzar() en la clase zoombie delega el movimiento al objeto movimientoHaciaLaIzquierda, y el método avanzar() delega el movimiento en el objeto movimientoHaciaLaIzquierda. 

El zoombie no implementa directamente la lógica para calcular su nueva posición, sino que le envía el mensaje "mover(self)" al objeto encargado de realizar el movimiento. Esto hace que podamos reutilizar la misma lógica para todas las instancias de Zoombie.

Otro ejemplo es el método "recibirDaño(...)" que delega el procesamiento del daño al objeto "dañoInflingido", mediante el mensaje "procesarDaño(self, daño)"

## Polimorfismo: 

El método atacar de la clase Planta está pensado para referenciar un objeto encargado de ejecutar un ataque.

tipoDeAtaque.ejecutar(self, zoombie) le envía el mismo mensaje (ejecutar) a diferentes objetos y cada uno define qué hacer al recibirlo.

Esto permite que diferentes objetos respondan al mensaje ejecutar con comportamientos diferentes. 

# Diagramas

*Incluír al menos un diagrama para comunicar su solución*

Zoombie
   |
   | comer(planta)
   v
Planta
   |
   | recibirDaño(daño)
   v
dañoInflingido
   |
   | procesarDaño(planta, daño)
   v
Planta
   |
   | si corresponde
   v
morir()
   |
   v
game.removeVisual(self)