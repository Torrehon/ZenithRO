# Guía de Monitorización en Vivo de rAthena (MobaXterm / VPS)

Esta guía documenta la solución implementada para ver la salida de consola en vivo (`map-server`, `char-server`, `login-server`) en tu VPS sin necesidad de reiniciar los procesos ni interferir con la ejecución normal.

---

## 1. El Script de Monitorización (`~/monitor.sh`)

Este script localiza dinámicamente los PIDs de los servidores de rAthena que estén activos y se acopla a sus descriptores de salida usando `strace`, formateando el texto en tiempo real con Python para evitar caracteres de escape o problemas de saltos de línea (`\r`).

Para crearlo o restaurarlo en el VPS:

```bash
cat << 'EOF' > ~/monitor.sh
#!/bin/bash

# 1. Asegurar que no hay otro strace bloqueando los procesos
killall -9 strace 2>/dev/null

# 2. Detectar PIDs de rAthena activos
PIDS=$(pgrep -f '\./(map|char|login)-server')

if [ -z "$PIDS" ]; then
    PIDS=$(pidof map-server char-server login-server)
fi

if [ -z "$PIDS" ]; then
    echo -e "\e[31m[!] No se encontraron servidores rAthena en ejecución.\e[0m"
    echo -e "\e[33m[i] Ejecuta 'encender' o 'reiniciar' primero.\e[0m"
    exit 1
fi

STRACE_ARGS=""
for pid in $PIDS; do
    STRACE_ARGS="$STRACE_ARGS -p $pid"
done

echo -e "\e[32m[+] Conectando a rAthena (PIDs: $(echo $PIDS | tr '\n' ' '))...\e[0m"
echo -e "\e[33m[i] Pulsa Ctrl+C en cualquier momento para volver a tu terminal.\e[0m"
echo "--------------------------------------------------------"

# 3. Monitorizar en tiempo real mostrando salida formateada y errores de strace
strace -q -e write -s 4096 $STRACE_ARGS 2>&1 | python3 -u -c '
import sys, re

for line in sys.stdin:
    m = re.search(r"write\([12], \"(.*)\", \d+\)", line)
    if m:
        try:
            text = m.group(1).encode("utf-8").decode("unicode_escape", "replace")
            text = re.sub(r"\r(?!\n)", "\n", text)
            sys.stdout.write(text)
            sys.stdout.flush()
        except Exception:
            pass
    elif "strace:" in line or "attach:" in line:
        sys.stdout.write("\033[31m" + line.strip() + "\033[0m\n")
        sys.stdout.flush()
'
EOF

chmod +x ~/monitor.sh
```

---

## 2. Alias Rápido (`rlog`)

Para no tener que recordar la ruta del script y poder abrir la consola tecleando solo `rlog`:

```bash
echo "alias rlog='~/monitor.sh'" >> ~/.bashrc
source ~/.bashrc
```

- **Para entrar:** Escribe `rlog`.
- **Para salir:** Pulsa `Ctrl+C` (vuelve a la terminal normal sin afectar al servidor).

---

## 3. Apertura Automática en MobaXterm (Opcional)

Si deseas que la consola aparezca automáticamente al abrir la sesión SSH en MobaXterm:

1. En MobaXterm, clic derecho en la sesión guardada -> **Edit session**.
2. Ir a la pestaña **Advanced SSH settings**.
3. Activar la casilla **Execute command** y poner:
   ```bash
   ~/monitor.sh
   ```
4. Pulsar **OK**. Al conectar iniciará el monitor; si pulsas `Ctrl+C`, te devuelve a tu terminal normal de Linux.

---

## 4. Interacción con `encender`, `apagar` y `reiniciar`

| Comando / Evento | Comportamiento con el Monitor |
| :--- | :--- |
| **`encender`** | Arranca nuevos procesos. Al ejecutar `rlog`, el script detecta los nuevos PIDs al vuelo. |
| **`apagar`** | Cierra los servidores. Si estabas dentro de `rlog`, la monitorización finaliza automáticamente y te devuelve a la consola. |
| **`reiniciar`** | Mata los procesos anteriores y crea nuevos PIDs. Solo debes volver a escribir `rlog` una vez iniciado. |
| **Seguridad** | `strace` es **estrictamente de solo lectura** de streams (`write`). No modifica memoria, archivos, bases de datos ni el flujo del servidor. |
