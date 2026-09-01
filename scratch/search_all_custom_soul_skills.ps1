$dbPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\skill_db.yml"

Select-String -Path $dbPath -Pattern "Id:\s*10[3-9][0-9]" -Context 0,4 | ForEach-Object {
    Write-Host "$($_.Line) | $($_.Context.PostContext[0]) | $($_.Context.PostContext[1])"
}
