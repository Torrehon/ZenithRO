Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\db"

$ymlFiles = Get-ChildItem -Recurse -Include "*.yml"

foreach ($f in $ymlFiles) {
    $matches = Select-String -Path $f.FullName -Pattern "Job_Genin|Job_Hiregun"
    foreach ($m in $matches) {
        Write-Host "Found in $($f.FullName) Line $($m.LineNumber): $($m.Line)"
    }
}
