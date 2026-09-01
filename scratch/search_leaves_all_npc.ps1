Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Write-Host "=== Searching for @leaves or leaves in all npc files ==="
Select-String -Path "*.txt","**/*.txt" -Pattern "@leaves|leaves|@snow|@sakura" -Context 2,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
