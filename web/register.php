<?php
/**
 * Zenith RO - Backend PHP de Registro de Cuentas rAthena
 */
header('Content-Type: application/json; charset=utf-8');
require_once 'config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['success' => false, 'message' => 'Método de solicitud no permitido.']);
    exit;
}

// Obtener y limpiar datos del formulario
$username = trim($_POST['username'] ?? '');
$password = trim($_POST['password'] ?? '');
$confirm_pass = trim($_POST['confirm_password'] ?? '');
$email = trim($_POST['email'] ?? '');
$gender = strtoupper(trim($_POST['gender'] ?? 'M'));

// 1. Validaciones
if (empty($username) || empty($password) || empty($email)) {
    echo json_encode(['success' => false, 'message' => 'Por favor, rellena todos los campos obligatorios.']);
    exit;
}

if ($password !== $confirm_pass) {
    echo json_encode(['success' => false, 'message' => 'Las contraseñas no coinciden.']);
    exit;
}

if (strlen($username) < 4 || strlen($username) > 23) {
    echo json_encode(['success' => false, 'message' => 'El nombre de usuario debe tener entre 4 y 23 caracteres.']);
    exit;
}

if (!preg_match('/^[a-zA-Z0-9_]+$/', $username)) {
    echo json_encode(['success' => false, 'message' => 'El usuario solo puede contener letras, números y guiones bajos.']);
    exit;
}

if (strlen($password) < 6) {
    echo json_encode(['success' => false, 'message' => 'La contraseña debe tener al menos 6 caracteres.']);
    exit;
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    echo json_encode(['success' => false, 'message' => 'El correo electrónico no es válido.']);
    exit;
}

if ($gender !== 'M' && $gender !== 'F') {
    $gender = 'M';
}

try {
    $pdo = getDBConnection();

    // 2. Comprobar si el usuario ya existe
    $stmt = $pdo->prepare("SELECT account_id FROM login WHERE userid = :userid LIMIT 1");
    $stmt->execute([':userid' => $username]);
    if ($stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Este nombre de usuario ya está registrado.']);
        exit;
    }

    // 3. Comprobar si el email ya existe
    $stmt = $pdo->prepare("SELECT account_id FROM login WHERE email = :email LIMIT 1");
    $stmt->execute([':email' => $email]);
    if ($stmt->fetch()) {
        echo json_encode(['success' => false, 'message' => 'Este correo electrónico ya está registrado.']);
        exit;
    }

    // 4. Cifrado de Contraseña según configuración
    $hashed_password = $password;
    if (PASSWORD_HASH === 'md5') {
        $hashed_password = md5($password);
    } elseif (PASSWORD_HASH === 'sha256') {
        $hashed_password = hash('sha256', $password);
    }

    // 5. Insertar nueva cuenta en la tabla 'login' de rAthena
    $sql = "INSERT INTO login (userid, user_pass, sex, email, group_id, state) 
            VALUES (:userid, :user_pass, :sex, :email, 0, 0)";
    
    $stmt = $pdo->prepare($sql);
    $success = $stmt->execute([
        ':userid'    => $username,
        ':user_pass' => $hashed_password,
        ':sex'       => $gender,
        ':email'     => $email
    ]);

    if ($success) {
        echo json_encode([
            'success' => true,
            'message' => '¡Cuenta registrada con éxito en Zenith RO! Ya puedes iniciar sesión en el juego.'
        ]);
    } else {
        echo json_encode(['success' => false, 'message' => 'No se pudo crear la cuenta. Inténtalo de nuevo.']);
    }

} catch (PDOException $e) {
    echo json_encode([
        'success' => false,
        'message' => 'Error en la base de datos: ' . $e->getMessage()
    ]);
}
?>
