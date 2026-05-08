# Guía Operativa para la Codificación

- **Contexto Activo:** Antes de cada implementación, verifica el flujo de la aplicación. Todo debe alinearse al objetivo de "TechNodes SV".
- **Separación de Responsabilidades:** Si un ViewController tiene más de 200 líneas, sugiere inmediatamente extraer lógica a un ViewModel o un Service (NetworkService, LocationService, CoreDataService).
- **Gestión de Permisos:** Antes de invocar Core Location, verificar el estado de autorización (`CLLocationManager.authorizationStatus()`). Proveer rutas de fallback si el usuario deniega el permiso.
- **Separación MVVM:** Queda estrictamente prohibido incluir lógica de red o acceso directo a Core Data dentro de los `ViewControllers`. Utiliza Modelos, ViewModels y Capas de Servicio.
- **Asincronía Moderna:** Utiliza las características de concurrencia de Swift 5.0+ (`async`/`await`). Si usas delegados o *completion handlers*, asegura que las actualizaciones de la UI siempre se realicen en el `DispatchQueue.main`.
- **Refactorización Continua:** Extrae funciones largas en métodos más pequeños y descriptivos. El código debe ser autoexplicativo, priorizando el inglés para variables y clases, y español/inglés para el contenido visible mediante `Localizable.strings`.
- **Manejo de Errores UI:** Incluir siempre alertas claras para dar feedback al usuario ante problemas de red o permisos denegados.
- **Evitar Librerías Externas:** Todo debe resolverse con frameworks nativos de Apple para demostrar conocimiento profundo de la plataforma.
- **Diagramación:** Mantén la estructura de clases clara para facilitar la generación de diagramas de flujo y jerarquía de carpetas requeridos en la documentación técnica.