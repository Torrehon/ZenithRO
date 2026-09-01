Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\src\map\skills\merchant"

Get-ChildItem -Path "." -Filter "*.cpp" | ForEach-Object {
    $lines = Get-Content -Path $_.FullName
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "BS_ADRENALINE|SC_ADRENALINE|homun|hd") {
            Write-Host "$($_.Name): Line $($i+1): $($lines[$i])"
        }
    }
}
