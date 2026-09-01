Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Get-ChildItem -Path "." -Filter "*.txt" | ForEach-Object {
    Write-Host "=== File: $($_.Name) ==="
    $lines = Get-Content -Path $_.FullName
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "BaseJob|Job_|F_Is2ndJob|Class ==" -and -not ($lines[$i] -match "//")) {
            Write-Host "Line $($i+1): $($lines[$i])"
        }
    }
}
