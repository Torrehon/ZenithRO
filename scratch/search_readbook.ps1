Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena"

Write-Host "--- Searching for readbook in rathena ---"
Get-ChildItem -Path "." -Recurse -Include "*.yml","*.txt","*.conf" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "readbook"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
