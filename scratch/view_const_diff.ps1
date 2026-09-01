Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

git diff db/const.txt | ForEach-Object { Write-Host $_ }
