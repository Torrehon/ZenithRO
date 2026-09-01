const { app, BrowserWindow, ipcMain } = require('electron');
const path = require('path');
const { spawn } = require('child_process');

function createWindow() {
    const win = new BrowserWindow({
        width: 1040,
        height: 640,
        resizable: false,
        frame: false, // Ventana sin bordes de Windows para apariencia personalizada
        transparent: true,
        icon: path.join(__dirname, 'assets/icon.ico'),
        webPreferences: {
            nodeIntegration: true,
            contextIsolation: false,
            autoplayPolicy: 'no-user-gesture-required' // Permite autoplay de vídeo y audio BGM
        }
    });

    win.loadFile(path.join(__dirname, 'index.html'));
}

app.whenReady().then(createWindow);

// Eventos de control de ventana
ipcMain.on('close-app', () => app.quit());
ipcMain.on('minimize-app', () => BrowserWindow.getFocusedWindow()?.minimize());

// Evento para lanzar ZenithRO.exe al pulsar JUGAR
ipcMain.on('launch-game', (event, clientName = 'ZenithRO.exe') => {
    const gamePath = path.join(__dirname, '..', clientName);
    
    try {
        const gameProcess = spawn(gamePath, [], {
            detached: true,
            stdio: 'ignore'
        });
        gameProcess.unref();
        app.quit(); // Cierra el launcher tras iniciar el cliente
    } catch (err) {
        console.error("Error al iniciar ejecutable ZenithRO.exe:", err);
    }
});
