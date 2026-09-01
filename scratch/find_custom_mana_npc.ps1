Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Listing custom script files ==="
Get-ChildItem -Path "." -Recurse -Filter "*.txt" | ForEach-Object { Write-Host $_.FullName }

Write-Host "`n=== Searching for leaves in custom scripts ==="
Select-String -Path "*.txt","**/*.txt" -Pattern "leaves|rate|exp" | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
