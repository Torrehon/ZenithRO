<?php
/**
 * Zenith RO - Configuración de Conexión MySQL para rAthena
 */

// Parámetros de la Base de Datos
define('DB_HOST', 'localhost');     // En tu XAMPP local es 'localhost'
define('DB_USER', 'root');          // Usuario por defecto en XAMPP es 'root'
define('DB_PASS', '');              // Contraseña por defecto en XAMPP es vacía ''
define('DB_NAME', 'ragnarok');      // Nombre de la base de datos de rAthena

// Cifrado de Contraseñas rAthena ('md5', 'sha256' o 'plaintext')
// La mayoría de servidores rAthena usan 'md5' por defecto
define('PASSWORD_HASH', 'md5');

// Función de conexión PDO segura
function getDBConnection() {
    try {
        $dsn = "mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4";
        $options = [
            PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
            PDO::ATTR_EMULATE_PREPARES   => false,
        ];
        return new PDO($dsn, DB_USER, DB_PASS, $options);
    } catch (PDOException $e) {
        die(json_encode([
            'success' => false,
            'message' => 'Error de conexión con la Base de Datos: ' . $e->getMessage()
        ]));
    }
}
?>
