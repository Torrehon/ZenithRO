<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zenith RO - Registro</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Outfit:wght@600;700;800;900&family=Rajdhani:wght@700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <!-- Vivid Video Background Layer -->
    <div class="video-container">
        <video id="bgVideo" autoplay loop muted playsinline poster="assets/background_fallback.jpg">
            <source src="assets/background.mp4" type="video/mp4">
        </video>
        <div class="video-overlay"></div>
    </div>

    <!-- Background BGM Audio -->
    <audio id="bgMusic" loop autoplay>
        <source src="assets/music.mp3" type="audio/mp3">
    </audio>

    <!-- Main Container -->
    <div class="web-app">
        <!-- Top Navigation Bar -->
        <header class="navbar">
            <!-- 100% Larger Volume Control Widget on Top Left -->
            <div class="volume-control-widget-large">
                <button class="win-btn-lg" id="btnToggleAudio" title="Música (Mute / Unmute)">
                    <svg id="iconAudioOn" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><path d="M19.07 4.93a10 10 0 0 1 0 14.14M15.54 8.46a5 5 0 0 1 0 7.07"></path></svg>
                    <svg id="iconAudioOff" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" style="display: none;"><polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"></polygon><line x1="23" y1="9" x2="17" y2="15"></line><line x1="17" y1="9" x2="23" y2="15"></line></svg>
                </button>
                <input type="range" id="volumeSlider" min="0" max="100" value="50" class="volume-slider-lg" title="Volumen BGM (50%)">
            </div>

            <!-- Download Button Justified / Aligned above Right Registration Column -->
            <div class="nav-actions-right">
                <a href="https://drive.google.com/your-download-link-here" target="_blank" class="download-btn-lg">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4"></path><polyline points="7 10 12 15 17 10"></polyline><line x1="12" y1="15" x2="12" y2="3"></line></svg>
                    <span>DESCARGAR CLIENTE (Google Drive)</span>
                </a>
            </div>
        </header>

        <!-- Central Content Grid -->
        <main class="content-grid">
            <!-- Left Hero Section - Server Logo Far Away from Registration Box -->
            <section class="hero-section">
                <div class="hero-logo-box">
                    <img src="assets/logo.png" alt="Zenith RO Logo" class="hero-logo-img" onerror="this.style.display='none'; document.getElementById('emblemFallback').style.display='flex';">
                    
                    <!-- Fallback Logo Emblem if logo.png is not present -->
                    <div class="emblem-fallback" id="emblemFallback" style="display: none;">
                        <h1 class="hero-title">ZENITH <span>RO</span></h1>
                        <span class="hero-subtitle">RAGNAROK ONLINE</span>
                    </div>
                </div>
            </section>

            <!-- Right Registration Form Card -->
            <section class="register-section">
                <div class="glass-card register-card">
                    <div class="card-header">
                        <h2>CREAR CUENTA</h2>
                    </div>

                    <div id="alertBox" class="alert-box" style="display: none;"></div>

                    <form id="registerForm" action="register.php" method="POST">
                        <div class="input-group">
                            <label for="username">Nombre de Usuario</label>
                            <input type="text" id="username" name="username" placeholder="Usuario" required autocomplete="off">
                        </div>

                        <div class="input-group">
                            <label for="password">Contraseña</label>
                            <input type="password" id="password" name="password" placeholder="••••••••" required>
                        </div>

                        <div class="input-group">
                            <label for="confirm_password">Repetir Contraseña</label>
                            <input type="password" id="confirm_password" name="confirm_password" placeholder="••••••••" required>
                        </div>

                        <div class="input-group">
                            <label for="email">Correo Electrónico</label>
                            <input type="email" id="email" name="email" placeholder="tu_correo@gmail.com" required>
                        </div>

                        <button type="submit" class="submit-btn" id="btnSubmit">
                            <span id="btnText">CREAR CUENTA</span>
                        </button>
                    </form>
                </div>
            </section>
        </main>
    </div>

    <script src="app.js"></script>
</body>
</html>
