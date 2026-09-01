Set-Location -Path "d:\SERVER_RO\LevitationRO"

Write-Host "=== Original Soul Names in soul_quests_1.txt ==="
git show HEAD~1:rathena/npc/custom/soul_quests_1.txt | Select-String -Pattern "\.@soul_name\s*=" -Context 0,2

Write-Host "`n=== Original Soul Names in soul_quests_expanded.txt ==="
git show HEAD~1:rathena/npc/custom/soul_quests_expanded.txt | Select-String -Pattern "\.@soul_name\s*=" -Context 0,2
