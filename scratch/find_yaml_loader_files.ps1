Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for yaml database loader files in src/ ==="
Get-ChildItem -Recurse -Path "src" -Filter "*yaml*" | ForEach-Object { Write-Host $_.FullName }
