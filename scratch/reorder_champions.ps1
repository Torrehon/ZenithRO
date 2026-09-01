# Parse mob_db_champions.yml to map Mob ID -> Base Monster Name (using AegisName)
$ymlPath = "d:\SERVER_RO\LevitationRO\rathena\db\pre-re\mob_db_champions.yml"
$ymlLines = Get-Content $ymlPath

$idToBaseName = @{}
$currentId = $null

foreach ($line in $ymlLines) {
    if ($line -match '^\s*-\s*Id:\s*(\d+)') {
        $currentId = [int]$matches[1]
    } elseif ($currentId -ne $null -and $line -match '^\s*AegisName:\s*(.+)') {
        $aegis = $matches[1].Trim()
        # Remove C1_, C2_, C3_, C4_, C5_
        $base = $aegis -replace '^C[1-5]_', ''
        # Replace underscores with spaces and title case
        $baseFormatted = (Get-Culture).TextInfo.ToTitleCase($base.Replace('_', ' ').ToLower())
        $idToBaseName[$currentId] = $baseFormatted
        $currentId = $null
    }
}

# Read spawns
$spawnsPath = "d:\SERVER_RO\LevitationRO\rathena\npc\custom\custom_champion_spawns.txt"
$spawnLines = Get-Content $spawnsPath

$groupedSpawns = [ordered]@{}

foreach ($line in $spawnLines) {
    if ($line -match '^\s*([a-zA-Z0-9_]+,\d+,\d+)\s+monster\s+([^\t]+)\s+(\d+),(\d+),(\d+)') {
        $mobId = [int]$matches[3]
        $mobName = if ($idToBaseName.ContainsKey($mobId)) { $idToBaseName[$mobId] } else { "Mob ID $mobId" }
        
        if (-not $groupedSpawns.Contains($mobName)) {
            $groupedSpawns[$mobName] = @()
        }
        $groupedSpawns[$mobName] += $line
    }
}

# Sort keys alphabetically
$sortedNames = $groupedSpawns.Keys | Sort-Object

$output = @()
$output += "// =============================================================="
$output += "// CUSTOM CHAMPION MONSTER MAP SPAWNS (Grouped by Base Monster)"
$output += "// =============================================================="
$output += "// Respawn time: 1 hour (3600000 ms)"
$output += "// =============================================================="
$output += ""

foreach ($name in $sortedNames) {
    $output += "// --- $name ---"
    foreach ($spawnLine in $groupedSpawns[$name]) {
        $output += $spawnLine
    }
    $output += ""
}

[System.IO.File]::WriteAllLines($spawnsPath, $output, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Reordered custom_champion_spawns.txt by Base Monster successfully!"
