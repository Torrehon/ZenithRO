Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db\pre-re"

Write-Host "=== Searching mob_db.yml for Zombie Guard, Fallen Crusader, Lost Knight ==="
$mobs = @("Zombie Guard", "Fallen Crusader", "Lost Knight")
foreach ($m in $mobs) {
    Select-String -Path "mob_db.yml" -Pattern "Name: $m" -Context 2,0 | ForEach-Object {
        Write-Host "$($_.Context.PreContext)"
        Write-Host "$($_.Line)"
    }
}
