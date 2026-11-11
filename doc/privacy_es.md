# Política de Privacidad de la Criba de Eratóstenes

*Última actualización: 31 de octubre de 2026*

---

## Privacidad por Diseño y Cero Datos Personales (Zero-PII)

La **Criba de Eratóstenes** ("la Aplicación") es un juego educativo
interactivo de matemáticas y demostración rítmica. Creemos firmemente en la
**Privacidad por Diseño**: no recopilamos información personal, no requerimos
cuentas de usuario, no rastreamos tu actividad en la web y no vendemos ni
monetizamos tus datos.

Esta aplicación ha sido creada para estudiantes, educadores y aficionados a
las matemáticas y la música de todas las edades.

---

## Información que NO Recopilamos

Para garantizar una arquitectura sin datos personales identificables
(Zero-PII):

* **Sin Cuentas de Usuario:** Nunca solicitamos ni almacenamos tu nombre,
  correo electrónico, número de teléfono o contraseña.

* **Sin Permisos ni Sensores del Dispositivo:** No accedemos a tu ubicación
  (GPS), cámara, micrófono, galería de fotos, contactos ni archivos locales.

* **Sin Rastreadores de Terceros ni Publicidad:** La aplicación está100% libre
  de anuncios y no contiene SDKs publicitarios, rastreadores de marketing ni
  cookies de seguimiento de sitios cruzados (sin Google Analytics, Facebook
  Pixel, etc.).

---

## Información Gestionada Durante el Juego

### Modo Individual (100% en el Dispositivo)

* Todas las estadísticas de juego en solitario—incluidos los récords
  históricos, las mejores rachas de números primos, la precisión de aciertos,
  los ajustes de tempo y las preferencias de audio—se guardan exclusivamente
  en el almacenamiento local de tu navegador (`localStorage` /
  `SharedPreferences` del dispositivo).

* Estos datos permanecen estrictamente en tu dispositivo y nunca se transmiten
  a ningún servidor.

### Modo Multijugador (Efímero y Autodestructivo)

Cuando creas o te unes a una sala multijugador:

* **Apodo:** Puedes ingresar un nombre de usuario temporal (por ejemplo,
  "Alicia" o "Jugador 1") para identificarte ante otros jugadores en la sala.

* **Estado de la Partida:** Las puntuaciones en vivo, las rachas, las
  predicciones de números primos y el código de sala de 4 caracteres se
  transmiten a través de una conexión cifrada WebSocket exclusivamente para
  sincronizar la partida en tiempo real.

* **Eliminación Automática:** Los datos de la sala multijugador son
  estrictamente temporales. Toda la sala y los registros de los jugadores se
  eliminan automáticamente de forma inmediata al finalizar la partida o tras
  10 minutos de inactividad.

---

## Infraestructura de Terceros

La Aplicación utiliza **Google Firebase** (Google LLC) para el alojamiento web
estático y la sincronización de mensajes multijugador en tiempo real:

* Google procesa los metadatos técnicos habituales de conexión (como
  direcciones IP y encabezados de enrutamiento) según sea necesario para
  establecer conexiones WebSocket cifradas y proteger el servicio frente a
  ataques de denegación de servicio.

* Para más información sobre las prácticas de privacidad de Google, consulta
  la [Política de Privacidad de Google](https://policies.google.com/privacy) .

---

## Seguro para Niños y el Aula (COPPA y FERPA)

La Aplicación estádiseñada para ser totalmente segura en entornos educativos y
para menores:

* Cumplimos con la **Ley de Protección de la Privacidad Infantil en Internet
  (COPPA)** y la **Ley de Privacidad y Derechos Educativos de la Familia
  (FERPA)**.

* Dado que la Aplicación no solicita, recopila ni almacena información
  personal de usuarios de ninguna edad, no requiere consentimiento parental y
  puede implementarse de manera segura en dispositivos escolares y centros
  educativos.

---

## Preguntas y Contacto

La Criba de Eratóstenes es un proyecto de código abierto. Si tienes alguna
pregunta, comentario o inquietud sobre esta Política de Privacidad:

* **Abre una Incidencia en GitHub:**
  [https://github.com/fredgc/sieve/issues](https://github.com/fredgc/sieve/issues)

* **Visita el Sitio Web del Proyecto:**
  [https://www.gchouse.org](https://www.gchouse.org)
