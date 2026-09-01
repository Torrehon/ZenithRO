$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

Write-Host "=== Inspecting Chunin Einherjar in soul_quests_expanded.txt ==="
git show HEAD:rathena/npc/custom/soul_quests_expanded.txt | Select-String -Pattern "Soul of|\.@soul_name|switch\(select" -Context 2,5
