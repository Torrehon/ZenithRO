$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"

Select-String -Path $soul1 -Pattern "F_EinherjarWeaponMenu|prt_prison|Star Fragment|Valkyrie" -Context 2,8 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
