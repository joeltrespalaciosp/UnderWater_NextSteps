void mouseReleased() {
  volumenArrastrando = false;
}
// UnderWater: The Next Step

// Imágenes y constantes de UI
PImage iconPulpo, iconDelfin, iconEstrella, iconRobot, iconTortuga, iconCaballo;
PImage avatarPulpo, avatarDelfin, avatarEstrella, avatarRobot, avatarTortuga, avatarCaballo;
PImage imagenFondoTablero;
PImage imagenFondoMenu;
PImage imagenFondoPanelLateral; // Imagen de fondo para el panel lateral del tablero
PImage imagenFinJuego;
PImage[] imagenesCaraDado = new PImage[6];
// Fuente
PFont fuentePrincipal;
String nombreFuente = "Comic Sans MS";

// Colores para textos
color colorTituloPrincipal = color(0, 160, 140);         // Verde mar profundo
color colorTituloSecundario = color(40, 180, 150);       // Verde agua suave

color colorTextoInfo = color(200, 230, 220);             // Verde grisáceo muy claro (no blanco)
color colorTextoDetalle = color(185, 220, 210);          // Verde espuma claro
color colorTextoPositivo = color(170, 230, 200);         // Verde menta suave
color colorTextoNegativo = color(220, 120, 120);         // Coral apagado

color colorTextoAlerta = color(235, 225, 170);           // Arena suave
color colorTextoInput = color(200, 230, 220);            // Verde grisáceo claro
color colorTextoBoton = color(200, 230, 220);            // Verde claro suave
color colorTextoHUD = color(210, 240, 230);              // Verde casi pastel

// Colores para botones
color colorBotonNormal = color(30, 55, 50);               // Verde grisáceo profundo
color colorBotonHover = color(70, 150, 130);              // Verde agua iluminado
color colorBotonHoverAlternativo = color(60, 135, 120);   // Verde marino suave
color colorBotonNormalAlternativo = color(40, 70, 65);    // Verde grisáceo alternativo
color colorBotonConfirmar = color(90, 180, 130);          // Verde natural suave
color colorBotonCancelar = color(200, 80, 80);            // Coral apagado
color colorBotonVolver = color(140);                      // Gris verdoso neutro
color colorBotonSeleccionado = color(120, 200, 150);      // Verde claro acuático
color colorBotonRutaA = color(100, 170, 140);             // Verde agua pastel
color colorBotonRutaB = color(120, 210, 150);             // Verde menta acuático
color colorBotonSi = color(130, 210, 140);                // Verde claro suave
color colorBotonNo = color(220, 120, 120);                // Coral pastel
color colorBotonVolverKraken = color(10, 70, 60);         // Verde mar profundo
color colorBotonVolverTablero = color(20, 120, 90);       // Verde océano oscuro
color colorBotonVolverMenu = color(70, 150, 130);         // Verde agua brillante suave

// Estilo de botones
float radioEsquinasBoton = 12.0;          // Radio de las esquinas redondeadas (0 = esquinas cuadradas)
float grosorBordeBoton = 2.0;             // Grosor del borde de los botones (0 = sin borde)
color colorBordeBoton = color(255, 255, 255, 80); // Color del borde (con transparencia)
boolean mostrarSombraBoton = true;        // Mostrar sombra en los botones
float offsetSombraX = 2.0;                // Desplazamiento X de la sombra
float offsetSombraY = 2.0;                // Desplazamiento Y de la sombra
color colorSombraBoton = color(0, 0, 0, 100); // Color de la sombra (con transparencia)

// Audio
import processing.sound.*;
SoundFile musica;
SoundFile sfxClick;
SoundFile sfxDado;
SoundFile sfxAcierto;
SoundFile sfxFallo;
boolean sonidoActivo = true;
int btnMuteX = 16, btnMuteY = 16, btnMuteW = 36, btnMuteH = 36;
float volumenGeneral = 1.0;   // [0..1]
boolean volumenArrastrando = false;
int volX = 0, volY = 0, volW = 220, volH = 10; // se posiciona en el menú
PImage iconMusica;

void sonar(SoundFile fx) { if (sonidoActivo && fx != null) { fx.amp(volumenGeneral); fx.play(); } }
void dibujarAudio() {
  // Solo mostrar en el menú principal
  if (estadoPantalla != MENU) return;
  
  // Colocar el botón en esquina superior izquierda
  btnMuteX = 16;
  btnMuteY = 16;
  noStroke(); fill(0,0,0,120);
  rect(btnMuteX-3, btnMuteY-3, btnMuteW+6, btnMuteH+6, 8);
  boolean hov = mouseX>=btnMuteX && mouseX<=btnMuteX+btnMuteW && mouseY>=btnMuteY && mouseY<=btnMuteY+btnMuteH;
  if (hov) dibujarBotonEstilizado(btnMuteX, btnMuteY, btnMuteW, btnMuteH, colorBotonHover);
  else dibujarBotonEstilizado(btnMuteX, btnMuteY, btnMuteW, btnMuteH, colorBotonNormal);
  if (iconMusica != null) {
    image(iconMusica, btnMuteX + 4, btnMuteY + 4, btnMuteW - 8, btnMuteH - 8);
  } else {
    fill(255);
    triangle(btnMuteX+8, btnMuteY+14, btnMuteX+16, btnMuteY+14, btnMuteX+16, btnMuteY+22);
    rect(btnMuteX+16, btnMuteY+12, 8, 12);
  }
  if (!sonidoActivo) { stroke(255); strokeWeight(2); line(btnMuteX + 8, btnMuteY + 10, btnMuteX + btnMuteW - 8, btnMuteY + btnMuteH - 10); line(btnMuteX + btnMuteW - 8, btnMuteY + 10, btnMuteX + 8, btnMuteY + btnMuteH - 10); noStroke(); }
  
  // Dibujar barra de volumen al lado del botón (no abajo)
  volW = 140; volH = 10; // Barra más corta
  volX = btnMuteX + btnMuteW + 12; // Al lado del botón
  volY = btnMuteY + (btnMuteH - volH) / 2; // Centrada verticalmente con el botón
  // fondo barra
  noStroke(); fill(0,0,0,120);
  rect(volX - 6, volY - 6, volW + 12, volH + 12, 8);
  // barra
  fill(70, 70, 90);
  rect(volX, volY, volW, volH, 6);
  // relleno según volumen
  fill(colorBotonHover);
  rect(volX, volY, int(volumenGeneral * volW), volH, 6);
  // perilla
  int knobX = volX + int(volumenGeneral * volW) - 6;
  int knobY = volY - 6;
  fill(220);
  rect(knobX, knobY, 12, volH + 12, 6);
}
PImage imagenCasillaSospechosa, imagenCasillaSegura, imagenCasillaNeutral, imagenCasillaSalida, imagenCasillaPregunta, minijuegoTrivia, minijuegoOrden, minijuegoBomba;
PImage minijuegoNuevo1, minijuegoNuevo2, minijuegoNuevo3;
PImage fotoOscar, fotoLuis, fotoJoel, fotoPremioFeria;
int anchoPanelLateral = 276;
int tamanoCasilla     = 60;

int MENU = 0, JUEGO = 1, INSTRUCCIONES = 2, ELEGIR_JUGADORES = 3, SELECCION_AVATAR = 4, JUEGOS_LIBRES = 5, FINAL_JUEGO = 9;

String[] etiquetasMenuPrincipal = { "Jugar", "Juegos Libres", "Instrucciones", "Créditos", "Salir" };
int anchoBotonMenu = 280, altoBotonMenu = 56, espacioEntreBotonesMenu = 16;
int indiceBotonHover = -1;
int i;

char[] bufferRondas = new char[50];  
int    tamBufferRondas = 0;          
boolean campoRondasActivo = false;  
String  mensajeRondas = "";
boolean hayErrorRondas = false;      
int rondasMin = 1;
int rondasMax = 100;

// Tablero y rutas
int cantidadCasillas;
int[][] casillas;
int[][] vecinos;

