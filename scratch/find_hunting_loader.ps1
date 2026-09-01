$files = Get-ChildItem -Path "d:\SERVER_RO\LevitationRO\rathena\npc" -Recurse | Where-Object { $_.Extension -eq ".txt" -or $_.Extension -eq ".conf" }

foreach ($f in $files) {
    $text = Get-Content -Path $f.FullName -Raw
    if ($text -match "hunting_prontera\.txt") {
        Write-Host "Found hunting_prontera.txt reference in $($f.FullName)"
    }
}
