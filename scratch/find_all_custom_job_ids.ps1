Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for custom job IDs in src/ and db/ ==="
Select-String -Path "src\map\pc.hpp","src\config\classes.hpp","db\job_db.yml","db\pre-re\job_db.yml" -Pattern "4501|4502|JOB_GENIN|JOB_HIREGUN" -Context 0,5 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
