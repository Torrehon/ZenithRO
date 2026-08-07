========================================================================
ZENITH RO - INSTRUCCIONES DE LA WEB DE REGISTRO Y DESCARGA
========================================================================

¡Hola! He creado la estructura completa de la Web de Registro y Landing Page para Zenith RO en esta carpeta (web/).

------------------------------------------------------------------------
PASO 1: CÓMO PROBARLA EN TU XAMPP LOCAL
------------------------------------------------------------------------
1. Copia todos los archivos de esta carpeta (web/) dentro de la carpeta de XAMPP:
   C:\xampp\htdocs\zenithweb\

2. Abre tu panel de XAMPP y enciende Apache y MySQL (clic en Start en ambos).

3. Abre tu navegador e ingresa a:
   http://localhost/zenithweb/

4. Revisa que en config.php la constante DB_NAME coincida con el nombre de tu base de datos de rAthena (por defecto 'ragnarok').

------------------------------------------------------------------------
PASO 2: CÓMO SUBIRLA A TU SERVIDOR DE PRODUCCIÓN (MobaXterm + HeidiSQL)
------------------------------------------------------------------------
1. En HeidiSQL: Conéctate a tu base de datos remota y verifica el nombre de tu base de datos rAthena.

2. En config.php: Cambia DB_HOST, DB_USER, DB_PASS y DB_NAME con los datos de tu servidor remoto.

3. En MobaXterm:
   - Abre la sesión SSH de tu servidor Linux.
   - En la pestaña SFTP del panel izquierdo de MobaXterm, navega hasta la carpeta pública de tu web (ej. /var/www/html/).
   - Arrastra todos los archivos de la carpeta web/ directamente a MobaXterm.

------------------------------------------------------------------------
PERSONALIZACIÓN FÁCIL:
- En index.php: Puedes cambiar el enlace de Google Drive reemplazando "https://drive.google.com/your-download-link-here" con el link de tu cliente comprimido.
- En assets/: Puedes colocar tu logo.png y background.mp4 para que la web tenga la misma estética animada que el launcher.
