Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for mob skill conditions in mob.cpp ==="
Select-String -Path "src\map\mob.cpp" -Pattern "MSC_|targetjob|aroundbefore|targetstatus|myhpltmaxrate" -Context 0,2 | Select-Object -First 30 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}

Write-Host "`n=== Searching doc/ for mob_skill_db ==="
Get-ChildItem -Path "doc" -Recurse -Filter "*mob*skill*" | ForEach-Object { Write-Host $_.FullName }
