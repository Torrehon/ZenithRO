Set-Location -Path "d:\SERVER_RO\LevitationRO"

git log -p -n 5 -- rathena/npc/custom/soul_quests_1.txt | Select-String -Pattern "Soul of|\.@soul_name"