// Jugadores y estado del juego
PImage[] imagenesJugador;
int cantidadJugadores;
int[] posicionJugador;
float[] puntosJugador;
color[] colorJugador = {#FFD700, #00CFFF, #FF7F50, #A0FF70};

int estadoPantalla = MENU;
int jugadoresSeleccionados;
int jugadorActivo = 0;
boolean desdeJuegosLibres = false; // Indica si se accedió a un minijuego desde el menú de juegos libres
int submenuInstrucciones = -1; // -1 = menú principal, 0-9 = submenú seleccionado
boolean mostrarCreditos = false; // Para mostrar/ocultar créditos

// Selección de avatares
String[] nombresAv = { "Pulpo", "Delfín", "Estrella", "Robot", "Tortuga", "Caballo de Mar" };
PImage[] spritesAv = new PImage[6];
boolean[] tomadoAv = new boolean[6];
int[] eleccionJugador;
int previewIdx = -1;

int rondasTotales;
int rondaActual = 1;
boolean juegoTerminado = false;
int tiempoFinJuego = 0;
boolean esperandoFinJuego = false;
boolean iniciarFinDesdeMinijuego = false;

int    caraDado = 0;
int    pasosRestantes = 0;
boolean animacionEnCurso = false;
int    ultimoPasoMs = 0;
int    intervaloPasoMs = 400; // Intervalo entre cada movimiento de casilla (aumentado para mejor visibilidad)

boolean esperandoEleccionRuta = false;
int[]   opcionesRuta = new int[2];
int     totalOpcionesRuta = 0;

boolean finTurnoPendiente = false;
boolean efectoCasillaAplicado = false;

String mensaje = "";
int    mostrarMensajeHastaMs = 0;
color  colorTexto = #FFFFFF;

boolean preguntaVisible = false;
String  textoPreguntaActual = "";
int indicePreguntaActual = 0;
// Preguntas de permisos (casillas de pregunta)
String[] preguntasPermisos = {
  // 🔴 10 preguntas de apps o páginas sospechosas (restan si dices "Si")
  "Una app llamada 'Cleaner Pro' te pide acceso a tus contraseñas guardadas.",
  "Al entrar a una página extraña en Google te aparece un aviso: 'Tu celular está infectado, descarga esta app para limpiarlo'.",
  "Un sitio web de descargas te pide permiso para enviar notificaciones aunque no lo necesitas.",
  "Una app de linterna solicita permiso para acceder a tu cámara y contactos.",
  "Una extensión en Chrome llamada 'Fast Download' te pide leer todos tus datos en los sitios web que visitas.",
  "Aparece una alerta en Safari que dice: 'Tu iPhone tiene 5 virus, presiona Aceptar para eliminarlos'.",
  "Una app llamada 'Battery Saver' solicita acceso completo al almacenamiento.",
  "Una página te pide desactivar el antivirus para continuar la descarga.",
  "Una app desconocida llamada 'Photo Editor Pro+' te pide permiso para grabar audio.",
  "Un mensaje en un sitio de sorteos dice: 'Concede permisos para reclamar tu premio'.",

  // 🟢 10 preguntas de apps seguras o permisos normales (suman si dices "Si")
  "Google Maps te pide acceso a tu ubicación para mostrarte rutas en tiempo real.",
  "Zoom te pide permiso para usar tu micrófono durante una videollamada.",
  "WhatsApp te pide acceso a tu cámara para enviar una foto.",
  "Drive te pide permiso para acceder a tus archivos guardados en la nube.",
  "Spotify te pide permiso para acceder a tus canciones descargadas.",
  "Uber te pide acceso a tu ubicación para buscar el conductor más cercano.",
  "Google Calendar te pide permiso para acceder a tus eventos y recordatorios.",
  "Teams te pide acceso al micrófono para participar en una reunión.",
  "Instagram te pide permiso para acceder a tus fotos para publicarlas.",
  "YouTube te pide permiso para acceder a tu historial de reproducción y recomendaciones."
};

int[] efectoSiPermitir = {
  -1, // Cleaner Pro (malo)
  -1, // Pagina falsa "celular infectado" (malo)
  -1, // Notificaciones innecesarias (malo)
  -1, // Linterna con acceso a cámara (malo)
  -1, // Extensión Chrome sospechosa (malo)
  -1, // Alerta falsa Safari (malo)
  -1, // Battery Saver (malo)
  -1, // Desactivar antivirus (malo)
  -1, // Photo Editor Pro+ (malo)
  -1, // Sitio de sorteos (malo)
  1,  // Google Maps (bueno)
  1,  // Zoom (bueno)
  1,  // WhatsApp (bueno)
  1,  // Drive (bueno)
  1,  // Spotify (bueno)
  1,  // Uber (bueno)
  1,  // Google Calendar (bueno)
  1,  // Teams (bueno)
  1,  // Instagram (bueno)
  1   // YouTube (bueno)
};


// === MINIJUEGO 1: TRIVIAS DEL ABISMO ===
PImage fondoTrivia;
int JUEGO1 = 10;
boolean teclaTomada = false;
char teclaAnterior;
int tiempoTeclaAnteriorMs = 0;
int retardoTeclaMs = 120;  // milisegundos entre repeticiones permitidas

// Variables del minijuego
int    preguntaActualTrivia = 0;   // índice dentro del arreglo (ya barajado por mezclarPreguntasTrivia())
int    preguntasContestadas = 0;   // cuántas preguntas ya fueron respondidas (máx 5)
int    preguntasMaxTrivia   = 3;   // tope de preguntas por partida
int    puntajeTrivia        = 0;   // acumulado local del minijuego (positivo o negativo)
boolean juegoTerminadoTrivia   = false;
boolean botonesTriviaVisibles  = false; // aparecen tras responder (bien o mal)
boolean campoActivoTrivia      = true;  // si se aceptan teclas A/B/C/ENTER
String  respuestaJugador       = "";
String  mensajeInput           = "";

// Para evitar repeticiones
int indiceParesApps = 0;  // Índice actual en el array mezclado de paresApps
int indiceFrasesKraken = 0;  // Índice actual en el array mezclado de frasesKraken

// Preguntas del minijuego Trivias del Abismo
String[][] preguntasTrivia = new String[][]{
  // 💻 Preguntas originales del minijuego
  {"¿Qué tipo de archivo puede contener virus al ejecutarse?", "A) .jpg", "B) .exe", "C) .txt", "B"},
  {"¿Qué es 'malware'?", "A) Software malicioso", "B) Un antivirus famoso", "C) Un juego en línea", "A"},
  {"¿Qué es el 'phishing'?", "A) Cambiar tu contraseña", "B) Robo de info con engaños", "C) Copia de seguridad", "B"},
  {"¿Qué app necesita micrófono para videollamadas?", "A) Netflix", "B) Zoom", "C) Pinterest", "B"},
  {"¿Qué acción NUNCA debes hacer en correos sospechosos?", "A) Eliminarlos", "B) Abrir enlaces", "C) Marcarlos spam", "B"},
  {"Una app de linterna te pide cámara y contactos. ¿Qué tan sospechoso es?", "A) Normal", "B) Sospechoso", "C) Da igual", "B"},
  {"¿Cuál app legítima requiere ubicación para funcionar?", "A) Spotify", "B) Uber", "C) PicsArt", "B"},
  {"Si una web dice 'tienes 5 virus, descarga esto', lo correcto es…", "A) Descargar lo sugerido", "B) Cerrar la página", "C) Escribir mis datos", "B"},
  {"¿Qué archivo puede ejecutar programas ocultos?", "A) .pdf", "B) .exe", "C) .mp3", "B"},
  {"¿Qué debes revisar antes de instalar una app?", "A) Solo el nombre", "B) Opiniones y permisos", "C) Color del ícono", "B"},
  {"¿Qué app es segura para almacenar archivos?", "A) FreeDownloads", "B) Google Drive", "C) APKMirror aleatorio", "B"},
  {"¿Qué implica dejar el GPS siempre activo?", "A) Más seguridad", "B) Batería/posible rastreo", "C) Acelera el celular", "B"},
  {"¿Qué extensión es sospechosa si pide 'leer todos tus datos'?", "A) AdBlock", "B) Fast Download", "C) Grammarly", "B"},
  {"¿Qué permiso es innecesario en una app de notas?", "A) Almacenamiento", "B) Micrófono", "C) Escritura de texto", "B"},
  {"Instalar apps fuera de la tienda oficial puede…", "A) Ser más seguro", "B) Aumentar rendimiento", "C) Traer malware", "C"},
  {"Una app te pide \"tus contraseñas\". Debes…", "A) Darlas rápido", "B) No darlas", "C) Guardarlas en notas", "B"},
  {"¿Qué es un parche de seguridad?", "A) Fondo nuevo", "B) Cambio de color", "C) Corrección de fallas", "C"},
  {"¿Qué app pide ubicación para rutas?", "A) CapCut", "B) Google Maps", "C) TikTok", "B"},
  {"¿Qué app pediría cámara legítimamente?", "A) Calculadora", "B) Videollamada", "C) Reloj", "B"},
  {"¿Qué indicador sugiere app sospechosa?", "A) Pide pocos permisos", "B) Promete 'limpiar virus' milagros", "C) Tiene reseñas positivas", "B"},
  {"La autenticación de dos factores (2FA) sirve para…", "A) Iniciar sesión sin contraseña", "B) Añadir una capa extra de verificación", "C) Acelerar el Wi-Fi", "B"},
  {"¿Cuál es una contraseña más segura?", "A) qwerty", "B) 123456", "C) Frase-larga_conSimbolos2025", "C"},
  {"Si recibes un link acortado desconocido…", "A) Lo abro para ver", "B) Lo verifico antes o lo ignoro", "C) Lo reenvío a todos", "B"},
  {"Un adjunto .pdf de remitente dudoso…", "A) Siempre es seguro", "B) Puede incluir scripts maliciosos", "C) Se ejecuta solo en Mac", "B"},
  {"Un juego pide permiso a SMS y llamadas…", "A) Normal en cualquier juego", "B) Sospechoso: podría abusar", "C) Requisito de Play Store", "B"},
  {"Para comprobar si un sitio es legítimo…", "A) Solo miro el logo", "B) Reviso URL/https/certificado", "C) Si carga rápido, es real", "B"},
  {"Un mensaje de 'premio' exige pago/envío de datos…", "A) Es una promo real", "B) Es estafa probable", "C) Es actualización de sistema", "B"},
  {"¿Cuál es buena práctica con contraseñas?", "A) Repetir la misma en todo", "B) Gestor de contraseñas", "C) Anotarlas en chat", "B"},
  {"Si tu app bancaria solicita actualizar por APK externa…", "A) Instalo esa APK", "B) Actualizo solo por tienda oficial", "C) Ignoro todas las actualizaciones", "B"},
  {"Un QR pegado sobre el original en un local…", "A) Es normal", "B) Podría ser sustitución maliciosa", "C) Acelera el pago", "B"},
  {"'WhatsApp Gold' y clones similares…", "A) Versión premium oficial", "B) Posibles apps trampa", "C) Solo cambian colores", "B"},
  {"Un correo dice 'verifica tu cuenta YA' con tono urgente…", "A) Soporte auténtico", "B) Señal típica de phishing", "C) Política de privacidad", "B"},

  //  NUEVAS 20 PREGUNTAS GENERALES DE CIBERSEGURIDAD Y BLOCKCHAIN
  {"¿Qué significa la sigla PUA?", "A) Programa de uso automático", "B) Aplicación potencialmente no deseada", "C) Plataforma universal Android", "B"},
  {"¿Qué sistema operativo usan la mayoría de las aplicaciones móviles?", "A) iOS", "B) Android", "C) Windows", "B"},
  {"¿Cuál es el propósito principal de los sistemas de seguridad en las aplicaciones?", "A) Cambiar el diseño visual", "B) Detectar apps sospechosas o maliciosas", "C) Aumentar la velocidad del celular", "B"},
  {"¿Qué tecnología permite registrar información de forma segura y transparente?", "A) Bluetooth", "B) Blockchain", "C) Wi-Fi", "B"},
  {"¿Qué se analiza para saber si una app es peligrosa?", "A) Su icono y color", "B) Los permisos que solicita y su comportamiento", "C) El tamaño del archivo", "B"},
  {"¿Qué deberías hacer si una app pide permisos innecesarios?", "A) Instalarla sin problema", "B) Revisar o no instalarla", "C) Ignorar los permisos", "B"},
  {"¿Qué ventaja ofrece blockchain en la seguridad digital?", "A) Menor consumo de batería", "B) Mayor transparencia y protección de datos", "C) Permite ocultar archivos", "B"},
  {"¿Qué es la esteganografía?", "A) Una técnica para borrar archivos", "B) El arte de ocultar información dentro de otra", "C) Un método de encriptación", "B"},
  {"¿Cómo se llama la ciencia que detecta información oculta?", "A) Criptografía", "B) Estegoanálisis", "C) Ciberanálisis", "B"},
  {"¿Qué tipo de archivos pueden usarse para esconder datos?", "A) Solo texto", "B) Cualquier archivo digital", "C) Solo videos", "B"},
  {"¿Qué son las redes sociales?", "A) Programas de edición de fotos", "B) Comunidades en línea donde las personas comparten e interactúan", "C) Aplicaciones para jugar", "B"},
  {"¿Qué problema común existe en las redes sociales?", "A) Falta de colores llamativos", "B) Falta de privacidad y anonimato", "C) Lentitud en los mensajes", "B"},
  {"¿Qué hace una herramienta de análisis de contenido web?", "A) Mejora los colores del sitio", "B) Examina información dinámica para detectar riesgos", "C) Cambia contraseñas", "B"},
  {"¿Qué lenguaje se usa con frecuencia para desarrollar herramientas de seguridad digital?", "A) HTML", "B) Java", "C) Excel", "B"},
  {"¿Qué significa LSB (Least Significant Bit)?", "A) Tipo de formato de audio", "B) Método para ocultar datos en los bits menos importantes de una imagen", "C) Modo de compresión de texto", "B"},
  {"¿Qué es un captcha?", "A) Un tipo de virus", "B) Una prueba para distinguir humanos de programas automáticos", "C) Un cifrado de contraseñas", "B"},
  {"¿Qué relación tiene el análisis de datos con la ciberseguridad?", "A) Aumenta la velocidad del internet", "B) Permite detectar amenazas o fugas de información", "C) Reduce el tamaño de los archivos", "B"},
  {"¿Qué ventaja tiene usar herramientas de detección en línea?", "A) Mejoran el diseño de la página", "B) Previenen ataques o archivos ocultos", "C) Hacen más lentas las búsquedas", "B"},
  {"¿Qué beneficio obtiene un usuario al usar apps seguras?", "A) Más espacio en el celular", "B) Protección de datos personales", "C) Juegos gratuitos", "B"},
  {"¿Cuál es el objetivo principal de la ciberseguridad?", "A) Crear nuevas redes sociales", "B) Proteger la información y mantener la confianza digital", "C) Borrar los historiales del navegador", "B"},
  
  // 50 PREGUNTAS ADICIONALES DE CIBERSEGURIDAD Y APPS
  {"¿Qué es un firewall?", "A) Un muro de fuego físico", "B) Sistema que bloquea accesos no autorizados", "C) Un tipo de antivirus", "B"},
  {"¿Qué significa HTTPS?", "A) Hipertexto temporal", "B) Protocolo seguro de transferencia", "C) Herramienta de búsqueda", "B"},
  {"¿Qué es un VPN?", "A) Video player network", "B) Red privada virtual para mayor seguridad", "C) Virus protection network", "B"},
  {"¿Qué hace un antivirus?", "A) Acelera el internet", "B) Detecta y elimina malware", "C) Mejora la señal WiFi", "B"},
  {"¿Qué es el doxxing?", "A) Hacer copias de seguridad", "B) Publicar información privada de alguien", "C) Encriptar archivos", "B"},
  {"¿Qué es el ransomware?", "A) Protección de archivos", "B) Software que secuestra datos pidiendo rescate", "C) Sistema de respaldo", "B"},
  {"¿Qué es un botnet?", "A) Red de amigos en línea", "B) Red de dispositivos infectados controlados remotamente", "C) Sistema de chat", "B"},
  {"¿Qué es el spoofing?", "A) Mejorar velocidad", "B) Suplantar identidad o dirección", "C) Comprimir archivos", "B"},
  {"¿Qué es un keylogger?", "A) Teclado mejorado", "B) Programa que registra las teclas presionadas", "C) Sistema de escritura", "B"},
  {"¿Qué es el smishing?", "A) Mensajería rápida", "B) Phishing por SMS", "C) Sistema de notificaciones", "B"},
  {"¿Qué es un troyano?", "A) Antivirus potente", "B) Malware disfrazado de software legítimo", "C) Sistema operativo", "B"},
  {"¿Qué es el vishing?", "A) Video chat seguro", "B) Phishing por llamada telefónica", "C) Sistema de voz", "B"},
  {"¿Qué es un gusano informático?", "A) Antivirus natural", "B) Malware que se replica automáticamente", "C) Sistema de limpieza", "B"},
  {"¿Qué es el steganography?", "A) Encriptación básica", "B) Ocultar información dentro de otros archivos", "C) Compresión de datos", "B"},
  {"¿Qué es un zero-day?", "A) Día sin internet", "B) Vulnerabilidad desconocida sin parche", "C) Actualización nueva", "B"},
  {"¿Qué es el deepfake?", "A) Video de alta calidad", "B) Contenido falso generado por IA", "C) Sistema de edición", "B"},
  {"¿Qué es el catfishing?", "A) Pescar información", "B) Crear perfil falso en redes sociales", "C) Sistema de búsqueda", "B"},
  {"¿Qué es el doxing?", "A) Hacer backup", "B) Exponer información personal de alguien", "C) Encriptar datos", "B"},
  {"¿Qué es un honeypot?", "A) Sistema de almacenamiento", "B) Trampa para atraer atacantes", "C) Red segura", "B"},
  {"¿Qué es el MITM (Man in the Middle)?", "A) Ataque interceptando comunicación", "B) Sistema de mensajería", "C) Protocolo seguro", "A"},
  {"¿Qué es el SQL injection?", "A) Ataque a bases de datos", "B) Sistema de consultas", "C) Lenguaje de programación", "A"},
  {"¿Qué es el XSS (Cross-Site Scripting)?", "A) Inyectar scripts maliciosos en páginas web", "B) Sistema de estilos", "C) Protocolo de red", "A"},
  {"¿Qué es el DDoS?", "A) Ataque de denegación de servicio", "B) Sistema de distribución", "C) Protocolo de datos", "A"},
  {"¿Qué es el brute force?", "A) Ataque probando todas las contraseñas posibles", "B) Fuerza de seguridad", "C) Sistema de encriptación", "A"},
  {"¿Qué es el social engineering?", "A) Manipular personas para obtener información", "B) Ingeniería social", "C) Sistema de redes", "A"},
  {"¿Qué es el credential stuffing?", "A) Usar credenciales robadas en múltiples sitios", "B) Almacenar contraseñas", "C) Sistema de autenticación", "A"},
  {"¿Qué es el clickjacking?", "A) Engañar para hacer clic en algo oculto", "B) Sistema de navegación", "C) Protección de clics", "A"},
  {"¿Qué es el typosquatting?", "A) Usar dominios similares con errores tipográficos", "B) Sistema de escritura", "C) Corrector ortográfico", "A"},
  {"¿Qué es el watering hole?", "A) Infectar sitios que visitan objetivos específicos", "B) Sistema de riego", "C) Protección de sitios", "A"},
  {"¿Qué es el APT (Advanced Persistent Threat)?", "A) Ataque sofisticado y prolongado", "B) Sistema avanzado", "C) Protocolo temporal", "A"},
  {"¿Qué es el cryptojacking?", "A) Usar dispositivos para minar criptomonedas sin permiso", "B) Sistema de encriptación", "C) Monedero digital", "A"},
  {"¿Qué es el formjacking?", "A) Robar datos de formularios web", "B) Sistema de formularios", "C) Protección de datos", "A"},
  {"¿Qué es el magecart?", "A) Ataque robando datos de tarjetas en sitios de compra", "B) Carrito de compras", "C) Sistema de pago", "A"},
  {"¿Qué es el SIM swapping?", "A) Transferir número de teléfono a otra SIM", "B) Cambiar de operador", "C) Actualizar SIM", "A"},
  {"¿Qué es el juice jacking?", "A) Robar datos al cargar en puertos USB públicos", "B) Cargador rápido", "C) Sistema de energía", "A"},
  {"¿Qué es el quishing?", "A) Phishing usando códigos QR", "B) Sistema de códigos", "C) Escáner QR", "A"},
  {"¿Qué es el pretexting?", "A) Crear escenario falso para obtener información", "B) Sistema de texto", "C) Protección de datos", "A"},
  {"¿Qué es el baiting?", "A) Ofrecer algo atractivo para infectar", "B) Sistema de cebo", "C) Protección anti-spam", "A"},
  {"¿Qué es el tailgating?", "A) Seguir a alguien autorizado para entrar", "B) Sistema de seguimiento", "C) Protección física", "A"},
  {"¿Qué es el shoulder surfing?", "A) Observar pantalla o teclado de otra persona", "B) Navegación visual", "C) Sistema de monitoreo", "A"},
  {"¿Qué es el dumpster diving?", "A) Buscar información en basura física o digital", "B) Sistema de reciclaje", "C) Limpieza de datos", "A"},
  {"¿Qué es el pretexting digital?", "A) Inventar historia falsa para obtener datos", "B) Sistema de texto", "C) Protección de identidad", "A"},
  {"¿Qué es el whaling?", "A) Phishing dirigido a ejecutivos importantes", "B) Sistema de caza", "C) Protección empresarial", "A"},
  {"¿Qué es el spear phishing?", "A) Phishing dirigido a persona específica", "B) Sistema de lanzamiento", "C) Protección personal", "A"},
  {"¿Qué es el pharming?", "A) Redirigir tráfico a sitio falso", "B) Sistema de granjas", "C) Protección de DNS", "A"},
  {"¿Qué es el evil twin?", "A) Red WiFi falsa que imita una legítima", "B) Red gemela", "C) Sistema de conexión", "A"},
  {"¿Qué es el wardriving?", "A) Buscar redes WiFi vulnerables", "B) Conducción segura", "C) Sistema de navegación", "A"},
  {"¿Qué es el bluejacking?", "A) Enviar mensajes no solicitados por Bluetooth", "B) Sistema Bluetooth", "C) Protección inalámbrica", "A"},
  {"¿Qué es el bluesnarfing?", "A) Robar datos vía Bluetooth", "B) Sistema de conexión", "C) Protección Bluetooth", "A"},
  {"¿Qué es el packet sniffing?", "A) Interceptar y analizar paquetes de red", "B) Sistema de paquetes", "C) Protección de red", "A"},
  {"¿Qué es el session hijacking?", "A) Secuestrar sesión activa de usuario", "B) Sistema de sesiones", "C) Protección de login", "A"},
  {"¿Qué es el DNS poisoning?", "A) Corromper caché DNS para redirigir tráfico", "B) Sistema DNS", "C) Protección de dominio", "A"}
};


int[] valoresPuntos = {1, 1, 2};

// Dibuja la pantalla de trivia
void dibujarTrivia() {
  if (fondoTrivia != null) image(fondoTrivia, 0, 0, width, height);
  else background(10, 30, 70);

  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(40); // Título más grande
  text("Trivias del Abismo", width / 2, 80);

  if (!juegoTerminadoTrivia) {
    // Encabezado y pregunta actual
    fill(colorTituloSecundario);
    textSize(22);
    int numeroAMostrar = min(preguntasContestadas + 1, preguntasMaxTrivia);
    text("Pregunta " + numeroAMostrar + " de " + preguntasMaxTrivia, width / 2, 130);

    // Enunciado + opciones
    fill(colorTextoInfo);
    textAlign(CENTER, CENTER);
    text(preguntasTrivia[preguntaActualTrivia][0], width / 2, 200);

    for (int i = 1; i <= 3; i++) {
      fill(colorTextoDetalle);
      textSize(20);
      text(preguntasTrivia[preguntaActualTrivia][i], width / 2, 240 + i * 36);
    }

    // Campo de entrada
    fill(colorTextoAlerta);
    text("Escribe A, B o C y presiona ENTER", width / 2, 420);
    fill(0, 100);
    rect(width / 2 - 100, 440, 200, 44, 8);
    fill(colorTextoInput);
    textSize(22);
    text(respuestaJugador, width / 2, 462);
    fill(colorTextoNegativo);
    text(mensajeInput, width / 2, 510);
    fill(colorTextoPositivo);
    text("Puntaje actual (trivia): " + puntajeTrivia, width / 2, 560);

    // Botones Seguir / Salir (solo tras responder)
    if (botonesTriviaVisibles) {
      // Congelar entrada de teclado mientras estén visibles
      float bx = width / 2 - 210;
      float by = 600;
      float bw = 180;
      float bh = 50;

      dibujarBotonEstilizado(bx, by, bw, bh, colorBotonHover);
      fill(colorTextoBoton);
      textSize(20);
      text("Seguir", bx + bw / 2, by + bh / 2);

      dibujarBotonEstilizado(bx + 240, by, bw, bh, colorBotonConfirmar);
      fill(colorTextoBoton);
      text("Salir", bx + 240 + bw / 2, by + bh / 2);
    }
  }
}

// Procesa la respuesta de la trivia
void procesarRespuestaTrivia() {
  // Normalizar a una sola letra mayúscula
  String r = respuestaJugador.trim();
  if (r.length() != 1) {
    mensajeInput = "Solo se permite A, B o C.";
    return;
  }
  String correcta = preguntasTrivia[preguntaActualTrivia][4]; // "A","B","C"

  // Puntaje por esta pregunta
  int delta = 0;
  if (r.equals(correcta)) {
    // rotativo según cuántas ya respondió (0..)
    delta = valoresPuntos[preguntasContestadas % valoresPuntos.length];
    puntajeTrivia += delta;
    mostrarMensaje("¡Correcto! +" + delta, 1200);
    sonar(sfxAcierto);
  } else {
    puntajeTrivia -= 2;
    mostrarMensaje("Respuesta incorrecta (-2)", 1200);
    sonar(sfxFallo);
  }

  // Ya se respondió esta pregunta
  preguntasContestadas++;

  // Preparar UI para decisión (antes de pasar a la siguiente)
  botonesTriviaVisibles = true;
  campoActivoTrivia = false;  // congelar entrada hasta que haga clic
  mensajeInput = "";
}

// Maneja los clicks en la trivia
void manejarClicksTrivia() {
  if (estadoPantalla == JUEGO1 && botonesTriviaVisibles && !juegoTerminadoTrivia) {
    float bx = width / 2 - 210;
    float by = 600;
    float bw = 180;
    float bh = 50;

    boolean clickSeguir = mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh;
    boolean clickSalir  = mouseX >= (bx + 240) && mouseX <= (bx + 240 + bw) && mouseY >= by && mouseY <= by + bh;

    if (clickSeguir) {
      // Si ya alcanzó el tope de 5 preguntas, terminar
      if (preguntasContestadas >= preguntasMaxTrivia) {
        modificarPuntosJugador(puntajeTrivia);
        mostrarMensaje("¡Trivia completada! +" + puntajeTrivia, 1600);
        // Reset y volver
        juegoTerminadoTrivia = true;
        if (desdeJuegosLibres) {
          estadoPantalla = JUEGOS_LIBRES;
          desdeJuegosLibres = false;
        } else {
          estadoPantalla = JUEGO;
          finTurnoPendiente = true;
          efectoCasillaAplicado = true;
        }
        // Limpieza local
        preguntaActualTrivia = 0;
        preguntasContestadas = 0;
        respuestaJugador = "";
        botonesTriviaVisibles = false;
        campoActivoTrivia = true;
      } else {
        // Cargar siguiente pregunta (el arreglo ya está mezclado en setup)
        preguntaActualTrivia++;
        // Seguridad: si nos pasamos del tamaño, ciclar desde 0
        if (preguntaActualTrivia >= preguntasTrivia.length) preguntaActualTrivia = 0;

        // Rehabilitar entrada
        respuestaJugador = "";
        mensajeInput = "";
        botonesTriviaVisibles = false;
        campoActivoTrivia = true;
      }
    } else if (clickSalir) {
      // Sumar lo acumulado (positivo o negativo) y salir
      modificarPuntosJugador(puntajeTrivia);
      mostrarMensaje("Trivia finalizada: " + (puntajeTrivia >= 0 ? "+" : "") + puntajeTrivia, 1400);

      // Reset y volver
      juegoTerminadoTrivia = true;
      if (desdeJuegosLibres) {
        estadoPantalla = JUEGOS_LIBRES;
        desdeJuegosLibres = false;
      } else {
        estadoPantalla = JUEGO;
        finTurnoPendiente = true;
        efectoCasillaAplicado = true;
      }

      // Limpieza local
      preguntaActualTrivia = 0;
      preguntasContestadas = 0;
      respuestaJugador = "";
      botonesTriviaVisibles = false;
      campoActivoTrivia = true;
    }
  }
}

// Maneja las teclas en la trivia
void manejarTeclasTrivia() {
  if (estadoPantalla == JUEGO1 && !juegoTerminadoTrivia) {
    // Mientras estén visibles los botones, no aceptar nuevas letras
    if (!campoActivoTrivia) return;

    if (key == BACKSPACE && respuestaJugador.length() > 0) {
      respuestaJugador = respuestaJugador.substring(0, respuestaJugador.length() - 1);
    } else if (key == ENTER || key == RETURN) {
      // Aceptar solo A/B/C
      if (respuestaJugador.equals("A") || respuestaJugador.equals("B") || respuestaJugador.equals("C")) {
        procesarRespuestaTrivia();
      } else {
        mensajeInput = "Solo se permiten A, B o C.";
      }
    } else if (key >= 65 && key <= 90) {
      // Solo letras mayúsculas y solo 1 carácter
      respuestaJugador = str(char(key));
      mensajeInput = "";
    }
  }
}

// === MINIJUEGO 2: CORRIENTE DESORDENADA ===
int JUEGO2 = 11;
PImage fondoOrden;
String[][] paresApps = {
  {"tiktok","camscanner"},
  {"whatsapp","facebook"},
  {"telegram","instagram"},
  {"camscanner","whatsapp"},
  {"facebook","tiktok"},
  {"xender", "snapchat"},
  {"truecaller", "imo"},
  {"shareit", "kwai"},
  {"wechat", "zedge"},
  {"bigo live", "uc browser"},
  {"pinterest", "vigo video"},
  {"zoom", "likee"},
  {"skype", "messenger"},
  {"discord", "line"},
  {"yubo", "aloha browser"}
};

String appCorrectA = "";
String appCorrectB = "";
String appScrambledA = "";
String appScrambledB = "";
String inputOrdenA = "";
String inputOrdenB = "";
boolean campoActivoOrdenA = false;
boolean campoActivoOrdenB = false;
int seleccionComparacion = -1;
boolean juegoTerminadoOrden = false;
String mensajeOrden = "";
boolean mostrarResultadoOrden = false;

// === MINIJUEGO 3: LA LETRA ENVENENADA DEL KRAKEN ===
int JUEGO3 = 12;
PImage fondoKraken;
String[] frasesKraken = {
  "camscanner", "whatsapp plus", "troyano bancario", "spyware", "adware", "phishing",
  "apk dudosa", "fuera de play store", "permiso de ubicacion", "lectura de contactos",
  "grabacion secreta", "keylogger", "rootkit", "malware", "ransomware",
  // 50 PALABRAS ADICIONALES RELACIONADAS CON CIBERSEGURIDAD
  "virus informatico", "gusano digital", "troyano oculto", "botnet maliciosa", "ransomware bloqueador",
  "phishing engañoso", "spyware oculto", "adware intrusivo", "rootkit profundo", "keylogger secreto",
  "malware avanzado", "virus troyano", "gusano replicante", "botnet controlada", "ransomware encriptador",
  "phishing suplantador", "spyware rastreador", "adware publicitario", "rootkit persistente", "keylogger silencioso",
  "malware polimorfico", "virus residente", "gusano de red", "botnet zombie", "ransomware destructivo",
  "phishing dirigido", "spyware keylogger", "adware agresivo", "rootkit bootkit", "keylogger hardware",
  "malware sin archivo", "virus macro", "gusano de correo", "botnet distribuida", "ransomware doble",
  "phishing masivo", "spyware remoto", "adware persistente", "rootkit firmware", "keylogger software",
  "malware multiplataforma", "virus de boot", "gusano de internet", "botnet global", "ransomware criptografico",
  "phishing corporativo", "spyware movil", "adware browser", "rootkit kernel", "keylogger movil",
  "malware evasivo", "virus polimorfico", "gusano de archivo", "botnet iot", "ransomware wannacry"
};

boolean oponenteElegido = false;
int jugadorOponente = -1;

String fraseKraken = "";
char letraInfectada = ' ';
char[] letrasElegidas = new char[26]; 
int totalLetrasElegidas = 0;
int turnoKraken = 0;

String inputLetraKraken = "";
String mensajeKraken = "";
boolean juegoTerminadoKraken = false;
boolean mostrarMensajeFinalKraken = false;

int JUEGO4 = 13; // ⚙️ Nuevo estado: Red del Abismo
int JUEGO5 = 14; // 🦑 Ataque del Kraken Digital
int JUEGO6 = 15;

// === MINIJUEGO 5: ATAQUE DEL KRAKEN DIGITAL ===
boolean enMinijuegoKraken = false;
int tiempoInicioKraken;
int duracionKraken = 15000; // 15 segundos

// Constantes de seguridad
int KR_SEGURIDAD_MS = 2500;
int KR_RADIO_SAFE = 2; // Come celdas
int TAMANO_CELDA = 50;

// Posición del jugador
int posJugadorX;
int posJugadorY;
int velocidadJugador = 10; // Velocidad del jugador (reducida)
int radioJugador = 25;
// Variables para movimiento del jugador (mejora del sistema de teclas)
boolean teclaArriba = false;
boolean teclaAbajo = false;
boolean teclaIzquierda = false;
boolean teclaDerecha = false;

// Sistema de tentáculos
int MAX_TENTACULOS = 6;
int[][] tentaculos = new int[6][2]; // x, y de cada tentáculo
boolean[] tentaculoActivo = new boolean[6];
int totalTentaculos = 0;
int radioTentaculo = 20;
int velocidadMovimientoTentaculo = 14; // Velocidad aumentada de los tentáculos
boolean tentaculosInicializados = false;
PImage[] imagenesTentaculo = new PImage[2]; // Array de imágenes para los tentáculos (opcional)
int[] tipoImagenTentaculo = new int[6]; // Índice de imagen asignada a cada tentáculo (0 o 1)
int tamanoHitboxTentaculo = 28; // Tamaño de la hitbox (solo parte inferior)

// Curva de dificultad
int krakenSpawnCadaMs = 1000;
int krakenPasoCadaMs = 200;
int ultimoSpawnMs = 0;
int ultimoPasoKrakenMs = 0;
int pasosDesdeInicio = 0;

// Sistema de bordes (0=TOP, 1=LEFT, 2=BOTTOM, 3=RIGHT)
int bordeActual = 0;

// Pausa
boolean krakenPausa = false;
int ultimaPausaMs = 0;

// Estado del juego
boolean jugadorAtrapado = false;
boolean minijuegoKrakenTerminado = false;
boolean ganoKraken = false;

// Efectos visuales del minijuego Kraken
int impactoMs = -1;
float shakeX = 0;
float shakeY = 0;

// Estela del jugador
int MAX_TRAIL = 16;
float[] trailX = new float[16];
float[] trailY = new float[16];
int[] trailA = new int[16];
int trailIdx = 0;

// Burbujas parallax
int NUM_BURBUJAS_LENTAS = 20;
int NUM_BURBUJAS_RAPIDAS = 10;
float[] bxLenta = new float[20];
float[] byLenta = new float[20];
float[] brLenta = new float[20];
float[] bxRapida = new float[10];
float[] byRapida = new float[10];
float[] brRapida = new float[10];

// === MINIJUEGO 4: RED DEL ABISMO ===
PImage fondoLaberinto;

// Minijuego 6: Flappy Ocean
PImage fondoFlappy;
PImage imagenTubo;

int filasRed = 10;
int columnasRed = 14;
int[][] matrizRed = new int[filasRed][columnasRed];
int posXPerla = 1;
int posYPerla = 1;
int velocidadPerla = 1;

int tiempoInicioLaberinto;
int tiempoLimite = 20000; // 20 segundos
float puntosLaberinto = 0;
boolean juegoTerminadoLaberinto = false;
boolean puntosLaberintoOtorgados = false; // Bandera para evitar que se otorguen puntos múltiples veces
boolean ganoLaberinto = false;

// Minijuego 6: Flappy Ocean
// Variables del jugador
float flappyX = 150; // Posición X fija del jugador
float flappyY = 300; // Posición Y del jugador
float flappyVelocidadY = 0; // Velocidad vertical
float flappyGravedad = 1.0; // Fuerza de gravedad (aumentada para caída más rápida)
float flappyImpulso = -14; // Fuerza del salto (aumentada para subida más rápida)
int flappyTamaño = 40; // Tamaño del personaje

// Variables de obstáculos (virus verdes)
int totalObstaculosRequeridos = 10; // Número total de obstáculos que se deben pasar
int maxObstaculos = 10; // Máximo número de obstáculos en pantalla
float[] obstaculoX = new float[10]; // Posición X de cada obstáculo
float[] obstaculoYSuperior = new float[10]; // Posición Y del obstáculo superior
float[] obstaculoYInferior = new float[10]; // Posición Y del obstáculo inferior
int[] obstaculoAncho = new int[10]; // Ancho de cada obstáculo
int[] obstaculoAlto = new int[10]; // Alto de cada obstáculo
int huecoAltura = 200; // Altura del hueco entre obstáculos
float velocidadObstaculos = 7; // Velocidad de desplazamiento de obstáculos (aumentada)
int totalObstaculos = 0; // Contador de obstáculos activos
boolean[] obstaculoPuntuado = new boolean[10]; // Para evitar contar puntos múltiples veces
int obstaculosPasados = 0; // Contador de obstáculos pasados exitosamente

// Variables del juego
int puntosFlappy = 0; // Puntos acumulados
boolean juegoTerminadoFlappy = false; // Estado del juego
boolean ganoFlappy = false; // Si ganó pasando todos los obstáculos
boolean juegoIniciadoFlappy = false; // Si el juego ha comenzado
int ultimoObstaculoX = 0; // Para generar nuevos obstáculos
boolean flappyDesdeMenu = false; // Indica si se accedió desde el menú (modo prueba)

// Funciones del laberinto
void inicializarLaberinto() {
  for (int i = 0; i < filasRed; i++) {
    for (int j = 0; j < columnasRed; j++) {
      if (i == 0 || j == 0 || i == filasRed - 1 || j == columnasRed - 1) {
        matrizRed[i][j] = 1; // paredes
      } else {
        int r = int(random(100));
        if (r < 10) matrizRed[i][j] = 2; // trampa roja
else if (r < 25) matrizRed[i][j] = 3; // dato verde
else matrizRed[i][j] = 0; // camino


      }
    }
  }
  matrizRed[posYPerla][posXPerla] = 0;
}

void dibujarLaberinto() {
  if (fondoLaberinto != null) image(fondoLaberinto, 0, 0, width, height);
  else background(0, 30, 70);

  int tam = 50;
  
  // Calcular posición centrada de la matriz
  int anchoMatriz = columnasRed * tam;
  int altoMatriz = filasRed * tam;
  int inicioX = (width - anchoMatriz) / 2;
  int inicioY = (height - altoMatriz) / 2 + 40; // +40 para dejar espacio para el texto arriba
  
  for (int i = 0; i < filasRed; i++) {
    for (int j = 0; j < columnasRed; j++) {
      int x = inicioX + j * tam;
      int y = inicioY + i * tam;

      if (matrizRed[i][j] == 1) fill(20, 60, 100); // pared
      else if (matrizRed[i][j] == 2) fill(255, 60, 60); // trampa
      else if (matrizRed[i][j] == 3) fill(60, 255, 100); // dato
      else fill(0, 100, 180);

      rect(x, y, tam - 2, tam - 2, 8);
    }
  }

  // Personaje del jugador (usando la imagen del avatar)
  float jugadorX = inicioX + posXPerla * tam + tam / 2;
  float jugadorY = inicioY + posYPerla * tam + tam / 2;
  float tamanoPersonaje = tam * 0.8;
  
  if (imagenesJugador != null && jugadorActivo < imagenesJugador.length && imagenesJugador[jugadorActivo] != null) {
    image(imagenesJugador[jugadorActivo], 
          jugadorX - tamanoPersonaje / 2, 
          jugadorY - tamanoPersonaje / 2, 
          tamanoPersonaje, 
          tamanoPersonaje);
  } else {
    // Fallback: círculo de color si no hay imagen
    fill(colorJugador[jugadorActivo % colorJugador.length]);
    ellipse(jugadorX, jugadorY, tamanoPersonaje, tamanoPersonaje);
  }

// Tiempo y puntaje
int restante = tiempoLimite - (millis() - tiempoInicioLaberinto);
if (restante < 0) restante = 0;

  fill(colorTextoHUD);
  textAlign(CENTER, CENTER);
  textSize(22);
  text("⏳ Tiempo restante: " + (restante / 1000) + " s", width / 2, 40);

  fill(colorTituloSecundario);
textSize(26);
// Contador de puntos removido para mejor experiencia
}

void moverPerla(int dx, int dy) {
  int nuevaX = posXPerla + dx;
  int nuevaY = posYPerla + dy;

  if (nuevaX >= 0 && nuevaX < columnasRed && nuevaY >= 0 && nuevaY < filasRed) {
    if (matrizRed[nuevaY][nuevaX] != 1) {
      posXPerla = nuevaX;
      posYPerla = nuevaY;

      if (matrizRed[posYPerla][posXPerla] == 3) {
        puntosLaberinto += 1;
        matrizRed[posYPerla][posXPerla] = 0;
      } else if (matrizRed[posYPerla][posXPerla] == 2) {
        puntosLaberinto -= 3;
        juegoTerminadoLaberinto = true;
        ganoLaberinto = false;
      }
    }
  }
}

void verificarFinLaberinto() {
  boolean quedanDatos = false;
  for (int i = 0; i < filasRed; i++) {
    for (int j = 0; j < columnasRed; j++) {
      if (matrizRed[i][j] == 3) quedanDatos = true;
    }
  }

if (!quedanDatos) {
  juegoTerminadoLaberinto = true;
  ganoLaberinto = true;
  
  // BONUS si recogió todas las verdes
  puntosLaberinto += 2;
  mostrarMensaje("✅ Red completada! (+2 puntos)", 1500);
}
else if (millis() - tiempoInicioLaberinto > tiempoLimite) {
  juegoTerminadoLaberinto = true;
  ganoLaberinto = false;
}

  // Solo otorgar puntos UNA VEZ cuando el juego termine
  if (juegoTerminadoLaberinto && !puntosLaberintoOtorgados) {
    puntosLaberintoOtorgados = true; // Marcar que ya se otorgaron los puntos
    
    if (ganoLaberinto) {
      mostrarMensaje("✅ Red completada (+2)", 1600);
      modificarPuntosJugador(2);
    } else {
      mostrarMensaje("💀 Caíste en un virus (-1)", 1600);
      modificarPuntosJugador(-1);
    }

    if (desdeJuegosLibres) {
      estadoPantalla = JUEGOS_LIBRES;
      desdeJuegosLibres = false;
    } else {
      estadoPantalla = JUEGO;
      finTurnoPendiente = true;
      efectoCasillaAplicado = true;
    }
  }
}

// Funciones de Flappy Ocean
void inicializarFlappyBird() {
  // Resetear posición y velocidad del jugador
  flappyX = 150;
  flappyY = height / 2;
  flappyVelocidadY = 0;
  
  // Resetear obstáculos
  totalObstaculos = 0;
  obstaculosPasados = 0;
  for (int i = 0; i < maxObstaculos; i++) {
    obstaculoX[i] = 0;
    obstaculoYSuperior[i] = 0;
    obstaculoYInferior[i] = 0;
    obstaculoAncho[i] = 0;
    obstaculoAlto[i] = 0;
    obstaculoPuntuado[i] = false;
  }
  
  // Generar los primeros obstáculos (más cerca del inicio)
  int espacioEntreObstaculos = 280; // Espacio entre cada obstáculo (reducido para que aparezcan más cerca)
  int offsetInicial = 200; // Offset para que el primer obstáculo aparezca más cerca
  for (int i = 0; i < totalObstaculosRequeridos; i++) {
    generarObstaculo(i);
    obstaculoX[i] = width - offsetInicial + i * espacioEntreObstaculos; // Espaciarlos horizontalmente, más cerca del inicio
    totalObstaculos++;
  }
  
  // Resetear juego
  puntosFlappy = 0;
  juegoTerminadoFlappy = false;
  ganoFlappy = false;
  juegoIniciadoFlappy = false;
  ultimoObstaculoX = width;
  flappyDesdeMenu = false; // Se resetea, se establecerá según desde dónde se llame
}

void generarObstaculo(int indice) {
  obstaculoAncho[indice] = 60;
  int espacioMinimo = 100; // Espacio mínimo desde los bordes
  int espacioDisponible = height - espacioMinimo * 2 - huecoAltura;
  int alturaSuperior = espacioMinimo + int(random(espacioDisponible));
  
  obstaculoYSuperior[indice] = 0;
  obstaculoAlto[indice] = alturaSuperior;
  obstaculoYInferior[indice] = alturaSuperior + huecoAltura;
  obstaculoX[indice] = width;
  obstaculoPuntuado[indice] = false; // Inicializar flag de puntuado
}

void actualizarFlappyBird() {
  if (juegoTerminadoFlappy) return;
  
  // Aplicar gravedad
  if (juegoIniciadoFlappy) {
    flappyVelocidadY += flappyGravedad;
    flappyY += flappyVelocidadY;
  }
  
  // Limitar posición del jugador (techo y fondo)
  if (flappyY < flappyTamaño / 2) {
    flappyY = flappyTamaño / 2;
    juegoTerminadoFlappy = true;
  }
  if (flappyY > height - flappyTamaño / 2) {
    flappyY = height - flappyTamaño / 2;
    juegoTerminadoFlappy = true;
  }
  
  // No generar nuevos obstáculos, ya están todos generados al inicio
  
  // Mover y actualizar obstáculos (todos se mueven, incluso los que salieron de pantalla)
  for (int i = 0; i < totalObstaculos; i++) {
    // Mover todos los obstáculos
    obstaculoX[i] -= velocidadObstaculos;
    
    // Verificar colisión con el jugador (solo si el obstáculo está cerca del jugador)
    if (obstaculoX[i] + obstaculoAncho[i] > flappyX - flappyTamaño && 
        obstaculoX[i] < flappyX + flappyTamaño) {
      float jugadorIzq = flappyX - flappyTamaño / 2;
      float jugadorDer = flappyX + flappyTamaño / 2;
      float jugadorArriba = flappyY - flappyTamaño / 2;
      float jugadorAbajo = flappyY + flappyTamaño / 2;
      
      float obstaculoIzq = obstaculoX[i];
      float obstaculoDer = obstaculoX[i] + obstaculoAncho[i];
      
      // Colisión con obstáculo superior
      if (jugadorDer > obstaculoIzq && jugadorIzq < obstaculoDer) {
        if (jugadorArriba < obstaculoAlto[i]) {
          juegoTerminadoFlappy = true;
          ganoFlappy = false;
        }
      }
      
      // Colisión con obstaculo inferior
      if (jugadorDer > obstaculoIzq && jugadorIzq < obstaculoDer) {
        if (jugadorAbajo > obstaculoYInferior[i]) {
          juegoTerminadoFlappy = true;
          ganoFlappy = false;
        }
      }
    }
    
    // Sumar puntos al pasar un obstáculo (solo una vez)
    if (!obstaculoPuntuado[i] && obstaculoX[i] + obstaculoAncho[i] < flappyX) {
      puntosFlappy++;
      obstaculosPasados++;
      obstaculoPuntuado[i] = true;
      
      // Verificar si se pasaron todos los obstáculos
      if (obstaculosPasados >= totalObstaculosRequeridos) {
        juegoTerminadoFlappy = true;
        ganoFlappy = true;
      }
    }
  }
}

void dibujarFlappyBird() {
  // Fondo acuático
  if (fondoFlappy != null) {
    image(fondoFlappy, 0, 0, width, height);
  } else {
    background(20, 60, 120);
    // Efecto de gradiente acuático (fallback si no hay imagen)
    for (int i = 0; i < height; i++) {
      float factor = float(i) / float(height);
      int r = int(20 + factor * 40);
      int g = int(60 + factor * 60);
      int b = int(120 + factor * 80);
      stroke(r, g, b);
      line(0, i, width, i);
    }
    noStroke();
  }
  
  // Dibujar obstáculos (tubos con imagen)
  imageMode(CORNER); // Establecer una vez al inicio
  for (int i = 0; i < totalObstaculos; i++) {
    // Dibujar solo si está visible en pantalla o cerca
    if (obstaculoX[i] > -obstaculoAncho[i] && obstaculoX[i] < width + obstaculoAncho[i]) {
      if (imagenTubo != null) {
        // Dibujar tubo superior (reflejado verticalmente para que apunte hacia abajo)
        // Optimización: usar pushMatrix/popMatrix solo cuando sea necesario
        pushMatrix();
        translate(obstaculoX[i] + obstaculoAncho[i] / 2, obstaculoYSuperior[i] + obstaculoAlto[i] / 2);
        scale(1, -1); // Reflejar verticalmente
        imageMode(CENTER);
        image(imagenTubo, 0, 0, obstaculoAncho[i], obstaculoAlto[i]);
        imageMode(CORNER);
        popMatrix();
        
        // Dibujar tubo inferior (normal, apunta hacia arriba)
        image(imagenTubo, obstaculoX[i], obstaculoYInferior[i], obstaculoAncho[i], height - obstaculoYInferior[i]);
      } else {
        // Fallback: rectángulos verdes si no hay imagen
        fill(0, 200, 0);
        // Obstáculo superior
        rect(obstaculoX[i], obstaculoYSuperior[i], obstaculoAncho[i], obstaculoAlto[i]);
        // Obstáculo inferior
        rect(obstaculoX[i], obstaculoYInferior[i], obstaculoAncho[i], height - obstaculoYInferior[i]);
      }
    }
  }
  
  // Dibujar jugador (usando la imagen del personaje elegido)
  if (imagenesJugador[jugadorActivo] != null) {
    image(imagenesJugador[jugadorActivo], 
          flappyX - flappyTamaño / 2, 
          flappyY - flappyTamaño / 2, 
          flappyTamaño, 
          flappyTamaño);
  } else {
    // Fallback: círculo de color si no hay imagen
    fill(colorJugador[jugadorActivo % colorJugador.length]);
    ellipse(flappyX, flappyY, flappyTamaño, flappyTamaño);
  }
  
  // Dibujar UI
  fill(colorTextoHUD);
  textAlign(LEFT, TOP);
  textSize(24);
  text("Puntos: " + puntosFlappy, 20, 20);
  fill(colorTituloSecundario);
  textSize(18);
  text("Obstáculos: " + obstaculosPasados + " / " + totalObstaculosRequeridos, 20, 50);
  
  // Mensaje de inicio
  if (!juegoIniciadoFlappy && !juegoTerminadoFlappy) {
    fill(colorTextoAlerta);
    textAlign(CENTER, CENTER);
    textSize(32);
    text("Presiona ESPACIO o CLIC para comenzar", width / 2, height / 2 - 20);
    fill(colorTituloSecundario);
    textSize(18);
    text("Pasa las " + totalObstaculosRequeridos + " barras para ganar", width / 2, height / 2 + 10);
    text("Evita los virus verdes", width / 2, height / 2 + 40);
  }
  
  // Mensaje de fin de juego
  if (juegoTerminadoFlappy) {
    if (ganoFlappy) {
      // Mensaje de victoria
      fill(0, 255, 0, 200);
      textAlign(CENTER, CENTER);
      textSize(42); // Título más grande
      text("¡Victoria!", width / 2, height / 2 - 60);
      textSize(20);
      fill(255, 255, 255, 200);
      text("Pasaste todas las barras", width / 2, height / 2 - 20);
      text("Puntos: " + puntosFlappy, width / 2, height / 2 + 10);
    } else {
      // Mensaje de game over
      fill(255, 0, 0, 200);
      textAlign(CENTER, CENTER);
      textSize(42); // Título más grande
      text("¡Game Over!", width / 2, height / 2 - 60);
      textSize(20);
      fill(255, 255, 255, 200);
      text("Puntos: " + puntosFlappy, width / 2, height / 2 - 20);
      text("Obstáculos pasados: " + obstaculosPasados + " / " + totalObstaculosRequeridos, width / 2, height / 2 + 10);
    }
    
    textSize(16);
    if (flappyDesdeMenu) {
      text("Presiona ESPACIO o CLIC para volver al menú", width / 2, height / 2 + 40);
    } else {
      text("Presiona ESPACIO o CLIC para volver al tablero", width / 2, height / 2 + 40);
    }
    
    // Botón para volver
    pushStyle();
    color c = color(red(colorBotonHoverAlternativo), green(colorBotonHoverAlternativo), blue(colorBotonHoverAlternativo), 200);
    fill(c);
    rect(width / 2 - 120, height / 2 + 70, 240, 50, radioEsquinasBoton);
    popStyle();
    fill(colorTextoBoton);
    textSize(18);
    if (flappyDesdeMenu) {
      text("Volver al menú", width / 2, height / 2 + 95);
    } else {
      text("Volver al tablero", width / 2, height / 2 + 95);
    }
  }
}

// Funciones del minijuego Kraken
// Calcula distancia Manhattan
int distManhattan(int x1, int y1, int x2, int y2) {
  int celdaX1 = x1 / TAMANO_CELDA;
  int celdaY1 = y1 / TAMANO_CELDA;
  int celdaX2 = x2 / TAMANO_CELDA;
  int celdaY2 = y2 / TAMANO_CELDA;
  
  int dx = celdaX1 - celdaX2;
  if (dx < 0) dx = -dx;
  int dy = celdaY1 - celdaY2;
  if (dy < 0) dy = -dy;
  
  return dx + dy;
}

// Spawn de tentáculos
void krakenSpawn() {
  int tiempoActual = millis();
  int tiempoTranscurrido = tiempoActual - tiempoInicioKraken;
  
  // No spawn en últimos 2 segundos
  if (tiempoTranscurrido > duracionKraken - 2000) {
    return;
  }
  
  // Periodo de seguridad: no spawn cerca del jugador
  boolean enPeriodoSeguro = tiempoTranscurrido < KR_SEGURIDAD_MS;
  
  // Crear todos los tentáculos de una vez (número fijo)
  int cantidadSpawn = MAX_TENTACULOS;
  
  int[] spawnsX = new int[cantidadSpawn];
  int[] spawnsY = new int[cantidadSpawn];
  int totalSpawns = 0;
  
  // Generar posiciones distribuyendo en los 4 bordes
  for (int intento = 0; intento < cantidadSpawn * 5 && totalSpawns < cantidadSpawn; intento = intento + 1) {
    int spawnX = 0;
    int spawnY = 0;
    
    // Usar intento % 4 para alternar bordes
    int borde = intento % 4;
    
    if (borde == 0) {
      // TOP: evitar área del título (primeros 80 píxeles)
      spawnX = int(random(80, width));
      spawnY = 0;
    } else if (borde == 1) {
      spawnX = 0;
      // LEFT: evitar área del título (primeros 80 píxeles)
      spawnY = int(random(80, height));
    } else if (borde == 2) {
      spawnX = int(random(width));
      spawnY = height;
    } else {
      spawnX = width;
      // RIGHT: evitar área del título (primeros 80 píxeles)
      spawnY = int(random(80, height));
    }
    
    // Verificar periodo de seguridad
    if (enPeriodoSeguro) {
      if (distManhattan(spawnX, spawnY, posJugadorX, posJugadorY) < KR_RADIO_SAFE) {
        continue;
      }
    }
    
    // Verificar separación mínima
    boolean muyCerca = false;
    for (int j = 0; j < totalSpawns; j = j + 1) {
      if (distManhattan(spawnX, spawnY, spawnsX[j], spawnsY[j]) < 2) {
        muyCerca = true;
        break;
      }
    }
    
    if (!muyCerca) {
      for (int i = 0; i < totalTentaculos; i = i + 1) {
        if (tentaculoActivo[i]) {
          if (distManhattan(spawnX, spawnY, tentaculos[i][0], tentaculos[i][1]) < 2) {
            muyCerca = true;
            break;
          }
        }
      }
    }
    
    if (!muyCerca) {
      spawnsX[totalSpawns] = spawnX;
      spawnsY[totalSpawns] = spawnY;
      totalSpawns = totalSpawns + 1;
    }
  }
  
  // Crear tentáculos
  for (int i = 0; i < totalSpawns; i = i + 1) {
    if (totalTentaculos < MAX_TENTACULOS) {
      tentaculos[totalTentaculos][0] = spawnsX[i];
      tentaculos[totalTentaculos][1] = spawnsY[i];
      tentaculoActivo[totalTentaculos] = true;
      // Asignar aleatoriamente una imagen de tentáculo (0 o 1)
      tipoImagenTentaculo[totalTentaculos] = int(random(2));
      totalTentaculos = totalTentaculos + 1;
    }
  }
  
  // Marcar tentáculos como inicializados (solo se crean una vez)
  tentaculosInicializados = true;
}

void inicializarMinijuegoKraken() {
  enMinijuegoKraken = true;
  tiempoInicioKraken = millis();
  posJugadorX = width / 2;
  posJugadorY = height / 2;
  jugadorAtrapado = false;
  minijuegoKrakenTerminado = false;
  ganoKraken = false;
  krakenPausa = false;
  
  // Reset variables de movimiento del jugador
  teclaArriba = false;
  teclaAbajo = false;
  teclaIzquierda = false;
  teclaDerecha = false;
  
  // Reset sistema de tentáculos
  totalTentaculos = 0;
  tentaculosInicializados = false;
  for (int i = 0; i < MAX_TENTACULOS; i = i + 1) {
    tentaculoActivo[i] = false;
    tentaculos[i][0] = 0;
    tentaculos[i][1] = 0;
    tipoImagenTentaculo[i] = 0; // Reset del tipo de imagen
  }
  
  // Reset curva de dificultad
  krakenSpawnCadaMs = 1000;
  krakenPasoCadaMs = 120;
  ultimoSpawnMs = tiempoInicioKraken;
  ultimoPasoKrakenMs = tiempoInicioKraken;
  pasosDesdeInicio = 0;
  bordeActual = 0;
  ultimaPausaMs = 0;
  impactoMs = -1;
  
  // Resetear shake para evitar que se quede aplicado
  shakeX = 0;
  shakeY = 0;
  
  // Inicializar estela
  for (int i = 0; i < MAX_TRAIL; i = i + 1) {
    trailX[i] = posJugadorX;
    trailY[i] = posJugadorY;
    trailA[i] = 0;
  }
  trailIdx = 0;
  
  // Inicializar burbujas lentas
  for (int i = 0; i < NUM_BURBUJAS_LENTAS; i = i + 1) {
    bxLenta[i] = random(width);
    byLenta[i] = random(height);
    brLenta[i] = random(8, 20);
  }
  
  // Inicializar burbujas rápidas
  for (int i = 0; i < NUM_BURBUJAS_RAPIDAS; i = i + 1) {
    bxRapida[i] = random(width);
    byRapida[i] = random(height);
    brRapida[i] = random(5, 15);
  }
}

// Efectos visuales del Kraken

// Dibujar viñeta radial
void dibujarVineta() {
  int centroX = width / 2;
  int centroY = height / 2;
  int maxDist = 0;
  if (width > height) {
    maxDist = width;
  } else {
    maxDist = height;
  }
  
  int paso = 10;
  for (int y = 0; y < height; y = y + paso) {
    for (int x = 0; x < width; x = x + paso) {
      int dx = x - centroX;
      int dy = y - centroY;
      float dist = sqrt(dx * dx + dy * dy);
      float distanciaNormalizada = dist / (maxDist / 2.0);
      if (distanciaNormalizada > 1.0) distanciaNormalizada = 1.0;
      
      int alpha = int(distanciaNormalizada * 180);
      fill(0, 0, 0, alpha);
      noStroke();
      rect(x, y, paso, paso);
    }
  }
}

// Dibujar luz del jugador (linterna)
void dibujarLuzJugador(int cx, int cy, int radioMax) {
  noStroke();
  for (int r = radioMax; r > 0; r = r - 8) {
    float factor = float(r) / float(radioMax);
    int alpha = int(factor * 80);
    fill(50, 120, 220, alpha);
    ellipse(cx, cy, r * 2, r * 2);
  }
}

// Dibujar tentáculo con pulso
void dibujarTentaculo(int x, int y, int tiempo, int indiceTentaculo) {
  float fase = float(x + y) * 0.01;
  float radioBase = 12;
  float amplitud = 2;
  float frecuencia = 0.008;
  float radioPulso = radioBase + sin(tiempo * frecuencia + fase) * amplitud;
  
  // Obtener el índice de imagen asignado a este tentáculo
  int tipoImagen = tipoImagenTentaculo[indiceTentaculo];
  
  // Si hay imagen de tentáculo disponible, usarla; si no, dibujar forma básica
  if (tipoImagen >= 0 && tipoImagen < imagenesTentaculo.length && imagenesTentaculo[tipoImagen] != null) {
    pushMatrix();
    translate(x, y);
    // Escalar la imagen al doble del tamaño
    imageMode(CENTER);
    float escala = 2.0; // Doble del tamaño
    image(imagenesTentaculo[tipoImagen], 0, 0, imagenesTentaculo[tipoImagen].width * escala, imagenesTentaculo[tipoImagen].height * escala);
    // Restaurar imageMode a CORNER después de usar CENTER
    imageMode(CORNER);
    popMatrix();
  } else {
    // Si no hay imagen, también duplicar el tamaño del círculo
    stroke(60, 0, 0);
    strokeWeight(3);
    fill(190, 20, 30);
    ellipse(x, y, radioPulso * 4, radioPulso * 4); // Doble del tamaño
    
    // Punto especular
    noStroke();
    fill(255, 255, 255, 180);
    ellipse(x - 8, y - 8, 12, 12); // También más grande
  }
}

// Actualizar estela del jugador
void actualizarEstela(int px, int py) {
  trailX[trailIdx] = px;
  trailY[trailIdx] = py;
  trailA[trailIdx] = 180;
  
  trailIdx = trailIdx + 1;
  if (trailIdx >= MAX_TRAIL) {
    trailIdx = 0;
  }
  
  // Desvanecer estela
  for (int i = 0; i < MAX_TRAIL; i = i + 1) {
    if (trailA[i] > 0) {
      trailA[i] = trailA[i] - 6;
      if (trailA[i] < 0) trailA[i] = 0;
    }
  }
}

// Dibujar estela del jugador
void dibujarEstela() {
  noStroke();
  for (int i = 0; i < MAX_TRAIL; i = i + 1) {
    if (trailA[i] > 0) {
      fill(255, 255, 255, trailA[i]);
      ellipse(trailX[i], trailY[i], 8, 8);
    }
  }
}

// Actualizar burbujas
void actualizarBurbujas() {
  // Burbujas lentas
  for (int i = 0; i < NUM_BURBUJAS_LENTAS; i = i + 1) {
    byLenta[i] = byLenta[i] - 0.5;
    if (byLenta[i] < -brLenta[i]) {
      byLenta[i] = height + brLenta[i];
      bxLenta[i] = random(width);
    }
  }
  
  // Burbujas rápidas
  for (int i = 0; i < NUM_BURBUJAS_RAPIDAS; i = i + 1) {
    byRapida[i] = byRapida[i] - 1.2;
    if (byRapida[i] < -brRapida[i]) {
      byRapida[i] = height + brRapida[i];
      bxRapida[i] = random(width);
    }
  }
}

// Dibujar burbujas
void dibujarBurbujas() {
  noStroke();
  
  // Burbujas lentas
  fill(200, 240, 255, 120);
  for (int i = 0; i < NUM_BURBUJAS_LENTAS; i = i + 1) {
    ellipse(bxLenta[i], byLenta[i], brLenta[i] * 2, brLenta[i] * 2);
    fill(255, 255, 255, 80);
    ellipse(bxLenta[i] - brLenta[i] * 0.3, byLenta[i] - brLenta[i] * 0.3, brLenta[i] * 0.4, brLenta[i] * 0.4);
    fill(200, 240, 255, 120);
  }
  
  // Burbujas rápidas
  fill(200, 240, 255, 100);
  for (int i = 0; i < NUM_BURBUJAS_RAPIDAS; i = i + 1) {
    ellipse(bxRapida[i], byRapida[i], brRapida[i] * 2, brRapida[i] * 2);
    fill(255, 255, 255, 60);
    ellipse(bxRapida[i] - brRapida[i] * 0.3, byRapida[i] - brRapida[i] * 0.3, brRapida[i] * 0.4, brRapida[i] * 0.4);
    fill(200, 240, 255, 100);
  }
}

// Obtener shake (sacudida)
void calcularShake() {
  if (impactoMs >= 0) {
    int tiempoImpacto = millis() - impactoMs;
    if (tiempoImpacto < 200) {
      shakeX = random(-2, 2);
      shakeY = random(-2, 2);
    } else {
      shakeX = 0;
      shakeY = 0;
      impactoMs = -1;
    }
  } else {
    shakeX = 0;
    shakeY = 0;
  }
}

// Dibujar flash de impacto
void dibujarFlash() {
  if (impactoMs >= 0) {
    int tiempoImpacto = millis() - impactoMs;
    if (tiempoImpacto < 120) {
      fill(255, 255, 255, 150);
      noStroke();
      rect(0, 0, width, height);
    }
  }
}

// Funciones de selección de avatar

boolean estaSobre(int mx, int my, int x, int y, int w, int h) {
  boolean resultado = false;
  if (mx >= x && mx <= x + w && my >= y && my <= y + h) {
    resultado = true;
  }
  return resultado;
}

void dibujarTarjetaAvatar(int x, int y, int w, int h, int idx, boolean hover, boolean seleccionado, boolean tomado) {
  int shadowY = y + 6;
  
  fill(0, 0, 0, 60);
  noStroke();
  rect(x, shadowY, w, h, 16);
  
  if (tomado) {
    fill(30, 30, 40);
  } else if (seleccionado) {
    fill(colorBotonHoverAlternativo);
  } else if (hover) {
    fill(colorBotonHover);
  } else {
    fill(40, 60, 90);
  }
  
  noStroke();
  rect(x, y, w, h, 16);
  
  int borderThickness = 2;
  if (hover && !tomado) {
    borderThickness = 4;
    float brillo = sin(millis() * 0.006) * 0.5 + 0.5;
    fill(255, 255, 255, int(brillo * 60));
    noStroke();
    rect(x, y, w, h, 16);
  }
  
  if (seleccionado && !tomado) {
    stroke(100, 200, 255);
    strokeWeight(borderThickness);
  } else if (hover && !tomado) {
    stroke(60, 180, 255);
    strokeWeight(borderThickness);
  } else {
    stroke(60, 80, 120);
    strokeWeight(2);
  }
  
  noFill();
  rect(x, y, w, h, 16);
  
  if (spritesAv[idx] != null) {
    int spriteW = 120;
    int spriteH = 120;
    int spriteX = x + w/2 - spriteW/2;
    int spriteY = y + 30;
    image(spritesAv[idx], spriteX, spriteY, spriteW, spriteH);
  }
  
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(18);
  text(nombresAv[idx], x + w/2, y + h - 30);
  
  if (tomado) {
    fill(0, 0, 0, 180);
    noStroke();
    rect(x, y, w, h, 16);
    
    fill(255, 255, 255, 200);
    textSize(24);
    text("🔒", x + w/2, y + h/2);
    
    fill(colorTextoNegativo);
    textSize(14);
    text("Tomado", x + w/2, y + h - 50);
  }
}

void dibujarPreview(int idx) {
  int previewX = width - 320;
  int previewY = 200;
  int previewW = 280;
  int previewH = 400;
  
  fill(20, 30, 50, 220);
  stroke(80, 150, 255);
  strokeWeight(3);
  rect(previewX, previewY, previewW, previewH, 20);
  
  if (spritesAv[idx] != null) {
    int spriteW = 240;
    int spriteH = 240;
    int spriteX = previewX + previewW/2 - spriteW/2;
    int spriteY = previewY + 40;
    
    float pulso = sin(millis() * 0.008) * 0.3 + 0.7;
    
    for (int r = 0; r < 3; r = r + 1) {
      int radio = spriteW/2 + r * 15;
      int alpha = 30 - r * 10;
      fill(100, 200, 255, alpha);
      noStroke();
      ellipse(spriteX + spriteW/2, spriteY + spriteH/2, radio, radio);
    }
    
    image(spritesAv[idx], spriteX, spriteY, spriteW, spriteH);
  }
  
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(24);
  text(nombresAv[idx], previewX + previewW/2, previewY + 300);
  
  fill(colorTituloSecundario);
  textSize(14);
  text("Clic para seleccionar", previewX + previewW/2, previewY + 330);
  text("y avanzar al siguiente jugador.", previewX + previewW/2, previewY + 350);
}

void dibujarBurbujasSeleccion() {
  int numBurbujas = 12;
  for (int i = 0; i < numBurbujas; i = i + 1) {
    float x = (width * i / numBurbujas + millis() * 0.02) % width;
    float y = height - (millis() * 0.03 + i * 60) % (height + 100);
    float radio = 8 + i % 5 * 3;
    
    fill(100, 180, 255, 40);
    noStroke();
    ellipse(x, y, radio * 2, radio * 2);
  }
}

void dibujarSeleccionAvatar() {
  if (imagenFondoMenu != null) {
    image(imagenFondoMenu, 0, 0, width, height);
  } else {
    background(10, 20, 40);
  }
  
  dibujarBurbujasSeleccion();
  
  noStroke();
  fill(0, 140);
  rect(0, 0, width, height);
  
  dibujarVineta();
  
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(48); // Título más grande
  text("Elige tu personaje", width/2, 80);
  
  textSize(28);
  fill(colorTituloSecundario);
  text("— Jugador " + (jugadorActivo + 1) + " —", width/2, 130);
  
  int cardW = 200;
  int cardH = 240;
  int gap = 40;
  int gridW = cardW * 3 + gap * 2;
  int gridH = cardH * 2 + gap;
  int gridX = width/2 - gridW/2;
  int gridY = 180;
  
  int[] cardX = new int[6];
  int[] cardY = new int[6];
  
  // fila 1
  cardX[0] = gridX;                    cardY[0] = gridY;
  cardX[1] = gridX + (cardW + gap);    cardY[1] = gridY;
  cardX[2] = gridX + (cardW + gap) * 2;cardY[2] = gridY;
  // fila 2
  cardX[3] = gridX;                    cardY[3] = gridY + cardH + gap;
  cardX[4] = gridX + (cardW + gap);    cardY[4] = gridY + cardH + gap;
  cardX[5] = gridX + (cardW + gap) * 2;cardY[5] = gridY + cardH + gap;
  
  int hoverIdx = -1;
  for (int i = 0; i < 6; i = i + 1) {
    boolean hover = estaSobre(mouseX, mouseY, cardX[i], cardY[i], cardW, cardH);
    if (hover && !tomadoAv[i]) {
      hoverIdx = i;
    }
    boolean seleccionado = false;
    dibujarTarjetaAvatar(cardX[i], cardY[i], cardW, cardH, i, hover, seleccionado, tomadoAv[i]);
  }
  
  if (hoverIdx != -1 && !tomadoAv[hoverIdx]) {
    dibujarPreview(hoverIdx);
  }
  
  int botonAtrasX = width/2 - 70;
  int botonAtrasY = gridY + gridH + 40;
  int botonAtrasW = 140;
  int botonAtrasH = 50;
  
  boolean hayElecciones = false;
  for (int i = 0; i < cantidadJugadores; i = i + 1) {
    if (eleccionJugador[i] != -1) {
      hayElecciones = true;
    }
  }
  
  if (hayElecciones) {
    dibujarBotonEstilizado(botonAtrasX, botonAtrasY, botonAtrasW, botonAtrasH, colorBotonCancelar);
  } else {
    dibujarBotonEstilizado(botonAtrasX, botonAtrasY, botonAtrasW, botonAtrasH, colorBotonNormalAlternativo);
  }
  
  fill(colorTextoBoton);
  textAlign(CENTER, CENTER);
  textSize(20);
  if (hayElecciones) {
    text("Deshacer", botonAtrasX + botonAtrasW/2, botonAtrasY + botonAtrasH/2);
  } else {
    text("Atrás", botonAtrasX + botonAtrasW/2, botonAtrasY + botonAtrasH/2);
  }
}

// Dibujar HUD con tarjeta
void dibujarHUD(int tiempoRestante) {
  fill(0, 0, 0, 120);
  noStroke();
  rect(20, 20, 280, 100, 10);
  
  // Colores acuáticos brillantes para visibilidad
  fill(colorTextoHUD);
  textAlign(LEFT, TOP);
  textSize(14);
  text("Flechas: mover | Evita tentáculos", 24, 24);
  fill(colorTituloSecundario);
  text("Tiempo: " + (tiempoRestante / 1000) + " s", 24, 48);
  fill(colorTextoInfo);
  text("Puntos: " + int(puntosJugador[jugadorActivo]), 24, 72);
}

void dibujarMinijuegoKraken() {
  int tiempoActual = millis();
  int tiempoTranscurrido = tiempoActual - tiempoInicioKraken;
  
  // Calcular shake
  calcularShake();
  
  // Aplicar shake con pushMatrix
  pushMatrix();
  translate(shakeX, shakeY);
  
  // 1. FONDO
  if (fondoKraken != null) {
    image(fondoKraken, 0, 0, width, height);
  } else {
    background(5, 10, 30);
    fill(0, 120, 255, 80);
    noStroke();
    rect(0, 0, width, height);
  }
  
  // Viñeta radial
  dibujarVineta();
  
  // 2. Actualizar y dibujar burbujas
  actualizarBurbujas();
  dibujarBurbujas();
  
  // Mostrar pausa si está activa
  if (krakenPausa) {
    popMatrix(); // Asegurar que se cierre el pushMatrix antes de salir
    fill(255, 255, 0);
    textAlign(CENTER, CENTER);
    textSize(48);
    text("PAUSA", width/2, height/2);
    return;
  }
  
  // Actualizar curva de dificultad cada 5 segundos
  int intervalos5s = tiempoTranscurrido / 5000;
  int nuevoSpawnMs = 1000 - (intervalos5s * 60);
  int nuevoPasoMs = 200 - (intervalos5s * 20);
  
  if (nuevoSpawnMs < 400) nuevoSpawnMs = 400;
  if (nuevoPasoMs < 180) nuevoPasoMs = 180;
  
  krakenSpawnCadaMs = nuevoSpawnMs;
  krakenPasoCadaMs = nuevoPasoMs;
  
  // Sistema de spawn - solo una vez al inicio
  if (!tentaculosInicializados && !jugadorAtrapado && !minijuegoKrakenTerminado) {
    krakenSpawn();
  }
  
  // Movimiento del jugador con flechas (sistema mejorado usando eventos)
  if (!jugadorAtrapado && !minijuegoKrakenTerminado) {
    // Calcular dirección del movimiento
    float dx = 0;
    float dy = 0;
    
    if (teclaArriba && posJugadorY > radioJugador) {
      dy -= 1;
    }
    if (teclaAbajo && posJugadorY < height - radioJugador) {
      dy += 1;
    }
    if (teclaIzquierda && posJugadorX > radioJugador) {
      dx -= 1;
    }
    if (teclaDerecha && posJugadorX < width - radioJugador) {
      dx += 1;
    }
    
    // Normalizar el vector de movimiento para que la velocidad diagonal sea igual a la lineal
    float magnitud = sqrt(dx * dx + dy * dy);
    if (magnitud > 0) {
      dx = (dx / magnitud) * velocidadJugador;
      dy = (dy / magnitud) * velocidadJugador;
      
      // Aplicar movimiento normalizado
      float nuevoX = posJugadorX + dx;
      float nuevoY = posJugadorY + dy;
      
      // Verificar límites antes de actualizar
      if (nuevoX >= radioJugador && nuevoX <= width - radioJugador) {
        posJugadorX = (int)nuevoX;
      }
      if (nuevoY >= radioJugador && nuevoY <= height - radioJugador) {
        posJugadorY = (int)nuevoY;
      }
    }
    
    // Actualizar estela
    actualizarEstela(posJugadorX, posJugadorY);
  }
  
  // 3. LUZ DEL JUGADOR (linterna)
  dibujarLuzJugador(posJugadorX, posJugadorY, 120);
  
  // 4. DIBUJAR TENTÁCULOS CON PULSO
  for (int i = 0; i < totalTentaculos; i = i + 1) {
    if (tentaculoActivo[i]) {
      dibujarTentaculo(tentaculos[i][0], tentaculos[i][1], tiempoActual, i);
    }
  }
  
  // Movimiento de tentáculos hacia el jugador
  if (!jugadorAtrapado && !minijuegoKrakenTerminado && tiempoActual - ultimoPasoKrakenMs >= krakenPasoCadaMs) {
    ultimoPasoKrakenMs = tiempoActual;
    pasosDesdeInicio = pasosDesdeInicio + 1;
    
    for (int i = 0; i < totalTentaculos; i = i + 1) {
      if (tentaculoActivo[i]) {
        if (tentaculos[i][0] < posJugadorX) {
          tentaculos[i][0] = tentaculos[i][0] + velocidadMovimientoTentaculo;
        }
        if (tentaculos[i][0] > posJugadorX) {
          tentaculos[i][0] = tentaculos[i][0] - velocidadMovimientoTentaculo;
        }
        if (tentaculos[i][1] < posJugadorY) {
          tentaculos[i][1] = tentaculos[i][1] + velocidadMovimientoTentaculo;
        }
        if (tentaculos[i][1] > posJugadorY) {
          tentaculos[i][1] = tentaculos[i][1] - velocidadMovimientoTentaculo;
        }
      }
    }
  }
  
  // Verificación de colisión usando solo la parte inferior del tentáculo (28x28)
  if (!jugadorAtrapado && !minijuegoKrakenTerminado) {
    int centroJugadorX = posJugadorX;
    int centroJugadorY = posJugadorY;
    int mitadHitbox = tamanoHitboxTentaculo / 2;
    
    for (int i = 0; i < totalTentaculos; i = i + 1) {
      if (tentaculoActivo[i]) {
        // La hitbox está en la parte inferior del tentáculo (28x28)
        // El centro de la hitbox está en la parte inferior de la imagen
        int centroHitboxX = tentaculos[i][0];
        int centroHitboxY = tentaculos[i][1];
        
        // Si hay imagen, ajustar el centro de la hitbox hacia la parte inferior
        int tipoImagen = tipoImagenTentaculo[i];
        if (tipoImagen >= 0 && tipoImagen < imagenesTentaculo.length && imagenesTentaculo[tipoImagen] != null) {
          // La imagen se dibuja con imageMode(CENTER), así que tentaculos[i][0/1] es el centro de la imagen
          // La hitbox de 28x28 está en la parte inferior, así que movemos el centro hacia abajo
          int alturaImagen = imagenesTentaculo[tipoImagen].height;
          // El centro de la hitbox está en: centroY + (altura/2) - (tamanoHitbox/2)
          centroHitboxY = tentaculos[i][1] + (alturaImagen / 2) - mitadHitbox;
        }
        
        // Verificar colisión: jugador vs hitbox cuadrada del tentáculo (28x28)
        // Usamos distancia Manhattan para hitbox cuadrada (más eficiente)
        int dx = abs(centroJugadorX - centroHitboxX);
        int dy = abs(centroJugadorY - centroHitboxY);
        
        // Colisión si el jugador está dentro del área de la hitbox + su radio
        if (dx <= (mitadHitbox + radioJugador) && dy <= (mitadHitbox + radioJugador)) {
          // Verificación más precisa con distancia euclidiana
          int dist2 = dx * dx + dy * dy;
          int sumaRadios = radioJugador + mitadHitbox;
          int sumaRadios2 = sumaRadios * sumaRadios;
          
          if (dist2 <= sumaRadios2) {
            jugadorAtrapado = true;
            minijuegoKrakenTerminado = true;
            ganoKraken = false;
            impactoMs = millis();
            break;
          }
        }
      }
    }
  }
  
  // 5. ESTELA DEL JUGADOR
  dibujarEstela();
  
  // 6. DIBUJAR JUGADOR
  // Asegurar que imageMode esté en CORNER antes de dibujar el jugador
  imageMode(CORNER);
  if (imagenesJugador[jugadorActivo] != null) {
    image(imagenesJugador[jugadorActivo], posJugadorX - radioJugador, posJugadorY - radioJugador, radioJugador * 2, radioJugador * 2);
  } else {
    fill(colorJugador[jugadorActivo % colorJugador.length]);
    noStroke();
    ellipse(posJugadorX, posJugadorY, radioJugador * 2, radioJugador * 2);
  }
  
  // Finalizar shake - SIEMPRE ejecutar popMatrix antes de salir
  popMatrix();
  
  // Asegurar que imageMode vuelva a CORNER después de salir del juego del Kraken
  imageMode(CORNER);
  
  // 7. HUD y efectos finales
  int tiempoRestante = duracionKraken - tiempoTranscurrido;
  if (tiempoRestante > 0) {
    dibujarHUD(tiempoRestante);
  }
  
  // 8. FLASH DE IMPACTO
  dibujarFlash();
  
  // 9. Verificación de fin del juego
  if (jugadorAtrapado) {
    minijuegoKrakenTerminado = true;
    ganoKraken = false;
    fill(colorTextoNegativo);
    textAlign(CENTER, CENTER);
    textSize(42); // Título más grande
    text("¡El Kraken te atrapó!", width/2, height/2 - 40);
    mostrarBotonVolverKraken();
  } else {
    if (tiempoRestante <= 0) {
      minijuegoKrakenTerminado = true;
      ganoKraken = true;
      fill(colorTextoPositivo);
      textAlign(CENTER, CENTER);
      textSize(42); // Título más grande
      text("¡Sobreviviste al Kraken!", width/2, height/2 - 40);
      mostrarBotonVolverKraken();
    }
  }
}

void mostrarBotonVolverKraken() {
  dibujarBotonEstilizado(width/2 - 80, height/2 + 60, 160, 50, colorBotonVolverKraken);
  fill(colorTextoBoton);
  textSize(20);
  textAlign(CENTER, CENTER);
  text("Volver al tablero", width/2, height/2 + 85);
}

// Configuración inicial

void settings() {
  size(1400, 720);
}

void setup() {
  frameRate(60); // Aumentar frame rate a 60 FPS para mejor rendimiento
  inicializarCasillas();
imagenFondoMenu = loadImage("fondo_menu.jpg");
  imagenFondoTablero = loadImage("fondo.png");
  // Cargar imagen de fondo del panel lateral (opcional, si no existe se usará color sólido)
  try {
    imagenFondoPanelLateral = loadImage("panel_lateral.png");
  } catch (Exception e) {
    imagenFondoPanelLateral = null; // Si no existe, se usará el color sólido
  }
  for (int i = 0; i < 6; i = i + 1) imagenesCaraDado[i] = loadImage("dado" + (i + 1) + ".png");
  imagenCasillaSospechosa = loadImage("sospechosa.png");
  imagenCasillaSegura     = loadImage("segura.png");
  imagenCasillaNeutral    = loadImage("neutral.png");
  imagenCasillaSalida     = loadImage("salida.png");
  imagenCasillaPregunta   = loadImage("pregunta.png");
  minijuegoTrivia = loadImage("appss.png");
  minijuegoOrden = loadImage("virus.png");
  minijuegoBomba = loadImage("bomba.png");
  fondoLaberinto = loadImage("fondo_rey.jpg");
  fondoTrivia = loadImage("fondo_trivia.jpg");
imagenFinJuego = loadImage("fondo_ataque.jpg");
fondoKraken = loadImage("fondo_kraken.jpg");
fondoOrden = loadImage("fondo_corriente.jpg");
  fondoFlappy = loadImage("fondo_flappy.jpg");
  imagenTubo = loadImage("tubo.png");
 iconPulpo   = loadImage("jugador_1.png");
  iconDelfin  = loadImage("jugador_2.png");
  iconEstrella= loadImage("jugador_3.png");
  iconRobot   = loadImage("jugador_4.png");
  iconTortuga   = loadImage("jugador_5.png");
  iconCaballo   = loadImage("jugador_6.png");
  
  // Cargar fotos de los integrantes (con fallback si no existen)
  // Redimensionar al cargar para mejor calidad de renderizado
  PImage tempOscar = loadImage("oscar.jpg");
  if (tempOscar != null) {
    tempOscar.resize(180, 220); // Reducido para que quepa la foto del premio
    fotoOscar = tempOscar;
  }
  PImage tempLuis = loadImage("luis.png");
  if (tempLuis != null) {
    tempLuis.resize(180, 220); // Reducido para que quepa la foto del premio
    fotoLuis = tempLuis;
  }
  PImage tempJoel = loadImage("joel.jpeg");
  if (tempJoel != null) {
    tempJoel.resize(180, 220); // Reducido para que quepa la foto del premio
    fotoJoel = tempJoel;
  }
  
  // Cargar foto del premio de la feria
  PImage tempPremio = loadImage("feriaganador.png");
  if (tempPremio != null) {
    tempPremio.resize(500, 250); // Formato horizontal reducido
    fotoPremioFeria = tempPremio;
  }
  
  spritesAv[0] = iconPulpo;
  spritesAv[1] = iconDelfin;
  spritesAv[2] = iconEstrella;
  spritesAv[3] = iconRobot;
  spritesAv[4] = iconTortuga;
  spritesAv[5] = iconCaballo;
  
  // Imágenes de casillas para minijuegos 4, 5 y 6
minijuegoNuevo1 = loadImage("laberinto.png"); // JUEGO4
minijuegoNuevo2 = loadImage("rey.png");       // JUEGO5
minijuegoNuevo3 = loadImage("flappy.png");    // JUEGO6 - Flappy Ocean
  
  // Cargar imágenes de tentáculos
  try {
    imagenesTentaculo[0] = loadImage("tentaculo.png");
  } catch (Exception e) {
    imagenesTentaculo[0] = null; // Si no existe, se usará el dibujo básico
  }
  try {
    imagenesTentaculo[1] = loadImage("tentaculo_2.png");
  } catch (Exception e) {
    imagenesTentaculo[1] = null; // Si no existe, se usará el dibujo básico
  }
  
  // Cargar fuente
  try {
    fuentePrincipal = createFont(nombreFuente, 18);
    textFont(fuentePrincipal);
  } catch (Exception e) {
    println("[FUENTE] No se pudo cargar la fuente '" + nombreFuente + "', usando fuente por defecto");
  }

  textAlign(CENTER, CENTER);
  textSize(18);
  
  // Mezclar preguntas
mezclarPreguntasTrivia();

  // Audio
  try {
    musica     = new SoundFile(this, "musica_fondo.mp3");
    sfxClick   = new SoundFile(this, "sfx_click.mp3");
    sfxDado    = new SoundFile(this, "sfx_dado.mp3");
    sfxAcierto = new SoundFile(this, "sfx_acierto.mp3");
    sfxFallo   = new SoundFile(this, "sfx_fallo.mp3");
    iconMusica = loadImage("musica.png");
  } catch (Exception e) {
    println("[AUDIO] Error de carga: " + e.getMessage());
  }
  if (musica != null) musica.loop();

}

// Inicializa las casillas del tablero
void inicializarCasillas() {
  int[][] coordenadasCasillas = {
    {  88,140},{197,120},{274,115},{351,130},{428,150},{504,150},{582,165},{659,170},{735,160},{812,140},
    { 879, 95},{957, 65},{1010,110},
    {1010,170},{ 967,230},{ 972,290},{ 957,350},{1010,410},{1010,480},{ 988,540},{ 999,600},
    { 944,645},{ 873,635},{ 801,635},{ 724,650},{ 648,640},{ 571,635},{ 494,605},{ 417,590},{ 340,590},{ 274,585},{ 198,585},{ 121,575},
    {  88,515},{  73,450},{  99,390},{ 150,340},{ 197,280},{ 165,220},
    { 625,230},{ 614,290},{ 538,320},{ 466,335},{ 395,350},{ 341,305},{ 269,280},{ 453,410},
    { 458,470},{ 442,530},{ 653,350},{ 691,405},{ 729,460},{ 757,520},{ 767,580}
  };

  cantidadCasillas = 54;
  casillas = new int[cantidadCasillas][3];
  vecinos = new int[cantidadCasillas][2];

  // 🔹 Asignación manual intercalada
int[] tipos = {
  1, // salida fija
  9,6,3,11,10,7,4,5,8,9,
  10,6,8,11,5,7,4,10,6,9,
  7,11,8,3,9,10,7,8,11,6,
  3,4,5,10,7,8,9,11,6,5,
  10,9,7,4,3,8,11,6,5,2,
  9,10,11
};

  for (int i = 0; i < cantidadCasillas; i++) {
    casillas[i][0] = coordenadasCasillas[i][0];
    casillas[i][1] = coordenadasCasillas[i][1];
    casillas[i][2] = tipos[i % tipos.length];
  }

  // 🔹 Conexiones del tablero (iguales a las que ya tenías)
  for (int i = 0; i < cantidadCasillas; i++) {
    if (i < cantidadCasillas - 1) vecinos[i][0] = i + 1;
    else vecinos[i][0] = 0;
    vecinos[i][1] = -1;
  }

  vecinos[6][0]  = 7;  vecinos[6][1]  = 39;
  vecinos[40][0] = 41; vecinos[40][1] = 49;
  vecinos[42][0] = 43; vecinos[42][1] = 46;
  vecinos[48][0] = 28; vecinos[48][1] = -1;
  vecinos[53][0] = 24; vecinos[53][1] = -1;
  
    // Parche de ramificación
  // 45 → 37 (y de ahí sigue normal a 38)
  vecinos[45][0] = 37;
  vecinos[45][1] = -1;

  // 38 → 1 (atajo de regreso cercano al inicio que me pediste)
  vecinos[38][0] = 1;
  vecinos[38][1] = -1;

  // 46 → continúa normal (sin devolverse): explícito para evitar bucles raros
  vecinos[46][0] = 47;
  vecinos[46][1] = -1;

}


// Mezcla las preguntas de trivia
// Mezcla aleatoriamente el orden de las preguntas del minijuego Trivia
// para que cada partida tenga un orden distinto de preguntas.
void mezclarPreguntasTrivia() {
  int iAleatorio, jAleatorio;
  String[] temp;

  for (int i = 0; i < preguntasTrivia.length; i = i + 1) {
    iAleatorio = int(random(preguntasTrivia.length));
    jAleatorio = int(random(preguntasTrivia.length));

    // Intercambio de posiciones
    temp = preguntasTrivia[iAleatorio];
    preguntasTrivia[iAleatorio] = preguntasTrivia[jAleatorio];
    preguntasTrivia[jAleatorio] = temp;
  }
}

// Mezclar pares de apps para evitar repeticiones
void mezclarParesApps() {
  int iAleatorio, jAleatorio;
  String[] temp;

  for (int i = 0; i < paresApps.length; i = i + 1) {
    iAleatorio = int(random(paresApps.length));
    jAleatorio = int(random(paresApps.length));

    // Intercambio de posiciones
    temp = paresApps[iAleatorio];
    paresApps[iAleatorio] = paresApps[jAleatorio];
    paresApps[jAleatorio] = temp;
  }
  indiceParesApps = 0; // Resetear índice
}

// Mezclar frases del Kraken para evitar repeticiones
void mezclarFrasesKraken() {
  int iAleatorio, jAleatorio;
  String temp;

  for (int i = 0; i < frasesKraken.length; i = i + 1) {
    iAleatorio = int(random(frasesKraken.length));
    jAleatorio = int(random(frasesKraken.length));

    // Intercambio de posiciones
    temp = frasesKraken[iAleatorio];
    frasesKraken[iAleatorio] = frasesKraken[jAleatorio];
    frasesKraken[jAleatorio] = temp;
  }
  indiceFrasesKraken = 0; // Resetear índice
}

// Dibuja las casillas del tablero
void dibujarCasillas() {
  stroke(20);
  strokeWeight(2);

  for (int i = 0; i < cantidadCasillas; i++) {
    int x = casillas[i][0];
    int y = casillas[i][1];
    int tipo = casillas[i][2];
    PImage imagenCasilla = null;
    int w = tamanoCasilla;
    int h = tamanoCasilla;
    int dx = 0;
    int dy = 0;

    // Selección de imagen según tipo
    if (tipo == 1) {
      imagenCasilla = imagenCasillaSalida;
      w = int(tamanoCasilla * 2.0);
      h = w;
      dx = -int((w - tamanoCasilla) * 0.5);
      dy = -int((h - tamanoCasilla) * 0.5);
    } else if (tipo == 2) imagenCasilla = imagenCasillaSospechosa;
    else if (tipo == 3) imagenCasilla = imagenCasillaNeutral;
    else if (tipo == 4) imagenCasilla = imagenCasillaSegura;
    else if (tipo == 5) imagenCasilla = imagenCasillaPregunta;
    else if (tipo == 6) imagenCasilla = minijuegoTrivia;
    else if (tipo == 7) imagenCasilla = minijuegoOrden;
    else if (tipo == 8) imagenCasilla = minijuegoBomba;
    else if (tipo == 9) imagenCasilla = minijuegoNuevo1;
    else if (tipo == 10) imagenCasilla = minijuegoNuevo2;
    else if (tipo == 11) imagenCasilla = minijuegoNuevo3;


    // Dibujar imagen o rectángulo base
    if (imagenCasilla != null) {
      image(imagenCasilla, x + dx, y + dy, w, h);
    } else {
      fill(200);
      rect(x + dx, y + dy, w, h, 8);
    }

    // Números de casilla removidos según solicitud del usuario
  }
}

// Dibuja las fichas de los jugadores
void dibujarJugadores() {
  for (int i = 0; i < cantidadJugadores; i++) {
    int indiceCasilla = posicionJugador[i];
    int tipoCasilla = casillas[indiceCasilla][2];

    float posJugadorX, posJugadorY;
    float tamanoFicha = tamanoCasilla * 0.8;

    // Si está en la casilla de salida (más grande)
    if (tipoCasilla == 1) {
      int x0 = casillas[indiceCasilla][0];
      int y0 = casillas[indiceCasilla][1];
      int anchoSalida = int(tamanoCasilla * 2.0);
      int altoSalida = anchoSalida;
      int dx = -int((anchoSalida - tamanoCasilla) * 0.5);
      int dy = -int((altoSalida - tamanoCasilla) * 0.5);

      float margen = max(6, tamanoFicha * 0.4);
      float esquina1X = x0 + dx + margen;
      float esquina1Y = y0 + dy + margen;
      float esquina2X = x0 + dx + anchoSalida - margen;
      float esquina2Y = y0 + dy + margen;
      float esquina3X = x0 + dx + margen;
      float esquina3Y = y0 + dy + altoSalida - margen;
      float esquina4X = x0 + dx + anchoSalida - margen;
      float esquina4Y = y0 + dy + altoSalida - margen;

      int ranura = i % 4;
      if (ranura == 0) { posJugadorX = esquina1X; posJugadorY = esquina1Y; }
      else if (ranura == 1) { posJugadorX = esquina2X; posJugadorY = esquina2Y; }
      else if (ranura == 2) { posJugadorX = esquina3X; posJugadorY = esquina3Y; }
      else { posJugadorX = esquina4X; posJugadorY = esquina4Y; }

      tamanoFicha = tamanoCasilla;
    } 
    // Si está en una casilla normal
    else {
      posJugadorX = casillas[indiceCasilla][0] + tamanoCasilla * 0.5;
      posJugadorY = casillas[indiceCasilla][1] + tamanoCasilla * 0.5;
    }

    // Dibujar imagen o círculo de color
    if (imagenesJugador[i] != null) {
      image(imagenesJugador[i],
            posJugadorX - tamanoFicha / 2,
            posJugadorY - tamanoFicha / 2,
            tamanoFicha,
            tamanoFicha);
    } else {
      fill(colorJugador[i % colorJugador.length]);
      ellipse(posJugadorX, posJugadorY, tamanoFicha, tamanoFicha);
    }
  }
}

// Actualiza el turno y las rondas
void actualizarTurno() {
  if (finTurnoPendiente && !animacionEnCurso && !preguntaVisible && !esperandoEleccionRuta) {
    
    // Verificar que hay jugadores válidos
    if (cantidadJugadores <= 0) {
      println("Error: cantidadJugadores inválido: " + cantidadJugadores);
      finTurnoPendiente = false;
      return;
    }
    
    // Avanzar turno
    jugadorActivo++;

    // Si todos jugaron, avanzar ronda
    if (jugadorActivo >= cantidadJugadores) {
      jugadorActivo = 0;
      rondaActual++;

      // Si se cumplieron todas las rondas, preparar fin del juego
      // Cambiado a >= para incluir cuando se completa la última ronda
      if (rondaActual >= rondasTotales && !esperandoFinJuego) {
        rondaActual = rondasTotales; // Mantener en la última ronda para mostrar correctamente
        esperandoFinJuego = true;
        tiempoFinJuego = millis();
      }
    }
    
    // Verificar que el jugador activo es válido
    if (jugadorActivo < 0 || jugadorActivo >= cantidadJugadores) {
      println("Error: jugadorActivo fuera de límites: " + jugadorActivo + " / " + cantidadJugadores);
      jugadorActivo = 0; // Resetear a un valor seguro
    }

    // Control del mensaje final (espera 10 segundos)
    if (esperandoFinJuego) {
      // Dibujar cuadro negro de fondo
      fill(0, 200); // Negro con transparencia
      noStroke();
      rectMode(CENTER);
      rect(width / 2, height - 80, 500, 60, 10); // Cuadro centrado
      rectMode(CORNER);
      
      // Texto blanco sobre el cuadro
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(26);
      text("Calculando resultados finales...", width / 2, height - 80);

      if (millis() - tiempoFinJuego >= 10000) {
        juegoTerminado = true;
        estadoPantalla = FINAL_JUEGO;
        esperandoFinJuego = false;
      }
    }

    // Si el juego terminó, ir a pantalla final
    if (juegoTerminado) {
      estadoPantalla = FINAL_JUEGO;
    }

    // Reset de banderas del turno
    finTurnoPendiente = false;
    efectoCasillaAplicado = false;
    pasosRestantes = 0;
  }

  // Mostrar y gestionar fin de juego aunque no haya finTurnoPendiente
  if (esperandoFinJuego) {
    // Dibujar cuadro negro de fondo
    fill(0, 200); // Negro con transparencia
    noStroke();
    rectMode(CENTER);
    rect(width / 2, height - 80, 500, 60, 10); // Cuadro centrado
    rectMode(CORNER);
    
    // Texto blanco sobre el cuadro
    fill(255);
    textAlign(CENTER, CENTER);
    textSize(26);
    text("Calculando resultados finales...", width / 2, height - 80);
    if (millis() - tiempoFinJuego >= 10000) {
      juegoTerminado = true;
      estadoPantalla = FINAL_JUEGO;
      esperandoFinJuego = false;
    }
  }
  if (juegoTerminado) {
    estadoPantalla = FINAL_JUEGO;
  }
}

// Modifica los puntos del jugador actual
void modificarPuntosJugador(float cantidad) {
  if (puntosJugador != null && 
      jugadorActivo >= 0 && 
      jugadorActivo < puntosJugador.length &&
      jugadorActivo < cantidadJugadores) {
    puntosJugador[jugadorActivo] += cantidad;
  } else {
    println("Error: No se pudo modificar puntos. jugadorActivo: " + jugadorActivo + 
            ", puntosJugador.length: " + (puntosJugador != null ? puntosJugador.length : 0) +
            ", cantidadJugadores: " + cantidadJugadores);
  }
}

// Modifica los puntos de un jugador específico
void modificarPuntosJugadorEspecifico(int indiceJugador, float cantidad) {
  if (puntosJugador != null && 
      indiceJugador >= 0 && 
      indiceJugador < puntosJugador.length &&
      indiceJugador < cantidadJugadores) {
    puntosJugador[indiceJugador] += cantidad;
  } else {
    println("Error: No se pudo modificar puntos. indiceJugador: " + indiceJugador + 
            ", puntosJugador.length: " + (puntosJugador != null ? puntosJugador.length : 0) +
            ", cantidadJugadores: " + cantidadJugadores);
  }
}

void aplicarEfectoCasilla(int tipo) {
  // Reset básicos
  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;

  // Verificar que podemos acceder a los puntos
  boolean accesoValido = (puntosJugador != null && 
                          jugadorActivo >= 0 && 
                          jugadorActivo < puntosJugador.length &&
                          jugadorActivo < cantidadJugadores);

  switch (tipo) {
    case 1: // Salida
      mostrarMensaje("Inicio de Aventura!", 1000);
      finTurnoPendiente = true;
      break;

    case 2: // 🔴 Sospechosa
      modificarPuntosJugador(-2);
      mostrarMensaje("Casilla sospechosa (-2)", 1400);
      finTurnoPendiente = true;
      break;

    case 3: // ⚪ Neutral
      mostrarMensaje("Casilla neutral (0)", 1000);
      finTurnoPendiente = true;
      break;

    case 4: // Segura
      modificarPuntosJugador(2);
      mostrarMensaje("Casilla segura (+2)", 1400);
      finTurnoPendiente = true;
      break;

    case 5: // Pregunta (permiso)
      mostrarMensaje("Preguntas del Abismo!", 800);
      // Abrir alerta especial (NO cerrar turno aquí)
      preguntaVisible = true;
      indicePreguntaActual = int(random(preguntasPermisos.length));
      textoPreguntaActual = preguntasPermisos[indicePreguntaActual];
      efectoCasillaAplicado = false; // se cerrará con el clic Sí/No
      break;

    case 6: // Trivia
      mostrarMensaje("Trivias del Abismo!", 800);
      estadoPantalla = JUEGO1;
      // reset trivia y mezclar preguntas
      mezclarPreguntasTrivia();
      preguntaActualTrivia = 0;
      preguntasContestadas = 0;
      puntajeTrivia = 0;
      juegoTerminadoTrivia = false;
      respuestaJugador = "";
      mensajeInput = "";
      botonesTriviaVisibles = false;
      campoActivoTrivia = true;
      break;

    case 7: // Corriente Desordenada
  mostrarMensaje("Corriente Desordenada!", 800);
  estadoPantalla = JUEGO2;

  // ✅ Mezclar pares de apps y seleccionar uno
  mezclarParesApps();
  appCorrectA = paresApps[indiceParesApps][0];
  appCorrectB = paresApps[indiceParesApps][1];
  indiceParesApps = (indiceParesApps + 1) % paresApps.length; // Avanzar índice

  // Mezclar A
  String tmpA = appCorrectA;
  appScrambledA = "";
  while (tmpA.length() > 0) {
    int pick = int(random(tmpA.length()));
    appScrambledA += tmpA.substring(pick, pick+1);
    tmpA = tmpA.substring(0, pick) + tmpA.substring(pick+1);
  }

  // Mezclar B
  String tmpB = appCorrectB;
  appScrambledB = "";
  while (tmpB.length() > 0) {
    int pick2 = int(random(tmpB.length()));
    appScrambledB += tmpB.substring(pick2, pick2+1);
    tmpB = tmpB.substring(0, pick2) + tmpB.substring(pick2+1);
  }

  // Reiniciar variables internas
  inputOrdenA = "";
  inputOrdenB = "";
  campoActivoOrdenA = false;
  campoActivoOrdenB = false;
  seleccionComparacion = -1;
  juegoTerminadoOrden = false;
  mensajeOrden = "";
  mostrarResultadoOrden = false;

  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;
  break;


    case 8: // 🐙 Kraken (Letra Envenenada)
  mostrarMensaje("Kraken Envenenado!", 800);
  estadoPantalla = JUEGO3;

  // Mezclar frases y elegir una
  mezclarFrasesKraken();
  fraseKraken = frasesKraken[indiceFrasesKraken];
  indiceFrasesKraken = (indiceFrasesKraken + 1) % frasesKraken.length; // Avanzar índice

  // ✅ Elegir letra infectada (una de la frase)
  char[] letrasUnicas = new char[26];
  int totalUnicas = 0;
  for (int idx = 0; idx < fraseKraken.length(); idx++) {
    char ch = fraseKraken.charAt(idx);
    if (ch >= 'A' && ch <= 'Z') ch = char(ch - 'A' + 'a');
    if (ch >= 'a' && ch <= 'z') {
      boolean ya = false;
      for (int j = 0; j < totalUnicas; j++) {
        if (letrasUnicas[j] == ch) ya = true;
      }
      if (!ya && totalUnicas < 26) letrasUnicas[totalUnicas++] = ch;
    }
  }
  if (totalUnicas > 0) {
    letraInfectada = letrasUnicas[int(random(totalUnicas))];
  } else {
    letraInfectada = 'a';
  }

  // Reiniciar variables del minijuego
  totalLetrasElegidas = 0;
  for (int t = 0; t < letrasElegidas.length; t++) letrasElegidas[t] = ' ';
  inputLetraKraken = "";
  mensajeKraken = "Elige un oponente.";
  juegoTerminadoKraken = false;
  mostrarMensajeFinalKraken = false;
  oponenteElegido = false;
  jugadorOponente = -1;
  turnoKraken = jugadorActivo;

  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;
  break;

case 9: // Red del Abismo
  mostrarMensaje("Red del Abismo!", 800);
  estadoPantalla = JUEGO4;

  // Inicializar variables del laberinto
  inicializarLaberinto();
  tiempoInicioLaberinto = millis();
  puntosLaberinto = 0;
  juegoTerminadoLaberinto = false;
  puntosLaberintoOtorgados = false; // Resetear bandera para nuevo juego

  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;
  break;



case 10: // Ataque del Kraken Digital
  mostrarMensaje("¡Ataque del Kraken Digital!", 800);
  estadoPantalla = JUEGO5;
  inicializarMinijuegoKraken();
  
  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;
  break;

case 11: // Flappy Ocean
  mostrarMensaje("Flappy Ocean!", 800);
  estadoPantalla = JUEGO6;
  inicializarFlappyBird();
  flappyDesdeMenu = false; // Viene del tablero, no del menú
  efectoCasillaAplicado = true;
  animacionEnCurso = false;
  esperandoEleccionRuta = false;
  break;

    default:
      mostrarMensaje("Sin efecto.", 800);
      finTurnoPendiente = true;
      break;
  }
}

// Muestra un mensaje temporal en pantalla
void mostrarMensaje(String texto, int duracionMs) {
  mensaje = texto;
  mostrarMensajeHastaMs = millis() + duracionMs;
}

// Dibuja un botón con estilo
void dibujarBotonEstilizado(float x, float y, float w, float h, color colorBoton) {
  pushStyle();
  
  // Extraer alpha del color
  int alpha = (colorBoton >> 24) & 0xFF;
  if (alpha == 0) alpha = 255; // Si no tiene alpha, usar 255
  
  // Dibujar sombra si está habilitada (solo si el botón no es transparente)
  if (mostrarSombraBoton && alpha == 255) {
    fill(colorSombraBoton);
    noStroke();
    rect(x + offsetSombraX, y + offsetSombraY, w, h, radioEsquinasBoton);
  }
  
  // Dibujar el botón
  fill(colorBoton);
  if (grosorBordeBoton > 0 && alpha == 255) {
    stroke(colorBordeBoton);
    strokeWeight(grosorBordeBoton);
  } else {
    noStroke();
  }
  rect(x, y, w, h, radioEsquinasBoton);
  
  popStyle();
}

// Loop principal

void draw() {
  // === MENÚ PRINCIPAL ===
  if (estadoPantalla == MENU) {
if (imagenFondoMenu != null) image(imagenFondoMenu, 0, 0, width, height);
  else background(20);

  noStroke();
  fill(0, 120);
  rect(0, 0, width, height);

  fill(255); // Color blanco para el título
  textAlign(CENTER, CENTER);
  textSize(48); // Título más grande
  text("UnderWater: The Next Step", width/2, 120);

  int altoTotal = etiquetasMenuPrincipal.length * altoBotonMenu + (etiquetasMenuPrincipal.length - 1) * espacioEntreBotonesMenu;
  int inicioY = (height - altoTotal) / 2;

  indiceBotonHover = -1;
  for (int indice = 0; indice < etiquetasMenuPrincipal.length; indice = indice + 1) {
    int posicionBotonX = (width - anchoBotonMenu) / 2;
    int posicionBotonY = inicioY + indice * (altoBotonMenu + espacioEntreBotonesMenu);

    boolean punteroSobreBoton =
      mouseX >= posicionBotonX && mouseX <= posicionBotonX + anchoBotonMenu &&
      mouseY >= posicionBotonY && mouseY <= posicionBotonY + altoBotonMenu;
    if (punteroSobreBoton) indiceBotonHover = indice;

    if (punteroSobreBoton) dibujarBotonEstilizado(posicionBotonX, posicionBotonY, anchoBotonMenu, altoBotonMenu, colorBotonHover);
    else dibujarBotonEstilizado(posicionBotonX, posicionBotonY, anchoBotonMenu, altoBotonMenu, colorBotonNormal);

    fill(colorTextoBoton);
    textSize(22);
    text(etiquetasMenuPrincipal[indice], posicionBotonX + anchoBotonMenu/2, posicionBotonY + altoBotonMenu/2);
  }

  // Mostrar submenú de créditos si está activo
  if (mostrarCreditos) {
    // Fondo semi-transparente
    fill(0, 200);
    rect(0, 0, width, height);
    
    // Título
    fill(colorTituloPrincipal);
    textAlign(CENTER, CENTER);
    textSize(42); // Título más grande
    text("Créditos", width / 2, 80);
    
    // Activar suavizado para mejor calidad de imagen
    smooth();
    
    // Espaciado para las fotos (reducido para que quepa la foto del premio)
    int espacioEntreFotos = 30;
    int anchoFoto = 180; // Reducido de 250 a 180
    int altoFoto = 220; // Reducido de 300 a 220
    int inicioX = (width - (3 * anchoFoto + 2 * espacioEntreFotos)) / 2;
    int inicioYCreditos = 120;
    
    // Oscar Velez - Gerente
    if (fotoOscar != null) {
      image(fotoOscar, inicioX, inicioYCreditos, anchoFoto, altoFoto);
    } else {
      fill(100, 150, 255);
      rect(inicioX, inicioYCreditos, anchoFoto, altoFoto);
      fill(135, 206, 255); // Azul cielo
      textSize(24);
      textAlign(CENTER, CENTER);
      text("?", inicioX + anchoFoto/2, inicioYCreditos + altoFoto/2);
    }
    fill(colorTituloPrincipal);
    textSize(18);
    textAlign(CENTER, TOP);
    text("Oscar Velez", inicioX + anchoFoto/2, inicioYCreditos + altoFoto + 10);
    fill(colorTituloSecundario);
    textSize(14);
    text("Gerente", inicioX + anchoFoto/2, inicioYCreditos + altoFoto + 35);
    
    // Luis Villarreal - Desarrollador
    if (fotoLuis != null) {
      image(fotoLuis, inicioX + anchoFoto + espacioEntreFotos, inicioYCreditos, anchoFoto, altoFoto);
    } else {
      fill(100, 150, 255);
      rect(inicioX + anchoFoto + espacioEntreFotos, inicioYCreditos, anchoFoto, altoFoto);
      fill(135, 206, 255); // Azul cielo
      textSize(24);
      textAlign(CENTER, CENTER);
      text("?", inicioX + anchoFoto + espacioEntreFotos + anchoFoto/2, inicioYCreditos + altoFoto/2);
    }
    fill(colorTituloPrincipal);
    textSize(18);
    textAlign(CENTER, TOP);
    text("Luis Villarreal", inicioX + anchoFoto + espacioEntreFotos + anchoFoto/2, inicioYCreditos + altoFoto + 10);
    fill(colorTituloSecundario);
    textSize(14);
    text("Desarrollador", inicioX + anchoFoto + espacioEntreFotos + anchoFoto/2, inicioYCreditos + altoFoto + 35);
    
    // Joel Trespalacios - Diseñador
    if (fotoJoel != null) {
      image(fotoJoel, inicioX + 2 * (anchoFoto + espacioEntreFotos), inicioYCreditos, anchoFoto, altoFoto);
    } else {
      fill(100, 150, 255);
      rect(inicioX + 2 * (anchoFoto + espacioEntreFotos), inicioYCreditos, anchoFoto, altoFoto);
      fill(135, 206, 255); // Azul cielo
      textSize(24);
      textAlign(CENTER, CENTER);
      text("?", inicioX + 2 * (anchoFoto + espacioEntreFotos) + anchoFoto/2, inicioYCreditos + altoFoto/2);
    }
    fill(colorTituloPrincipal);
    textSize(18);
    textAlign(CENTER, TOP);
    text("Joel Trespalacios", inicioX + 2 * (anchoFoto + espacioEntreFotos) + anchoFoto/2, inicioYCreditos + altoFoto + 10);
    fill(colorTituloSecundario);
    textSize(14);
    text("Diseñador", inicioX + 2 * (anchoFoto + espacioEntreFotos) + anchoFoto/2, inicioYCreditos + altoFoto + 35);
    
    // Espacio para foto horizontal del premio de la feria
    int inicioYPremio = inicioYCreditos + altoFoto + 60; // Espacio reducido debajo de las fotos de los integrantes
    int anchoFotoPremio = 500; // Foto horizontal reducida de 600 a 500
    int altoFotoPremio = 250; // Altura reducida de 300 a 250
    int inicioXPremio = (width - anchoFotoPremio) / 2;
    
    if (fotoPremioFeria != null) {
      image(fotoPremioFeria, inicioXPremio, inicioYPremio, anchoFotoPremio, altoFotoPremio);
    } else {
      fill(100, 150, 255);
      rect(inicioXPremio, inicioYPremio, anchoFotoPremio, altoFotoPremio);
      fill(135, 206, 255);
      textSize(24);
      textAlign(CENTER, CENTER);
      text("?", inicioXPremio + anchoFotoPremio/2, inicioYPremio + altoFotoPremio/2);
    }
    fill(colorTituloPrincipal);
    textSize(18);
    textAlign(CENTER, TOP);
    text("Ganadores Feria Gamer Semestre: 2025_10", inicioXPremio + anchoFotoPremio/2, inicioYPremio + altoFotoPremio + 15);
    
    // Botón cerrar
    int cerrarBotonX = width - 170, cerrarBotonY = 100, cerrarBotonAncho = 120, cerrarBotonAlto = 45;
    boolean hoverCerrar = mouseX >= cerrarBotonX && mouseX <= cerrarBotonX + cerrarBotonAncho &&
                          mouseY >= cerrarBotonY && mouseY <= cerrarBotonY + cerrarBotonAlto;
    if (hoverCerrar) dibujarBotonEstilizado(cerrarBotonX, cerrarBotonY, cerrarBotonAncho, cerrarBotonAlto, colorBotonHoverAlternativo);
    else dibujarBotonEstilizado(cerrarBotonX, cerrarBotonY, cerrarBotonAncho, cerrarBotonAlto, colorBotonNormalAlternativo);
    fill(colorTextoBoton);
    textSize(18);
    textAlign(CENTER, CENTER);
    text("Cerrar", cerrarBotonX + cerrarBotonAncho/2, cerrarBotonY + cerrarBotonAlto/2);
  } else {
    textSize(14);
    fill(colorTituloSecundario);
    text("Haz clic en un botón", width/2, height - 36);
  }
  
  // Dibujar controles de audio (botón y barra de volumen) - solo en menú
  dibujarAudio();
  
  // Actualizar volumen si está arrastrando (solo en menú)
  if (estadoPantalla == MENU && volumenArrastrando && mousePressed) {
    float r = constrain((mouseX - volX) / float(volW), 0, 1);
    volumenGeneral = r;
    if (musica != null) musica.amp(sonidoActivo ? volumenGeneral : 0);
  }
  
  
  // === INSTRUCCIONES ===
  } else if (estadoPantalla == INSTRUCCIONES) {
  // Fondo igual que el del menú principal
  if (imagenFondoMenu != null) image(imagenFondoMenu, 0, 0, width, height);
  else background(20);

  // Capa oscura encima para contraste
  noStroke();
  fill(0, 140);
  rect(0, 0, width, height);

  // Si hay un submenú abierto, mostrar la explicación
  if (submenuInstrucciones >= 0) {
    // Panel de explicación
    fill(0, 200);
    rect(0, 0, width, height);
    
    fill(30, 40, 60, 240);
    rect(80, 80, width - 160, height - 160, 20);
    
    // Título del submenú
    fill(colorTituloPrincipal);
    textAlign(CENTER, CENTER);
    textSize(38); // Título más grande
    String tituloSubmenu = "";
    String textoExplicacion = "";
    
    if (submenuInstrucciones == 0) {
      tituloSubmenu = "Información General";
      textoExplicacion = "- Lanza el dado y avanza por el tablero.\n\n" +
                        "- Casillas sospechosas: -2 puntos\n\n" +
                        "- Casillas neutras: 0 puntos (sin efecto)\n\n" +
                        "- Casillas seguras: +2 puntos\n\n" +
                        "- Casillas de 'Pregunta': +1 o -1 según tu elección\n\n" +
                        "- Minijuegos ganados: +2 puntos\n\n" +
                        "- Minijuegos perdidos: -1 punto (excepto Trivia que mantiene su sistema)\n\n" +
                        "- Al final, el jugador con más puntos será el ganador.";
    } else if (submenuInstrucciones == 1) {
      tituloSubmenu = "Trivia del Abismo";
      textoExplicacion = "Responde hasta 3 preguntas sobre apps sospechosas o cultura digital.\n\n" +
                        "Cada acierto suma puntos, pero si decides seguir, ¡arriesgas más!\n\n" +
                        "Puedes decidir continuar después de cada pregunta o salir con tus puntos acumulados.\n\n" +
                        "¡Ten cuidado! Si fallas, perderás puntos.";
    } else if (submenuInstrucciones == 2) {
      tituloSubmenu = "Corriente Desordenada";
      textoExplicacion = "Reordena los nombres mezclados de apps sospechosas.\n\n" +
                        "Cuenta los caracteres y compara sus longitudes.\n\n" +
                        "Si aciertas todo, ganas puntos.\n\n" +
                        "Debes emparejar correctamente las aplicaciones relacionadas con ciberseguridad.";
    } else if (submenuInstrucciones == 3) {
      tituloSubmenu = "Kraken Envenenado";
      textoExplicacion = "Compite con otro jugador eligiendo letras de una palabra.\n\n" +
                        "Una letra está infectada: quien la elija pierde puntos, el otro gana.\n\n" +
                        "Debes ser estratégico y adivinar qué letra está envenenada.\n\n" +
                        "¡El jugador que evite la letra envenenada gana puntos!";
    } else if (submenuInstrucciones == 4) {
      tituloSubmenu = "Red del Abismo";
      textoExplicacion = "Navega por un laberinto evitando los obstáculos.\n\n" +
                        "Debes llegar al final del laberinto para ganar puntos.\n\n" +
                        "Usa las teclas de flecha o WASD para moverte.\n\n" +
                        "¡Ten cuidado con las paredes y los obstáculos!";
    } else if (submenuInstrucciones == 5) {
      tituloSubmenu = "Ataque del Kraken Digital";
      textoExplicacion = "Enfrenta al Kraken Digital en un combate estratégico.\n\n" +
                        "Debes elegir tus movimientos cuidadosamente para derrotar al enemigo.\n\n" +
                        "Cada decisión cuenta y puede afectar el resultado del combate.\n\n" +
                        "¡Demuestra tu habilidad estratégica!";
    } else if (submenuInstrucciones == 6) {
      tituloSubmenu = "Flappy Ocean";
      textoExplicacion = "Controla tu personaje en un juego estilo Flappy Ocean.\n\n" +
                        "Evita los obstáculos verdes (virus) que se mueven hacia ti.\n\n" +
                        "Presiona ESPACIO o haz clic para saltar y evitar los obstáculos.\n\n" +
                        "Debes pasar al menos 10 barras para ganar puntos.\n\n" +
                        "¡La gravedad te empuja hacia abajo constantemente!";
    } else if (submenuInstrucciones == 7) {
      tituloSubmenu = "Casillas Seguras";
      textoExplicacion = "Las casillas seguras son lugares confiables en el tablero.\n\n" +
                        "Cuando caigas en una casilla segura, recibirás puntos positivos.\n\n" +
                        "Estas casillas representan aplicaciones y sitios web legítimos y seguros.\n\n" +
                        "¡Aprovecha estas casillas para aumentar tu puntaje!";
    } else if (submenuInstrucciones == 8) {
      tituloSubmenu = "Casillas Sospechosas";
      textoExplicacion = "Las casillas sospechosas son lugares peligrosos en el tablero.\n\n" +
                        "Cuando caigas en una casilla sospechosa, perderás puntos.\n\n" +
                        "Estas casillas representan aplicaciones o sitios web maliciosos.\n\n" +
                        "¡Ten cuidado y evítalas si es posible!";
    } else if (submenuInstrucciones == 9) {
      tituloSubmenu = "Casillas Neutras";
      textoExplicacion = "Las casillas neutras no tienen efecto en tu puntaje.\n\n" +
                        "Cuando caigas en una casilla neutra, tu puntaje permanecerá igual.\n\n" +
                        "Estas casillas representan aplicaciones o sitios web que no son ni seguros ni peligrosos.\n\n" +
                        "Son lugares de paso que no afectan tu progreso.";
    }
    
    text(tituloSubmenu, width / 2, 130);
    
    // Texto de explicación
    fill(colorTituloSecundario);
    textSize(16);
    textLeading(28);
    text(textoExplicacion, width / 2, height / 2);
    
    // Botón cerrar
    int cerrarBotonX = width - 170, cerrarBotonY = 100, cerrarBotonAncho = 120, cerrarBotonAlto = 45;
    boolean hoverCerrar = mouseX >= cerrarBotonX && mouseX <= cerrarBotonX + cerrarBotonAncho &&
                          mouseY >= cerrarBotonY && mouseY <= cerrarBotonY + cerrarBotonAlto;
    if (hoverCerrar) dibujarBotonEstilizado(cerrarBotonX, cerrarBotonY, cerrarBotonAncho, cerrarBotonAlto, colorBotonHoverAlternativo);
    else dibujarBotonEstilizado(cerrarBotonX, cerrarBotonY, cerrarBotonAncho, cerrarBotonAlto, colorBotonNormalAlternativo);
    fill(colorTextoBoton);
    textSize(18);
    text("Cerrar", cerrarBotonX + cerrarBotonAncho/2, cerrarBotonY + cerrarBotonAlto/2);
    
  } else {
    // Menú principal con 10 botones
    // Título
    fill(colorTituloPrincipal);
    textAlign(CENTER, CENTER);
    textSize(42); // Título más grande
    text("Instrucciones", width / 2, 100);
    
    // Configuración de botones - 2 filas de 5 botones
    int tamanoBoton = 100;
    int espacioEntreBotones = 50; // Aumentado de 30 a 50 para separar más los botones
    int inicioX = (width - (5 * tamanoBoton + 4 * espacioEntreBotones)) / 2;
    int inicioY = 150;
    int espacioVertical = 180; // Aumentado de 160 a 180 para más espacio vertical
    
    // Nombres de los juegos y casillas
    String[] nombresJuegos = {"Información General", "Trivia del Abismo", "Corriente Desordenada", 
                               "Kraken Envenenado", "Red del Abismo", "Ataque del Kraken", "Flappy Ocean",
                               "Casillas Seguras", "Casillas Sospechosas", "Casillas Neutras"};
    PImage[] imagenesJuegos = {null, minijuegoTrivia, minijuegoOrden, minijuegoBomba, 
                               minijuegoNuevo1, minijuegoNuevo2, minijuegoNuevo3,
                               imagenCasillaSegura, imagenCasillaSospechosa, imagenCasillaNeutral};
    
    // Dibujar 10 botones en grid 5x2 (2 filas de 5)
    for (int i = 0; i < 10; i++) {
      int fila = i / 5;
      int columna = i % 5;
      int x = inicioX + columna * (tamanoBoton + espacioEntreBotones);
      int y = inicioY + fila * espacioVertical;
      
      boolean hover = mouseX >= x && mouseX <= x + tamanoBoton &&
                     mouseY >= y && mouseY <= y + tamanoBoton + 30;
      
      // Botón con imagen
      color colorBotonHoverTrans = color(red(colorBotonHover), green(colorBotonHover), blue(colorBotonHover), 180);
      color colorBotonNormalTrans = color(red(colorBotonNormal), green(colorBotonNormal), blue(colorBotonNormal), 200);
      if (hover) dibujarBotonEstilizado(x - 5, y - 5, tamanoBoton + 10, tamanoBoton + 10, colorBotonHoverTrans);
      else dibujarBotonEstilizado(x - 5, y - 5, tamanoBoton + 10, tamanoBoton + 10, colorBotonNormalTrans);
      
      // Imagen de la casilla
      if (imagenesJuegos[i] != null) {
        image(imagenesJuegos[i], x, y, tamanoBoton, tamanoBoton);
      } else {
        // Para información general, dibujar un icono genérico
        fill(100, 150, 255);
        rect(x + 20, y + 20, tamanoBoton - 40, tamanoBoton - 40, 8);
        fill(255);
        textSize(24);
        text("?", x + tamanoBoton/2, y + tamanoBoton/2);
      }
      
      // Nombre del juego abajo
      fill(colorTituloSecundario);
      textSize(14);
      textAlign(CENTER, TOP);
      text(nombresJuegos[i], x + tamanoBoton/2, y + tamanoBoton + 8);
    }
  }
  
  // Botón volver (siempre visible)
  int volverBotonX = 30, volverBotonY = 24, volverBotonAncho = 140, volverBotonAlto = 48;
  boolean hoverVolver = mouseX >= volverBotonX && mouseX <= volverBotonX + volverBotonAncho &&
                       mouseY >= volverBotonY && mouseY <= volverBotonY + volverBotonAlto;
  if (hoverVolver) dibujarBotonEstilizado(volverBotonX, volverBotonY, volverBotonAncho, volverBotonAlto, colorBotonHoverAlternativo);
  else dibujarBotonEstilizado(volverBotonX, volverBotonY, volverBotonAncho, volverBotonAlto, colorBotonNormalAlternativo);
  fill(colorTextoBoton);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Volver", volverBotonX + volverBotonAncho/2, volverBotonY + volverBotonAlto/2);
  
  dibujarAudio();

  // === ELEGIR JUGADORES ===
  } else if (estadoPantalla == ELEGIR_JUGADORES) {
  if (imagenFondoMenu != null) image(imagenFondoMenu, 0, 0, width, height);
  else background(20);

  noStroke();
  fill(0, 140);
  rect(0, 0, width, height);

  int anchoBotonSeleccion = 80, altoBotonSeleccion = 80, espacioEntreOpciones = 40;
  int anchoTotalOpciones = 3*anchoBotonSeleccion + 2*espacioEntreOpciones;
  int inicioXOpciones = width/2 - anchoTotalOpciones/2;
  int posicionYOpciones = height/2 - altoBotonSeleccion/2;
  
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(42); // Título más grande
  text("Elige número de jugadores", width/2, posicionYOpciones - 60); // Posicionado justo arriba de los botones

  for (int indiceOpcion = 0; indiceOpcion < 3; indiceOpcion = indiceOpcion + 1) {
    int valorCantidadJugadores = 2 + indiceOpcion;
    int posicionXOpcion = inicioXOpciones + indiceOpcion*(anchoBotonSeleccion + espacioEntreOpciones);
    boolean punteroSobreOpcion =
      mouseX >= posicionXOpcion && mouseX <= posicionXOpcion + anchoBotonSeleccion &&
      mouseY >= posicionYOpciones && mouseY <= posicionYOpciones + altoBotonSeleccion;

    color colorBotonActual;
    if (valorCantidadJugadores == jugadoresSeleccionados) colorBotonActual = colorBotonSeleccionado;
    else if (punteroSobreOpcion)                          colorBotonActual = colorBotonHover;
    else                                                  colorBotonActual = colorBotonNormal;

    dibujarBotonEstilizado(posicionXOpcion, posicionYOpciones, anchoBotonSeleccion, altoBotonSeleccion, colorBotonActual);
    fill(colorTextoBoton);
    textSize(28);
    text(valorCantidadJugadores, posicionXOpcion + anchoBotonSeleccion/2, posicionYOpciones + altoBotonSeleccion/2);
  }

  textSize(26);
  fill(colorTituloSecundario);
  text("Escribe rondas", width/2, posicionYOpciones + altoBotonSeleccion + 36);

  int anchoCampoRondas = 220;
  int altoCampoRondas = 44;
  int campoRondasX = width/2 - anchoCampoRondas/2;
  int campoRondasY = posicionYOpciones + altoBotonSeleccion + 56;

  noStroke();
  if (campoRondasActivo) fill(255); else fill(230);
  rect(campoRondasX, campoRondasY, anchoCampoRondas, altoCampoRondas, 10);

  fill(colorTextoInput);
  textAlign(LEFT, CENTER);
  textSize(22);
  String mostrar = "";
  for (int k = 0; k < tamBufferRondas; k = k + 1) {
    mostrar = mostrar + bufferRondas[k];
  }
  text(mostrar, campoRondasX + 12, campoRondasY + altoCampoRondas/2);

  textAlign(CENTER, TOP);
  textSize(14);
  if (hayErrorRondas) {
    fill(colorTextoNegativo);
    text(mensajeRondas, width/2, campoRondasY + altoCampoRondas + 6);
  } else {
    fill(colorTextoDetalle);
    text("Solo números. Entre " + rondasMin + " y " + rondasMax + ".", width/2, campoRondasY + altoCampoRondas + 6);
  }

  if (campoRondasActivo) {
    if (keyPressed) {
      boolean permitirEntrada = false;
      if (!teclaTomada) permitirEntrada = true;
      else if (key != teclaAnterior) permitirEntrada = true;
      else if (millis() - tiempoTeclaAnteriorMs > retardoTeclaMs) permitirEntrada = true;

      if (permitirEntrada) {
        if (key == BACKSPACE || key == DELETE) {
          if (tamBufferRondas > 0) tamBufferRondas = tamBufferRondas - 1;
        } else if (key == ENTER || key == RETURN) {
          // La validación se hace al pulsar el botón Confirmar
          } else {
          if (tamBufferRondas < bufferRondas.length) {
            bufferRondas[tamBufferRondas] = key;
            tamBufferRondas = tamBufferRondas + 1;
          }
        }

        teclaTomada = true;
        teclaAnterior = key;
        tiempoTeclaAnteriorMs = millis();
      }
    } else {
      teclaTomada = false;
    }
  }

  int anchoBotonConfirmarVolver = 140, altoBotonConfirmarVolver = 48;
  int posicionYBotonesConfirmarVolver = campoRondasY + altoCampoRondas + 40;
  int botonConfirmarX = width/2 - (anchoBotonConfirmarVolver + 20);
  int botonVolverX    = width/2 + 20;

  dibujarBotonEstilizado(botonConfirmarX, posicionYBotonesConfirmarVolver, anchoBotonConfirmarVolver, altoBotonConfirmarVolver, colorBotonConfirmar);
  fill(colorTextoBoton);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("Confirmar", botonConfirmarX + anchoBotonConfirmarVolver/2, posicionYBotonesConfirmarVolver + altoBotonConfirmarVolver/2);

  dibujarBotonEstilizado(botonVolverX, posicionYBotonesConfirmarVolver, anchoBotonConfirmarVolver, altoBotonConfirmarVolver, colorBotonVolver);
  fill(colorTextoBoton);
  text("Volver",   botonVolverX + anchoBotonConfirmarVolver/2, posicionYBotonesConfirmarVolver + altoBotonConfirmarVolver/2);
  dibujarAudio();
 

  // === SELECCIÓN DE AVATAR ===
} else if (estadoPantalla == SELECCION_AVATAR) {
  dibujarSeleccionAvatar();
  dibujarAudio();

// === JUEGOS LIBRES ===
} else if (estadoPantalla == JUEGOS_LIBRES) {
  // Fondo igual que el del menú principal
  if (imagenFondoMenu != null) image(imagenFondoMenu, 0, 0, width, height);
  else background(20);

  // Capa oscura encima para contraste
  noStroke();
  fill(0, 140);
  rect(0, 0, width, height);

  // Título
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(42); // Título más grande
  text("Juegos Libres", width / 2, 100);

  // Nombres de los minijuegos
  String[] nombresJuegos = {
    "Trivia del Abismo",
    "Corriente Desordenada",
    "Kraken Envenenado",
    "Red del Abismo",
    "Ataque del Kraken",
    "Flappy Ocean"
  };
  
  // Imágenes de las casillas de los juegos
  PImage[] imagenesJuegos = {
    minijuegoTrivia,
    minijuegoOrden,
    minijuegoBomba,
    minijuegoNuevo1,
    minijuegoNuevo2,
    minijuegoNuevo3
  };

  // Configuración de botones (igual que instrucciones)
  int tamanoBoton = 100;
  int espacioEntreBotones = 50;
  int inicioX = (width - (3 * tamanoBoton + 2 * espacioEntreBotones)) / 2;
  int inicioY = 180;
  int espacioVertical = 180;

  // Dibujar 6 botones en grid 3x2
  for (int i = 0; i < nombresJuegos.length; i++) {
    int fila = i / 3;
    int columna = i % 3;
    int x = inicioX + columna * (tamanoBoton + espacioEntreBotones);
    int y = inicioY + fila * espacioVertical;
    
    boolean hover = mouseX >= x && mouseX <= x + tamanoBoton &&
                   mouseY >= y && mouseY <= y + tamanoBoton + 30;
    
    // Botón con imagen
    if (hover) fill(red(colorBotonHover), green(colorBotonHover), blue(colorBotonHover), 180);
    else fill(red(colorBotonNormal), green(colorBotonNormal), blue(colorBotonNormal), 200);
    rect(x - 5, y - 5, tamanoBoton + 10, tamanoBoton + 10, 12);
    
    // Imagen de la casilla
    if (imagenesJuegos[i] != null) {
      image(imagenesJuegos[i], x, y, tamanoBoton, tamanoBoton);
    } else {
      // Fallback si no hay imagen
      fill(100, 150, 255);
      rect(x + 20, y + 20, tamanoBoton - 40, tamanoBoton - 40, 8);
    }
    
    // Nombre del juego abajo
    fill(127, 255, 212); // Verde agua
    textSize(14);
    textAlign(CENTER, TOP);
    text(nombresJuegos[i], x + tamanoBoton/2, y + tamanoBoton + 8);
  }

  // Botón volver
  int botonVolverX = 30;
  int botonVolverY = 24;
  int botonVolverW = 140;
  int botonVolverH = 48;

  boolean hoverVolver = mouseX >= botonVolverX && mouseX <= botonVolverX + botonVolverW &&
                        mouseY >= botonVolverY && mouseY <= botonVolverY + botonVolverH;

  if (hoverVolver) fill(colorBotonHoverAlternativo);
  else fill(colorBotonNormalAlternativo);
  rect(botonVolverX, botonVolverY, botonVolverW, botonVolverH, 12);

  fill(colorTextoBoton);
  textSize(18);
  textAlign(CENTER, CENTER);
  text("Volver", botonVolverX + botonVolverW/2, botonVolverY + botonVolverH/2);

  dibujarAudio();

// === MINIJUEGO 1: TRIVIAS DEL ABISMO ===
} else if (estadoPantalla == JUEGO1) {
  dibujarTrivia();
  dibujarAudio();

// === MINIJUEGO 2: CORRIENTE DESORDENADA ===
} else if (estadoPantalla == JUEGO2) {
    if (fondoOrden != null) image(fondoOrden, 0, 0, width, height);
  else background(6, 18, 40);
  
  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(38); // Título más grande
  text("Corriente Desordenada", width/2, 80);

  textSize(18);
  fill(colorTituloSecundario);
  text("Reconstrúyelas correctamente y decide cuál es más larga.", width/2, 120);

  textSize(20);
  fill(colorTextoNegativo);
  textAlign(CENTER, CENTER);
  text("A desordenada: " + appScrambledA, width/2, 180);
  text("B desordenada: " + appScrambledB, width/2, 210);

  float boxW = 420, boxH = 44;
  float boxAX = width/2 - boxW/2, boxAY = 250;
  float boxBX = boxAX, boxBY = boxAY + 72;

  if (campoActivoOrdenA) fill(255); else fill(230);
  rect(boxAX, boxAY, boxW, boxH, 8);
  fill(colorTextoDetalle);
  textAlign(LEFT, CENTER);
  textSize(20);
  text(inputOrdenA, boxAX + 10, boxAY + boxH/2);

  if (campoActivoOrdenB) fill(255); else fill(230);
  rect(boxBX, boxBY, boxW, boxH, 8);
  fill(colorTextoInput);
  textAlign(LEFT, CENTER);
  textSize(20);
  text(inputOrdenB, boxBX + 10, boxBY + boxH/2);

  textAlign(CENTER, CENTER);
  textSize(18);
  float cx = width/2;
  float cy = boxBY + 110;
  fill(colorTextoDetalle);
  text("¿Cuál es más larga?", cx, cy - 26);

  float optW = 160, optH = 40, gap = 18;
  float ox = cx - (optW*3 + gap*2)/2;

  if (seleccionComparacion == 0) dibujarBotonEstilizado(ox, cy, optW, optH, colorBotonSeleccionado);
  else dibujarBotonEstilizado(ox, cy, optW, optH, colorBotonHoverAlternativo);
  fill(colorTextoBoton);
  text("A más larga", ox + optW/2, cy + optH/2);

  if (seleccionComparacion == 1) dibujarBotonEstilizado(ox + (optW + gap), cy, optW, optH, colorBotonSeleccionado);
  else dibujarBotonEstilizado(ox + (optW + gap), cy, optW, optH, colorBotonHoverAlternativo);
  fill(colorTextoBoton);
  text("B más larga", ox + (optW + gap) + optW/2, cy + optH/2);

  if (seleccionComparacion == 2) dibujarBotonEstilizado(ox + 2*(optW + gap), cy, optW, optH, colorBotonSeleccionado);
  else dibujarBotonEstilizado(ox + 2*(optW + gap), cy, optW, optH, colorBotonHoverAlternativo);
  fill(colorTextoBoton);
  text("Igual", ox + 2*(optW + gap) + optW/2, cy + optH/2);

  float byButtons = cy + 90;
  float bw = 160, bh = 48;

  dibujarBotonEstilizado(cx - bw - 16, byButtons, bw, bh, colorBotonConfirmar);
  fill(colorTextoBoton);
  textSize(18); text("Confirmar", cx - bw - 16 + bw/2, byButtons + bh/2);

  dibujarBotonEstilizado(cx + 16, byButtons, bw, bh, colorBotonCancelar);
  fill(colorTextoBoton);
  text("No sé", cx + 16 + bw/2, byButtons + bh/2);

  if (mensajeOrden != null && mensajeOrden.length() > 0) {
    fill(colorTextoAlerta);
    textSize(16);
    text(mensajeOrden, width/2, byButtons + bh + 36);
  }

  if (mostrarResultadoOrden) {
    fill(0,120);
    rect(0,0,width,height);
    fill(colorTituloPrincipal);
    textSize(24);
    text(mensajeOrden, width/2, height/2 - 30);
    dibujarBotonEstilizado(width/2 - 140, height/2 + 10, 280, 52, colorBotonVolverTablero);
    fill(colorTextoBoton);
    textSize(20); text("Volver al tablero", width/2, height/2 + 36);
  }
  dibujarAudio();

// === MINIJUEGO 3: LA LETRA ENVENENADA DEL KRAKEN ===
} else if (estadoPantalla == JUEGO3) {
  if (fondoKraken != null) image(fondoKraken, 0, 0, width, height);
  else background(8, 20, 45);
  fill(0, 130); noStroke(); rect(0, 0, width, height);

  fill(colorTituloPrincipal);
  textAlign(CENTER, CENTER);
  textSize(38); // Título más grande
  text("La Letra Envenenada del Kraken", width/2, 80);

  textSize(20);
  fill(colorTituloSecundario);
  text("Frase: \"" + fraseKraken + "\" (elige una letra minúscula)", width/2, 130);

  fill(colorTextoInfo);
  textSize(18);
  text("Jugador actual: J" + (turnoKraken + 1), width/2, 170);

  if (!oponenteElegido) {
    fill(colorTituloSecundario);
    text("Selecciona un oponente para enfrentarte:", width/2, 210);

    int bw = 140, bh = 46, gap = 18, baseY = 250;
    int totalBtns = 0;
    for (int j = 0; j < cantidadJugadores; j++) {
      if (j != jugadorActivo) {
        int bx = width/2 - (bw + gap) * (cantidadJugadores-1) / 2 + totalBtns*(bw + gap);
        int by = baseY;
        dibujarBotonEstilizado(bx, by, bw, bh, colorBotonHoverAlternativo);
        fill(colorTextoBoton);
        text("Elegir J" + (j+1), bx + bw/2, by + bh/2);
        totalBtns++;
      }
    }
    fill(colorTextoAlerta);
    text(mensajeKraken, width/2, baseY + 80);

  } else {
    textAlign(CENTER, CENTER);
    fill(colorTextoDetalle);
    String historial = "Letras usadas: ";
    for (int k = 0; k < totalLetrasElegidas; k++) historial += letrasElegidas[k] + " ";
    text(historial, width/2, 210);

    textSize(18);
    fill(colorTituloSecundario);
    text("Escribe UNA letra que aparezca en la frase y presiona ENTER", width/2, 250);

    char[] letrasV = new char[26];
    int totalV = 0;
    for (int i = 0; i < fraseKraken.length(); i++) {
      char ch = fraseKraken.charAt(i);
      if (ch >= 'A' && ch <= 'Z') ch = char(ch - 'A' + 'a');
      if (ch >= 'a' && ch <= 'z') {
        boolean ya = false;
        for (int j = 0; j < totalV; j++) {
          if (letrasV[j] == ch) ya = true;
        }
        if (!ya && totalV < 26) { letrasV[totalV] = ch; totalV++; }
      }
    }
    String letrasValidas = "Letras válidas: ";
    for (int j = 0; j < totalV; j++) letrasValidas += letrasV[j] + " ";
    textSize(16);
    fill(colorTextoInfo);
    text(letrasValidas, width/2, 275);

    fill(0, 100);
    rect(width/2 - 100, 300, 200, 44, 8);
    fill(colorTextoInput);
    textSize(22);
    text(inputLetraKraken, width/2, 322);

    textSize(18);
    if (mensajeKraken.length() > 0) {
      fill(colorTextoNegativo);
      text(mensajeKraken, width/2, 360);
    }

    fill(colorTextoDetalle);
    textSize(16);
    text("Turno: J" + (turnoKraken+1) + " — evita la letra envenenada...", width/2, 390);
  }

  if (mostrarMensajeFinalKraken) {
    fill(0, 0, 0, 180);
    rect(0, 0, width, height);

    fill(colorTextoNegativo);
    textAlign(CENTER, CENTER);
    textSize(42); // Título más grande
    text("¡Letra envenenada!", width/2, height/2 - 60);

    fill(colorTituloPrincipal);
    textSize(24);
    int perdedor = turnoKraken;
    int ganador;
    if (turnoKraken == jugadorActivo) {
      ganador = jugadorOponente;
    } else {
      ganador = jugadorActivo;
    }
    text("J" + (perdedor + 1) + " perdió (-1) y J" + (ganador + 1) + " ganó (+2)", width/2, height/2 - 10);

    int botonAncho = 220;
    int botonAlto = 50;
    int botonX = width/2 - botonAncho/2;
    int botonY = height/2 + 40;

    fill(colorBotonVolverTablero);
    rect(botonX, botonY, botonAncho, botonAlto, 12);
    fill(colorTextoBoton);
    textSize(20);
    text("Volver al tablero", width/2, botonY + botonAlto/2);
  }
  dibujarAudio();

// === TABLERO ===
// === PANTALLA FINAL ===
// === MINIJUEGO 4: RED DEL ABISMO ===
} else if (estadoPantalla == JUEGO4) {
  dibujarLaberinto();
  verificarFinLaberinto();
  dibujarAudio();

// === MINIJUEGO 5: ATAQUE DEL KRAKEN DIGITAL ===
} else if (estadoPantalla == JUEGO5) {
  dibujarMinijuegoKraken();
  dibujarAudio();

// Minijuego 6: Flappy Ocean
} else if (estadoPantalla == JUEGO6) {
  actualizarFlappyBird();
  dibujarFlappyBird();
  dibujarAudio();

// Minijuego 6: Flappy Ocean
} else if (estadoPantalla == JUEGO6) {
  actualizarFlappyBird();
  dibujarFlappyBird();
  dibujarAudio();
} else if (estadoPantalla == FINAL_JUEGO) {
  if (imagenFinJuego != null) {
    image(imagenFinJuego, 0, 0, width, height);
  } else {
    background(0, 20, 60);
  }

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(54); // Título más grande
  text("¡Juego Terminado!", width/2, height/2 - 100);

  fill(colorTituloPrincipal);
  textSize(28);
  text("Gracias por jugar UnderWater: The Next Step", width/2, height/2 - 40);
  
  // Verificar datos antes de calcular el ganador
  int ganador = 0;
  boolean empate = false;
  
  if (puntosJugador != null && cantidadJugadores > 0 && puntosJugador.length >= cantidadJugadores) {
    // Encontrar el puntaje máximo
    float maxPuntos = puntosJugador[0];
    int contadorEmpate = 1;
    
    for (int i = 1; i < cantidadJugadores; i++) {
      if (i < puntosJugador.length) {
        if (puntosJugador[i] > maxPuntos) {
          maxPuntos = puntosJugador[i];
          ganador = i;
          contadorEmpate = 1;
        } else if (puntosJugador[i] == maxPuntos) {
          contadorEmpate++;
        }
      }
    }
    
    // Verificar si hay empate (múltiples jugadores con el mismo puntaje máximo)
    if (contadorEmpate > 1) {
      empate = true;
    }
    
    textSize(32);
    fill(255, 255, 153); // Amarillo claro para ganador
    
    if (empate) {
      text("¡Empate entre jugadores con " + int(maxPuntos) + " puntos!", width/2, height/2 + 20);
    } else {
      if (ganador < puntosJugador.length) {
        text("Ganador: Jugador " + (ganador + 1) + " con " + int(puntosJugador[ganador]) + " puntos", width/2, height/2 + 20);
      } else {
        text("Error al calcular ganador", width/2, height/2 + 20);
      }
    }
  } else {
    // Fallback si hay problemas con los datos
    textSize(32);
    fill(255, 255, 153);
    text("Error: No se pudieron calcular los resultados", width/2, height/2 + 20);
  }

// --- Botón volver al menú ---
int bw = 220, bh = 60;
int bx = width/2 - bw/2, by = height/2 + 120;

dibujarBotonEstilizado(bx, by, bw, bh, colorBotonVolverMenu);

fill(colorTextoBoton);
textSize(22);
text("Volver al menú", bx + bw/2, by + bh/2);
  dibujarAudio();

}
 else {
  if (imagenFondoTablero != null) image(imagenFondoTablero, 0, 0, width - anchoPanelLateral, height);
  else background(120, 180, 255);

  // Casillas
  stroke(20);
  strokeWeight(2);
  
  dibujarCasillas();

  //fichas
  dibujarJugadores();


  noStroke();
  // Dibujar imagen de fondo del panel lateral si existe
  if (imagenFondoPanelLateral != null) {
    image(imagenFondoPanelLateral, width - anchoPanelLateral, 0, anchoPanelLateral, height);
  } else {
    // Si no hay imagen, usar color sólido
    fill(35, 70, 130);
    rect(width - anchoPanelLateral, 0, anchoPanelLateral, height);
  }
  fill(colorTextoHUD);
  textAlign(LEFT, TOP);
  textSize(18);
  text("Casilla: " + posicionJugador[jugadorActivo], width - anchoPanelLateral + 20, 100);

  String tipoCasillaActualTexto = "";
  int tipoCasillaActual = casillas[posicionJugador[jugadorActivo]][2];
  if (tipoCasillaActual == 1) tipoCasillaActualTexto = "SALIDA";
  else if (tipoCasillaActual == 2) tipoCasillaActualTexto = "SOSPECHOSA";
  else if (tipoCasillaActual == 3) tipoCasillaActualTexto = "NEUTRAL";
  else if (tipoCasillaActual == 4) tipoCasillaActualTexto = "SEGURA";
  else if (tipoCasillaActual == 5) tipoCasillaActualTexto = "PREGUNTA";
  else if (tipoCasillaActual == 6) tipoCasillaActualTexto = "TRIVIA DEL \n ABISMO";
  else if (tipoCasillaActual == 7) tipoCasillaActualTexto = "CORRIENTE \n DESORDENADA";
  else if (tipoCasillaActual == 8) tipoCasillaActualTexto = "KRAKEN \n ENVENENADO";
  else if (tipoCasillaActual == 9) tipoCasillaActualTexto = "RED DEL \n ABISMO";
else if (tipoCasillaActual == 10) tipoCasillaActualTexto = "ATAQUE DEL \n KRAKEN";
else if (tipoCasillaActual == 11) tipoCasillaActualTexto = "FLAPPY OCEAN";


  fill(colorTituloSecundario);
  text("Tipo de casilla: " + tipoCasillaActualTexto, width - anchoPanelLateral + 20, 140);
  fill(colorTextoInfo);
  textSize(20);
  text("Turno: Jugador " + (jugadorActivo + 1), width - anchoPanelLateral + 20, 180);
  fill(colorTextoDetalle);
  text("Ronda: " + rondaActual + " / " + rondasTotales, width - anchoPanelLateral + 20, 226);

  double dadoW = 197; // 2/3 de 295
  double dadoH = 157; // 2/3 de 235
  double dadoX = width - anchoPanelLateral / 2.0 - dadoW / 2.0; // Centrado
  double dadoY = 300;            

  fill(colorTextoHUD);
  textAlign(CENTER, CENTER);
  textSize(18);
  if (!esperandoEleccionRuta) {
    text("Lanzar dado", width - anchoPanelLateral / 2.0, (float)(dadoY - 22));
  }

  // Dibujar borde visual alrededor del área clickeable
  noFill();
  stroke(colorBordeBoton);
  strokeWeight((float)grosorBordeBoton);
  rect((float)(dadoX - 8), (float)(dadoY - 8), (float)(dadoW + 16), (float)(dadoH + 16), 12);
  noStroke();

  int cara = caraDado;
  if (cara >= 1 && cara <= 6) { cara = cara - 1; }
  if (cara >= 0 && cara < 6 && imagenesCaraDado != null && imagenesCaraDado[cara] != null) {
    image(imagenesCaraDado[cara], (float)dadoX, (float)dadoY, (float)dadoW, (float)dadoH);
  } else {
    fill(255); rect((float)dadoX, (float)dadoY, (float)dadoW, (float)dadoH);
    fill(colorTextoHUD);
    textAlign(CENTER, CENTER); textSize(18);
    text("Lanzar", (float)(dadoX + dadoW/2.0), (float)(dadoY + dadoH/2.0));
  }

  double paddingY = 64;          
  double gapBotones = 16;        
  double anchoBotonRuta = 96;
  double altoBotonRuta  = 34;

  double botonRutaAY = dadoY + dadoH + paddingY;
  double centroPanelX = width - anchoPanelLateral / 2.0;
  double anchoTotalBotones = 2*anchoBotonRuta + gapBotones;
  double botonRutaAX = centroPanelX - anchoTotalBotones / 2.0;
  double botonRutaBX = botonRutaAX + anchoBotonRuta + gapBotones;
  double botonRutaBY = botonRutaAY;

  if (esperandoEleccionRuta) {
    dibujarBotonEstilizado((float)botonRutaAX, (float)botonRutaAY, (float)anchoBotonRuta, (float)altoBotonRuta, colorBotonRutaA);
    fill(colorTextoBoton);
    textAlign(CENTER, CENTER); text("Ruta A",
      (float)(botonRutaAX + anchoBotonRuta/2.0), (float)(botonRutaAY + altoBotonRuta/2.0));

    dibujarBotonEstilizado((float)botonRutaBX, (float)botonRutaBY, (float)anchoBotonRuta, (float)altoBotonRuta, colorBotonRutaB);
    fill(colorTextoBoton);
    text("Ruta B",
      (float)(botonRutaBX + anchoBotonRuta/2.0), (float)(botonRutaBY + altoBotonRuta/2.0));
  }

  noStroke();
  fill(0, 0, 0, 120);
  rect(0, height - 48, width - anchoPanelLateral, 48);
  textAlign(LEFT, CENTER);
  fill(colorTextoHUD);
  textSize(16);
  double marcadorX = 20;
  double marcadorY = height - 24;
  for (i = 0; i < cantidadJugadores; i = i + 1) {
    fill(colorJugador[i % colorJugador.length]);
    rect((float)marcadorX, (float)(marcadorY - 12), 24, 24, 6);
    fill(colorTextoHUD);
    text("  J" + (i + 1) + ": " + int(puntosJugador[i]), (float)(marcadorX + 30), (float)marcadorY);
    marcadorX = marcadorX + 130;
  }
  stroke(255); noFill();
  rect(20 + 130 * jugadorActivo - 4, (float)(marcadorY - 16), 120, 32, 8);
  noStroke();

  if (millis() < mostrarMensajeHastaMs) {
    fill(0, 0, 0, 180);
    rect(20, height - 90, width - anchoPanelLateral - 40, 36);
    fill(colorTextoHUD);
    textAlign(CENTER, CENTER);
    text(mensaje, (width - anchoPanelLateral) / 2, height - 72);
  }

  if (preguntaVisible) {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(colorTextoAlerta);
    textAlign(CENTER, CENTER);
    textSize(26);
    text("Alerta de Permiso! Decida si permite o no concederlo.", width / 2, height / 2 - 80);
    fill(colorTituloSecundario);
    textSize(20);
    text(textoPreguntaActual + "\n¿Permitir?", width / 2, height / 2 - 20);
    dibujarBotonEstilizado(width / 2 - 90, height / 2 + 30, 80, 40, colorBotonSi);
    fill(colorTextoBoton);
    text("Sí", width / 2 - 50, height / 2 + 50);
    dibujarBotonEstilizado(width / 2 + 10, height / 2 + 30, 80, 40, colorBotonNo);
    fill(colorTextoBoton);
    text("No", width / 2 + 50, height / 2 + 50);
  }

  if (esperandoEleccionRuta) {
    int indiceActual = posicionJugador[jugadorActivo];
    double nodoCentroX = casillas[indiceActual][0] + tamanoCasilla * 0.5;
    double nodoCentroY = casillas[indiceActual][1] + tamanoCasilla * 0.5;

    if (totalOpcionesRuta >= 1) {
      int indiceA = opcionesRuta[0];
      double opcionAX = casillas[indiceA][0] + tamanoCasilla * 0.5;
      double opcionAY = casillas[indiceA][1] + tamanoCasilla * 0.5;

      stroke(80,180,255); strokeWeight(4);
      line((float)nodoCentroX, (float)nodoCentroY, (float)opcionAX, (float)opcionAY);
      noStroke(); fill(80,180,255);
      ellipse((float)opcionAX, (float)opcionAY, 10, 10);
      fill(colorTextoBoton);
      textAlign(CENTER, BOTTOM);
      text("A", (float)((nodoCentroX+opcionAX)/2.0), (float)((nodoCentroY+opcionAY)/2.0 - 6));
    }

    if (totalOpcionesRuta >= 2) {
      int indiceB = opcionesRuta[1];
      double opcionBX = casillas[indiceB][0] + tamanoCasilla * 0.5;
      double opcionBY = casillas[indiceB][1] + tamanoCasilla * 0.5;

      stroke(80,220,160); strokeWeight(4);
      line((float)nodoCentroX, (float)nodoCentroY, (float)opcionBX, (float)opcionBY);
      noStroke(); fill(80,220,160);
      ellipse((float)opcionBX, (float)opcionBY, 10, 10);
      fill(colorTextoBoton);
      textAlign(CENTER, TOP);
      text("B", (float)((nodoCentroX+opcionBX)/2.0), (float)((nodoCentroY+opcionBY)/2.0 + 6));
    }
    strokeWeight(1); stroke(20);
  }

actualizarTurno();


if (animacionEnCurso && !preguntaVisible && !esperandoEleccionRuta) {
  if (millis() - ultimoPasoMs >= intervaloPasoMs) {
    if (pasosRestantes > 0) {
      int indiceActual = posicionJugador[jugadorActivo];
      int vecino1 = vecinos[indiceActual][0];
      int vecino2 = vecinos[indiceActual][1];

      if (vecino2 == -1) {
        // solo un camino
        posicionJugador[jugadorActivo] = vecino1;
        pasosRestantes--;
        ultimoPasoMs = millis();

        // Si el NUEVO nodo tiene 2 salidas y aún quedan pasos → pedir elección
        if (pasosRestantes > 0) {
          int indiceNuevo = posicionJugador[jugadorActivo];
          int s1 = vecinos[indiceNuevo][0];
          int s2 = vecinos[indiceNuevo][1];
          if (s2 != -1) {
            totalOpcionesRuta = 0;
            opcionesRuta[0] = s1;
            opcionesRuta[1] = s2;
            totalOpcionesRuta = 2;
            esperandoEleccionRuta = true;
            animacionEnCurso = false;
          }
        }
      } else {
        // dos caminos: detener animación para que el jugador elija
        totalOpcionesRuta = 0;
        opcionesRuta[0] = vecino1;
        opcionesRuta[1] = vecino2;
        totalOpcionesRuta = 2;
        esperandoEleccionRuta = true;
        animacionEnCurso = false;
      }
    }
    if (pasosRestantes == 0 && !esperandoEleccionRuta) {
   if (!efectoCasillaAplicado) {
  int casillaIndice = posicionJugador[jugadorActivo];
  int tipo = casillas[casillaIndice][2];

  // Si es una casilla de pregunta (permiso), abrir alerta especial
  if (tipo == 5) {
    preguntaVisible = true;
    indicePreguntaActual = int(random(preguntasPermisos.length));
    textoPreguntaActual = preguntasPermisos[indicePreguntaActual];
  } 
  // Para el resto, aplicar efecto general
  else {
    aplicarEfectoCasilla(tipo);
  }
 }
 }
 }
 }
 }
}

// Manejo de mouse

void mousePressed() {
  // Minijuego 6: Flappy Ocean
  if (estadoPantalla == JUEGO6) {
    if (juegoTerminadoFlappy) {
      // Verificar click en botón "Volver"
      if (mouseX >= width / 2 - 120 && mouseX <= width / 2 + 120 &&
          mouseY >= height / 2 + 70 && mouseY <= height / 2 + 120) {
        if (flappyDesdeMenu) {
          // Volver al menú (modo prueba)
          estadoPantalla = MENU;
          flappyDesdeMenu = false;
        } else if (desdeJuegosLibres) {
          // Volver a juegos libres
          estadoPantalla = JUEGOS_LIBRES;
          desdeJuegosLibres = false;
        } else {
          // Sumar puntos al jugador y volver al tablero
          if (ganoFlappy) {
            modificarPuntosJugador(2);
            mostrarMensaje("¡Flappy Ocean completado! (+2)", 1600);
          } else {
            // No otorgar puntos si perdió
            mostrarMensaje("Flappy Ocean: No completado (0 puntos)", 1600);
          }
          estadoPantalla = JUEGO;
          efectoCasillaAplicado = true;
          finTurnoPendiente = true;
        }
      }
    } else {
      // Salto
      if (!juegoIniciadoFlappy) {
        juegoIniciadoFlappy = true;
      }
      flappyVelocidadY = flappyImpulso;
    }
    return;
  }
  
  // Botón Mute (solo en menú principal)
  if (estadoPantalla == MENU) {
    boolean clickMute = mouseX >= btnMuteX && mouseX <= btnMuteX + btnMuteW && mouseY >= btnMuteY && mouseY <= btnMuteY + btnMuteH;
    if (clickMute) {
      sonidoActivo = !sonidoActivo;
      if (musica != null) musica.amp(sonidoActivo ? volumenGeneral : 0);
      return;
    }
    // Inicio drag del volumen (solo en menú)
    boolean sobreBarra = mouseX >= volX && mouseX <= volX + volW && mouseY >= volY - 8 && mouseY <= volY + volH + 8;
    if (sobreBarra) {
      volumenArrastrando = true;
      float r = constrain((mouseX - volX) / float(volW), 0, 1);
      volumenGeneral = r;
      if (musica != null) musica.amp(sonidoActivo ? volumenGeneral : 0);
      return;
    }
  }
  // Si estamos esperando el fin del juego, bloquear demás entradas
  if (esperandoFinJuego) {
    return;
  }
  // === MENÚ ===
  if (estadoPantalla == MENU) {
    // Manejar clic en botón cerrar de créditos
    if (mostrarCreditos) {
      int cerrarBotonX = width - 170, cerrarBotonY = 100, cerrarBotonAncho = 120, cerrarBotonAlto = 45;
      if (mouseX >= cerrarBotonX && mouseX <= cerrarBotonX + cerrarBotonAncho &&
          mouseY >= cerrarBotonY && mouseY <= cerrarBotonY + cerrarBotonAlto) {
        mostrarCreditos = false;
        return;
      }
      // Si se hace clic fuera del submenú, no hacer nada más
      return;
    }
    
    int altoTotal = etiquetasMenuPrincipal.length * altoBotonMenu + (etiquetasMenuPrincipal.length - 1) * espacioEntreBotonesMenu;
    int inicioY = (height - altoTotal) / 2;

    for (int indice = 0; indice < etiquetasMenuPrincipal.length; indice++) {
      int posicionBotonX = (width - anchoBotonMenu) / 2;
      int posicionBotonY = inicioY + indice * (altoBotonMenu + espacioEntreBotonesMenu);
      boolean clickEnBoton = mouseX >= posicionBotonX && mouseX <= posicionBotonX + anchoBotonMenu &&
                             mouseY >= posicionBotonY && mouseY <= posicionBotonY + altoBotonMenu;

      if (clickEnBoton) {
        if (indice == 0) {
          jugadoresSeleccionados = 4;
          estadoPantalla = ELEGIR_JUGADORES;
        } else if (indice == 1) {
          estadoPantalla = JUEGOS_LIBRES;
        } else if (indice == 2) {
          estadoPantalla = INSTRUCCIONES;
          submenuInstrucciones = -1;
        } else if (indice == 3) {
          mostrarCreditos = true; // Abrir créditos
        } else if (indice == 4) {
          exit();
        }
      }
    }

  // === JUEGOS LIBRES ===
  } else if (estadoPantalla == JUEGOS_LIBRES) {
    // Botón volver
    int botonVolverX = 30;
    int botonVolverY = 24;
    int botonVolverW = 140;
    int botonVolverH = 48;
    
    if (mouseX >= botonVolverX && mouseX <= botonVolverX + botonVolverW &&
        mouseY >= botonVolverY && mouseY <= botonVolverY + botonVolverH) {
      estadoPantalla = MENU;
      return;
    }
    
    // Configuración de botones (igual que instrucciones)
    int tamanoBoton = 100;
    int espacioEntreBotones = 30;
    int inicioX = (width - (3 * tamanoBoton + 2 * espacioEntreBotones)) / 2;
    int inicioY = 180;
    int espacioVertical = 140;
    
    // Verificar clic en botones de juegos
    for (int i = 0; i < 6; i++) {
      int fila = i / 3;
      int columna = i % 3;
      int x = inicioX + columna * (tamanoBoton + espacioEntreBotones);
      int y = inicioY + fila * espacioVertical;
      
      if (mouseX >= x && mouseX <= x + tamanoBoton &&
          mouseY >= y && mouseY <= y + tamanoBoton + 30) {
        // Inicializar variables necesarias para el juego
        cantidadJugadores = 1;
        jugadorActivo = 0;
        if (puntosJugador == null || puntosJugador.length == 0) {
          puntosJugador = new float[1];
          puntosJugador[0] = 0;
        } else {
          puntosJugador[0] = 0; // Resetear puntos
        }
        if (imagenesJugador == null || imagenesJugador.length == 0) {
          imagenesJugador = new PImage[1];
          // Verificar que spritesAv esté inicializado
          if (spritesAv != null && spritesAv.length > 0 && spritesAv[0] != null) {
            imagenesJugador[0] = spritesAv[0]; // Usar primer avatar por defecto
          } else {
            // Si spritesAv no está inicializado, intentar inicializarlo
            if (spritesAv == null) {
              spritesAv = new PImage[6];
            }
            // Si aún no hay imágenes, usar null (se dibujará un círculo)
            imagenesJugador[0] = null;
          }
        }
        
        desdeJuegosLibres = true; // Marcar que viene de juegos libres
        
        // Inicializar el juego correspondiente
        if (i == 0) { // Trivia
          mezclarPreguntasTrivia();
          preguntaActualTrivia = 0;
          preguntasContestadas = 0;
          puntajeTrivia = 0;
          juegoTerminadoTrivia = false;
          respuestaJugador = "";
          mensajeInput = "";
          botonesTriviaVisibles = false;
          campoActivoTrivia = true;
        } else if (i == 1) { // Corriente Desordenada
          if (paresApps == null || paresApps.length == 0) {
            // Si paresApps no está inicializado, volver al menú
            estadoPantalla = JUEGOS_LIBRES;
            return;
          }
          mezclarParesApps();
          appCorrectA = paresApps[indiceParesApps][0];
          appCorrectB = paresApps[indiceParesApps][1];
          indiceParesApps = (indiceParesApps + 1) % paresApps.length;
          String tmpA = appCorrectA;
          appScrambledA = "";
          while (tmpA.length() > 0) {
            int pick = int(random(tmpA.length()));
            appScrambledA += tmpA.substring(pick, pick+1);
            tmpA = tmpA.substring(0, pick) + tmpA.substring(pick+1);
          }
          String tmpB = appCorrectB;
          appScrambledB = "";
          while (tmpB.length() > 0) {
            int pick2 = int(random(tmpB.length()));
            appScrambledB += tmpB.substring(pick2, pick2+1);
            tmpB = tmpB.substring(0, pick2) + tmpB.substring(pick2+1);
          }
          inputOrdenA = "";
          inputOrdenB = "";
          campoActivoOrdenA = false;
          campoActivoOrdenB = false;
          seleccionComparacion = -1;
          juegoTerminadoOrden = false;
          mensajeOrden = "";
          mostrarResultadoOrden = false;
        } else if (i == 2) { // Kraken Envenenado
          if (frasesKraken == null || frasesKraken.length == 0) {
            // Si frasesKraken no está inicializado, volver al menú
            estadoPantalla = JUEGOS_LIBRES;
            return;
          }
          mezclarFrasesKraken();
          fraseKraken = frasesKraken[indiceFrasesKraken];
          indiceFrasesKraken = (indiceFrasesKraken + 1) % frasesKraken.length;
          // Verificar que cantidadJugadores esté inicializado para elegir oponente
          // Para juegos libres, simular 2 jugadores (jugadorActivo y un oponente virtual)
          if (cantidadJugadores < 2) {
            cantidadJugadores = 2;
            // Asegurar que puntosJugador tenga espacio para 2 jugadores
            if (puntosJugador == null || puntosJugador.length < 2) {
              float[] nuevoPuntos = new float[2];
              if (puntosJugador != null && puntosJugador.length > 0) {
                nuevoPuntos[0] = puntosJugador[0];
              }
              nuevoPuntos[1] = 0;
              puntosJugador = nuevoPuntos;
            }
            // Asegurar que imagenesJugador tenga espacio para 2 jugadores
            if (imagenesJugador == null || imagenesJugador.length < 2) {
              PImage[] nuevasImagenes = new PImage[2];
              if (imagenesJugador != null && imagenesJugador.length > 0) {
                nuevasImagenes[0] = imagenesJugador[0];
              } else if (spritesAv != null && spritesAv.length > 0 && spritesAv[0] != null) {
                nuevasImagenes[0] = spritesAv[0];
              }
              // Para el oponente virtual, usar otro avatar si está disponible
              if (spritesAv != null && spritesAv.length > 1 && spritesAv[1] != null) {
                nuevasImagenes[1] = spritesAv[1];
              } else if (spritesAv != null && spritesAv.length > 0 && spritesAv[0] != null) {
                nuevasImagenes[1] = spritesAv[0]; // Usar el mismo si no hay otro
              }
              imagenesJugador = nuevasImagenes;
            }
          }
          char[] letrasUnicas = new char[26];
          int totalUnicas = 0;
          for (int idx = 0; idx < fraseKraken.length(); idx++) {
            char ch = fraseKraken.charAt(idx);
            if (ch >= 'A' && ch <= 'Z') ch = char(ch - 'A' + 'a');
            if (ch >= 'a' && ch <= 'z') {
              boolean ya = false;
              for (int j = 0; j < totalUnicas; j++) {
                if (letrasUnicas[j] == ch) ya = true;
              }
              if (!ya && totalUnicas < 26) letrasUnicas[totalUnicas++] = ch;
            }
          }
          if (totalUnicas > 0) {
            letraInfectada = letrasUnicas[int(random(totalUnicas))];
          } else {
            letraInfectada = 'a';
          }
          totalLetrasElegidas = 0;
          for (int t = 0; t < letrasElegidas.length; t++) letrasElegidas[t] = ' ';
          inputLetraKraken = "";
          mensajeKraken = "Elige un oponente.";
          juegoTerminadoKraken = false;
          mostrarMensajeFinalKraken = false;
          oponenteElegido = false;
          jugadorOponente = -1;
          turnoKraken = 0;
        } else if (i == 3) { // Red del Abismo
          // Verificar que las variables del laberinto estén inicializadas
          if (matrizRed == null) {
            // Inicializar matriz si no existe
            filasRed = 10;
            columnasRed = 14;
            matrizRed = new int[filasRed][columnasRed];
            posXPerla = 1;
            posYPerla = 1;
          }
          inicializarLaberinto();
          tiempoInicioLaberinto = millis();
          puntosLaberinto = 0;
          juegoTerminadoLaberinto = false;
          puntosLaberintoOtorgados = false; // Resetear bandera para nuevo juego
          ganoLaberinto = false;
        } else if (i == 4) { // Ataque del Kraken Digital
          // Verificar que tentaculos esté inicializado
          if (tentaculos == null) {
            tentaculos = new int[6][2];
            tentaculoActivo = new boolean[6];
          }
          // Las variables ya están inicializadas globalmente, solo inicializar el juego
          inicializarMinijuegoKraken();
        } else if (i == 5) { // Flappy Ocean
          inicializarFlappyBird();
          flappyDesdeMenu = false; // No viene del menú, viene de juegos libres
        }
        
        // Asignar el estado del juego correspondiente
        if (i == 0) {
          estadoPantalla = JUEGO1;
        } else if (i == 1) {
          estadoPantalla = JUEGO2;
        } else if (i == 2) {
          estadoPantalla = JUEGO3;
        } else if (i == 3) {
          estadoPantalla = JUEGO4;
        } else if (i == 4) {
          estadoPantalla = JUEGO5;
        } else if (i == 5) {
          estadoPantalla = JUEGO6;
        }
        return;
      }
    }

  // === INSTRUCCIONES ===
  } else if (estadoPantalla == INSTRUCCIONES) {
    // Si hay un submenú abierto
    if (submenuInstrucciones >= 0) {
      // Botón cerrar
      int cerrarBotonX = width - 170, cerrarBotonY = 100, cerrarBotonAncho = 120, cerrarBotonAlto = 45;
      if (mouseX >= cerrarBotonX && mouseX <= cerrarBotonX + cerrarBotonAncho &&
          mouseY >= cerrarBotonY && mouseY <= cerrarBotonY + cerrarBotonAlto) {
        submenuInstrucciones = -1;
      }
    } else {
      // Menú principal - detectar clics en botones (mismos valores que en dibujo)
      int tamanoBoton = 100;
      int espacioEntreBotones = 30;
      int inicioX = (width - (5 * tamanoBoton + 4 * espacioEntreBotones)) / 2;
      int inicioY = 150;
      int espacioVertical = 160;
      
      for (int i = 0; i < 10; i++) {
        int fila = i / 5; // 2 filas de 5
        int columna = i % 5;
        int x = inicioX + columna * (tamanoBoton + espacioEntreBotones);
        int y = inicioY + fila * espacioVertical;
        
        // Área clickeable: incluye el botón y el texto debajo
        if (mouseX >= x && mouseX <= x + tamanoBoton &&
            mouseY >= y && mouseY <= y + tamanoBoton + 30) {
          submenuInstrucciones = i;
          break;
        }
      }
    }
    
    // Botón volver
    int volverBotonX = 30, volverBotonY = 24, volverBotonAncho = 140, volverBotonAlto = 48;
    if (mouseX >= volverBotonX && mouseX <= volverBotonX + volverBotonAncho &&
        mouseY >= volverBotonY && mouseY <= volverBotonY + volverBotonAlto) {
      if (submenuInstrucciones >= 0) {
        submenuInstrucciones = -1;
      } else {
        estadoPantalla = MENU;
        submenuInstrucciones = -1;
      }
    }

  // === ELEGIR JUGADORES ===
  } else if (estadoPantalla == ELEGIR_JUGADORES) {
    int anchoBotonSeleccion = 80, altoBotonSeleccion = 80, espacioEntreOpciones = 40;
    int anchoTotalOpciones = 3*anchoBotonSeleccion + 2*espacioEntreOpciones;
    int inicioXOpciones = width/2 - anchoTotalOpciones/2;
    int posicionYOpciones = height/2 - altoBotonSeleccion/2;

    for (int indiceOpcion = 0; indiceOpcion < 3; indiceOpcion++) {
      int posicionXOpcion = inicioXOpciones + indiceOpcion*(anchoBotonSeleccion + espacioEntreOpciones);
      if (mouseX >= posicionXOpcion && mouseX <= posicionXOpcion + anchoBotonSeleccion &&
          mouseY >= posicionYOpciones && mouseY <= posicionYOpciones + altoBotonSeleccion) {
        jugadoresSeleccionados = 2 + indiceOpcion;
      }
    }

    int anchoCampoRondas = 220, altoCampoRondas = 44;
    int campoRondasX = width/2 - anchoCampoRondas/2;
    int campoRondasY = posicionYOpciones + altoBotonSeleccion + 56;
    campoRondasActivo = (mouseX >= campoRondasX && mouseX <= campoRondasX + anchoCampoRondas &&
                         mouseY >= campoRondasY && mouseY <= campoRondasY + altoCampoRondas);

    int anchoBotonConfirmarVolver = 140, altoBotonConfirmarVolver = 48;
    int posicionYBotonesConfirmarVolver = campoRondasY + altoCampoRondas + 40;
    int botonConfirmarX = width/2 - (anchoBotonConfirmarVolver + 20);
    int botonVolverX    = width/2 + 20;

    boolean clickConfirmar = mouseX >= botonConfirmarX && mouseX <= botonConfirmarX + anchoBotonConfirmarVolver &&
                             mouseY >= posicionYBotonesConfirmarVolver && mouseY <= posicionYBotonesConfirmarVolver + altoBotonConfirmarVolver;
    boolean clickVolver    = mouseX >= botonVolverX && mouseX <= botonVolverX + anchoBotonConfirmarVolver &&
                             mouseY >= posicionYBotonesConfirmarVolver && mouseY <= posicionYBotonesConfirmarVolver + altoBotonConfirmarVolver;

    if (clickConfirmar) {
      // sonar(sfxClick); // Comentado: sfxClick puede no estar inicializado
      int rondasTemporal = 0;
      boolean valido = true;

      hayErrorRondas = false;
      mensajeRondas = "";

      if (tamBufferRondas == 0) {
        hayErrorRondas = true;
        mensajeRondas = "Escribe un número.";
        valido = false;
      }

      int iVal = 0;
      while (valido && iVal < tamBufferRondas) {
        char ch = bufferRondas[iVal];

        if (ch < '0' || ch > '9') {
          hayErrorRondas = true;
          mensajeRondas = "Entrada inválida: solo números (0–9).";
          valido = false;
        } else {
          int dig = ch - '0';
          if (rondasTemporal > 99) {
            hayErrorRondas = true;
            mensajeRondas = "Número inválido: debe estar entre 0 y 999.";
            valido = false;
          } else {
            rondasTemporal = rondasTemporal * 10 + dig;
          }
        }
        iVal = iVal + 1;
      }

      if (valido) {
  if (rondasTemporal < rondasMin || rondasTemporal > rondasMax) {
    hayErrorRondas = true;
    mensajeRondas = "Número inválido: debe estar entre " + rondasMin + " y " + rondasMax + ".";
    valido = false;
  }
}

      if (valido) {
        hayErrorRondas = false;
        mensajeRondas = "";

        cantidadJugadores = jugadoresSeleccionados;
        rondasTotales     = rondasTemporal;
        rondaActual       = 1;
        juegoTerminado    = false;

        posicionJugador = new int[cantidadJugadores];
        puntosJugador   = new float[cantidadJugadores];
        imagenesJugador = new PImage[cantidadJugadores];
        eleccionJugador = new int[cantidadJugadores];

        for (int iConf = 0; iConf < cantidadJugadores; iConf = iConf + 1) {
          posicionJugador[iConf] = 0;
          puntosJugador[iConf]   = 0;
          eleccionJugador[iConf] = -1;
        }

        for (int i = 0; i < 6; i = i + 1) {
          tomadoAv[i] = false;
        }

        jugadorActivo = 0;
        previewIdx = -1;
        estadoPantalla = SELECCION_AVATAR;

        tamBufferRondas = 0;
      }
    } else if (clickVolver) {
      // sonar(sfxClick); // Comentado: sfxClick puede no estar inicializado
      estadoPantalla = MENU;
    }

  // === SELECCIÓN DE AVATAR ===
  } else if (estadoPantalla == SELECCION_AVATAR) {
    int cardW = 200;
    int cardH = 240;
    int gap = 40;
    int gridW = cardW * 3 + gap * 2;
    int gridX = width/2 - gridW/2;
    int gridY = 180;
    
    int[] cardX = new int[6];
    int[] cardY = new int[6];
    
    // fila 1
    cardX[0] = gridX;                     cardY[0] = gridY;
    cardX[1] = gridX + (cardW + gap);     cardY[1] = gridY;
    cardX[2] = gridX + (cardW + gap) * 2; cardY[2] = gridY;
    // fila 2
    cardX[3] = gridX;                     cardY[3] = gridY + cardH + gap;
    cardX[4] = gridX + (cardW + gap);     cardY[4] = gridY + cardH + gap;
    cardX[5] = gridX + (cardW + gap) * 2; cardY[5] = gridY + cardH + gap;
    
    boolean clickEnTarjeta = false;
    int idxSeleccionado = -1;
    
    for (int i = 0; i < 6; i = i + 1) {
      boolean sobreTarjeta = estaSobre(mouseX, mouseY, cardX[i], cardY[i], cardW, cardH);
      if (sobreTarjeta && !tomadoAv[i]) {
        clickEnTarjeta = true;
        idxSeleccionado = i;
        break;
      }
    }
    
    if (clickEnTarjeta && idxSeleccionado != -1) {
      // sonar(sfxClick); // Comentado: sfxClick puede no estar inicializado
      eleccionJugador[jugadorActivo] = idxSeleccionado;
      tomadoAv[idxSeleccionado] = true;
      imagenesJugador[jugadorActivo] = spritesAv[idxSeleccionado];
      
      jugadorActivo = jugadorActivo + 1;
      previewIdx = -1;
      
      if (jugadorActivo >= cantidadJugadores) {
        jugadorActivo = 0;
        estadoPantalla = JUEGO;
      }
    } else {
      int botonAtrasX = width/2 - 70;
      int botonAtrasY = gridY + (cardH * 2 + gap) + 40;
      int botonAtrasW = 140;
      int botonAtrasH = 50;
      
      boolean clickAtras = estaSobre(mouseX, mouseY, botonAtrasX, botonAtrasY, botonAtrasW, botonAtrasH);
      
      if (clickAtras) {
        // sonar(sfxClick); // Comentado: sfxClick puede no estar inicializado
        boolean hayElecciones = false;
        for (int i = 0; i < cantidadJugadores; i = i + 1) {
          if (eleccionJugador[i] != -1) {
            hayElecciones = true;
          }
        }
        
        if (hayElecciones && jugadorActivo > 0) {
          jugadorActivo = jugadorActivo - 1;
          int idxElegido = eleccionJugador[jugadorActivo];
          if (idxElegido != -1) {
            tomadoAv[idxElegido] = false;
            eleccionJugador[jugadorActivo] = -1;
            imagenesJugador[jugadorActivo] = null;
          }
          previewIdx = -1;
        } else {
          estadoPantalla = ELEGIR_JUGADORES;
        }
      }
    }

  // === TABLERO ===
  } else {
if (preguntaVisible) {
  float btnSiX = width/2f - 90, btnSiY = height/2f + 30, btnSiW = 80, btnSiH = 40;
  float btnNoX = width/2f + 10,  btnNoY = height/2f + 30, btnNoW = 80, btnNoH = 40;

  boolean clickSi = mouseX >= btnSiX && mouseX <= btnSiX + btnSiW &&
                    mouseY >= btnSiY && mouseY <= btnSiY + btnSiH;
  boolean clickNo = mouseX >= btnNoX && mouseX <= btnNoX + btnNoW &&
                    mouseY >= btnNoY && mouseY <= btnNoY + btnNoH;

  if (clickSi || clickNo) {
    int idx = indicePreguntaActual;
    int efecto = efectoSiPermitir[idx]; // -1 si era peligroso, +1 si era seguro

    if (clickSi) {
      modificarPuntosJugador(efecto);
      if (efecto > 0)
        mostrarMensaje("Permitiste un permiso útil (+1)", 1000);
      else
        mostrarMensaje("¡Cuidado! Permitiste un permiso peligroso (-1)", 1000);
    } else { // clickNo
      modificarPuntosJugador(-efecto);
      if (efecto > 0)
        mostrarMensaje("Negaste un permiso útil (-1)", 1000);
      else
        mostrarMensaje("Negaste un permiso peligroso (+1)", 1000);
    }

    preguntaVisible = false;
    efectoCasillaAplicado = true;
    animacionEnCurso = false;
    esperandoEleccionRuta = false;
    finTurnoPendiente = true; // ✅ importante: cerrar turno
  }
}


    double dadoW = 197; // 2/3 de 295 (igual que en dibujo)
    double dadoH = 157; // 2/3 de 235 (igual que en dibujo)
    double dadoX = width - anchoPanelLateral / 2.0 - dadoW / 2.0; // Centrado (igual que en dibujo)
    double dadoY = 300; // Igual que en dibujo

    boolean clickDado =
      !juegoTerminado && !esperandoFinJuego && !animacionEnCurso && !esperandoEleccionRuta && !preguntaVisible && !finTurnoPendiente &&
      mouseX > dadoX && mouseX < dadoX + dadoW && mouseY > dadoY && mouseY < dadoY + dadoH;

    if (clickDado) {
      sonar(sfxDado);
      caraDado = int(random(1, 7));
      pasosRestantes = caraDado;
      animacionEnCurso = true;
      ultimoPasoMs = millis();
      efectoCasillaAplicado = false; // Resetear para que se ejecute el evento al finalizar
      if (rondaActual >= rondasTotales) {
  mensaje = "✅ Rondas completadas. Espere resultado...";
} else {
  mensaje = "Avanza " + caraDado + " casillas";
}
mostrarMensajeHastaMs = millis() + 800;

    } else if (esperandoEleccionRuta) {
      double paddingY = 64;
      double gapBotones = 16;
      double anchoBotonRuta = 96;
      double altoBotonRuta  = 34;

      double botonRutaAY = dadoY + dadoH + paddingY;
      double centroPanelX = width - anchoPanelLateral / 2.0;
      double anchoTotalBotones = 2*anchoBotonRuta + gapBotones;
      double botonRutaAX = centroPanelX - anchoTotalBotones / 2.0;
      double botonRutaBX = botonRutaAX + anchoBotonRuta + gapBotones;
      double botonRutaBY = botonRutaAY;

      boolean clickRutaA = esperandoEleccionRuta &&
        mouseX >= botonRutaAX && mouseX <= botonRutaAX + anchoBotonRuta &&
        mouseY >= botonRutaAY && mouseY <= botonRutaAY + altoBotonRuta;

      boolean clickRutaB = esperandoEleccionRuta &&
        mouseX >= botonRutaBX && mouseX <= botonRutaBX + anchoBotonRuta &&
        mouseY >= botonRutaBY && mouseY <= botonRutaBY + altoBotonRuta;
    if (clickRutaA || clickRutaB) {
      if (clickRutaA) {
        posicionJugador[jugadorActivo] = opcionesRuta[0];
      } else {
        posicionJugador[jugadorActivo] = opcionesRuta[1];
      }
      esperandoEleccionRuta = false;
      pasosRestantes--;

      if (pasosRestantes > 0) {
        animacionEnCurso = true;
        ultimoPasoMs = millis();
      } else {
        if (!efectoCasillaAplicado) {
          int casillaIndice = posicionJugador[jugadorActivo];
          int tipo = casillas[casillaIndice][2];
          if (tipo == 5) {
            preguntaVisible = true;
            int r = int(random(preguntasPermisos.length));
            textoPreguntaActual = preguntasPermisos[r];
          } else if (tipo == 2) {
            modificarPuntosJugador(-2);
            mensaje = "Casilla sospechosa (-2)";
            mostrarMensajeHastaMs = millis() + 1000;
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            finTurnoPendiente = true;
          } else if (tipo == 4) {
            modificarPuntosJugador(2);
            mensaje = "Casilla segura (+2)";
            mostrarMensajeHastaMs = millis() + 1000;
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            finTurnoPendiente = true;
          } 
          // INICIO PARCHE TRIVIA (entrada desde elección de ruta)
          else if (tipo == 6) {
            estadoPantalla = JUEGO1;
            mezclarPreguntasTrivia();
            preguntaActualTrivia = 0;
            preguntasContestadas = 0;
            puntajeTrivia = 0;
            juegoTerminadoTrivia = false;
            respuestaJugador = "";
            campoActivoTrivia = true;
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            esperandoEleccionRuta = false;
          }
          // INICIO PARCHE ORDEN (entrada desde elección de ruta)
          else if (tipo == 7) {
            // Preparar el minijuego 2: mezclar y elegir par
            mezclarParesApps();
            appCorrectA = paresApps[indiceParesApps][0];
            appCorrectB = paresApps[indiceParesApps][1];
            indiceParesApps = (indiceParesApps + 1) % paresApps.length;

            // Mezclar A
            String tmpA = appCorrectA;
            appScrambledA = "";
            while (tmpA.length() > 0) {
              int pick = int(random(tmpA.length()));
              appScrambledA += tmpA.substring(pick, pick+1);
              tmpA = tmpA.substring(0, pick) + tmpA.substring(pick+1);
            }
            // Mezclar B
            String tmpB = appCorrectB;
            appScrambledB = "";
            while (tmpB.length() > 0) {
              int pick2 = int(random(tmpB.length()));
              appScrambledB += tmpB.substring(pick2, pick2+1);
              tmpB = tmpB.substring(0, pick2) + tmpB.substring(pick2+1);
            }

            // Reiniciar inputs y flags
            inputOrdenA = "";
            inputOrdenB = "";
            campoActivoOrdenA = false;
            campoActivoOrdenB = false;
            seleccionComparacion = -1;
            juegoTerminadoOrden = false;
            mensajeOrden = "";
            mostrarResultadoOrden = false;

            estadoPantalla = JUEGO2;
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            esperandoEleccionRuta = false;
          }
          // INICIO PARCHE KRAKEN (entrada desde elección de ruta)
          else if (tipo == 8) {
            // Entrar al minijuego Kraken (Letra Envenenada)
            estadoPantalla = JUEGO3;

            // Mezclar frases y elegir una
            mezclarFrasesKraken();
            fraseKraken = frasesKraken[indiceFrasesKraken];
            indiceFrasesKraken = (indiceFrasesKraken + 1) % frasesKraken.length;

            // Elegir letra infectada: tomar una letra (a-z) presente en la frase
            char[] letrasUnicas = new char[26];
            int totalUnicas = 0;
            for (int idx = 0; idx < fraseKraken.length(); idx++) {
              char ch = fraseKraken.charAt(idx);
              if (ch >= 'A' && ch <= 'Z') ch = char(ch - 'A' + 'a');
              if (ch >= 'a' && ch <= 'z') {
                boolean ya = false;
                for (int j = 0; j < totalUnicas; j++) {
                  if (letrasUnicas[j] == ch) ya = true;
                }
                if (!ya && totalUnicas < 26) {
                  letrasUnicas[totalUnicas] = ch;
                  totalUnicas++;
                }
              }
            }
            if (totalUnicas > 0) {
              int pick = int(random(totalUnicas));
              letraInfectada = letrasUnicas[pick];
            } else {
              letraInfectada = 'a';
            }

            // Reinicio de estado interno
            totalLetrasElegidas = 0;
            for (int t = 0; t < letrasElegidas.length; t++) letrasElegidas[t] = ' ';
            inputLetraKraken = "";
            mensajeKraken = "Elige un oponente.";
            juegoTerminadoKraken = false;
            mostrarMensajeFinalKraken = false;

            oponenteElegido = false;
            jugadorOponente = -1;
            turnoKraken = jugadorActivo;

            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            esperandoEleccionRuta = false;
          }
          // INICIO PARCHE ATAQUE KRAKEN DIGITAL (entrada desde elección de ruta)
          else if (tipo == 10) {
            estadoPantalla = JUEGO5;
            inicializarMinijuegoKraken();
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            esperandoEleccionRuta = false;
          } else {
            // Casillas tipo 1 (salida) o tipo 3 (neutra) - sin efectos especiales
            efectoCasillaAplicado = true;
            animacionEnCurso = false;
            finTurnoPendiente = true;
          }

        }
      }
    }
  }
  
  //MINIJUEGO TRIVIA DEL ABISMO
manejarClicksTrivia();
  
 if (mostrarResultadoOrden) {
  if (mouseX >= width/2 - 140 && mouseX <= width/2 + 140 &&
      mouseY >= height/2 + 10 && mouseY <= height/2 + 62) {
    mostrarResultadoOrden = false;
    juegoTerminadoOrden = true;
    if (desdeJuegosLibres) {
      estadoPantalla = JUEGOS_LIBRES;
      desdeJuegosLibres = false;
    } else {
      estadoPantalla = JUEGO;
      efectoCasillaAplicado = true;
      finTurnoPendiente = true;
    }
  }
}
 else {
      // Solo procesar clicks si NO se está mostrando el resultado
      float cx = width/2;
      float bw = 160, bh = 48;

      // Para ser exactos usamos los mismos valores que en draw()
      float cy = 250 + 72 + 110;
      float ox = cx - (160*3 + 18*2)/2;

      // Botón Confirmar real
      float confirmBtnY = cy + 90;
      boolean clickConfirmar = mouseX >= cx - bw - 16 && mouseX <= cx - 16 &&
                               mouseY >= confirmBtnY && mouseY <= confirmBtnY + bh;
      // Botón No sé
      boolean clickNoSe = mouseX >= cx + 16 && mouseX <= cx + 16 + bw &&
                          mouseY >= confirmBtnY && mouseY <= confirmBtnY + bh;

      if (clickConfirmar) {
        // Verificar respuestas usando length() y substring() carácter a carácter
        // Normalizar (minúsculas y quitar espacios)
        String normCorrectA = appCorrectA.toLowerCase();
        normCorrectA = normCorrectA.replace(" ", "");
        String normCorrectB = appCorrectB.toLowerCase();
        normCorrectB = normCorrectB.replace(" ", "");

        String normInputA = inputOrdenA.toLowerCase();
        normInputA = normInputA.replace(" ", "");
        String normInputB = inputOrdenB.toLowerCase();
        normInputB = normInputB.replace(" ", "");

        boolean correctoA = false;
        if (normInputA.length() == normCorrectA.length()) {
          boolean igual = true;
          for (int i = 0; i < normCorrectA.length(); i++) {
            if (!normInputA.substring(i, i+1).equals(normCorrectA.substring(i, i+1))) {
              igual = false; break;
            }
          }
          correctoA = igual;
        }

        boolean correctoB = false;
        if (normInputB.length() == normCorrectB.length()) {
          boolean igual2 = true;
          for (int i = 0; i < normCorrectB.length(); i++) {
            if (!normInputB.substring(i, i+1).equals(normCorrectB.substring(i, i+1))) {
              igual2 = false; break;
            }
          }
          correctoB = igual2;
        }

        boolean correctoComparacion = false;
        if (seleccionComparacion == 0) {
          if (normCorrectA.length() > normCorrectB.length()) correctoComparacion = true;
        } else if (seleccionComparacion == 1) {
          if (normCorrectB.length() > normCorrectA.length()) correctoComparacion = true;
        } else if (seleccionComparacion == 2) {
          if (normCorrectA.length() == normCorrectB.length()) correctoComparacion = true;
        }

        if (correctoA && correctoB && correctoComparacion) {
          mensajeOrden = "¡Correcto! +2 puntos";
          modificarPuntosJugador(2);
        } else {
          mensajeOrden = "Incorrecto. No ganaste puntos.";
        }

        juegoTerminadoOrden = true;
        mostrarResultadoOrden = true;
      } else if (clickNoSe) {
        // Penalización inmediata
        modificarPuntosJugador(-2);
        mensajeOrden = "No supiste. -2 puntos";
        juegoTerminadoOrden = true;
        mostrarResultadoOrden = true;
      } else {
        // Solo procesar otros clicks si NO se confirmó ni se dijo "No sé"
        // Selección de comparación (tres opciones)
        float optW = 160, optH = 40, gap = 18;
        if (mouseY >= cy && mouseY <= cy + optH) {
          if (mouseX >= ox && mouseX <= ox + optW) seleccionComparacion = 0;
          else if (mouseX >= ox + (optW + gap) && mouseX <= ox + (optW + gap) + optW) seleccionComparacion = 1;
          else if (mouseX >= ox + 2*(optW + gap) && mouseX <= ox + 2*(optW + gap) + optW) seleccionComparacion = 2;
        }

        // Click en cajas para activarlas (usar mismos coords que draw)
        float boxW = 420, boxH = 44;
        float boxAX = width/2 - boxW/2, boxAY = 250;
        float boxBX = boxAX, boxBY = boxAY + 72;
        if (mouseX >= boxAX && mouseX <= boxAX + boxW && mouseY >= boxAY && mouseY <= boxAY + boxH) {
          campoActivoOrdenA = true; campoActivoOrdenB = false;
        } else if (mouseX >= boxBX && mouseX <= boxBX + boxW && mouseY >= boxBY && mouseY <= boxBY + boxH) {
          campoActivoOrdenA = false; campoActivoOrdenB = true;
        }
      }
    }
  }

  if (estadoPantalla == JUEGO3) {
    if (!oponenteElegido) {
      int bw = 140, bh = 46, gap = 18, baseY = 250, btnIndex = 0;
      for (int j = 0; j < cantidadJugadores; j++) {
        if (j != jugadorActivo) {
          int bx = width/2 - (bw + gap) * (cantidadJugadores-1) / 2 + btnIndex*(bw + gap);
          int by = baseY;
          boolean click = mouseX >= bx && mouseX <= bx + bw && mouseY >= by && mouseY <= by + bh;
          if (click) {
            oponenteElegido = true;
            jugadorOponente = j;
            turnoKraken = jugadorActivo;
            mensajeKraken = "Escribe tu letra.";
          }
          btnIndex++;
        }
      }
    } else if (mostrarMensajeFinalKraken) {
      // Detectar clic en botón "Volver al tablero"
      int botonAncho = 220;
      int botonAlto = 50;
      int botonX = width/2 - botonAncho/2;
      int botonY = height/2 + 40;
      
      boolean clickBoton = mouseX >= botonX && mouseX <= botonX + botonAncho && 
                          mouseY >= botonY && mouseY <= botonY + botonAlto;
      
    if (clickBoton) {
  // ✅ cerrar minijuego Kraken y pasar turno
  mostrarMensajeFinalKraken = false;
  juegoTerminadoKraken = true;
  if (desdeJuegosLibres) {
    estadoPantalla = JUEGOS_LIBRES;
    desdeJuegosLibres = false;
  } else {
    estadoPantalla = JUEGO;
    efectoCasillaAplicado = true;
    finTurnoPendiente = true;
  }
}


    
  }

}

// === CLICK EN MINIJUEGO KRAKEN (JUEGO5) ===
if (estadoPantalla == JUEGO5 && minijuegoKrakenTerminado) {
  if (mouseX >= width/2 - 80 && mouseX <= width/2 + 80 && 
      mouseY >= height/2 + 60 && mouseY <= height/2 + 110) {
    // Aplicar premios
    if (ganoKraken) {
      modificarPuntosJugador(2);
      mostrarMensaje("¡Sobreviviste al Kraken! (+2)", 1600);
    } else {
      modificarPuntosJugador(-1);
      mostrarMensaje("El Kraken te atrapó (-1)", 1600);
    }
    
    // Limpiar arrays y flags
    totalTentaculos = 0;
    for (int i = 0; i < MAX_TENTACULOS; i = i + 1) {
      tentaculoActivo[i] = false;
      tentaculos[i][0] = 0;
      tentaculos[i][1] = 0;
    }
    
    // Resetear shake y transformaciones para evitar que se queden aplicadas
    shakeX = 0;
    shakeY = 0;
    resetMatrix(); // Resetear la matriz de transformación
    imageMode(CORNER); // Asegurar que imageMode vuelva a CORNER
    
    // Volver
    if (desdeJuegosLibres) {
      estadoPantalla = JUEGOS_LIBRES;
      desdeJuegosLibres = false;
    } else {
      estadoPantalla = JUEGO;
      efectoCasillaAplicado = true;
      finTurnoPendiente = true;
    }
    enMinijuegoKraken = false;
    krakenPausa = false;
  }
}

// === CLICK EN PANTALLA FINAL ===
if (estadoPantalla == FINAL_JUEGO) {
  int bw = 200, bh = 60;
  int bx = width/2 - bw/2, by = height/2 + 120;

  boolean clickMenu = mouseX >= bx && mouseX <= bx + bw &&
                      mouseY >= by && mouseY <= by + bh;

  if (clickMenu) {
    estadoPantalla = MENU;
    juegoTerminado = false;
    rondaActual = 1;
  }
}
}
// Manejo de teclado

void keyPressed() {
  // Minijuego 6: Flappy Ocean
  if (estadoPantalla == JUEGO6) {
    if (key == ' ' || key == 'w' || key == 'W' || keyCode == UP) {
      if (juegoTerminadoFlappy) {
        if (flappyDesdeMenu) {
          // Volver al menú (modo prueba)
          estadoPantalla = MENU;
          flappyDesdeMenu = false;
        } else if (desdeJuegosLibres) {
          // Volver a juegos libres
          estadoPantalla = JUEGOS_LIBRES;
          desdeJuegosLibres = false;
        } else {
          // Volver al tablero
          if (ganoFlappy) {
            modificarPuntosJugador(2);
            mostrarMensaje("¡Flappy Ocean completado! (+2)", 1600);
          } else {
            // No otorgar puntos si perdió
            mostrarMensaje("Flappy Ocean: No completado (0 puntos)", 1600);
          }
          estadoPantalla = JUEGO;
          efectoCasillaAplicado = true;
          finTurnoPendiente = true;
        }
      } else {
        // Salto
        if (!juegoIniciadoFlappy) {
          juegoIniciadoFlappy = true;
        }
        flappyVelocidadY = flappyImpulso;
      }
    }
    return;
  }
  
  // === MINIJUEGO 1: TRIVIA ===
manejarTeclasTrivia();

  // === MINIJUEGO 2: ORDEN ===
  if (estadoPantalla == JUEGO2 && !mostrarResultadoOrden) {
    if (key == BACKSPACE || key == DELETE) {
      if (campoActivoOrdenA && inputOrdenA.length() > 0) {
        inputOrdenA = inputOrdenA.substring(0, inputOrdenA.length()-1);
      } else if (campoActivoOrdenB && inputOrdenB.length() > 0) {
        inputOrdenB = inputOrdenB.substring(0, inputOrdenB.length()-1);
      }
    } else if (key >= 32 && key <= 126) {
      if (campoActivoOrdenA) {
        inputOrdenA += key;
      } else if (campoActivoOrdenB) {
        inputOrdenB += key;
      }
    }
  }

  // === MINIJUEGO 3: KRAKEN ===
  if (estadoPantalla == JUEGO3 && oponenteElegido && !juegoTerminadoKraken) {
    if (key == BACKSPACE && inputLetraKraken.length() > 0) {
      inputLetraKraken = inputLetraKraken.substring(0, inputLetraKraken.length()-1);
      mensajeKraken = "";
    } else if (key == ENTER || key == RETURN) {
      boolean entradaValida = (inputLetraKraken.length() == 1 && 
                              inputLetraKraken.charAt(0) >= 'a' && 
                              inputLetraKraken.charAt(0) <= 'z');
      
      if (!entradaValida) {
        mensajeKraken = "Error: ingresa solo UNA letra minúscula (a-z) y presiona ENTER.";
      } else {
        char letraElegida = inputLetraKraken.charAt(0);
        
        boolean yaElegida = false;
for (int k = 0; k < totalLetrasElegidas && !yaElegida; k++) {
  if (letrasElegidas[k] == letraElegida) {
    yaElegida = true;
  }
}

        if (yaElegida) {
          mensajeKraken = "Esa letra ya fue elegida. Escoge otra.";
        } else {
          boolean encontrada = false;
          for (int i = 0; i < fraseKraken.length() && !encontrada; i++) {
  char ch = fraseKraken.charAt(i);
            if (ch >= 'A' && ch <= 'Z') {
              ch = char(ch - 'A' + 'a');
            }
             if (ch == letraElegida) {
    encontrada = true;
  }
}
          
          if (!encontrada) {
            mensajeKraken = "Esa letra no aparece en la frase.";
          } else {
            if (totalLetrasElegidas < letrasElegidas.length) {
              letrasElegidas[totalLetrasElegidas] = letraElegida;
              totalLetrasElegidas++;
            }
            
            if (letraElegida == letraInfectada) {
              modificarPuntosJugadorEspecifico(turnoKraken, -1);
              int otroJugador;
              if (turnoKraken == jugadorActivo) {
                otroJugador = jugadorOponente;
              } else {
                otroJugador = jugadorActivo;
              }
              modificarPuntosJugadorEspecifico(otroJugador, 2);
              
              mensajeKraken = "¡J" + (turnoKraken + 1) + " eligió la letra envenenada '" + letraInfectada + "'! Pierde 1 punto, J" + (otroJugador + 1) + " gana 2.";
              juegoTerminadoKraken = true;
              mostrarMensajeFinalKraken = true;
            } else {
              if (turnoKraken == jugadorActivo) {
                turnoKraken = jugadorOponente;
              } else {
                turnoKraken = jugadorActivo;
              }
              mensajeKraken = "";
            }
            
            inputLetraKraken = "";
          }
        }
      }
    } else {
      boolean esMinuscula = (key >= 'a' && key <= 'z');
      if (esMinuscula && inputLetraKraken.length() < 1) {
        inputLetraKraken += key;
        mensajeKraken = "";
      }
    }
  }
  // === Movimiento de la perla en el laberinto ===
if (estadoPantalla == JUEGO4 && !juegoTerminadoLaberinto) {
  if (keyCode == UP) moverPerla(0, -1);
  else if (keyCode == DOWN) moverPerla(0, 1);
  else if (keyCode == LEFT) moverPerla(-1, 0);
  else if (keyCode == RIGHT) moverPerla(1, 0);
}

  // === Pausa en minijuego Kraken Digital (JUEGO5) ===
  if (estadoPantalla == JUEGO5 && (key == 'p' || key == 'P')) {
    if (millis() - ultimaPausaMs > 200) {
      krakenPausa = !krakenPausa;
      ultimaPausaMs = millis();
    }
  }
  
  // === Movimiento del jugador en Ataque del Kraken (JUEGO5) ===
  if (estadoPantalla == JUEGO5 && !jugadorAtrapado && !minijuegoKrakenTerminado) {
    if (keyCode == UP) teclaArriba = true;
    else if (keyCode == DOWN) teclaAbajo = true;
    else if (keyCode == LEFT) teclaIzquierda = true;
    else if (keyCode == RIGHT) teclaDerecha = true;
  }

}

// ========================================
// INPUT - MANEJO DE TECLADO (KEY RELEASED)
// ========================================
void keyReleased() {
  // === Movimiento del jugador en Ataque del Kraken (JUEGO5) ===
  if (estadoPantalla == JUEGO5) {
    if (keyCode == UP) teclaArriba = false;
    else if (keyCode == DOWN) teclaAbajo = false;
    else if (keyCode == LEFT) teclaIzquierda = false;
    else if (keyCode == RIGHT) teclaDerecha = false;
  }
}
 
