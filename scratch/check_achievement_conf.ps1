Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\conf"

Get-ChildItem -Path "." -Recurse -Include "*.conf" | ForEach-Object {
    $matches = Select-String -Path $_.FullName -Pattern "achievement"
    if ($matches) {
        foreach ($m in $matches) {
            Write-Host "$($_.FullName): Line $($m.LineNumber): $($m.Line)"
        }
    }
}
