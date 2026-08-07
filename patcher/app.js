/**
 * Zenith RO - Minimalist Patcher Controller with Volume Slider and Pure Opacity Logo Entrance
 */

document.addEventListener('DOMContentLoaded', () => {
    // Elements
    const bgVideo = document.getElementById('bgVideo');
    const bgMusic = document.getElementById('bgMusic');
    const volumeSlider = document.getElementById('volumeSlider');
    
    // Toggle Buttons & Icons
    const btnToggleVideo = document.getElementById('btnToggleVideo');
    const iconVideoPause = document.getElementById('iconVideoPause');
    const iconVideoPlay = document.getElementById('iconVideoPlay');

    const btnToggleAudio = document.getElementById('btnToggleAudio');
    const iconAudioOn = document.getElementById('iconAudioOn');
    const iconAudioOff = document.getElementById('iconAudioOff');

    // Status & Progress Elements
    const statusText = document.getElementById('statusText');
    const progressPercent = document.getElementById('progressPercent');
    const progressBarFill = document.getElementById('progressBarFill');
    const downloadDetails = document.getElementById('downloadDetails');
    const downloadSpeed = document.getElementById('downloadSpeed');
    const btnPlay = document.getElementById('btnPlay');
    const playBtnText = document.getElementById('playBtnText');

    // Settings Modal
    const btnSettings = document.getElementById('btnSettings');
    const settingsModal = document.getElementById('settingsModal');
    const btnCloseSettings = document.getElementById('btnCloseSettings');
    const btnSaveSettings = document.getElementById('btnSaveSettings');

    let isAudioPlaying = false;
    let isVideoPaused = false;
    let lastNonZeroVolume = 0.5;

    // 1. Force Video Playback
    if (bgVideo) {
        bgVideo.play().catch(err => {
            console.warn("Autoplay de vídeo bloqueado por el navegador:", err);
        });
    }

    // 2. Default Audio Setup (Starts at 50% Volume)
    if (bgMusic) {
        bgMusic.volume = 0.5; // 50% volumen por defecto
    }

    const updateAudioIcons = (volume) => {
        if (volume === 0 || bgMusic.muted) {
            iconAudioOn.style.display = 'none';
            iconAudioOff.style.display = 'block';
            btnToggleAudio.classList.remove('active');
        } else {
            iconAudioOn.style.display = 'block';
            iconAudioOff.style.display = 'none';
            btnToggleAudio.classList.add('active');
        }
    };

    const tryPlayAudio = () => {
        if (!bgMusic) return;
        bgMusic.volume = volumeSlider ? (volumeSlider.value / 100) : 0.5;
        bgMusic.play().then(() => {
            isAudioPlaying = true;
            updateAudioIcons(bgMusic.volume);
        }).catch(err => {
            console.log("Esperando interacción del usuario para reproducir audio...");
        });
    };

    // Volume Slider Input Event Handler
    if (volumeSlider) {
        volumeSlider.addEventListener('input', (e) => {
            const val = parseFloat(e.target.value) / 100;
            if (bgMusic) {
                bgMusic.volume = val;
                if (val > 0) {
                    bgMusic.muted = false;
                    lastNonZeroVolume = val;
                    if (bgMusic.paused) {
                        bgMusic.play().catch(() => {});
                    }
                }
                updateAudioIcons(val);
            }
        });
    }

    // Audio Toggle Mute / Unmute Button
    if (btnToggleAudio) {
        btnToggleAudio.addEventListener('click', () => {
            if (!bgMusic) return;

            if (bgMusic.muted || bgMusic.volume === 0) {
                bgMusic.muted = false;
                const newVol = lastNonZeroVolume > 0 ? lastNonZeroVolume : 0.5;
                bgMusic.volume = newVol;
                if (volumeSlider) volumeSlider.value = newVol * 100;
                bgMusic.play().catch(() => {});
                updateAudioIcons(newVol);
            } else {
                bgMusic.muted = true;
                if (volumeSlider) volumeSlider.value = 0;
                updateAudioIcons(0);
            }
        });
    }

    // Autoplay audio on first user click anywhere
    document.body.addEventListener('click', () => {
        if (!isAudioPlaying) {
            tryPlayAudio();
        }
    }, { once: true });

    // 3. Video Pause / Freeze at Frame 1 Toggle
    if (btnToggleVideo) {
        btnToggleVideo.addEventListener('click', () => {
            isVideoPaused = !isVideoPaused;

            if (isVideoPaused) {
                bgVideo.pause();
                bgVideo.currentTime = 0; // Freeze at Frame 1
                iconVideoPause.style.display = 'none';
                iconVideoPlay.style.display = 'block';
                btnToggleVideo.classList.add('active');
            } else {
                bgVideo.play();
                iconVideoPause.style.display = 'block';
                iconVideoPlay.style.display = 'none';
                btnToggleVideo.classList.remove('active');
            }
        });
    }

    // 4. Modal Events
    if (btnSettings) {
        btnSettings.addEventListener('click', () => settingsModal.classList.add('active'));
    }
    if (btnCloseSettings) {
        btnCloseSettings.addEventListener('click', () => settingsModal.classList.remove('active'));
    }
    if (btnSaveSettings) {
        btnSaveSettings.addEventListener('click', () => settingsModal.classList.remove('active'));
    }

    // 5. Simulated Patch Progress
    const simulatePatching = () => {
        let currentStep = 0;
        const steps = [
            { text: "Comprobando servidor Zenith RO...", details: "Conectando...", speed: "0.0 MB/s", targetProgress: 15 },
            { text: "Verificando integridad de archivos...", details: "Analizando GRF...", speed: "0.0 MB/s", targetProgress: 35 },
            { text: "Descargando patch_2026_zenith.gpf...", details: "24.5 MB / 48.0 MB", speed: "5.4 MB/s", targetProgress: 75 },
            { text: "Actualizando cliente ZenithRO.exe...", details: "Finalizando...", speed: "11.2 MB/s", targetProgress: 95 },
            { text: "¡Servidor Zenith RO listo para jugar!", details: "Todos los archivos actualizados correctamente.", speed: "ONLINE", targetProgress: 100 }
        ];

        let progress = 0;
        const interval = setInterval(() => {
            const step = steps[currentStep];
            statusText.textContent = step.text;
            downloadDetails.textContent = step.details;
            downloadSpeed.textContent = step.speed;

            progress += Math.floor(Math.random() * 6) + 4;

            if (progress >= step.targetProgress) {
                progress = step.targetProgress;
                currentStep++;
            }

            progressPercent.textContent = `${progress}%`;
            progressBarFill.style.width = `${progress}%`;

            if (progress >= 100) {
                clearInterval(interval);
                onPatchComplete();
            }
        }, 250);
    };

    const onPatchComplete = () => {
        btnPlay.disabled = false;
        btnPlay.classList.add('ready');
        playBtnText.textContent = "JUGAR";
    };

    btnPlay.addEventListener('click', () => {
        if (btnPlay.disabled) return;
        playBtnText.textContent = "INICIANDO...";
        btnPlay.disabled = true;

        if (window.require) {
            try {
                const { ipcRenderer } = window.require('electron');
                ipcRenderer.send('launch-game', 'ZenithRO.exe');
                return;
            } catch (e) {
                console.warn("Navegador web detectado (fuera de Electron).");
            }
        }

        setTimeout(() => {
            alert("¡Ejecutando juego! (Iniciando ZenithRO.exe).");
            playBtnText.textContent = "JUGAR";
            btnPlay.disabled = false;
        }, 1200);
    });

    setTimeout(simulatePatching, 600);
});
