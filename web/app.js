/**
 * Zenith RO - Web Registration Form Controller & Ultra-Responsive BGM Autoplay
 */

document.addEventListener('DOMContentLoaded', () => {
    const registerForm = document.getElementById('registerForm');
    const alertBox = document.getElementById('alertBox');
    const btnSubmit = document.getElementById('btnSubmit');
    const btnText = document.getElementById('btnText');

    // BGM Elements
    const bgMusic = document.getElementById('bgMusic');
    const volumeSlider = document.getElementById('volumeSlider');
    const btnToggleAudio = document.getElementById('btnToggleAudio');
    const iconAudioOn = document.getElementById('iconAudioOn');
    const iconAudioOff = document.getElementById('iconAudioOff');

    let isAudioPlaying = false;
    let lastNonZeroVolume = 0.5;

    // 1. Configurar Audio al 50% por defecto
    if (bgMusic) {
        bgMusic.volume = 0.5;
    }

    const updateAudioIcons = (vol) => {
        if (!iconAudioOn || !iconAudioOff) return;
        if (vol === 0 || bgMusic.muted) {
            iconAudioOn.style.display = 'none';
            iconAudioOff.style.display = 'block';
        } else {
            iconAudioOn.style.display = 'block';
            iconAudioOff.style.display = 'none';
        }
    };

    // Función para intentar reproducir la música inmediatamente
    const forcePlayAudio = () => {
        if (!bgMusic || isAudioPlaying) return;
        
        bgMusic.volume = volumeSlider ? (volumeSlider.value / 100) : 0.5;
        bgMusic.muted = false;

        const playPromise = bgMusic.play();
        if (playPromise !== undefined) {
            playPromise.then(() => {
                isAudioPlaying = true;
                updateAudioIcons(bgMusic.volume);
                removeInteractionListeners();
            }).catch(err => {
                // El navegador bloqueó el autoplay sin gesto previo
                console.log("Autoplay bloqueado por políticas del navegador. Esperando interacción...");
            });
        }
    };

    // Intentar reproducción inmediata al cargar el DOM
    forcePlayAudio();

    // Disparar audio inmediatamente al mover el ratón, hacer scroll, tocar la pantalla o pulsar cualquier tecla
    const userInteractionEvents = ['click', 'mousemove', 'keydown', 'scroll', 'touchstart', 'pointerdown'];

    const onUserInteract = () => {
        if (!isAudioPlaying) {
            forcePlayAudio();
        }
    };

    userInteractionEvents.forEach(eventType => {
        window.addEventListener(eventType, onUserInteract, { passive: true });
    });

    const removeInteractionListeners = () => {
        userInteractionEvents.forEach(eventType => {
            window.removeEventListener(eventType, onUserInteract);
        });
    };

    // Manejador del Deslizador de Volumen
    if (volumeSlider) {
        volumeSlider.addEventListener('input', (e) => {
            const val = parseFloat(e.target.value) / 100;
            if (bgMusic) {
                bgMusic.volume = val;
                if (val > 0) {
                    bgMusic.muted = false;
                    lastNonZeroVolume = val;
                    if (bgMusic.paused) {
                        bgMusic.play().then(() => { isAudioPlaying = true; }).catch(() => {});
                    }
                }
                updateAudioIcons(val);
            }
        });
    }

    // Botón de Mute / Unmute
    if (btnToggleAudio) {
        btnToggleAudio.addEventListener('click', () => {
            if (!bgMusic) return;

            if (bgMusic.muted || bgMusic.volume === 0 || bgMusic.paused) {
                bgMusic.muted = false;
                const newVol = lastNonZeroVolume > 0 ? lastNonZeroVolume : 0.5;
                bgMusic.volume = newVol;
                if (volumeSlider) volumeSlider.value = newVol * 100;
                bgMusic.play().then(() => { isAudioPlaying = true; }).catch(() => {});
                updateAudioIcons(newVol);
            } else {
                bgMusic.muted = true;
                if (volumeSlider) volumeSlider.value = 0;
                updateAudioIcons(0);
            }
        });
    }

    // 2. Registro AJAX Form Handler
    if (registerForm) {
        registerForm.addEventListener('submit', async (e) => {
            e.preventDefault();

            alertBox.style.display = 'none';
            alertBox.className = 'alert-box';

            const formData = new FormData(registerForm);

            btnSubmit.disabled = true;
            btnText.textContent = "CREANDO CUENTA...";

            try {
                const response = await fetch('register.php', {
                    method: 'POST',
                    body: formData
                });

                const result = await response.json();

                if (result.success) {
                    alertBox.className = 'alert-box success';
                    alertBox.textContent = result.message;
                    alertBox.style.display = 'block';
                    registerForm.reset();
                } else {
                    alertBox.className = 'alert-box error';
                    alertBox.textContent = result.message;
                    alertBox.style.display = 'block';
                }
            } catch (error) {
                console.error("Error en el registro:", error);
                alertBox.className = 'alert-box error';
                alertBox.textContent = "Ocurrió un error al conectar con el servidor. Verifica tu conexión.";
                alertBox.style.display = 'block';
            } finally {
                btnSubmit.disabled = false;
                btnText.textContent = "CREAR CUENTA";
            }
        });
    }
});
