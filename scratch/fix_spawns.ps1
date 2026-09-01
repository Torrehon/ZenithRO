$filePath = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\custom_champion_spawns.txt"
$lines = Get-Content $filePath
$updatedLines = @()

foreach ($line in $lines) {
    if ($line.StartsWith("//") -or -not ($line.Contains("`tmonster`t"))) {
        $updatedLines += $line
    } else {
        $parts = $line.Split("`t")
        if ($parts.Count -ge 4) {
            $parts[2] = "--en--"
            $updatedLines += ($parts -join "`t")
        } else {
            $updatedLines += $line
        }
    }
}

[System.IO.File]::WriteAllLines($filePath, $updatedLines, (New-Object System.Text.UTF8Encoding $false))
Write-Host "File custom_champion_spawns.txt updated successfully!"
