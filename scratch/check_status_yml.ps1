Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

Write-Host "=== Searching pre-re/status.yml for POISON_MIST or 752 ==="
Select-String -Path "pre-re\status.yml" -Pattern "POISON_MIST|752" -Context 2,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
