$path = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\produce_db.txt"
Get-Content -Path $path -Head 35 | ForEach-Object { Write-Host $_ }
