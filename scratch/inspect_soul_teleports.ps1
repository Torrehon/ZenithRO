$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"
$soulexp = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_expanded.txt"

Write-Host "=== Inspecting warps / teleports / pantheon / prison in soul_quests_1.txt ==="
Select-String -Path $soul1 -Pattern "warp|teleport|pantheon|prison|prt_prison|SOUL_QUEST|checkquest|9000" -Context 1,5 | Select-Object -First 40 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
