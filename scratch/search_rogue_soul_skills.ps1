$dbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\skill_db.yml"

Select-String -Path $dbPath -Pattern "Id:\s*106[0-9]" -Context 0,6 | ForEach-Object {
    Write-Host $_.Line
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
