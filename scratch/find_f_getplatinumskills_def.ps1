Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\npc" -Recurse -Filter "*.txt" | ForEach-Object {
    $lines = Get-Content -Path $_.FullName
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "function\s+script\s+F_GetPlatinumSkills") {
            Write-Host "Found in $($_.FullName) at line $($i+1)"
        }
    }
}
