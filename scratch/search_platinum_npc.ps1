Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Searching for bioeth in custom scripts ==="
Select-String -Path "*.txt","**/*.txt" -Pattern "bioeth|AM_BIOETHICS|238" -Context 1,3 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
