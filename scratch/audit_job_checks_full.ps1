Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Auditing all custom NPC files for BaseJob / Job_ / F_Is2ndJob ==="

Get-ChildItem -Path "." -Filter "*.txt" | ForEach-Object {
    $file = $_.FullName
    $lines = Get-Content -Path $file
    for ($i = 0; $i -lt $lines.Length; $i++) {
        $line = $lines[$i]
        if ($line -match "BaseJob|Job_|F_Is2ndJob|Class ==" -and -not ($line -match "^\s*//")) {
            Write-Host "$($_.Name): Line $($i+1): $line"
        }
    }
}
