$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$lines = Get-Content $path -Encoding UTF8

$inDesc = $false

for ($i = 0; $i -lt $lines.Count; $i++) {
    $line = $lines[$i]
    if ($line -match '(unidentifiedDescriptionName|identifiedDescriptionName)\s*=\s*\{') {
        $inDesc = $true
        continue
    }
    if ($inDesc) {
        if ($line -match '^\s*\},?') {
            $inDesc = $false
            continue
        }
        # If line ends with double quote and no comma
        if ($line -match '^\s*".*?"\s*$') {
            $lines[$i] = $line.TrimEnd() + ","
        }
    }
}

[System.IO.File]::WriteAllLines($path, $lines, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Fixed description commas in itemInfo.lua successfully!"
