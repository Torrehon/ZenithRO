Set-Location -Path "C:\xampp\mysql\bin"

Write-Host "=== Running myisamchk on skill.MYI ==="
if (Test-Path ".\myisamchk.exe") {
    .\myisamchk.exe -r "C:\xampp\mysql\data\rathena\skill.MYI"
} else {
    Write-Host "myisamchk.exe not found in C:\xampp\mysql\bin"
}
