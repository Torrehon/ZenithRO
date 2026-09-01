Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching re/status.yml for POISON_MIST ==="
Select-String -Path "re\status.yml" -Pattern "POISON_MIST" -Context 2,15 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
