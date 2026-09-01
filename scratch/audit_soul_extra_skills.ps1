Set-Location -Path "d:\SERVER_RO\LevitationRO"

Write-Host "=== Inspecting all skill grants in original soul_quests_1.txt ==="
git show HEAD~3:rathena/npc/custom/soul_quests_1.txt | Select-String -Pattern "skill\s+\d+|skill\s+\.@sk|addskill" -Context 0,2

Write-Host "`n=== Inspecting all skill grants in original soul_quests_expanded.txt ==="
git show HEAD~3:rathena/npc/custom/soul_quests_expanded.txt | Select-String -Pattern "skill\s+\d+|skill\s+\.@sk|addskill" -Context 0,2
