# TechNodes SV

TechNodes SV es una aplicación iOS nativa diseñada para que estudiantes y profesionales de ingeniería localicen talleres, fab-labs y proveedores de componentes tecnológicos en El Salvador. La navegación principal se organiza mediante un Tab Bar Controller programático.

## Funcionalidades principales
- Mapa interactivo de nodos tecnológicos usando `MapKit` y `Core Location`.
- Seguimiento de ubicación en tiempo real con la API moderna de `CLLocationUpdate`.
- Directorio global de servicios consumido de forma asíncrona mediante `URLSession`.
- Gestión de inventario local de componentes y favoritos con un CRUD completo en `Core Data`.
- Soporte total para internacionalización (Español e Inglés).
- Formateo dinámico de moneda, distancias y fechas según la región.

## Arquitectura y patrones
- **MVVM + Clean Architecture:** Separación estricta de responsabilidades en capas (Domain, Data, Presentation).
- **Capa de Dominio:** Entidades puras y Casos de Uso (Use Cases) para la lógica de negocio.
- **Capa de Datos:** Implementación del patrón Repositorio y Data Sources (Network, CoreData, Location).
- **Concurrencia Moderna:** Uso extensivo de `async/await` para evitar el bloqueo del hilo principal.
- **Reactividad:** Uso de `Combine` para la vinculación (binding) entre ViewModels y ViewControllers.

## Componentes clave
- `SceneDelegate`: Configurador central y punto de entrada con inyección de dependencias.
- `MapViewController` & `MapViewModel`: Gestión del mapa y lógica de localización.
- `DirectoryViewController` & `DirectoryViewModel`: Consumo y visualización de datos remotos.
- `InventoryViewController` & `InventoryViewModel`: Interfaz para el manejo de persistencia local.
- `NetworkService`: Cliente de red nativo con validación de estados HTTP.
- `CoreDataStack`: Configuración programática del modelo de persistencia.
- `LocationService`: Wrapper asíncrono moderno para servicios de ubicación.

## Interacción
- Selección de pines en el mapa para ver detalles del nodo tecnológico.
- Listado detallado de suministros y servicios en la pestaña de directorio.
- Botón "+" en el inventario para registrar componentes necesarios.
- Deslizar (Swipe-to-delete) para eliminar elementos del inventario local.
- Alertas de error y estados de carga (UIActivityIndicator) para feedback al usuario.

## Ejecución
1. Abre el archivo `TechNodesSV.xcodeproj` en Xcode.
2. Importa las carpetas del proyecto (`Core`, `Data`, `Domain`, `Presentation`) al navegador de Xcode si no están presentes.
3. Asegúrate de que el Target sea iOS 17.0 o superior.
4. Ejecuta la app en un simulador o dispositivo físico para comenzar a localizar nodos tecnológicos en El Salvador.
