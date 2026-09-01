Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching db/ for POISON_MIST in status_change_db.yml ==="
Select-String -Path "pre-re\status_change_db.yml","re\status_change_db.yml" -Pattern "POISON_MIST" -Context 2,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
