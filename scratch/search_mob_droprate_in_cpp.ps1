Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== Searching for mob_getdroprate definition in mob.cpp ==="
Select-String -Path "mob.cpp","mob.h" -Pattern "mob_getdroprate" -Context 2,15 | ForEach-Object {
    Write-Host "File $($_.Path) Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}

Write-Host "`n=== Searching for card rate calculations in atcommand.cpp (atcommand_mobinfo) ==="
Select-String -Path "atcommand.cpp" -Pattern "mobinfo|whodrops|drop_rate|mob_getdroprate" -Context 1,10 | Select-Object -First 20 | ForEach-Object {
    Write-Host "File $($_.Path) Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
