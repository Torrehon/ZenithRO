Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Write-Host "=== All matches for IT_CARD in src/map/mob.cpp, atcommand.cpp, clif.cpp ==="
Select-String -Path "mob.cpp","atcommand.cpp","clif.cpp" -Pattern "IT_CARD" -Context 3,3 | ForEach-Object {
    Write-Host "`n--- File: $($_.Path) Line: $($_.LineNumber) ---"
    $_.Context.PreContext | ForEach-Object { Write-Host "  PR: $_" }
    Write-Host "  >> $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host "  PO: $_" }
}
