Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map"

Get-ChildItem -Path "." -Recurse -Include "*.cpp","*.hpp" | ForEach-Object {
    $m = Select-String -Path $_.FullName -Pattern "BS_ADRENALINE"
    if ($m) {
        foreach ($match in $m) {
            Write-Host "$($_.FullName): Line $($match.LineNumber): $($match.Line)"
        }
    }
}
