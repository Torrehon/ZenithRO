Add-Type -AssemblyName System.IO.Compression.FileSystem

$zipPath = "D:\SERVER_RO\PARA CLIENTE PRE-RENEWAL\System\itemInfo.zip"
$targetDir = "d:\SERVER_RO\LevitationRO\scratch\extracted_backup"

if (Test-Path $targetDir) {
    Remove-Item -Path $targetDir -Recurse -Force
}
New-Item -ItemType Directory -Path $targetDir | Out-Null

[System.IO.Compression.ZipFile]::ExtractToDirectory($zipPath, $targetDir)

$extracted = Join-Path $targetDir "itemInfo.lua"
if (Test-Path $extracted) {
    $bytes = [System.IO.File]::ReadAllBytes($extracted)
    Write-Host "Extracted itemInfo.lua size: $($bytes.Length) bytes"
    
    # Check encoding BOM
    if ($bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF) {
        Write-Host "Encoding: UTF-8 with BOM"
    } else {
        Write-Host "Encoding: Raw / ANSI / EUC-KR (No BOM)"
    }
}
