# CONTEXTO DEL PROYECTO: TechNodes SV

## 1. Definición del Producto
**Nombre:** TechNodes SV
**Propósito:** Aplicación iOS nativa para localizar fab-labs, talleres de electrónica y proveedores de suministros tecnológicos en El Salvador. Diseñada para facilitar a estudiantes y profesionales la búsqueda de componentes (sensores, microcontroladores, motores) y espacios de trabajo.

## 2. Flujo de Navegación (UI/UX)
La aplicación se basa en un `UITabBarController` principal con tres pestañas, cada una embebida en un `UINavigationController`:
- **Tab 1: Mapa de Nodos (MapKit)**. Muestra pines con la ubicación de los talleres y tiendas.
- **Tab 2: Directorio (Lista)**. Un `UITableView` o `UICollectionView` que lista los nodos disponibles obtenidos desde la red.
- **Tab 3: Mi Inventario / Favoritos**. Lista de componentes a comprar o nodos guardados localmente.

## 3. Mapeo de Requisitos Técnicos (Nivel Excelente)
Este proyecto debe cumplir estrictamente con los siguientes requisitos funcionales:

* **Networking (Tab 2):** Se debe consumir un servicio web (API REST o JSON remoto) utilizando **exclusivamente `URLSession` asíncrono**. El hilo principal nunca debe bloquearse.
* **Persistencia (Tab 3):** Los favoritos y el inventario del usuario deben guardarse utilizando **Core Data (`NSPersistentContainer`)** con operaciones CRUD eficientes.
* **Localización (Tab 1):** Uso de **MapKit y Core Location** para mostrar la ubicación en tiempo real del usuario y centrar el mapa, manejando los permisos de privacidad correctamente.
* **Arquitectura:** Toda la app debe seguir el patrón **MVVM** o **Clean Architecture**. Queda estrictamente prohibido mezclar lógica de red o base de datos dentro de los ViewControllers.
* **Internacionalización (i18n):** Soporte dinámico para Español e Inglés mediante `Localizable.strings`. Fechas, distancias (km/millas) y monedas (USD) deben formatearse dinámicamente según la región.

## 4. Estado Actual
*(Actualiza esta sección a medida que el equipo avance)*
- [x] Inicialización del proyecto en Xcode 16.4.
- [ ] Configuración del TabBarController y Storyboards base.
- [ ] Implementación de los modelos de datos (Domain).
- [ ] Configuración del stack de Core Data.
- [ ] Integración de MapKit y permisos.