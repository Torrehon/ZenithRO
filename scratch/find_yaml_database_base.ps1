Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "=== Searching for YamlDatabase in src/ ==="
Select-String -Path "src\custom\*.hpp","src\custom\*.cpp","src\common\*.hpp","src\common\*.cpp" -Pattern "YamlDatabase|TypesafeYamlDatabase" -Context 0,2 | Select-Object -First 10 | ForEach-Object {
    Write-Host "$($_.Path): Line $($_.LineNumber): $($_.Line)"
}
