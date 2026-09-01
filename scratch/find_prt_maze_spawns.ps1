Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc"

$matches = Get-ChildItem -Recurse -Include "*prt_maze*"

foreach ($m in $matches) {
    Write-Host "Found file: $($m.FullName)"
}

Write-Host "Searching for prt_maze01 in all npc files..."
Select-String -Path "*.txt","*\*.txt","*\*\*.txt","*\*\*\*.txt" -Pattern "prt_maze01" | Select-Object -First 10 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
