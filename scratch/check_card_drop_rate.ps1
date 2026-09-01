Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Inspecting card drop rates in battle config ==="
Select-String -Path "conf/battle/drops.conf" -Pattern "card" -Context 0,2

Write-Host "`n=== Inspecting card drop rate modifications in mob.cpp ==="
Select-String -Path "src/map/mob.cpp" -Pattern "200|2000|card|drop_card" -Context 2,2 | Select-Object -First 30

Write-Host "`n=== Inspecting @mi / @mobinfo in atcommand.cpp ==="
Select-String -Path "src/map/atcommand.cpp" -Pattern "atcommand_mobinfo|card|200" -Context 2,2 | Select-Object -First 30
