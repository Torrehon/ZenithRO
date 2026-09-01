Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching skill_db.yml for ICEWALL ==="
Select-String -Path "db\pre-re\skill_db.yml" -Pattern "ICEWALL" -Context 2,25 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
