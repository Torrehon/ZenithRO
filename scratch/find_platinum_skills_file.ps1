Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

Get-ChildItem -Path "." -Recurse -Include "*plat*.txt" | ForEach-Object {
    Write-Host $_.FullName
}
