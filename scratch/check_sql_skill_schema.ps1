$sqlPath = "d:\SERVER_RO\LevitationRO\rathena\sql-files\main.sql"
Select-String -Path $sqlPath -Pattern "CREATE TABLE.*skill" -Context 0,10 | ForEach-Object {
    Write-Host $_.Line
    $_.Context.PostContext | ForEach-Object { Write-Host $_ }
}
