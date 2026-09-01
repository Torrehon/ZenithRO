$dbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\skill_db.yml"

$ids = @(1013, 3001, 1028, 1029, 1026, 1025)

foreach ($id in $ids) {
    Write-Host "=== Skill ID $id ==="
    Select-String -Path $dbPath -Pattern "Id:\s*$id\b" -Context 0,8 | ForEach-Object {
        Write-Host $_.Line
        $_.Context.PostContext | ForEach-Object { Write-Host $_ }
    }
}
