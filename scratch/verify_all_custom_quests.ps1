Set-Location -Path "d:\SERVER_RO\LevitationRO\rathena\npc\custom"

Write-Host "=== Verification of Job Checks in Custom NPC files ==="

Get-ChildItem -Path "." -Filter "*.txt" | ForEach-Object {
    $lines = Get-Content -Path $_.FullName
    $file = $_.Name
    for ($i = 0; $i -lt $lines.Length; $i++) {
        if ($lines[$i] -match "F_Is2ndJob|BaseJob !=|BaseJob ==") {
            Write-Host "$file : Line $($i+1) : $($lines[$i])"
        }
    }
}
