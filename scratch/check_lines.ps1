$backupPath = "d:\SERVER_RO\LevitationRO\scratch\extracted_backup\itemInfo.lua"
$enc = [System.Text.Encoding]::GetEncoding(949)
$lines = [System.IO.File]::ReadAllLines($backupPath, $enc)

for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match '^\s*\[5383\]\s*=\s*\{') {
        Write-Host "Real 5383 line index:" $i
        for ($j = $i; $j -le ($i + 15); $j++) {
            Write-Host $j ":" $lines[$j]
        }
        break
    }
}
