# Objetivo del Proyecto: TechNodes SV

Crear y evolucionar "TechNodes SV", una aplicación iOS nativa para que estudiantes y profesionales de ingeniería localicen talleres, fab-labs y componentes tecnológicos.

La aplicación utilizará Swift, UIKit y Storyboards. El flujo principal se organizará mediante un `UITabBarController`, conectando diferentes `UINavigationController` para cada módulo de la aplicación.

## Requisitos de Implementación
1. **Directorio (Networking):** Consumir un servicio web que liste los nodos tecnológicos utilizando exclusivamente `URLSession`. Toda llamada a la red debe documentar el manejo de errores.
2. **Mapa de Nodos (MapKit):** Integrar un mapa interactivo que solicite permisos de ubicación al usuario de forma clara (explicando por qué en el `Info.plist`), centrando el mapa en su posición y mostrando los nodos cercanos.
3. **Inventario Local (Core Data):** Permitir al usuario guardar un inventario local de componentes o nodos favoritos. Debe reflejar operaciones eficientes de creación, lectura, actualización y eliminación en la base de datos.
4. **Localización Universal:** Toda la aplicación debe soportar internacionalización desde el día uno, evitando cadenas de texto estáticas (hardcoded) en el código.