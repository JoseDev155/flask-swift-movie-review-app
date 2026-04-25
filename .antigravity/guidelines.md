# Guías de Código y Mejores Prácticas

## Python & Flask
1. **Estándar PEP 8:** Todo el código Python debe adherirse estrictamente al estándar PEP 8.
2. **Validación Dinámica:** Dado que Flask no impone un tipado estricto, NO es necesario agregar tipado estático forzado en todos lados (Type Hints), PERO es obligatorio realizar validaciones lógicas de los tipos de datos entrantes directamente dentro de los `services` o funciones antes de procesarlos.
3. **Manejo de Errores:** Evitar que la API devuelva errores genéricos 500. Las excepciones deben ser capturadas en los `services` y controladas en las `routes` devolviendo códigos HTTP semánticos (400, 401, 404).

## Swift & Flutter
1. **Asincronismo:** Todas las llamadas a la API de Flask deben realizarse de forma asíncrona (usando `async/await` en Swift y `Future`/`async` en Flutter) para no bloquear el hilo principal de la interfaz.
2. **Modularidad UI:** No crear pantallas de miles de líneas. Extraer componentes visuales repetitivos (tarjetas de películas, botones personalizados) en archivos separados.
3. **Manejo de Estados de Red:** Toda petición debe reflejar en la interfaz 3 estados lógicos: Cargando (Loading), Éxito (Success con datos) y Error (mostrando un Pop-up o mensaje claro al usuario).