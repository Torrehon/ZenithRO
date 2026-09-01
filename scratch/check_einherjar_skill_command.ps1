Set-Location -Path "d:\SERVER_RO\LevitationRO"

git show HEAD~2:rathena/npc/custom/soul_quests_1.txt | Select-String -Pattern "skill\s+104|skill\s+\.@sk" -Context 2,5
