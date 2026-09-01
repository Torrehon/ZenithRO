Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching for status files in db ==="
Get-ChildItem -Recurse -Filter "*status*" | ForEach-Object { Write-Host $_.FullName }
