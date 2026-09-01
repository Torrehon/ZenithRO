$soul1 = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\soul_quests_1.txt"

Write-Host "=== Searching F_EinherjarWeaponMenu and F_ValkyrieReroll ==="
Select-String -Path $soul1 -Pattern "function\s+script\s+F_EinherjarWeaponMenu|function\s+script\s+F_ValkyrieReroll|getitem2|setrandomoption" -Context 0,25 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
