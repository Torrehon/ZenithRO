$sqlPath = "d:\SERVER_RO\LevitationRO\rathena\sql-files\main.sql"

Select-String -Path $sqlPath -Pattern "`option" -Context 0,5 | ForEach-Object {
    Write-Host $_.Line
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
