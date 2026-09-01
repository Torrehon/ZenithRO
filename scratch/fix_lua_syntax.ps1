$path = "d:\SERVER_RO\LevitationRO\ZenithRO\SystemEN\itemInfo.lua"
$lines = Get-Content $path -Encoding UTF8

for ($i = 0; $i -lt $lines.Count; $i++) {
    # Fix costume line: "costume = false," or "costume = true," -> "costume = false" / "costume = true"
    if ($lines[$i] -match '^\s*costume\s*=\s*(true|false),?\s*$') {
        $val = $matches[1]
        $lines[$i] = "`t`tcostume = $val"
    }

    # Fix last element inside description array before closing brace "}," or "}"
    if ($i -lt $lines.Count - 1) {
        if ($lines[$i+1] -match '^\s*\},?\s*$' -and $lines[$i] -match '^\s*".*?",\s*$') {
            $lines[$i] = $lines[$i].TrimEnd().TrimEnd(',')
        }
    }
}

[System.IO.File]::WriteAllLines($path, $lines, (New-Object System.Text.UTF8Encoding $false))
Write-Host "Fixed Lua syntax in itemInfo.lua successfully!"
